import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/home/selectLocation.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'package:gather_go/shared/num_button.dart';
import 'package:geocoding/geocoding.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:gather_go/services/database.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/Models/EventInfo.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gather_go/screens/home/nav.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


// geo code 
// ignore: camel_case_types
class createEvent extends StatefulWidget {
  
 
  @override
  _Eventform createState() => _Eventform();
    

}

class _Eventform extends State<createEvent> {
   
  final category = [
    'Educational',
    'Sports',
    'Arts',
    'Academic',
    'Culture',
    'Video Games',
    'Activities',
    'Beauty',
    'Health',
    'Career',
    'Personal Growth',
    'Other'
  ];
  String? item = 'Other';
 
  final _formKey = GlobalKey<FormState>();

  //DateTime _dateTime = DateTime.now();
  TextEditingController eventName = TextEditingController();
  TextEditingController eventDescription = TextEditingController();
  DateRangePickerController eventDate = DateRangePickerController();
  TextEditingController attendeeNum = TextEditingController();

  //int _currentStep = 0;
  DateTime? dateo;
  TextEditingController? name;
  TextEditingController? description;
  String? Name;
  String? Description;
  int? attendeeNumber;
  TimeOfDay? ttime;
  GeoPoint? location;
  DateRangePickerController Datee = DateRangePickerController();
  String? timeAgo;
  int _currentValue = 0;
  bool approved = false;
  LatLng _initialcameraposition = LatLng(24.708481, 46.752108);
  late GoogleMapController _controller;
bool selectLocationTime= false;
  List<Marker> myMarker = [];
  LatLng saveLatLng = LatLng(24.708481, 46.752108);
  String? StringLatLng;
  String viewDate = "Date ";
  String viewTime = "Time ";
  String viewLocation = "Location  ";
 
var googleMap=GoogleMap(initialCameraPosition: CameraPosition(target:LatLng(24.708481, 46.752108) ));
 
bool selected=false;
 double saveLat =0;
double saveLong=0 ;

  //DateTime date;
  @override
  Widget build(BuildContext context) {
    EventInfo? eventData;
    final user = Provider.of<NewUser?>(context, listen: false);
   
// double v =widget.saveLat;


  //   saveLat = widget.saveLat1 ;
  //   saveLong = widget.saveLong1;
  // saveLongAsString = widget.saveLong1.toString();

  


    return selectLocationTime?showMap(context):Scaffold(
      
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Create An Event",),
      body:
     StreamBuilder<Object>(
        stream: DatabaseService(uid: user?.uid).eventss,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            eventData = snapshot.data as EventInfo;
          }
          return 
          SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            "Event Name",
                            style: TextStyle(
                                color: Colors.orange[400],
                                letterSpacing: 2,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Comfortaa"),
                          ),
                        ),
                      SizedBox(height: 5),
                      SizedBox(
                        width: 350,
                        height: 50,
                        child: TextFormField(
                          controller: eventName,
                          maxLines: 1,
                          initialValue: eventData?.name,
                          decoration: 
                          textInputDecoration.copyWith(
                            
                          ),
                          validator: (val) => val!.trim().isEmpty
                              ? "The event needs a name."
                              : eventData?.name,
                          onChanged: (val) => setState(() => Name = val),
                        ),
                      ),
                      
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            "Event Category",
                            style: TextStyle(
                                color: Colors.orange[400],
                                letterSpacing: 2,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Comfortaa"),
                          ),
                        ),
                      

                      SizedBox(height: 5),
                      Container(
                        width: 350,
                        height: 50,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey, width: 1)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              focusColor: Colors.grey,
                              value: item,

