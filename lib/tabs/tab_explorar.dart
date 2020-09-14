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
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:turiscyl/db_handler.dart';
import 'package:turiscyl/models/actividad_turistica.dart';
import 'package:turiscyl/models/albergue.dart';
import 'package:turiscyl/models/alojamiento_hotelero.dart';
import 'package:turiscyl/models/apartamento.dart';
import 'package:turiscyl/models/bar.dart';
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
import 'package:turiscyl/models/venue.dart';
import 'package:turiscyl/models/vivienda.dart';
import 'package:turiscyl/utils.dart';
import 'package:turiscyl/values/strings.dart';
import 'package:turiscyl/view_categorias.dart';
import 'package:turiscyl/view_informacion.dart';
import 'package:url_launcher/url_launcher.dart';

class TabExplorar extends StatefulWidget {
  @override
  _TabExplorarState createState() => _TabExplorarState();
}

class _TabExplorarState extends State<TabExplorar> {

  @override
  void initState() {
    super.initState();
    Utils().hayInternet(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 200,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/donde_comer.jpg',
                    fit: BoxFit.cover,
                    height: 145,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Strings.dondeComer,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            VistaCategorias(categoriaElegida: 0)));
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
          ),
        ),
        Container(
          height: 200,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/donde_dormir.jpg',
                    fit: BoxFit.cover,
                    height: 145,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Strings.dondeDormir,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            VistaCategorias(categoriaElegida: 1)));
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
          ),
        ),
        Container(
          height: 200,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/que_ver.jpg',
                    fit: BoxFit.cover,
                    height: 145,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Strings.queVer,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            VistaCategorias(categoriaElegida: 2)));
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
          ),
        ),
        Container(
          height: 200,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/que_hacer.jpg',
                    fit: BoxFit.cover,
                    height: 145,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Strings.queHacer,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            VistaCategorias(categoriaElegida: 3)));
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
          ),
        ),
        Container(
          height: 200,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/mas_informacion.jpg',
                    fit: BoxFit.cover,
                    height: 145,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Strings.masInfo,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            VistaInformacion(categoriaElegida: OficinaTurismo.NOMBRE, consulta: null)));
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
          ),
        ),
        Container(
          height: 200,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/espacios_naturales.jpg',
                    fit: BoxFit.cover,
                    height: 145,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Strings.espaciosNaturales,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              onTap: () {
                launch(
                    "https://play.google.com/store/apps/details?id=es.davidpob99.naturcyl");
              }
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
          ),
        ),
      ],
    );
  }
}
