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

/// Definición de las cadenas de caracteres usadas en la app
class Strings {
  // App
  static const String nombreApp = "TurisCyL";
  static const String version = "Versión 1.0.1";
  static const String explorar = "Explorar";
  static const String listas = "Listas";
  static const String nombreDb = "TurisCyL.db";
  static const String descripcionApp =
      "Descubre dónde dormir, dónde comer, qué visitar y qué hacer en Castilla y León";
  static const String copyright = "Copyright © 2020 David Población Criado";
  static const String gnu3Corto = """
Este programa es software libre: puede redistribuirlo y/o modificarlo bajo los términos de la Licencia General Pública de GNU publicada por la Free Software Foundation, ya sea la versión 3 de la Licencia, o (a su elección) cualquier versión posterior.

Este programa se distribuye con la esperanza de que sea útil pero SIN NINGUNA GARANTÍA; incluso sin la garantía implícita de MERCANTIBILIDAD o CALIFICADA PARA UN PROPÓSITO EN PARTICULAR. Vea la Licencia General Pública de GNU para más detalles.

Usted ha debido de recibir una copia de la Licencia General Pública de GNU junto con este programa. Si no, vea http://www.gnu.org/licenses/.""";

  static const String htmlCreditosImagenes = """
  <p>Todas las fotografías usadas tienen licencia Creative Commons o ninguna licencia (Unsplash):</p>
  <br>
<p>Bar: <span>Photo by <a href="https://unsplash.com/@fabienmaurin?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Fabien Maurin</a> on <a href="https://unsplash.com/s/photos/bar-terrace?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>
<p>Cafetería: <span>Photo by <a href="https://unsplash.com/@mparzuchowski?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Michał Parzuchowski</a> on <a href="https://unsplash.com/?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>
<p>Restaurante: <span>Photo by <a href="https://unsplash.com/@ninjason?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Jason Leung</a> on <a href="https://unsplash.com/?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>
<p>Salón de banquetes: <span>Photo by <a href="https://unsplash.com/@kaziiparkour?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Zakaria Zayane</a> on <a href="https://unsplash.com/@kaziiparkour?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>

<p>Albergue: <span>Photo by <a href="https://unsplash.com/@marcusloke?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Marcus Loke</a> on <a href="https://unsplash.com/s/photos/hostel?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>
<p>Hotel: <span>Photo by <a href="https://unsplash.com/@martenbjork?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Marten Bjork</a> on <a href="https://unsplash.com/?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>
<p>Apartamento: <span>Photo by <a href="https://unsplash.com/@paralitik?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Brandon Griggs</a> on <a href="https://unsplash.com/s/photos/apartment?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>
<p>Camping: <span>Photo by <a href="https://unsplash.com/@tlisbin?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Tommy Lisbin</a> on <a href="https://unsplash.com/s/photos/camping?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>
<p>Turismo Rural: <span>Photo by <a href="https://unsplash.com/@henarlanga?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Henar Langa</a> on <a href="https://unsplash.com/s/photos/castilla?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>
<p>Vivienda: <span>Photo by <a href="https://unsplash.com/@joakimaglo?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Joakim Aglo</a> on <a href="https://unsplash.com/s/photos/house-spain?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>

<p>Monumentos: Fotografía por David Población</p>
<p>Museos: Fotografía por Raúl Villalón en https://flic.kr/p/Gj5E5s</p>
<p>Archivos: Fotografía por David Población</p>

<p>Evento: Fotografía por Santiago López Pastor en https://flic.kr/p/HaWGnk</p>
<p>Actividad Turística: <span>Photo by <a href="https://unsplash.com/@zubearasyraf?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Zubair Asyraf</a> on <a href="https://unsplash.com/s/photos/turistic-activity?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>
<p>Guía: <span>Photo by <a href="https://unsplash.com/@capturethemoment?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Janis Oppliger</a> on <a href="https://unsplash.com/s/photos/tour?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>
<p>Turismo Activo: <span>Photo by <a href="https://unsplash.com/@ihsanus?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">ihsan ulusoy</a> on <a href="https://unsplash.com/s/photos/treking?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>

<p>Dónde comer: <span>Photo by <a href="https://unsplash.com/@vishkatti?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Vishwas Katti</a> on <a href="https://unsplash.com/?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>
<p>Dónde dormir: <span>Photo by <a href="https://unsplash.com/@chris_jolly?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Christopher Jolly</a> on <a href="https://unsplash.com/s/photos/bed?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>
<p>Qué ver: Fotografía por Joan en https://flic.kr/p/L9XPRm</p>
<p>Qué hacer: <span>Photo by <a href="https://unsplash.com/@icehoundphotography?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">David Murray Chambers</a> on <a href="https://unsplash.com/s/photos/canoe?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></p>
<p>Oficinas de turismo: Fotografía por Jesús Pérez Pacheco en https://flic.kr/p/9g3rHe</p>
<p>Espacios Naturales: Fotografía por willi_bremen en https://flic.kr/p/WpdYfJ</p>
  """;
  static const String htmlAyuda = """
  <h3>Pestaña explorar</h3>
  <p>Es la pestaña principal de la aplicación, donde se muestran las diferentes categorías para acceder a los lugares de interés turístico. Las categorías son:</p>
  <ul>
    <li>¿Dónde comer?: bares, restaurantes, cafeterías y salones de banquetes</li>
    <li>¿Dónde dormir?: albergues, alojamientos hoteleros, apartamentos, campings, turismo rural y vivendas de uso turístico</li>
    <li>¿Qué ver?: monumentos y museos</li>
    <li>¿Qué hacer?: eventos, actividades turísticas, guías de turismo y turismo activo</li>
    <li>Más información: oficinas de turismo</li>
    <li>Espacios Naturales: aplicación con información sobre los equipamientos de la Red de Espacios Naturales de Castilla y León</li>
  </ul>
  <p>Clicando sobre cada una de las subcategorías (bares, eventos, monumentos...) es posible acceder a la lista de los lugares de dicho subtipo, así como filtrarlos por nombre, provincia, municipio...</p>
  <p>Pinchando en uno en concreto, aparece la información sobre el mismo junto a un mapa (si está disponible) con la ubicación. El icono inferior sirve para guardarlos en listas (excepto en los eventos, que sirve para añadirlo al calendario)</p>
  
  <h3>Pestaña listas</h3>
  <p>Sirve para acceder, crear, importar o compartir listas de lugares guardados. El objetivo de estas listas es almacenar los diferentes lugares para planificar un viaje, por ejemplo</p>
  <h4>Crear/Importar lista</h4>
  <p>A través del botón '+' se abrirá un submenú, con el que podemos elegir si crear una lista o importar una ya creada anteriormente </p>
  <h5>Importar lista</h5>
  <p>Para importar una lista es necesario haberla compartido antes, lo cual generará un código similar al siguiente (formato JSON)</p>
  <code>
  {"id":"e69781ac-f8c9-4e1b-87e5-4e4e43364c88","publicada":false,"timestamp":"2020-09-11T15:21:54.475567","nombre":"Hola mundo","descripcion":"Esto es una lista de prueba :)","autor":"Anónimo","dias":-1,"provincias":"[]","elementos":"[]"}
  </code>
  <p>Para añadirla basta con pegar dicho código en el cuadro de texto que se abre</p>
  <h4>Listas públicas</h4>
  <p>Las listas públicas son aquellas creadas por otros usuarios y que han sido verificadas para su uso público.</p>
  <p>Puedes colaborar haciendo listas públicas y mandándolas a través <a href='https://forms.gle/Nooaur7qnskr8PaeA'>de este formulario</a></p>
  """;
  static const String htmlPoliticaPrivacidad = """
  <p>Los datos que se introduzcan en la aplicación, así como la creación de listas NO se envían a ningún servidor y se guardan únicamente en el dispositivo del usuario.</p>
  <p>NO se recoge ningún tipo de dato asociado al uso de la app, ni local ni remotamente.</p>
  <p>Esta aplicación obtiene datos de los servidores de la <a href='http://www.jcyl.es'>Junta de Castilla y León</a>, <a href='https://www.openstreetmap.org/'>OpenStreetMap</a> y de <a href='https://foursquare.com/'>Foursquare</a> por lo que al hacer las peticiones dichos servicios guarden cierta información del dispositivo (como la dirección IP). Se recomienda revisar las políticas de dichos servicios.</p>
  <p>Con la finalidad de proteger la privacidad de los usuarios que usan esta app no se usan los mapas de Google ni ningún otro servicio asciado a esta empresa (ni siquiera Google Play Services), aunque la aplicación se distribuye a través de Google Play</p>
  """;
  static const String htmlDatosJcyl = """
  <p>Los datos que usa esta aplicación se han extraído del portal de <a href='http://datosabiertos.jcyl.es'>datos abiertos</a> de la <a href='http://www.jcyl.es'>Junta de Castilla y León</a>. Se han utilizado los siguientes conjuntos de datos:</p>
  
  <ul>
    <li>Registro de empresas que ofrecen otras actividades turísticas</li>
    <li>Registro de albergues turísticos</li>
    <li>Registro de alojamientos hoteleros</li>
    <li>Registro de apartamentos turísticos</li>
    <li>Registro de bares</li>
    <li>Registro de cafeterías</li>
    <li>Registro de campings</li>
    <li>Relación de eventos de la agenda cultural categorizados y geolocalizados</li>
    <li>Registro de guías de turismo</li>
    <li>Relación de monumentos de Castilla y León</li>
    <li>Directorio de Museos de Castilla y León</li>
    <li>Oficinas de información turística</li>
    <li>Registro de restaurantes</li>
    <li>Registro de salones de banquetes</li>
    <li>Registro de establecimientos de turismo activo</li>
    <li>Registro de establecimientos de turismo rural</li>
    <li>Registro de viviendas de uso turístico</li>
    <li>Directorio de Archivos de Castilla y León</li>
  </ul> 
  
  <p>Los mapas usados en la aplicación se obtienen de <a href='https://www.openstreetmap.org/'>OpenStreetMap</a></p>
  <p>Las fotografías de los lugares concretos se obtienen a través de <a href='https://foursquare.com/'>Foursquare</a></p>
  
  """;
  static const String htmlGpl3 = """
  <h3 style="text-align: center;">GNU GENERAL PUBLIC LICENSE</h3>
<p style="text-align: center;">Version 3, 29 June 2007</p>

<p>Copyright &copy; 2007 Free Software Foundation, Inc.
 &lt;<a href="https://fsf.org/">https://fsf.org/</a>&gt;</p><p>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.</p>

<h3><a name="preamble"></a>Preamble</h3>

<p>The GNU General Public License is a free, copyleft license for
software and other kinds of works.</p>

<p>The licenses for most software and other practical works are designed
to take away your freedom to share and change the works.  By contrast,
the GNU General Public License is intended to guarantee your freedom to
share and change all versions of a program--to make sure it remains free
software for all its users.  We, the Free Software Foundation, use the
GNU General Public License for most of our software; it applies also to
any other work released this way by its authors.  You can apply it to
your programs, too.</p>

<p>When we speak of free software, we are referring to freedom, not
price.  Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
them if you wish), that you receive source code or can get it if you
want it, that you can change the software or use pieces of it in new
free programs, and that you know you can do these things.</p>

<p>To protect your rights, we need to prevent others from denying you
these rights or asking you to surrender the rights.  Therefore, you have
certain responsibilities if you distribute copies of the software, or if
you modify it: responsibilities to respect the freedom of others.</p>

<p>For example, if you distribute copies of such a program, whether
gratis or for a fee, you must pass on to the recipients the same
freedoms that you received.  You must make sure that they, too, receive
or can get the source code.  And you must show them these terms so they
know their rights.</p>

<p>Developers that use the GNU GPL protect your rights with two steps:
(1) assert copyright on the software, and (2) offer you this License
giving you legal permission to copy, distribute and/or modify it.</p>

<p>For the developers' and authors' protection, the GPL clearly explains
that there is no warranty for this free software.  For both users' and
authors' sake, the GPL requires that modified versions be marked as
changed, so that their problems will not be attributed erroneously to
authors of previous versions.</p>

<p>Some devices are designed to deny users access to install or run
modified versions of the software inside them, although the manufacturer
can do so.  This is fundamentally incompatible with the aim of
protecting users' freedom to change the software.  The systematic
pattern of such abuse occurs in the area of products for individuals to
use, which is precisely where it is most unacceptable.  Therefore, we
have designed this version of the GPL to prohibit the practice for those
products.  If such problems arise substantially in other domains, we
stand ready to extend this provision to those domains in future versions
of the GPL, as needed to protect the freedom of users.</p>

<p>Finally, every program is threatened constantly by software patents.
States should not allow patents to restrict development and use of
software on general-purpose computers, but in those that do, we wish to
avoid the special danger that patents applied to a free program could
make it effectively proprietary.  To prevent this, the GPL assures that
patents cannot be used to render the program non-free.</p>

<p>The precise terms and conditions for copying, distribution and
modification follow.</p>

<h3><a name="terms"></a>TERMS AND CONDITIONS</h3>

<h4><a name="section0"></a>0. Definitions.</h4>

<p>&ldquo;This License&rdquo; refers to version 3 of the GNU General Public License.</p>

<p>&ldquo;Copyright&rdquo; also means copyright-like laws that apply to other kinds of
works, such as semiconductor masks.</p>
 
<p>&ldquo;The Program&rdquo; refers to any copyrightable work licensed under this
License.  Each licensee is addressed as &ldquo;you&rdquo;.  &ldquo;Licensees&rdquo; and
&ldquo;recipients&rdquo; may be individuals or organizations.</p>

<p>To &ldquo;modify&rdquo; a work means to copy from or adapt all or part of the work
in a fashion requiring copyright permission, other than the making of an
exact copy.  The resulting work is called a &ldquo;modified version&rdquo; of the
earlier work or a work &ldquo;based on&rdquo; the earlier work.</p>

<p>A &ldquo;covered work&rdquo; means either the unmodified Program or a work based
on the Program.</p>

<p>To &ldquo;propagate&rdquo; a work means to do anything with it that, without
permission, would make you directly or secondarily liable for
infringement under applicable copyright law, except executing it on a
computer or modifying a private copy.  Propagation includes copying,
distribution (with or without modification), making available to the
public, and in some countries other activities as well.</p>

<p>To &ldquo;convey&rdquo; a work means any kind of propagation that enables other
parties to make or receive copies.  Mere interaction with a user through
a computer network, with no transfer of a copy, is not conveying.</p>

<p>An interactive user interface displays &ldquo;Appropriate Legal Notices&rdquo;
to the extent that it includes a convenient and prominently visible
feature that (1) displays an appropriate copyright notice, and (2)
tells the user that there is no warranty for the work (except to the
extent that warranties are provided), that licensees may convey the
work under this License, and how to view a copy of this License.  If
the interface presents a list of user commands or options, such as a
menu, a prominent item in the list meets this criterion.</p>

<h4><a name="section1"></a>1. Source Code.</h4>

<p>The &ldquo;source code&rdquo; for a work means the preferred form of the work
for making modifications to it.  &ldquo;Object code&rdquo; means any non-source
form of a work.</p>

<p>A &ldquo;Standard Interface&rdquo; means an interface that either is an official
standard defined by a recognized standards body, or, in the case of
interfaces specified for a particular programming language, one that
is widely used among developers working in that language.</p>

<p>The &ldquo;System Libraries&rdquo; of an executable work include anything, other
than the work as a whole, that (a) is included in the normal form of
packaging a Major Component, but which is not part of that Major
Component, and (b) serves only to enable use of the work with that
Major Component, or to implement a Standard Interface for which an
implementation is available to the public in source code form.  A
&ldquo;Major Component&rdquo;, in this context, means a major essential component
(kernel, window system, and so on) of the specific operating system
(if any) on which the executable work runs, or a compiler used to
produce the work, or an object code interpreter used to run it.</p>

<p>The &ldquo;Corresponding Source&rdquo; for a work in object code form means all
the source code needed to generate, install, and (for an executable
work) run the object code and to modify the work, including scripts to
control those activities.  However, it does not include the work's
System Libraries, or general-purpose tools or generally available free
programs which are used unmodified in performing those activities but
which are not part of the work.  For example, Corresponding Source
includes interface definition files associated with source files for
the work, and the source code for shared libraries and dynamically
linked subprograms that the work is specifically designed to require,
such as by intimate data communication or control flow between those
subprograms and other parts of the work.</p>

<p>The Corresponding Source need not include anything that users
can regenerate automatically from other parts of the Corresponding
Source.</p>

<p>The Corresponding Source for a work in source code form is that
same work.</p>

<h4><a name="section2"></a>2. Basic Permissions.</h4>

<p>All rights granted under this License are granted for the term of
copyright on the Program, and are irrevocable provided the stated
conditions are met.  This License explicitly affirms your unlimited
permission to run the unmodified Program.  The output from running a
covered work is covered by this License only if the output, given its
content, constitutes a covered work.  This License acknowledges your
rights of fair use or other equivalent, as provided by copyright law.</p>

<p>You may make, run and propagate covered works that you do not
convey, without conditions so long as your license otherwise remains
in force.  You may convey covered works to others for the sole purpose
of having them make modifications exclusively for you, or provide you
with facilities for running those works, provided that you comply with
the terms of this License in conveying all material for which you do
not control copyright.  Those thus making or running the covered works
for you must do so exclusively on your behalf, under your direction
and control, on terms that prohibit them from making any copies of
your copyrighted material outside their relationship with you.</p>

<p>Conveying under any other circumstances is permitted solely under
the conditions stated below.  Sublicensing is not allowed; section 10
makes it unnecessary.</p>

<h4><a name="section3"></a>3. Protecting Users' Legal Rights From Anti-Circumvention Law.</h4>

<p>No covered work shall be deemed part of an effective technological
measure under any applicable law fulfilling obligations under article
11 of the WIPO copyright treaty adopted on 20 December 1996, or
similar laws prohibiting or restricting circumvention of such
measures.</p>

<p>When you convey a covered work, you waive any legal power to forbid
circumvention of technological measures to the extent such circumvention
is effected by exercising rights under this License with respect to
the covered work, and you disclaim any intention to limit operation or
modification of the work as a means of enforcing, against the work's
users, your or third parties' legal rights to forbid circumvention of
technological measures.</p>

<h4><a name="section4"></a>4. Conveying Verbatim Copies.</h4>

<p>You may convey verbatim copies of the Program's source code as you
receive it, in any medium, provided that you conspicuously and
appropriately publish on each copy an appropriate copyright notice;
keep intact all notices stating that this License and any
non-permissive terms added in accord with section 7 apply to the code;
keep intact all notices of the absence of any warranty; and give all
recipients a copy of this License along with the Program.</p>

<p>You may charge any price or no price for each copy that you convey,
and you may offer support or warranty protection for a fee.</p>

<h4><a name="section5"></a>5. Conveying Modified Source Versions.</h4>

<p>You may convey a work based on the Program, or the modifications to
produce it from the Program, in the form of source code under the
terms of section 4, provided that you also meet all of these conditions:</p>

<ul>
<li>a) The work must carry prominent notices stating that you modified
    it, and giving a relevant date.</li>

<li>b) The work must carry prominent notices stating that it is
    released under this License and any conditions added under section
    7.  This requirement modifies the requirement in section 4 to
    &ldquo;keep intact all notices&rdquo;.</li>

<li>c) You must license the entire work, as a whole, under this
    License to anyone who comes into possession of a copy.  This
    License will therefore apply, along with any applicable section 7
    additional terms, to the whole of the work, and all its parts,
    regardless of how they are packaged.  This License gives no
    permission to license the work in any other way, but it does not
    invalidate such permission if you have separately received it.</li>

<li>d) If the work has interactive user interfaces, each must display
    Appropriate Legal Notices; however, if the Program has interactive
    interfaces that do not display Appropriate Legal Notices, your
    work need not make them do so.</li>
</ul>

<p>A compilation of a covered work with other separate and independent
works, which are not by their nature extensions of the covered work,
and which are not combined with it such as to form a larger program,
in or on a volume of a storage or distribution medium, is called an
&ldquo;aggregate&rdquo; if the compilation and its resulting copyright are not
used to limit the access or legal rights of the compilation's users
beyond what the individual works permit.  Inclusion of a covered work
in an aggregate does not cause this License to apply to the other
parts of the aggregate.</p>

<h4><a name="section6"></a>6. Conveying Non-Source Forms.</h4>

<p>You may convey a covered work in object code form under the terms
of sections 4 and 5, provided that you also convey the
machine-readable Corresponding Source under the terms of this License,
in one of these ways:</p>

<ul>
<li>a) Convey the object code in, or embodied in, a physical product
    (including a physical distribution medium), accompanied by the
    Corresponding Source fixed on a durable physical medium
    customarily used for software interchange.</li>

<li>b) Convey the object code in, or embodied in, a physical product
    (including a physical distribution medium), accompanied by a
    written offer, valid for at least three years and valid for as
    long as you offer spare parts or customer support for that product
    model, to give anyone who possesses the object code either (1) a
    copy of the Corresponding Source for all the software in the
    product that is covered by this License, on a durable physical
    medium customarily used for software interchange, for a price no
    more than your reasonable cost of physically performing this
    conveying of source, or (2) access to copy the
    Corresponding Source from a network server at no charge.</li>

<li>c) Convey individual copies of the object code with a copy of the
    written offer to provide the Corresponding Source.  This
    alternative is allowed only occasionally and noncommercially, and
    only if you received the object code with such an offer, in accord
    with subsection 6b.</li>

<li>d) Convey the object code by offering access from a designated
    place (gratis or for a charge), and offer equivalent access to the
    Corresponding Source in the same way through the same place at no
    further charge.  You need not require recipients to copy the
    Corresponding Source along with the object code.  If the place to
    copy the object code is a network server, the Corresponding Source
    may be on a different server (operated by you or a third party)
    that supports equivalent copying facilities, provided you maintain
    clear directions next to the object code saying where to find the
    Corresponding Source.  Regardless of what server hosts the
    Corresponding Source, you remain obligated to ensure that it is
    available for as long as needed to satisfy these requirements.</li>

<li>e) Convey the object code using peer-to-peer transmission, provided
    you inform other peers where the object code and Corresponding
    Source of the work are being offered to the general public at no
    charge under subsection 6d.</li>
</ul>

<p>A separable portion of the object code, whose source code is excluded
from the Corresponding Source as a System Library, need not be
included in conveying the object code work.</p>

<p>A &ldquo;User Product&rdquo; is either (1) a &ldquo;consumer product&rdquo;, which means any
tangible personal property which is normally used for personal, family,
or household purposes, or (2) anything designed or sold for incorporation
into a dwelling.  In determining whether a product is a consumer product,
doubtful cases shall be resolved in favor of coverage.  For a particular
product received by a particular user, &ldquo;normally used&rdquo; refers to a
typical or common use of that class of product, regardless of the status
of the particular user or of the way in which the particular user
actually uses, or expects or is expected to use, the product.  A product
is a consumer product regardless of whether the product has substantial
commercial, industrial or non-consumer uses, unless such uses represent
the only significant mode of use of the product.</p>

<p>&ldquo;Installation Information&rdquo; for a User Product means any methods,
procedures, authorization keys, or other information required to install
and execute modified versions of a covered work in that User Product from
a modified version of its Corresponding Source.  The information must
suffice to ensure that the continued functioning of the modified object
code is in no case prevented or interfered with solely because
modification has been made.</p>

<p>If you convey an object code work under this section in, or with, or
specifically for use in, a User Product, and the conveying occurs as
part of a transaction in which the right of possession and use of the
User Product is transferred to the recipient in perpetuity or for a
fixed term (regardless of how the transaction is characterized), the
Corresponding Source conveyed under this section must be accompanied
by the Installation Information.  But this requirement does not apply
if neither you nor any third party retains the ability to install
modified object code on the User Product (for example, the work has
been installed in ROM).</p>

<p>The requirement to provide Installation Information does not include a
requirement to continue to provide support service, warranty, or updates
for a work that has been modified or installed by the recipient, or for
the User Product in which it has been modified or installed.  Access to a
network may be denied when the modification itself materially and
adversely affects the operation of the network or violates the rules and
protocols for communication across the network.</p>

<p>Corresponding Source conveyed, and Installation Information provided,
in accord with this section must be in a format that is publicly
documented (and with an implementation available to the public in
source code form), and must require no special password or key for
unpacking, reading or copying.</p>

<h4><a name="section7"></a>7. Additional Terms.</h4>

<p>&ldquo;Additional permissions&rdquo; are terms that supplement the terms of this
License by making exceptions from one or more of its conditions.
Additional permissions that are applicable to the entire Program shall
be treated as though they were included in this License, to the extent
that they are valid under applicable law.  If additional permissions
apply only to part of the Program, that part may be used separately
under those permissions, but the entire Program remains governed by
this License without regard to the additional permissions.</p>

<p>When you convey a copy of a covered work, you may at your option
remove any additional permissions from that copy, or from any part of
it.  (Additional permissions may be written to require their own
removal in certain cases when you modify the work.)  You may place
additional permissions on material, added by you to a covered work,
for which you have or can give appropriate copyright permission.</p>

<p>Notwithstanding any other provision of this License, for material you
add to a covered work, you may (if authorized by the copyright holders of
that material) supplement the terms of this License with terms:</p>

<ul>
<li>a) Disclaiming warranty or limiting liability differently from the
    terms of sections 15 and 16 of this License; or</li>

<li>b) Requiring preservation of specified reasonable legal notices or
    author attributions in that material or in the Appropriate Legal
    Notices displayed by works containing it; or</li>

<li>c) Prohibiting misrepresentation of the origin of that material, or
    requiring that modified versions of such material be marked in
    reasonable ways as different from the original version; or</li>

<li>d) Limiting the use for publicity purposes of names of licensors or
    authors of the material; or</li>

<li>e) Declining to grant rights under trademark law for use of some
    trade names, trademarks, or service marks; or</li>

<li>f) Requiring indemnification of licensors and authors of that
    material by anyone who conveys the material (or modified versions of
    it) with contractual assumptions of liability to the recipient, for
    any liability that these contractual assumptions directly impose on
    those licensors and authors.</li>
</ul>

<p>All other non-permissive additional terms are considered &ldquo;further
restrictions&rdquo; within the meaning of section 10.  If the Program as you
received it, or any part of it, contains a notice stating that it is
governed by this License along with a term that is a further
restriction, you may remove that term.  If a license document contains
a further restriction but permits relicensing or conveying under this
License, you may add to a covered work material governed by the terms
of that license document, provided that the further restriction does
not survive such relicensing or conveying.</p>

<p>If you add terms to a covered work in accord with this section, you
must place, in the relevant source files, a statement of the
additional terms that apply to those files, or a notice indicating
where to find the applicable terms.</p>

<p>Additional terms, permissive or non-permissive, may be stated in the
form of a separately written license, or stated as exceptions;
the above requirements apply either way.</p>

<h4><a name="section8"></a>8. Termination.</h4>

<p>You may not propagate or modify a covered work except as expressly
provided under this License.  Any attempt otherwise to propagate or
modify it is void, and will automatically terminate your rights under
this License (including any patent licenses granted under the third
paragraph of section 11).</p>

<p>However, if you cease all violation of this License, then your
license from a particular copyright holder is reinstated (a)
provisionally, unless and until the copyright holder explicitly and
finally terminates your license, and (b) permanently, if the copyright
holder fails to notify you of the violation by some reasonable means
prior to 60 days after the cessation.</p>

<p>Moreover, your license from a particular copyright holder is
reinstated permanently if the copyright holder notifies you of the
violation by some reasonable means, this is the first time you have
received notice of violation of this License (for any work) from that
copyright holder, and you cure the violation prior to 30 days after
your receipt of the notice.</p>

<p>Termination of your rights under this section does not terminate the
licenses of parties who have received copies or rights from you under
this License.  If your rights have been terminated and not permanently
reinstated, you do not qualify to receive new licenses for the same
material under section 10.</p>

<h4><a name="section9"></a>9. Acceptance Not Required for Having Copies.</h4>

<p>You are not required to accept this License in order to receive or
run a copy of the Program.  Ancillary propagation of a covered work
occurring solely as a consequence of using peer-to-peer transmission
to receive a copy likewise does not require acceptance.  However,
nothing other than this License grants you permission to propagate or
modify any covered work.  These actions infringe copyright if you do
not accept this License.  Therefore, by modifying or propagating a
covered work, you indicate your acceptance of this License to do so.</p>

<h4><a name="section10"></a>10. Automatic Licensing of Downstream Recipients.</h4>

<p>Each time you convey a covered work, the recipient automatically
receives a license from the original licensors, to run, modify and
propagate that work, subject to this License.  You are not responsible
for enforcing compliance by third parties with this License.</p>

<p>An &ldquo;entity transaction&rdquo; is a transaction transferring control of an
organization, or substantially all assets of one, or subdividing an
organization, or merging organizations.  If propagation of a covered
work results from an entity transaction, each party to that
transaction who receives a copy of the work also receives whatever
licenses to the work the party's predecessor in interest had or could
give under the previous paragraph, plus a right to possession of the
Corresponding Source of the work from the predecessor in interest, if
the predecessor has it or can get it with reasonable efforts.</p>

<p>You may not impose any further restrictions on the exercise of the
rights granted or affirmed under this License.  For example, you may
not impose a license fee, royalty, or other charge for exercise of
rights granted under this License, and you may not initiate litigation
(including a cross-claim or counterclaim in a lawsuit) alleging that
any patent claim is infringed by making, using, selling, offering for
sale, or importing the Program or any portion of it.</p>

<h4><a name="section11"></a>11. Patents.</h4>

<p>A &ldquo;contributor&rdquo; is a copyright holder who authorizes use under this
License of the Program or a work on which the Program is based.  The
work thus licensed is called the contributor's &ldquo;contributor version&rdquo;.</p>

<p>A contributor's &ldquo;essential patent claims&rdquo; are all patent claims
owned or controlled by the contributor, whether already acquired or
hereafter acquired, that would be infringed by some manner, permitted
by this License, of making, using, or selling its contributor version,
but do not include claims that would be infringed only as a
consequence of further modification of the contributor version.  For
purposes of this definition, &ldquo;control&rdquo; includes the right to grant
patent sublicenses in a manner consistent with the requirements of
this License.</p>

<p>Each contributor grants you a non-exclusive, worldwide, royalty-free
patent license under the contributor's essential patent claims, to
make, use, sell, offer for sale, import and otherwise run, modify and
propagate the contents of its contributor version.</p>

<p>In the following three paragraphs, a &ldquo;patent license&rdquo; is any express
agreement or commitment, however denominated, not to enforce a patent
(such as an express permission to practice a patent or covenant not to
sue for patent infringement).  To &ldquo;grant&rdquo; such a patent license to a
party means to make such an agreement or commitment not to enforce a
patent against the party.</p>

<p>If you convey a covered work, knowingly relying on a patent license,
and the Corresponding Source of the work is not available for anyone
to copy, free of charge and under the terms of this License, through a
publicly available network server or other readily accessible means,
then you must either (1) cause the Corresponding Source to be so
available, or (2) arrange to deprive yourself of the benefit of the
patent license for this particular work, or (3) arrange, in a manner
consistent with the requirements of this License, to extend the patent
license to downstream recipients.  &ldquo;Knowingly relying&rdquo; means you have
actual knowledge that, but for the patent license, your conveying the
covered work in a country, or your recipient's use of the covered work
in a country, would infringe one or more identifiable patents in that
country that you have reason to believe are valid.</p>
  
<p>If, pursuant to or in connection with a single transaction or
arrangement, you convey, or propagate by procuring conveyance of, a
covered work, and grant a patent license to some of the parties
receiving the covered work authorizing them to use, propagate, modify
or convey a specific copy of the covered work, then the patent license
you grant is automatically extended to all recipients of the covered
work and works based on it.</p>

<p>A patent license is &ldquo;discriminatory&rdquo; if it does not include within
the scope of its coverage, prohibits the exercise of, or is
conditioned on the non-exercise of one or more of the rights that are
specifically granted under this License.  You may not convey a covered
work if you are a party to an arrangement with a third party that is
in the business of distributing software, under which you make payment
to the third party based on the extent of your activity of conveying
the work, and under which the third party grants, to any of the
parties who would receive the covered work from you, a discriminatory
patent license (a) in connection with copies of the covered work
conveyed by you (or copies made from those copies), or (b) primarily
for and in connection with specific products or compilations that
contain the covered work, unless you entered into that arrangement,
or that patent license was granted, prior to 28 March 2007.</p>

<p>Nothing in this License shall be construed as excluding or limiting
any implied license or other defenses to infringement that may
otherwise be available to you under applicable patent law.</p>

<h4><a name="section12"></a>12. No Surrender of Others' Freedom.</h4>

<p>If conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License.  If you cannot convey a
covered work so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you may
not convey it at all.  For example, if you agree to terms that obligate you
to collect a royalty for further conveying from those to whom you convey
the Program, the only way you could satisfy both those terms and this
License would be to refrain entirely from conveying the Program.</p>

<h4><a name="section13"></a>13. Use with the GNU Affero General Public License.</h4>

<p>Notwithstanding any other provision of this License, you have
permission to link or combine any covered work with a work licensed
under version 3 of the GNU Affero General Public License into a single
combined work, and to convey the resulting work.  The terms of this
License will continue to apply to the part which is the covered work,
but the special requirements of the GNU Affero General Public License,
section 13, concerning interaction through a network will apply to the
combination as such.</p>

<h4><a name="section14"></a>14. Revised Versions of this License.</h4>

<p>The Free Software Foundation may publish revised and/or new versions of
the GNU General Public License from time to time.  Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.</p>

<p>Each version is given a distinguishing version number.  If the
Program specifies that a certain numbered version of the GNU General
Public License &ldquo;or any later version&rdquo; applies to it, you have the
option of following the terms and conditions either of that numbered
version or of any later version published by the Free Software
Foundation.  If the Program does not specify a version number of the
GNU General Public License, you may choose any version ever published
by the Free Software Foundation.</p>

<p>If the Program specifies that a proxy can decide which future
versions of the GNU General Public License can be used, that proxy's
public statement of acceptance of a version permanently authorizes you
to choose that version for the Program.</p>

<p>Later license versions may give you additional or different
permissions.  However, no additional obligations are imposed on any
author or copyright holder as a result of your choosing to follow a
later version.</p>

<h4><a name="section15"></a>15. Disclaimer of Warranty.</h4>

<p>THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM &ldquo;AS IS&rdquo; WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
ALL NECESSARY SERVICING, REPAIR OR CORRECTION.</p>

<h4><a name="section16"></a>16. Limitation of Liability.</h4>

<p>IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.</p>

<h4><a name="section17"></a>17. Interpretation of Sections 15 and 16.</h4>

<p>If the disclaimer of warranty and limitation of liability provided
above cannot be given local legal effect according to their terms,
reviewing courts shall apply local law that most closely approximates
an absolute waiver of all civil liability in connection with the
Program, unless a warranty or assumption of liability accompanies a
copy of the Program in return for a fee.</p>

<p>END OF TERMS AND CONDITIONS</p>

<h3><a name="howto"></a>How to Apply These Terms to Your New Programs</h3>

<p>If you develop a new program, and you want it to be of the greatest
possible use to the public, the best way to achieve this is to make it
free software which everyone can redistribute and change under these terms.</p>

<p>To do so, attach the following notices to the program.  It is safest
to attach them to the start of each source file to most effectively
state the exclusion of warranty; and each file should have at least
the &ldquo;copyright&rdquo; line and a pointer to where the full notice is found.</p>

<pre>    &lt;one line to give the program's name and a brief idea of what it does.&gt;
    Copyright (C) &lt;year&gt;  &lt;name of author&gt;

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see &lt;https://www.gnu.org/licenses/&gt;.
</pre>

<p>Also add information on how to contact you by electronic and paper mail.</p>

<p>If the program does terminal interaction, make it output a short
notice like this when it starts in an interactive mode:</p>

<pre>    &lt;program&gt;  Copyright (C) &lt;year&gt;  &lt;name of author&gt;
    This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
    This is free software, and you are welcome to redistribute it
    under certain conditions; type `show c' for details.
</pre>

<p>The hypothetical commands `show w' and `show c' should show the appropriate
parts of the General Public License.  Of course, your program's commands
might be different; for a GUI interface, you would use an &ldquo;about box&rdquo;.</p>

<p>You should also get your employer (if you work as a programmer) or school,
if any, to sign a &ldquo;copyright disclaimer&rdquo; for the program, if necessary.
For more information on this, and how to apply and follow the GNU GPL, see
&lt;<a href="https://www.gnu.org/licenses/">https://www.gnu.org/licenses/</a>&gt;.</p>

<p>The GNU General Public License does not permit incorporating your program
into proprietary programs.  If your program is a subroutine library, you
may consider it more useful to permit linking proprietary applications with
the library.  If this is what you want to do, use the GNU Lesser General
Public License instead of this License.  But first, please read
&lt;<a href="https://www.gnu.org/licenses/why-not-lgpl.html">https://www.gnu.org/licenses/why-not-lgpl.html</a>&gt;.</p>
  """;
  static const String htmlBibliotecas = """
<h3>add_2_calendar</h3>
<p>MIT License</p>
<p>Copyright (c) 2018 Javi Hurtado</p>
<p>Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the &quot;Software&quot;), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.</p>

<h3>android_intent</h3>
<p>Copyright 2017 The Chromium Authors. All rights reserved.</p>
<p>Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:</p>
<pre><code>* Redistributions <span class="hljs-keyword">of</span> source code must retain <span class="hljs-keyword">the</span> above copyright
  notice, this list <span class="hljs-keyword">of</span> conditions <span class="hljs-keyword">and</span> <span class="hljs-keyword">the</span> following disclaimer.
* Redistributions <span class="hljs-keyword">in</span> binary form must reproduce <span class="hljs-keyword">the</span> above
  copyright notice, this list <span class="hljs-keyword">of</span> conditions <span class="hljs-keyword">and</span> <span class="hljs-keyword">the</span> following
  disclaimer <span class="hljs-keyword">in</span> <span class="hljs-keyword">the</span> documentation <span class="hljs-keyword">and</span>/<span class="hljs-keyword">or</span> other materials provided
  <span class="hljs-keyword">with</span> <span class="hljs-keyword">the</span> distribution.
* Neither <span class="hljs-keyword">the</span> name <span class="hljs-keyword">of</span> Google Inc. nor <span class="hljs-keyword">the</span> names <span class="hljs-keyword">of</span> its
  contributors may be used <span class="hljs-built_in">to</span> endorse <span class="hljs-keyword">or</span> promote products derived
  <span class="hljs-built_in">from</span> this software <span class="hljs-keyword">without</span> specific prior written permission.
</code></pre><p>THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS &quot;AS IS&quot; AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p>

<h3>autocomplete_textfield</h3>
<p>Copyright <2018> &lt;@Felix McCuaig&gt;</p>
<p>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the &quot;Software&quot;), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.</p>

<h3>carousel_slider</h3>
<p>MIT License</p>
<p>Copyright (c) 2017 serenader</p>
<p>Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the &quot;Software&quot;), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.</p>

<h3>clipboard</h3>
<p>Copyright 2020, the Clipboard project authors. All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:</p>
<pre><code>* Redistributions <span class="hljs-keyword">of</span> source code must retain <span class="hljs-keyword">the</span> above copyright
  notice, this list <span class="hljs-keyword">of</span> conditions <span class="hljs-keyword">and</span> <span class="hljs-keyword">the</span> following disclaimer.
* Redistributions <span class="hljs-keyword">in</span> binary form must reproduce <span class="hljs-keyword">the</span> above
  copyright notice, this list <span class="hljs-keyword">of</span> conditions <span class="hljs-keyword">and</span> <span class="hljs-keyword">the</span> following
  disclaimer <span class="hljs-keyword">in</span> <span class="hljs-keyword">the</span> documentation <span class="hljs-keyword">and</span>/<span class="hljs-keyword">or</span> other materials provided
  <span class="hljs-keyword">with</span> <span class="hljs-keyword">the</span> distribution.
* That <span class="hljs-keyword">the</span> names <span class="hljs-keyword">of</span> its contributors may <span class="hljs-keyword">not</span> be used <span class="hljs-built_in">to</span> endorse <span class="hljs-keyword">or</span> promote
  products derived <span class="hljs-built_in">from</span> this software <span class="hljs-keyword">without</span> specific prior
  written permission.
</code></pre><p>THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
&quot;AS IS&quot; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p>

<h3>csv</h3>
<p>The MIT License (MIT)</p>
<p>Copyright (c) 2014 Christian Loitsch</p>
<p>Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the &quot;Software&quot;), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.</p>

<h3>data_connection_checker</h3>
<p>MIT</p>
<p>Copyright 2019 Kristiyan Mitev and [Spirit Navigator][spiritnavigator]</p>
<p>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the &quot;Software&quot;), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.</p>

<h3>flutter_html</h3>
<p>MIT License</p>
<p>Copyright (c) 2019 Matthew Whitaker</p>
<p>Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the &quot;Software&quot;), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.</p>

<h3>flutter_map</h3>
<p>Copyright (c) 2020, the flutter_map authors
Copyright (c) 2010-2019, Vladimir Agafonkin
Copyright (c) 2010-2011, CloudMade
All rights reserved.</p>
<p>Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:</p>
<ul>
<li><p>Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.</p>
</li>
<li><p>Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.</p>
</li>
<li><p>Neither the name of the copyright holder nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.</p>
</li>
</ul>
<p>THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS &quot;AS IS&quot;
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p>

<h3>flutter_map_marker_popup</h3>
<p>Copyright (c) 2020, Rory Stephenson
All rights reserved.</p>
<p>Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:</p>
<ul>
<li><p>Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.</p>
</li>
<li><p>Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.</p>
</li>
<li><p>Neither the name of the copyright holder nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.</p>
</li>
</ul>
<p>THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS &quot;AS IS&quot;
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p>

<h3>flutter_speed_dialog</h3>
<p>The MIT License (MIT)
Copyright (c) 2018 Dario Ielardi</p>
<p>Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the &quot;Software&quot;), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
USE OR OTHER DEALINGS IN THE SOFTWARE.</p>

<h3>foursquare</h3>
<p>MIT License</p>
<p>Copyright (c) 2019 Matthew Huie</p>
<p>Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the &quot;Software&quot;), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.</p>

<h3>geolocator</h3>
<p>MIT License</p>
<p>Copyright (c) 2018 Baseflow</p>
<p>Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the &quot;Software&quot;), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.</p>

<h3>http</h3>
<p>Copyright 2014, the Dart project authors. All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:</p>
<pre><code>* Redistributions <span class="hljs-keyword">of</span> source code must retain <span class="hljs-keyword">the</span> above copyright
  notice, this list <span class="hljs-keyword">of</span> conditions <span class="hljs-keyword">and</span> <span class="hljs-keyword">the</span> following disclaimer.
* Redistributions <span class="hljs-keyword">in</span> binary form must reproduce <span class="hljs-keyword">the</span> above
  copyright notice, this list <span class="hljs-keyword">of</span> conditions <span class="hljs-keyword">and</span> <span class="hljs-keyword">the</span> following
  disclaimer <span class="hljs-keyword">in</span> <span class="hljs-keyword">the</span> documentation <span class="hljs-keyword">and</span>/<span class="hljs-keyword">or</span> other materials provided
  <span class="hljs-keyword">with</span> <span class="hljs-keyword">the</span> distribution.
* Neither <span class="hljs-keyword">the</span> name <span class="hljs-keyword">of</span> Google Inc. nor <span class="hljs-keyword">the</span> names <span class="hljs-keyword">of</span> its
  contributors may be used <span class="hljs-built_in">to</span> endorse <span class="hljs-keyword">or</span> promote products derived
  <span class="hljs-built_in">from</span> this software <span class="hljs-keyword">without</span> specific prior written permission.
</code></pre><p>THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
&quot;AS IS&quot; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p>

<h3>introduction_screen</h3>
<p>MIT License</p>
<p>Copyright (c) 2019 Jean-Charles Moussé</p>
<p>Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the &quot;Software&quot;), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.</p>

<h3>latlong</h3>
<p>Copyright 2015 Michael Mitterer (office@mikemitterer.at),
IT-Consulting and Development Limited, Austrian Branch</p>
<p>Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
you may not use this file except in compliance with the License.
You may obtain a copy of the License at</p>
<p>   <a href="http://www.apache.org/licenses/LICENSE-2.0">http://www.apache.org/licenses/LICENSE-2.0</a></p>
<p>Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
&quot;AS IS&quot; BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
either express or implied. See the License for the specific language
governing permissions and limitations under the License.</p>

<h3>path</h3>
<p>Copyright 2014, the Dart project authors. All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:</p>
<pre><code>* Redistributions <span class="hljs-keyword">of</span> source code must retain <span class="hljs-keyword">the</span> above copyright
  notice, this list <span class="hljs-keyword">of</span> conditions <span class="hljs-keyword">and</span> <span class="hljs-keyword">the</span> following disclaimer.
* Redistributions <span class="hljs-keyword">in</span> binary form must reproduce <span class="hljs-keyword">the</span> above
  copyright notice, this list <span class="hljs-keyword">of</span> conditions <span class="hljs-keyword">and</span> <span class="hljs-keyword">the</span> following
  disclaimer <span class="hljs-keyword">in</span> <span class="hljs-keyword">the</span> documentation <span class="hljs-keyword">and</span>/<span class="hljs-keyword">or</span> other materials provided
  <span class="hljs-keyword">with</span> <span class="hljs-keyword">the</span> distribution.
* Neither <span class="hljs-keyword">the</span> name <span class="hljs-keyword">of</span> Google Inc. nor <span class="hljs-keyword">the</span> names <span class="hljs-keyword">of</span> its
  contributors may be used <span class="hljs-built_in">to</span> endorse <span class="hljs-keyword">or</span> promote products derived
  <span class="hljs-built_in">from</span> this software <span class="hljs-keyword">without</span> specific prior written permission.
</code></pre><p>THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
&quot;AS IS&quot; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p>

<h3>share</h3>
<p>Copyright 2017, the Flutter project authors. All rights reserved.</p>
<p>Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:</p>
<pre><code>* Redistributions <span class="hljs-keyword">of</span> source code must retain <span class="hljs-keyword">the</span> above copyright
  notice, this list <span class="hljs-keyword">of</span> conditions <span class="hljs-keyword">and</span> <span class="hljs-keyword">the</span> following disclaimer.
* Redistributions <span class="hljs-keyword">in</span> binary form must reproduce <span class="hljs-keyword">the</span> above
  copyright notice, this list <span class="hljs-keyword">of</span> conditions <span class="hljs-keyword">and</span> <span class="hljs-keyword">the</span> following
  disclaimer <span class="hljs-keyword">in</span> <span class="hljs-keyword">the</span> documentation <span class="hljs-keyword">and</span>/<span class="hljs-keyword">or</span> other materials provided
  <span class="hljs-keyword">with</span> <span class="hljs-keyword">the</span> distribution.
* Neither <span class="hljs-keyword">the</span> name <span class="hljs-keyword">of</span> Google Inc. nor <span class="hljs-keyword">the</span> names <span class="hljs-keyword">of</span> its
  contributors may be used <span class="hljs-built_in">to</span> endorse <span class="hljs-keyword">or</span> promote products derived
  <span class="hljs-built_in">from</span> this software <span class="hljs-keyword">without</span> specific prior written permission.
</code></pre><p>THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS &quot;AS IS&quot; AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p>

<h3>shared_preferences</h3>
<p>Copyright 2017 The Chromium Authors. All rights reserved.</p>
<p>Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:</p>
<pre><code>* Redistributions <span class="hljs-keyword">of</span> source code must retain <span class="hljs-keyword">the</span> above copyright
  notice, this list <span class="hljs-keyword">of</span> conditions <span class="hljs-keyword">and</span> <span class="hljs-keyword">the</span> following disclaimer.
* Redistributions <span class="hljs-keyword">in</span> binary form must reproduce <span class="hljs-keyword">the</span> above
  copyright notice, this list <span class="hljs-keyword">of</span> conditions <span class="hljs-keyword">and</span> <span class="hljs-keyword">the</span> following
  disclaimer <span class="hljs-keyword">in</span> <span class="hljs-keyword">the</span> documentation <span class="hljs-keyword">and</span>/<span class="hljs-keyword">or</span> other materials provided
  <span class="hljs-keyword">with</span> <span class="hljs-keyword">the</span> distribution.
* Neither <span class="hljs-keyword">the</span> name <span class="hljs-keyword">of</span> Google Inc. nor <span class="hljs-keyword">the</span> names <span class="hljs-keyword">of</span> its
  contributors may be used <span class="hljs-built_in">to</span> endorse <span class="hljs-keyword">or</span> promote products derived
  <span class="hljs-built_in">from</span> this software <span class="hljs-keyword">without</span> specific prior written permission.
</code></pre><p>THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS &quot;AS IS&quot; AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p>

<h3>sqflite</h3>
<p>Copyright (c) 2017, Alexandre Roux Tekartik.</p>
<p>Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the &quot;Software&quot;), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.</p>

<h3>toast</h3>
<p>MIT License</p>
<p>Copyright (c) 2018 YM</p>
<p>Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the &quot;Software&quot;), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.</p>

<h3>url_launcher</h3>
<p>Copyright 2017 The Chromium Authors. All rights reserved.</p>
<p>Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:</p>
<pre><code>* Redistributions <span class="hljs-keyword">of</span> source code must retain <span class="hljs-keyword">the</span> above copyright
  notice, this list <span class="hljs-keyword">of</span> conditions <span class="hljs-keyword">and</span> <span class="hljs-keyword">the</span> following disclaimer.
* Redistributions <span class="hljs-keyword">in</span> binary form must reproduce <span class="hljs-keyword">the</span> above
  copyright notice, this list <span class="hljs-keyword">of</span> conditions <span class="hljs-keyword">and</span> <span class="hljs-keyword">the</span> following
  disclaimer <span class="hljs-keyword">in</span> <span class="hljs-keyword">the</span> documentation <span class="hljs-keyword">and</span>/<span class="hljs-keyword">or</span> other materials provided
  <span class="hljs-keyword">with</span> <span class="hljs-keyword">the</span> distribution.
* Neither <span class="hljs-keyword">the</span> name <span class="hljs-keyword">of</span> Google Inc. nor <span class="hljs-keyword">the</span> names <span class="hljs-keyword">of</span> its
  contributors may be used <span class="hljs-built_in">to</span> endorse <span class="hljs-keyword">or</span> promote products derived
  <span class="hljs-built_in">from</span> this software <span class="hljs-keyword">without</span> specific prior written permission.
</code></pre><p>THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS &quot;AS IS&quot; AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p>

<h3>uuid</h3>
<p>Copyright (c) 2012 Yulian Kuncheff</p>
<p>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the &quot;Software&quot;), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.</p>

  """;

