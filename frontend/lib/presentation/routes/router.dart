import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_bloc.dart';
import 'package:flutter_web_fe/core/data/repositories/book_repository.dart';
import 'package:flutter_web_fe/presentation/screens/about/about_screen.dart';
import 'package:flutter_web_fe/presentation/screens/cart/cart_page.dart';
import 'package:flutter_web_fe/presentation/screens/contact/contact_page.dart';
import 'package:flutter_web_fe/presentation/screens/home/home_sreen.dart';
import 'package:flutter_web_fe/presentation/screens/myFavorite/my_favorite_product.dart';
import 'package:flutter_web_fe/presentation/screens/order/order_list_page.dart';
import 'package:flutter_web_fe/presentation/screens/order/order_page.dart';
import 'package:flutter_web_fe/presentation/screens/productDeatil/product_detail.dart';
import 'package:flutter_web_fe/presentation/screens/products/products_page.dart';
import 'package:flutter_web_fe/presentation/screens/profile/profile_screnn.dart';
import 'package:flutter_web_fe/presentation/screens/register/register_screen.dart';

class AppRouter {
  final ProductService productService;

  AppRouter(this.productService);

  BeamerDelegate get routerDelegate => BeamerDelegate(
        transitionDelegate: const DefaultTransitionDelegate(),
        locationBuilder: RoutesLocationBuilder(
          routes: {
            '/': (context, state, data) => const BeamPage(
                  key: ValueKey('home'),
                  type: BeamPageType.slideLeftTransition,
                  child: HomePage(),
                ),
            '/home': (context, state, data) => const BeamPage(
                  key: ValueKey('home'),
                  type: BeamPageType.fadeTransition,
                  child: HomePage(),
                ),
            '/products': (context, state, data) {
              final genreId = state.queryParameters['genreId'];
              return BeamPage(
                key: ValueKey('products-${genreId ?? "all"}'),
                type: BeamPageType.slideRightTransition,
                child: ProductsPage(genreId: genreId),
              );
            },
            '/products/:id': (context, state, data) {
              final id = state.pathParameters['id'];
              if (id != null) {
                return BeamPage(
                  key: ValueKey('product-$id'),
                  title: 'Product Detail',
                  type: BeamPageType.fadeTransition,
                  child: BlocProvider.value(
                    value: context.read<ProductBloc>(),
                    child: ProductDetail(productId: id),
                  ),
                );
              }
              return const BeamPage(
                key: ValueKey('product-not-found'),
                title: 'Product Not Found',
                child: Scaffold(
                    body: Center(child: Text('Không tìm thấy sản phẩm'))),
              );
            },
            '/about': (context, state, data) => const BeamPage(
                  key: ValueKey('about'),
                  type: BeamPageType.slideLeftTransition,
                  child: AboutScreen(),
                ),
            '/contact': (context, state, data) => const BeamPage(
                  key: ValueKey('contact'),
                  type: BeamPageType.slideLeftTransition,
                  child: ContactPage(),
                ),
            '/profile': (context, state, data) => const BeamPage(
                  key: ValueKey('profile'),
                  type: BeamPageType.slideLeftTransition,
                  child: ProfileScreen(),
                ),
            '/cart': (context, state, data) => const BeamPage(
                  key: ValueKey('cart'),
                  type: BeamPageType.slideRightTransition,
                  child: CartPage(),
                ),
            '/register': (context, state, data) => const BeamPage(
                  key: ValueKey('register'),
                  type: BeamPageType.fadeTransition,
                  child: RegisterPage(),
                ),
            '/my-order': (context, state, data) => const BeamPage(
                  key: ValueKey('register'),
                  type: BeamPageType.fadeTransition,
                  child: OrderListPage(),
                ),
            '/my-favorite-book': (context, state, data) => const BeamPage(
                  key: ValueKey('register'),
                  type: BeamPageType.fadeTransition,
                  child: MyFavoriteProductsScreen(),
                ),
            '/order/:id': (context, state, data) {
              final productId = state.pathParameters['id'];
              final quantity = state.queryParameters['quantity'] ??
                  '1'; // Giá trị mặc định là 1
              return BeamPage(
                key: ValueKey('order-$productId'),
                type: BeamPageType.slideLeftTransition,
                child: OrderPage(
                  productId: productId ?? '',
                  quantity: int.tryParse(quantity) ?? 1,
                ),
              );
            },
          },
        ).call,
      );
}

void handleNavigation(BuildContext context, String title, {String? genreId}) {
  switch (title) {
    case 'Home':
      Beamer.of(context).beamToNamed('/');
      break;
    case 'Products':
      if (genreId != null) {
        Beamer.of(context).beamToNamed('/products', data: {'genreId': genreId});
      } else {
        Beamer.of(context).beamToNamed('/products');
      }
      break;
    case 'About':
      Beamer.of(context).beamToNamed('/about');
      break;
    case 'Contact':
      Beamer.of(context).beamToNamed('/contact');
      break;
    case 'Register':
      Beamer.of(context).beamToNamed('/register');
      break;
    default:
      Beamer.of(context).beamToNamed('/home');
      break;
  }
}
