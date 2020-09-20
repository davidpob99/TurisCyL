/*
 * TurisCyL: Planifica tu viaje por Castilla y León
 * Copyright (C) 2020 David Población Criado
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:turiscyl/models/lista.dart';
import 'package:turiscyl/utils.dart';
import 'package:turiscyl/values/strings.dart';
import 'package:uuid/uuid.dart';

/// Vista que permite crear una [Lista] a través de sus campos
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
      appBar: AppBar(title: Text(Strings.crearLista)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: Strings.nombre,
                    icon: Icon(Icons.title),
                    contentPadding: new EdgeInsets.all(8.0),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return Strings.nombreVacio;
                    }
                  },
                  onSaved: (val) => setState(() => _lista.nombre = val),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: Strings.autor,
                    icon: Icon(Icons.person),
                    contentPadding: new EdgeInsets.all(8.0),
                  ),
                  onSaved: (val) {
                    setState(() {
                      if (val == '')
                        _lista.autor = Strings.anonimo;
                      else
                        _lista.autor = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Strings.advertenciaAnonimo,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 10000000,
                  decoration: InputDecoration(
                    hintText: Strings.descripcion,
                    icon: Icon(Icons.short_text),
                    contentPadding: new EdgeInsets.all(8.0),
                  ),
                  onSaved: (val) => setState(() => _lista.descripcion = val),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: Strings.numeroDias,
                      icon: Icon(Icons.today),
                      contentPadding: new EdgeInsets.all(8.0)),
                  keyboardType: TextInputType.number,
                  onSaved: (val) {
                    try {
                      _lista.dias = int.parse(val);
                    } catch (e) {
                      _lista.dias = -1;
                    }
                  },
                ),
              ])),
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

