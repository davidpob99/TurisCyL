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

import 'dart:ffi';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:turiscyl/db_handler.dart';
import 'package:turiscyl/icons_turiscyl.dart';
import 'package:turiscyl/models/albergue.dart';
import 'package:turiscyl/models/alojamiento_hotelero.dart';
import 'package:turiscyl/models/apartamento.dart';
import 'package:turiscyl/models/cafeteria.dart';
import 'package:turiscyl/models/camping.dart';
import 'package:turiscyl/models/guia.dart';
import 'package:turiscyl/models/museo.dart';
import 'package:turiscyl/models/oficina_turismo.dart';
import 'package:turiscyl/models/restaurante.dart';
import 'package:turiscyl/models/salon_banquetes.dart';
import 'package:turiscyl/models/turismo_activo.dart';
import 'package:turiscyl/models/turismo_rural.dart';
import 'package:turiscyl/models/vivienda.dart';
import 'package:turiscyl/utils.dart';
import 'package:turiscyl/values/constantes.dart';
import 'package:turiscyl/values/strings.dart';
import 'package:turiscyl/view_informacion.dart';

import 'models/actividad_turistica.dart';
import 'models/evento.dart';
import 'models/monumento.dart';

class FiltroInformacion extends StatefulWidget {
  final objetoElegido;

  FiltroInformacion({Key key, @required this.objetoElegido}) : super(key: key);

  @override
  _FiltroInformacionState createState() => _FiltroInformacionState();
}

class _FiltroInformacionState extends State<FiltroInformacion> {
  List<String> nombresElegidos = new List<String>();
  List<String> municipiosElegidos = new List<String>();
  List<String> provinciasElegidas = new List<String>();
  bool pmrElegido = false;
  List<String> categoriaElegida = new List<String>();
  List<String> tiposElegidos = new List<String>();
  List<String> categorias = new List<String>();
  List<String> tipos = new List<String>();
  // Monumentos
  List<String> tiposConstruccion = new List<String>();
  List<String> tiposConstruccionElegidos = new List<String>();
  List<String> clasificaciones = new List<String>();
  List<String> clasificacionesElegidas = new List<String>();
  // Eventos
  List<String> tematicas = new List<String>();
  List<String> tematicasElegidas = new List<String>();

  DbHandler dbHandler = new DbHandler();

  @override
  void initState() {
    super.initState();
    _cargarFiltrosDb();
  }

  String _generarConsulta() {
    final String whereNombres = nombresElegidos.length > 0
        ? "WHERE instr(UPPER(nombre), '${nombresElegidos.join(" ").toUpperCase()}') > 0"
        : "WHERE 0=0";
    // Discernir entre municipios y localidades
    String whereMunicipios;
    if (widget.objetoElegido.DB_NOMBRE == Museo.NOMBRE || widget.objetoElegido.DB_NOMBRE == Evento.NOMBRE){
      whereMunicipios  = municipiosElegidos.length > 0
          ? "AND localidad IN ('${municipiosElegidos.join(',')}')"
          : "";
    }else{
      whereMunicipios = municipiosElegidos.length > 0
          ? "AND municipio IN ('${municipiosElegidos.join(',')}')"
          : "";
    }
    final String whereProvincias = provinciasElegidas.length > 0
        ? "AND provincia IN ('${provinciasElegidas.join(',')}')"
        : "";
    final String whereCategorias =
    (widget.objetoElegido.DB_NOMBRE == Cafeteria.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == Restaurante.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == SalonBanquetes.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == AlojamientoHotelero.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == Apartamento.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == Camping.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == TurismoRural.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == Evento.NOMBRE) && categoriaElegida.length > 0
    ? "AND categoria IN ('${categoriaElegida.join(',')}')" : "";
    final String whereTipos =
    (widget.objetoElegido.DB_NOMBRE == Cafeteria.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == Restaurante.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == SalonBanquetes.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == Vivienda.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == Albergue.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == AlojamientoHotelero.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == TurismoRural.NOMBRE) && tiposElegidos.length > 0
    ? "AND tipo IN ('${tiposElegidos.join(',')}')" : "";
    final String whereTiposConstruccion = tiposConstruccionElegidos.length > 0
        ? "AND instr(UPPER(tipo_construccion), '${tiposConstruccionElegidos.join(" ").toUpperCase()}') > 0"
        : "";
    final String whereClasificaciones = clasificacionesElegidas.length > 0
        ? "AND instr(UPPER(clasificacion), '${clasificacionesElegidas.join(" ").toUpperCase()}') > 0"
        : "";
    final String whereTematicas = tematicasElegidas.length > 0
        ? "AND instr(UPPER(tematica), '${tematicasElegidas.join(" ").toUpperCase()}') > 0"
        : "";

    return '''
    SELECT *
    FROM ${widget.objetoElegido.DB_NOMBRE}
    ${whereNombres}
    ${whereMunicipios}
    ${whereProvincias}
    ${whereCategorias}
    ${whereTipos}
    ${whereTiposConstruccion}
    ${whereClasificaciones}
    ${whereTematicas}
    ${pmrElegido ? "AND pmr = 1" : ""}
    ''';
  }

