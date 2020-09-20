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
import 'package:introduction_screen/introduction_screen.dart';
import 'package:turiscyl/values/strings.dart';
import 'package:turiscyl/view_html.dart';

/// Vista de bienvenida, se ejecuta en la primera ejecución de la aplicación y
/// sirve para orientar superficialmente al usuario sobre las características de
/// la app
class VistaBienvenida extends StatefulWidget {
  @override
  _VistaBienvenidaState createState() => _VistaBienvenidaState();
}

class _VistaBienvenidaState extends State<VistaBienvenida> {
  static const TextStyle _bodyStyle =
      TextStyle(fontSize: 19.0, color: Colors.white);
  static const PageDecoration _pageDecoration = const PageDecoration(
    titleTextStyle: TextStyle(
        fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.white),
    bodyTextStyle: _bodyStyle,
    descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    pageColor: Color(0xFFC62828),
    imagePadding: EdgeInsets.zero,
  );

  /// Devuelve una imagen alieneada en el centro según el [assetName] dado
  Widget _buildImage(String assetName) {
    return Align(
      child:
          Image.asset('assets/images/bienvenida/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: Strings.explorar,
          body: Strings.bienvenida1,
          image: _buildImage('1'),
          decoration: _pageDecoration,
        ),
        PageViewModel(
          title: Strings.listas,
          body: Strings.bienvenida2,
          image: _buildImage('2'),
          decoration: _pageDecoration,
        ),
        PageViewModel(
          title: Strings.interactue,
          body: Strings.bienvenida3,
          image: _buildImage('3'),
          decoration: _pageDecoration,
        ),
        PageViewModel(
          title: Strings.politicaPrivacidad,
          body: Strings.bienvenida4,
          image: _buildImage('4'),
          footer: Column(
            children: [
              RaisedButton(
                  child: Text(Strings.politicaPrivacidad),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VistaHtml(
                                    titulo: Strings.politicaPrivacidad,
                                    html: Strings.htmlPoliticaPrivacidad)));
                  }),
              RaisedButton(
                  child: Text(Strings.licenciaApp),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VistaHtml(
                                    titulo: Strings.gnuGplv3,
                                    html: Strings.htmlGpl3)));
                  })
            ],
          ),
          //image: _buildImage('img1'),
          decoration: _pageDecoration,
        )
      ],
      onDone: () => Navigator.of(context).pop(),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text(
        Strings.saltar,
        style: TextStyle(color: Colors.white),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
      done: const Text(Strings.hecho,
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.white,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
