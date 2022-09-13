class CustomersModel {
  int? id;
  String? name;
  String?      email;
  String? mobile;
  String? address;
  String? contactPerson;
  dynamic companyContact;
  dynamic companyEmail;
  String? companyName;
  String? status;
  String? inserted;
  int? insertedBy;
  dynamic modified;
  dynamic modifiedBy;

  CustomersModel(
      {this.id,
        this.name,
        this.email,
        this.mobile,
        this.address,
        this.contactPerson,
        this.companyContact,
        this.companyEmail,
        this.companyName,
        this.status,
        this.inserted,
        this.insertedBy,
        this.modified,
        this.modifiedBy});

  CustomersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    address = json['address'];
    contactPerson = json['contact_person'];
    companyContact = json['company_contact'];
    companyEmail = json['company_email'];
    companyName = json['company_name'];
    status = json['status'];
    inserted = json['inserted'];
    insertedBy = json['inserted_by'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['address'] = address;
    data['contact_person'] = contactPerson;
    data['company_contact'] = companyContact;
    data['company_email'] = companyEmail;
    data['company_name'] = companyName;
    data['status'] = status;
    data['inserted'] = inserted;
    data['inserted_by'] = insertedBy;
    data['modified'] = modified;
    data['modified_by'] = modifiedBy;
    return data;
  }
}