  // Tab Explorar
  static const String dondeComer = "¿Dónde comer?";
  static const String dondeDormir = "¿Dónde dormir?";
  static const String queVer = "¿Qué ver?";
  static const String queHacer = "¿Qué hacer?";
  static const String masInfo = "Oficinas de turismo";
  static const String espaciosNaturales = "Espacios Naturales";

  // Listas
  static const String crearLista = "Crear lista";
  static const String nombre = "Nombre";
  static const String nombreVacio = "Introduzca el nombre de la lista";
  static const String autor = "Autor";
  static const String anonimo = "Anónimo";
  static const String advertenciaAnonimo =
      "Si no introduce el nombre del autor figurará como 'Anónimo'";
  static const String descripcion = "Descripción";
  static const String numeroDias = "Número de días";

  // Filtro
  static const String filtro = "Filtro";
  static const String infoFiltros =
      "Añade un filtro para concretar las búsquedas. Recuerda que se tienen que cumplir todas las condiciones que introduzcas";
  static const String categoria = "Categoría";
  static const String categoriasDisponibles = "Categorías disponibles";
  static const String tipo = "Tipo";
  static const String tiposDisponibles = "Tipos disponibles";
  static const String tipoConstruccion = "Tipo de construcción";
  static const String clasificacion = "Clasificación";
  static const String clasificacionesDisponibles =
      "Clasificaciones disponibles";
  static const String tematica = "Temática";
  static const String tematicasDisponibles = "Temáticas disponibles";
  static const String buscarSolo1Nombre = "Solo se puede buscar un nombre";
  static const String ok = "Ok";
  static const String municipio = "Municipio";
  static const String provincia = "Provincia";

