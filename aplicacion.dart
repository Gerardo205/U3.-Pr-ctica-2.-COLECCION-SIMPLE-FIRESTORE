import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_u3_ejercicio4_firebase/baseremota.dart';
import 'package:flutter/material.dart';

class AppFirebase extends StatefulWidget {
  const AppFirebase({super.key});

  @override
  State<AppFirebase> createState() => _AppFirebaseState();
}

class _AppFirebaseState extends State<AppFirebase> {
  String titulo = "COLECCION SIMPLE FIRESTORE";
  int _index = 0;
  String  idClub= "";
  String  nombre1 = "";
  String  entrenador1 = "";
  String  estadio1 = "";
  int fundacion1 = 0;
  String liga1 = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${titulo}"),
      ),
      body: dinamico(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(child: Text("CG"),),
                SizedBox(height: 20,),
                Text("Cristian Gerardo", style: TextStyle(color: Colors.white, fontSize: 20),)
              ],
            ),
              decoration: BoxDecoration(color: Colors.red),
            ),
            _item(Icons.add, "Insertar Club", 1),
            _item(Icons.edit, "Actualizar Club", 2),
            _item(Icons.format_list_bulleted, "Lista Clubes", 0),
          ],
        ),
      ),
    );
  }
  Widget _item(IconData icono, String texto, int indice) {
    return ListTile(
      onTap: (){
        setState(() {
          _index = indice;
        });
        Navigator.pop(context);
      },
      title: Row(
        children: [Expanded(child: Icon(icono)), Expanded(child: Text(texto),flex: 2,)],
      ),
    );
  }
  Widget dinamico(){
    if(_index==1){
      return capturar();
    }
    if(_index==2){
      return actualizar();
    }
    return cargarData();
  }

  Widget cargarData(){

    return FutureBuilder(
        future: DB.mostrarTodos(),
        builder: (context, listaJSON){
          if(listaJSON.hasData){
            return ListView.builder(
                itemCount: listaJSON.data?.length,
                itemBuilder: (context,indice){
                  return ListTile(
                    title: Text("${listaJSON.data?[indice]['nombre']}"),
                    subtitle: Text("${listaJSON.data?[indice]['liga']}"),
                    trailing: IconButton(
                      onPressed: (){
                        DB.eliminar(listaJSON.data?[indice]['id'])
                            .then((value) {
                              setState(() {
                                titulo = "SE BORRÓ";
                              });
                        });
                      },
                        icon: Icon(Icons.delete)
                    ),
                      onTap: () {
                        setState(() {
                          idClub = listaJSON.data?[indice]['id'];
                          nombre1 = listaJSON.data?[indice]['nombre'];
                          entrenador1 = listaJSON.data?[indice]['entrenador'];
                          estadio1 = listaJSON.data?[indice]['estadio'];
                          fundacion1 = listaJSON.data?[indice]['fundacion'];
                          liga1 = listaJSON.data?[indice]['liga'];
                          _index = 2;
                        });
                      }
                  );
                }
            );
          }
          return Center(child: CircularProgressIndicator(),);
        }
    );
  }

  Widget actualizar(){
    final nombre = TextEditingController();
    final entrenador = TextEditingController();
    final estadio = TextEditingController();
    final fundacion = TextEditingController();
    final liga = TextEditingController();
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        Text('Rellena los campos que deseas actualizar',
          style: TextStyle(fontSize: 20),),
        SizedBox(height: 10,),
        TextField(
          controller: nombre,
          decoration: InputDecoration(
              labelText: "Nombre"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: entrenador,
          decoration: InputDecoration(
              labelText: "Entrenador:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: estadio,
          decoration: InputDecoration(
              labelText: "Estadio:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: fundacion,
          decoration: InputDecoration(
              labelText: "Año de fundación:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: liga,
          decoration: InputDecoration(
              labelText: "Liga:"
          ),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: (){
                  if(nombre.text.isEmpty){
                    nombre.text = nombre1;
                  }
                  if(entrenador.text.isEmpty){
                    entrenador.text = entrenador1;
                  }
                  if(estadio.text.isEmpty){
                    estadio.text = estadio1;
                  }
                  if(fundacion.text.isEmpty){
                    fundacion.text = fundacion1.toString();
                  }
                  if(liga.text.isEmpty){
                    liga.text = liga1;
                  }
                  var JsonTemporal = {
                    'id' : idClub,
                    'nombre': nombre.text,
                    'entrenador': entrenador.text,
                    'estadio': estadio.text,
                    'fundacion': int.parse(fundacion.text),
                    'liga': liga.text
                  };
                  DB.actualizar(JsonTemporal)
                      .then((value) {
                    setState(() {
                      titulo = "SE ACTUALIZÓ";
                      _index = 0;
                    });
                    nombre.text = "";
                    entrenador.text = "";
                    estadio.text = "";
                    fundacion.text = "";
                    liga.text = "";
                  });
                },
                child: Text("Actualizar")
            ),
            ElevatedButton(
                onPressed: (){
                  setState(() {
                    _index = 0;
                  });
                },
                child: Text("Cancel")
            ),
          ],
        )
      ],
    );
  }
  Widget capturar(){
    final nombre = TextEditingController();
    final entrenador = TextEditingController();
    final estadio = TextEditingController();
    final fundacion = TextEditingController();
    final liga = TextEditingController();

    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        Text('Rellena los campos',
          style: TextStyle(fontSize: 20),),
        SizedBox(height: 10,),
        TextField(
          controller: nombre,
          decoration: InputDecoration(
              labelText: "Nombre"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: entrenador,
          decoration: InputDecoration(
              labelText: "Entrenador:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: estadio,
          decoration: InputDecoration(
              labelText: "Estadio:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
        controller: fundacion,
        decoration: InputDecoration(
        labelText: "Año de fundación:"
        ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: liga,
          decoration: InputDecoration(
              labelText: "Liga:"
          ),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: (){
                var JSonTemporal={
                  'nombre':nombre.text,
                  'entrenador':entrenador.text,
                  'estadio':estadio.text,
                  'fundacion':int.parse(fundacion.text),
                  'liga': liga.text
                };
                DB.insertar(JSonTemporal)
                    .then((value){
                      setState(() {
                        titulo = "SE INSERTÓ";
                      });
                });
                },
                child: Text("Insertar")
            ),
            ElevatedButton(
                onPressed: (){
                  setState(() {
                    _index = 0;
                  });
                },
                child: Text("Cancel")
            ),
          ],
        )
      ],
    );
  }
}
