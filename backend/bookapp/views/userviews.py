from django.shortcuts import render
from rest_framework import viewsets, status, generics, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import api_view, permission_classes
from django.contrib.auth.models import AnonymousUser
from rest_framework.views import APIView
from oauth2_provider.models import AccessToken, RefreshToken
from bookapp.config import CustomPagination
from bookapp.models.product import SanPham
from bookapp.models.user import KhachHang, ChuDeGopY, GopY, YeuThich, LichSuMua, LichSuMuon, HinhThucThanhToan, EmailVerification
from bookapp.serializers import ChuDeGopYSerializer, GopYSerializer, YeuThichSerializer, LichSuMuaSerializer, \
    LichSuMuonSerializer, KhachHangSerializer, HinhThucThanhToanSerializer
from dateutil import parser
from datetime import date
from django.core.exceptions import ValidationError
from django.core.validators import validate_email
from django.db.models import Count
from bookapp.serializers.productserializers import SanPhamMiniSerializer
from bookapp.views.utilsviews import gui_otp_email

# Create your views here.
#get user = token
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def user_info(request):
    try:
        user = request.user
        if isinstance(user, AnonymousUser):
            return Response({"error": "Người dùng chưa đăng nhập"}, status=status.HTTP_401_UNAUTHORIZED)
        
        return Response({
            'id': user.id,
            'username': user.username,
            'hoten': user.hoten,
            'avatar': user.avatar.url if user.avatar else None,
        })
    except AttributeError:
        return Response({"error": "Không thể truy cập thông tin người dùng"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    except Exception as e:
        return Response({"error": f"Đã xảy ra lỗi: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            # Xóa tất cả Access Tokens của người dùng hiện tại
            AccessToken.objects.filter(user=request.user).delete()
            # Xóa tất cả Refresh Tokens của người dùng hiện tại
            RefreshToken.objects.filter(user=request.user).delete()

            return Response({"message": "Đăng xuất thành công"}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class KhachHangViewSet(viewsets.ViewSet,generics.RetrieveAPIView):
    queryset = KhachHang.objects.filter(is_active=True)
    serializer_class = KhachHangSerializer

    def get_permissions(self):
        if self.action in ['create']:
            return [permissions.AllowAny()]
        return [permissions.IsAuthenticated()]

    def get_queryset(self):
        return KhachHang.objects.filter(khachhang=self.request.user)

    #Change Password
    @action(methods=['put'], detail=False, url_path="change-password", url_name="change-password")
    def change_password(self, request):
        user = request.user
        old_password = request.data.get('old_password')
        new_password = request.data.get('new_password')
        confirm_password = request.data.get('confirm_password')

        if not user.check_password(old_password):
            return Response({"error": "Mật khẩu cũ không đúng"}, status=status.HTTP_400_BAD_REQUEST)

        if new_password != confirm_password:
            return Response({"error": "Mật khẩu mới và xác nhận mật khẩu không khớp"}, status=status.HTTP_400_BAD_REQUEST)

        user.set_password(new_password)
        user.save()
        return Response({"message": "Đổi mật khẩu thành công"}, status=status.HTTP_200_OK)


class ChuDeGopYViewSet(viewsets.ViewSet,
                       generics.RetrieveAPIView,
                       generics.ListAPIView
                       ):
    queryset = ChuDeGopY.objects.all().order_by('id')
    serializer_class = ChuDeGopYSerializer
    pagination_class = CustomPagination

    def get_permissions(self):
        if self.action in ['list', 'retrieve']:
            return [permissions.AllowAny()]
        return [permissions.IsAuthenticated()]

class GopYViewSet(viewsets.ViewSet):
    queryset = GopY.objects.all().order_by('id')
    serializer_class = GopYSerializer
    permission_classes = [permissions.IsAuthenticated]
    pagination_class = CustomPagination

    @action(detail=False, methods=['post'], url_path='create')
    def create_gopy(self, request):
        chude_id = request.data.get('chude_id')
        noidung = request.data.get('noidung')
        try:
            khachhang = request.user
            chude = ChuDeGopY.objects.get(id=chude_id)
            GopY.objects.create(
                khachhang=khachhang,
                chude=chude,
                noidung=noidung,
            )
            return Response({"message": "Cảm ơn bạn đã góp ý."},
                            status=status.HTTP_201_CREATED)
        except ChuDeGopY.DoesNotExist:
            return Response({"error": "Chủ đề góp ý không tồn tại."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": f"Có lỗi xảy ra: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class YeuThichViewSet(viewsets.ViewSet,
                  generics.RetrieveAPIView,
                  generics.ListAPIView,
                  generics.DestroyAPIView,
                  ):
    queryset = YeuThich.objects.all()
    serializer_class = YeuThichSerializer
    permission_classes = [permissions.IsAuthenticated]
    pagination_class = CustomPagination

    def get_queryset(self):
        return YeuThich.objects.filter(khachhang=self.request.user).order_by('id')

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()

        if instance.khachhang != request.user:
            return Response({"error": "Bạn không có quyền xóa."}, status=status.HTTP_403_FORBIDDEN)

        self.perform_destroy(instance)
        return Response({"message": "Đã xóa thành công."}, status=status.HTTP_200_OK)

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        if not queryset.exists():
            return Response({"error": "Bạn không có yêu thích nào."}, status=status.HTTP_404_NOT_FOUND)

        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_paginated_response(self.get_serializer(page, many=True).data)
        else:
            serializer = self.get_serializer(queryset, many=True)

        return Response(serializer.data)

    @action(detail=False, methods=['post'], url_path='add')
    def add_yeuthich(self, request):
        sanpham_id = request.data.get('sanpham_id')

        # Kiểm tra nếu không có thông tin sản phẩm
        if not sanpham_id:
            return Response({"error": "Vui lòng cung cấp ID sản phẩm."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            # Kiểm tra xem sản phẩm có tồn tại không
            sanpham = SanPham.objects.get(id=sanpham_id)

            # Kiểm tra xem sản phẩm đã được thêm vào danh sách yêu thích của khách hàng chưa
            existing_yeuthich = YeuThich.objects.filter(khachhang=request.user, sanpham=sanpham).exists()
            if existing_yeuthich:
                return Response({"error": "Sản phẩm này đã có trong danh sách yêu thích."},
                                status=status.HTTP_400_BAD_REQUEST)

            # Tạo yêu thích mới
            YeuThich.objects.create(
                khachhang=request.user,
                sanpham=sanpham
            )

            return Response({"message": "Sản phẩm đã được thêm vào danh sách yêu thích."},
                            status=status.HTTP_201_CREATED)

        except SanPham.DoesNotExist:
            return Response({"error": "Sản phẩm không tồn tại."}, status=status.HTTP_404_NOT_FOUND)

class HottestFavoriteProductsView(APIView):
    def get(self, request):
        san_pham_yeuthich = SanPham.objects.annotate(
            quantity=Count('yeuthich')
        ).order_by('-quantity')[:10]

        serializer = SanPhamMiniSerializer(san_pham_yeuthich, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class HinhThucThanhToanViewSet(viewsets.ViewSet,
                               generics.RetrieveAPIView,
                               generics.ListAPIView
                               ):
    queryset = HinhThucThanhToan.objects.filter(active=True).order_by('id')
    serializer_class = HinhThucThanhToanSerializer
    pagination_class = CustomPagination

    def get_permissions(self):
        if self.action in ['list', 'retrieve']:
            return [permissions.AllowAny()]
        return [permissions.IsAuthenticated()]


class LichSuMuaViewSet(viewsets.ViewSet,
                        generics.DestroyAPIView,
                        generics.RetrieveAPIView,
                        generics.ListAPIView
                        ):
    queryset = LichSuMua.objects.all()
    serializer_class = LichSuMuaSerializer
    permission_classes = [IsAuthenticated]
    pagination_class = CustomPagination

    def get_queryset(self):
        return LichSuMua.objects.filter(khachhang=self.request.user).order_by('id')

    def destroy(self, request, *args, **kwargs):
        # Lấy đối tượng yêu cầu mua cần xóa
        instance = self.get_object()

        # Kiểm tra xem người dùng hiện tại có phải là chủ sở hữu yêu cầu hay không
        if instance.khachhang != request.user:
            return Response({"error": "Bạn không có quyền xóa yêu cầu này."}, status=status.HTTP_403_FORBIDDEN)

        # Nếu đúng, tiếp tục xóa yêu cầu
        self.perform_destroy(instance)
        return Response({"message": "Lịch sử mua đã được xóa thành công."}, status=status.HTTP_200_OK)

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        if not queryset.exists():
            return Response({"error": "Bạn không có lịch sử nào."}, status=status.HTTP_404_NOT_FOUND)

        # Nếu có dữ liệu, sử dụng phương thức gốc để trả về kết quả
        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_paginated_response(self.get_serializer(page, many=True).data)
        else:
            serializer = self.get_serializer(queryset, many=True)

        return Response(serializer.data)


class LichSuMuonViewSet(viewsets.ViewSet,
                        generics.DestroyAPIView,
                        generics.RetrieveAPIView,
                        generics.ListAPIView
                        ):
    queryset = LichSuMuon.objects.all()
    serializer_class = LichSuMuonSerializer
    permission_classes = [permissions.IsAuthenticated]
    pagination_class = CustomPagination

    def get_queryset(self):
        return LichSuMuon.objects.filter(khachhang=self.request.user).order_by('id')

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()

        if instance.khachhang != request.user:
            return Response({"error": "Bạn không có quyền xóa yêu cầu này."}, status=status.HTTP_403_FORBIDDEN)

        self.perform_destroy(instance)
        return Response({"message": "Lịch sử mượn đã được xóa thành công."}, status=status.HTTP_200_OK)

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        if not queryset.exists():
            return Response({"error": "Bạn không có lịch sử nào."}, status=status.HTTP_404_NOT_FOUND)

        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_paginated_response(self.get_serializer(page, many=True).data)
        else:
            serializer = self.get_serializer(queryset, many=True)

        return Response(serializer.data)

class XacThucEmailView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        email = request.data.get('email')
        if KhachHang.objects.filter(email=email).exists():
            return Response({"error": "Email đã được sử dụng để đăng ký tài khoản"}, status=status.HTTP_400_BAD_REQUEST)
        return gui_otp_email(email)

class XacThucOTPView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        email = request.data.get('email')
        otp = request.data.get('otp')

        try:
            email_verification = EmailVerification.objects.get(email=email)
        except EmailVerification.DoesNotExist:
            return Response({"error": "Không tìm thấy yêu cầu xác thực cho email này"}, status=status.HTTP_400_BAD_REQUEST)

        success, message = email_verification.xac_thuc_otp(otp)
        if success:
            return Response({"message": message, "email": email})
        else:
            return Response({"error": message}, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request):
        email = request.data.get('email')
        try:
            email_verification = EmailVerification.objects.get(email=email)
        except EmailVerification.DoesNotExist:
            return Response({"error": "Không tìm thấy yêu cầu xác thực cho email này"}, status=status.HTTP_400_BAD_REQUEST)

        if email_verification.gui_otp_email():
            return Response({"message": "OTP mới đã được gửi đến email của bạn"})
        else:
            return Response({"error": "Không thể gửi email OTP mới"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class DangKyView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        email = request.data.get('email')
        username = request.data.get('username')
        password = request.data.get('password')
        hoten = request.data.get('hoten')
        gioitinh = request.data.get('gioitinh')
        diachi = request.data.get('diachi')
        dienthoai = request.data.get('dienthoai')
        ngaysinh_str = request.data.get('ngaysinh')
        cmnd = request.data.get('cmnd')

        try:
            email_verification = EmailVerification.objects.get(email=email, is_verified=True)
        except EmailVerification.DoesNotExist:
            return Response({"error": "Email chưa được xác thực"}, status=status.HTTP_400_BAD_REQUEST)

        if KhachHang.objects.filter(username=username).exists():
            return Response({"error": "Tên đăng nhập đã tồn tại"}, status=status.HTTP_400_BAD_REQUEST)

        if dienthoai and KhachHang.objects.filter(dienthoai=dienthoai).exists():
            return Response({"error": "Số điện thoại đã tồn tại"}, status=status.HTTP_400_BAD_REQUEST)

        if cmnd and KhachHang.objects.filter(cmnd=cmnd).exists():
            return Response({"error": "CMND/CCCD đã tồn tại"}, status=status.HTTP_400_BAD_REQUEST)

        ngaysinh = None
        if ngaysinh_str:
            try:
                ngaysinh = parser.parse(ngaysinh_str).date()
                if ngaysinh > date.today():
                    return Response({"error": "Ngày sinh không thể là ngày trong tương lai"}, status=status.HTTP_400_BAD_REQUEST)
            except ValueError:
                return Response({"error": "Định dạng ngày sinh không hợp lệ"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            khach_hang = KhachHang.objects.create_user(
                username=username, 
                email=email, 
                password=password,
                hoten=hoten,
                gioitinh=gioitinh,
                diachi=diachi,
                dienthoai=dienthoai,
                ngaysinh=ngaysinh,
                cmnd=cmnd,
                is_active=True,
                email_xac_thuc=True
            )
            email_verification.delete()
            return Response({"message": "Đăng ký tài khoản thành công"}, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

class ForgotPassword(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        action = request.data.get('action')
        if action == 'check-user':
            return self.UserIfExists(request)
        elif action == 'check-email':
            return self.EmailIfExists(request)
        elif action == 'send_otp':
            return self.send_otp(request)
        return Response({"error": "Hành động không hợp lệ"}, status=status.HTTP_400_BAD_REQUEST)

    def UserIfExists(self, request):
        username = request.data.get('username')
        
        if not username:
            return Response({"error": "Vui lòng cung cấp tên đăng nhập"}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            user = KhachHang.objects.get(username=username)
            email = user.email
            # Chỉnh sửa cách hiển thị email
            email_parts = email.split('@')
            masked_email = f"{email_parts[0][:2]}{'*' * (len(email_parts[0]) - 2)}{email_parts[0][-3:]}@{email_parts[1]}"
            return Response({"message": "Tài khoản tồn tại", "email": masked_email}, status=status.HTTP_200_OK)
        except KhachHang.DoesNotExist:
            return Response({"error": "Tài khoản không tồn tại"}, status=status.HTTP_404_NOT_FOUND)

    def EmailIfExists(self, request):
        username = request.data.get('username')
        email = request.data.get('email')

        if not email or email.strip() == "":
            return Response({"error": "Vui lòng cung cấp địa chỉ email"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            validate_email(email)
        except ValidationError:
            return Response({"error": "Địa chỉ email không hợp lệ"}, status=status.HTTP_400_BAD_REQUEST)

        user = KhachHang.objects.get(username=username)
        if user.email != email:
            return Response({"error": "Email không khớp với email của người dùng"},
                            status=status.HTTP_400_BAD_REQUEST)

        if KhachHang.objects.filter(email=email).exists():
            return Response({"message": "xác thực email có tồn tại"}, status=status.HTTP_200_OK)
        else:
            return Response({"error": "Email không tồn tại"}, status=status.HTTP_404_NOT_FOUND)

    def send_otp(self, request):
        username = request.data.get('username')
        email = request.data.get('email')

        user = KhachHang.objects.get(username=username)
        if user.email != email:
            return Response({"error": "Email không khớp với email của người dùng"},
                            status=status.HTTP_400_BAD_REQUEST)

        return gui_otp_email(email)

    def put(self, request):
        username = request.data.get('username')
        email = request.data.get('email')
        otp = request.data.get('otp')
        new_password = request.data.get('new_password')
        confirm_new_password = request.data.get('confirm_new_password')

        if not new_password or not confirm_new_password:
            return Response({"error": "Vui lòng cung cấp mật khẩu mới và xác nhận mật khẩu mới"}, status=status.HTTP_400_BAD_REQUEST)

        if new_password != confirm_new_password:
            return Response({"error": "Mật khẩu mới và xác nhận mật khẩu mới không khớp"}, status=status.HTTP_400_BAD_REQUEST)

        user = KhachHang.objects.get(username=username)
        if user.email != email:
            return Response({"error": "Email không khớp với email của người dùng"},
                            status=status.HTTP_400_BAD_REQUEST)

        try:
            email_verification = EmailVerification.objects.get(email=email)
        except EmailVerification.DoesNotExist:
            return Response({"error": "Không tìm thấy yêu cầu xác thực cho email này"}, status=status.HTTP_400_BAD_REQUEST)

        success, message = email_verification.xac_thuc_otp(otp)
        if success:
            user.set_password(new_password)
            user.save()
            email_verification.delete()
            return Response({"message": "Mật khẩu đã được thay đổi thành công"}, status=status.HTTP_200_OK)
        else:
            return Response({"error": message}, status=status.HTTP_400_BAD_REQUEST)
