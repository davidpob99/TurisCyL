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

class OficinaTurismo {
  static const String CSV =
      "https://datosabiertos.jcyl.es/web/jcyl/risp/es/turismo/oficinas-info-turismo/1284211843051.csv";
  static const String NOMBRE = "OficinasTurismo";
  final String DB_CONSULTA_BASICA = """
  SELECT * FROM ${NOMBRE} ORDER BY provincia;
  """;
  final String DB_NOMBRE = NOMBRE;
  final String DB_CREAR = """
  CREATE TABLE ${NOMBRE}(
     nombre TEXT,
     direccion TEXT,
     cp INTEGER,
     provincia TEXT,
     municipio TEXT,
     localidad TEXT,
     telefono1 TEXT,
     telefono2 TEXT,
     fax TEXT,
     email TEXT,
     web TEXT,
     ambito TEXT,
     horario TEXT  
  )""";

  String _nombre;
  String _direccion;
  int _cp;
  String _provincia;
  String _municipio;
  String _localidad;
  String _telefono1;
  String _telefono2;
  String _fax;
  String _email;
  String _web;
  String _ambito;
  String _horario;

  OficinaTurismo.vacio();

  /// Crea un objeto OficinaTurismo a partir de una lista de datos obtenidos a través del
  /// archivo CSV. Si no existe un dato lo marca con -1
  OficinaTurismo.fromCsv(List<dynamic> datos) {
    this._nombre = datos[0].toString();
    this._direccion = datos[1].toString();
    // Algunos códigos postales no están bien
    try {
      this._cp = datos[5];
    } catch (e) {
      this._cp = -1;
    }
    this._provincia = datos[2].toString();
    this._municipio = datos[3].toString();
    this._localidad = datos[4].toString();
    this._telefono1 = datos[6].toString();
    this._telefono2 = datos[7].toString();
    this._fax = datos[8].toString();
    this._email = datos[9].toString();
    this._web = datos[10].toString();
    this._ambito = datos[11].toString();
    this._horario = datos[12].toString();
  }

  OficinaTurismo.fromMap(Map<dynamic, dynamic> map) {
    this._nombre = map['nombre'];
    this._direccion = map['direccion'];
    this._cp = map['cp'];
    this._provincia = map['provincia'];
    this._municipio = map['municipio'];
    this._localidad = map['localidad'];
    this._telefono1 = map['telefono1'];
    this._telefono2 = map['telefono2'];
    this._fax = map['fax'];
    this._email = map['email'];
    this._web = map['web'];
    this._ambito = map['ambito'];
    this._horario = map['horario'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nombre': nombre,
      'direccion': direccion,
      'cp': cp,
      'provincia': provincia,
      'municipio': municipio,
      'localidad': localidad,
      'telefono1': telefono1,
      'telefono2': telefono2,
      'fax': fax,
      'email': email,
      'web': web,
      'ambito': ambito,
      'horario': horario
    };
    return map;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'DB_NOMBRE': DB_NOMBRE,
      'nombre': nombre,
      'direccion': direccion,
      'cp': cp,
      'provincia': provincia,
      'municipio': municipio,
      'localidad': localidad,
      'telefono1': telefono1,
      'telefono2': telefono2,
      'fax': fax,
      'email': email,
      'web': web,
      'ambito': ambito,
      'horario': horario
    };
    return map;
  }

  ListTile vistaInformacion(){
    return ListTile(
      title: Text(nombre),
      subtitle: Text(
          "${direccion} · ${municipio}, ${provincia}"),
    );
  }

  String get horario => _horario;

  set horario(String value) {
    _horario = value;
  }

  String get ambito => _ambito;

  set ambito(String value) {
    _ambito = value;
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

  String get telefono2 => _telefono2;

  set telefono2(String value) {
    _telefono2 = value;
  }

  String get telefono1 => _telefono1;

  set telefono1(String value) {
    _telefono1 = value;
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
}
