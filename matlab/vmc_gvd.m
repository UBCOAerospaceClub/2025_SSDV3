function Gvd = vmc_gvd(Vi, Vo, Io, caps, L, Rd)
% VMC_GVD  VMC Buck converter control-to-output voltage transfer function
%
%   Syntax
%       Gvd = VMC_GVD(Vi, Vo, Io, caps, L, dcr)
%
%   Input Arguments
%       Vi - Input voltage in Volts
%           scalar
%       Vo - Output voltage in Volts
%           scalar
%       Io - Output current in Amperes
%           scalar
%       caps - Output capacitor(s) in Farads and Ohms
%           1-D array structure of fields 'C', 'R'
%       L - Inductor in Henries
%           scalar
%       Rd - Series damping resistance in Ohms
%           scalar
%
%   Output Arguments
%       Gvd - Power stage transfer function
%           dynamic system model
%
%   Example Usage
%       Vi = 24;            % Volts
%       Vo = 5;             % Volts
%       Io = 2;             % Amps
%       caps = struct;
%       caps(1).C = 100e-6; % Farads
%       caps(1).R = 10e-3;  % Ohms
%       L = 4.7e-6;         % Henries
%       Rd = 10e-3;         % Ohms
%       Gvd = VMC_GVD(Vi, Vo, Io, caps, L, dcr);
%
%   See also
%       <a href="matlab:web('https://www.edn.com/voltage-mode-control-and-compensation-intricacies-for-buck-regulators/')">EDN: Voltage-mode control and compensation</a>
%       <a href="matlab:web('https://e2e.ti.com/cfs-file/__key/communityserver-discussions-components-files/188/Buck-Converter-Modeling_2C00_-Control_2C00_and-Compensator-Design.pdf')">Buck Converter Modeling, Control, and Compensator Design</a>

    Zc = 0;
    for c = caps
        Zc = Zc + 1/tf([c.C*c.R 1],[c.C 0]);
    end
    Zc = 1/Zc;
    Zl = tf([L Rd],1);
    Ro = Vo/Io;
    Gvd = (Vi*Zc*Ro) / (Zl*Zc + Zl*Ro + Zc*Ro);
end
