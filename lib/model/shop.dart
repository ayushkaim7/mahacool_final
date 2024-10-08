class Shop {
  final String? id;
  final String? pname;
  final String? des;
  final int? aprice;
  final int? dprice;
  final String? pphoto;
  final String? pcat;

  const Shop(
      {this.id,
      this.aprice,
      this.pname,
      this.dprice,
      this.pphoto,
      this.des,
      this.pcat});

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json['_id'],
        aprice: json['aprice'],
        pname: json['name'],
        des: json["address"]["locality"],
        dprice: json['dprice'],
        pphoto: json['profilelink'],
        pcat: json['pcat'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'aprice': aprice,
        'pname': pname,
        'des': des,
        'dprice': dprice,
        'pphoto': pphoto,
        'pcat': pcat
      };
}
