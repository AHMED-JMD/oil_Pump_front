import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:OilEnergy_System/API/auth.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/BG1.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 600,
                    height: 460,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      borderRadius: BorderRadius.circular(13)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            isLoading ? SpinKitChasingDots(
                              color: Colors.deepPurple,
                              size: 50,
                            )
                                : Text(''),
                            Center(
                              child: Text(
                                  'نظام تشغيل طرمبة الميناء الجاف',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple
                                  ),
                              ),
                            ),
                            SizedBox(height: 30,),
                            Center(
                              child: Text('تسجيل الدخول',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple
                                ),
                              ),
                            ),
                            FormBuilderTextField(
                                name: 'username',
                              decoration: InputDecoration(
                                  labelText: 'الاسم',
                                  icon: Icon(Icons.person),
                              ),
                              validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                            ),
                            SizedBox(height: 20,),
                            FormBuilderTextField(
                              name: 'password',
                              decoration: InputDecoration(
                                labelText: 'كلمة السر',
                                icon: Icon(Icons.password),
                                focusColor: Colors.deepPurple
                              ),
                              obscureText: true,
                              validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                            ),
                            SizedBox(height: 30,),
                            SizedBox(
                              height: 40,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: (){
                                  if(_formKey.currentState!.saveAndValidate()){
                                    setState(() {
                                      isLoading = true;
                                    });

                                    //call to server
                                    final data = _formKey.currentState!.value;
                                    API_auth.Login(data).then((response){
                                      setState(() {
                                        isLoading = false;
                                      });

                                      if(response == true){

                                        Navigator.pushReplacementNamed(context, '/home');
                                      }
                                      else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('$response', textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    });
                                  }
                                },
                                child: Text('ارسال'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    textStyle: TextStyle(fontSize: 18)
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        ]
      ),
    );
  }
}