  Future<void> _cargarFiltrosDb() async {
    // CATEGORÍAS
    if(
      widget.objetoElegido.DB_NOMBRE == Cafeteria.NOMBRE ||
      widget.objetoElegido.DB_NOMBRE == Restaurante.NOMBRE ||
      widget.objetoElegido.DB_NOMBRE == SalonBanquetes.NOMBRE ||
      widget.objetoElegido.DB_NOMBRE == AlojamientoHotelero.NOMBRE ||
          widget.objetoElegido.DB_NOMBRE == Apartamento.NOMBRE ||
          widget.objetoElegido.DB_NOMBRE == Camping.NOMBRE ||
          widget.objetoElegido.DB_NOMBRE == TurismoRural.NOMBRE ||
          widget.objetoElegido.DB_NOMBRE == Evento.NOMBRE
    ){
      final String sql = '''
    SELECT DISTINCT categoria
    FROM ${widget.objetoElegido.DB_NOMBRE}
    ''';
      List<Map> s = await dbHandler.consulta(sql);
      s.forEach((element) {
        setState(() {
          categorias.add(element['categoria']);
        });
      });
    }else{
      setState(() {
        categorias = null;
      });
    }

    // TIPOS
    if(
    widget.objetoElegido.DB_NOMBRE == Cafeteria.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == Restaurante.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == SalonBanquetes.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == Vivienda.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == Albergue.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == AlojamientoHotelero.NOMBRE ||
        widget.objetoElegido.DB_NOMBRE == TurismoRural.NOMBRE
    ){
      final String sql = '''
    SELECT DISTINCT tipo
    FROM ${widget.objetoElegido.DB_NOMBRE}
    ''';
      List<Map> s = await dbHandler.consulta(sql);
      s.forEach((element) {
        setState(() {
          tipos.add(element['tipo']);
        });
      });
    }else{
      setState(() {
        tipos = null;
      });
    }

    // TIPO CONSTRUCCIÓN (MONUMENTOS)
    if(widget.objetoElegido.DB_NOMBRE == Monumento.NOMBRE){
    final String sql = '''
    SELECT DISTINCT tipo_construccion
    FROM ${widget.objetoElegido.DB_NOMBRE}
    ''';
      List<Map> s = await dbHandler.consulta(sql);
      s.forEach((element) {
        setState(() {
          tiposConstruccion.add(element['tipo_construccion']);
        });
      });
    }else{
      setState(() {
        tiposConstruccion = null;
      });
    }
    // CLASIFICACION (MONUMENTOS)
    if(widget.objetoElegido.DB_NOMBRE == Monumento.NOMBRE){
      final String sql = '''
    SELECT DISTINCT clasificacion
    FROM ${widget.objetoElegido.DB_NOMBRE}
    ''';
      List<Map> s = await dbHandler.consulta(sql);
      s.forEach((element) {
        setState(() {
          clasificaciones.add(element['clasificacion']);
        });
      });
    }else{
      setState(() {
        clasificaciones = null;
      });
    }
    // TEMÁTICAS (EVENTOS)
    if(widget.objetoElegido.DB_NOMBRE == Evento.NOMBRE){
      final String sql = '''
    SELECT DISTINCT tematica
    FROM ${widget.objetoElegido.DB_NOMBRE}
    ''';
      List<Map> s = await dbHandler.consulta(sql);
      s.forEach((element) {
        setState(() {
          tematicas.add(element['tematica']);
        });
      });
    }else{
      setState(() {
        tematicas = null;
      });
    }

  }

