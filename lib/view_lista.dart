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
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong/latlong.dart';
import 'package:toast/toast.dart';
import 'package:turiscyl/utils.dart';
import 'package:turiscyl/values/colores.dart';
import 'package:turiscyl/view_detalles.dart';

import 'models/archivo.dart';
import 'models/lista.dart';

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
  List<Marker> _markers = new List<Marker>();
  final PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();
    _markers = _crearMarkers();
  }

  List<Marker> _crearMarkers() {
    List<Marker> lista = new List();
    for (int i = 0; i < widget.lista.elementos.length; i++) {
      try {
        if (widget.lista.elementos[i].posicion.latitude != 1 &&
            widget.lista.elementos[i].posicion.longitude != 1) {
          lista.add(new Marker(
            width: 80.0,
            height: 80.0,
            point: widget.lista.elementos[i].posicion,
            builder: (ctx) => new Container(
              child: Icon(Icons.place, color: Colores().primario),
            ),
          ));
        }
      } catch (e) {
        print(e);
      }
    }
    return lista;
  }

  LatLng _calcularCentroide(List<Marker> markers) {
    double sumX = 0;
    double sumY = 0;

    for (int i = 0; i < markers.length; i++) {
      sumX += markers[i].point.latitude.toDouble();
      sumY += markers[i].point.longitude.toDouble();
    }

    return new LatLng(sumX / markers.length, sumY / markers.length);
  }

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
                _markers.length > 0
                    ? Container(
                  height: 300,
                  child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: FlutterMap(
                          options: new MapOptions(
                              plugins: [PopupMarkerPlugin()],
                              center: _calcularCentroide(_markers),
                              zoom: 14,
                              maxZoom: 17,
                              interactive: true,
                              onTap: (_) =>
                                  _popupLayerController.hidePopup()),
                          layers: [
                            new TileLayerOptions(
                                urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c']),
                            new PopupMarkerLayerOptions(
                                markers: _markers,
                                popupSnap: PopupSnap.top,
                                popupController: _popupLayerController,
                                popupBuilder:
                                    (BuildContext _, Marker marker) {
                                  for (int i = 0;
                                  i < widget.lista.elementos.length;
                                  i++) {
                                    try {
                                      if (marker.point ==
                                          widget.lista.elementos[i]
                                              .posicion) {
                                        return Card(
                                            child: ListTile(
                                              title: Text(widget
                                                  .lista.elementos[i].nombre),
                                              subtitle: Text(widget.lista
                                                  .elementos[i].direccion),
                                              trailing: IconButton(
                                                icon: Icon(Icons.directions),
                                                onPressed: () {
                                                  Utils().openUrl(
                                                      "http://maps.google.com/maps?daddr=${widget
                                                          .lista.elementos[i]
                                                          .posicion
                                                          .latitude}, ${widget
                                                          .lista.elementos[i]
                                                          .posicion
                                                          .longitude}");
                                                },
                                              ),
                                            ));
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                })
                          ])),
                )
                    : Container(),
                _markers.length > 0
                    ? Text(
                  "Solo se muestran en el mapa los lugares con GPS disponibles",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ) : Container(),
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
                                  Utils().eliminarElementoDeLista(
                                      widget.lista.id,
                                      widget.lista.elementos[index]);
                                  setState(() {
                                    widget.lista.elementos.removeAt(index);
                                  });
                                },
                              ),
                              title:
                              Text('${widget.lista.elementos[index].nombre}'),
                              subtitle: Text(
                                  '${widget.lista.elementos[index]
                                      .DB_NOMBRE} · ${widget.lista
                                      .elementos[index].DB_NOMBRE !=
                                      Archivo.NOMBRE ? widget.lista
                                      .elementos[index].provincia : widget.lista
                                      .elementos[index].localidad }'),
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
