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
import 'package:turiscyl/models/lista.dart';
import 'package:turiscyl/utils.dart';
import 'package:turiscyl/values/strings.dart';
import 'package:turiscyl/view_lista.dart';

class TabListas extends StatefulWidget {
  @override
  _TabListasState createState() => _TabListasState();
}

class _TabListasState extends State<TabListas> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils().obtenerListasGuardadas(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                final Lista lista = Lista.fromMap(snapshot.data[index]);
                return Card(
                  child: InkWell(
                    splashColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VistaLista(
                              lista: lista,
                            ),
                          ));
                    },
                    child: ListTile(
                      title: Text('${lista.nombre}'),
                      subtitle: Text(
                          '${lista.provincias.toList().join(", ")} · ${lista.dias} días'),
                    ),
                  ),
                );
              });
        } else if (snapshot.hasError){
          return Text(snapshot.error);
        } else {
          return Utils().cargandoDatos();
        }
    }
    );
  }
}