import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class  Util{

   List<String> running_num = [];
   int timeToInt(String string){
    List<String> splited =  string.split(":");
    int time = 0;
    print(splited);
    for(int i=0; i<splited.length; i++){
      if(i == 2){
        time += int.parse(splited[i]);
      }
       if(i == 1){
        time += int.parse(splited[i])*60;
      }
       if(i == 0){
        time += int.parse(splited[i])*3600;
      }
    }
    return time;
  }
  
}

  
