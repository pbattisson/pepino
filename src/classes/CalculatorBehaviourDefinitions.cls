public with sharing class CalculatorBehaviourDefinitions implements BehaviourDefinitions
{
	public CalculatorBehaviourDefinitions() {
		
	}

	public Map<String, String> functionDeclarationMap()
	{
		Map<String, String> definitions = new Map<String, String>();
		definitions.put('Given I have a calculator', 'createCalculator');
		definitions.put('And I have entered (\\d+) into the calculator', 'enterValue');
		definitions.put('When I press add', 'addValues');
		definitions.put('Then the result should be (\\d+)', 'assertResult');
		return definitions;
	}

	public String getStepCodeForFunctionWithParameters(String functionName, List<Object> parameters)
	{
		if(functionName == 'createCalculator')
		{
			return createCalculator();
		}
		else if(functionName == 'enterValue')
		{
			return enterValue(Double.valueOf(parameters[0]));
		}
		else if(functionName == 'addValues')
		{
			return addValues();
		}
		else if(functionName == 'assertResult')
		{
			return assertResult(Double.valueOf(parameters[0]));
		}
		
		return '';
	}

	private String createCalculator()
	{
		return 'Calculator calc = new Calculator();';
	}

	private String enterValue(Double dbl)
	{
		return 'calc.enterNumber(double.valueOf(' + dbl + '));';
	}

	private String addValues()
	{
		return 'Double output = calc.add();'; 
	}

	private String assertResult(Double dbl)
	{
		return 'System.assertEquals(double.valueOf(' + dbl + '), output, \'Incorrect value output from calculator\');';
	}
}