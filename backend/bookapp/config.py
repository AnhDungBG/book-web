from rest_framework.pagination import PageNumberPagination
from rest_framework.response import Response


class CustomPagination(PageNumberPagination):
    page_size_query_param = 'limit'
    max_page_size = 50  # Giới hạn tối đa số bản ghi trên một trang

    def get_paginated_response(self, data):
        """
        Trả về phản hồi phân trang tùy chỉnh.
        """
        return Response({
            'count': self.page.paginator.count,
            'next': self.get_next_link(),
            'previous': self.get_previous_link(),
            'results': data
        })
