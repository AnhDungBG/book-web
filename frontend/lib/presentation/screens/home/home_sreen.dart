import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_event.dart';
import 'package:flutter_web_fe/blocs/favoriteProduct/favorite_product_bloc.dart';
import 'package:flutter_web_fe/blocs/favoriteProduct/favorite_product_event.dart';
import 'package:flutter_web_fe/presentation/screens/home/components/banner_bottom.dart';
import 'package:flutter_web_fe/presentation/screens/home/components/banner_top.dart';
import 'package:flutter_web_fe/presentation/screens/home/components/bookle_top_book.dart';
import 'package:flutter_web_fe/presentation/screens/home/components/sale_books.dart';
import 'package:flutter_web_fe/presentation/screens/home/components/our_service.dart';
import 'package:flutter_web_fe/presentation/screens/home/components/top_categories_book.dart';
import 'package:flutter_web_fe/presentation/screens/home/components/top_favorite_book.dart';
import 'package:flutter_web_fe/presentation/components/footer_desktop.dart';
import 'package:flutter_web_fe/presentation/components/header_desktop.dart';
import 'package:flutter_web_fe/presentation/components/wapper_mobile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const FetchProducts(page: 1, limit: 10));
    context.read<FavoriteProductBloc>().add(const FetchFavoriteProduct());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: true,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (didPop) {
          context
              .read<ProductBloc>()
              .add(const FetchProducts(page: 1, limit: 10));
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          return Scaffold(
            key: scaffoldKey,
            endDrawer: isMobile ? const DrawerMobile() : null,
            body: RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ProductBloc>()
                    .add(const FetchProducts(page: 1, limit: 10));
              },
              child: const SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      HeaderDesktop(),
                      CustomBannerTop(),
                      Service(),
                      ProductCarouselPage(),
                      TopCategoryBook(),
                      BookleTopBooks(),
                      BannerBottom(),
                      TopFavoriteBook(),
                      CustomFooter()
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}
