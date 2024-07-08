import 'package:OilEnergy_System/components/MoneyFormatter.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/gas.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:OilEnergy_System/components/tables/gasoline_table.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sidebarx/sidebarx.dart';

class Gasolines extends StatefulWidget {
  const Gasolines({super.key});

  @override
  State<Gasolines> createState() => _GasolinesState();
}

class _GasolinesState extends State<Gasolines> {
  SidebarXController controller = SidebarXController(selectedIndex: 3, extended: true);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool isLoading = false;
  List data = [];
  int avail_benz = 0;
  int avail_gas = 0;
  DateTime now = DateTime.now();

  @override
  void initState() {
    getAllGas();
    super.initState();
  }
  //server side Functions ------------------
  //------get--
  Future getAllGas () async {
    setState(() {
      isLoading = true;
    });
    //post to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Gas.Get_All_Gas(auth.token,);

    response != false ?
    setState(() {
      isLoading = false;
      data = response['gas'];
      avail_benz = response['available_benz'];
      avail_gas = response['available_gas'];
    }) : setState(() {
      isLoading = false;
      data = [];
      avail_benz = 0;
      avail_gas = 0;
    });

  }
  //on Submit
  Future _OnSubmit(datas) async {
    setState(() {
      isLoading = true;
    });

    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Gas.Find_Gas(datas, auth.token);

    if(response != false){
      setState(() {
        isLoading = false;
        data = response;
      });
    }
  }
  //search dates
  Future Search(datas) async {
    setState(() {
      isLoading = true;
    });

    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Gas.Search(datas, auth.token);

    if(response != false){
      setState(() {
        isLoading = false;
        data = response;
      });
    }
  }

