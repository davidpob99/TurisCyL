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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:turiscyl/utils.dart';
import 'package:turiscyl/values/strings.dart';

import 'models/lista.dart';

/// Vista para importar los datos de una [Lista] dada su cadena JSON exportada
class VistaImportar extends StatelessWidget {
  final _textoIntroducido = TextEditingController();

  /// Clean up the controller when the widget is disposed.
  @override
  void dispose() {
    _textoIntroducido.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.importar)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(Strings.pegaDatosImportar),
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
          Toast.show(Strings.listaAnadida, context);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
