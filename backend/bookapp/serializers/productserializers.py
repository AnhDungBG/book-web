from rest_framework.serializers import ModelSerializer
from bookapp.models.product import LoaiSanPham, Tag, NhaSanXuat, SanPham
from bookapp.serializers.khuyenmaiserializers import KhuyenMaiSerializer
from django_filters import rest_framework as filters
from rest_framework import serializers
from django.db.models import Sum, F
from django.db.models.functions import Coalesce

class TagSerializer(ModelSerializer):
    class Meta:
        model = Tag
        fields = ["id","ten"]

class LoaiSanPhamSerializer(ModelSerializer):
    class Meta:
        model = LoaiSanPham
        fields = ["id","ten"]

class NhaSanXuatSerializer(ModelSerializer):
    class Meta:
        model = NhaSanXuat
        fields = ["id", "ten"]

class SanPhamMiniSerializer(ModelSerializer):
    quantity = serializers.SerializerMethodField()
    khuyenmai = KhuyenMaiSerializer()
    class Meta:
        model = SanPham
        fields = ["id", "ten","tacgia", "giamua", "giamuon","giathitruong","khuyenmai","hinhanh",'quantity']

    def get_quantity(self, obj):
        return obj.quantity if hasattr(obj, 'quantity') else 0


class SanPhamSerializer(serializers.ModelSerializer):
    soluong_dathang = serializers.SerializerMethodField()
    tags = TagSerializer(many=True)
    loai = LoaiSanPhamSerializer()
    nsx = NhaSanXuatSerializer()
    khuyenmai = KhuyenMaiSerializer()
    class Meta:
        model = SanPham
        fields = ["id", "ten","tacgia", "giamua", "giamuon","giathitruong", "motangan","motachitiet",
                  "ngaycapnhat", "soluong","khuyenmai","ngayxuatban","tags", "loai", "nsx","hinhanh", 'active', 'soluong_dathang']

    def get_soluong_dathang(self, obj):
        return obj.soluong_dathang if hasattr(obj, 'soluong_dathang') else 0


class SanPhamFilter(filters.FilterSet):
    # Lọc theo các trường văn bản
    tacgia = filters.CharFilter(method='filter_tacgia')
    loai = filters.CharFilter(method='filter_loai')
    nsx = filters.CharFilter(method='filter_nsx')

    # Lọc theo giá trị lớn hơn hoặc bằng, nhỏ hơn hoặc bằng
    giamua = filters.RangeFilter()
    giamuon = filters.RangeFilter()
    giathitruong = filters.RangeFilter()

    # Lọc theo ngày tháng năm xuất bản
    ngayxuatban = filters.DateFromToRangeFilter()

    # Thêm trường lọc cho tags
    tags = filters.CharFilter(method='filter_tags')

    class Meta:
        model = SanPham
        fields = ['ten', 'tacgia', 'giamua', 'giamuon', 'giathitruong', 'ngayxuatban', 'loai', 'nsx', 'tags']

    def filter_tacgia(self, queryset, name, value):
        tacgia_list = value.split(',')
        return queryset.filter(tacgia__in=tacgia_list)

    def filter_loai(self, queryset, name, value):
        loai_list = value.split(',')
        return queryset.filter(loai__ten__in=loai_list)

    def filter_nsx(self, queryset, name, value):
        nsx_list = value.split(',')
        return queryset.filter(nsx__ten__in=nsx_list)

    def filter_tags(self, queryset, name, value):
        tag_list = value.split(',')
        return queryset.filter(tags__ten__in=tag_list)
