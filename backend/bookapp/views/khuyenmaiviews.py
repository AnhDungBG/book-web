from rest_framework import viewsets, generics
from datetime import date

from bookapp.config import CustomPagination
from bookapp.models.khuyenmai import KhuyenMai
from bookapp.serializers import KhuyenMaiSerializer


class KhuyenMaiViewSet(viewsets.ViewSet,
                       generics.RetrieveAPIView,
                       generics.ListAPIView):
    queryset = KhuyenMai.objects.all()
    serializer_class = KhuyenMaiSerializer
    pagination_class = CustomPagination

    def get_queryset(self):
        today = date.today()
        # Chỉ lấy những khuyến mãi còn hiệu lực
        return KhuyenMai.objects.filter(tungay__lte=today, denngay__gte=today).order_by('id')
