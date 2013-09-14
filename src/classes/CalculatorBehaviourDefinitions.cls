public with sharing class CalculatorBehaviourDefinitions {
	public CalculatorBehaviourDefinitions() {
		
	}

	public static String createCalculator()
	{
		return 'Calculator calc = new Calculator();';
	}

	public static String enterValue(Double dbl)
	{
		return 'calc.enterNumber(double.valueOf(' + dbl + '));';
	}

	public static String addValues()
	{
		return 'Double output = calc.add();'; 
	}

	public static String assertResult(Double dbl)
	{
		return 'System.assertEquals(double.valueOf(' + dbl + '), output, \'Incorrect value output from calculator\');';
	}
}