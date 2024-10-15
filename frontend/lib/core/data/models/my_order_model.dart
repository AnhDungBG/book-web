class Order {
  final int id;
  final int khachhang;
  final String ngaydat;
  final String noigiao;
  final bool trangthaiThanhtoan;
  final String httt;
  final String dienthoai;
  final int sanpham;
  final int soluong;
  final String dongia;

  Order({
    required this.id,
    required this.khachhang,
    required this.ngaydat,
    required this.noigiao,
    required this.trangthaiThanhtoan,
    required this.httt,
    required this.dienthoai,
    required this.sanpham,
    required this.soluong,
    required this.dongia,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      khachhang: json['khachhang'],
      ngaydat: json['ngaydat'],
      noigiao: json['noigiao'],
      trangthaiThanhtoan: json['trangthai_thanhtoan'],
      httt: json['httt'],
      dienthoai: json['dienthoai'],
      sanpham: json['sanpham'],
      soluong: json['soluong'],
      dongia: json['dongia'],
    );
  }
}
