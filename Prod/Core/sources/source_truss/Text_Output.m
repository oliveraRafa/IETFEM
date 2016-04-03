% =====================================================
% =============      IETFEM     =======================
% ============= User Interface  =======================
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
%
% site:
%   
%
% Last update:  Sep-2015  v.0.01
%
% Developed for GNU-Octave 3.6.4
% View license.txt for licensing information (inside tutoriales folder).
%
% =======================================================
%

tiempo = reading_time + preprocess_time + process_time;
tic
cd UI_TXT
  cd Linear
    UI_txt_output
    Complete_txt_lin
    Complete_tex_lin
  cd ..
  % NO esta hecho para Finita aún
cd ..

tiempo_TEXTO = toc;

tiempo = tiempo + tiempo_TEXTO;

fprintf('\nIETFEM finalizo luego de %6.3f segundos.\n',tiempo)
