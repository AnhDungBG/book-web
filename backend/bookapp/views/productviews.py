from rest_framework.views import APIView
from rest_framework import viewsets, status, generics, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import Sum, F
from django.db.models.functions import Coalesce
from bookapp.config import CustomPagination
from bookapp.models.product import Tag, LoaiSanPham, NhaSanXuat, SanPham
from bookapp.serializers import TagSerializer, LoaiSanPhamSerializer, NhaSanXuatSerializer, SanPhamSerializer, \
    SanPhamFilter, SanPhamMiniSerializer


# Create your views here.
class TagViewSet(viewsets.ViewSet,
                       generics.RetrieveAPIView,
                       generics.ListAPIView
                       ):
    queryset = Tag.objects.all().order_by('id')
    serializer_class = TagSerializer
    pagination_class = CustomPagination

    def get_permissions(self):
        if self.action in ['list', 'retrieve']:
            return [permissions.AllowAny()]
        return [permissions.IsAuthenticated()]


class LoaiSanPhamViewSet(viewsets.ViewSet,
                       generics.RetrieveAPIView,
                       generics.ListAPIView
                       ):
    queryset = LoaiSanPham.objects.all().order_by('id')
    serializer_class = LoaiSanPhamSerializer
    pagination_class = CustomPagination

    def get_permissions(self):
        if self.action in ['list', 'retrieve']:
            return [permissions.AllowAny()]
        return [permissions.IsAuthenticated()]

class NhaSanXuatViewSet(viewsets.ViewSet,
                       generics.RetrieveAPIView,
                       generics.ListAPIView
                       ):
    queryset = NhaSanXuat.objects.filter(active=True).order_by('id')
    serializer_class = NhaSanXuatSerializer
    pagination_class = CustomPagination

    def get_permissions(self):
        if self.action in ['list', 'retrieve']:
            return [permissions.AllowAny()]
        return [permissions.IsAuthenticated()]

class SanPhamViewSet(viewsets.ViewSet, generics.RetrieveAPIView, generics.ListAPIView):
    queryset = SanPham.objects.filter(active=True).order_by('id')
    serializer_class = SanPhamSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_class = SanPhamFilter
    pagination_class = CustomPagination

    def get_permissions(self):
        if self.action in ['list', 'retrieve', 'search', 'get_related_products']:
            return [permissions.AllowAny()]
        return [permissions.IsAuthenticated()]

    def get_queryset(self):
        queryset = SanPham.objects.filter(active=True).annotate(
            soluong_dathang=Coalesce(Sum('lichsumua__soluong'), 0) + Coalesce(Sum('lichsumuon__soluong'), 0)
        )
        
        # Áp dụng bộ lọc
        return self.filterset_class(self.request.GET, queryset=queryset).qs

    @action(detail=False, methods=['get'], url_path='search', url_name='search')
    def search(self, request):
        ten = request.query_params.get('ten', '')
        tacgia = request.query_params.get('tacgia', '')
        tags = request.query_params.get('tags', '')

        queryset = self.filter_queryset(self.get_queryset()).filter(
            ten__icontains=ten,
            tacgia__icontains=tacgia,
            tags__icontains=tags,
            active=True
        )

        serializer = SanPhamSerializer(queryset, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['get'], url_path='related', url_name='related')
    def get_related_products(self, request, pk=None):
        san_pham = self.get_object()
        related_products = SanPham.objects.filter(
            tags__in=san_pham.tags.all()
        ).exclude(id=san_pham.id).distinct()[:5]  # Lấy tối đa 5 sản phẩm liên quan

        serializer = self.get_serializer(related_products, many=True)
        return Response(serializer.data)

class HottestProductsView(APIView):
    def get(self, request):
        san_pham_hot = SanPham.objects.filter(active=True).annotate(
            quantity=Coalesce(Sum('lichsumua__soluong'), 0) + Coalesce(Sum('lichsumuon__soluong'), 0)
        ).order_by('-quantity')[:10]

        serializer = SanPhamMiniSerializer(san_pham_hot, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class ProductSales(APIView):
    def get(self, request):
        queryset = SanPham.objects.filter(active=True,khuyenmai__isnull=False).annotate(
            quantity=Coalesce(Sum('lichsumua__soluong'), 0) + Coalesce(Sum('lichsumuon__soluong'), 0)
        ).order_by('-khuyenmai__khuyenmai')
        serializer = SanPhamMiniSerializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)