  String numCheck (int number) {
    if(number < 10){
      return '0$number';
    }else{
      return '$number';
    }
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
                Navbar(controller: controller),
              ],
            ),
            Expanded(
                child: ListView(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/Curve_Line.png'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.difference),
                          ),
                      ),
                      child: Center(child: Text('حالة الوقود', style: TextStyle(fontSize: 26, color: Colors.white), textAlign: TextAlign.center,)),
                    ),
                    SizedBox(height: 80,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        data.length != 0 ?
                        Container(
                            color: Colors.grey.shade100,
                            child: Column(
                              children: [
                                FormBuilder(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0, right: 20),
                                              child: Container(
                                                width: MediaQuery.of(context).size.width/3.2,
                                                child: FormBuilderDateTimePicker(
                                                  name: "date",
                                                  onChanged: (value){},
                                                  decoration: InputDecoration(
                                                      labelText: "اختر اليوم",
                                                  ),
                                                  validator: FormBuilderValidators.required(errorText: "الرجاء اختيار تاريخ محدد"),
                                                  initialDate: DateTime.now(),
                                                  inputType: InputType.date,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            // Add a submit button
                                            IconButton(
                                              onPressed: (){
                                                if(_formKey.currentState!.saveAndValidate()){
                                                  //send to server
                                                  Map datas = {};
                                                  datas['date'] = _formKey.currentState!.value['date'].toIso8601String();

                                                  _OnSubmit(datas);
                                                  setState(() {
                                                    data = [];
                                                  });
                                                }
                                              },
                                              icon: Icon(Icons.search, size: 30,),
                                            ),
                                            SizedBox(width: 20,),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: TextButton.icon(
                                                onPressed: () {
                                                  getAllGas();
                                                  setState(() {
                                                    data = [];
                                                  });
                                                },
                                                style: TextButton.styleFrom(
                                                    backgroundColor: Colors.grey[300],
                                                    minimumSize: Size(70, 50)
                                                ),
                                                label: Text('الكل', style: TextStyle(color: Colors.black, fontSize: 17),),
                                                icon: const Icon(Icons.person_search_outlined, size: 30, color: Colors.red,),
                                              ),
                                            ),
                                            SizedBox(width: 40,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: Container(
                                                    width: 130,
                                                    child: DropdownButtonFormField(
                                                        decoration: InputDecoration(
                                                            labelText: 'الفترة',
                                                            suffixIcon: Icon(Icons.date_range_outlined, color: Colors.blue,),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            )
                                                        ),
                                                        items: [
                                                          DropdownMenuItem(child: Text('شهر'), value: 'month',),
                                                          DropdownMenuItem(child: Text('اسبوع'), value: 'week',),
                                                          DropdownMenuItem(child: Text('يوم'), value: 'day',),
                                                        ],
                                                        onChanged: (val){
                                                          if(val == 'month'){
                                                            //custom start date to get data from beginning of the month till now
                                                            String startDate = '${now.year}-${numCheck(now.month)}-01';
                                                            String endDate = '${now.year}-${numCheck(now.month)}-${numCheck(now.day)}';
                                                            //call server
                                                            Map thedata = {};
                                                            thedata['start_date'] = startDate;
                                                            thedata['end_date'] = endDate;
                                                            //call server
                                                            Search(thedata);
                                                            setState(() {
                                                              data = [];
                                                            });

                                                          } else if(val == 'week'){
                                                            //custom start date for week
                                                            DateTime startDate = now.subtract(Duration(days: 7));
                                                            //call server
                                                            Map thedata = {};
                                                            thedata['start_date'] = startDate.toIso8601String();
                                                            thedata['end_date'] = now.toIso8601String();
                                                            //call server
                                                            Search(thedata);
                                                            setState(() {
                                                              data = [];
                                                            });

                                                          }else {
                                                            //call server
                                                            Map thedata = {};
                                                            thedata['start_date'] = now.toIso8601String();
                                                            thedata['end_date'] = now.toIso8601String();
                                                            //call server
                                                            Search(thedata);
                                                            setState(() {
                                                              data = [];
                                                            });
                                                          }
                                                        }
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                ),
                                GasolineTable(data: data,),
                                Padding(
                                  padding:  EdgeInsets.only(left: 40.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('متبقي بئر البنزين = ${myFormat(avail_benz)} لتر',
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
                                      ),
                                      SizedBox(width: 35,),
                                      Text('متبقي بئر الجازولين = ${myFormat(avail_gas)} لتر',
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20,)
                              ],
                            )
                        ) : Column(
                          children: [
                            FormBuilder(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0, right: 20),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width/3.2,
                                            child: FormBuilderDateTimePicker(
                                              name: "date",
                                              onChanged: (value){},
                                              decoration: InputDecoration(
                                                labelText: "اختر اليوم",
                                              ),
                                              validator: FormBuilderValidators.required(errorText: "الرجاء اختيار تاريخ محدد"),
                                              initialDate: DateTime.now(),
                                              inputType: InputType.date,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        // Add a submit button
                                        IconButton(
                                          onPressed: (){
                                            if(_formKey.currentState!.saveAndValidate()){
                                              //send to server
                                              Map datas = {};
                                              datas['date'] = _formKey.currentState!.value['date'].toIso8601String();

                                              _OnSubmit(datas);
                                              setState(() {
                                                data = [];
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.search, size: 30,),
                                        ),
                                        SizedBox(width: 20,),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: TextButton.icon(
                                            onPressed: () {
                                              getAllGas();
                                              setState(() {
                                                data = [];
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors.grey[300],
                                                minimumSize: Size(70, 50)
                                            ),
                                            label: Text('الكل', style: TextStyle(color: Colors.black, fontSize: 17),),
                                            icon: const Icon(Icons.person_search_outlined, size: 30, color: Colors.red,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            ),
                            SizedBox(width: 40,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, right: 20),
                                  child: Container(
                                    width: 130,
                                    child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                            labelText: 'الفترة',
                                            suffixIcon: Icon(Icons.date_range_outlined, color: Colors.blue,),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            )
                                        ),
                                        items: [
                                          DropdownMenuItem(child: Text('شهر'), value: 'month',),
                                          DropdownMenuItem(child: Text('اسبوع'), value: 'week',),
                                          DropdownMenuItem(child: Text('يوم'), value: 'day',),
                                        ],
                                        onChanged: (val){
                                          if(val == 'month'){
                                            //custom start date to get data from beginning of the month till now
                                            String startDate = '${now.year}-${numCheck(now.month)}-01';
                                            String endDate = '${now.year}-${numCheck(now.month)}-${numCheck(now.day)}';
                                            //call server
                                            Map thedata = {};
                                            thedata['start_date'] = startDate;
                                            thedata['end_date'] = endDate;
                                            //call server
                                            Search(thedata);
                                            setState(() {
                                              data = [];
                                            });

                                          } else if(val == 'week'){
                                            //custom start date for week
                                            DateTime startDate = now.subtract(Duration(days: 7));
                                            //call server
                                            Map thedata = {};
                                            thedata['start_date'] = startDate.toIso8601String();
                                            thedata['end_date'] = now.toIso8601String();
                                            //call server
                                            Search(thedata);
                                            setState(() {
                                              data = [];
                                            });

                                          }else {
                                            //call server
                                            Map thedata = {};
                                            thedata['start_date'] = now.toIso8601String();
                                            thedata['end_date'] = now.toIso8601String();
                                            //call server
                                            Search(thedata);
                                            setState(() {
                                              data = [];
                                            });
                                          }
                                        }
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            GasolineTable(data: data),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 50,),
                  ]
                )
            ) 
          ],
        ),
      ),
    );
  }
}
