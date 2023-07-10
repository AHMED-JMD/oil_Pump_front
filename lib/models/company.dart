class Company {
  Company({
    required this.ID,
    required this.company,
    required this.fname,
    required this.lname,
    required this.phone,
  });
  late final String ID;
  late final String company;
  late final String fname;
  late final String lname;
  late final String phone;

  Company.fromJson(Map<String, dynamic> json){
    ID = json['ID'];
    company = json['company'];
    fname = json['fname'];
    lname = json['lname'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    _data['company'] = company;
    _data['fname'] = fname;
    _data['lname'] = lname;
    _data['phone'] = phone;
    return _data;
  }
}

List<Company> CompanyData = [
  Company(ID: 'ID', company: 'company', fname: 'fname', lname: 'lname', phone: 'phone'),
  Company(ID: 'ID2', company: 'company2', fname: 'fname2', lname: 'lname2', phone: 'phone2'),
  Company(ID: 'ID3', company: 'company2', fname: 'fname2', lname: 'lname2', phone: 'phone2'),
  Company(ID: 'ID4', company: 'company2', fname: 'fname2', lname: 'lname2', phone: 'phone2'),
  Company(ID: 'ID5', company: 'company2', fname: 'fname2', lname: 'lname2', phone: 'phone2')
];