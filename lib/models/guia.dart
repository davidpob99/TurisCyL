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

class Guia {
  static const String CSV =
      "https://datosabiertos.jcyl.es/web/jcyl/risp/es/turismo/guias-turismo/1284808423791.csv";
  static const String NOMBRE = "Guias";
  final String DB_CONSULTA_BASICA = """
  SELECT * FROM ${NOMBRE} ORDER BY numero_guia;
  """;
  final String DB_NOMBRE = NOMBRE;
  final String DB_CREAR = """
  CREATE TABLE ${NOMBRE}(
     numero_guia TEXT PRIMARY KEY,
     nombre TEXT,
     provincia TEXT,
     telefono1 TEXT,
     telefono2 TEXT,
     email TEXT,
     web TEXT,
     idiomas TEXT,
     especialidades TEXT  
  )""";

  String _numeroGuia;
  String _nombre;
  String _telefono1;
  String _telefono2;
  String _email;
  String _web;
  String _provincia;
  String _idiomas;
  String _especialidades;

  Guia.vacio();

  /// Crea un objeto Guia a partir de una lista de datos obtenidos a través del
  /// archivo CSV. Si no existe un dato lo marca con -1
  Guia.fromCsv(List<dynamic> datos) {
    this._numeroGuia = datos[0].toString();
    this._nombre = datos[1].toString();
    this._provincia = datos[6].toString();
    this._telefono1 = datos[2].toString();
    this._telefono2 = datos[3].toString();
    this._email = datos[4].toString();
    this._web = datos[5].toString();
    this._idiomas = datos[7].toString();
    this._especialidades = datos[8].toString();
  }

  Guia.fromMap(Map<dynamic, dynamic> map) {
    this._numeroGuia = map['numero_guia'];
    this._nombre = map['nombre'];
    this._provincia = map['provincia'];
    this._telefono1 = map['telefono1'];
    this._telefono2 = map['telefono2'];
    this._email = map['email'];
    this._web = map['web'];
    this._idiomas = map['idiomas'];
    this._especialidades = map['especialidades'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'numero_guia': numeroGuia,
      'nombre': nombre,
      'provincia': provincia,
      'telefono1': telefono1,
      'telefono2': telefono2,
      'email': email,
      'web': web,
      'idiomas': idiomas,
      'especialidades': especialidades
    };
    return map;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'DB_NOMBRE': DB_NOMBRE,
      'numero_guia': numeroGuia,
      'nombre': nombre,
      'provincia': provincia,
      'telefono1': telefono1,
      'telefono2': telefono2,
      'email': email,
      'web': web,
      'idiomas': idiomas,
      'especialidades': especialidades
    };
    return map;
  }

  ListTile vistaInformacion(){
    return ListTile(
      title: Text(nombre),
      subtitle: Text(
          "${provincia} ${idiomas}"),
    );
  }

  String get especialidades => _especialidades;

  set especialidades(String value) {
    _especialidades = value;
  }

  String get idiomas => _idiomas.replaceAll("#", "").replaceAll("1","").replaceAll("2","").replaceAll("3","").replaceAll("4","");

  set idiomas(String value) {
    _idiomas = value;
  }

  String get provincia => _provincia;

  set provincia(String value) {
    _provincia = value;
  }

  String get web => _web;

  set web(String value) {
    _web = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get telefono2 => _telefono2;

  set telefono2(String value) {
    _telefono2 = value;
  }

  String get telefono1 => _telefono1;

  set telefono1(String value) {
    _telefono1 = value;
  }

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  String get numeroGuia => _numeroGuia;

  set numeroGuia(String value) {
    _numeroGuia = value;
  }
}
