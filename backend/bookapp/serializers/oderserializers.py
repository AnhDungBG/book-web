from rest_framework import serializers
from rest_framework.serializers import ModelSerializer

from bookapp.models.oder import DonHang, YeuCauMua, YeuCauMuon
from bookapp.serializers.khuyenmaiserializers import KhuyenMaiSerializer
from bookapp.serializers.productserializers import SanPhamSerializer
from bookapp.serializers.userserializers import KhachHangSerializer, HinhThucThanhToanSerializer


class YeuCauMuaSerializer(ModelSerializer):
    khachhang = serializers.PrimaryKeyRelatedField(read_only=True)
    httt = serializers.SlugRelatedField(slug_field='ten', read_only=True)
    sanpham = serializers.PrimaryKeyRelatedField(read_only=True)
    class Meta:
        model = YeuCauMua
        fields = ["id","khachhang","ngaydat","noigiao","trangthai_thanhtoan","httt","dienthoai","sanpham","soluong","dongia"]


class YeuCauMuonSerializer(ModelSerializer):
    khachhang = serializers.PrimaryKeyRelatedField(read_only=True)
    httt = serializers.SlugRelatedField(slug_field='ten', read_only=True)
    sanpham = serializers.PrimaryKeyRelatedField(read_only=True)
    class Meta:
        model = YeuCauMuon
        fields = ["id","khachhang","ngaydat","noigiao","trangthai_thanhtoan","httt","dienthoai","sanpham","soluong","dongia","ngaytra"]


class DonHangSerializer(ModelSerializer):
    yeucaumua = YeuCauMuaSerializer()
    yeucaumuon = YeuCauMuonSerializer()
    class Meta:
        model = DonHang
        fields = ["id","yeucaumua","yeucaumuon","ngaygiaotu","ngaygiaoden"]
