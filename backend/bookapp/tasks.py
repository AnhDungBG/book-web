from celery import shared_task
from django.utils import timezone
from oauth2_provider.models import AccessToken, RefreshToken
from bookapp.models.khuyenmai import KhuyenMai
from bookapp.models.user import EmailVerification, LichSuMuon, KhachHang
from datetime import timedelta
from notifications.utils import send_notification_email
from notifications.models import ThongBao, LoaiThongBao

@shared_task
def xoa_khuyenmai_hethan():
    now = timezone.now().date()
    expired_promotions = KhuyenMai.objects.filter(denngay__lt=now)
    deleted_count, _ = expired_promotions.delete()
    print(f"{deleted_count} khuyến mại hết hạn đã bị xóa.")

@shared_task
def xoa_token_hethan():
    now = timezone.now()
    # Xóa Access Token hết hạn
    access_deleted = AccessToken.objects.filter(expires__lt=now).delete()[0]
    # Xóa Refresh Token hết hạn
    refresh_deleted = RefreshToken.objects.filter(access_token__expires__lt=now).delete()[0]
    print(f"{access_deleted} Access Token và {refresh_deleted} Refresh Token hết hạn đã bị xóa.")

@shared_task
def xoa_email_verification_cu():
    # Xóa các bản ghi EmailVerification cũ hơn 24 giờ
    thoi_gian_gioi_han = timezone.now() - timedelta(hours=1)
    email_verifications_cu = EmailVerification.objects.filter(otp_created_at__lt=thoi_gian_gioi_han)
    so_luong_xoa = email_verifications_cu.count()
    email_verifications_cu.delete()
    print(f"Đã xóa {so_luong_xoa} bản ghi EmailVerification cũ.")

@shared_task
def gui_thong_bao_tra_sach():
    ngay_hien_tai = timezone.now().date()
    ngay_sap_den_han = ngay_hien_tai + timedelta(days=3)  # Thông báo trước 3 ngày
    
    # Kiểm tra và tạo LoaiThongBao nếu chưa tồn tại
    loai_thong_bao, created = LoaiThongBao.objects.get_or_create(
        tieude="Thông báo sắp đến hạn trả sách"
    )
    
    lich_su_muon_sap_den_han = LichSuMuon.objects.filter(ngaytra=ngay_sap_den_han)
    
    for lich_su in lich_su_muon_sap_den_han:
        khach_hang = lich_su.khachhang
        san_pham = lich_su.sanpham
        
        subject = '[BookWebsite] Nhắc nhở: Sách sắp đến hạn trả'
        message = f'''
        Xin chào {khach_hang.hoten},

        Chúng tôi xin nhắc nhở bạn rằng cuốn sách "{san_pham.ten}" mà bạn đã mượn sẽ đến hạn trả vào ngày {lich_su.ngaytra}.

        Vui lòng trả sách đúng hạn để tránh phí phạt.

        Trân trọng,
        Đội ngũ BookWebsite
        '''
        
        try:
            send_notification_email(khach_hang.email, subject, message)
            
            # Tạo ThongBao
            ThongBao.objects.create(
                khachhang=khach_hang,
                sanpham=san_pham,
                ngaythongbao=timezone.now(),
                loaithongbao=loai_thong_bao,
                loinhan=message
            )
        except Exception as e:
            print(f"Lỗi gửi email cho {khach_hang.email}: {str(e)}")
    
    print(f"Đã gửi {lich_su_muon_sap_den_han.count()} email nhắc nhở trả sách.")

@shared_task
def gui_thong_bao_qua_han_tra_sach():
    ngay_hien_tai = timezone.now().date()

    # Kiểm tra và tạo LoaiThongBao nếu chưa tồn tại
    loai_thong_bao, created = LoaiThongBao.objects.get_or_create(
        tieude="Thông báo quá hạn trả sách"
    )
    
    lich_su_muon_qua_han = LichSuMuon.objects.filter(ngaytra__lt=ngay_hien_tai)
    
    for lich_su in lich_su_muon_qua_han:
        khach_hang = lich_su.khachhang
        san_pham = lich_su.sanpham
        
        subject = '[BookWebsite] Thông báo: Sách đã quá hạn trả'
        message = f'''
        Xin chào {khach_hang.hoten},

        Chúng tôi lưu ý rằng cuốn sách "{san_pham.ten}" mà bạn đã mượn đã quá hạn trả. Ngày trả dự kiến là {lich_su.ngaytra}, nhưng hiện tại đã là {ngay_hien_tai}.

        Vui lòng trả sách càng sớm càng tốt để tránh phí phạt tăng thêm.

        Nếu bạn đã trả sách, xin hãy bỏ qua thông báo này và liên hệ với chúng tôi để cập nhật thông tin.

        Trân trọng,
        Đội ngũ BookWebsite
        '''
        
        try:
            send_notification_email(khach_hang.email, subject, message)

            # Tạo ThongBao
            ThongBao.objects.create(
                khachhang=khach_hang,
                sanpham=san_pham,
                ngaythongbao=timezone.now(),
                loaithongbao=loai_thong_bao,
                loinhan=message
            )
        except Exception as e:
            print(f"Lỗi gửi email cho {khach_hang.email}: {str(e)}")
    
    print(f"Đã gửi {lich_su_muon_qua_han.count()} email thông báo quá hạn trả sách.")