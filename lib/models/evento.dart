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
import 'package:latlong/latlong.dart';

class Evento {
  static const String CSV =
      "https://datosabiertos.jcyl.es/web/jcyl/risp/es/cultura-ocio/agenda_cultural/1284806871500.csv";
  static const String NOMBRE = "Eventos";
  final String DB_CONSULTA_BASICA = """
  SELECT * FROM ${NOMBRE};
  """;
  final String DB_NOMBRE = NOMBRE;
  final String DB_CREAR = """
  CREATE TABLE ${NOMBRE}(
     nombre TEXT,
     descripcion TEXT,
     tematica TEXT,
     categoria TEXT,
     fecha_inicio TEXT,
     hora_inicio TEXT,
     fecha_fin TEXT,
     hora_fin TEXT,
     precio TEXT,
     colectivo_destinatario TEXT,
     destinatarios TEXT,
     url_miniatura TEXT,
     url_imagen TEXT,
     lugar TEXT,
     latitud REAL,
     longitud REAL,
     localidad TEXT,
     provincia TEXT,
     calle TEXT,
     cp INTEGER,
     evento_biblioteca INTEGER,
     url_enlace TEXT     
  )""";

  String _nombre;
  String _descripcion;
  String _tematica;
  String _categoria;
  DateTime _fechaInicio;
  String _horaInicio;
  DateTime _fechaFin;
  String _horaFin;
  String _precio;
  String _colectivoDestinatario;
  String _destinatarios;
  String _urlMiniatura;
  String _urlImagen;
  String _lugar;
  LatLng _posicion;
  String _localidad;
  String _provincia;
  String _calle;
  int _cp;
  bool _eventoBiblioteca;
  String _urlEnlace;

  Evento.vacio();

  /// Crea un objeto Evento a partir de una lista de datos obtenidos a través del
  /// archivo CSV. Si no existe un dato lo marca con -1
  Evento.fromCsv(List<dynamic> datos) {
    _nombre = datos[0].toString();
    _descripcion = datos[1].toString();
    _tematica = datos[2].toString();
    _categoria = datos[3].toString();
    _fechaInicio = DateTime(
        int.parse(datos[4].toString().split('-')[0]),
        int.parse(datos[4].toString().split('-')[1]),
        int.parse(datos[4].toString().split('-')[2]));
    _horaInicio = datos[6].toString();
    if(datos[5].toString() == ''){
       fechaFin = null;
    } else {
      _fechaFin = DateTime(
          int.parse(datos[5].toString().split('-')[0]),
          int.parse(datos[5].toString().split('-')[1]),
          int.parse(datos[5].toString().split('-')[2]));
    }
    _horaFin = datos[7].toString();
    _precio = datos[8].toString();
    _colectivoDestinatario = datos[9].toString();
    _destinatarios = datos[10].toString();
    _urlMiniatura = datos[11].toString();
    _urlImagen = datos[12].toString();
    _lugar = datos[13].toString();
    try {
      _posicion = new LatLng(double.parse(datos[26].toString().split(",")[0]),
          double.parse(datos[26].toString().split(",")[1]));
    } catch (e) {
      this._posicion = new LatLng(-1, -1);
    }
    _localidad = datos[17].toString();
    _provincia = datos[19].toString();
    _calle = datos[20].toString();
    try {
      this._cp = int.parse(datos[21].toString());
    } catch (e) {
      this._cp = -1;
    }
    _eventoBiblioteca = datos[23] == 'SI' ? true : false;
    _urlEnlace = datos[25].toString();
  }

