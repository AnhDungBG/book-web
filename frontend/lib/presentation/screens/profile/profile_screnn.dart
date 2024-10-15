import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/auth/auth_bloc.dart';
import 'package:flutter_web_fe/blocs/auth/auth_event.dart';
import 'package:flutter_web_fe/blocs/auth/auth_state.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';
import 'package:flutter_web_fe/core/data/models/auth_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() {
    BlocProvider.of<AuthBloc>(context).add(GetUserInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return _buildProfileContent(state.user);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildProfileContent(User user) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                _buildHeader(user),
                _buildBody(context, user),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(User user) {
    return Stack(
      children: [
        Container(
          height: 300,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                CustomColor.primaryBlue,
                CustomColor.secondBlue,
              ],
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Positioned(
          left: 50,
          bottom: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : const AssetImage('assets/default_avatar.png')
                        as ImageProvider,
              ),
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.name ?? 'Không có tên',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.username ?? 'Không có username',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 50,
          bottom: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              // Xử lý khi nhấn nút chỉnh sửa
            },
            icon: const Icon(Icons.edit),
            label: const Text('Chỉnh sửa hồ sơ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: CustomColor.secondBlue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Thông tin cá nhân'),
                _buildInfoCard(context, user),
                const SizedBox(height: 30),
                _buildSectionTitle('Hoạt động'),
                _buildActivityCard(context),
              ],
            ),
          ),
          const SizedBox(width: 50),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Cài đặt'),
                _buildSettingsCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, User user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.email, 'Email',
                user.email?.isNotEmpty == true ? user.email! : 'Chưa cập nhật'),
            _buildInfoRow(
                Icons.phone,
                'Số điện thoại',
                user.phoneNumber?.isNotEmpty == true
                    ? user.phoneNumber!
                    : 'Chưa cập nhật'),
            _buildInfoRow(
                Icons.location_on,
                'Địa chỉ',
                user.address?.isNotEmpty == true
                    ? user.address!
                    : 'Chưa cập nhật'),
            _buildInfoRow(
                Icons.cake,
                'Ngày sinh',
                user.dateOfBirth != null
                    ? '${user.dateOfBirth!.day}/${user.dateOfBirth!.month}/${user.dateOfBirth!.year}'
                    : 'Chưa cập nhật'),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          _buildActivityTile(
              context, Icons.shopping_bag, 'Đơn hàng của tôi', '5 đơn hàng',
              () {
            Beamer.of(context).beamToNamed('/my-order');
          }),
          _buildActivityTile(
              context, Icons.favorite, 'Sản phẩm yêu thích', '12 sản phẩm', () {
            Beamer.of(context).beamToNamed('/my-favorite-book');
          }),
          _buildActivityTile(
              context, Icons.star, 'Đánh giá của tôi', '8 đánh giá', () {}),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          _buildSettingsTile(
            context,
            Icons.notifications,
            'Thông báo',
          ),
          _buildSettingsTile(context, Icons.lock, 'Quyền riêng tư'),
          _buildSettingsTile(context, Icons.help, 'Trợ giúp & Hỗ trợ'),
          _buildSettingsTile(context, Icons.logout, 'Đăng xuất',
              isLogout: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: CustomColor.secondBlue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(BuildContext context, IconData icon, String title,
      String subtitle, VoidCallback onTap) {
    return ListTile(
        leading: Icon(icon, color: CustomColor.secondBlue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap);
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title,
      {bool isLogout = false}) {
    return ListTile(
      leading:
          Icon(icon, color: isLogout ? Colors.red : CustomColor.secondBlue),
      title: Text(title, style: TextStyle(color: isLogout ? Colors.red : null)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () async {
        if (isLogout) {
          // Xử lý đăng xuất
          final authBloc = BlocProvider.of<AuthBloc>(context);
          await authBloc.logout();
          // Sử dụng Beamer để điều hướng về trang chủ
          // ignore: use_build_context_synchronously
          Beamer.of(context).beamToNamed('/');
        } else {
          // Xử lý các cài đặt khác
        }
      },
    );
  }
}
