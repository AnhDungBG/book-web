from rest_framework import status
from rest_framework.response import Response
from bookapp.models.user import KhachHang, EmailVerification
from django.utils import timezone
from django.core.exceptions import ValidationError
from django.core.validators import validate_email

def gui_otp_email(email):

    if not email or email.strip() == "":
        return Response({"error": "Vui lòng cung cấp địa chỉ email"}, status=status.HTTP_400_BAD_REQUEST)
    try:
        validate_email(email)
    except ValidationError:
        return Response({"error": "Địa chỉ email không hợp lệ"}, status=status.HTTP_400_BAD_REQUEST)

    email_verification, created = EmailVerification.objects.get_or_create(email=email)

    # Kiểm tra số lần gửi OTP trong 1 giờ qua
    one_hour_ago = timezone.now() - timezone.timedelta(hours=1)
    if EmailVerification.objects.filter(email=email, otp_created_at__gte=one_hour_ago).count() >= 5:
        return Response({"error": "Bạn đã yêu cầu OTP quá nhiều lần. Vui lòng thử lại sau."},
                        status=status.HTTP_400_BAD_REQUEST)

    # Gửi OTP
    if email_verification.gui_otp_email():
        return Response({"message": "Mã OTP đã được gửi đến email của bạn"}, status=status.HTTP_200_OK)
    else:
        return Response({"error": "Không thể gửi email OTP"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)