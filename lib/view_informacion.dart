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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:turiscyl/db_handler.dart';
import 'package:turiscyl/filter_informacion.dart';
import 'package:turiscyl/models/actividad_turistica.dart';
import 'package:turiscyl/models/albergue.dart';
import 'package:turiscyl/models/alojamiento_hotelero.dart';
import 'package:turiscyl/models/apartamento.dart';
import 'package:turiscyl/models/cafeteria.dart';
import 'package:turiscyl/models/camping.dart';
import 'package:turiscyl/models/evento.dart';
import 'package:turiscyl/models/guia.dart';
import 'package:turiscyl/models/monumento.dart';
import 'package:turiscyl/models/museo.dart';
import 'package:turiscyl/models/oficina_turismo.dart';
import 'package:turiscyl/models/restaurante.dart';
import 'package:turiscyl/models/salon_banquetes.dart';
import 'package:turiscyl/models/turismo_activo.dart';
import 'package:turiscyl/models/turismo_rural.dart';
import 'package:turiscyl/models/vivienda.dart';
import 'package:turiscyl/utils.dart';
import 'package:turiscyl/values/strings.dart';
import 'package:turiscyl/view_detalles.dart';

import 'models/archivo.dart';
import 'models/bar.dart';

/// Vista que muestra un [ListView] con los elementos de la [categoriaElegida] y
/// que cumplen la [consulta]. Si hay un error muestra un [Toast] advirtiendo
/// y un [Text] con el mensaje de error de la BD
class VistaInformacion extends StatefulWidget {
  final String categoriaElegida;
  final String consulta;

  VistaInformacion({Key key, @required this.categoriaElegida, this.consulta})
      : super(key: key);

  @override
  _VistaInformacionState createState() => _VistaInformacionState();
}

class _VistaInformacionState extends State<VistaInformacion> {
  List lista = List();
  DbHandler dbHandler = DbHandler();
  var objetoElegido;

