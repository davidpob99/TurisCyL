/*
 * Copyright (C) 2020  David Población Criado
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:turiscyl/models/lista.dart';
import 'package:turiscyl/utils.dart';
import 'package:uuid/uuid.dart';

class CrearLista extends StatefulWidget {
  @override
  _CrearListaState createState() => _CrearListaState();
}

class _CrearListaState extends State<CrearLista> {
  final _formKey = GlobalKey<FormState>();
  var uuid = Uuid();
  Lista _lista = new Lista();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Crear lista")
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
            key: _formKey,
            child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Nombre",
                      icon: Icon(Icons.title),
                      contentPadding: new EdgeInsets.all(8.0),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Introduzca el nombre de la lista';
                      }
                    },
                    onSaved: (val) => setState(() => _lista.nombre = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Autor",
                      icon: Icon(Icons.person),
                      contentPadding: new EdgeInsets.all(8.0),
                    ),
                    onSaved: (val){
                      setState(() {
                        if(val == '')
                          _lista.autor = "Anónimo";
                        else
                          _lista.autor = val;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Si no introduce el nombre del autor figurará como 'Anónimo'",
                    style: TextStyle(
                      color: Colors.grey
                    ),),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Descripción",
                      icon: Icon(Icons.short_text),
                      contentPadding: new EdgeInsets.all(8.0),
                    ),
                    onSaved: (val) => setState(() => _lista.descripcion = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Número de días",
                      icon: Icon(Icons.today),
                      contentPadding: new EdgeInsets.all(8.0)
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (val) {
                      try{
                        _lista.dias = int.parse(val);
                      } catch(e){
                        _lista.dias = -1;
                      }

                    },
                  ),
                ]
            )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: (){
          final form = _formKey.currentState;
          if (form.validate()){
            _lista.timestamp = DateTime.now();
            _lista.id = uuid.v4();
            form.save();
            Utils().anadirLista(_lista);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

