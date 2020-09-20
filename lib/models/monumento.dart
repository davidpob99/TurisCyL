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

/// Representación de un monumento
class Monumento {
  static const String JSON = "https://datosabiertos.jcyl.es/web/jcyl/risp/es/cultura-ocio/monumentos/1284325843131.json";
  static const String NOMBRE = "Monumentos";
  final String DB_CONSULTA_BASICA = """
  SELECT * FROM ${NOMBRE} ORDER BY numero_registro;
  """;
  final String DB_NOMBRE = NOMBRE;
  final String DB_CREAR = """
  CREATE TABLE ${NOMBRE}(
     numero_registro TEXT PRIMARY KEY,
     nombre TEXT,
     tipo_monumento TEXT,
     id_bic TEXT,
     direccion TEXT,
     clasificacion TEXT,
     tipo_construccion TEXT,
     cp INTEGER,
     descripcion TEXT,
     email TEXT,
     estilo_predominante TEXT,
     fax TEXT,
     horarios_y_tarifas TEXT,
     periodo_historico TEXT,
     provincia TEXT,
     municipio TEXT,
     localidad TEXT,
     telefono TEXT,
     latitud REAL,
     longitud REAL,
     web TEXT     
  )""";

  String _numeroRegistro; //identificador
  String _nombre;
  String _tipoMonumento;
  String _idBic;
  String _direccion; //calle
  String _clasificacion;
  String _tipoConstruccion;
  int _cp;
  String _descripcion;
  String _email;
  String _estiloPredominante;
  String _fax;
  String _horariosYTarifas;
  String _periodoHistorico;
  String _provincia;
  String _municipio;
  String _localidad;
  String _telefono;
  LatLng _posicion;
  String _web;

  Monumento.vacio();

  Monumento.fromJson(Map<dynamic, dynamic> map){
    _numeroRegistro = map['identificador'];
    _nombre = map['nombre'];
    _tipoMonumento = map['tipoMonumento'];
    if (map['identificadorBienInteresCultural'] != null){
      if(map['identificadorBienInteresCultural'].length == 0)
        _idBic = map['identificadorBienInteresCultural'][0];
      else
        _idBic = map['identificadorBienInteresCultural'].join("/");
    } else
      _idBic = null;
    _direccion = map['calle'];
    _clasificacion = map['clasificacion'];
    if(map['tipoConstruccion'] != null)
      _tipoConstruccion = map['tipoConstruccion'][0];
    else
      _tipoConstruccion = null;
    if(map['codigoPostal'] != null)
      _cp = int.parse(map['codigoPostal']);
    else
      _cp = null;
    _descripcion = map['Descripcion'];
    if(map['email'] != null){
      if(map['email'].length == 0)
        _email = map['email'][0];
      else
        _email = map['email'].join("/");
    } else
      _email = null;
    if (map['estiloPredominante'] != null)
      _estiloPredominante = map['estiloPredominante'][0];
    else
      _estiloPredominante = null;
    _fax = map['fax'];
    _horariosYTarifas = map['horariosYTarifas'];
    _periodoHistorico;
    _provincia = map['poblacion']['provincia'];
    _municipio = map['poblacion']['municipio'];
    _localidad = map['poblacion']['localidad'];
    if(map['telefono'] != null) {
      if (map['telefono'].length == 0)
        _telefono = map['telefono'][0];
      else
        _telefono = map['telefono'].join("/");
    } else
      _telefono = null;
    _posicion = new LatLng(double.parse(map['coordenadas']['latitud']), double.parse(map['coordenadas']['longitud'].replaceAll('#', '')));
    if(map['web'] != null) {
      if (map['web'].length == 0)
        _web = map['web'][0];
      else
        _web = map['web'].join("/");
    } else
      _web = null;
  }


  Monumento.fromMap(Map<dynamic, dynamic> map){
    _numeroRegistro = map['numero_registro'];
    _nombre = map['nombre'];
    _tipoMonumento = map['tipoMonumento'];
    _idBic = map['id_bic'];
    _direccion = map['direccion'];
    _clasificacion = map['clasificacion'];
    _tipoConstruccion = map['tipo_construccion'];
    _cp = map['cp'];
    _descripcion = map['descripcion'];
    _email = map['email'];
    _estiloPredominante = map['estilo_predominante'];
    _fax = map['fax'];
    _horariosYTarifas = map['horarios_y_tarifas'];
    _periodoHistorico;
    _provincia = map['provincia'];
    _municipio = map['municipio'];
    _localidad = map['localidad'];
    _telefono = map['telefono'];
    _posicion = new LatLng(map['latitud'],map['longitud']);
    _web = map['web'];
  }

