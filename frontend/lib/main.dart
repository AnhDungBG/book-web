import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_fe/blocs/auth/auth_bloc.dart';
import 'package:flutter_web_fe/blocs/author/author_bloc.dart';
import 'package:flutter_web_fe/blocs/cart/cart_bloc.dart';
import 'package:flutter_web_fe/blocs/category/category_bloc.dart';
import 'package:flutter_web_fe/blocs/checkout/checkout_bloc.dart';
import 'package:flutter_web_fe/blocs/favoriteProduct/favorite_product_bloc.dart';
import 'package:flutter_web_fe/blocs/genre/genre_bloc.dart';
import 'package:flutter_web_fe/blocs/myFavoriteProduct/my_favorite_bloc.dart';
import 'package:flutter_web_fe/blocs/notification/notification_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_bloc.dart';
import 'package:flutter_web_fe/blocs/order/order_bloc.dart';
import 'package:flutter_web_fe/blocs/search/book_search/book_search_bloc.dart';
import 'package:flutter_web_fe/blocs/topProduct/top_product_bloc.dart';
import 'package:flutter_web_fe/core/data/repositories/checkout_repositiry.dart';
import 'package:flutter_web_fe/core/data/repositories/genre_repository.dart';
import 'package:flutter_web_fe/core/services/api_service.dart';
import 'package:flutter_web_fe/core/data/repositories/auth_repository.dart';
import 'package:flutter_web_fe/core/data/repositories/author_repository.dart';
import 'package:flutter_web_fe/core/data/repositories/cart_repository.dart';
import 'package:flutter_web_fe/core/data/repositories/category_repository.dart';
import 'package:flutter_web_fe/core/data/repositories/notification_repository.dart';
import 'package:flutter_web_fe/core/data/repositories/book_repository.dart';
import 'package:flutter_web_fe/core/data/repositories/order_repository.dart'; // Thêm import cho OrderRepository
import 'package:flutter_web_fe/presentation/routes/router.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");

  setUrlStrategy(PathUrlStrategy());

  final apiClient = ApiClient();
  final checkoutService = CheckoutService(apiClient);
  final authService = AuthService(apiClient);
  final cartService = CartService(apiClient);
  final orderService = OrderService(apiClient);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                CartBloc(cartService: cartService, authService: authService)),
        BlocProvider(
          create: (context) => CheckoutBloc(
            checkoutService: checkoutService,
            cartBloc: context.read<CartBloc>(),
          ),
        ),
        BlocProvider(create: (context) => AuthBloc(authService: authService)),
        BlocProvider(
            create: (context) =>
                CategoryBloc(categoryService: CategoryService(apiClient))),
        BlocProvider(
            create: (context) =>
                AuthorBloc(authorService: AuthorService(apiClient))),
        BlocProvider(
            create: (context) => NotificationBloc(
                notificationService: NotificationService(apiClient))),
        BlocProvider(
            create: (context) =>
                GenreBloc(genreService: GenreService(apiClient))),
        BlocProvider(
            create: (context) =>
                SearchBloc(productSearchService: ProductService(apiClient))),
        BlocProvider(
            create: (context) =>
                ProductBloc(productService: ProductService(apiClient))),
        BlocProvider(
            create: (context) =>
                FavoriteProductBloc(productService: ProductService(apiClient))),
        BlocProvider(
          create: (context) =>
              TopBookBloc(productService: ProductService(apiClient)),
        ),
        BlocProvider(
          create: (context) =>
              MyFavoriteProductBloc(productService: ProductService(apiClient)),
        ),
        BlocProvider(create: (context) => OrderBloc(orderService)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = context.read<ProductBloc>().productService;

    return MaterialApp.router(
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        fontFamily: 'Inter',
      ),
      routeInformationParser: BeamerParser(),
      routerDelegate: AppRouter(productService).routerDelegate,
      debugShowCheckedModeBanner: false,
    );
  }
}
