# VersionNumber
Simple utility to manage version number as string.

Manages version number by storing major, minor and patch numbers, as
well as an additional optional label given as char array.

Example:

    % Create version number
    v = VersionNumber(1, 0, 2);
    % Display it in a readable form
    char(v)
    ans =
        '1.0.2'
    
    % Another example with a label
    v2 = VersionNumber(1, 2, 0, 'SNAPSHOT');
    char(v2)
    ans =
        '1.2.0-SNAPSHOT'
    
    % Compare two version numbers
    v2 > v
    ans = 
       logical
        1
