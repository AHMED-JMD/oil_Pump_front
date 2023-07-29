import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_pump_system/API/client.dart';
import 'package:oil_pump_system/SharedService.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sidebarx/sidebarx.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key,}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {

  SidebarXController controller = SidebarXController(selectedIndex: 2, extended: true);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  //state of widget
  bool isLoading = false;

  Future _OnSubmit(data) async {
    setState(() {
      isLoading = true;
    });

    //call backend
    final auth = await SharedServices.LoginDetails();
    API_Emp.AddClient(data, auth.token).then((response){
      setState(() {
        isLoading = false;
      });
      if(response == true){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تمت اضافة الموظف بنجاح', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: APPBAR(context),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                      Navbar(controller: controller,),
                  Expanded(
                    child: ListView(
                      children:[
                        Container(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Padding(
                                padding: const EdgeInsets.all(50.0),
                                  child: FormBuilder(
                                    // Define the form key to identify the form
                                    key: _formKey,
                                    // Define the form fields
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          child: Icon(Icons.person),
                                          radius: 50,
                                          backgroundColor: Colors.grey.shade300,
                                        ),
                                        isLoading ? SpinKitThreeBounce(
                                          color: Colors.white,
                                          size: 100.0,
                                        )
                                            : Text(''),
                                        // Add a text field
                                        FormBuilderTextField(
                                          name: 'name',
                                          decoration: InputDecoration(
                                              labelText: 'الاسم',
                                              suffixIcon: Icon(Icons.person, color: Colors.blueAccent,)
                                          ),
                                          validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                        ),
                                        // Add another text field
                                        FormBuilderTextField(
                                          name: 'address',
                                          decoration: InputDecoration(
                                              labelText: 'السكن',
                                              suffixIcon: Icon(Icons.location_city_outlined, color: Colors.blueAccent,)
                                          ),
                                          validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                        ),
                                        // Add another text field
                                        FormBuilderTextField(
                                          name: 'phoneNum',
                                          decoration: InputDecoration(
                                              labelText: 'رقم الهاتف',
                                              suffixIcon: Icon(Icons.phone_android, color: Colors.blueAccent,)
                                          ),
                                          validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                        ),
                                        FormBuilderTextField(
                                          name: 'account',
                                          decoration: InputDecoration(
                                              labelText: 'الحساب',
                                              suffixIcon: Icon(Icons.wallet, color: Colors.blueAccent,)
                                          ),
                                          validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                        ),
                                        SizedBox(height: 10,),
                                        FormBuilderTextField(
                                          name: 'comment',
                                          decoration: InputDecoration(
                                              labelText: 'التعليق',
                                              contentPadding: EdgeInsets.symmetric(vertical: 40),
                                              suffixIcon: Icon(Icons.comment, color: Colors.blueAccent,)
                                          ),
                                          maxLines: 5,
                                          minLines: 1,
                                          // onChanged: (val) {
                                          //   print(val); // Print the text value write into TextField
                                          // },
                                          validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                        ),
                                        SizedBox(height: 40,),
                                        // Add a submit button
                                        SizedBox(
                                          width: 100,
                                          height: 40,
                                          child: ElevatedButton(
                                            child: Text('ارسال'),
                                            style: ElevatedButton.styleFrom(
                                                textStyle: TextStyle(fontSize: 18)
                                            ),
                                            onPressed: () {
                                              if (_formKey.currentState!.saveAndValidate()) {
                                                  final data = _formKey.currentState!.value;
                                                  _OnSubmit(data);
                                                }
                                              }
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ),
                            )
                      ]
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

const canvasColor = Color(0xFF2E2E48);