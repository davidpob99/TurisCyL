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

import 'package:latlong/latlong.dart';

/// Representación de un lugar turístico obtenido de Foursquare. Se almacena
/// también el [numero_registro] del elemento al que se refiere y el [tipo] del
/// mismo
class Venue {
  static const String NOMBRE = "Venues";
  final String DB_CONSULTA_BASICA = """
  SELECT * FROM Venues ORDER BY numero_registro;
  """;
  final String DB_NOMBRE = NOMBRE;
  final String DB_CREAR = """
  CREATE TABLE ${NOMBRE}(
     tipo TEXT,
     numero_registro TEXT,
     id TEXT UNIQUE,
     nombre TEXT,
     direccion TEXT,
     cp INTEGER,
     ciudad TEXT,
     latitud REAL,
     longitud REAL,
     url_foto TEXT,
     PRIMARY KEY (tipo, numero_registro)
  )""";
  String _tipo;
  String _numeroRegistro;
  String _id;
  String _nombre;
  String _direccion;
  LatLng _posicion;
  int _cp;
  String _ciudad;
  String _urlFoto;

  Venue.vacio();

  Venue.fromFoursquare(Map<String, dynamic> json) {
    this._posicion = new LatLng(json['location']['lat'], json['location']['lng']);
    this._id = json['id'];
    this._nombre = json['name'];
    this._direccion = json['location']['address'];
    //this._cp = int.parse(json['location']['postalCode']);
    this._ciudad = json['location']['city'];
    this._urlFoto = '';
  }

  Venue.fromMap(Map<dynamic, dynamic> map){
    this._tipo = map['tipo'];
    this._numeroRegistro = map['numero_registro'];
    this._id = map['id'];
    this._nombre = map['nombre'];
    this._ciudad = map['ciudad'];
    this._direccion = map['direccion'];
    this._cp = map['cp'];
    this._posicion = new LatLng(map['latitud'], map['longitud']);
    this.urlFoto = map['url_foto'];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'numero_registro': numeroRegistro,
      'id': id,
      'tipo': tipo,
      'nombre': nombre,
      'direccion': direccion,
      'cp': cp,
      'ciudad': ciudad,
      'latitud': posicion.latitude,
      'longitud': posicion.longitude,
      'url_foto': urlFoto
    };
    return map;
  }


  Venue.fromGeolocation(this._posicion);

  @override
  String toString() {
    return 'Venue{_id: $_id, _nombre: $_nombre, _direccion: $_direccion, _posicion: $_posicion, _cp: $_cp, _ciudad: $_ciudad, _urlFoto: $_urlFoto}';
  }


  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get urlFoto => _urlFoto;

  set urlFoto(String value) {
    _urlFoto = value;
  }

  String get ciudad => _ciudad;

  set ciudad(String value) {
    _ciudad = value;
  }

  int get cp => _cp;

  set cp(int value) {
    _cp = value;
  }


  LatLng get posicion => _posicion;

  set posicion(LatLng value) {
    _posicion = value;
  }

  String get direccion => _direccion;

  set direccion(String value) {
    _direccion = value;
  }

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get numeroRegistro => _numeroRegistro;

  set numeroRegistro(String value) {
    _numeroRegistro = value;
  }
}