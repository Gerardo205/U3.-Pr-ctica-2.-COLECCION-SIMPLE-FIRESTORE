import 'package:cloud_firestore/cloud_firestore.dart';

var baseRemota = FirebaseFirestore.instance;

class DB{
  static Future insertar(Map<String,dynamic>club)async{
    return await baseRemota.collection("club").add(club);
  }
  static Future<List> mostrarTodos()async{
    List temporal =[];
    var query = await baseRemota.collection("club").get();

    query.docs.forEach((element){
      Map<String,dynamic> dataTemp = element.data();
      dataTemp.addAll({'id':element.id});
      temporal.add(dataTemp);
    });
    return temporal;
  }
  static Future eliminar(String id)async{
    return await baseRemota.collection("club").doc(id).delete();
  }

    static Future actualizar(Map<String,dynamic>club)async{
      String idActualizar = club['id'];
      club.remove('id');
      return await baseRemota.collection("club").doc(idActualizar).update(club);
    }
}