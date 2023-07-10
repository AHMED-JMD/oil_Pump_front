class Gas {
  Gas({
    required this.ID,
    required this.type,
    required this.d_gas,
    required this.trans_gas,
    required this.total,
    required this.comment,
    required this.date
  });
  late final String ID;
  late final String type;
  late final String d_gas;
  late final String trans_gas;
  late final String total;
  late final String comment;
  late final String date;

  Gas.fromJson(Map<String, dynamic> json){
    ID = json['ID'];
    type = json['type'];
    d_gas = json['d_gas'];
    trans_gas = json['trans_gas'];
    total = json['total'];
    comment = json['comment'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    _data['type'] = type;
    _data['d_gas'] = d_gas;
    _data['trans_gas'] = trans_gas;
    _data['total'] = total;
    _data['comment'] = comment;
    _data['date'] = date;
    return _data;
  }
}

List<Gas> DailyData = [
  Gas(ID: "ID", type: "جاز", d_gas: "5230 لبر", trans_gas: "15000 لتر", total: "22370 لتر",comment: "تعليق جديد", date: "5-7-2023")
];