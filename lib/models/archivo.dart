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

class Archivo {
  static const String CSV =
      "https://analisis.datosabiertos.jcyl.es/explore/dataset/directorio-de-archivos-de-castilla-y-leon/download/?format=csv&timezone=Europe/Madrid&lang=es&use_labels_for_header=true&csv_separator=%3B";
  static const String NOMBRE = "Archivos";
  final String DB_CONSULTA_BASICA = """
  SELECT * FROM Archivos;
  """;
  final String DB_NOMBRE = NOMBRE;
  final String DB_CREAR = """
  CREATE TABLE ${NOMBRE}(
     nombre TEXT,
     tipo TEXT,
     localidad TEXT,
     horario TEXT,
     requisitos TEXT,
     accesibilidad TEXT,
     servicios TEXT,
     informacion TEXT,
     codigo TEXT,
     enlace_contenido TEXT 
  )""";

  String _nombre;
  String _tipo;
  String _localidad;
  String _horario;
  String _requisitos;
  String _accesibilidad;
  String _servicios;
  String _informacion;
  String _codigo;
  String _enlaceContenido;

  Archivo.vacio();

  Archivo.fromCsv(List<dynamic> datos) {
    _nombre = datos[1];
    _tipo = datos[14].toString();
    _localidad = datos[4];
    _horario = datos[8];
    _requisitos = datos[9];
    _accesibilidad = datos[10];
    _servicios = datos[11];
    _informacion = datos[12];
    _codigo = datos[13];
    _enlaceContenido = datos[18];
  }

  Archivo.fromMap(Map<dynamic, dynamic> map) {
    _nombre = map['nombre'];
    _tipo = map['tipo'];
    _localidad = map['localidad'];
    _horario = map['horario'];
    _requisitos = map['requisitos'];
    _accesibilidad = map['accesibilidad'];
    _servicios = map['servicios'];
    _informacion = map['informacion'];
    _codigo = map['codigo'];
    _enlaceContenido = map['enlace_contenido'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nombre': _nombre,
      'tipo': _tipo,
      'localidad': _localidad,
      'horario': _horario,
      'requisitos': _requisitos,
      'accesibilidad': _accesibilidad,
      'servicios': _servicios,
      'informacion': _informacion,
      'codigo': _codigo,
      'enlace_contenido': _enlaceContenido
    };
    return map;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'DB_NOMBRE': NOMBRE,
      'nombre': _nombre,
      'tipo': _tipo,
      'localidad': _localidad,
      'horario': _horario,
      'requisitos': _requisitos,
      'accesibilidad': _accesibilidad,
      'servicios': _servicios,
      'informacion': _informacion,
      'codigo': _codigo,
      'enlace_contenido': _enlaceContenido
    };
    return map;
  }

  ListTile vistaInformacion() {
    return ListTile(
      title: Text(nombre),
      subtitle: Text("${tipo} · ${localidad}"),
    );
  }

  String get enlaceContenido => _enlaceContenido;

  set enlaceContenido(String value) {
    _enlaceContenido = value;
  }

  String get codigo => _codigo;

  set codigo(String value) {
    _codigo = value;
  }

  String get informacion => _informacion;

  set informacion(String value) {
    _informacion = value;
  }

  String get servicios => _servicios;

  set servicios(String value) {
    _servicios = value;
  }

  String get accesibilidad => _accesibilidad;

  set accesibilidad(String value) {
    _accesibilidad = value;
  }

  String get requisitos => _requisitos;

  set requisitos(String value) {
    _requisitos = value;
  }

  String get horario => _horario;

  set horario(String value) {
    _horario = value;
  }

  String get localidad => _localidad;

  set localidad(String value) {
    _localidad = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }
}
