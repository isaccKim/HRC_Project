import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class  Util{

   List<String> running_num = [];
   double timeToDouble(String string){
    List<String> splited =  string.split(":");
    double time = 0;
    print(splited);
    for(int i=0; i<splited.length; i++){
      if(i == 2){
        time += double.parse(splited[i]);
      }
       if(i == 1){
        time += double.parse(splited[i])*60;
      }
       if(i == 0){
        time += double.parse(splited[i])*3600;
      }
    }
    return time;
  }
  
}

  
