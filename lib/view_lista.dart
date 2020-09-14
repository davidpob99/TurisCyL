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

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:turiscyl/utils.dart';
import 'package:turiscyl/values/colores.dart';
import 'package:turiscyl/view_detalles.dart';

import 'models/actividad_turistica.dart';
import 'models/albergue.dart';
import 'models/alojamiento_hotelero.dart';
import 'models/apartamento.dart';
import 'models/bar.dart';
import 'models/cafeteria.dart';
import 'models/camping.dart';
import 'models/evento.dart';
import 'models/guia.dart';
import 'models/lista.dart';
import 'models/monumento.dart';
import 'models/museo.dart';
import 'models/oficina_turismo.dart';
import 'models/restaurante.dart';
import 'models/salon_banquetes.dart';
import 'models/turismo_activo.dart';
import 'models/turismo_rural.dart';
import 'models/vivienda.dart';

class VistaLista extends StatefulWidget {
  final Lista lista;

  VistaLista({Key key, @required this.lista}) : super(key: key);

  @override
  _VistaListaState createState() => _VistaListaState();
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Exportar', icon: Icons.share),
  //const Choice(title: 'Editar', icon: Icons.edit),
  const Choice(title: 'Eliminar', icon: Icons.delete)
];

class _VistaListaState extends State<VistaLista> {
  Choice _selectedChoice = choices[0];

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
      switch (_selectedChoice.title) {
        case "Exportar":
          FlutterClipboard.copy(jsonEncode(widget.lista));
          Toast.show("Copiado en el portapapeles", context);
          break;
      //case "Editar":
      //  break;
        case "Eliminar":
          Utils().eliminarLista(widget.lista.id);
          Toast.show('Lista "${widget.lista.nombre}" eliminada', context);
          Navigator.pop(context);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lista.nombre),
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(choice.icon),
                      ),
                      Text(choice.title)
                    ],
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.person),
                    ),
                    Text("${widget.lista.autor}",
                        style: TextStyle(fontSize: 16))
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.short_text),
                    ),
                    Flexible(
                      child: Text("${widget.lista.descripcion}",
                          overflow: TextOverflow.fade,
                          style: TextStyle(fontSize: 16)),
                    )
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.today),
                    ),
                    Text(
                        widget.lista.dias >= 0
                            ? "${widget.lista.dias} días"
                            : "N/A",
                        style: TextStyle(fontSize: 16))
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.map),
                    ),
                    Text("${widget.lista.provincias.toList().join(", ")}",
                        style: TextStyle(fontSize: 16))
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text("Creación: ${widget.lista.timestamp.toLocal()}",
                        style: TextStyle(fontSize: 16, color: Colors.grey))
                  ]),
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: widget.lista.elementos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: InkWell(
                            splashColor: Colors.orange,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VistaDetalles(
                                      elemento: widget.lista.elementos[index],
                                      categoriaElegida:
                                      widget.lista.elementos[index].DB_NOMBRE,
                                    ),
                                  ));
                            },
                            child: ListTile(
                              trailing: InkWell(
                                child: Icon(Icons.delete),
                                onTap: () {
                                  Utils().eliminarElementoDeLista(widget.lista.id,
                                      widget.lista.elementos[index]);
                                  setState(() {
                                    widget.lista.elementos.removeAt(index);
                                  });
                                },
                              ),
                              title:
                              Text('${widget.lista.elementos[index].nombre}'),
                              subtitle: Text(
                                  '${widget.lista.elementos[index].DB_NOMBRE} · ${widget.lista.elementos[index].provincia}'),
                            ),
                          ));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
