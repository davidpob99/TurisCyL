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

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:turiscyl/utils.dart';

import 'models/lista.dart';

class VistaImportar extends StatelessWidget {
  final _textoIntroducido = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textoIntroducido.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Importar lista")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text("Pega en el cuadro inferior los datos a importar"),
              TextField(
                controller: _textoIntroducido,
                keyboardType: TextInputType.multiline,
                minLines: 10,
                maxLines: 10000000,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: (){
          Lista lista = Lista.fromMap(json.decode(_textoIntroducido.text));
          lista.timestamp = DateTime.now();
          Utils().anadirLista(lista);
          Toast.show("Lista añadida", context);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