  // Main
  static const String ayuda = "Ayuda";
  static const String acercaDe = "Acerca de";
  static const String actualizandoDatos =
      "Actualizando los datos en segundo plano...";
  static const String importar = "Importar";
  static const String publicas = "Públicas";
  static const String nuevaLista = "Nueva lista";

  // Utils
  static const String noInternet = "No hay conexión a Internet";
  static const String cargandoDatos = "Cargando datos...";

  // Acerca de
  static const String gnuGplv3 = "GNU GPL v3";
  static const String licenciaApp = "Licencia de la app";
  static const String sobreDatos = "Sobre los datos";
  static const String politicaPrivacidad = "Política de privacidad";
  static const String bibliotecasAbiertas = "Bibliotecas de código abierto";
  static const String creditosFotos = "Créditos de las fotografías";
  static const String verGithub = "Ver en GitHub";

  // Bienvenida
  static const String interactue = "Interactúe";
  static const String bienvenida1 =
      "Descubre dónde dormir, dónde comer, qué visitar y qué hacer en Castilla y León";
  static const String bienvenida2 =
      "Guarde los lugares que desee en listas para organizar tu estancia en la comunidad";
  static const String bienvenida3 =
      "Comparte tus listas con otros usuarios y/o descubre listas públicas";
  static const String bienvenida4 =
      "Continuando entendemos que entiende y acepta la política de privacidad y la licencia de la app (GNU GPL v3)";
  static const String saltar = "Saltar";
  static const String hecho = "Hecho";

