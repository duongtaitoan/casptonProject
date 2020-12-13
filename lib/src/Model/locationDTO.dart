class LocationDTO{
  int id;
  String title;
  String address;
  String roomNumber;
  String floor;

  LocationDTO({this.id, this.title, this.address, this.roomNumber, this.floor});
  factory LocationDTO.fromJson(Map<String, dynamic> json) => LocationDTO(
    id: json["id"],
    title: json["title"],
    address: json["address"],
    roomNumber: json["roomNumber"],
    floor: json["floor"],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['address'] = this.address;
    data['roomNumber'] = this.roomNumber;
    data['floor'] = this.floor;
    return data;
  }
}