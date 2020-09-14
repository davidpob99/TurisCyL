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

import 'dart:convert';

import 'package:turiscyl/models/evento.dart';
import 'package:turiscyl/models/restaurante.dart';
import 'package:turiscyl/models/salon_banquetes.dart';
import 'package:turiscyl/models/turismo_activo.dart';
import 'package:turiscyl/models/turismo_rural.dart';
import 'package:turiscyl/models/vivienda.dart';

import 'actividad_turistica.dart';
import 'albergue.dart';
import 'alojamiento_hotelero.dart';
import 'apartamento.dart';
import 'bar.dart';
import 'cafeteria.dart';
import 'camping.dart';
import 'guia.dart';
import 'monumento.dart';
import 'museo.dart';
import 'oficina_turismo.dart';

/// Representación de una lista de objetos de turismo. Estos elementos pueden
/// ser de cualquiera de las clases definidas a partir de los datos de la JCyL
/// excepto de [Evento]
class Lista {
  String _id;
  bool _publicada;
  DateTime _timestamp;
  String _nombre;
  String _descripcion;
  String _autor;
  int _dias;
  Set _provincias;
  List _elementos;
  
  Lista(){
    this._provincias = new Set<String>();
    this._elementos = new List();
    this._publicada = false;
  }

  Lista.fromMap(Map<dynamic, dynamic> map) {
    this._id = map['id'];
    this._nombre = map['nombre'];
    this._publicada = map['publicada'];
    this._timestamp = DateTime.parse(map['timestamp']);
    this._descripcion = map['descripcion'];
    this._autor = map['autor'];
    this._dias = map['dias'];
    this._provincias = jsonDecode(map['provincias']).toSet();
    this._elementos = new List();
    for (int i = 0 ; i < jsonDecode(map['elementos']).length ; i++){
      final elemento = _decidirElemento(jsonDecode(map['elementos'])[i]);
      elementos.add(elemento);
    }
  }

  _decidirElemento(Map map) {
    switch (map['DB_NOMBRE']) {
      case Bar.NOMBRE:
        return Bar.fromMap(map);
      case Cafeteria.NOMBRE:
        return Cafeteria.fromMap(map);
      case Restaurante.NOMBRE:
        return Restaurante.fromMap(map);
      case SalonBanquetes.NOMBRE:
        return SalonBanquetes.fromMap(map);
      case Albergue.NOMBRE:
        return Albergue.fromMap(map);
      case AlojamientoHotelero.NOMBRE:
        return AlojamientoHotelero.fromMap(map);
      case Apartamento.NOMBRE:
        return Apartamento.fromMap(map);
      case Camping.NOMBRE:
        return Camping.fromMap(map);
      case TurismoRural.NOMBRE:
        return TurismoRural.fromMap(map);
      case Vivienda.NOMBRE:
        return Vivienda.fromMap(map);
      case Monumento.NOMBRE:
        return Monumento.fromMap(map);
      case Museo.NOMBRE:
        return Museo.fromMap(map);
      case Evento.NOMBRE:
        return Evento.fromMap(map);
      case ActividadTuristica.NOMBRE:
        return ActividadTuristica.fromMap(map);
      case Guia.NOMBRE:
        return Guia.fromMap(map);
      case TurismoActivo.NOMBRE:
        return TurismoActivo.fromMap(map);
      case OficinaTurismo.NOMBRE:
        return OficinaTurismo.fromMap(map);
    }
  }

  @override
  String toString() {
    return 'Lista{_id: $_id, _publicada: $_publicada, _timestamp: $_timestamp, _nombre: $_nombre, _descripcion: $_descripcion, _autor: $_autor, _dias: $_dias, _provincias: $_provincias, _elementos: $_elementos}';
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'publicada': publicada,
      'timestamp': timestamp.toIso8601String(),
      'nombre': nombre,
      'descripcion': descripcion,
      'autor': autor,
      'dias': dias,
      'provincias': jsonEncode(provincias.toList()),
      'elementos': jsonEncode(elementos.toList())
    };

  void anadirElemento(var elemento){
    if(elementos.contains(elemento))
      throw new Exception("Elemento ya en la lista ${this.nombre}");
    _provincias.add(elemento.provincia);
    _elementos.add(elemento);
  }

  void eliminarElemento(var elemento){
    for (int i = 0 ; i < elementos.length ; i++){
      if(elementos[i].numeroRegistro == elemento.numeroRegistro && elementos[i].DB_NOMBRE == elemento.DB_NOMBRE){
        elementos.removeAt(i);
      }
    }
    for (var e in _elementos){
      if(e.provincia == elemento.provincia)
        return;
    }
    _provincias.remove(elemento.provincia);
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  bool get publicada => _publicada;

  set publicada(bool value) {
    _publicada = value;
  }

  DateTime get timestamp => _timestamp;

  set timestamp(DateTime value) {
    _timestamp = value;
  }

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  String get descripcion => _descripcion;

  set descripcion(String value) {
    _descripcion = value;
  }

  String get autor => _autor;

  set autor(String value) {
    _autor = value;
  }

  int get dias => _dias;

  set dias(int value) {
    _dias = value;
  }

  Set get provincias => _provincias;

  List get elementos => _elementos;
}

