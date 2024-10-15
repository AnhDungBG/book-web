import 'package:flutter/material.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';
import 'package:flutter_web_fe/presentation/components/header_desktop.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderDesktop(),
            _buildHeader(),
            _buildStorySection(context),
            _buildMissionSection(context),
            _buildValuesSection(context),
            _buildServicesSection(context), // Thêm phần mới này
            _buildTeamSection(context),
            _buildContactSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 400,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bookstore.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
          child: const Center(
            child: Text(
              'Về Chúng Tôi',
              style: TextStyle(
                color: CustomColor.secondBlue,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStorySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Câu chuyện của chúng tôi'),
          const SizedBox(height: 20),
          const Text(
            'Được thành lập vào năm 2010, Hiệu sách Trí Tuệ bắt đầu như một cửa hàng sách nhỏ với niềm đam mê chia sẻ kiến thức. Qua hơn một thập kỷ, chúng tôi đã phát triển thành một trong những hiệu sách trực tuyến hàng đầu, mang đến cho độc giả trải nghiệm mua sắm sách thuận tiện và đa dạng.',
            style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionSection(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Sứ mệnh'),
          const SizedBox(height: 24),
          const Text(
            'Sứ mệnh của chúng tôi là truyền cảm hứng và nuôi dưỡng tình yêu đọc sách, đồng thời cung cấp cho độc giả những cuốn sách chất lượng với giá cả phải chăng. Chúng tôi cam kết hỗ trợ cộng đồng đọc sách và thúc đẩy việc học tập suốt đời.',
            style: TextStyle(fontSize: 18, height: 1.8, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildValuesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Giá trị cốt lõi'),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: _buildValueCard('Chất lượng', Icons.star_outline,
                      'Cam kết cung cấp sách chất lượng cao')),
              const SizedBox(width: 24),
              Expanded(
                  child: _buildValueCard('Đa dạng', Icons.category_outlined,
                      'Đa dạng thể loại sách cho mọi độc giả')),
              const SizedBox(width: 24),
              Expanded(
                  child: _buildValueCard('Dịch vụ', Icons.support_agent,
                      'Hỗ trợ khách hàng tận tâm')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Dịch vụ của chúng tôi'),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                  child: _buildServiceCard('Đa dạng sách', Icons.menu_book,
                      'Hơn 100,000 đầu sách từ nhiều thể loại khác nhau')),
              const SizedBox(width: 20),
              Expanded(
                  child: _buildServiceCard(
                      'Giao hàng toàn quốc',
                      Icons.local_shipping_outlined,
                      'Giao sách đến tận nhà trên khắp 63 tỉnh thành')),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _buildServiceCard(
                      'Tư vấn chọn sách',
                      Icons.support_agent,
                      'Đội ngũ chuyên gia sẵn sàng tư vấn 24/7')),
              const SizedBox(width: 20),
              Expanded(
                  child: _buildServiceCard(
                      'Ưu đãi hấp dẫn',
                      Icons.card_giftcard,
                      'Chương trình khuyến mãi và tích điểm thường xuyên')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Đội ngũ của chúng tôi'),
          const SizedBox(height: 24),
          const Text(
            'Đội ngũ của chúng tôi gồm những người yêu sách, có kinh nghiệm trong ngành xuất bản và bán lẻ. Chúng tôi luôn sẵn sàng tư vấn và hỗ trợ bạn tìm được những cuốn sách phù hợp nhất.',
            style: TextStyle(fontSize: 18, height: 1.8, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Liên hệ'),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildContactInfo(
                  Icons.email_outlined, 'Email', 'info@tritue.com'),
              _buildContactInfo(
                  Icons.phone_outlined, 'Điện thoại', '1900 1234'),
              _buildContactInfo(Icons.location_on_outlined, 'Địa chỉ',
                  'Số 123 Đường ABC, Hà Nội'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard(String title, IconData icon, String description) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: CustomColor.secondBlue),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String title, String content) {
    return Column(
      children: [
        Icon(icon, color: CustomColor.secondBlue, size: 40),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: CustomColor.secondBlue,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, String description) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, size: 36, color: CustomColor.secondBlue),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style:
                  TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
