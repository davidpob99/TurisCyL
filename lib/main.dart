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
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:toast/toast.dart';
import 'package:turiscyl/crear_lista.dart';
import 'package:turiscyl/material_design_icons.dart';
import 'package:turiscyl/tabs/tab_explorar.dart';
import 'package:turiscyl/tabs/tab_listas.dart';
import 'package:turiscyl/utils.dart';
import 'package:turiscyl/values/colores.dart';
import 'package:turiscyl/values/strings.dart';
import 'package:turiscyl/view_about.dart';
import 'package:turiscyl/view_html.dart';
import 'package:turiscyl/view_importar.dart';
import 'package:turiscyl/view_listas_publicas.dart';

import 'choice.dart';
import 'models/evento.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.nombreApp,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colores().primario,
        accentColor: Colores().light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
            color: Colors.white,
            elevation: 0,
            textTheme: TextTheme(
                headline6: TextStyle(
                    color: Colores().primario,
                    fontSize: 20,
                    letterSpacing: 0.15)),
            iconTheme: IconThemeData(color: Colores().primario)),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: Strings.nombreApp),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const List<Choice> choices = const <Choice>[
  const Choice(title: Strings.ayuda, icon: Icons.help),
  const Choice(title: Strings.acercaDe, icon: Icons.info),
];

class _MyHomePageState extends State<MyHomePage> {
  Choice _selectedChoice = choices[0];
  int _selectedIndex = 0; // fab counter

  @override
  void initState() {
    Utils().descargarCsv(Evento.vacio());
    Utils().comprobarPrimeraEjecucion(context);
    super.initState();
  }

  // tap BottomNavigationBar will invoke this method
  _onItemTapped(int index) {
    setState(() {
      // change _selectedIndex, fab will show or hide
      _selectedIndex = index;
    });
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
      switch (_selectedChoice.title) {
        case Strings.ayuda:
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VistaHtml(
                      titulo: Strings.ayuda,
                      html: Strings.htmlAyuda,
                    )),
          );
          break;
        case Strings.acercaDe:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VistaAcercaDe()),
          );
          break;
      }
    });
  }

  Widget _elegirFab() {
    switch (_selectedIndex) {
      case 0:
        return FloatingActionButton(
            onPressed: () {
              switch (_selectedIndex) {
                case 0:
                  Utils().hayInternet(context);
                  Toast.show(Strings.actualizandoDatos, context, duration: 5);
                  Utils().descargarDatos();
                  break;
              }
            },
            child: Icon(Icons.refresh));
      case 1:
        return SpeedDial(
          child: Icon(Icons.add),
          children: [
            SpeedDialChild(
                child: Icon(Icons.file_download),
                backgroundColor: Colores().primario,
                label: Strings.importar,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VistaImportar()));
                }),
            SpeedDialChild(
                child: Icon(MaterialDesignIcons.people),
                backgroundColor: Colores().primario,
                label: Strings.publicas,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VistaListasPublicas()));
                }),
            SpeedDialChild(
                child: Icon(Icons.playlist_add),
                backgroundColor: Colores().primario,
                label: Strings.nuevaLista,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CrearLista()));
                })
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text(Strings.nombreApp),
              actions: <Widget>[
                PopupMenuButton<Choice>(
                  onSelected: _select,
                  itemBuilder: (BuildContext context) {
                    return choices.map((Choice choice) {
                      return PopupMenuItem<Choice>(
                        value: choice,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(choice.icon),
                            ),
                            Text(choice.title)
                          ],
                        ),
                      );
                    }).toList();
                  },
                )
              ],
              bottom: TabBar(
                onTap: _onItemTapped,
                labelColor: Colors.white,
                unselectedLabelColor: Colores().primario,
                indicator: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 5),
                  gradient: LinearGradient(
                      colors: [Colores().primario, Colores().dark]),
                  borderRadius: BorderRadius.circular(50),
                ),
                tabs: [
                  Tab(
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 24.0,
                        ),
                        Icon(
                          Icons.explore,
                        ),
                        SizedBox(
                          width: 24.0,
                        ),
                        Text(Strings.explorar)
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 24.0,
                        ),
                        Icon(
                          Icons.list,
                        ),
                        SizedBox(
                          width: 24.0,
                        ),
                        Text(Strings.listas)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [TabExplorar(), TabListas()],
            ),
            floatingActionButton: _elegirFab()
        ),
      ),
    );
  }
}