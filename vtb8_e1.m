% example script file for BEAM
% A five element aluminum beam clamped at the left end
% with five elements.  The cross section is 5 cm square.
% No shear deformation is modeled. Density is per unit length
% (2700 kg/m^3 * .0025 m^2 = 6.75 kg/m).
% Extensional degrees of freedom are included (not zeroed).
% The force vector is zero since this is a dynamic analysis.
node=[0 0;.1 0;.2 0;.3 0;.4 0;.5 0];
ncon=[1 2 69e9 .0025 5.208e-7 0 6.75;
      2 3 69e9 .0025 5.208e-7 0 6.75;
      3 4 69e9 .0025 5.208e-7 0 6.75;
      4 5 69e9 .0025 5.208e-7 0 6.75;
      5 6 69e9 .0025 5.208e-7 0 6.75];
zero=[1 1;
      1 2;
      1 3];
conm=[];
force=[];
save('-mat','VTB8_e1.con','node','ncon','zero','force','conm')
