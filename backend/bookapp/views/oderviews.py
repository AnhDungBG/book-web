from rest_framework import viewsets, generics, status, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet
from datetime import date
from django.utils import timezone
from bookapp.config import CustomPagination
from bookapp.models.oder import YeuCauMua, YeuCauMuon, DonHang
from bookapp.models.product import SanPham
from bookapp.models.user import KhachHang, HinhThucThanhToan, LichSuMua, LichSuMuon
from bookapp.serializers import DonHangSerializer, YeuCauMuaSerializer, YeuCauMuonSerializer
from django.db.models import Sum, Q

from notifications.models import ThongBao, LoaiThongBao
from notifications.utils import send_notification_email


# Create your views here.
class YeuCauMuaViewSet(viewsets.ViewSet,
                     generics.RetrieveAPIView,
                     generics.ListAPIView):
    queryset = YeuCauMua.objects.filter(active=True)
    serializer_class = YeuCauMuaSerializer
    permission_classes = [permissions.IsAuthenticated]
    pagination_class = CustomPagination

    def get_queryset(self):
        # Chỉ lấy các yêu cầu mua của khách hàng đang đăng nhập và có active=True
        return YeuCauMua.objects.filter(khachhang=self.request.user, active=True).order_by('id')

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        if not queryset.exists():
            return Response({"error": "Bạn không có yêu cầu nào."}, status=status.HTTP_404_NOT_FOUND)

        # Nếu có dữ liệu, sử dụng phương thức gốc để trả về kết quả
        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_paginated_response(self.get_serializer(page, many=True).data)
        else:
            serializer = self.get_serializer(queryset, many=True)

        return Response(serializer.data)

    @action(detail=False, methods=['post'], url_path='create')
    def create_request_mua(self, request):
        sanpham_id = request.data.get('sanpham_id')
        soluong = request.data.get('soluong')
        httt_id = request.data.get('httt_id')

        # Kiểm tra nếu thiếu thông tin
        if not (sanpham_id and soluong and httt_id):
            return Response({"error": "Vui lòng cung cấp đủ thông tin."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            khachhang = request.user
            sanpham = SanPham.objects.get(id=sanpham_id)

            # Kiểm tra sản phẩm có active hay không
            if not sanpham.active:
                return Response({"error": "Sản phẩm chưa mở bán."}, status=status.HTTP_400_BAD_REQUEST)

            httt = HinhThucThanhToan.objects.get(id=httt_id)

            # Lấy thông tin khuyến mãi nếu có
            # khuyenmai = getattr(sanpham.khuyenmai, 'khuyenmai', 0)
            khuyenmai = 0
            if sanpham.khuyenmai and sanpham.khuyenmai.loaikhuyenmai in ["Mua","All"]:
                khuyenmai = sanpham.khuyenmai.khuyenmai
            dongia = (sanpham.giamua - (sanpham.giamua * khuyenmai)) * int(soluong)

            # Kiểm tra số lượng yêu cầu có hợp lệ không
            if int(soluong) > sanpham.soluong:
                return Response({"error": "Số lượng yêu cầu vượt quá số lượng sản phẩm có sẵn."},
                                status=status.HTTP_400_BAD_REQUEST)

            # Tạo yêu cầu mua
            yeucau = YeuCauMua(
                khachhang=khachhang,
                sanpham=sanpham,
                soluong=soluong,
                httt=httt,
                dienthoai=khachhang.dienthoai,
                noigiao=khachhang.diachi,
                dongia=dongia,
                active=True
            )
            yeucau.save()

            # Cập nhật số lượng sản phẩm sau khi có yêu cầu mua
            sanpham.soluong -= int(soluong)
            sanpham.save()

            # Kiểm tra và tạo LoaiThongBao nếu chưa tồn tại
            loai_thong_bao, created = LoaiThongBao.objects.get_or_create(
                tieude="Thông báo yêu cầu mua sách"
            )

            ThongBao.objects.create(
                khachhang=khachhang,
                sanpham=sanpham,
                ngaythongbao=timezone.now(),
                loaithongbao=loai_thong_bao,
                loinhan=f'''
                Xin chào {khachhang.hoten},
        
                Yêu cầu mua sách "{sanpham.ten}" với số lượng {soluong}, hình thức thanh toán {httt}.
                Đã được tạo thành công!
                
                BookWebsite
                '''
            )

            serializer = YeuCauMuaSerializer(yeucau)
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        except (SanPham.DoesNotExist, HinhThucThanhToan.DoesNotExist) as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=True, methods=['put'], url_path='huy')
    def huy_yeucau(self, request, pk=None):
        try:
            yeucau = YeuCauMua.objects.get(pk=pk, khachhang=request.user, active=True)

            sanpham = yeucau.sanpham
            sanpham.soluong += yeucau.soluong
            sanpham.save()

            yeucau.active = False
            yeucau.ghichu = "Khách huỷ yêu cầu"
            yeucau.save()

            LichSuMua.objects.create(
                khachhang=yeucau.khachhang,
                sanpham=yeucau.sanpham,
                httt=yeucau.httt,
                dienthoai=yeucau.dienthoai,
                soluong=yeucau.soluong,
                ngaydathang=yeucau.ngaydat,
                dongia=yeucau.dongia,
                noigiao=yeucau.noigiao,
                ghichu="Đơn hàng đã được huỷ",
            )

            # Kiểm tra và tạo LoaiThongBao nếu chưa tồn tại
            loai_thong_bao, created = LoaiThongBao.objects.get_or_create(
                tieude="Thông báo huỷ mượn sách"
            )

            ThongBao.objects.create(
                khachhang=yeucau.khachhang,
                sanpham=sanpham,
                ngaythongbao=timezone.now(),
                loaithongbao=loai_thong_bao,
                loinhan=f'''
                Xin chào {yeucau.khachhang.hoten},

                Yêu cầu mua "{sanpham.ten}" với số lượng {yeucau.soluong}, hình thức thanh toán {yeucau.httt}.
                Đã được huỷ thành công!

                BookWebsite
                '''
            )

            return Response({"message": "Yêu cầu mua đã được hủy thành công."}, status=status.HTTP_200_OK)

        except YeuCauMua.DoesNotExist:
            return Response({"error": "Yêu cầu mua không tồn tại hoặc bạn không có quyền hủy yêu cầu này."},
                            status=status.HTTP_404_NOT_FOUND)


class YeuCauMuonViewSet(viewsets.ViewSet,
                     generics.RetrieveAPIView,
                     generics.ListAPIView):
    queryset = YeuCauMuon.objects.filter(active=True)
    serializer_class = YeuCauMuonSerializer
    permission_classes = [permissions.IsAuthenticated]
    pagination_class = CustomPagination

    def get_queryset(self):
        # Chỉ lấy các yêu cầu muon của khách hàng đang đăng nhập
        return YeuCauMuon.objects.filter(khachhang=self.request.user, active=True).order_by('id')

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        if not queryset.exists():
            return Response({"error": "Bạn không có yêu cầu nào."}, status=status.HTTP_404_NOT_FOUND)

        # Nếu có dữ liệu, sử dụng phương thức gốc để trả về kết quả
        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_paginated_response(self.get_serializer(page, many=True).data)
        else:
            serializer = self.get_serializer(queryset, many=True)

        return Response(serializer.data)

    @action(detail=False, methods=['post'], url_path='create')
    def create_request_muon(self, request):

        sanpham_id = request.data.get('sanpham_id')
        soluong = request.data.get('soluong')
        httt_id = request.data.get('httt_id')
        ngaytra = request.data.get('ngaytra')

        if not (sanpham_id and soluong and httt_id):
            return Response({"error": "Vui lòng cung cấp đủ thông tin."}, status=status.HTTP_400_BAD_REQUEST)

        # Kiểm tra nếu ngày trả không lớn hơn ngày hiện tại
        if date.fromisoformat(ngaytra) <= date.today():
            return Response({"error": "Ngày trả phải lớn hơn ngày hiện tại."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            khachhang = request.user
            sanpham = SanPham.objects.get(id=sanpham_id)

            if not sanpham.active:
                return Response({"error": "Sản phẩm chưa mở bán."}, status=status.HTTP_400_BAD_REQUEST)

            httt = HinhThucThanhToan.objects.get(id=httt_id)
            khuyenmai = 0
            if sanpham.khuyenmai and sanpham.khuyenmai.loaikhuyenmai in ["Muon", "Mượn","All"]:
                khuyenmai = sanpham.khuyenmai.khuyenmai

            dongia = (sanpham.giamuon - (sanpham.giamuon * khuyenmai)) * int(soluong)

            if int(soluong) > sanpham.soluong:
                return Response({"error": "Số lượng yêu cầu vượt quá số lượng sản phẩm có sẵn."},
                                status=status.HTTP_400_BAD_REQUEST)

            yeucau = YeuCauMuon(
                khachhang=khachhang,
                sanpham=sanpham,
                soluong=soluong,
                httt=httt,
                dienthoai=khachhang.dienthoai,
                noigiao=khachhang.diachi,
                dongia=dongia,
                ngaytra=ngaytra,
                active=True
            )
            yeucau.save()

            sanpham.soluong -= soluong
            sanpham.save()

            # Kiểm tra và tạo LoaiThongBao nếu chưa tồn tại
            loai_thong_bao, created = LoaiThongBao.objects.get_or_create(
                tieude="Thông báo yêu cầu mượn sách"
            )

            ThongBao.objects.create(
                khachhang=khachhang,
                sanpham=sanpham,
                ngaythongbao=timezone.now(),
                loaithongbao=loai_thong_bao,
                loinhan=f'''
                Xin chào {khachhang.hoten},

                Yêu cầu mượn sách "{sanpham.ten}" với số lượng {soluong}, hình thức thanh toán {httt}.
                Đã được tạo thành công!

                BookWebsite
                '''
            )

            serializer = YeuCauMuonSerializer(yeucau)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        except (KhachHang.DoesNotExist, SanPham.DoesNotExist, HinhThucThanhToan.DoesNotExist) as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=True, methods=['put'], url_path='huy')
    def huy_yeucau(self, request, pk=None):
        try:
            yeucau = YeuCauMuon.objects.get(pk=pk, khachhang=request.user, active=True)
            sanpham = yeucau.sanpham
            sanpham.soluong += yeucau.soluong
            sanpham.save()
            
            yeucau.active = False
            yeucau.ghichu = "Khách huỷ yêu cầu"
            yeucau.save()

            LichSuMuon.objects.create(
                khachhang=yeucau.khachhang,
                sanpham=yeucau.sanpham,
                httt=yeucau.httt,
                dienthoai=yeucau.dienthoai,
                soluong=yeucau.soluong,
                ngaydathang=yeucau.ngaydat,
                dongia=yeucau.dongia,
                noigiao=yeucau.noigiao,
                ngaytra=yeucau.ngaytra,
                ghichu="Đơn hàng đã được huỷ",
            )

            # Kiểm tra và tạo LoaiThongBao nếu chưa tồn tại
            loai_thong_bao, created = LoaiThongBao.objects.get_or_create(
                tieude="Thông báo huỷ mượn sách"
            )

            ThongBao.objects.create(
                khachhang=yeucau.khachhang,
                sanpham=sanpham,
                ngaythongbao=timezone.now(),
                loaithongbao=loai_thong_bao,
                loinhan=f'''
                Xin chào {yeucau.khachhang.hoten},

                Yêu cầu mượn "{sanpham.ten}" với số lượng {yeucau.soluong}, hình thức thanh toán {yeucau.httt}.
                Đã được huỷ thành công!

                BookWebsite
                '''
            )

            return Response({"message": "Yêu cầu muợn đã được hủy thành công."}, status=status.HTTP_200_OK)

        except YeuCauMuon.DoesNotExist:
            return Response({"error": "Yêu cầu muợn không tồn tại hoặc bạn không có quyền hủy yêu cầu này."},
                            status=status.HTTP_404_NOT_FOUND)


class DonHangViewSet(viewsets.ViewSet,
                     generics.RetrieveAPIView,
                     generics.ListAPIView):
    queryset = DonHang.objects.all()
    serializer_class = DonHangSerializer
    permission_classes = [permissions.IsAuthenticated]
    pagination_class = CustomPagination

    def get_queryset(self):
        user = self.request.user
        return DonHang.objects.filter(
            Q(yeucaumua__khachhang=user) | Q(yeucaumuon__khachhang=user),
            xacnhandonhang=False
        ).order_by('id')

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        if not queryset.exists():
            return Response({"error": "Bạn không có đơn hàng nào."}, status=status.HTTP_404_NOT_FOUND)

        # Nếu có dữ liệu, sử dụng phương thức gốc để trả về kết quả
        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_paginated_response(self.get_serializer(page, many=True).data)
        else:
            serializer = self.get_serializer(queryset, many=True)

        return Response(serializer.data)

    @action(detail=False, methods=['post'], url_path='xacnhandonhang')
    def request_xacnhandonhang(self, request):
        donhang_id = request.data.get('donhang_id')

        try:
            donhang = DonHang.objects.get(id=donhang_id)

            if donhang.xacnhandonhang:
                return Response({"error": "Đơn hàng đã được xác nhận trước đó."}, status=status.HTTP_400_BAD_REQUEST)

            # Xác nhận đơn hàng
            donhang.xacnhandonhang = True
            donhang.ghichu = "Đơn hàng đã được xác nhận"
            donhang.save()

            self._xu_ly_xac_nhan(donhang)
            self._gui_thong_bao(donhang)

            return Response({"message": "Đơn hàng đã được xác nhận và lịch sử đã được lưu thành công."}, status=status.HTTP_200_OK)

        except DonHang.DoesNotExist:
            return Response({"error": "Không tìm thấy đơn hàng."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def _xu_ly_xac_nhan(self, donhang):
        if donhang.yeucaumua:
            self._luu_lich_su_mua(donhang.yeucaumua)
        if donhang.yeucaumuon:
            self._luu_lich_su_muon(donhang.yeucaumuon)
        donhang.active = False
        donhang.save()

    def _luu_lich_su_mua(self, yeucaumua):
        LichSuMua.objects.create(
            khachhang=yeucaumua.khachhang,
            sanpham=yeucaumua.sanpham,
            httt=yeucaumua.httt,
            dienthoai=yeucaumua.dienthoai,
            soluong=yeucaumua.soluong,
            ngaydathang=yeucaumua.ngaydat,
            dongia=yeucaumua.dongia,
            noigiao=yeucaumua.noigiao,
            ghichu="Hoàn thành đơn hàng",
        )

    def _luu_lich_su_muon(self, yeucaumuon):
        LichSuMuon.objects.create(
            khachhang=yeucaumuon.khachhang,
            sanpham=yeucaumuon.sanpham,
            httt=yeucaumuon.httt,
            dienthoai=yeucaumuon.dienthoai,
            soluong=yeucaumuon.soluong,
            ngaydathang=yeucaumuon.ngaydat,
            dongia=yeucaumuon.dongia,
            noigiao=yeucaumuon.noigiao,
            ngaytra=yeucaumuon.ngaytra,
            ghichu="Hoàn thành đơn hàng",
        )

    def _gui_thong_bao(self, donhang):
        khachhang = donhang.yeucaumua.khachhang if donhang.yeucaumua else donhang.yeucaumuon.khachhang
        san_pham_info = self._lay_thong_tin_san_pham(donhang)

        self._gui_email(khachhang, san_pham_info, donhang)
        self._tao_thong_bao(khachhang, donhang)

    def _lay_thong_tin_san_pham(self, donhang):
        sanphammua = donhang.yeucaumua.sanpham.ten if donhang.yeucaumua else ""
        sanphammuon = donhang.yeucaumuon.sanpham.ten if donhang.yeucaumuon else ""
        return f"{sanphammua}, {sanphammuon}".strip()

    def _gui_email(self, khachhang, san_pham_info, donhang):
        subject = "[BookWebsite] Đơn Hàng Của Bạn Đã Được Xác Nhận!"
        message = (f"Xin chào {khachhang.hoten}. Đơn hàng {san_pham_info} của bạn đã được xác nhận! "
                   f"Đơn hàng của bạn sẽ được giao từ khoảng {donhang.ngaygiaotu} đến {donhang.ngaygiaoden}")
        send_notification_email(khachhang.email, subject, message)

    def _tao_thong_bao(self, khachhang, donhang):
        loai_thong_bao, _ = LoaiThongBao.objects.get_or_create(tieude="Thông báo đơn hàng")
        
        if donhang.yeucaumua:
            self._tao_thong_bao_mua(khachhang, donhang.yeucaumua, loai_thong_bao)
        if donhang.yeucaumuon:
            self._tao_thong_bao_muon(khachhang, donhang.yeucaumuon, loai_thong_bao)

    def _tao_thong_bao_mua(self, khachhang, yeucaumua, loai_thong_bao):
        ThongBao.objects.create(
            khachhang=khachhang,
            sanpham=yeucaumua.sanpham,
            ngaythongbao=timezone.now(),
            loaithongbao=loai_thong_bao,
            loinhan=f'''
            Xin chào {khachhang.hoten},
            
            Đơn hàng mua sách "{yeucaumua.sanpham.ten}" của bạn đã được xác nhận!
            
            BookWebsite
            '''
        )

    def _tao_thong_bao_muon(self, khachhang, yeucaumuon, loai_thong_bao):
        ThongBao.objects.create(
            khachhang=khachhang,
            sanpham=yeucaumuon.sanpham,
            ngaythongbao=timezone.now(),
            loaithongbao=loai_thong_bao,
            loinhan=f'''
            Xin chào {khachhang.hoten},
            
            Đơn hàng mượn sách "{yeucaumuon.sanpham.ten}" của bạn đã được xác nhận!
            
            BookWebsite
            '''
        )