  Evento.fromMap(Map<dynamic, dynamic> map) {
    _nombre = map['nombre'];
    _descripcion = map['descripcion'];
    _tematica = map['tematica'];
    _categoria = map['categoria'];
    _fechaInicio = DateTime.parse(map['fecha_inicio']);
    _horaInicio = map['hora_inicio'];
    try {
      _fechaFin = DateTime.parse(map['fecha_fin']);

    } catch (e) {
      _fechaFin = null;
    }
    _horaFin = map['hora_fin'];
    _precio = map['precio'];
    _colectivoDestinatario = map['colectivo_destinatario'];
    _destinatarios = map['destinatarios'];
    _urlMiniatura = map['url_miniatura'];
    _urlImagen = map['url_imagen'];
    _lugar = map['lugar'];
    _posicion = new LatLng(map['latitud'], map['longitud']);
    _localidad = map['localidad'];
    _provincia = map['provincia'];
    _calle = map['calle'];
    _cp = map['cp'];
    _eventoBiblioteca = map['evento_biblioteca'] == 1 ? true : false;
    _urlEnlace = map['url_enlace'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nombre': _nombre,
      'descripcion': _descripcion,
      'tematica': _tematica,
      'categoria': _categoria,
      'fecha_inicio': _fechaInicio.toIso8601String(),
      'hora_inicio': _horaInicio,
      'fecha_fin': _fechaFin != null ? _fechaFin.toIso8601String() : null,
      'hora_fin': _horaFin,
      'precio': _precio,
      'colectivo_destinatario': _colectivoDestinatario,
      'destinatarios': _destinatarios,
      'url_miniatura': _urlMiniatura,
      'url_imagen': _urlImagen,
      'lugar': _lugar,
      'latitud': _posicion.latitude,
      'longitud': _posicion.longitude,
      'localidad': _localidad,
      'provincia': _provincia,
      'calle': _calle,
      'cp': _cp,
      'evento_biblioteca': _eventoBiblioteca ? 1 : 0,
      'url_enlace': _urlEnlace
    };
    return map;
  }

  ListTile vistaInformacion(){
    return ListTile(
      title: Text(nombre),
      subtitle: Text(
          "${categoria} · ${localidad}, ${provincia}"),
    );
  }

  @override
  String toString() {
    return 'Evento{_titulo: $_nombre, _fechaInicio: $_fechaInicio, _fechaFin: $_fechaFin, _urlImagen: $_urlImagen, _lugar: $_lugar}';
  }

  String get urlEnlace => _urlEnlace;

  set urlEnlace(String value) {
    _urlEnlace = value;
  }

  bool get eventoBiblioteca => _eventoBiblioteca;

  set eventoBiblioteca(bool value) {
    _eventoBiblioteca = value;
  }

  int get cp => _cp;

  set cp(int value) {
    _cp = value;
  }

  String get calle => _calle;

  set calle(String value) {
    _calle = value;
  }

  String get provincia => _provincia;

  set provincia(String value) {
    _provincia = value;
  }

  String get localidad => _localidad;

  set localidad(String value) {
    _localidad = value;
  }

  LatLng get posicion => _posicion;

  set posicion(LatLng value) {
    _posicion = value;
  }

  String get lugar => _lugar;

  set lugar(String value) {
    _lugar = value;
  }

  String get urlImagen => _urlImagen;

  set urlImagen(String value) {
    _urlImagen = value;
  }

  String get urlMiniatura => _urlMiniatura;

  set urlMiniatura(String value) {
    _urlMiniatura = value;
  }

  String get destinatarios => _destinatarios;

  set destinatarios(String value) {
    _destinatarios = value;
  }

  String get colectivoDestinatario => _colectivoDestinatario;

  set colectivoDestinatario(String value) {
    _colectivoDestinatario = value;
  }

  String get precio => _precio;

  set precio(String value) {
    _precio = value;
  }

  String get horaFin => _horaFin;

  set horaFin(String value) {
    _horaFin = value;
  }

  DateTime get fechaFin => _fechaFin;

  set fechaFin(DateTime value) {
    _fechaFin = value;
  }

  String get horaInicio => _horaInicio;

  set horaInicio(String value) {
    _horaInicio = value;
  }

  DateTime get fechaInicio => _fechaInicio;

  set fechaInicio(DateTime value) {
    _fechaInicio = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  String get tematica => _tematica;

  set tematica(String value) {
    _tematica = value;
  }

  String get descripcion => _descripcion;

  set descripcion(String value) {
    _descripcion = value;
  }

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }
}
