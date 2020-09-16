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

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:foursquare/src/api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';
import 'package:turiscyl/crear_lista.dart';
import 'package:turiscyl/db_handler.dart';
import 'package:turiscyl/models/albergue.dart';
import 'package:turiscyl/models/alojamiento_hotelero.dart';
import 'package:turiscyl/models/apartamento.dart';
import 'package:turiscyl/models/cafeteria.dart';
import 'package:turiscyl/models/camping.dart';
import 'package:turiscyl/models/evento.dart';
import 'package:turiscyl/models/monumento.dart';
import 'package:turiscyl/models/museo.dart';
import 'package:turiscyl/models/oficina_turismo.dart';
import 'package:turiscyl/models/turismo_activo.dart';
import 'package:turiscyl/models/turismo_rural.dart';
import 'package:turiscyl/models/venue.dart';
import 'package:turiscyl/models/vivienda.dart';
import 'package:turiscyl/utils.dart';
import 'package:turiscyl/values/colores.dart';
import 'package:turiscyl/values/keys.dart';
import 'package:turiscyl/values/strings.dart';

import 'icons_turiscyl.dart';
import 'material_design_icons.dart';
import 'models/actividad_turistica.dart';
import 'models/bar.dart';
import 'models/guia.dart';
import 'models/lista.dart';
import 'models/restaurante.dart';
import 'models/salon_banquetes.dart';

class VistaDetalles extends StatefulWidget {
  final String categoriaElegida;
  final elemento;

  VistaDetalles(
      {Key key, @required this.categoriaElegida, @required this.elemento})
      : super(key: key);

  @override
  _VistaDetallesState createState() => _VistaDetallesState();
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Abrir en', icon: Icons.open_in_new),
  const Choice(title: 'Cómo llegar', icon: Icons.directions),
  const Choice(title: 'Compartir', icon: Icons.share),
  const Choice(title: 'StreetView', icon: Icons.streetview),
  //const Choice(title: 'Notificaciones', icon: Icons.notifications)
];

class _VistaDetallesState extends State<VistaDetalles> {
  DbHandler dbHandler = new DbHandler();
  API api = API.userless(
      Keys.keyClientIdFoursquare, Keys.keyClientSecretFoursquare);
  Choice _selectedChoice = choices[0];

  @override
  void initState() {
    super.initState();
  }

  Future<Venue> _getPlace() async {
    final List<Map> listaVenuesDb = await dbHandler.consulta(
        'SELECT * FROM Venues WHERE tipo="${widget.elemento.DB_NOMBRE}" AND numero_registro="${widget.elemento.numeroRegistro}"');
    if (listaVenuesDb.length == 1) {
      return Venue.fromMap(listaVenuesDb.first);
    } else {
      final List items = (await api.get('venues/search',
              '&near=${widget.elemento.municipio},${widget.elemento.provincia}&query=${widget.elemento.nombre}'))[
          'venues'];
      if (items.length > 0) {
        Venue venue = Venue.fromFoursquare(items.first);
        Map map = await api.get('venues/${venue.id}/photos', '');
        if (map['photos']['count'] > 0) {
          venue.urlFoto =
              "${map['photos']['items'][0]['prefix']}${map['photos']['items'][0]['width']}x${map['photos']['items'][0]['height']}${map['photos']['items'][0]['suffix']}";
        } else {
          venue.urlFoto = null;
        }
        venue.tipo = widget.elemento.DB_NOMBRE;
        venue.numeroRegistro = widget.elemento.numeroRegistro;
        await dbHandler.abrirDb();
        dbHandler.insertarDatos(null, venue);
        return venue;
      } else {
        return await _getGeolocation();
      }
    }
  }

  Future<Venue> _getGeolocation() async {
    List<Placemark> placemark = await Geolocator().placemarkFromAddress(
        "${widget.elemento.direccion},${widget.elemento.municipio},${widget.elemento.provincia}");
    if (placemark.length > 0) {
      return Venue.fromGeolocation(LatLng(placemark.first.position.latitude,
          placemark.first.position.longitude));
    } else {
      return null;
    }
  }