  Widget _categoria() {
    return Column(
      children: [
        SimpleAutoCompleteTextField(
          decoration: new InputDecoration(
            icon: Icon(Icons.star),
            hintText: "Categoría",
          ),
          suggestions: categorias,
          textSubmitted: (s) => setState(() {
            if (s != "") {
              categoriaElegida.add(s);
            }
          }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Categorías disponibles: ${categorias.join(' - ')}",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
        categoriaElegida.length > 0
            ? Container(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: categoriaElegida.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 5, top: 5),
                      child: InkWell(
                        child: Chip(
                          label: Text(e),
                          avatar: Icon(Icons.remove),
                        ),
                        onTap: () {
                          setState(() {
                            categoriaElegida.remove(e);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _tipo() {
    return Column(
      children: [
        SimpleAutoCompleteTextField(
          decoration: new InputDecoration(
            icon: Icon(IconsTurisCyL.shape),
            hintText: "Tipo",
          ),
          suggestions: tipos,
          textSubmitted: (s) => setState(() {
            if (s != "") {
              tiposElegidos.add(s);
            }
          }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "Tipos disponibles: ${tipos.join(' - ')}",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
            ),
          ),
        ),
        tiposElegidos.length > 0
            ? Container(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: tiposElegidos.map((e) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, top: 5),
                child: InkWell(
                  child: Chip(
                    label: Text(e),
                    avatar: Icon(Icons.remove),
                  ),
                  onTap: () {
                    setState(() {
                      tiposElegidos.remove(e);
                    });
                  },
                ),
              );
            }).toList(),
          ),
        )
            : Container(),
      ],
    );
  }

  Widget _tipoConstruccion() {
    return Column(
      children: [
        SimpleAutoCompleteTextField(
          decoration: new InputDecoration(
            icon: Icon(IconsTurisCyL.bank),
            hintText: "Tipo construcción",
          ),
          suggestions: tiposConstruccion,
          textSubmitted: (s) => setState(() {
            if (s != "") {
              tiposConstruccionElegidos.add(s);
            }
          }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Tipos disponibles: ${tiposConstruccion.join(' - ')}",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
        tiposConstruccionElegidos.length > 0
            ? Container(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: tiposConstruccionElegidos.map((e) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, top: 5),
                child: InkWell(
                  child: Chip(
                    label: Text(e),
                    avatar: Icon(Icons.remove),
                  ),
                  onTap: () {
                    setState(() {
                      tiposConstruccionElegidos.remove(e);
                    });
                  },
                ),
              );
            }).toList(),
          ),
        )
            : Container(),
      ],
    );
  }

  Widget _clasificacion() {
    return Column(
      children: [
        SimpleAutoCompleteTextField(
          decoration: new InputDecoration(
            icon: Icon(IconsTurisCyL.castle),
            hintText: "Clasificación",
          ),
          suggestions: clasificaciones,
          textSubmitted: (s) => setState(() {
            if (s != "") {
              clasificacionesElegidas.add(s);
            }
          }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Clasificaciones disponibles: ${clasificaciones.join(' - ')}",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
        clasificacionesElegidas.length > 0
            ? Container(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: clasificacionesElegidas.map((e) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, top: 5),
                child: InkWell(
                  child: Chip(
                    label: Text(e),
                    avatar: Icon(Icons.remove),
                  ),
                  onTap: () {
                    setState(() {
                      clasificacionesElegidas.remove(e);
                    });
                  },
                ),
              );
            }).toList(),
          ),
        )
            : Container(),
      ],
    );
  }

