import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/cart/cart_event.dart';
import 'package:flutter_web_fe/blocs/cart/cart_state.dart';
import 'package:flutter_web_fe/core/data/models/cart_model.dart';
import 'package:flutter_web_fe/core/data/repositories/auth_repository.dart';
import 'package:flutter_web_fe/core/data/repositories/cart_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService cartService;
  final AuthService authService;

  CartBloc({required this.cartService, required this.authService})
      : super(CartLoading()) {
    on<CartStarted>(_onCartStarted);
    on<CartItemAdded>(_onCartItemAdded);
    // on<CartItemRemoved>(_onCartItemRemoved);
    on<CartItemQuantityChanged>(_onCartItemQuantityChanged);
    on<CartCleared>(_onCartCleared);
  }

  Future<void> _saveCartToLocalStorage(CartModel cart) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart', jsonEncode(cart.toJson()));
  }

  void _onCartStarted(CartStarted event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final isLoggedIn = await authService.isLoggedIn();
      if (!isLoggedIn) {
        emit(CartNotAuthenticated());
        return;
      }

      CartModel cart = FakeCartData.getFakeCart();
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError('Không thể tải giỏ hàng: $e'));
    }
  }

  void _onCartItemAdded(CartItemAdded event, Emitter<CartState> emit) async {
    final state = this.state;
    if (state is CartLoaded) {
      try {
        final updatedCart = state.cart.copyWith(
          items: List.from(state.cart.items)..add(event.item),
        );
        updatedCart.recalculateTotals(); // Call the public method
        emit(CartLoaded(updatedCart));
        await _saveCartToLocalStorage(updatedCart); // Save to local storage
      } catch (e) {
        emit(CartError('Không thể thêm sách vào giỏ hàng: $e'));
      }
    }
  }

  void _onCartItemQuantityChanged(
      CartItemQuantityChanged event, Emitter<CartState> emit) async {
    final state = this.state;
    if (state is CartLoaded) {
      try {
        final updatedItems = state.cart.items.map((item) {
          if (item.id == event.itemId) {
            return item.copyWith(quantity: event.quantity);
          }
          return item;
        }).toList();
        final updatedCart = state.cart.copyWith(items: updatedItems);
        updatedCart.recalculateTotals(); // Use the public method
        emit(CartLoaded(updatedCart));
        await _saveCartToLocalStorage(updatedCart); // Save to local storage
      } catch (e) {
        emit(CartError('Không thể cập nhật số lượng sản phẩm: $e'));
      }
    }
  }

  void _onCartCleared(CartCleared event, Emitter<CartState> emit) async {
    try {
      // await cartService.clearCart();
      final emptyCart = CartModel(
        items: const [],
        subtotal: 0,
        shippingFee: 0,
        totalPrice: 0,
      );
      await _saveCartToLocalStorage(emptyCart);
      emit(CartLoaded(emptyCart));
    } catch (e) {
      emit(CartError('Không thể xóa giỏ hàng: $e'));
    }
  }
}

class FakeCartData {
  static CartModel getFakeCart() {
    return CartModel(
      items: const [
        CartItemModel(
          id: '1',
          title: 'Đắc Nhân Tâm',
          author: 'Dale Carnegie',
          imageUrl: 'https://example.com/dac-nhan-tam.jpg',
          price: 150000,
          quantity: 2,
        ),
        CartItemModel(
          id: '2',
          title: 'Nhà Giả Kim',
          author: 'Paulo Coelho',
          imageUrl: 'https://example.com/nha-gia-kim.jpg',
          price: 120000,
          quantity: 1,
        ),
        CartItemModel(
          id: '3',
          title: 'Tuổi Trẻ Đáng Giá Bao Nhiêu',
          author: 'Rosie Nguyễn',
          imageUrl: 'https://example.com/tuoi-tre-dang-gia-bao-nhieu.jpg',
          price: 80000,
          quantity: 3,
        ),
        CartItemModel(
          id: '4',
          title: 'Cà Phê Cùng Tony',
          author: 'Tony Buổi Sáng',
          imageUrl: 'https://example.com/ca-phe-cung-tony.jpg',
          price: 90000,
          quantity: 1,
        ),
        CartItemModel(
          id: '5',
          title: 'Tôi Thấy Hoa Vàng Trên Cỏ Xanh',
          author: 'Nguyễn Nhật Ánh',
          imageUrl: 'https://example.com/toi-thay-hoa-vang-tren-co-xanh.jpg',
          price: 110000,
          quantity: 2,
        ),
      ],
      subtotal: 0,
      shippingFee: 30000,
      totalPrice: 0,
    )..recalculateTotals(); // Ensure totals are calculated
  }
}
