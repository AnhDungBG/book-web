from rest_framework import viewsets, permissions, status, generics
from rest_framework.permissions import IsAuthenticated
from django.db.models import Q

from bookapp.config import CustomPagination
from notifications.models import LoaiThongBao, ThongBao
from notifications.serializers import LoaiThongBaoSerializer, ThongBaoSerializer


# Create your views here.
# class LoaiThongBaoViewSet(viewsets.ViewSet,
#                           generics.RetrieveAPIView,
#                           generics.ListAPIView):
#     queryset = LoaiThongBao.objects.filter(active=True).order_by('id')
#     serializer_class = LoaiThongBaoSerializer
#     pagination_class = CustomPagination


class ThongBaoViewSet(viewsets.ViewSet,
                      generics.RetrieveAPIView,
                      generics.ListAPIView
                      ):
    serializer_class = ThongBaoSerializer
    pagination_class = CustomPagination
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return ThongBao.objects.filter(khachhang=self.request.user).filter(active=True).order_by('-ngaythongbao')
