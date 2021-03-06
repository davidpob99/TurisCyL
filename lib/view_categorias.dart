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
import 'package:turiscyl/utils.dart';
import 'package:turiscyl/values/constantes.dart';
import 'package:turiscyl/values/strings.dart';
import 'package:turiscyl/view_informacion.dart';

/// Vista con la lista de subcategorías dada una [categoriaElegida]
/// Argumentos:
/// * [categoriaElegida]: una de las categorias (dormir, comer, ...) que se
/// muestran en [TabExplorar]
class VistaCategorias extends StatelessWidget {
  final int categoriaElegida;

  VistaCategorias({Key key, @required this.categoriaElegida}) : super(key: key);

  /// Dependiendo la [categoriaElegida] devuelve la lista de nombres de las
  /// subcategorías que corresponda
  List<String> _getListaDeCategorias() {
    switch (categoriaElegida) {
      case 0:
        return Constantes.categoriasComer;
      case 1:
        return Constantes.categoriasDormir;
      case 2:
        return Constantes.categoriasVer;
      case 3:
        return Constantes.categoriasHacer;
    }
  }

  /// Dependiendo la [categoriaElegida] devuelve la lista de imágenes de las
  /// subcategorías que corresponda
  List<String> _getListaDeImagenes() {
    switch (categoriaElegida) {
      case 0:
        return Constantes.imagenesComer;
      case 1:
        return Constantes.imagenesDormir;
      case 2:
        return Constantes.imagenesVer;
      case 3:
        return Constantes.imagenesHacer;
    }
  }

  /// Dependiendo la [categoriaElegida] devuelve el título de la misma
  String _getTitulo() {
    switch (categoriaElegida) {
      case 0:
        return Strings.dondeComer;
      case 1:
        return Strings.dondeDormir;
      case 2:
        return Strings.queVer;
      case 3:
        return Strings.queHacer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _categoria = _getListaDeCategorias();
    final List<String> _imagenes = _getListaDeImagenes();
    final String _titulo = _getTitulo();

    return Scaffold(
      appBar: AppBar(title: Text(_titulo)),
      body: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: _categoria.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 200,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        _imagenes[index],
                        fit: BoxFit.cover,
                        height: 145,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _categoria[index]
                              .split(Utils().beforeCapitalLetter)
                              .join(" "),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VistaInformacion(
                                categoriaElegida: _categoria[index]
                            )
                        )
                    );
                  },
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
            );
          }),
    );
  }
}
