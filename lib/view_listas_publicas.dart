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
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:turiscyl/models/lista.dart';
import 'package:turiscyl/utils.dart';
import 'package:turiscyl/values/constantes.dart';
import 'package:turiscyl/values/strings.dart';
import 'package:turiscyl/view_lista.dart';

/// Vista que muestra un [ListView] con las listas públicas y la posibilidad de
/// guardarlas como propias
class VistaListasPublicas extends StatefulWidget {
  @override
  _VistaListasPublicasState createState() => _VistaListasPublicasState();
}

class _VistaListasPublicasState extends State<VistaListasPublicas> {
  /// Devuelve desde [Constantes.urlListasPublicas] una [List] de [Lista] con
  /// las listas públicas disponibles en el momento de su ejecución. Si hay un
  /// problema devuelve [null]
  Future<List> _getListasPublicas() async {
    final http.Response respuesta =
        await http.get(Constantes.urlListasPublicas);

    if (respuesta.statusCode == 200) {
      final json = jsonDecode(respuesta.body);
      return json['listas'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.listasPublicas)),
      body: FutureBuilder(
          future: _getListasPublicas(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Lista lista = Lista.fromMap(snapshot.data[index]);
                    return Card(
                        child: InkWell(
                      child: ListTile(
                        title: Text(lista.nombre),
                        subtitle: Text(
                            "${lista.provincias.join(", ")} · ${lista.dias == -1 ? 'N/A' : lista.dias.toString()} días"),
                        trailing: IconButton(
                          icon: Icon(Icons.playlist_add),
                          onPressed: () {
                            Toast.show(Strings.listaAnadida, context);
                            Utils().anadirLista(lista);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VistaLista(
                                lista: lista,
                              ),
                            ));
                      },
                    ));
                  });
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Utils().cargandoDatos();
            }
          }),
    );
  }
}
