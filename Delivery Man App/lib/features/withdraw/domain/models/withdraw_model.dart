class WithdrawModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<Withdraws>? withdraws;

  WithdrawModel({this.totalSize, this.limit, this.offset, this.withdraws});

  WithdrawModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['withdraws'] != null) {
      withdraws = <Withdraws>[];
      json['withdraws'].forEach((v) {
        withdraws!.add(Withdraws.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (withdraws != null) {
      data['withdraws'] = withdraws!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Withdraws {
  int? id;
  double? amount;
  String? transactionNote;
  String? proofOfPayment;
  String? createdAt;
  String? updatedAt;

  Withdraws(
      {this.id,
        this.amount,
        this.transactionNote,
        this.proofOfPayment,
        this.createdAt,
        this.updatedAt});

  Withdraws.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = double.parse(json['amount'].toString());
    transactionNote = json['transaction_note'];
    proofOfPayment = json['proof_of_payment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['transaction_note'] = transactionNote;
    data['proof_of_payment'] = proofOfPayment;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
