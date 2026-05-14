% Copyright © 2026 Julian Joaquin
% 
% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files (the “Software”),
% to deal in the Software without restriction, including without limitation
% the rights to use, copy, modify, merge, publish, distribute, sublicense,
% and/or sell copies of the Software, and to permit persons to whom the
% Software is furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
% THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
% DEALINGS IN THE SOFTWARE.
%
% =========================================================================
%
%% Voltage-mode buck converter open-loop analysis.
%
% Uses the equations from "Voltage-mode control and compensation:
% Intricacies for buck converters."
% https://www.edn.com/voltage-mode-control-and-compensation-intricacies-for-buck-regulators/
%
% =========================================================================

%% Open loop characteristics

Vi = 50;
Vo = 5.1;
Io = 8;

% Capacitors
caps = struct;

% GRM31CC71E226ME15L
% CAP CER 22uF 25V X7S 10% 1206
%caps(1).C = 15e-6 * 6;
%caps(1).R = 3e-3 / 6;

% CL32A226KAJNNNE
% CAP CER 22uF 25V X5R 10% 1210
caps(1).C = 17.1e-6 * 6;
caps(1).R = 3e-3 / 6;

% T521D107M025ATE060
% CAP TANT 100uF 25V 20% 7343
caps(2).C = 100e-6;
caps(2).R = 16.5e-3;

% PULSE PA4342.472NLT
L = 4.7e-6;
Rdcr = 15.5e-3;

% BSZ146N10LS5
Rdson1 = 12.7e-3;
Rdson2 = 9.8e-3;
D = Vo / Vi;
Rd = Rdcr + Rdson1*D + Rdson2*(1-D);

kff = 15; % v_in/v_ramp gain

% input voltage feedforward added
Gv(1) = vmc_gvd(Vi,Vo,Io,caps,L,Rd) / (Vi / kff);

% Variation 2
Vi = 50;
Vo = 12;
caps(1).C = 8.83e-6 * 6;

% WE 7443330820
%L = 8.2e-6;
%Rdcr = 15e-3;
  
D = Vo / Vi;
Rd = Rdcr + Rdson1*D + Rdson2*(1-D);

Gv(2) = vmc_gvd(Vi,Vo,Io,caps,L,Rd) / (Vi / kff);

%% Compensation

Rfb1 = 20e3;
Rc2 = 68;
Cc3 = 1500e-12;

Rc1 = 10e3;
Cc1 = 4700e-12;
Cc2 = 68e-12;

Gc = comp_opamp3(Rfb1, Rc2, Cc3, Rc1, Cc1, Cc2);

%% Bode plot
T = Gv * Gc;

clear h
hold on

opts = bodeoptions;
opts.FreqUnits = 'Hz';
opts.XLim = {[1e2,1e7]};

for t=T
    %h = bodeplot(t,opts);
    margin(t)
end
grid on
legend('Vin 5.1V','Vin 12.0V')
hold off
