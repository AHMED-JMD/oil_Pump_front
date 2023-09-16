import 'package:OilEnergy_System/API/daily.dart';
import 'package:OilEnergy_System/API/employee.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:OilEnergy_System/components/tables/clientDetailsTable.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sidebarx/sidebarx.dart';

class EmployeeDetail extends StatefulWidget {
  final String id;
  EmployeeDetail({super.key, required this.id});

  @override
  State<EmployeeDetail> createState() => _EmployeeDetailState(id: id);
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  final String id;
  _EmployeeDetailState({required this.id});

  SidebarXController controller = SidebarXController(selectedIndex: 5, extended: true);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _SecondKey = GlobalKey<FormBuilderState>();

  bool isLoading = false;
  Map employe = {};
  List trans = [];

  @override
  void initState() {
    super.initState();
    getEmp();
  }

  //function to get the client and his transactions
  Future getEmp () async {
    setState(() {
      isLoading = true;
    });
    //send to server
    final auth = await SharedServices.LoginDetails();
    Map data = {};
    data['id'] = id;
    final response = await API_Emp.getOneEmp(data, auth.token);
    
    setState(() {
      isLoading = false;
      employe = response;
      trans = response['transactions'];
    });
  }
  //function to find transaction
  Future _OnSubmit(datas) async {
    setState(() {
      isLoading = true;
    });

    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Daily.client_Trans(datas, auth.token);
    print(response);
    if(response != false){
      setState(() {
        isLoading = false;
        trans = response;
      });
    }
  }
  //handle update data
  Future _UpdateEmp(data) async {
    setState(() {
      isLoading = true;
    });

    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Emp.UpdateEmp(data, auth.token);
    print(response);
    if(response != false){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم التعديل بنجاح بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        employe = {};
      });
      //call get emp again
      getEmp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: APPBAR(context),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Navbar(controller: controller),
            Expanded(
              child: ListView(
                  children:[
                    Column(
                      children: [
                        employe.isNotEmpty ?
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: FormBuilder(
                            key: _SecondKey,
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.3,
                              height: 390,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[300]
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('البيانات الاساسية', style: TextStyle(fontSize: 22),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                          height:70,
                                          width: 300,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: FormBuilderTextField(
                                              name: 'name',
                                              decoration: InputDecoration(labelText: 'الاسم'),
                                              initialValue: employe['name']!= null ? employe['name'].toString(): '',
                                            ),
                                          )
                                      ),
                                      Container(
                                        height:70,
                                        width: 300,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12)
                                        ),
                                        child: Center(
                                            child: FormBuilderTextField(
                                              name: 'address',
                                              decoration: InputDecoration(labelText: 'العنوان'),
                                              initialValue: employe['address']!= null ? employe['address'].toString(): '',
                                            ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height:70,
                                        width: 280,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12)
                                        ),
                                        child: Center(
                                            child: FormBuilderTextField(
                                              name: 'phoneNum',
                                              decoration: InputDecoration(labelText: 'رقم الهاتف'),
                                              initialValue: employe['phoneNum'] != null ? employe['phoneNum'].toString(): '',
                                            ),
                                        ),
                                      ),

                                      Container(
                                        height:70,
                                        width: 300,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12)
                                        ),
                                        child: Center(
                                            child: FormBuilderTextField(
                                              name: 'start_salary',
                                              decoration: InputDecoration(labelText: 'المرتب'),
                                              initialValue: employe['start_salary'] != null ? employe['start_salary'].toString(): '',
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height:70,
                                        width: 220,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12)
                                        ),
                                        child: Center(
                                            child: FormBuilderTextField(
                                              name: 'salary',
                                              decoration: InputDecoration(labelText: 'المرتب الحالي'),
                                              initialValue: employe['salary'] != null ?employe['salary'].toString() : '',
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  ElevatedButton(
                                      onPressed: (){
                                        if(_SecondKey.currentState!.saveAndValidate()){
                                          final data = {};
                                          data['id'] = employe['id'];
                                          data['name'] = _SecondKey.currentState!.value['name'];
                                          data['address'] = _SecondKey.currentState!.value['address'];
                                          data['phoneNum'] = _SecondKey.currentState!.value['phoneNum'];
                                          data['start_salary'] = _SecondKey.currentState!.value['start_salary'];
                                          data['salary'] = _SecondKey.currentState!.value['salary'];
                                            //call server
                                          _UpdateEmp(data);
                                        }
                                        },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(100, 40)
                                      ),
                                      child: Text('تحديث')
                                  )
                                ],
                              ),
                            ),
                          ),
                        ): Text(''),
                        SizedBox(height: 50,),
                        Text('تفاصيل المرتب', style: TextStyle(fontSize: 22),),
                        SizedBox(height: 20,),
                        trans.length != 0 ?Row(
                          children: [
                            Expanded(
                                child: Container(
                                    color: Colors.grey[100],
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
                                                      child: Row(
                                                        children: [
                                                          Text('من : ', style: TextStyle(fontSize: 17),),
                                                          SizedBox(width: 10,),
                                                          Container(
                                                            width: MediaQuery.of(context).size.width/7,
                                                            child: FormBuilderDateTimePicker(
                                                              name: "start_date",
                                                              onChanged: (value){},
                                                              decoration: InputDecoration(
                                                                  labelText: "اختر اليوم",
                                                                  suffixIcon: Icon(Icons.calendar_month, color: Colors.blue,)
                                                              ),
                                                              validator: FormBuilderValidators.required(errorText: "الرجاء اختيار تاريخ محدد"),
                                                              initialDate: DateTime.now(),
                                                              inputType: InputType.date,
                                                            ),
                                                          ),
                                                          SizedBox(width: 10,),
                                                          Text('الى : ', style: TextStyle(fontSize: 17),),
                                                          SizedBox(width: 10,),
                                                          Container(
                                                            width: MediaQuery.of(context).size.width/7,
                                                            child: FormBuilderDateTimePicker(
                                                              name: "end_date",
                                                              onChanged: (value){},
                                                              decoration: InputDecoration(
                                                                  labelText: "اختر اليوم",
                                                                  suffixIcon: Icon(Icons.calendar_month, color: Colors.blue,)
                                                              ),
                                                              validator: FormBuilderValidators.required(errorText: "الرجاء اختيار تاريخ محدد"),
                                                              initialDate: DateTime.now(),
                                                              inputType: InputType.date,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 10,),
                                                    // Add a submit button
                                                    TextButton.icon(
                                                      onPressed: (){
                                                        if(_formKey.currentState!.saveAndValidate()){
                                                          //send to server
                                                          Map datas = {};
                                                          datas['start_date'] = _formKey.currentState!.value['start_date'].toIso8601String();
                                                          datas['end_date'] = _formKey.currentState!.value['end_date'].toIso8601String();
                                                          datas['id'] = id;

                                                          _OnSubmit(datas);
                                                          setState(() {
                                                            trans = [];
                                                          });
                                                        }
                                                      },
                                                      style: TextButton.styleFrom(
                                                          primary: Colors.black,
                                                          minimumSize: Size(50, 50)
                                                      ),
                                                      icon: Icon(Icons.search, size: 30,),
                                                      label: Text('بحث'),
                                                    ),
                                                    SizedBox(width: 20,),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0),
                                                      child: TextButton.icon(
                                                        onPressed: () {
                                                          getEmp();
                                                          setState(() {
                                                            trans = [];
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
                                            )
                                        ),
                                        ClientDetailsTable(data: trans),
                                      ],
                                    )
                                )
                            ),
                          ],
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
                                              datas['id'] = id;

                                              _OnSubmit(datas);
                                              setState(() {
                                                trans = [];
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
                                              getEmp();
                                              setState(() {
                                                trans = [];
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
                                )
                            ),
                            SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cancel_rounded, size: 30, color: Colors.redAccent,),
                                SizedBox(width: 10,),
                                Text('لا يوجد تفاصيل معاملات', style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black
                                ),),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
