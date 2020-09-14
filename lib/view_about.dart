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
import 'package:turiscyl/icons_turiscyl.dart';
import 'package:turiscyl/material_design_icons.dart';
import 'package:turiscyl/utils.dart';
import 'package:turiscyl/values/colores.dart';
import 'package:turiscyl/values/strings.dart';
import 'package:turiscyl/view_html.dart';

class VistaAcercaDe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Acerca de"),
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
                  "Versión 0.1.0",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(Strings.descripcion, textAlign: TextAlign.center),
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
                          titulo: "GNU GPL v3",
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
                    Text("Licencia de la app", style: TextStyle(color: Colores().dark),)
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VistaHtml(
                          titulo: "Sobre los datos",
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
                    Text("Sobre los datos", style: TextStyle(color: Colores().dark),)
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VistaHtml(
                          titulo: "Política de privacidad",
                          html: Strings.politicaPrivacidad,
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
                    Text("Política de privacidad", style: TextStyle(color: Colores().dark),)
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VistaHtml(
                          titulo: "Bibliotecas de código abierto",
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
                    Text("Bibliotecas de código abierto", style: TextStyle(color: Colores().dark),)
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Utils().openUrl("https://www.gnu.org/licenses/gpl-3.0.txt");
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(IconsTurisCyL.github,
                          color: Colores().dark),
                    ),
                    Text("Ver en GitHub", style: TextStyle(color: Colores().dark),)
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
