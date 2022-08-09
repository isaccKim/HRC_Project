import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class  Util{
   late String u_sum_dist;
   late String u_sum_time;
   late String user_name;
   late String email;
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
  
  Future getUserData() async {
  final user = await FirebaseAuth.instance.currentUser;
  final userData =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid);
  await userData.get().then(
        (value) => {
          user_name = value['user_name'],
          email = value['email'],
          u_sum_dist= value['sum_distance'],
          u_sum_time= value['sum_time'],
        },
      );
}
}