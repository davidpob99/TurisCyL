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

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:turiscyl/models/actividad_turistica.dart';
import 'package:turiscyl/models/albergue.dart';
import 'package:turiscyl/models/alojamiento_hotelero.dart';
import 'package:turiscyl/models/apartamento.dart';
import 'package:turiscyl/models/archivo.dart';
import 'package:turiscyl/models/cafeteria.dart';
import 'package:turiscyl/models/camping.dart';
import 'package:turiscyl/models/evento.dart';
import 'package:turiscyl/models/guia.dart';
import 'package:turiscyl/models/monumento.dart';
import 'package:turiscyl/models/oficina_turismo.dart';
import 'package:turiscyl/models/restaurante.dart';
import 'package:turiscyl/models/salon_banquetes.dart';
import 'package:turiscyl/models/turismo_activo.dart';
import 'package:turiscyl/models/turismo_rural.dart';
import 'package:turiscyl/models/vivienda.dart';

import 'models/bar.dart';
import 'models/museo.dart';
import 'models/venue.dart';
import 'values/strings.dart';

/// Agrupación de las operaciones con la base de datos SQLite
class DbHandler {
  String _path;
  Database _database;

  DbHandler();

  /// Abre la BD para hacer operaciones con ella
  Future<void> abrirDb() async{
    var dbPath = await getDatabasesPath();
    _path = join(dbPath, Strings.nombreDb);
    _database = await openDatabase(_path);
  }

  /// Cierra la base de datos
  Future<void> cerrarDb() async {
    _database.close();
  }

  /// Dado un [objeto] de los elementos turísticos (los del directorio /models,
  /// excepto [Lista] y [Venue]) elimina la tabla de la BD si existe y la genera
  /// de nuevo con su estructura
  Future<void> eliminarYCrearTabla(var objeto) async {
    await abrirDb();
    Batch batch = _database.batch();
    batch.execute('DROP TABLE IF EXISTS ${objeto.DB_NOMBRE}');
    await batch.commit(noResult: true);
    batch.execute(objeto.DB_CREAR);
    await batch.commit(noResult: true);
  }

  /// Dado un [objeto] crea la tabla con la estructura necesaria para el mismo
  Future<void> crearTabla(var objeto) async{
    await abrirDb();
    Batch batch = _database.batch();
    batch.execute(objeto.DB_CREAR);
    await batch.commit(noResult: true);
  }

  /// Dado un [objeto] inserta los [datos] a dicha tabla
  Future<void> insertarDatos(var datos, var objeto) async{
    var batch = _database.batch();
    if(objeto.DB_NOMBRE != Venue.NOMBRE){
      for (int i = 1; i < datos.length; i++) {
        switch (objeto.DB_NOMBRE) {
          case Bar.NOMBRE:
            batch.insert(objeto.DB_NOMBRE, Bar.fromCsv(datos[i]).toMap());
            break;
          case Cafeteria.NOMBRE:
            batch.insert(objeto.DB_NOMBRE, Cafeteria.fromCsv(datos[i]).toMap());
            break;
          case Restaurante.NOMBRE:
            batch.insert(objeto.DB_NOMBRE, Restaurante.fromCsv(datos[i]).toMap());
            break;
          case SalonBanquetes.NOMBRE:
            batch.insert(objeto.DB_NOMBRE, SalonBanquetes.fromCsv(datos[i]).toMap());
            break;
          case Albergue.NOMBRE:
            batch.insert(objeto.DB_NOMBRE, Albergue.fromCsv(datos[i]).toMap());
            break;
          case AlojamientoHotelero.NOMBRE:
            batch.insert(objeto.DB_NOMBRE, AlojamientoHotelero.fromCsv(datos[i]).toMap());
            break;
          case Apartamento.NOMBRE:
            batch.insert(objeto.DB_NOMBRE, Apartamento.fromCsv(datos[i]).toMap());
            break;
          case Camping.NOMBRE:
            batch.insert(objeto.DB_NOMBRE, Camping.fromCsv(datos[i]).toMap());
            break;
          case TurismoRural.NOMBRE:
            batch.insert(objeto.DB_NOMBRE, TurismoRural.fromCsv(datos[i]).toMap());
            break;
          case Vivienda.NOMBRE:
            batch.insert(objeto.DB_NOMBRE, Vivienda.fromCsv(datos[i]).toMap());
            break;
          case Monumento.NOMBRE:
            batch.insert(
                objeto.DB_NOMBRE, Monumento.fromJson(datos[i]).toMap());
            break;
          case Museo.NOMBRE:
            if (i == 1) break;
            batch.insert(objeto.DB_NOMBRE, Museo.fromCsv(datos[i]).toMap());
            break;
          case Archivo.NOMBRE:
            batch.insert(objeto.DB_NOMBRE, Archivo.fromCsv(datos[i]).toMap());
            break;
          case Evento.NOMBRE:
            batch.insert(objeto.DB_NOMBRE, Evento.fromCsv(datos[i]).toMap());
            break;
          case ActividadTuristica.NOMBRE:
            batch.insert(
                objeto.DB_NOMBRE, ActividadTuristica.fromCsv(datos[i]).toMap());
            break;
          case Guia.NOMBRE:
            batch.insert(objeto.DB_NOMBRE, Guia.fromCsv(datos[i]).toMap());
            break;
          case TurismoActivo.NOMBRE:
            batch.insert(objeto.DB_NOMBRE, TurismoActivo.fromCsv(datos[i]).toMap());
            break;
          case OficinaTurismo.NOMBRE:
            batch.insert(
                objeto.DB_NOMBRE, OficinaTurismo.fromCsv(datos[i]).toMap());
            break;
        }
      }
    } else {
      batch.insert(objeto.DB_NOMBRE, objeto.toMap());
    }

    await batch.commit(noResult: true, continueOnError: true);
  }

  /// Dado una orden [sql] realiza la consulta en la BD
  Future<List<Map>> consulta(String sql) async {
    await abrirDb();
    List<Map> query = await _database.rawQuery(sql);
    return query;
  }
}