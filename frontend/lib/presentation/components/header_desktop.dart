import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/auth/auth_event.dart';
import 'package:flutter_web_fe/blocs/cart/cart_state.dart';
import 'package:flutter_web_fe/blocs/notification/notification_bloc.dart';
import 'package:flutter_web_fe/blocs/notification/notification_event.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';
import 'package:flutter_web_fe/core/constants/nav_items.dart';
import 'package:flutter_web_fe/blocs/auth/auth_bloc.dart';
import 'package:flutter_web_fe/blocs/auth/auth_state.dart';
import 'package:flutter_web_fe/core/data/models/notification_model.dart';
import 'package:flutter_web_fe/core/data/models/auth_model.dart';
import 'package:flutter_web_fe/presentation/routes/router.dart';
import 'package:flutter_web_fe/presentation/screens/login/login_screen.dart';
import 'package:flutter_web_fe/presentation/components/site_logo.dart';

class HeaderDesktop extends StatefulWidget {
  const HeaderDesktop({super.key});

  @override
  State<HeaderDesktop> createState() => _HeaderDesktopState();
}

class _HeaderDesktopState extends State<HeaderDesktop> {
  final TextEditingController searchController = TextEditingController();
  int itemCount = 0;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    BlocProvider.of<AuthBloc>(context).add(CheckAuthStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state is Authenticated ? state.user : null;
          if (state is CartLoaded) {
            itemCount =
                state.cart.items.fold(0, (sum, item) => sum + item.quantity);
          }
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomPaint(
                    painter: CurvedHeaderPainter(
                      color: CustomColor.secondBlue,
                      isLeftSide: true,
                    ),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 190),
                      child: _buildLogoSection(),
                    )),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: CustomPaint(
                                  painter: CurvedHeaderPainter(
                                    color: CustomColor.lightBlue,
                                    isLeftSide: false,
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 100),
                                    color: CustomColor.primaryBlue,
                                  )),
                            ),
                            const Expanded(child: ContactInfoBar()),
                          ],
                        )),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: CustomColor.white,
                        padding: const EdgeInsets.fromLTRB(20, 10, 200, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 20),
                            _buildNavItems(),
                            const SizedBox(width: 100),
                            Row(
                              children: [
                                _buildSearchField(),
                                const SizedBox(width: 15),
                                _buildNotification(),
                                if (user != null) _buildShoppingCartIcon(),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      width: 400,
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm...',
          prefixIcon: const Icon(
            Icons.search,
            color: CustomColor.secondBlue,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
                const BorderSide(color: CustomColor.secondBlue, width: 1),
          ),
        ),
        onSubmitted: (query) {},
      ),
    );
  }

  Widget _buildNavItems() {
    return Row(
      children: [
        for (final title in navTitle(context))
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextButton(
              onPressed: () => handleNavigation(context, title),
              style:
                  TextButton.styleFrom(foregroundColor: CustomColor.secondBlue),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildShoppingCartIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Badge(
          label: Text('$itemCount'),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Beamer.of(context).beamToNamed('/cart');
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNotification() {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        return PopupMenuButton<void>(
          tooltip: 'Thông báo',
          offset: const Offset(0, 50),
          icon: Stack(
            children: [
              const Icon(
                Icons.notifications,
                color: CustomColor.secondBlue,
              ),
              if (state.unreadCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${state.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          onOpened: () {
            context.read<NotificationBloc>().add(FetchNotificationsEvent());
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<void>(
              child: SizedBox(
                width: 600, // Adjust this value for the desired width
                height: 500, // Adjust height if needed
                child: _buildNotificationList(state.notifications),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Không có thông báo nào.'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 8.0), // Add padding between items for spacing
          child: Container(
            width: 400, // Set desired width for each item
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0), // Add some padding inside each item
            decoration: BoxDecoration(
              color: Colors.white, // Background color for the notification item
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.notification_important,
                    color: CustomColor.secondBlue,
                  ),
                  title: Text(
                    notification.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(notification.message),
                  onTap: () {},
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: SiteLogo(onTab: () => Beamer.of(context).beamToNamed('/')),
    );
  }
}

class CurvedHeaderPainter extends CustomPainter {
  final Color color;
  final bool isLeftSide;

  CurvedHeaderPainter({required this.color, required this.isLeftSide});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();
    if (isLeftSide) {
      path.lineTo(size.width - 100, 0);
      path.quadraticBezierTo(size.width, 0, size.width, 100);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
    } else {
      path.moveTo(-50, 0);

      path.quadraticBezierTo(
          size.width * 0.15, size.height * 0.3, 9, size.height);

      path.lineTo(size.width, size.height); // bottom right

      path.lineTo(size.width, 0); // top right
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ContactInfoBar extends StatelessWidget {
  const ContactInfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: double.infinity,
      color: CustomColor.lightBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildInfoItem(Icons.phone, '+208-6666-0112'),
              _buildInfoItem(Icons.email, 'info@example.com'),
              _buildInfoItem(Icons.access_time, 'Sunday - Fri: 9 aM - 6 pM'),
            ],
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final user = state is Authenticated ? state.user : null;
              return Container(
                margin: const EdgeInsets.only(right: 200),
                child: _buildUserSection(context, user),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        children: [
          Icon(icon, color: CustomColor.white, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: CustomColor.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context, User? user) {
    return user != null
        ? GestureDetector(
            onTap: () => Beamer.of(context).beamToNamed('/profile'),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: _getAvatarImage(user),
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${user.name}',
                  style: const TextStyle(
                      color: CustomColor.textDarkGray, fontSize: 14),
                ),
              ],
            ),
          )
        : Row(
            children: [
              TextButton(
                onPressed: () => showLoginDialog(context),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: CustomColor.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () => Beamer.of(context).beamToNamed('/register'),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    color: CustomColor.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          );
  }

  ImageProvider _getAvatarImage(User user) {
    return (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
        ? NetworkImage(user.avatarUrl!) as ImageProvider
        : const AssetImage('assets/images/default_avatar.png');
  }
}
