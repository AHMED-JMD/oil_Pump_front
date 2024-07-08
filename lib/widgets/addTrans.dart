import 'package:OilEnergy_System/API/transaction.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/API/client.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sidebarx/sidebarx.dart';

class AddDaily extends StatefulWidget {
  const AddDaily({Key? key}) : super(key: key);

  @override
  State<AddDaily> createState() => _AddDailyState();
}

class _AddDailyState extends State<AddDaily> {
  SidebarXController controller = SidebarXController(selectedIndex: 0, extended: true);

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  DateTime? nw_date;
  String? emp_id;
  String? type;
  String? gas_type;
  String? gas_amount;
  String? price;
  String? comment = 'خصم جازولين';
  List clients = [];

  @override
  void initState() {
    super.initState();
    GetClients();
  }

  @override
  void dispose() {
    super.dispose();
  }
//server side functions
  //on submit form
  Future _OnSubmit(data) async{
    setState(() {
      isLoading = true;
    });

    final auth = await SharedServices.LoginDetails();

    API_Trans.Add_Trans(data, auth.token).then((response){
      setState(() {
        isLoading = false;
      });
      if(response == true){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم اضافة اليومية بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
            backgroundColor: Colors.green,
          ),
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$response', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
  //get clients data
  Future GetClients() async {
    setState(() {
      isLoading = true;
    });

    //get data
    final auth = await SharedServices.LoginDetails();
    final response = await API_Client.getClients(auth.token);

      setState(() {
        clients = response;
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: APPBAR(context),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              Row(
                children: [
                  Navbar(controller: controller,)
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                        child:  Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: FormBuilder(
                                // Define the form key to identify the form
                                key: _formKey,
                                // Define the form fields
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      child: Icon(Icons.edit_calendar_outlined),
                                      radius: 50,
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                    // Add a text field
                                    FormBuilderDropdown(
                                      name: 'name',
                                      decoration: InputDecoration(labelText: 'اختر العميل'),
                                      onChanged: (val) {
                                        emp_id = val; // Print the text value write into TextField
                                      },
                                      items: clients
                                       .map((client) => DropdownMenuItem(
                                          value: client['emp_id'].toString(),
                                          child: Text('${client['name']}')
                                      )).toList(),
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                    ),
                                    FormBuilderDropdown(
                                      name: 'type',
                                      decoration: InputDecoration(labelText: 'الحالة'),
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                      onChanged: (val) {
                                          type = val;// Print the text value write into TextField
                                      },
                                      items: ['عليه','له']
                                          .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Text('$type'),
                                      ))
                                          .toList(),
                                    ),
                                    FormBuilderDropdown(
                                      name: 'gas_type',
                                      decoration: InputDecoration(labelText: 'نوع الوقود'),
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                      onChanged: (val) {
                                        gas_type = val; // Print the text value write into TextField
                                      },
                                      items: ['بنزين', 'جازولين',]
                                          .map((type) => DropdownMenuItem(
                                            value: type,
                                            child: Text('$type'),
                                          ))
                                              .toList(),
                                        ),
                                    FormBuilderTextField(
                                          name: 'gas_amount',
                                          decoration: InputDecoration(
                                              labelText: 'كمية الوقود باللتر',
                                              suffixIcon: Icon(Icons.gas_meter, color: Colors.blueAccent,)
                                          ),
                                          onChanged: (val) {
                                            gas_amount = val; // Print the text value write into TextField
                                          },
                                          validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                        ),
                                    FormBuilderTextField(
                                      name: 'price',
                                      decoration: InputDecoration(
                                          labelText: 'سعر اللتر',
                                          suffixIcon: Icon(Icons.gas_meter, color: Colors.blueAccent,)
                                      ),
                                      onChanged: (val) {
                                        price = val; // Print the text value write into TextField
                                      },
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                    ),
                                    FormBuilderDateTimePicker(
                                          name: 'date',
                                          decoration: InputDecoration(
                                              labelText: 'التاريخ',
                                              suffixIcon: Icon(Icons.calendar_month, color: Colors.blueAccent,)
                                          ),
                                          onChanged: (value){
                                            nw_date = value;
                                          },
                                          validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                          initialDate: DateTime.now(),
                                          inputType: InputType.date,
                                        ),
                                    FormBuilderTextField(
                                          name: 'comment',
                                          decoration: InputDecoration(
                                              labelText: 'البيان',
                                              suffixIcon: Icon(Icons.comment, color: Colors.blueAccent,)
                                          ),
                                          onChanged: (val) {
                                            comment = val; // Print the text value write into TextField
                                          },
                                          initialValue: "خصم جازولين",
                                          validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                        ), // Add another text field
                                    SizedBox(height: 40,),
                                    // Add a submit button
                                    SizedBox(
                                      width: 300,
                                      height: 50,
                                      child: ElevatedButton(
                                        child: Text('ارسال', style: TextStyle(color: Colors.white, fontSize: 18)),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!.saveAndValidate()) {
                                            //call to backend
                                            nw_date = _formKey.currentState!.value['date'];
                                            Map data = {};
                                            data['emp_id'] = emp_id;
                                            data['type'] = type;
                                            data['gas_type'] = gas_type;
                                            data['gas_amount'] = gas_amount;
                                            data['price'] = price;
                                            data['date'] = nw_date!.toIso8601String();
                                            data['comment'] = _formKey.currentState!.value['comment'];

                                            //------
                                             _OnSubmit(data);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                    ),
                  ),
              )
            ],
          ),
        )
    );
  }
}