                              // initialValue: category[0],
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.blueGrey),
                              items: category.map(buildMenuItem).toList(),
                              onChanged: (value) =>
                                  setState(() => this.item = value),
                              style: TextStyle(
                                color: Colors.orange[400],
                                fontFamily: 'Comfortaa',
                              )),
                        ),
                      ),
                      
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            "Event Description",
                            style: TextStyle(
                                color: Colors.orange[400],
                                letterSpacing: 2,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Comfortaa"),
                          ),
                        ),
                      SizedBox(height: 5),
                      SizedBox(
                       
                        width: 350,
                        
                        child: TextFormField(
                          controller: eventDescription,
                          minLines: 3,
                          maxLines: 5,
                          initialValue: eventData?.description,
                          decoration: textInputDecoration.copyWith(),
                          validator: (val) => val!.trim().isEmpty
                              ? "Description can't be empty."
                              : eventData?.description,
                          onChanged: (val) => setState(() => Description = val),
                        ),
                      ),
                    
                      SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Text(
                          "Attendee Number",
                          style: TextStyle(
                              color: Colors.orange[400],
                              letterSpacing: 2,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Comfortaa"),
                        ),
                      ),
  NumericStepButton(
                        
                        minValue: 1,
                        maxValue: 500,
                        onChanged: (value) {
                            setState(() => this._currentValue = value);
                            }
                      ),
                      ],
                    ),
                      
                      
                      
                       
                       Center( child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        RichText(
                        text: TextSpan(
                          children: [
                             WidgetSpan(
                              child: IconButton(
                               
                                icon: Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.orange[400],
                                  size: 25,
                                ),
                               
                                onPressed: () => pickDate(context),
                              ),
                            ),
                            TextSpan(
                              text: viewDate,
                              style: TextStyle(
                                  color: Colors.orange[400],
                                  letterSpacing: 2,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Comfortaa"),
                            ),
                           
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                             WidgetSpan(
                              child: IconButton(
                                
                                icon: Icon(
                                  Icons.access_time,
                                  textDirection: TextDirection.ltr,
                                  color: Colors.orange[400],
                                  size: 25,
                                ),
                                
                                onPressed: () => pickTime(context),
                              ),
                            ),
                            TextSpan(
                              text: viewTime,
                              style: TextStyle(
                                  color: Colors.orange[400],
                                  letterSpacing: 2,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Comfortaa"),
                            ),
                           
                            
                          ],
                        ),
                      ),RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: IconButton(
                               
                                icon: Icon(
                                  Icons.location_on_outlined,
                                  textDirection: TextDirection.ltr,
                                  color: Colors.orange[400],
                                  size: 25,
                                ),
                                //Location()
                                //selectLocation
                           onPressed: () {
                             setState(() {
                               this.selectLocationTime=true;
                             }); 
                            
                                      },
               
              ),
                            ),
                            TextSpan(
                              text: viewLocation,
                              style: TextStyle(
                                  color: Colors.orange[400],
                                  letterSpacing: 2,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Comfortaa"),
                            ),
                            
                            
                          ],
                        ),
                      ),
                      ],
                      ),),
                  
                      
                     SizedBox(height: 10),
                     

                      SizedBox(
                        height: 50,
                        width: 180,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange[400]),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.fromLTRB(35, 15, 35, 15))),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Comfortaa"),
                          ),
                          onPressed: () async {
                         //update db here using stream provider and database class
                            if (item == null) {
                              item = 'Other';
                            } else {
                              timeAgo = DateTime.now().toString();
                              if (_formKey.currentState!.validate()) {
                                if (dateo == null &&
                                    ttime == null &&
                                    saveLat == 0 &&
                                    saveLong == 0) {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Date and time and location have to be selected.",
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                } else if (dateo == null) {
                                  Fluttertoast.showToast(
                                    msg: "Date has to be selected.",
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                } else if (ttime == null) {
                                  Fluttertoast.showToast(
                                    msg: "Time has to be selected.",
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                } else if (saveLat == 0 &&saveLong == 0) {
                                  Fluttertoast.showToast(
                                    msg: "Location has to be selected.",
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                } else if (_currentValue == 0){
                                  Fluttertoast.showToast(
                                    msg: "Attendee number can't be 0 ",
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                }else{
                                  // print(ttime);
                                  var result = await showMyDialog(context);

                                  if (result == true) {
                                   
                                    await DatabaseService(uid: user?.uid)
                                        .addEventData(
                                      user!.uid,
                                      Name!,
                                      item!,
                                      Description!,
                                      timeAgo!,
                                      _currentValue,
                                      dateo.toString(),
                                      ttime.toString(),
                                      approved,
                                      false,
                                    saveLat,
                                      saveLong,
                                    );
                                    var userID = user.uid;
                                    await FirebaseMessaging.instance.subscribeToTopic('event_$userID');
                                    Fluttertoast.showToast(
                                      msg: "Event successfully sent to admin.",
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyBottomBarDemo()));
                                  }
                                }
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  )));
        }));
                         
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    
  }

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: true,
          onDragEnd: (dragEndPosition) {
            print(dragEndPosition);
          }));
      saveLat = tappedPoint.latitude;
      saveLong = tappedPoint.longitude;
      selected=true;
      pos(saveLat, saveLong);
      
                });
  }
  

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now().add(Duration(days: 1));
    final newDate = await showDatePicker(
      // enablePastDates: false,
      context: context,
      initialDate: dateo ?? initialDate,
      firstDate: DateTime.now().add(Duration(days: 1)),
      //   DateTime(DateTime.now().day + 1),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;
    Fluttertoast.showToast(
      msg: "Date selected.",
      toastLength: Toast.LENGTH_LONG,
    );
    setState(() => dateo = newDate);
    viewDate = newDate.toString().substring(0, 10);
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now() //ttime ?? initialTime
      ,
    );

    if (newTime == null) return;

    setState(() => ttime = newTime);
    Fluttertoast.showToast(
      msg: "Time selected.",
      toastLength: Toast.LENGTH_LONG,
    );
    viewTime = ttime.toString().substring(10, 15);
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(item,
          style: TextStyle(/*fontWeight: FontWeight.bold,*/ fontSize: 20)));



