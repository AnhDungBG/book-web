// order_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/core/data/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderService orderService;

  OrderBloc(this.orderService) : super(OrderInitial()) {
    on<FetchOrders>(_onFetchOrders);
    on<SendOrderRequest>(_onSendOrderRequest);
    on<CancelOrder>(_onCancelOrder); // Thêm sự kiện hủy đơn hàng
  }

  Future<void> _onFetchOrders(
    FetchOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orderLists = await orderService.fetchListOrders();
      emit(OrderListLoaded(orderLists));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onSendOrderRequest(
    SendOrderRequest event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await orderService.sendOrder(event.order);
      // emit(OrderSuccess());
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading()); // Hiển thị loading khi đang xử lý yêu cầu hủy
    try {
      await orderService.cancelOrder(event.orderId); // Gọi hàm hủy đơn hàng
      // Có thể gọi lại danh sách đơn hàng sau khi hủy
      final orderLists =
          await orderService.fetchListOrders(); // Làm mới danh sách đơn hàng
      emit(OrderListLoaded(orderLists)); // Cập nhật danh sách đơn hàng
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