  @override
  void initState() {
    super.initState();
    switch (widget.categoriaElegida) {
    // Comer
      case Bar.NOMBRE:
        objetoElegido = Bar.vacio();
        break;
      case Cafeteria.NOMBRE:
        objetoElegido = Cafeteria.vacio();
        break;
      case Restaurante.NOMBRE:
        objetoElegido = Restaurante.vacio();
        break;
      case SalonBanquetes.NOMBRE:
        objetoElegido = SalonBanquetes.vacio();
        break;
    // Dormir
      case Albergue.NOMBRE:
        objetoElegido = Albergue.vacio();
        break;
      case AlojamientoHotelero.NOMBRE:
        objetoElegido = AlojamientoHotelero.vacio();
        break;
      case Apartamento.NOMBRE:
        objetoElegido = Apartamento.vacio();
        break;
      case Camping.NOMBRE:
        objetoElegido = Camping.vacio();
        break;
      case TurismoRural.NOMBRE:
        objetoElegido = TurismoRural.vacio();
        break;
      case Vivienda.NOMBRE:
        objetoElegido = Vivienda.vacio();
        break;
      // Ver
      case Monumento.NOMBRE:
        objetoElegido = Monumento.vacio();
        break;
      case Museo.NOMBRE:
        objetoElegido = Museo.vacio();
        break;
      case Archivo.NOMBRE:
        objetoElegido = Archivo.vacio();
        break;
      // Hacer
      case Evento.NOMBRE:
        objetoElegido = Evento.vacio();
        break;
      case ActividadTuristica.NOMBRE:
        objetoElegido = ActividadTuristica.vacio();
        break;
      case Guia.NOMBRE:
        objetoElegido = Guia.vacio();
        break;
      case TurismoActivo.NOMBRE:
        objetoElegido = TurismoActivo.vacio();
        break;
      case OficinaTurismo.NOMBRE:
        objetoElegido = OficinaTurismo.vacio();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
          widget.categoriaElegida.split(Utils().beforeCapitalLetter).join(
              " "))),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 10,
            child: Container(
              height: double.infinity,
              child: FutureBuilder<List>(
                future: dbHandler.consulta(widget.consulta == null
                    ? objetoElegido.DB_CONSULTA_BASICA
                    : widget.consulta),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (widget.categoriaElegida) {
                    // Comer
                      case Bar.NOMBRE:
                        snapshot.data.forEach((k) => lista.add(Bar.fromMap(k)));
                        break;
                      case Cafeteria.NOMBRE:
                        snapshot.data
                            .forEach((k) => lista.add(Cafeteria.fromMap(k)));
                        break;
                      case Restaurante.NOMBRE:
                        snapshot.data
                            .forEach((k) => lista.add(Restaurante.fromMap(k)));
                        break;
                      case SalonBanquetes.NOMBRE:
                        snapshot.data.forEach(
                                (k) => lista.add(SalonBanquetes.fromMap(k)));
                        break;
                    // Dormir
                      case Albergue.NOMBRE:
                        snapshot.data
                            .forEach((k) => lista.add(Albergue.fromMap(k)));
                        break;
                      case AlojamientoHotelero.NOMBRE:
                        snapshot.data.forEach(
                                (k) => lista.add(AlojamientoHotelero.fromMap(k)));
                        break;
                      case Apartamento.NOMBRE:
                        snapshot.data
                            .forEach((k) => lista.add(Apartamento.fromMap(k)));
                        break;
                      case Camping.NOMBRE:
                        snapshot.data
                            .forEach((k) => lista.add(Camping.fromMap(k)));
                        break;
                      case TurismoRural.NOMBRE:
                        snapshot.data
                            .forEach((k) => lista.add(TurismoRural.fromMap(k)));
                        break;
                      case Vivienda.NOMBRE:
                        snapshot.data
                            .forEach((k) => lista.add(Vivienda.fromMap(k)));
                        break;
                      case Monumento.NOMBRE:
                        snapshot.data
                            .forEach((k) => lista.add(Monumento.fromMap(k)));
                        break;
                      case Museo.NOMBRE:
                        snapshot.data
                            .forEach((k) => lista.add(Museo.fromMap(k)));
                        break;
                      case Archivo.NOMBRE:
                        snapshot.data
                            .forEach((k) => lista.add(Archivo.fromMap(k)));
                        break;
                      case Evento.NOMBRE:
                        snapshot.data
                            .forEach((k) => lista.add(Evento.fromMap(k)));
                        break;
                      case ActividadTuristica.NOMBRE:
                        snapshot.data.forEach(
                                (k) =>
                                lista.add(ActividadTuristica.fromMap(k)));
                        break;
                      case Guia.NOMBRE:
                        snapshot.data
                            .forEach((k) => lista.add(Guia.fromMap(k)));
                        break;
                      case TurismoActivo.NOMBRE:
                        snapshot.data.forEach(
                                (k) => lista.add(TurismoActivo.fromMap(k)));
                        break;
                      case OficinaTurismo.NOMBRE:
                        snapshot.data.forEach(
                                (k) => lista.add(OficinaTurismo.fromMap(k)));
                        break;
                    }
                    return ListView.builder(
                      primary: true,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10),
                      itemCount: lista.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VistaDetalles(
                                          categoriaElegida:
                                          widget.categoriaElegida,
                                          elemento: lista[index],
                                        )));
                              },
                              child: lista[index].vistaInformacion(),
                            ));
                      },
                    );
                  } else if (snapshot.hasError) {
                    Toast.show(Strings.errorDb, context, duration: 3);
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                          "Texto del error:\n\n $snapshot.error\n\nSi el error persiste, contacte con el desarrollador"),
                    );
                  } else {
                    return Utils().cargandoDatos();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          child: Icon(
            Icons.tune,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FiltroInformacion(objetoElegido: objetoElegido)));
          }),
    );
  }
}