  ListTile vistaInformacion(){
    return ListTile(
      title: Text(nombre),
      subtitle: Text("${clasificacion} · ${municipio}, ${provincia}"),
    );
  }

  @override
  String toString() {
    return 'Monumento{_numeroRegistro: $_numeroRegistro, _nombre: $_nombre, _tipoMonumento: $_tipoMonumento, _idBic: $_idBic, _direccion: $_direccion, _clasificacion: $_clasificacion, _tipoConstruccion: $_tipoConstruccion, _cp: $_cp, _descripcion: $_descripcion, _email: $_email, _estiloPredominante: $_estiloPredominante, _fax: $_fax, _horariosYTarifas: $_horariosYTarifas, _periodoHistorico: $_periodoHistorico, _provincia: $_provincia, _municipio: $_municipio, _localidad: $_localidad, _telefono: $_telefono, _posicion: $_posicion, _web: $_web}';
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'numero_registro': numeroRegistro,
      'nombre': nombre,
      'tipo_monumento': tipoMonumento,
      'id_bic': idBic,
      'direccion': direccion,
      'clasificacion': clasificacion,
      'tipo_construccion': tipoConstruccion,
      'cp': cp,
      'descripcion': descripcion,
      'email': email,
      'estilo_predominante': estiloPredominante,
      'fax': fax,
      'horarios_y_tarifas': horariosYTarifas,
      'periodo_historico': periodoHistorico,
      'provincia': provincia,
      'municipio': municipio,
      'localidad': localidad,
      'telefono': telefono,
      'latitud': posicion.latitude,
      'longitud': posicion.longitude,
      'web': web
    };
    return map;
  }

  Map<String, dynamic> toJson(){
    var map = <String, dynamic>{
      'DB_NOMBRE': DB_NOMBRE,
      'numero_registro': numeroRegistro,
      'nombre': nombre,
      'tipo_monumento': tipoMonumento,
      'id_bic': idBic,
      'direccion': direccion,
      'clasificacion': clasificacion,
      'tipo_construccion': tipoConstruccion,
      'cp': cp,
      'descripcion': descripcion,
      'email': email,
      'estilo_predominante': estiloPredominante,
      'fax': fax,
      'horarios_y_tarifas': horariosYTarifas,
      'periodo_historico': periodoHistorico,
      'provincia': provincia,
      'municipio': municipio,
      'localidad': localidad,
      'telefono': telefono,
      'latitud': posicion.latitude,
      'longitud': posicion.longitude,
      'web': web
    };
    return map;
  }

  String get web => _web;

  set web(String value) {
    _web = value;
  }

  LatLng get posicion => _posicion;

  set posicion(LatLng value) {
    _posicion = value;
  }

  String get telefono => _telefono;

  set telefono(String value) {
    _telefono = value;
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

  String get periodoHistorico => _periodoHistorico;

  set periodoHistorico(String value) {
    _periodoHistorico = value;
  }

  String get horariosYTarifas => _horariosYTarifas;

  set horariosYTarifas(String value) {
    _horariosYTarifas = value;
  }

  String get fax => _fax;

  set fax(String value) {
    _fax = value;
  }

  String get estiloPredominante => _estiloPredominante;

  set estiloPredominante(String value) {
    _estiloPredominante = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get descripcion => _descripcion;

  set descripcion(String value) {
    _descripcion = value;
  }

  int get cp => _cp;

  set cp(int value) {
    _cp = value;
  }

  String get tipoConstruccion => _tipoConstruccion;

  set tipoConstruccion(String value) {
    _tipoConstruccion = value;
  }

  String get clasificacion => _clasificacion;

  set clasificacion(String value) {
    _clasificacion = value;
  }

  String get direccion => _direccion;

  set direccion(String value) {
    _direccion = value;
  }

  String get idBic => _idBic;

  set idBic(String value) {
    _idBic = value;
  }

  String get tipoMonumento => _tipoMonumento;

  set tipoMonumento(String value) {
    _tipoMonumento = value;
  }

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  String get numeroRegistro => _numeroRegistro;

  set numeroRegistro(String value) {
    _numeroRegistro = value;
  }
}