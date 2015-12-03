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

function dof=node2dof(nodes,Ndofpn)

Nnodes=length(nodes);
dof=[];
for i = 1 : Nnodes
    aux = [] ;
    for j = 1 : Ndofpn
        aux = [ aux ; Ndofpn * ( nodes ( i ) ) - ( Ndofpn - j ) ] ;
    end
    dof ( Ndofpn * ( i-1 )+1 : Ndofpn*i ) = aux ;
end
 
    
     
    
 
