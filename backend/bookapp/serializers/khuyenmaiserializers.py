from rest_framework.serializers import ModelSerializer

from bookapp.models.khuyenmai import KhuyenMai


class KhuyenMaiSerializer(ModelSerializer):
    class Meta:
        model = KhuyenMai
        fields = ["id","ten","khuyenmai","loaikhuyenmai","noidung","tungay","denngay"]