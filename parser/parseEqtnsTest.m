
% Set Up Once

testCase = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

%% Test One

TYPE = @int8;

b = parser.theparser.Equation( );
b.Type = TYPE(2);
code = file2char('parseEqtnsTest.model');
equation = model.component.Equation( );
quantity = model.component.Quantity( );
euc = parser.EquationUnderConstruction( );

q = warning('query');
expId = 'IRIS:TheParser:EmptyEquation';
warning('off', expId);
opt = struct('SteadyOnly', false);
[~, equation] = parse(b, [ ], code, quantity, equation, euc, [ ], opt);
[~, actId] = lastwarn( );

assertEqual(testCase, actId, expId);
warning(q);

actInput = equation.Input;
expInput = { ...
    'x{-10}=y{+10}', ...
    'a{-1}=b{-5}', ...
    'c{2}=d{+3}!!c=0', ...
    'e{t+2*10}=f{t-100-100}!!e=f', ...
    'g{2*0}=0!!g=0', ...
    'a+b+c+d+e+f+g', ...
    'j{+4}=2*j{t-4}', ...
    };

actType = equation.Type;
expType = repmat(b.Type, 1, length(expInput));

actLabel = equation.Label;
expLabel = { ...
    'Label1', ...  
    '', ...
    '', ...
    '''Label4'';', ...
    'Invalid Time Subscript', ...
    'No Equal Sign', ...
    '''Multiple Labels 3''', ...
    };

actLhsDynamic = euc.LhsDynamic;
expLhsDynam = { ...
    'x{@-10}', ...
    'a{@-1}', ...
    'c{@+2}', ...
    'e{@+20}', ...
    'g', ...
    char.empty(1, 0), ...
    'j{@+4}', ...
    };

actRhsDynamic = euc.RhsDynamic;
expRhsDynam = { ...
    'y{@+10}', ...
    'b{@-5}', ...
    'd{@+3}', ...
    'f{@-200}', ...
    '0', ...
    'a+b+c+d+e+f+g', ...
    '2*j{@-4}', ...
    };

actSignDynamic = euc.SignDynamic;
expSignDynamic = { ...
    '=', ...
    '=', ...
    '=', ...
    '=', ...
    '=', ...
    char.empty(1, 0), ...
    '=', ...    
    };

actLhsSteady = euc.LhsSteady;
expLhsSteady = { ...
    char.empty(1, 0), ...
    char.empty(1, 0), ...
    'c', ...
    'e', ...
    'g', ...
    char.empty(1, 0), ...
    char.empty(1, 0), ...
    };

actRhsSteady = euc.RhsSteady;
expRhsSteady = { ...
    '', ...
    '', ...
    '0', ...
    'f', ...
    '0', ...
    '', ...
    '', ...
    };

actSignSteady = euc.SignSteady;
expSignSteady = { ...
    char.empty(1, 0), ...
    char.empty(1, 0), ...
    '=', ...
    '=', ...
    '=', ...
    char.empty(1, 0), ...
    char.empty(1, 0), ...
    };

actMaxShDynamic = max(euc.MaxShDynamic);
expMaxShDynamic = 20;

actMinShDynamic = min(euc.MinShDynamic);
expMinShDynamic = -200;

assertEqual(testCase, actInput, expInput);
assertEqual(testCase, actType, expType);
assertEqual(testCase, actLabel, expLabel);
assertEqual(testCase, actLhsDynamic, expLhsDynam);
assertEqual(testCase, actRhsDynamic, expRhsDynam);
assertEqual(testCase, actSignDynamic, expSignDynamic);
assertEqual(testCase, actLhsSteady, expLhsSteady);
assertEqual(testCase, actRhsSteady, expRhsSteady);
assertEqual(testCase, actSignSteady, expSignSteady);
assertEqual(testCase, actMaxShDynamic, expMaxShDynamic);
assertEqual(testCase, actMinShDynamic, expMinShDynamic);
