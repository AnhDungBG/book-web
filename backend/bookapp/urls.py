"""
URL configuration for BookWebsite project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, re_path, include
from rest_framework.routers import DefaultRouter
from django.contrib.auth import views as auth_views
from notifications import views
from .views import userviews, productviews, oderviews, khuyenmaiviews, LogoutView, user_info, DangKyView, \
    XacThucOTPView, XacThucEmailView, ForgotPassword, HottestFavoriteProductsView, HottestProductsView, ProductSales
from django.conf.urls.static import static

router =DefaultRouter()
#user
router.register('user',userviews.KhachHangViewSet )
router.register('chudegopy',userviews.ChuDeGopYViewSet )
router.register('gopy',userviews.GopYViewSet )
router.register('hinhthucthanhtoan',userviews.HinhThucThanhToanViewSet )
router.register('yeuthich',userviews.YeuThichViewSet )
router.register('lichsumua',userviews.LichSuMuaViewSet )
router.register('lichsumuon',userviews.LichSuMuonViewSet )

#product
router.register('tag',productviews.TagViewSet )
router.register('loaisanpham',productviews.LoaiSanPhamViewSet )
router.register('nhasanxuat',productviews.NhaSanXuatViewSet )
router.register('sanpham',productviews.SanPhamViewSet )

#oder
router.register('yeucaumua',oderviews.YeuCauMuaViewSet )
router.register('yeucaumuon',oderviews.YeuCauMuonViewSet )
router.register('donhang',oderviews.DonHangViewSet )

#khuyenmai
router.register('khuyenmai',khuyenmaiviews.KhuyenMaiViewSet )

#notification
# router.register('loaithongbao',views.LoaiThongBaoViewSet )
router.register('thongbao', views.ThongBaoViewSet, basename='thongbao')

urlpatterns = [
    path('', include(router.urls)),
    path('userinfo/', user_info, name='userinfo'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('dangky/', DangKyView.as_view(), name='dangky'),
    path('xacthuc-otp/', XacThucOTPView.as_view(), name='xacthuc-otp'),
    path('xacthuc-email/', XacThucEmailView.as_view(), name='xacthuc-email'),
    path('sanpham-hot/', HottestProductsView.as_view(), name='sanpham-hot'),
    path('dangky/', DangKyView.as_view(), name='dangky'),
    path('forgotpassword/', ForgotPassword.as_view(), name='forgotpassword'),
    path('top-sanpham-yeuthich/', HottestFavoriteProductsView.as_view(), name='top-sanpham-yeuthich'),
    path('sanpham-sale/', ProductSales.as_view(), name='sanpham-sale'),
]

