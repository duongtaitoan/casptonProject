class EventsDTO{
  int id;
  String title;
  String hostName;
  String description;
  int maximumParticipant;
  String startTime;
  String endTime;
  String thumbnailPicture;
  String banner;
  bool gpsTrackingRequired;
  bool approvalRequired;
  String location;
  String startAcceptingRegistrationAt;
  String stopAcceptingRegistrationAt;
  String status;
  String checkInQrCode;
  int trackingInterval;
  String myRegistrationStatus;

  EventsDTO({
      this.id,
      this.title,
      this.hostName,
      this.description,
      this.maximumParticipant,
      this.startTime,
      this.banner,
      this.location,
      this.endTime,
      this.gpsTrackingRequired,
      this.approvalRequired,
      this.status,
      this.thumbnailPicture,
      this.checkInQrCode,
      this.trackingInterval,
      this.myRegistrationStatus,
      this.startAcceptingRegistrationAt,
      this.stopAcceptingRegistrationAt
  }); // DateTime timeStop;

  factory EventsDTO.fromJson(Map<String, dynamic> json) => EventsDTO(
    id: json["id"],
    title: json["title"],
    hostName: json["hostName"],
    description: json["description"],
    location: json["location"],
    endTime: json["endTime"],
    gpsTrackingRequired: json["gpsTrackingRequired"],
    approvalRequired: json["approvalRequired"],
    checkInQrCode: json["checkInQrCode"],
    startTime: json["startTime"],
    maximumParticipant:json["maximumParticipant"],
    stopAcceptingRegistrationAt:json["stopAcceptingRegistrationAt"],
    startAcceptingRegistrationAt: json["startAcceptingRegistrationAt"],
    trackingInterval: json["trackingInterval"],
    status: json["status"],
    thumbnailPicture: json["thumbnailPicture"],
    banner: json["banner"],
    myRegistrationStatus: json["myRegistrationStatus"],

  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['hostName'] = this.hostName;
    data['description'] = this.description;
    data['location'] = this.location;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['maximumParticipant'] = this.maximumParticipant;
    data['stopAcceptingRegistrationAt'] = this.stopAcceptingRegistrationAt;
    data['startAcceptingRegistrationAt'] = this.startAcceptingRegistrationAt;
    data['gpsTrackingRequired'] = this.gpsTrackingRequired;
    data['approvalRequired'] = this.approvalRequired;
    data['trackingInterval'] = this.trackingInterval;
    data['myRegistrationStatus'] = this.myRegistrationStatus;
    data['checkInQrCode'] = this.checkInQrCode;
    data['status'] = this.status;
    data['banner'] = this.banner;
    data['thumbnailPicture'] = this.thumbnailPicture;

    return data;
  }

}