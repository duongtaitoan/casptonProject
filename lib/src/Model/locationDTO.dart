class LocationDTO{
  int id;
  bool active;
  String preferredName;
  int capacity;
  String address;
  String floor;
  String roomNumber;
  String latitude;
  String longitude;
  String createdAt;
  int createdBy;

  LocationDTO({this.id, this.preferredName, this.address, this.floor,this.roomNumber,this.latitude,this.longitude
              ,this.createdAt,this.active,this.capacity,this.createdBy,});
  factory LocationDTO.fromJson(Map<String, dynamic> json) => LocationDTO(
    id: json["id"],
    preferredName: json["preferredName"],
    address: json["address"],
    floor: json["floor"],
    roomNumber: json["roomNumber"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    createdAt: json["createdAt"],
    active: json["active"],
    capacity: json["capacity"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['preferredName'] = this.preferredName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['roomNumber'] = this.roomNumber;
    data['floor'] = this.floor;
    data['createdAt'] = this.createdAt;
    data['active'] = this.active;
    data['capacity'] = this.capacity;
    data['createdBy'] = this.createdBy;
    return data;
  }
}