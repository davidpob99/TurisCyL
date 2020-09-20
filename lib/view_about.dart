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
import 'package:turiscyl/icons_turiscyl.dart';
import 'package:turiscyl/material_design_icons.dart';
import 'package:turiscyl/utils.dart';
import 'package:turiscyl/values/colores.dart';
import 'package:turiscyl/values/constantes.dart';
import 'package:turiscyl/values/strings.dart';
import 'package:turiscyl/view_html.dart';

/// Vista que muestra la información de los créditos de la app y distintos
/// enlaces relacionados como la Política de Privacidad
class VistaAcercaDe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.acercaDe),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(width: 150,child: Image(image: AssetImage("assets/icon/icon.png"))),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Strings.version,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(Strings.descripcionApp, textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(Strings.copyright, textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(Strings.gnu3Corto, textAlign: TextAlign.center),
              ),
              Divider(
                color: Colores().dark,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VistaHtml(
                          titulo: Strings.gnuGplv3,
                          html: Strings.htmlGpl3,
                        ),
                      ));
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: Icon(Icons.copyright,
                        color: Colores().dark),
                      ),
                    ),
                    Text(Strings.licenciaApp,
                      style: TextStyle(color: Colores().dark),)
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VistaHtml(
                          titulo: Strings.sobreDatos,
                          html: Strings.htmlDatosJcyl,
                        ),
                      ));
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.assessment,
                          color: Colores().dark),
                    ),
                    Text(Strings.sobreDatos,
                      style: TextStyle(color: Colores().dark),)
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VistaHtml(
                          titulo: Strings.politicaPrivacidad,
                          html: Strings.htmlPoliticaPrivacidad,
                        ),
                      ));
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(MaterialDesignIcons.description,
                          color: Colores().dark),
                    ),
                    Text(Strings.politicaPrivacidad,
                      style: TextStyle(color: Colores().dark),)
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VistaHtml(
                          titulo: Strings.bibliotecasAbiertas,
                          html: Strings.htmlBibliotecas,
                        ),
                      ));
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(MaterialDesignIcons.description,
                          color: Colores().dark),
                    ),
                    Text(
                      Strings.bibliotecasAbiertas,
                      style: TextStyle(color: Colores().dark),
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VistaHtml(
                          titulo: Strings.creditosFotos,
                          html: Strings.htmlCreditosImagenes,
                        ),
                      ));
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.photo, color: Colores().dark),
                    ),
                    Text(
                      Strings.creditosFotos,
                      style: TextStyle(color: Colores().dark),
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Utils().openUrl(Constantes.urlGithub);
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(IconsTurisCyL.github, color: Colores().dark),
                    ),
                    Text(
                      Strings.verGithub,
                      style: TextStyle(color: Colores().dark),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