  // Importar
  static const String pegaDatosImportar =
      "Pega en el cuadro inferior los datos a importar";
  static const String listaAnadida = "Lista añadida";

  // Información
  static const String errorDb =
      "Se ha producido un error con la base de datos, inténtelo de nuevo por favor";

  // Lista (Vista)
  static const String exportar = "Exportar";
  static const String eliminar = "Eliminar";
  static const String copiadoPortapapeles = "Copiado en el portapapeles";
  static const String soloGpsDisponible =
      "Solo se muestran en el mapa los lugares con GPS disponibles";

  // Listas públicas
  static const String listasPublicas = "Listas públicas";

  // Detalles
  static const String abrirEn = "Abrir en";
  static const String comoLlegar = "Cómo llegar";
  static const String compartir = "Compartir";
  static const String streetView = "StreetView";
  static const String elegirLista = "Elegir lista";
  static const String anadidoALista = "Añadido a la lista";
  static const String ubicacionNoReal =
      "Es posible que la ubicación mostrada no se corresponda con la real";
  static const String pmr = "Accesibilidad PMR";
  static const String direccion = "Dirección";
  static const String telefonos = "Teléfono(s)";
  static const String web = "Página web";
  static const String noDefinido = "No definido";
  static const String si = "Sí";
  static const String no = "No";
  static const String especialidades = "Especialidades";
  static const String numeroRegistro = "Número registro";
  static const String cp = "Código postal";
  static const String email = "E-mail";
  static const String plazas = "Plazas";
  static const String posadaReal = "Posada real";
  static const String idBic = "ID BIC";
  static const String tipoMonumento = "Tipo Monumento";
  static const String horariosTarifas = "Horarios y Tarifas";
  static const String localidad = "Localidad";
  static const String telefono = "Teléfono";
  static const String infoAdicional = "Información adicional";
  static const String enlaceContenido = "Enlace al contenido";
  static const String datosPersonales = "Datos personales";
  static const String noDisponible = "No disponible";
  static const String codigo = "Código";
  static const String horarioApertura = "Horario de apertura";
  static const String serviciosDisponibles = "Servicios disponibles";
  static const String requisitosEspecificos =
      "Requisitos específicos para el acceso";
  static const String lugarCelebracion = "Lugar de celebración";
  static const String fechaInicio = "Fecha inicio";
  static const String fechaFin = "Fecha fin";
  static const String precio = "Precio";
  static const String destinatarios = "Destinatarios";
  static const String idiomas = "Idiomas";
  static const String numeroGuia = "Número guía";
  static const String ambito = "Ámbito";
}