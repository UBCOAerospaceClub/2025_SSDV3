% Copyright © 2025 Julian Joaquin
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

caps(1).C = 75.0e-6;
caps(1).R = 0.6e-3;

caps(2).C = 100e-6;
caps(2).R = 18e-3;

L = 4.7e-6;
Rdcr = 15.5e-3;

Rdson1 = 14.6e-3;
Rdson2 = 14.6e-3;
D = Vo / Vi;
Rd = Rdcr + Rdson1*D + Rdson2*(1-D);

kff = 15; % v_in/v_ramp gain

Gv(1) = control_output(Vi,Vo,Io,caps,L,Rd) / (Vi / kff);

% Variation 2
Vi = 50;
Vo = 12.05;
caps(1).C = 36.8e-6;

D = Vo / Vi;
Rd = Rdcr + Rdson1*D + Rdson2*(1-D);

Gv(2) = control_output(Vi,Vo,Io,caps,L,Rd) / (Vi / kff);

%% Compensation

Rfb1 = 20e3;
Rc2 = 1000;
Cc3 = 2200e-12;

Rc1 = 6.8e3;
Cc1 = 2200e-12;
Cc2 = 100e-12;

Gc = compensator(Rfb1, Rc2, Cc3, Rc1, Cc1, Cc2);

%% Bode plot
T = Gv * Gc;

clear h
hold on

for t=T
    h = bodeplot(t);
    h.XLim = {[1e2,1e7]};
    h.FrequencyUnit = 'Hz';
end

grid on
legend('Vin 5.1V','Vin 12.0V')
hold off
