public with sharing class CalculatorBehaviourDefinitions implements BehaviourDefinitions
{
	public CalculatorBehaviourDefinitions() {
		
	}

	public Map<String, String> functionDeclarationMap()
	{
		Map<String, String> definitions = new Map<String, String>();
		definitions.put('I have a calculator', 'createCalculator');
		definitions.put('I have entered (\\d+) into the calculator', 'enterValue');
		definitions.put('I press add', 'addValues');
		definitions.put('I press divide', 'divideValues');
		definitions.put('the result should be (\\d+)', 'assertResult');
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
			System.debug(parameters);
			return enterValue(Double.valueOf(parameters[0]));
		}
		else if(functionName == 'addValues')
		{
			return addValues();
		}
		else if(functionName == 'divideValues')
		{
			return divideValues();
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
		return 'Double output = 0.0;try{output = calc.add();}catch(Exception ex){System.assert(false, ex.getMessage());}'; 
	}

	private String divideValues()
	{
		return 'Double output = 0.0;try{output = calc.divide();}catch(Exception ex){System.assert(false, ex.getMessage());}';
	}

	private String assertResult(Double dbl)
	{
		return 'System.assertEquals(double.valueOf(' + dbl + '), output, \'Incorrect value output from calculator\');';
	}
}