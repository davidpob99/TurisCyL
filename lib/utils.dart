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

import 'package:csv/csv.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:turiscyl/models/archivo.dart';
import 'package:turiscyl/values/constantes.dart';
import 'package:turiscyl/view_bienvenida.dart';
import 'package:url_launcher/url_launcher.dart';

import 'db_handler.dart';
import 'models/actividad_turistica.dart';
import 'models/albergue.dart';
import 'models/alojamiento_hotelero.dart';
import 'models/apartamento.dart';
import 'models/bar.dart';
import 'models/cafeteria.dart';
import 'models/camping.dart';
import 'models/evento.dart';
import 'models/guia.dart';
import 'models/lista.dart';
import 'models/monumento.dart';
import 'models/museo.dart';
import 'models/oficina_turismo.dart';
import 'models/restaurante.dart';
import 'models/salon_banquetes.dart';
import 'models/turismo_activo.dart';
import 'models/turismo_rural.dart';
import 'models/venue.dart';
import 'models/vivienda.dart';

class Utils {
  final RegExp beforeCapitalLetter = RegExp(r"(?=[A-Z])");

  Utils();

  DbHandler dbHandler = new DbHandler();

  Future<bool> hayInternet(BuildContext context) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      return true;
    } else {
      Toast.show(
          "No hay conexión a Internet: ${DataConnectionChecker().lastTryResults}",
          context);
      return false;
    }
  }

  Future<void> comprobarPrimeraEjecucion(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool noEsPrimera = prefs.containsKey(Constantes.primeraEjecucion);
    if (!noEsPrimera)
      _primeraEjecucion(context);
  }

  void _primeraEjecucion(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VistaBienvenida()));
    _generarSharedPreferences();
    descargarDatos();
  }

  Future<void> _generarSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constantes.listas, Constantes.crearSharedPreferences);
    prefs.setBool(Constantes.primeraEjecucion, false); // da igual que valor sea
  }

  Future<List> obtenerListasGuardadas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String sGuardado = await prefs.getString(Constantes.listas);
    final List listaGuardada = json.decode(sGuardado);
    return listaGuardada;
  }

  Future<void> anadirElementoALista(String id, var elemento) async {
    final List datos = await obtenerListasGuardadas();
    List listas = new List<Lista>();
    for(int i = 0 ; i < datos.length ; i++){
      listas.add(Lista.fromMap(datos[i]));
      if(listas[i].id == id){
        listas[i].anadirElemento(elemento);
      }
    }
    guardarListas(listas);
  }

  Future<void> eliminarElementoDeLista(String id, var elemento) async {
    final List datos = await obtenerListasGuardadas();
    List listas = new List<Lista>();
    for(int i = 0 ; i < datos.length ; i++){
      listas.add(Lista.fromMap(datos[i]));
      if(listas[i].id == id){
        listas[i].eliminarElemento(elemento);
      }
    }
    guardarListas(listas);
  }

  Future<void> anadirLista(Lista lista) async {
    List guardados = await obtenerListasGuardadas();
    guardados.add(lista);
    guardarListas(guardados);
  }

  Future<void> eliminarLista(String id) async {
    List guardados = await obtenerListasGuardadas();
    for (int i = 0 ; i < guardados.length ; i++){
      final Lista lista = Lista.fromMap(guardados[i]);
      if (lista.id == id)
        guardados.removeAt(i);
    }
    guardarListas(guardados);
  }

  Future<void> guardarListas(List list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constantes.listas, jsonEncode(list));
  }

  void descargarDatos(){
    try {
      dbHandler.crearTabla(Venue.vacio());
    } catch (e) {
      print("Tabla Venues ya creada");
    }
    descargarCsv(Bar.vacio());
    descargarCsv(Cafeteria.vacio());
    descargarCsv(Restaurante.vacio());
    descargarCsv(SalonBanquetes.vacio());
    descargarCsv(Albergue.vacio());
    descargarCsv(AlojamientoHotelero.vacio());
    descargarCsv(Apartamento.vacio());
    descargarCsv(Camping.vacio());
    descargarCsv(TurismoRural.vacio());
    descargarCsv(Vivienda.vacio());
    descargarJson(Monumento.vacio());
    descargarCsv(Museo.vacio());
    descargarCsv(Archivo.vacio());
    descargarCsv(Evento.vacio());
    descargarCsv(ActividadTuristica.vacio());
    descargarCsv(Guia.vacio());
    descargarCsv(TurismoActivo.vacio());
    descargarCsv(OficinaTurismo.vacio());
  }

  /// Dado un [objeto] descarga el Csv de dicho objeto e invoca a [csvToDb] para
  /// crear la base de datos
  Future descargarCsv(var objeto) async {
    var url = getUrl(objeto);
    http.Response respuesta = await http.get(url);
    if (respuesta.statusCode == 200) {
      List<List<dynamic>> csv;
      String str = respuesta.body;
      if (objeto.DB_NOMBRE == Museo.NOMBRE ||
          objeto.DB_NOMBRE == Evento.NOMBRE ||
          objeto.DB_NOMBRE == Archivo.NOMBRE) {
        str.replaceAll("\n", "");
        str.replaceAll("\r", "\r\n");
      }
      else {
        str = str.replaceAll('"', '');
      }
      csv = CsvToListConverter(fieldDelimiter: ";").convert(str);
      csvToDb(csv, objeto);
    } else {
      throw Exception("Fallo al descargar " + url);
    }
  }

  Future descargarJson(var objeto) async {
    var url = getUrl(objeto);
    http.Response respuesta = await http.get(url);
    if (respuesta.statusCode == 200) {
      String str = respuesta.body;
      str = str.replaceAll("Ã¡", "á");
      str = str.replaceAll("Ã©", "é");
      str = str.replaceAll("Ã­", "í");
      str = str.replaceAll("Ã³", "ó");
      str = str.replaceAll("Ãº", "ú");
      str = str.replaceAll("Ã", "Á");
      str = str.replaceAll("Ã‰", "É");
      str = str.replaceAll("Ã", "Í");
      str = str.replaceAll("Ã“", "Ó");
      str = str.replaceAll("Ãš", "Ú");
      str = str.replaceAll("Ã±", "ñ");
      List lista = jsonDecode(str)['monumentos'];
      csvToDb(lista, objeto);
    } else {
      throw Exception("Fallo al descargar " + url);
    }
  }

  /// A partir del [objeto] devuelve la URL del CSV para descargar los datos del
  /// servidor de la JCyL
  String getUrl(var objeto) {
    switch (objeto.DB_NOMBRE) {
      case Bar.NOMBRE:
        return Bar.CSV;
      case Cafeteria.NOMBRE:
        return Cafeteria.CSV;
      case Restaurante.NOMBRE:
        return Restaurante.CSV;
      case SalonBanquetes.NOMBRE:
        return SalonBanquetes.CSV;
      case Albergue.NOMBRE:
        return Albergue.CSV;
      case Camping.NOMBRE:
        return Camping.CSV;
      case AlojamientoHotelero.NOMBRE:
        return AlojamientoHotelero.CSV;
      case Apartamento.NOMBRE:
        return Apartamento.CSV;
      case TurismoRural.NOMBRE:
        return TurismoRural.CSV;
      case Vivienda.NOMBRE:
        return Vivienda.CSV;
      case Monumento.NOMBRE:
        return Monumento.JSON;
      case Museo.NOMBRE:
        return Museo.CSV;
      case Archivo.NOMBRE:
        return Archivo.CSV;
      case Evento.NOMBRE:
        return Evento.CSV;
      case ActividadTuristica.NOMBRE:
        return ActividadTuristica.CSV;
      case Guia.NOMBRE:
        return Guia.CSV;
      case TurismoActivo.NOMBRE:
        return TurismoActivo.CSV;
      case OficinaTurismo.NOMBRE:
        return OficinaTurismo.CSV;
    }
  }

  /// A partir de unos [datos] dados (obtenidos a partir del CSV ya en forma de
  /// lista de listas csv[i][j]) crea y los almacena en la base de datos
  /// [Strings.nombreDb] de forma Batch, para que sea más rápido al juntar
  /// transacciones
  Future csvToDb(var datos, var objeto) async {
    await dbHandler.eliminarYCrearTabla(objeto);
    await dbHandler.insertarDatos(datos, objeto);
  }

  Future<void> openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget cargandoDatos(){
    return Container(
      padding: EdgeInsets.only(top: 50),
      height: 200,
      child: Column(
        children: <Widget>[
          new Center(child: new CircularProgressIndicator()),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Text("Cargando datos..."),
          )
        ],
      ),
    );
  }
}