import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SearchDates extends StatefulWidget {
  final Function(Map) Search;
  const SearchDates({super.key, required this.Search});

  @override
  State<SearchDates> createState() => _SearchDatesState();
}

class _SearchDatesState extends State<SearchDates> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  DateTime? start_date;
  DateTime? end_date;
  DateTime now = DateTime.now();

  String numCheck (int number) {
    if(number < 10){
      return '0$number';
    }else{
      return '$number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(builder: (BuildContext context,
                  BoxConstraints constraints) {
                if (constraints.maxWidth > 700) {
                  return Row(
                    children: [
                      Text(
                        'من : ',
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 200,
                        child: FormBuilderDateTimePicker(
                          name: "start_date",
                          onChanged: (value) {
                            setState(() {
                              start_date = value;
                            });
                          },
                          decoration: InputDecoration(
                              labelText: "البداية",
                              suffixIcon: Icon(
                                Icons.calendar_month,
                                color: Colors.blueAccent,
                              )),
                          validator:
                          FormBuilderValidators.required(
                              errorText:
                              "الرجاء اختيار تاريخ محدد"),
                          initialDate: DateTime.now(),
                          inputType: InputType.date,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'الى : ',
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 200,
                        child: FormBuilderDateTimePicker(
                          name: "end_date",
                          onChanged: (value) {
                            setState(() {
                              end_date = value;
                            });
                          },
                          decoration: InputDecoration(
                              labelText: "النهاية",
                              suffixIcon: Icon(
                                Icons.calendar_month,
                                color: Colors.blueAccent,
                              )),
                          validator:
                          FormBuilderValidators.required(
                              errorText:
                              "الرجاء اختيار تاريخ محدد"),
                          initialDate: DateTime.now(),
                          inputType: InputType.date,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
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
                            if (_formKey.currentState!
                                .saveAndValidate()) {
                              //call to backend
                              Map datas = {};
                              datas['start_date'] =
                                  start_date!.toIso8601String();
                              datas['end_date'] =
                                  end_date!.toIso8601String();

                              // function
                              widget.Search(datas);
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 50,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 200,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'الفترة الزمنية',
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
                                    Map data = {};
                                    data['start_date'] = startDate;
                                    data['end_date'] = endDate;
                                    widget.Search(data);

                                  } else if(val == 'week'){
                                    //custom start date for week
                                    DateTime startDate = now.subtract(Duration(days: 7));
                                    //call server
                                    Map data = {};
                                    data['start_date'] = startDate.toIso8601String();
                                    data['end_date'] = now.toIso8601String();
                                    widget.Search(data);
                                  }else {
                                    //call server
                                    Map data = {};
                                    data['start_date'] = now.toIso8601String();
                                    data['end_date'] = now.toIso8601String();
                                    widget.Search(data);
                                  }
                                }
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  if (constraints.maxWidth > 500) {
                    return Row(
                      children: [
                        Text(
                          'من : ',
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 130,
                          child: FormBuilderDateTimePicker(
                            name: "start_date",
                            onChanged: (value) {
                              setState(() {
                                start_date = value;
                              });
                            },
                            decoration: InputDecoration(
                                labelText: "البداية",
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  color: Colors.blueAccent,
                                )),
                            validator:
                            FormBuilderValidators.required(
                                errorText:
                                "الرجاء اختيار تاريخ محدد"),
                            initialDate: DateTime.now(),
                            inputType: InputType.date,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'الى : ',
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 130,
                          child: FormBuilderDateTimePicker(
                            name: "end_date",
                            onChanged: (value) {
                              setState(() {
                                end_date = value;
                              });
                            },
                            decoration: InputDecoration(
                                labelText: "النهاية",
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  color: Colors.blueAccent,
                                )),
                            validator:
                            FormBuilderValidators.required(
                                errorText:
                                "الرجاء اختيار تاريخ محدد"),
                            initialDate: DateTime.now(),
                            inputType: InputType.date,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // Add a submit button
                        SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                            child: Text('ارسال'),
                            style: ElevatedButton.styleFrom(
                                textStyle:
                                TextStyle(fontSize: 16)),
                            onPressed: () {
                              if (_formKey.currentState!
                                  .saveAndValidate()) {
                                //call to backend
                                Map datas = {};
                                datas['start_date'] =
                                    start_date!
                                        .toIso8601String();
                                datas['end_date'] =
                                    end_date!.toIso8601String();

                                // function
                                widget.Search(datas);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
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
                                      Map data = {};
                                      data['start_date'] = startDate;
                                      data['end_date'] = endDate;
                                      widget.Search(data);

                                    } else if(val == 'week'){
                                      //custom start date for week
                                      DateTime startDate = now.subtract(Duration(days: 7));
                                      //call server
                                      Map data = {};
                                      data['start_date'] = startDate.toIso8601String();
                                      data['end_date'] = now.toIso8601String();
                                      widget.Search(data);
                                    }else {
                                      //call server
                                      Map data = {};
                                      data['start_date'] = now.toIso8601String();
                                      data['end_date'] = now.toIso8601String();
                                      widget.Search(data);
                                    }
                                  }
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Text(
                          'من : ',
                          style: TextStyle(fontSize: 17),
                        ),
                        Container(
                          width: 200,
                          child: FormBuilderDateTimePicker(
                            name: "start_date",
                            onChanged: (value) {
                              setState(() {
                                start_date = value;
                              });
                            },
                            decoration: InputDecoration(
                                labelText: "البداية",
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  color: Colors.blueAccent,
                                )),
                            validator:
                            FormBuilderValidators.required(
                                errorText:
                                "الرجاء اختيار تاريخ محدد"),
                            initialDate: DateTime.now(),
                            inputType: InputType.date,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'الى : ',
                          style: TextStyle(fontSize: 17),
                        ),
                        Container(
                          width: 200,
                          child: FormBuilderDateTimePicker(
                            name: "end_date",
                            onChanged: (value) {
                              setState(() {
                                end_date = value;
                              });
                            },
                            decoration: InputDecoration(
                                labelText: "النهاية",
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  color: Colors.blueAccent,
                                )),
                            validator:
                            FormBuilderValidators.required(
                                errorText:
                                "الرجاء اختيار تاريخ محدد"),
                            initialDate: DateTime.now(),
                            inputType: InputType.date,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Add a submit button
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            child: Text('ارسال'),
                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 18)
                            ),
                            onPressed: () {
                              if (_formKey.currentState!
                                  .saveAndValidate()) {
                                //call to backend
                                Map datas = {};
                                datas['start_date'] =
                                    start_date!
                                        .toIso8601String();
                                datas['end_date'] =
                                    end_date!.toIso8601String();

                                // function
                                widget.Search(datas);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                      labelText: 'الفترة الزمنية',
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
                                      Map data = {};
                                      data['start_date'] = startDate;
                                      data['end_date'] = endDate;
                                      widget.Search(data);

                                    } else if(val == 'week'){
                                      //custom start date for week
                                      DateTime startDate = now.subtract(Duration(days: 7));
                                      //call server
                                      Map data = {};
                                      data['start_date'] = startDate.toIso8601String();
                                      data['end_date'] = now.toIso8601String();
                                      widget.Search(data);
                                    }else {
                                      //call server
                                      Map data = {};
                                      data['start_date'] = now.toIso8601String();
                                      data['end_date'] = now.toIso8601String();
                                      widget.Search(data);
                                    }
                                  }
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                }
              })
            ],
          )),
    );
  }
}
