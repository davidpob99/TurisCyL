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
import 'package:latlong/latlong.dart';

/// Representación de un museo
class Museo {
  static const String CSV =
      "https://analisis.datosabiertos.jcyl.es/explore/dataset/directorio-de-museos-de-castilla-y-leon/download/?format=csv&timezone=UTC&lang=es&use_labels_for_header=true&csv_separator=%3B";
  static const String NOMBRE = "Museos";
  final String DB_CONSULTA_BASICA = """
  SELECT * FROM ${NOMBRE};
  """;
  final String DB_NOMBRE = NOMBRE;
  final String DB_CREAR = """
  CREATE TABLE ${NOMBRE}(
     nombre TEXT,
     descripcion TEXT,
     datos_personales TEXT,
     direccion TEXT,
     calle TEXT,
     cp INTEGER,
     localidad TEXT,
     telefono TEXT,
     fax TEXT,
     email TEXT,
     web TEXT,
     latitud REAL,
     longitud REAL,
     informacion TEXT,
     provincia TEXT,
     enlace_contenido TEXT     
  )""";

  String _nombre;
  String _descripcion;
  String _datosPersonales;
  String _direccion;
  String _calle;
  int _cp;
  String _localidad;
  String _telefono;
  String _fax;
  String _email;
  String _web;
  LatLng _posicion;
  String _informacion;
  String _provincia;
  String _enlaceContenido;

  Museo.vacio();

  /// Crea un objeto Museo a partir de una lista de datos obtenidos a través del
  /// archivo CSV. Si no existe un dato lo marca con -1
  Museo.fromCsv(List<dynamic> datos) {
    _nombre = datos[0].toString();
    _descripcion = datos[1].toString();
    _datosPersonales = datos[2].toString();
    _direccion = datos[3].toString();
    _calle = datos[4].toString();
    try {
      this._cp = int.parse(datos[5].toString());
    } catch (e){
      this._cp = -1;
    }
    _localidad = datos[6].toString();
    _telefono = datos[9].toString();
    _fax = datos[10].toString();
    _email = datos[12].toString();
    _web = datos[13].toString();
    try {
      _posicion = new LatLng(double.parse(datos[14].toString().split(",")[0]),
          double.parse(datos[14].toString().split(",")[1]));
    }catch (e){
      this._posicion = new LatLng(-1,-1);
    }
    _informacion = datos[17].toString();
    _provincia = datos[18].toString();
    _enlaceContenido = datos[22].toString();
  }

  Museo.fromMap(Map<dynamic, dynamic> map) {
    _nombre = map['nombre'];
    _descripcion = map['descripcion'];
    _datosPersonales = map['datos_personales'];
    _direccion = map['direccion'];
    _calle = map['calle'];
    _cp = map['cp'];
    _localidad = map['localidad'];
    _telefono = map['telefono'];
    _fax = map['fax'];
    _email = map['email'];
    _web = map['web'];
    _posicion = new LatLng(map['latitud'], map['longitud']);
    _informacion = map['informacion'];
    _provincia = map['provincia'];
    _enlaceContenido = map['enlace_contenido'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nombre': _nombre,
      'descripcion': _descripcion,
      'datos_personales': _datosPersonales,
      'direccion': _direccion,
      'calle': _calle,
      'cp': _cp,
      'localidad': _localidad,
      'telefono': _telefono,
      'fax': _fax,
      'email': _email,
      'web': _web,
      'latitud': _posicion.latitude,
      'longitud': _posicion.longitude,
      'informacion': _informacion,
      'provincia': _provincia,
      'enlace_contenido': _enlaceContenido
    };
    return map;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'DB_NOMBRE': DB_NOMBRE,
      'nombre': _nombre,
      'descripcion': _descripcion,
      'datos_personales': _datosPersonales,
      'direccion': _direccion,
      'calle': _calle,
      'cp': _cp,
      'localidad': _localidad,
      'telefono': _telefono,
      'fax': _fax,
      'email': _email,
      'web': _web,
      'latitud': _posicion.latitude,
      'longitud': _posicion.longitude,
      'informacion': _informacion,
      'provincia': _provincia,
      'enlace_contenido': _enlaceContenido
    };
    return map;
  }

  ListTile vistaInformacion(){
    return ListTile(
      title: Text(nombre),
      subtitle: Text(
          "${calle} · ${localidad}, ${provincia}"),
    );
  }

  @override
  String toString() {
    return 'Museo{_nombre: $_nombre, _descripcion: $_descripcion, _datosPersonales: $_datosPersonales, _direccion: $_direccion, _calle: $_calle, _cp: $_cp, _localidad: $_localidad, _telefono: $_telefono, _fax: $_fax, _email: $_email, _web: $_web, _posicion: $_posicion, _informacion: $_informacion, _provincia: $_provincia, _enlaceContenido: $_enlaceContenido}';
  }

  String get enlaceContenido => _enlaceContenido;

  set enlaceContenido(String value) {
    _enlaceContenido = value;
  }

  String get provincia => _provincia;

  set provincia(String value) {
    _provincia = value;
  }

  String get informacion => _informacion;

  set informacion(String value) {
    _informacion = value;
  }

  LatLng get posicion => _posicion;

  set posicion(LatLng value) {
    _posicion = value;
  }

  String get web => _web;

  set web(String value) {
    _web = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get fax => _fax;

  set fax(String value) {
    _fax = value;
  }

  String get telefono => _telefono;

  set telefono(String value) {
    _telefono = value;
  }

  String get localidad => _localidad;

  set localidad(String value) {
    _localidad = value;
  }

  int get cp => _cp;

  set cp(int value) {
    _cp = value;
  }

  String get calle => _calle;

  set calle(String value) {
    _calle = value;
  }

  String get direccion => _direccion;

  set direccion(String value) {
    _direccion = value;
  }

  String get datosPersonales => _datosPersonales;

  set datosPersonales(String value) {
    _datosPersonales = value;
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
