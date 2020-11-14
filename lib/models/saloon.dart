
class Saloon{
  String id;
  String name;
  String featuredImageUrl;
  String description;
  String baseLocation;
  String address;
  String gender;
  int appointmentInterval;
  Map additionalData;
  List<dynamic> services;
  List<dynamic> smallGallery;
  List<dynamic> reviews;


  Saloon(this.id, this.name, this.featuredImageUrl, this.description,
      this.baseLocation, this.address, this.gender, this.additionalData,
      this.appointmentInterval, this.services,this.smallGallery,this.reviews);
}