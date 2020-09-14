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

class TurismoRural {
  static const String CSV = "https://datosabiertos.jcyl.es/web/jcyl/risp/es/turismo/turismo_rural/1284211842462.csv";
  static const String NOMBRE = "TurismoRural";
  final String DB_CONSULTA_BASICA = """
  SELECT * FROM ${NOMBRE} ORDER BY numero_registro;
  """;
  final String DB_NOMBRE = NOMBRE;
  final String DB_CREAR = """
  CREATE TABLE ${NOMBRE}(
     numero_registro TEXT PRIMARY KEY,
     tipo TEXT,
     categoria TEXT,
     nombre TEXT,
     direccion TEXT,
     cp INTEGER,
     provincia TEXT,
     municipio TEXT,
     localidad TEXT,
     nucleo TEXT,
     telefono1 TEXT,
     telefono2 TEXT,
     telefono3 TEXT,
     email TEXT,
     web TEXT,
     q_calidad INTEGER,
     posada_real INTEGER,
     plazas INTEGER,
     latitud REAL,
     longitud REAL,
     pmr INTEGER     
  )""";

  String _numeroRegistro;
  String _tipo;
  String _categoria;
  String _nombre;
  String _direccion;
  int _cp;
  String _provincia;
  String _municipio;
  String _localidad;
  String _nucleo;
  String _telefono1;
  String _telefono2;
  String _telefono3;
  String _email;
  String _web;
  bool _qCalidad;
  bool _posadaReal;
  int _plazas;
  LatLng _posicion;
  bool _pmr;

  TurismoRural.vacio();

  /// Crea un objeto TurismoRural a partir de una lista de datos obtenidos a través del
  /// archivo CSV. Si no existe un dato lo marca con -1
  TurismoRural.fromCsv(List<dynamic> datos){
    this._numeroRegistro = datos[0].toString();
    this._tipo = datos[1].toString();
    this._categoria = datos[2].toString();
    this._nombre = datos[3].toString();
    this._direccion = datos[4].toString();
    // Algunos códigos postales no están bien
    try {
      this._cp = datos[5];
    } catch (e){
      this._cp = -1;
    }
    this._provincia = datos[6].toString();
    this._municipio = datos[7].toString();
    this._localidad = datos[8].toString();
    this._nucleo = datos[9].toString();
    this._telefono1 = datos[10].toString();
    this._telefono2 = datos[11].toString();
    this._telefono3 = datos[12].toString();
    this._email = datos[13].toString();
    this._web = datos[14].toString();
    this._qCalidad = datos[15] == "Si" ? true : false;
    this._posadaReal = datos[17] == "Si" ? true : false;
    if (datos[18] == "")
      this._plazas = -1;
    else
      this._plazas = datos[18];
    if (datos[19] == "" || datos[20] == "")
      this._posicion = new LatLng(-1,-1);
    else {
      this._posicion = new LatLng(double.parse(datos[20].toString().replaceAll(",", ".")), double.parse(datos[19].toString().replaceAll(",", ".")));
    }
    this._pmr = datos[21] == "Si" ? true : false;
  }

  TurismoRural.fromMap(Map<dynamic, dynamic> map){
    this._numeroRegistro = map['numero_registro'];
    this._tipo = map['tipo'];
    this._categoria = map['categoria'];
    this._nombre = map['nombre'];
    this._direccion = map['direccion'];
    this._cp = map['cp'];
    this._provincia = map['provincia'];
    this._municipio = map['municipio'];
    this._localidad = map['localidad'];
    this._nucleo = map['nucleo'];
    this._telefono1 = map['telefono1'];
    this._telefono2 = map['telefono2'];
    this._telefono3 = map['telefono3'];
    this._email = map['email'];
    this._web = map['web'];
    this._qCalidad = map['q_calidad'] == 1 ? true : false;
    this._posadaReal = map['posada_real'] == 1 ? true : false;
    this._plazas = map['plazas'];
    this._posicion = new LatLng(map['latitud'], map['longitud']);
    this._pmr = map['pmr'] == 1 ? true : false;
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'numero_registro': numeroRegistro,
      'tipo': tipo,
      'categoria': categoria,
      'nombre': nombre,
      'direccion': direccion,
      'cp': cp,
      'provincia': provincia,
      'municipio': municipio,
      'localidad': localidad,
      'nucleo': nucleo,
      'telefono1': telefono1,
      'telefono2': telefono2,
      'telefono3': telefono3,
      'email': email,
      'web': web,
      'q_calidad': qCalidad ? 1 : 0,
      'posada_real': posadaReal ? 1 : 0,
      'plazas': plazas,
      'latitud': posicion.latitude,
      'longitud': posicion.longitude,
      'pmr': pmr ? 1 : 0
    };
    return map;
  }

  Map<String, dynamic> toJson(){
    var map = <String, dynamic>{
      'DB_NOMBRE': DB_NOMBRE,
      'numero_registro': numeroRegistro,
      'tipo': tipo,
      'categoria': categoria,
      'nombre': nombre,
      'direccion': direccion,
      'cp': cp,
      'provincia': provincia,
      'municipio': municipio,
      'localidad': localidad,
      'nucleo': nucleo,
      'telefono1': telefono1,
      'telefono2': telefono2,
      'telefono3': telefono3,
      'email': email,
      'web': web,
      'q_calidad': qCalidad ? 1 : 0,
      'posada_real': posadaReal ? 1 : 0,
      'plazas': plazas,
      'latitud': posicion.latitude,
      'longitud': posicion.longitude,
      'pmr': pmr ? 1 : 0
    };
    return map;
  }

  ListTile vistaInformacion(){
    return ListTile(
      title: Text(nombre),
      subtitle: Text(
          "${tipo}-${categoria} · ${municipio}, ${provincia}"),
    );
  }

  bool get posadaReal => _posadaReal;

  set posadaReal(bool value) {
    _posadaReal = value;
  }

  bool get pmr => _pmr;

  set pmr(bool value) {
    _pmr = value;
  }

  LatLng get posicion => _posicion;

  set posicion(LatLng value) {
    _posicion = value;
  }

  int get plazas => _plazas;

  set plazas(int value) {
    _plazas = value;
  }

  bool get qCalidad => _qCalidad;

  set qCalidad(bool value) {
    _qCalidad = value;
  }

  String get web => _web;

  set web(String value) {
    _web = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get telefono3 => _telefono3;

  set telefono3(String value) {
    _telefono3 = value;
  }

  String get telefono2 => _telefono2;

  set telefono2(String value) {
    _telefono2 = value;
  }

  String get telefono1 => _telefono1;

  set telefono1(String value) {
    _telefono1 = value;
  }

  String get nucleo => _nucleo;

  set nucleo(String value) {
    _nucleo = value;
  }

  String get localidad => _localidad;

  set localidad(String value) {
    _localidad = value;
  }

  String get municipio => _municipio;

  set municipio(String value) {
    _municipio = value;
  }

  String get provincia => _provincia;

  set provincia(String value) {
    _provincia = value;
  }

  int get cp => _cp;

  set cp(int value) {
    _cp = value;
  }

  String get direccion => _direccion;

  set direccion(String value) {
    _direccion = value;
  }

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get numeroRegistro => _numeroRegistro;

  set numeroRegistro(String value) {
    _numeroRegistro = value;
  }
}