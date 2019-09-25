function text = title_image(it, lab)

text = '';

if it == 48 %the zero key
    title('CROWDS');
elseif it == 114
    title('ROBOTS');
end
if strcmp(lab, 'BarcelonaImages')
    if it == 50
        title('Plinio');
        %                                   elseif it == 51
        %                                       title('Only seen once Person');
    elseif it == 104
        title('Merino');
    elseif it == 107
        title('Sequeira 17Jul');
    elseif it == 77
        title('Bruno');
    elseif it == 89
        title('Bruno 15Jul');
    elseif it == 33
        title('Rashid 15Jul');
    elseif it == 34
        title('Frances 15Jul');
    elseif it == 40
        title('Marco Barbosa 18Jul');
    elseif it == 41
        title('Sequeira 18Jul');
    elseif it == 42
        title('Andrew 17Jul');
    elseif it == 100
        title('Nelson? 17Jul');
    elseif it == 90
        title('Alberto 15Jul');
    elseif it == 231
        title('Alberto 17Jul');
    end
end
if strcmp(lab, 'piso8corredores')
    if it == 49 % 1
        text = 'gajooculos1';
        title('gajooculos1');
    elseif it == 50 % 2
        text = 'Matteo';
        title('Matteo');
    elseif it == 51 % 3
        text = 'prof1';
        title('prof1');
    elseif it == 52 % 4
        text = 'gajo1';
        title('gajo1');
    elseif it == 53 % 5
        text = 'dario';
        title('dario');
    elseif it == 54 % 6
        text = 'indiangreen';
        title('indiangreen');
    elseif it == 55 % 7
        text = 'gajored1';
        title('gajored1');
    elseif it == 56 % 8
        text = 'gajaindia';
        title('gajaindia');
    elseif it == 57 % 9
        text = 'gajored2';
        title('gajored2');
    end
end
