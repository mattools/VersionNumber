classdef VersionNumber < handle
% Simple utility to manage version number as string.
%
%   Manages version number by storing major, minor and patch numbers, as
%   well as an additional optional label given as char array.
%
%   Example
%     v = VersionNumber(1, 0, 2);
%     char(v)
%     ans =
%         '1.0.2'
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2015-07-24,    using Matlab 8.5.0.197613 (R2015a)
% Copyright 2015 INRA - BIA-BIBS.


%% Properties
properties
    % the major release number, as int
    Major;
    
    % the minor release number, as int
    Minor;
    
    % the patch number, as int
    Patch;
    
    % an optional identifier
    Label = '';
    
end % end properties


%% Constructor
methods
    function this = VersionNumber(varargin)
        % Constructor for VersionNumber class.
    
        if nargin == 1
            var1 = varargin{1};
            if ischar(var1)
                ver = VersionNumber.parse(var1);
                this.Major = ver.Major;
                this.Minor = ver.Minor;
                this.Patch = ver.Patch;
                this.Label = ver.Label;
                
            elseif isa(var1, 'VersionNumber')
                % copy constructeur
                this.Major = var1.Major;
                this.Minor = var1.Minor;
                this.Patch = var1.Patch;
                this.Label = var1.Label;
                
            else
                error('Unable to process input of class % s', classname(var1));
            end
            
        elseif nargin >= 3
            this.Major = varargin{1};
            this.Minor = varargin{2};
            this.Patch = varargin{3};
            if nargin == 4
                this.Label = varargin{4};
            end
        end
    end

end % end constructors

%% Static Methods
methods (Static)
    function ver = parse(string)
        
        % first extract ending label
        tokens = strsplit(string, {'-', '+'});
        if length(tokens) > 1
            lbl = tokens{2};
        else
            lbl = '';
        end
        
        % split the different version numbers
        tokens = strsplit(tokens{1}, '.');
        if length(tokens) > 3
            error('too many tokens in version string: %s', string);
        end
        
        % convert to numerical values
        maj = str2double(tokens{1});
        min = str2double(tokens{2});
        if length(tokens) > 2
            pat = str2double(tokens{3});
        else
            pat = 0;
        end
        
        % create version number object
        ver = VersionNumber(maj, min, pat, lbl);
    end
    
    function c = compareStrings(str1, str2)
        
        % case of one empty string
        len = min(length(str1), length(str2));
        if len == 0
            if ~isempty(str1)
                c = 1;
            else
                c = -1;
            end
            return;
        end
        
        % find indices of non equal characters
        inds = find(str1(1:len) ~= str2(1:len));
        
        % in case of no difference, compare lengths
        if isempty(inds)
            if length(str1) < length(str2)
                c = -1;
            elseif length(str1) == length(str2)
                c = 0;
            else
                c = 1;
            end
            return;
        end
        
        % compare first different character
        ind = inds(1);
        if str1(ind) < str2(ind)
            c = -1;
        else
            c = 1;
        end

    end
    
end % end methods


%% Methods
methods
    
    function b = eq(obj, other)
        if ~(isa(obj, 'VersionNumber') && isa(other, 'VersionNumber'))
            error('Both inputs must be instances of VersionNumber');
        end
         
        b1 = obj.Major == other.Major;
        b2 = obj.Minor == other.Minor;
        b3 = obj.Patch == other.Patch;
        b4 = strcmp(obj.Label, other.Label);
        b = b1 && b2 && b3 && b4;
    end
    
    function b = gt(obj, other)
        if ~(isa(obj, 'VersionNumber') && isa(other, 'VersionNumber'))
            error('Both inputs must be instances of VersionNumber');
        end
        
        if obj.Major > other.Major
            b = true;
            return;
        elseif obj.Major < other.Major
            b = false;
            return;
        end
        
        if obj.Minor > other.Minor
            b = true;
            return;
        elseif obj.Minor < other.Minor
            b = false;
            return;
        end
        
        if obj.Patch > other.Patch
            b = true;
            return;
        elseif obj.Patch < other.Patch
            b = false;
            return;
        end
        
        c = VersionNumber.compareStrings(obj.Label, other.Label);
        b = c == 1;
    end
    
    function b = ge(obj, other)
        b = gt(obj, other) || eq(obj, other);
    end
    
    function b = lt(obj, other)
        if ~(isa(obj, 'VersionNumber') && isa(other, 'VersionNumber'))
            error('Both inputs must be instances of VersionNumber');
        end
        
        if obj.Major < other.Major
            b = true;
            return;
        elseif obj.Major > other.Major
            b = false;
            return;
        end
        
        if obj.Minor < other.Minor
            b = true;
            return;
        elseif obj.Minor > other.Minor
            b = false;
            return;
        end
        
        if obj.Patch < other.Patch
            b = true;
            return;
        elseif obj.Patch > other.Patch
            b = false;
            return;
        end
        
        c = VersionNumber.compareStrings(obj.Label, other.Label);
        b = c == -1;
    end
    
    function b = le(obj, other)
        b = lt(obj, other) || eq(obj, other);
    end
    
    function str = char(obj)
        str = sprintf('%d.%d.%d', obj.Major, obj.Minor, obj.Patch);
        if ~isempty(obj.Label)
            str = [str '-' obj.Label];
        end
    end
    
end % end methods

end % end classdef

