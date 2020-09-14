
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

/// Representación de un Bar
/// https://datosabiertos.jcyl.es/web/jcyl/set/es/turismo/bares/1284211832884
class Bar {
  static const String CSV = "https://datosabiertos.jcyl.es/web/jcyl/risp/es/turismo/bares/1284211832884.csv";
  static const String NOMBRE = "Bares";
  final String DB_CONSULTA_BASICA = """
  SELECT * FROM Bares ORDER BY numero_registro;
  """;
  final String DB_NOMBRE = NOMBRE;
  final String DB_CREAR = """
  CREATE TABLE ${NOMBRE}(
     numero_registro TEXT PRIMARY KEY,
     especialidades TEXT,
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
     plazas INTEGER,
     latitud REAL,
     longitud REAL,
     pmr INTEGER     
  )""";

  String _numeroRegistro;
  String _especialidades;
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
  int _plazas;
  LatLng _posicion;
  bool _pmr;

  Bar.vacio();

  /// Crea un objeto Bar a partir de una lista de datos obtenidos a través del
  /// archivo CSV. Si no existe un dato lo marca con -1
  Bar.fromCsv(List<dynamic> datos){
    this._numeroRegistro = datos[0].toString();
    this._especialidades = datos[1].toString();
    this._nombre = datos[2].toString();
    this._direccion = datos[3].toString();
    // Algunos códigos postales no están bien
    try {
      this._cp = datos[4];
    } catch (e){
      this._cp = -1;
    }
    this._provincia = datos[5].toString();
    this._municipio = datos[6].toString();
    this._localidad = datos[7].toString();
    this._nucleo = datos[8].toString();
    this._telefono1 = datos[9].toString();
    this._telefono2 = datos[10].toString();
    this._telefono3 = datos[11].toString();
    this._email = datos[12].toString();
    this._web = datos[13].toString();
    this._qCalidad = datos[14] == "Si" ? true : false;
    if (datos[15] == "")
      this._plazas = -1;
    else
      this._plazas = datos[15];
    if (datos[16] == "" || datos[17] == "")
      this._posicion = new LatLng(-1,-1);
    else {
      this._posicion = new LatLng(double.parse(datos[17].toString().replaceAll(",", ".")), double.parse(datos[16].toString().replaceAll(",", ".")));
    }
    this._pmr = datos[19] == "Si" ? true : false;
  }

  Bar.fromMap(Map<dynamic, dynamic> map){
    this._numeroRegistro = map['numero_registro'];
    this._especialidades = map['especialidades'];
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
    this._plazas = map['plazas'];
    this._posicion = new LatLng(map['latitud'], map['longitud']);
    this.pmr = map['pmr'] == 1 ? true : false;
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'numero_registro': numeroRegistro,
      'especialidades': especialidades,
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
      'especialidades': especialidades,
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
          "${direccion} · ${municipio}, ${provincia}"),
    );
  }

  @override
  String toString() {
    return 'Bar{_numeroRegistro: $_numeroRegistro, _nombre: $_nombre, _direccion: $_direccion, _municipio: $_municipio, _posicion: $_posicion}';
  }

  /// Devuelve el código SQL para insertar el objeto en SQLite
  /*String insertarEnDb(){
    return """INSERT INTO Bares(
     numero_registro,
     especialidades,
     nombre,
     direccion,
     cp,
     provincia,
     municipio,
     localidad,
     nucleo,
     telefono1,
     telefono2,
     telefono3,
     email,
     web,
     q_calidad,
     plazas,
     latitud,
     longitud,
     pmr
  ) VALUES(
    "${numeroRegistro}",
    "${especialidades}",
    "${nombre}",
    "${direccion}",
    ${cp},
    "${provincia}",
    "${municipio}",
    "${localidad}",
    "${nucleo}",
    "${telefono1}",
    "${telefono2}",
    "${telefono3}",
    "${email}",
    "${web}",
    ${qCalidad ? 1 : 0},
    ${plazas},
    ${posicion.latitude},
    ${posicion.longitude},
    ${pmr ? 1 : 0}
  );""";
  }*/

  /// Número de registro del establecimiento asignado en el registro turístico
  String get numeroRegistro => _numeroRegistro;

  set numeroRegistro(String value) {
    _numeroRegistro = value;
  }

  /// Especilidades del establecimiento, se envía el código y la descripción de la especialidad. Por cada grupo de código y descripción termina en "|". Cada valor termina en "#". Ejemplo "99#especialidad#|"
  String get especialidades => _especialidades;

  set especialidades(String value) {
    _especialidades = value;
  }

  /// Nombre del establecimiento
  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  /// Dirección postal del establecimiento (via y número)
  String get direccion => _direccion;

  set direccion(String value) {
    _direccion = value;
  }

  /// Código postal
  int get cp => _cp;

  set cp(int value) {
    _cp = value;
  }

  /// Nombre, según el INE, de la provincia donde esta ubicado el establecimiento
  String get provincia => _provincia;

  set provincia(String value) {
    _provincia = value;
  }

  /// Nombre, según el INE, del municipio donde esta ubicado el establecimiento
  String get municipio => _municipio;

  set municipio(String value) {
    _municipio = value;
  }

  /// Nombre, según el INE, de la localidad donde esta ubicado el establecimiento
  String get localidad => _localidad;

  set localidad(String value) {
    _localidad = value;
  }

  /// Nombre, según el INE, del nucleo donde esta ubicado el establecimiento
  String get nucleo => _nucleo;

  set nucleo(String value) {
    _nucleo = value;
  }

  /// Teléfono de contacto
  String get telefono1 => _telefono1;

  set telefono1(String value) {
    _telefono1 = value;
  }

  /// Teléfono de contacto
  String get telefono2 => _telefono2;

  set telefono2(String value) {
    _telefono2 = value;
  }

  /// Teléfono de contacto
  String get telefono3 => _telefono3;

  set telefono3(String value) {
    _telefono3 = value;
  }

  /// Correo electrónico  de contacto del establecimiento
  String get email => _email;

  set email(String value) {
    _email = value;
  }

  /// Página web del establecimiento
  String get web => _web;

  set web(String value) {
    _web = value;
  }

  /// Si tiene la marca de Q de Calidad
  bool get qCalidad => _qCalidad;

  set qCalidad(bool value) {
    _qCalidad = value;
  }

  /// Número de plazas totales del establecimiento
  int get plazas => _plazas;

  set plazas(int value) {
    _plazas = value;
  }

  /// Coordenadas GPS
  LatLng get posicion => _posicion;

  set posicion(LatLng value) {
    _posicion = value;
  }

  /// Si tiene como servicio accesibilidad o servicios de minusválidos
  bool get pmr => _pmr;

  set pmr(bool value) {
    _pmr = value;
  }
}