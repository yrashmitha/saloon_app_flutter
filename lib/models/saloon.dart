
class Saloon{
  String id;
  String name;
  Map<dynamic,dynamic> featuredImageUrl;
  String description;
  String baseLocation;
  String address;
  String gender;
  String contactNumber;
  int appointmentInterval;
  Map additionalData;
  int openTime;
  int closeTime;
  List<dynamic> closedDays;
  double rating;
  int ratingsCount;
  List<dynamic> services;
  List<dynamic> smallGallery;
  List<dynamic> reviews;


  Saloon(this.id, this.name, this.featuredImageUrl, this.description,
      this.baseLocation, this.address, this.gender,this.contactNumber, this.additionalData,this.openTime,this.closeTime,
      this.closedDays,this.rating,this.ratingsCount,this.appointmentInterval, this.services,this.smallGallery,this.reviews);
}