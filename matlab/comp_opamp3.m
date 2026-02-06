function Gc = comp_opamp3(Ri1, Ri2, Ci1, Rf1, Cf1, Cf2)
% COMP_OPAMP3  Type III op amp compensator transfer function
%
%   Syntax
%       Gc = COMP_OPAMP3(Ri1, Ri2, Ci1, Rf1, Cf1, Cf2)
%
%   Input Arguments
%       Ri1 - Input impedance voltage divider resistor, in Ohms
%           scalar
%       Ri2 - Input impedance feedforward resistor, in Ohms
%           scalar
%       Ci1 - Input impedance feedforward capacitor, in Farads
%           scalar
%       Rf1 - Feedback impedance gain-zero resistor, in Ohms
%           scalar
%       Cf1 - Feedback impedance integrator capacitor, in Farads
%           scalar
%       Cf2 - Feedback impedance HF pole capacitor, in Farads
%           scalar
%           
%   Output Arguments
%       Gc - Compensation transfer function
%           dynamic system model
%
%   See also
%       <a href="matlab:web('https://ieeexplore.ieee.org/document/7373052')">Generalized Type III controller design interface for DC-DC converters</a>
%       <a href="matlab:web('https://www.ti.com/lit/an/slva662/slva662.pdf')">SLVA662 - Demystifying Type II and Type III Compensators Using Op-Amp and OTA for DC/DC Converters</a>

    Zi = Ri1*Ri2/(Ri1+Ri2) * tf([1 1/(Ri2*Ci1)],[1 1/(Ci1*(Ri1+Ri2))]);
    Zf = 1/Cf2 * tf([1 1/(Rf1*Cf1)],[1 (Cf1+Cf2)/(Cf1*Cf2*Rf1) 0]);
    Gc = Zf / Zi;
end