  Widget _tematica() {
    return Column(
      children: [
        SimpleAutoCompleteTextField(
          decoration: new InputDecoration(
            icon: Icon(IconsTurisCyL.stadium_variant),
            hintText: "Temática",
          ),
          suggestions: tematicas,
          textSubmitted: (s) => setState(() {
            if (s != "") {
              tematicasElegidas.add(s);
            }
          }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Temáticas disponibles: ${tematicas.join(' - ')}",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
        tematicasElegidas.length > 0
            ? Container(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: tematicasElegidas.map((e) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, top: 5),
                child: InkWell(
                  child: Chip(
                    label: Text(e),
                    avatar: Icon(Icons.remove),
                  ),
                  onTap: () {
                    setState(() {
                      tematicasElegidas.remove(e);
                    });
                  },
                ),
              );
            }).toList(),
          ),
        )
            : Container(),
      ],
    );
  }

  Widget _decidirVista() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
              "Añade un filtro para concretar las búsquedas. Recuerda que se tienen que cumplir todas las condiciones que introduzcas"),
          SimpleAutoCompleteTextField(
            decoration: new InputDecoration(
              icon: Icon(Icons.label),
              hintText: "Nombre",
            ),
            suggestions: [],
            textSubmitted: (s) => setState(() {
              if (nombresElegidos.length > 0) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text("Solo se puede buscar un nombre"),
                        actions: [
                          new FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: new Text("Ok"))
                        ],
                      );
                    });
              } else if (s != "") {
                setState(() {
                  nombresElegidos.add(s);
                });
              }
            }),
          ),
          nombresElegidos.length > 0
              ? Container(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: nombresElegidos.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 5, top: 5),
                        child: InkWell(
                          child: Chip(
                            label: Text(e),
                            avatar: Icon(Icons.remove),
                          ),
                          onTap: () {
                            setState(() {
                              nombresElegidos.remove(e);
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Container(),
          widget.objetoElegido.DB_NOMBRE != Guia.NOMBRE ? SimpleAutoCompleteTextField(
            decoration: new InputDecoration(
              icon: Icon(Icons.location_city),
              hintText: "Municipio",
            ),
            suggestions: Constantes.municipios,
            textSubmitted: (s) => setState(() {
              if (s != "") {
                municipiosElegidos.add(s);
              }
            }),
          ):Container(),
          municipiosElegidos.length > 0
              ? Container(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: municipiosElegidos.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 5, top: 5),
                        child: InkWell(
                          child: Chip(
                            label: Text(e),
                            avatar: Icon(Icons.remove),
                          ),
                          onTap: () {
                            setState(() {
                              municipiosElegidos.remove(e);
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Container(),
          SimpleAutoCompleteTextField(
            decoration: new InputDecoration(
              icon: Icon(Icons.filter_hdr),
              hintText: "Provincia",
            ),
            suggestions: Constantes.provincias,
            textSubmitted: (s) => setState(() {
              if (s != "") {
                provinciasElegidas.add(s);
              }
            }),
          ),
          provinciasElegidas.length > 0
              ? Container(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: provinciasElegidas.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 5, top: 5),
                        child: InkWell(
                          child: Chip(
                            label: Text(e),
                            avatar: Icon(Icons.remove),
                          ),
                          onTap: () {
                            setState(() {
                              provinciasElegidas.remove(e);
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Container(),
          (
              widget.objetoElegido.DB_NOMBRE == ActividadTuristica.NOMBRE ||
              widget.objetoElegido.DB_NOMBRE == Evento.NOMBRE ||
              widget.objetoElegido.DB_NOMBRE == Guia.NOMBRE ||
              widget.objetoElegido.DB_NOMBRE == Monumento.NOMBRE ||
              widget.objetoElegido.DB_NOMBRE == Museo.NOMBRE ||
              widget.objetoElegido.DB_NOMBRE == OficinaTurismo.NOMBRE ||
              widget.objetoElegido.DB_NOMBRE == TurismoActivo.NOMBRE
          ) ? Container() :
          Row(children: [
            Icon(IconsTurisCyL.wheelchair_accessibility, color: Colors.grey),
            Checkbox(
              value: pmrElegido,
              onChanged: (b) {
                setState(() {
                  pmrElegido = b;
                });
              },
            ),
          ]),
          categorias != null ? _categoria() : Container(),
          tipos != null ? _tipo() : Container(),
          tiposConstruccion != null ? _tipoConstruccion() : Container(),
          clasificaciones != null ? _clasificacion() : Container(),
          tematicas != null ? _tematica() : Container()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Filtro")),
      body: SingleChildScrollView(child: _decidirVista()),
      floatingActionButton: new FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VistaInformacion(
                          categoriaElegida: widget.objetoElegido.DB_NOMBRE,
                          consulta: _generarConsulta(),
                        )));
          }),
    );
  }
}
