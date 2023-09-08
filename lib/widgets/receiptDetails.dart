import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:OilEnergy_System/API/reciept.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class ReceiptDetails extends StatefulWidget {
  String reciept_id;
  ReceiptDetails({super.key, required this.reciept_id});

  @override
  State<ReceiptDetails> createState() => _ReceiptDetailsState(reciept_id: reciept_id);
}

class _ReceiptDetailsState extends State<ReceiptDetails> {
  String reciept_id;
  _ReceiptDetailsState({required this.reciept_id});

  SidebarXController controller = SidebarXController(selectedIndex: 6, extended: true);

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  Map data = {};
  String? company;
  String? source;
  String? driver;
  String? car_plate;
  String? fuel_type;
  String? shortage;
  String? amount;
  DateTime? ship_date;
  DateTime? arrive_date;

  @override
  void initState() {
    super.initState();
    getById();
  }

  //server side function
  Future getById () async {
    setState(() {
      isLoading = true;
    });

    //send to server
    var datas = {};
    datas['reciept_id'] = reciept_id;
    final auth = await SharedServices.LoginDetails();
    final response = await API_Reciept.GetById(datas, auth.token);

    if(response != false){
      setState(() {
        isLoading = false;
        data = response;
      });
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }
  //on submit
  Future _OnSubmit(data) async {
    setState(() {
      isLoading = true;
    });

    //call backend
    final auth = await SharedServices.LoginDetails();

    API_Reciept.Update(data, auth.token).then((response){
      setState(() {
        isLoading = false;
      });
      if(response == true){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تحديث الايصال بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
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

    getById();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APPBAR(context),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Navbar(controller: controller,),
            Expanded(child: SingleChildScrollView(
              child:
                data.length != 0?
                FormBuilder(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: FormBuilderTextField(
                                      name: "company",
                                      decoration: InputDecoration(
                                          labelText: 'اسم الشركة',
                                          suffixIcon: Icon(Icons.home_work, color: Colors.blueAccent,)
                                      ),
                                      initialValue: data['company'],
                                      onChanged: (val){
                                        company = val;
                                      },
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: FormBuilderTextField(
                                      name: "source",
                                      decoration: InputDecoration(
                                          labelText: 'مصدر الوقود',
                                          suffixIcon: Icon(Icons.location_on, color: Colors.blueAccent,)
                                      ),
                                      initialValue: data['source'],
                                      onChanged: (val){
                                        source = val;
                                      },
                                      validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                    ),
                                  ),
                                ],
                              ),
                          SizedBox(height: 40,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 300,
                                child: FormBuilderDateTimePicker(
                                  name: 'ship_date',
                                  decoration: InputDecoration(
                                      labelText: 'تاريخ الشحن',
                                      suffixIcon: Icon(Icons.calendar_month,  color: Colors.blueAccent)
                                  ),
                                  initialValue: DateTime.tryParse(data['ship_date'])!.toLocal(),
                                  onChanged: (val){
                                    ship_date = val;
                                  },
                                  validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                  initialDate: DateTime.now(),
                                ),
                              ),
                              SizedBox(
                                width: 300,
                                child: FormBuilderDateTimePicker(
                                  name: 'arrive_date',
                                  decoration: InputDecoration(
                                      labelText: 'تاريخ الوصول',
                                      suffixIcon: Icon(Icons.calendar_month,  color: Colors.blueAccent)
                                  ),
                                  onChanged: (val){
                                    arrive_date = val;
                                  },
                                  initialValue: DateTime.tryParse(data['arrive_date'])!.toUtc(),
                                  validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                  initialDate: DateTime.now(),

                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30,),
                          // Add a dropdown field
                          FormBuilderDropdown(
                            name: 'fuel_type',
                            decoration: InputDecoration(labelText: 'نوع الوقود'),
                            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                            onChanged: (val){
                              fuel_type = val as String?;
                            },
                            initialValue: data['fuel_type'],
                            items: ['بنزين', 'جازولين']
                                .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text('$type'),
                            ))
                                .toList(),
                          ),
                          FormBuilderTextField(
                            name: "shortage",
                            decoration: InputDecoration(
                                labelText: 'عجز العربة',
                                suffixIcon: Icon(Icons.gas_meter_outlined, color: Colors.blueAccent,)
                            ),
                            initialValue: data['shortage'].toString(),
                            onChanged: (val){
                              shortage = val;
                            },
                            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                          ),
                          FormBuilderTextField(
                            name: "amount",
                            decoration: InputDecoration(
                                labelText: 'كمية الوقود',
                                suffixIcon: Icon(Icons.gas_meter_outlined, color: Colors.blueAccent,)
                            ),
                            initialValue: data['amount'].toString(),
                            onChanged: (val){
                              amount = val;
                            },
                            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                          ),
                         SizedBox(height: 50,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 300,
                                child: FormBuilderTextField(
                                  name: "driver",
                                  decoration: InputDecoration(
                                      labelText: 'السائق',
                                      suffixIcon: Icon(Icons.person, color: Colors.blueAccent,)
                                  ),
                                  initialValue: data['driver'],
                                  onChanged: (val){
                                    driver = val;
                                  },
                                  validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                ),
                              ),
                              SizedBox(
                                width: 300,
                                child: FormBuilderTextField(
                                  name: "car_plate",
                                  decoration: InputDecoration(
                                      labelText: 'رقم اللوحة',
                                      suffixIcon: Icon(Icons.car_crash_outlined, color: Colors.blueAccent,)
                                  ),
                                  initialValue: data['car_plate'],
                                  onChanged: (val){
                                    car_plate = val;
                                  },
                                  validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40,),
                          SizedBox(
                            height: 45,
                            width: 200,
                            child: ElevatedButton(
                              onPressed: (){
                                if(_formKey.currentState!.saveAndValidate()){
                                  //call to server

                                  final datac = {};
                                  datac['reciept_id'] = reciept_id;
                                  datac['company'] = _formKey.currentState!.value['company'];
                                  datac['source'] = _formKey.currentState!.value['source'];
                                  datac['driver'] = _formKey.currentState!.value['driver'];
                                  datac['car_plate'] = _formKey.currentState!.value['car_plate'];
                                  datac['fuel_type'] = _formKey.currentState!.value['fuel_type'];
                                  datac['shortage'] = _formKey.currentState!.value['shortage'];
                                  datac['amount'] = _formKey.currentState!.value['amount'];
                                  datac['ship_date'] = _formKey.currentState!.value['ship_date']!.toIso8601String();
                                  datac['arrive_date'] = _formKey.currentState!.value['arrive_date']!.toIso8601String();

                                  //server
                                  _OnSubmit(datac);
                                }
                              },
                              child: Text('تحديث'),
                              style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 18)
                              ),
                            ),
                          )
                        ],
                      ),
                    )): Center(child: Text('data not found'),)
            )
            )
          ],
        ),
      ),
    );
  }
}
