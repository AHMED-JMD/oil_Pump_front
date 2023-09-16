import 'package:OilEnergy_System/API/employee.dart';
import 'package:OilEnergy_System/components/tables/EmpoyeesTable.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sidebarx/sidebarx.dart';


class Employees extends StatefulWidget {
  const Employees({super.key});

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  SidebarXController controller = SidebarXController(selectedIndex: 5, extended: true);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  List employees = [];
  List<String> emp_names = [];

  @override
  void initState() {
    getEmps();
    super.initState();
  }

  //Future server functions
  Future getEmps() async {
    setState(() {
      isLoading = true;
    });

    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Emp.getEmps(auth.token);

    if(response != false){
      setState(() {
        isLoading = false;
        employees = response;
      });
    }
  }
  //on Submit
  Future _OnSubmit(data) async {
    setState(() {
      isLoading = true;
    });

    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Emp.FindEmp(data, auth.token);

    if(response != false){
      setState(() {
        isLoading = false;
        employees = response;
      });
    }
  }

  //function to extract clients names
  Future extractName (List Employes) async {
    List<String> names = [];
    //iterate
    Employes.map((map) => map['name']).forEach((value) {
      names.add(value);
    });

    setState(() {
      emp_names = names;
    });
  }


  @override
  Widget build(BuildContext context) {
    //extract names from clients
    extractName(employees);
    return Scaffold(
      appBar: APPBAR(context),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Row(
              children: [
                Navbar(controller: controller,),
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
                              image: AssetImage('assets/Abstract Paper.png'),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.difference),
                            )
                        ),
                        child: Center(child: Text('الموظفين', style: TextStyle(fontSize: 26, color: Colors.white), textAlign: TextAlign.center,)),
                      ),
                      SizedBox(height: 80,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          employees.length != 0?
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
                                                  child: FormBuilderTextField(
                                                    name: 'name',
                                                    decoration: InputDecoration(
                                                      labelText: 'ابحث عن الاسم',
                                                    ),
                                                    validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10,),
                                              // Add a submit button
                                              IconButton(
                                                onPressed: (){
                                                  if(_formKey.currentState!.saveAndValidate()){
                                                    //send to server
                                                    _OnSubmit(_formKey.currentState!.value);
                                                    setState(() {
                                                      employees = [];
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
                                                    getEmps();
                                                    setState(() {
                                                      employees = [];
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
                                  EmployeeTable(employees: employees,),
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
                                              child: FormBuilderTextField(
                                                name: 'name',
                                                decoration: InputDecoration(
                                                  labelText: 'ابحث بالاسم',
                                                ),
                                                onChanged: (val){},
                                                validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الحقول"),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          // Add a submit button
                                          IconButton(
                                            onPressed: (){
                                              if(_formKey.currentState!.saveAndValidate()){
                                                //send to server
                                                _OnSubmit(_formKey.currentState!.value);
                                                setState(() {
                                                  employees = [];
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
                                                getEmps();
                                                setState(() {
                                                  employees = [];
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
                              SizedBox(height: 20,),
                              EmployeeTable(employees: employees),
                            ],
                          )
                        ],
                      ),
                    ]
                )
            )
          ],
        ),
      ),
    );
  }
}
