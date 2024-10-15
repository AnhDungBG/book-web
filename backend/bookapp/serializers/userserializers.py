from dataclasses import fields

from rest_framework.serializers import ModelSerializer

from bookapp.models.user import KhachHang, ChuDeGopY, GopY, YeuThich, HinhThucThanhToan, LichSuMuon, LichSuMua
from bookapp.serializers.productserializers import SanPhamSerializer, SanPhamMiniSerializer


class KhachHangMiniSerializer(ModelSerializer):
    class Meta:
        model = KhachHang
        fields = ['id', 'hoten']


class KhachHangSerializer(ModelSerializer):
    class Meta:
        model = KhachHang
        fields = ["id", "username", "password","email", "hoten", "gioitinh", "diachi", "dienthoai","ngaysinh", "cmnd","avatar","otp"]
        extra_kwargs = {
            'password': {'write_only': True},
            'otp': {'write_only': True}
        }

    def create(self, validated_data):
        khachhang = KhachHang(**validated_data)
        khachhang.set_password(validated_data['password'])
        khachhang.save()
        return khachhang


class ChuDeGopYSerializer(ModelSerializer):
    class Meta:
        model = ChuDeGopY
        fields = ["id","chude"]


class GopYSerializer(ModelSerializer):
    khachhang = KhachHangMiniSerializer()
    chude = ChuDeGopYSerializer()
    class Meta:
        model = GopY
        fields = ["id","khachhang","chude","noidung"]


class YeuThichSerializer(ModelSerializer):
    khachhang = KhachHangMiniSerializer()
    sanpham = SanPhamMiniSerializer()
    class Meta:
        model = YeuThich
        fields = ["id","khachhang","sanpham"]


class HinhThucThanhToanSerializer(ModelSerializer):
    class Meta:
        model = HinhThucThanhToan
        fields = ["id","ten"]


class LichSuMuaSerializer(ModelSerializer):
    khachhang = KhachHangMiniSerializer()
    sanpham = SanPhamSerializer()
    httt = HinhThucThanhToanSerializer()
    class Meta:
        model = LichSuMua
        fields = ["id", "khachhang", "sanpham", "httt","dienthoai", "soluong", "ngaydathang", "dongia", "noigiao","muahang"]


class LichSuMuonSerializer(ModelSerializer):
    khachhang = KhachHangMiniSerializer()
    sanpham = SanPhamSerializer()
    httt = HinhThucThanhToanSerializer()
    class Meta:
        model = LichSuMuon
        fields = ["id", "khachhang", "sanpham", "httt","dienthoai", "soluong", "ngaydathang","ngaytra", "dongia", "noigiao","muonhang"]
