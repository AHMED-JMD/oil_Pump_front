import 'package:flutter/material.dart';
import 'package:OilEnergy_System/API/client.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:OilEnergy_System/components/tables/ClientTable.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  SidebarXController controller = SidebarXController(selectedIndex: 4, extended: true);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  List clients = [];
  List<String> clients_names = [];
  String? name;

  @override
  void initState() {
    getClients();
    super.initState();
  }

  //Future server functions
  Future getClients() async {
    setState(() {
      isLoading = true;
    });

    //send to server
    final auth = await SharedServices.LoginDetails();
    final response = await API_Client.getClients(auth.token);

    if(response != false){
      setState(() {
        isLoading = false;
        clients = response;
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
    final response = await API_Client.FindClient(data, auth.token);

    if(response != false){
      setState(() {
        isLoading = false;
        clients = response;
      });
    }
  }

  //function to extract clients names
  Future extractName (List Clients) async {
    List<String> names = [];
    //iterate
    Clients.map((map) => map['name']).forEach((value) {
      names.add(value);
    });

    setState(() {
      clients_names = names;
    });
  }


  @override
  Widget build(BuildContext context) {
    //extract names from clients
    extractName(clients);
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
                            image: AssetImage('assets/Curve_Line.png'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.difference),
                          )
                      ),
                      child: Center(child: Text('العملاء', style: TextStyle(fontSize: 26, color: Colors.white), textAlign: TextAlign.center,)),
                    ),
                    SizedBox(height: 80,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        clients.length != 0?
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
                                                height: 60,
                                                child: TypeAheadField(
                                                  textFieldConfiguration: TextFieldConfiguration(
                                                      autofocus: false,
                                                      decoration: InputDecoration(
                                                        label: Text('ابحث عن الاسم'),
                                                      ),
                                                  ),
                                                  suggestionsCallback: (pattern) async {
                                                    return clients_names.where((option) => option.toLowerCase().contains(pattern.toLowerCase()));
                                                  },
                                                  itemBuilder: (context, suggestion) {
                                                    return ListTile(
                                                      title: Text(suggestion),
                                                    );
                                                  },
                                                  onSuggestionSelected: (suggestion) {
                                                    name = suggestion;
                                                  },
                                                )
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            // Add a submit button
                                            IconButton(
                                              onPressed: (){
                                                if(_formKey.currentState!.saveAndValidate()){
                                                    //send to server
                                                  Map data = {};
                                                  data['name'] = name;
                                                  _OnSubmit(data);
                                                  setState(() {
                                                    clients = [];
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
                                                  getClients();
                                                  setState(() {
                                                    clients = [];
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
                                ClientsTable(clients: clients,),
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
                                                clients = [];
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
                                              getClients();
                                              setState(() {
                                                clients = [];
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
                            ClientsTable(clients: clients),
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