Widget showMap(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
     title: Text("Select Location",
      style: TextStyle(
          color: Colors.black, 
          fontFamily: 'Comfortaa', 
          fontSize: 28, 
          fontWeight: FontWeight.bold)),
    elevation: 6,
    toolbarHeight:100,
    backgroundColor: Colors.orange[400],
    iconTheme: IconThemeData(
      color: Colors.black,),
      actions:[IconButton(
            icon: const Icon(Icons.cancel,
                                color: Colors.black, size: 27), 
            onPressed: () {
              setState(() {
                selectLocationTime =false;
              });
            }),],
    
  )
      ,

    body: Column(mainAxisSize: MainAxisSize.max,children: [
       Expanded(child: Container(
                     height: 450,
   child: GoogleMap(
                            initialCameraPosition:
                                CameraPosition(target: !selected? LatLng(24.708481, 46.752108) : LatLng(saveLat, saveLong), zoom: 15),
                            mapType: MapType.normal,
                            onMapCreated: _onMapCreated,
                            rotateGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            zoomGesturesEnabled: true,
                            liteModeEnabled: false,
                            indoorViewEnabled: true,
                            tiltGesturesEnabled: true,
                            myLocationEnabled: true,
                            markers: Set.from(myMarker),
                            onTap: _handleTap,
    ),),),
    !selected?Container():Flex(
      direction:Axis.horizontal,
      children: <Widget>[Expanded(child: Text('$address ')), Padding(
                                padding: const EdgeInsets.all(8),
                                child:ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange[400]),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.fromLTRB(35, 15, 35, 15))),
                          child: Text(
                            'Ok',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Comfortaa"),
                          ),
                          onPressed: (){
                           
                           setState(() {
                             selectLocationTime =false;
                           });
                           
                          

                          
                                                    
                                                    },
     ) ),  ]),],));
                        


  
  }
  String address='';
  String areaName='';
  Future<String?> pos(lat, long) async {
  List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);

  Placemark placeMark = newPlace[0];
  String? name = placeMark.name;
  String? subLocality = placeMark.subLocality;
  String? locality = placeMark.locality;
  String? administrativeArea = placeMark.administrativeArea;
  String? postalCode = placeMark.postalCode;
  String? country = placeMark.country;
  setState(() {
   
   address =
      "$name, $subLocality, $locality, $administrativeArea, $postalCode, $country";
 
  areaName="$locality , $subLocality";
   viewLocation= areaName;
  }); 
  String? location;
  String? area;
  int index;
  if (locality != "") {
    location = locality.toString();
  } else {
    // area = administrativeArea.toString();
    // index = area.indexOf(' ');
//    location = area.substring(0, index);
    location = administrativeArea.toString();
  }
  return location;
}

}
