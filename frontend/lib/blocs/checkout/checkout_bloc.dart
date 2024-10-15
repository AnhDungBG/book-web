import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/cart/cart_bloc.dart';
import 'package:flutter_web_fe/blocs/cart/cart_state.dart';
import 'package:flutter_web_fe/blocs/checkout/checkout_event.dart';
import 'package:flutter_web_fe/blocs/checkout/checkout_state.dart';
import 'package:flutter_web_fe/core/data/models/cart_model.dart';
import 'package:flutter_web_fe/core/data/models/order_model.dart';
import 'package:flutter_web_fe/core/data/repositories/checkout_repositiry.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutService checkoutService;
  final CartBloc cartBloc;

  CheckoutBloc({
    required this.checkoutService,
    required this.cartBloc,
  }) : super(CheckoutInitial()) {
    on<CheckoutStarted>(_onCheckoutStarted);
    on<CheckoutInfoUpdated>(_onCheckoutInfoUpdated);
    on<PaymentMethodSelected>(_onPaymentMethodSelected);
    on<CheckoutSubmitted>(_onCheckoutSubmitted);
    on<BuyNowRequested>(_onBuyNowRequested);
  }

  void _onCheckoutStarted(CheckoutStarted event, Emitter<CheckoutState> emit) {
    final cartState = cartBloc.state;
    if (cartState is CartLoaded) {
      emit(CheckoutLoaded(
          cart: cartState.cart, totalPrice: cartState.cart.totalPrice));
    } else {
      emit(const CheckoutError('Không thể tải giỏ hàng'));
    }
  }

  void _onCheckoutInfoUpdated(
      CheckoutInfoUpdated event, Emitter<CheckoutState> emit) {
    if (state is CheckoutLoaded) {
      final currentState = state as CheckoutLoaded;
      emit(currentState.copyWith(
        name: event.name,
        phone: event.phone,
        address: event.address,
      ));
    }
  }

  void _onPaymentMethodSelected(
      PaymentMethodSelected event, Emitter<CheckoutState> emit) {
    if (state is CheckoutLoaded) {
      final currentState = state as CheckoutLoaded;
      emit(currentState.copyWith(paymentMethod: event.paymentMethod));
    }
  }

  void _onCheckoutSubmitted(
      CheckoutSubmitted event, Emitter<CheckoutState> emit) async {
    emit(CheckoutLoading());
    try {
      OrderDetail orderDetail = await checkoutService.submitOrder(
        productId: event.productId,
        quantity: event.quantity,
        paymentMethod: event.paymentMethod,
      );

      emit(CheckoutSuccess(orderDetail));
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }

  void _onBuyNowRequested(BuyNowRequested event, Emitter<CheckoutState> emit) {
    final tempCart = CartModel(
      items: [
        CartItemModel(
          id: event.product.id.toString(),
          title: event.product.title ?? '',
          author: event.product.author ?? '',
          imageUrl: event.product.imageUrl ?? '',
          price: event.product.price ?? 0,
          quantity: event.quantity,
        )
      ],
      subtotal: (event.product.price ?? 0) * event.quantity,
      shippingFee: 0,
      totalPrice: (event.product.price ?? 0) * event.quantity,
    );

    emit(CheckoutLoaded(cart: tempCart, totalPrice: tempCart.totalPrice));
    // ignore: avoid_print
    print('CheckoutLoaded emitted with cart: ${tempCart.toJson()}');
  }
}