  Widget _decidirFab() {
    switch (widget.categoriaElegida) {
      case Evento.NOMBRE:
        return new FloatingActionButton(
            child: Icon(
              IconsTurisCyL.calendar_plus
            ),
            onPressed: () {
              final Event event = Event(
                title: widget.elemento.nombre,
                description: widget.elemento.descripcion,
                location: widget.elemento.lugar,
                startDate: widget.elemento.fechaInicio,
                endDate: widget.elemento.fechaFin != null
                    ? widget.elemento.fechaFin
                    : widget.elemento.fechaInicio,
              );
              Add2Calendar.addEvent2Cal(event);
            });
      default:
        return new FloatingActionButton(
            child: Icon(
              Icons.playlist_add,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text('Elegir lista'),
                        actions: [
                          IconButton(
                            icon: Icon(
                                Icons.add,
                                color: Colores().primario
                            ),
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CrearLista(),
                                  ));
                            },
                          )
                        ],
                        content: Container(
                          height: 200,
                          width: 300,
                          child: FutureBuilder(
                              future: Utils().obtenerListasGuardadas(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List> snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final Lista lista = Lista.fromMap(snapshot.data[index]);
                                      return InkWell(
                                        child: ListTile(
                                          title: Text(lista.nombre),
                                        ),
                                        onTap: (){
                                          Utils().anadirElementoALista(lista.id, widget.elemento);
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(snapshot.error);
                                  return Text(snapshot.error);
                                } else {
                                  return Utils().cargandoDatos();
                                }
                              }),
                        ));
                  });
            });
    }
  }

  // ignore: missing_return
  Widget _decidirVista() {
    switch (widget.categoriaElegida) {
      case Bar.NOMBRE:
        return _bar();
      case Cafeteria.NOMBRE:
        return _cafeteria();
      case Restaurante.NOMBRE:
        return _restaurante();
      case SalonBanquetes.NOMBRE:
        return _salonBanquetes();
      case Albergue.NOMBRE:
        return _albergue();
      case AlojamientoHotelero.NOMBRE:
        return _alojamientoHotelero();
      case Apartamento.NOMBRE:
        return _apartamento();
      case Camping.NOMBRE:
        return _camping();
      case TurismoRural.NOMBRE:
        return _turismoRural();
      case Vivienda.NOMBRE:
        return _vivienda();
      case Monumento.NOMBRE:
        return _monumento();
      case Museo.NOMBRE:
        return _museo();
      case Evento.NOMBRE:
        return _evento();
      case ActividadTuristica.NOMBRE:
        return _actividadTuristica();
      case Guia.NOMBRE:
        return _guia();
      case TurismoActivo.NOMBRE:
        return _turismoActivo();
      case OficinaTurismo.NOMBRE:
        return _oficinaTurismo();
    }
  }

  Widget _fotoYMapa() {
    return FutureBuilder<Venue>(
        future: _getPlace(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return Column(children: [
                CarouselSlider(
                  options: CarouselOptions(
                      aspectRatio: 16 / 9, enableInfiniteScroll: false),
                  items: [
                    Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: Container(
                        height: 200,
                        child: FlutterMap(
                          options: new MapOptions(
                              center: widget.elemento.posicion.latitude != -1
                                  ? widget.elemento.posicion
                                  : snapshot.data.posicion,
                              zoom: 17,
                              maxZoom: 17,
                              interactive: true),
                          layers: [
                            new TileLayerOptions(
                                urlTemplate:
                                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c']),
                            new MarkerLayerOptions(
                              markers: [
                                new Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: widget.elemento.posicion.latitude != -1
                                      ? widget.elemento.posicion
                                      : snapshot.data.posicion,
                                  builder: (ctx) => new Container(
                                    child: Icon(Icons.place, color: Colores().primario,),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    snapshot.data.urlFoto != null && snapshot.data.urlFoto != ''
                        ? Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: EdgeInsets.all(10),
                            child: Container(
                              height: 200,
                              child: Image.network(snapshot.data.urlFoto,
                                  fit: BoxFit.cover, width: double.infinity),
                              //child: Text("Funciona"),
                            ),
                          )
                        : Container(),
                  ],
                ),
                widget.elemento.posicion.latitude != -1
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Text(
                          "Es posible que la ubicación mostrada no se corresponda con la real",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      )
              ]);
            }
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          } else {
            return Utils().cargandoDatos();
          }
        });
  }

  Widget _fotoYMapaEvento() {
    return CarouselSlider(
      options:
          CarouselOptions(aspectRatio: 16 / 9, enableInfiniteScroll: false),
      items: [
        Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: Container(
            height: 200,
            child: FlutterMap(
              options: new MapOptions(
                  center: widget.elemento.posicion,
                  zoom: 17,
                  maxZoom: 17,
                  interactive: true),
              layers: [
                new TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                new MarkerLayerOptions(
                  markers: [
                    new Marker(
                      width: 80.0,
                      height: 80.0,
                      point: widget.elemento.posicion,
                      builder: (ctx) => new Container(
                        child: Icon(Icons.place, color:Colores().primario),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: Container(
            height: 200,
            child: widget.elemento.urlImagen != ''
                ? Image.network(widget.elemento.urlImagen,
                    fit: BoxFit.cover, width: double.infinity)
                : Image.network(widget.elemento.urlMiniatura,
                    fit: BoxFit.cover, width: double.infinity),
            //child: Text("Funciona"),
          ),
        )
      ],
    );
  }

  Widget _soloMapa() {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Container(
        height: 200,
        child: FlutterMap(
          options: new MapOptions(
              center: widget.elemento.posicion,
              zoom: 17,
              maxZoom: 17,
              interactive: true),
          layers: [
            new TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            new MarkerLayerOptions(
              markers: [
                new Marker(
                  width: 80.0,
                  height: 80.0,
                  point: widget.elemento.posicion,
                  builder: (ctx) => new Container(
                    child: Icon(Icons.place),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar() {
    return Column(
      children: [
        _fotoYMapa(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: new Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("Accesibilidad PMR",
                                        style: TextStyle(
                                            color: Colores().dark,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(IconsTurisCyL.wheelchair_accessibility,
                                            color: Colores().dark),
                                        Text(
                                          widget.elemento.pmr ? "Sí" : "No",
                                          style:
                                              TextStyle(color: Colores().dark),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: new Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("Municipio",
                                        style: TextStyle(
                                            color: Colores().dark,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.location_city,
                                            color: Colores().dark),
                                        Flexible(
                                          child: Text(
                                            widget.elemento.municipio,
                                            style: TextStyle(
                                              color: Colores().dark,
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: new Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("Dirección",
                                        style: TextStyle(
                                            color: Colores().dark,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.place,
                                            color: Colores().dark),
                                        Flexible(
                                          child: Text(
                                            widget.elemento.direccion,
                                            style: TextStyle(
                                              color: Colores().dark,
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: new Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("Teléfono(s)",
                                        style: TextStyle(
                                            color: Colores().dark,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.phone,
                                            color: Colores().dark),
                                        InkWell(
                                          child: Text(
                                            "${widget.elemento.telefono1 != '' ? widget.elemento.telefono1 : "No definido"}",
                                            style: TextStyle(
                                                color: Colores().light),
                                          ),
                                          onTap: () {
                                            Utils().openUrl(
                                                "tel:${widget.elemento.telefono1}");
                                          },
                                        ),
                                        Text("\t"),
                                        InkWell(
                                          child: Text(
                                            "${widget.elemento.telefono2}",
                                            style: TextStyle(
                                                color: Colores().light),
                                          ),
                                          onTap: () {
                                            Utils().openUrl(
                                                "tel:${widget.elemento.telefono2}");
                                          },
                                        ),
                                        Text("\t"),
                                        InkWell(
                                          child: Text(
                                            "${widget.elemento.telefono3}",
                                            style: TextStyle(
                                                color: Colores().light),
                                          ),
                                          onTap: () {
                                            Utils().openUrl(
                                                "tel:${widget.elemento.telefono3}");
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: new Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("Página web",
                                        style: TextStyle(
                                            color: Colores().dark,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.web, color: Colores().dark),
                                        Flexible(
                                            child: InkWell(
                                          child: Text(
                                            widget.elemento.web != ''
                                                ? "${widget.elemento.web}"
                                                : "No definido",
                                            style: TextStyle(
                                                color: Colores().light),
                                          ),
                                          onTap: () {
                                            widget.elemento.web != ''
                                                ? Utils().openUrl(
                                                    "${widget.elemento.web}")
                                                : null;
                                          },
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: new Container(
                              child: Center(
                                child: widget.elemento.especialidades != ''
                                    ? Column(
                                        children: [
                                          Text("Especialidades",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                widget.elemento.especialidades,
                                                style: TextStyle(
                                                    color: Colores().dark),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: new Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("Número registro",
                                        style: TextStyle(
                                            color: Colores().dark,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(IconsTurisCyL.barcode,
                                            color: Colores().dark),
                                        Text(
                                          widget.elemento.numeroRegistro,
                                          style:
                                              TextStyle(color: Colores().dark),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: new Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("Provincia",
                                        style: TextStyle(
                                            color: Colores().dark,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.filter_hdr,
                                            color: Colores().dark),
                                        Text(
                                          widget.elemento.provincia,
                                          style:
                                              TextStyle(color: Colores().dark),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: new Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("Código postal",
                                        style: TextStyle(
                                            color: Colores().dark,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.label,
                                            color: Colores().dark),
                                        Flexible(
                                          child: Text(
                                            widget.elemento.cp.toString(),
                                            style: TextStyle(
                                              color: Colores().dark,
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: new Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("E-mail",
                                        style: TextStyle(
                                            color: Colores().dark,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.mail, color: Colores().dark),
                                        Flexible(
                                            child: InkWell(
                                          child: Text(
                                            widget.elemento.email != ''
                                                ? "${widget.elemento.email}"
                                                : "No definido",
                                            style: TextStyle(
                                                color: Colores().light),
                                          ),
                                          onTap: () {
                                            widget.elemento.email != ''
                                                ? Utils().openUrl(
                                                    "mailto:${widget.elemento.email}")
                                                : null;
                                          },
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: new Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("Plazas",
                                        style: TextStyle(
                                            color: Colores().dark,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.people,
                                            color: Colores().dark),
                                        Text(
                                          widget.elemento.plazas > 0
                                              ? widget.elemento.plazas
                                                  .toString()
                                              : "No definido",
                                          style:
                                              TextStyle(color: Colores().dark),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _cafeteria() {
    return Column(
      children: [
        _fotoYMapa(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Accesibilidad PMR",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.wheelchair_accessibility,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.pmr ? "Sí" : "No",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Tipo",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.store,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.tipo,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Municipio",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.location_city,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.municipio,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Dirección",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.place,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.direccion,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Teléfono(s)",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.phone,
                                              color: Colores().dark),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono1 != '' ? widget.elemento.telefono1 : "No definido"}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono1}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono2}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono2}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono3}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono3}");
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Página web",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.web,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.web != ''
                                                  ? "${widget.elemento.web}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.web != ''
                                                  ? Utils().openUrl(
                                                      "${widget.elemento.web}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Número registro",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.barcode,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.numeroRegistro,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Categoría",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.local_cafe,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.categoria,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Código postal",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.label,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.cp.toString(),
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("E-mail",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.mail,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.email != ''
                                                  ? "${widget.elemento.email}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.email != ''
                                                  ? Utils().openUrl(
                                                      "mailto:${widget.elemento.email}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Plazas",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.people,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.plazas > 0
                                                ? widget.elemento.plazas
                                                    .toString()
                                                : "No definido",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _restaurante() {
    return Column(
      children: [
        _fotoYMapa(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Accesibilidad PMR",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.wheelchair_accessibility,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.pmr ? "Sí" : "No",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Municipio",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.location_city,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.municipio,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Dirección",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.place,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.direccion,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Teléfono(s)",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.phone,
                                              color: Colores().dark),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono1 != '' ? widget.elemento.telefono1 : "No definido"}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono1}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono2}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono2}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono3}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono3}");
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Página web",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.web,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.web != ''
                                                  ? "${widget.elemento.web}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.web != ''
                                                  ? Utils().openUrl(
                                                      "${widget.elemento.web}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: widget.elemento.especialidades != ''
                                      ? Column(
                                          children: [
                                            Text("Especialidades",
                                                style: TextStyle(
                                                    color: Colores().dark,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  widget
                                                      .elemento.especialidades,
                                                  style: TextStyle(
                                                      color: Colores().dark),
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Número registro",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.barcode,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.numeroRegistro,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Categoría",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.silverware_fork_knife,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.categoria,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Código postal",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.label,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.cp.toString(),
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("E-mail",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.mail,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.email != ''
                                                  ? "${widget.elemento.email}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.email != ''
                                                  ? Utils().openUrl(
                                                      "mailto:${widget.elemento.email}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Plazas",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.people,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.plazas > 0
                                                ? widget.elemento.plazas
                                                    .toString()
                                                : "No definido",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _salonBanquetes() {
    return Column(
      children: [
        _fotoYMapa(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Accesibilidad PMR",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.wheelchair_accessibility,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.pmr ? "Sí" : "No",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Municipio",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.location_city,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.municipio,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Dirección",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.place,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.direccion,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Teléfono(s)",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.phone,
                                              color: Colores().dark),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono1 != '' ? widget.elemento.telefono1 : "No definido"}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono1}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono2}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono2}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono3}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono3}");
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Página web",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.web,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.web != ''
                                                  ? "${widget.elemento.web}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.web != ''
                                                  ? Utils().openUrl(
                                                      "${widget.elemento.web}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Número registro",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.barcode,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.numeroRegistro,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Categoría",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.glass_flute,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.categoria,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Código postal",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.label,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.cp.toString(),
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("E-mail",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.mail,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.email != ''
                                                  ? "${widget.elemento.email}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.email != ''
                                                  ? Utils().openUrl(
                                                      "mailto:${widget.elemento.email}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Plazas",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.people,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.plazas > 0
                                                ? widget.elemento.plazas
                                                    .toString()
                                                : "No definido",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _albergue() {
    return Column(
      children: [
        _fotoYMapa(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Accesibilidad PMR",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.wheelchair_accessibility,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.pmr ? "Sí" : "No",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Tipo",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.home,
                                              color: Colores().dark),
                                          Flexible(
                                              child: Text(
                                            widget.elemento.tipo,
                                            style: TextStyle(
                                                color: Colores().dark),
                                            overflow: TextOverflow.clip,
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Municipio",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.location_city,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.municipio,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Dirección",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.place,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.direccion,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Teléfono(s)",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.phone,
                                              color: Colores().dark),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono1 != '' ? widget.elemento.telefono1 : "No definido"}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono1}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono2}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono2}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono3}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono3}");
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Página web",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.web,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.web != ''
                                                  ? "${widget.elemento.web}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.web != ''
                                                  ? Utils().openUrl(
                                                      "${widget.elemento.web}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Número registro",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.barcode,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.numeroRegistro,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Código postal",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.label,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.cp.toString(),
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("E-mail",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.mail,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.email != ''
                                                  ? "${widget.elemento.email}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.email != ''
                                                  ? Utils().openUrl(
                                                      "mailto:${widget.elemento.email}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Plazas",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.people,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.plazas > 0
                                                ? widget.elemento.plazas
                                                    .toString()
                                                : "No definido",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _alojamientoHotelero() {
    return Column(
      children: [
        _fotoYMapa(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Accesibilidad PMR",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.wheelchair_accessibility,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.pmr ? "Sí" : "No",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Municipio",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.location_city,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.municipio,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Dirección",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.place,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.direccion,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Teléfono(s)",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.phone,
                                              color: Colores().dark),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono1 != '' ? widget.elemento.telefono1 : "No definido"}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono1}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono2}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono2}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono3}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono3}");
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Página web",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.web,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.web != ''
                                                  ? "${widget.elemento.web}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.web != ''
                                                  ? Utils().openUrl(
                                                      "${widget.elemento.web}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Número registro",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.barcode,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.numeroRegistro,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Categoría",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.star,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.categoria,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Código postal",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.label,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.cp.toString(),
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("E-mail",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.mail,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.email != ''
                                                  ? "${widget.elemento.email}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.email != ''
                                                  ? Utils().openUrl(
                                                      "mailto:${widget.elemento.email}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Plazas",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.people,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.plazas > 0
                                                ? widget.elemento.plazas
                                                    .toString()
                                                : "No definido",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _apartamento() {
    return Column(
      children: [
        _fotoYMapa(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Accesibilidad PMR",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.wheelchair_accessibility,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.pmr ? "Sí" : "No",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Municipio",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.location_city,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.municipio,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Dirección",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.place,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.direccion,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Teléfono(s)",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.phone,
                                              color: Colores().dark),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono1 != '' ? widget.elemento.telefono1 : "No definido"}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono1}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono2}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono2}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono3}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono3}");
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Página web",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.web,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.web != ''
                                                  ? "${widget.elemento.web}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.web != ''
                                                  ? Utils().openUrl(
                                                      "${widget.elemento.web}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Número registro",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.barcode,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.numeroRegistro,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Categoría",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.vpn_key,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.categoria,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Código postal",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.label,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.cp.toString(),
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("E-mail",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.mail,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.email != ''
                                                  ? "${widget.elemento.email}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.email != ''
                                                  ? Utils().openUrl(
                                                      "mailto:${widget.elemento.email}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Plazas",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.people,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.plazas > 0
                                                ? widget.elemento.plazas
                                                    .toString()
                                                : "No definido",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _camping() {
    return Column(
      children: [
        _fotoYMapa(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Accesibilidad PMR",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.wheelchair_accessibility,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.pmr ? "Sí" : "No",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Municipio",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.location_city,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.municipio,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Dirección",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.place,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.direccion,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Teléfono(s)",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.phone,
                                              color: Colores().dark),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono1 != '' ? widget.elemento.telefono1 : "No definido"}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono1}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono2}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono2}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono3}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono3}");
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Página web",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.web,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.web != ''
                                                  ? "${widget.elemento.web}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.web != ''
                                                  ? Utils().openUrl(
                                                      "${widget.elemento.web}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Número registro",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.barcode,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.numeroRegistro,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Categoría",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.star,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.categoria,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Código postal",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.label,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.cp.toString(),
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("E-mail",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.mail,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.email != ''
                                                  ? "${widget.elemento.email}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.email != ''
                                                  ? Utils().openUrl(
                                                      "mailto:${widget.elemento.email}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Plazas",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.people,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.plazas > 0
                                                ? widget.elemento.plazas
                                                    .toString()
                                                : "No definido",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _turismoRural() {
    return Column(
      children: [
        _fotoYMapa(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Accesibilidad PMR",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.wheelchair_accessibility,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.pmr ? "Sí" : "No",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Municipio",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.location_city,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.municipio,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Dirección",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.place,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.direccion,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Teléfono(s)",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.phone,
                                              color: Colores().dark),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono1 != '' ? widget.elemento.telefono1 : "No definido"}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono1}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono2}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono2}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono3}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono3}");
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Página web",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.web,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.web != ''
                                                  ? "${widget.elemento.web}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.web != ''
                                                  ? Utils().openUrl(
                                                      "${widget.elemento.web}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Posada real",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.crown,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.posadaReal
                                                ? "Sí"
                                                : "No",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Número registro",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.barcode,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.numeroRegistro,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Categoría",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.star,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.categoria,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Código postal",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.label,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.cp.toString(),
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("E-mail",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.mail,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.email != ''
                                                  ? "${widget.elemento.email}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.email != ''
                                                  ? Utils().openUrl(
                                                      "mailto:${widget.elemento.email}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Plazas",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.people,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.plazas > 0
                                                ? widget.elemento.plazas
                                                    .toString()
                                                : "No definido",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _vivienda() {
    return Column(
      children: [
        _fotoYMapa(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Accesibilidad PMR",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.wheelchair_accessibility,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.pmr ? "Sí" : "No",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Municipio",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.location_city,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.municipio,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Dirección",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.place,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.direccion,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Teléfono(s)",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.phone,
                                              color: Colores().dark),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono1 != '' ? widget.elemento.telefono1 : "No definido"}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono1}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono2}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono2}");
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Página web",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.web,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.web != ''
                                                  ? "${widget.elemento.web}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.web != ''
                                                  ? Utils().openUrl(
                                                      "${widget.elemento.web}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Número registro",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.barcode,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.numeroRegistro,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Código postal",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.label,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.cp.toString(),
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("E-mail",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.mail,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.email != ''
                                                  ? "${widget.elemento.email}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.email != ''
                                                  ? Utils().openUrl(
                                                      "mailto:${widget.elemento.email}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Plazas",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.people,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.plazas > 0
                                                ? widget.elemento.plazas
                                                    .toString()
                                                : "No definido",
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _monumento() {
    return Column(
      children: [
        _soloMapa(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: new Row(
                        children: <Widget>[
                          Expanded(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("ID BIC",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(IconsTurisCyL.church,
                                                  color: Colores().dark),
                                              Text(
                                                widget.elemento.idBic
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colores().dark),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                widget.elemento.tipoMonumento != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 13),
                                        child: new Container(
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text("Tipo Monumento",
                                                    style: TextStyle(
                                                        color: Colores().dark,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Icon(IconsTurisCyL.bank,
                                                        color: Colores().dark),
                                                    Text(
                                                      widget.elemento
                                                          .tipoMonumento,
                                                      style: TextStyle(
                                                          color:
                                                              Colores().dark),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                widget.elemento.tipoConstruccion != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 13),
                                        child: new Container(
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text("Tipo Construcción",
                                                    style: TextStyle(
                                                        color: Colores().dark,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Icon(IconsTurisCyL.bank,
                                                        color: Colores().dark),
                                                    Flexible(
                                                      child: Text(
                                                        widget.elemento
                                                            .tipoConstruccion,
                                                        style: TextStyle(
                                                            color:
                                                                Colores().dark),
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Municipio",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.location_city,
                                                  color: Colores().dark),
                                              Flexible(
                                                child: Text(
                                                  widget.elemento.municipio,
                                                  style: TextStyle(
                                                    color: Colores().dark,
                                                  ),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                widget.elemento.direccion != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 13),
                                        child: new Container(
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text("Dirección",
                                                    style: TextStyle(
                                                        color: Colores().dark,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Icon(Icons.place,
                                                        color: Colores().dark),
                                                    Flexible(
                                                      child: Text(
                                                        widget
                                                            .elemento.direccion,
                                                        style: TextStyle(
                                                          color: Colores().dark,
                                                        ),
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Teléfono(s)",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.phone,
                                                  color: Colores().dark),
                                              InkWell(
                                                child: Text(
                                                  "${widget.elemento.telefono != '' ? widget.elemento.telefono : "No definido"}",
                                                  style: TextStyle(
                                                      color: Colores().light),
                                                ),
                                                onTap: () {
                                                  Utils().openUrl(
                                                      "tel:${widget.elemento.telefono}");
                                                },
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Página web",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.web,
                                                  color: Colores().dark),
                                              Flexible(
                                                  child: InkWell(
                                                child: Text(
                                                  widget.elemento.web != ''
                                                      ? "${widget.elemento.web}"
                                                      : "No definido",
                                                  style: TextStyle(
                                                      color: Colores().light),
                                                ),
                                                onTap: () {
                                                  widget.elemento.web != ''
                                                      ? Utils().openUrl(
                                                          "${widget.elemento.web}")
                                                      : null;
                                                },
                                              ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Número registro",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(IconsTurisCyL.barcode,
                                                  color: Colores().dark),
                                              Text(
                                                widget.elemento.numeroRegistro
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colores().dark),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                widget.elemento.clasificacion != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 13),
                                        child: new Container(
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text("Clasificación",
                                                    style: TextStyle(
                                                        color: Colores().dark,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Icon(IconsTurisCyL.castle,
                                                        color: Colores().dark),
                                                    Text(
                                                      widget.elemento
                                                          .clasificacion,
                                                      style: TextStyle(
                                                          color:
                                                              Colores().dark),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Código postal",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.label,
                                                  color: Colores().dark),
                                              Flexible(
                                                child: Text(
                                                  widget.elemento.cp.toString(),
                                                  style: TextStyle(
                                                    color: Colores().dark,
                                                  ),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("E-mail",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.mail,
                                                  color: Colores().dark),
                                              Flexible(
                                                  child: InkWell(
                                                child: Text(
                                                  widget.elemento.email != ''
                                                      ? "${widget.elemento.email}"
                                                      : "No definido",
                                                  style: TextStyle(
                                                      color: Colores().light),
                                                ),
                                                onTap: () {
                                                  widget.elemento.email != ''
                                                      ? Utils().openUrl(
                                                          "mailto:${widget.elemento.email}")
                                                      : null;
                                                },
                                              ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Text("Descripción",
                        style: TextStyle(
                            color: Colores().dark,
                            fontWeight: FontWeight.bold)),
                    widget.elemento.descripcion != null
                        ? Html(data: widget.elemento.descripcion)
                        : Text("No disponible"),
                    Text("Horarios y Tarifas",
                        style: TextStyle(
                            color: Colores().dark,
                            fontWeight: FontWeight.bold)),
                    widget.elemento.horariosYTarifas != null
                        ? Html(data: widget.elemento.horariosYTarifas)
                        : Text("No disponibles"),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _museo() {
    return Column(
      children: [
        _soloMapa(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: new Row(
                        children: <Widget>[
                          Expanded(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Localidad",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.location_city,
                                                  color: Colores().dark),
                                              Flexible(
                                                child: Text(
                                                  widget.elemento.localidad,
                                                  style: TextStyle(
                                                    color: Colores().dark,
                                                  ),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                widget.elemento.direccion != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 13),
                                        child: new Container(
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text("Dirección",
                                                    style: TextStyle(
                                                        color: Colores().dark,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Icon(Icons.place,
                                                        color: Colores().dark),
                                                    Flexible(
                                                      child: Text(
                                                        widget.elemento.calle,
                                                        style: TextStyle(
                                                          color: Colores().dark,
                                                        ),
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Teléfono",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.phone,
                                                  color: Colores().dark),
                                              InkWell(
                                                child: Text(
                                                  "${widget.elemento.telefono != '' ? widget.elemento.telefono : "No definido"}",
                                                  style: TextStyle(
                                                      color: Colores().light),
                                                ),
                                                onTap: () {
                                                  Utils().openUrl(
                                                      "tel:${widget.elemento.telefono}");
                                                },
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Página web",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.web,
                                                  color: Colores().dark),
                                              Flexible(
                                                  child: InkWell(
                                                child: Text(
                                                  widget.elemento.web != ''
                                                      ? "${widget.elemento.web}"
                                                      : "No definido",
                                                  style: TextStyle(
                                                      color: Colores().light),
                                                ),
                                                onTap: () {
                                                  widget.elemento.web != ''
                                                      ? Utils().openUrl(
                                                          "${widget.elemento.web}")
                                                      : null;
                                                },
                                              ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Código postal",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.label,
                                                  color: Colores().dark),
                                              Flexible(
                                                child: Text(
                                                  widget.elemento.cp.toString(),
                                                  style: TextStyle(
                                                    color: Colores().dark,
                                                  ),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("E-mail",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.mail,
                                                  color: Colores().dark),
                                              Flexible(
                                                  child: InkWell(
                                                child: Text(
                                                  widget.elemento.email != ''
                                                      ? "${widget.elemento.email}"
                                                      : "No definido",
                                                  style: TextStyle(
                                                      color: Colores().light),
                                                ),
                                                onTap: () {
                                                  widget.elemento.email != ''
                                                      ? Utils().openUrl(
                                                          "mailto:${widget.elemento.email}")
                                                      : null;
                                                },
                                              ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Text("Descripción",
                        style: TextStyle(
                            color: Colores().dark,
                            fontWeight: FontWeight.bold)),
                    widget.elemento.descripcion != ''
                        ? Text(widget.elemento.descripcion)
                        : Text("No disponible"),
                    Text("Información adicional",
                        style: TextStyle(
                            color: Colores().dark,
                            fontWeight: FontWeight.bold)),
                    widget.elemento.informacion != ''
                        ? Html(data: widget.elemento.informacion)
                        : Text("No disponible"),
                    Text("Enlace al contenido",
                        style: TextStyle(
                            color: Colores().dark,
                            fontWeight: FontWeight.bold)),
                    InkWell(
                      child: Text(widget.elemento.enlaceContenido,
                          style: TextStyle(
                              color: Colores().light,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        Utils().openUrl(widget.elemento.enlaceContenido);
                      },
                    ),
                    Text("Datos personales",
                        style: TextStyle(
                            color: Colores().dark,
                            fontWeight: FontWeight.bold)),
                    widget.elemento.datosPersonales != ''
                        ? Html(data: widget.elemento.datosPersonales)
                        : Text("No disponible"),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _evento() {
    return Column(
      children: [
        _fotoYMapaEvento(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Lugar de celebración",
                        style: TextStyle(
                            color: Colores().dark,
                            fontWeight: FontWeight.bold)),
                    widget.elemento.lugar != ''
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(widget.elemento.lugar),
                          )
                        : Text("No disponible"),
                    Container(
                      child: new Row(
                        children: <Widget>[
                          Expanded(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Fecha inicio",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.calendar_today,
                                                  color: Colores().dark),
                                              Flexible(
                                                child: Text(
                                                  "${widget.elemento.fechaInicio.day}/${widget.elemento.fechaInicio.month}/${widget.elemento.fechaInicio.year} - ${widget.elemento.horaInicio}",
                                                  style: TextStyle(
                                                    color: Colores().dark,
                                                  ),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Temática",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(IconsTurisCyL.stadium_variant,
                                                  color: Colores().dark),
                                              Flexible(
                                                child: Text(
                                                  widget.elemento.tematica,
                                                  style: TextStyle(
                                                    color: Colores().dark,
                                                  ),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Precio",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.attach_money,
                                                  color: Colores().dark),
                                              Flexible(
                                                child: Text(
                                                  widget.elemento.precio,
                                                  style: TextStyle(
                                                    color: Colores().dark,
                                                  ),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Localidad",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.location_city,
                                                  color: Colores().dark),
                                              Flexible(
                                                child: Text(
                                                  widget.elemento.localidad,
                                                  style: TextStyle(
                                                    color: Colores().dark,
                                                  ),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                widget.elemento.calle != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 13),
                                        child: new Container(
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text("Dirección",
                                                    style: TextStyle(
                                                        color: Colores().dark,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Icon(Icons.place,
                                                        color: Colores().dark),
                                                    Flexible(
                                                      child: Text(
                                                        widget.elemento.calle,
                                                        style: TextStyle(
                                                          color: Colores().dark,
                                                        ),
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Fecha fin",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.calendar_today,
                                                  color: Colores().dark),
                                              Flexible(
                                                child: widget.elemento
                                                            .fechaFin !=
                                                        null
                                                    ? Text(
                                                        "${widget.elemento.fechaFin.day}/${widget.elemento.fechaFin.month}/${widget.elemento.fechaFin.year} - ${widget.elemento.horaFin}",
                                                        style: TextStyle(
                                                          color: Colores().dark,
                                                        ),
                                                        overflow:
                                                            TextOverflow.clip,
                                                      )
                                                    : Text(
                                                        "${widget.elemento.fechaInicio.day}/${widget.elemento.fechaInicio.month}/${widget.elemento.fechaInicio.year} - ${widget.elemento.horaFin}",
                                                        style: TextStyle(
                                                          color: Colores().dark,
                                                        ),
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Categoría",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(IconsTurisCyL.shape,
                                                  color: Colores().dark),
                                              Flexible(
                                                child: Text(
                                                  widget.elemento.categoria,
                                                  style: TextStyle(
                                                    color: Colores().dark,
                                                  ),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Destinatarios",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.people,
                                                  color: Colores().dark),
                                              Flexible(
                                                child: Text(
                                                  widget.elemento.destinatarios,
                                                  style: TextStyle(
                                                    color: Colores().dark,
                                                  ),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: new Container(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Código postal",
                                              style: TextStyle(
                                                  color: Colores().dark,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.label,
                                                  color: Colores().dark),
                                              Flexible(
                                                child: Text(
                                                  widget.elemento.cp.toString(),
                                                  style: TextStyle(
                                                    color: Colores().dark,
                                                  ),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Text("Descripción",
                        style: TextStyle(
                            color: Colores().dark,
                            fontWeight: FontWeight.bold)),
                    widget.elemento.descripcion != ''
                        ? Html(data: widget.elemento.descripcion)
                        : Text("No disponible"),
                    Text("Enlace al contenido",
                        style: TextStyle(
                            color: Colores().dark,
                            fontWeight: FontWeight.bold)),
                    InkWell(
                      child: Text(widget.elemento.urlEnlace,
                          style: TextStyle(
                              color: Colores().light,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        Utils().openUrl(widget.elemento.urlEnlace);
                      },
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _actividadTuristica() {
    return Column(
      children: [
        _fotoYMapa(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Municipio",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.location_city,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.municipio,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Dirección",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.place,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.direccion,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Teléfono(s)",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.phone,
                                              color: Colores().dark),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono1 != '' ? widget.elemento.telefono1 : "No definido"}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono1}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono2}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono2}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono3}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono3}");
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Página web",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.web,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.web != ''
                                                  ? "${widget.elemento.web}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.web != ''
                                                  ? Utils().openUrl(
                                                      "${widget.elemento.web}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Número registro",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.barcode,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.numeroRegistro,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Código postal",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.label,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.cp.toString(),
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("E-mail",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.mail,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.email != ''
                                                  ? "${widget.elemento.email}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.email != ''
                                                  ? Utils().openUrl(
                                                      "mailto:${widget.elemento.email}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _guia() {
    return Column(
      children: [
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Idiomas",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.translate,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.idiomas,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Teléfono(s)",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.phone,
                                              color: Colores().dark),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono1 != '' ? widget.elemento.telefono1 : "No definido"}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono1}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono2}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono2}");
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Página web",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.web,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.web != ''
                                                  ? "${widget.elemento.web}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.web != ''
                                                  ? Utils().openUrl(
                                                      "${widget.elemento.web}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Número guía",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.barcode,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.numeroGuia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("E-mail",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.mail,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.email != ''
                                                  ? "${widget.elemento.email}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.email != ''
                                                  ? Utils().openUrl(
                                                      "mailto:${widget.elemento.email}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _turismoActivo() {
    return Column(
      children: [
        _fotoYMapa(),
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Municipio",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.location_city,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.municipio,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Dirección",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.place,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.direccion,
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Teléfono(s)",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.phone,
                                              color: Colores().dark),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono1 != '' ? widget.elemento.telefono1 : "No definido"}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono1}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono2}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono2}");
                                            },
                                          ),
                                          Text("\t"),
                                          InkWell(
                                            child: Text(
                                              "${widget.elemento.telefono3}",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              Utils().openUrl(
                                                  "tel:${widget.elemento.telefono3}");
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Página web",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.web,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.web != ''
                                                  ? "${widget.elemento.web}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.web != ''
                                                  ? Utils().openUrl(
                                                      "${widget.elemento.web}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Número registro",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(IconsTurisCyL.barcode,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.numeroRegistro,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Código postal",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.label,
                                              color: Colores().dark),
                                          Flexible(
                                            child: Text(
                                              widget.elemento.cp.toString(),
                                              style: TextStyle(
                                                color: Colores().dark,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("E-mail",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.mail,
                                              color: Colores().dark),
                                          Flexible(
                                              child: InkWell(
                                            child: Text(
                                              widget.elemento.email != ''
                                                  ? "${widget.elemento.email}"
                                                  : "No definido",
                                              style: TextStyle(
                                                  color: Colores().light),
                                            ),
                                            onTap: () {
                                              widget.elemento.email != ''
                                                  ? Utils().openUrl(
                                                      "mailto:${widget.elemento.email}")
                                                  : null;
                                            },
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _oficinaTurismo() {
    return Column(
      children: [
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 13),
                                child: new Container(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text("Municipio",
                                            style: TextStyle(
                                                color: Colores().dark,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.location_city,
                                                color: Colores().dark),
                                            Flexible(
                                              child: Text(
                                                widget.elemento.municipio,
                                                style: TextStyle(
                                                  color: Colores().dark,
                                                ),
                                                overflow: TextOverflow.clip,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 13),
                                child: new Container(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text("Dirección",
                                            style: TextStyle(
                                                color: Colores().dark,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.place,
                                                color: Colores().dark),
                                            Flexible(
                                              child: Text(
                                                widget.elemento.direccion,
                                                style: TextStyle(
                                                  color: Colores().dark,
                                                ),
                                                overflow: TextOverflow.clip,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 13),
                                child: new Container(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text("Teléfono(s)",
                                            style: TextStyle(
                                                color: Colores().dark,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.phone,
                                                color: Colores().dark),
                                            InkWell(
                                              child: Text(
                                                "${widget.elemento.telefono1 != '' ? widget.elemento.telefono1 : "No definido"}",
                                                style: TextStyle(
                                                    color: Colores().light),
                                              ),
                                              onTap: () {
                                                Utils().openUrl(
                                                    "tel:${widget.elemento.telefono1}");
                                              },
                                            ),
                                            Text("\t"),
                                            InkWell(
                                              child: Text(
                                                "${widget.elemento.telefono2}",
                                                style: TextStyle(
                                                    color: Colores().light),
                                              ),
                                              onTap: () {
                                                Utils().openUrl(
                                                    "tel:${widget.elemento.telefono2}");
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 13),
                                child: new Container(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text("Página web",
                                            style: TextStyle(
                                                color: Colores().dark,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.web,
                                                color: Colores().dark),
                                            Flexible(
                                                child: InkWell(
                                              child: Text(
                                                widget.elemento.web != ''
                                                    ? "${widget.elemento.web}"
                                                    : "No definido",
                                                style: TextStyle(
                                                    color: Colores().light),
                                              ),
                                              onTap: () {
                                                widget.elemento.web != ''
                                                    ? Utils().openUrl(
                                                        "${widget.elemento.web}")
                                                    : null;
                                              },
                                            ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Provincia",
                                          style: TextStyle(
                                              color: Colores().dark,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.filter_hdr,
                                              color: Colores().dark),
                                          Text(
                                            widget.elemento.provincia,
                                            style: TextStyle(
                                                color: Colores().dark),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 13),
                                child: new Container(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text("Código postal",
                                            style: TextStyle(
                                                color: Colores().dark,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.label,
                                                color: Colores().dark),
                                            Flexible(
                                              child: Text(
                                                widget.elemento.cp.toString(),
                                                style: TextStyle(
                                                  color: Colores().dark,
                                                ),
                                                overflow: TextOverflow.clip,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 13),
                                child: new Container(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text("E-mail",
                                            style: TextStyle(
                                                color: Colores().dark,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.mail,
                                                color: Colores().dark),
                                            Flexible(
                                                child: InkWell(
                                              child: Text(
                                                widget.elemento.email != ''
                                                    ? "${widget.elemento.email}"
                                                    : "No definido",
                                                style: TextStyle(
                                                    color: Colores().light),
                                              ),
                                              onTap: () {
                                                widget.elemento.email != ''
                                                    ? Utils().openUrl(
                                                        "mailto:${widget.elemento.email}")
                                                    : null;
                                              },
                                            ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Text("Ámbito",
                      style: TextStyle(
                          color: Colores().dark, fontWeight: FontWeight.bold)),
                  widget.elemento.ambito != ''
                      ? Text(widget.elemento.ambito)
                      : Text("No disponible"),
                  Text("Horario",
                      style: TextStyle(
                          color: Colores().dark, fontWeight: FontWeight.bold)),
                  widget.elemento.horario != ''
                      ? Text(widget.elemento.horario)
                      : Text("No disponible"),
                ]),
              ),
            )),
      ],
    );
  }

  void _select(Choice choice) {
    setState(() {
      _selectedChoice = choice;
    });
    switch (_selectedChoice.title) {
      case 'Abrir en':
        if(widget.elemento.posicion.latitude == -1)
          Utils().openUrl(
            "https://www.google.com/maps/search/?api=1&query=${widget.elemento.nombre}+${widget.elemento.provincia}");
        else
          Utils().openUrl(
              "https://www.google.com/maps/search/?api=1&query=${widget.elemento.posicion.latitude}, ${widget.elemento.posicion.longitude}");
        break;
      case 'Cómo llegar':
        if(widget.elemento.posicion.latitude == -1)
          Utils().openUrl(
            "http://maps.google.com/maps?daddr=${widget.elemento.nombre}+${widget.elemento.provincia}");
        else
          Utils().openUrl(
              "http://maps.google.com/maps?daddr=${widget.elemento.posicion.latitude}, ${widget.elemento.posicion.longitude}");;
        break;
      case 'Compartir':
        Share.share(
            "${widget.elemento.nombre}\n${widget.elemento.direccion}, ${widget.elemento.cp}\n${widget.elemento.municipio}, ${widget.elemento.provincia}\nhttp://maps.google.com/maps?daddr=${widget.elemento.nombre}+${widget.elemento.provincia}");
        break;
      case 'StreetView':
        if(widget.elemento.posicion.latitude != -1)
          Utils().openUrl(
              "google.streetview:cbll=${widget.elemento.posicion.latitude},${widget.elemento.posicion.longitude}");
        else
          Toast.show("No está disponible StreetView en esta ubicación", context);
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.elemento.nombre),
          actions: [
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
        floatingActionButton: _decidirFab(),
        body: _decidirVista());
  }
}
