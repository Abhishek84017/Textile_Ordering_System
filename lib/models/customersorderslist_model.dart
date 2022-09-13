class CustomersOrdersListModel {
  int? id;
  int? orderNumber;
  int? customerId;
  String? orderDate;
  String? status;
  String? inserted;
  int? insertedBy;
  dynamic modified;
  dynamic modifiedBy;

  CustomersOrdersListModel(
      {this.id,
        this.orderNumber,
        this.customerId,
        this.orderDate,
        this.status,
        this.inserted,
        this.insertedBy,
        this.modified,
        this.modifiedBy});

  CustomersOrdersListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    customerId = json['customer_id'];
    orderDate = json['order_date'];
    status = json['status'];
    inserted = json['inserted'];
    insertedBy = json['inserted_by'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    data['customer_id'] = this.customerId;
    data['order_date'] = this.orderDate;
    data['status'] = this.status;
    data['inserted'] = this.inserted;
    data['inserted_by'] = this.insertedBy;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    return data;
  }
}