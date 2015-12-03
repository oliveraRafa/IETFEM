% =====================================================
% =============      IETFEM     =======================
% =====================================================
%
% Instituto de Estructuras y Transporte
% Finite Element Method solver
% Facultad de Ingeniería
% Universidad de la República
% Uruguay
%
% Project Leaders:
%   Pablo Castrillo Green
%   Jorge Martín Perez Zerpa
%
% Colaborators:
%   A. Spalvier
%   ARCHFEM: Mihdi Caballero / Yessica Rodriguez / Francisco Vidovich
%   anybody who would like to contribute...
%
% site:
%   
%
% Last update:  Mar-2015  v.2.11
%
% Developed for GNU-Octave 3.6.4
% View license.txt for licensing information (inside tutoriales folder).
%
% =======================================================
%
% Todos los .tex tendrán este formato.

fprintf( fidout_tex , '%sdocumentclass[a4paper,11pt]{article} \n\n','\')

fprintf( fidout_tex , '%s ===== Algunos paquetes a ser usados =====\n\n','%')

fprintf( fidout_tex , '%s para poder escribir con tildes   \n','%')
fprintf( fidout_tex , '%susepackage[T1]{fontenc}           \n','\')
fprintf( fidout_tex , '%susepackage[utf8]{inputenc}        \n','\')
fprintf( fidout_tex , '%susepackage[spanish]{babel}        \n\n','\')
fprintf( fidout_tex , '%sspanishdecimal{.}        \n','\')
fprintf( fidout_tex , '%susepackage{times}        \n\n','\')

fprintf( fidout_tex , '%susepackage{animate}        \n\n','\')

fprintf( fidout_tex , '%s fuentes para escribir símbolos \n','%')
fprintf( fidout_tex , '%susepackage{amsfonts}            \n','\')
fprintf( fidout_tex , '%susepackage{amssymb}             \n','\')
fprintf( fidout_tex , '%susepackage{amsthm}              \n','\')
fprintf( fidout_tex , '%susepackage{mathrsfs}            \n','\')
fprintf( fidout_tex , '%susepackage[centertags]{amsmath}    \n\n','\')

fprintf( fidout_tex , '%s inclusión de graficos    \n','%')
fprintf( fidout_tex , '%susepackage{graphicx}      \n\n','\')

fprintf( fidout_tex , '%s símbolo de grados    \n','%')
fprintf( fidout_tex , '%snewcommand{%sgrad}{%shspace{-2.5mm}$%s,%sphantom{a}^{%scirc}%s,$}        \n\n','\','\','\','\','\','\','\')

fprintf( fidout_tex , '%s ==================================== \n\n','%')

fprintf( fidout_tex , '%s ========= Referencias ==========           \n','%')
fprintf( fidout_tex , '%susepackage{hyperref}                        \n','\')
fprintf( fidout_tex , '%s ================================           \n\n','%')

fprintf( fidout_tex , '%s ========= Color ==========           \n','%')
fprintf( fidout_tex , '%susepackage[usenames,dvipsnames]{color}                         \n','\')
fprintf( fidout_tex , '%s ================================           \n\n','%')

fprintf( fidout_tex , '%s ===== Ajuste layout pagina =====           \n','%')
fprintf( fidout_tex , '%stextheight=23cm                            \n','\')
fprintf( fidout_tex , '%stextwidth=18cm                              \n','\')
fprintf( fidout_tex , '%stopmargin=-1cm                              \n','\')
fprintf( fidout_tex , '%soddsidemargin=-1cm                           \n','\') 
fprintf( fidout_tex , '%sparindent=0mm                               \n','\')
fprintf( fidout_tex , '%susepackage{fancyhdr}                        \n','\')
fprintf( fidout_tex , '%s ================================           \n\n','%')

fprintf( fidout_tex , '%s ========= Comandos ==========           \n','%')
fprintf( fidout_tex , '%snewcommand{%sds}{%sdisplaystyle}         \n','\','\','\')
fprintf( fidout_tex , '%sdef%sx{{%sbf x}}                         \n','\','\','\')
fprintf( fidout_tex , '%s ================================           \n\n','%')

fprintf( fidout_tex , '%s ========= Tablas y otros ==========           \n','%')
fprintf( fidout_tex , '%s%susepackage[table]{xcolor} %s Sirve para poner letras con colores y colorear tablas            \n','%','\','%')
fprintf( fidout_tex , '%saddto%scaptionsspanish{ %srenewcommand{%stablename}{Tabla}} %sUso tabla en vez de cuadro        \n','\','\','\','\','%')
fprintf( fidout_tex , '%saddto%scaptionsspanish{ %srenewcommand{%sappendixname}{Apéndice}}                               \n','\','\','\','\')
fprintf( fidout_tex , '%s%saddto%scaptionsspanish{ %srenewcommand{%sappendixpagename}{Apéndice}}                         \n','%','\','\','\','\')
fprintf( fidout_tex , '%s%saddto%scaptionsspanish{ %srenewcommand{%sappendixtocname}{Apéndice}}                          \n','%','\','\','\','\')
fprintf( fidout_tex , '%s%saddto%scaptionsspanish{ %srenewcommand{%slstlistingname}{Rutina}}                             \n','%','\','\','\','\')
fprintf( fidout_tex , '%susepackage{array}                                                                               \n','\')
fprintf( fidout_tex , '%snewcolumntype{C}[1]{>{%scentering%slet%snewline%s%s%sarraybackslash%shspace{0pt}}m{#1}}         \n','\','\','\','\','\','\','\','\')
fprintf( fidout_tex , '%snewcolumntype{L}[1]{>{%sraggedright%slet%snewline%s%s%sarraybackslash%shspace{0pt}}m{#1}}       \n','\','\','\','\','\','\','\','\')
fprintf( fidout_tex , '%snewcolumntype{R}[1]{>{%sraggedleft%slet%snewline%s%s%sarraybackslash%shspace{0pt}}m{#1}}        \n','\','\','\','\','\','\','\','\')
fprintf( fidout_tex , '%susepackage{booktabs}                                                                            \n','\')
fprintf( fidout_tex , '%susepackage{longtable}                                                                            \n','\')
fprintf( fidout_tex , '%s ================================           \n\n','%')

fprintf( fidout_tex , '%snewpage  \n\n','\')

