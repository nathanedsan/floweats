class Sellers {
  String? sellerUID;
  String? sellerName;
  String? sellerAvatarUrl;
  String? sellerEmail;
  String? Address;
  double? Lat; // Change to double
  double? Lng; // Change to double
  String? phone;

  Sellers({
    this.sellerUID,
    this.sellerName,
    this.sellerAvatarUrl,
    this.sellerEmail,
    this.Address,
    this.Lat,
    this.Lng,
    this.phone,
  });

  Sellers.fromJson(Map<String, dynamic> json) {
    sellerUID = json["sellerUID"];
    sellerName = json["sellerName"];
    sellerAvatarUrl = json["sellerAvatarUrl"];
    sellerEmail = json["sellerEmail"];
    Address = json["Address"];
    Lat = json['Lat'];
    Lng = json['Lng'];
    phone = json["phone"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["sellerUID"] = this.sellerUID;
    data["sellerName"] = sellerName;
    data["sellerAvatarUrl"] = sellerAvatarUrl;
    data["sellerEmail"] = this.sellerEmail;
    data["Address"] = this.Address;
    data["Lat"] = this.Lat;
    data["Lng"] = this.Lng;
    data["phone"]= this.phone;
    return data;
  }
}
