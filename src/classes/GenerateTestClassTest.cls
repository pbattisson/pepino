@isTest
public with sharing class GenerateTestClassTest 
{
	public GenerateTestClassTest() {
		
	}

	private static Map<String, String> getTestMap()
	{
		Map<String, String> testMap = new Map<String, String>();
		testMap.put('I have a calculator', 'createCalculator');
		testMap.put('I have entered (\\d+) into the calculator', 'enterValue');
		testMap.put('I press add', 'addValues');
		testMap.put('the result should be (\\d+)', 'assertResult');
		return testMap;
	}

	private static List<String> getTestSet()
	{
		List<String> testSet = new List<String>();
		testSet.add('I have a calculator');
		testSet.add('I have entered 5 into the calculator');
		testSet.add('I have entered 7 into the calculator');
		testSet.add('I press add');
		testSet.add('the result should be 12');
		return testSet;
	}

	private static String expectedClass = '@isTest\npublic with sharing class Addition_Testing\n{\n@isTest\nprivate static void Addition_of_5_and_7_gives_12()\n{\nCalculator calc = new Calculator();\ncalc.enterNumber(double.valueOf(5.0));\ncalc.enterNumber(double.valueOf(7.0));\nDouble output = 0.0;try{output = calc.add();}catch(Exception ex){System.assert(false, ex.getMessage());}\nSystem.assertEquals(double.valueOf(12.0), output, \'Incorrect value output from calculator\');\n\n}\n\n}';
	
	@isTest
	private static void testGenerateCorrectClass()
	{

		FunctionRetriever retriever = new FunctionRetriever(getTestMap());
		Map<String, String> definitions = retriever.retrieveCorrectStepDefinition(getTestSet());
		Map<String, List<Object>> functionsWithParameters = retriever.retrieveFunctionsWithParameters(definitions);
		
		Map<String, List<String>> scenariosWithSteps = new Map<String, List<String>>();
		scenariosWithSteps.put('Addition of 5 and 7 gives 12', getTestSet());

		GenerateTestClass gtc = new GenerateTestClass('Addition Testing', new CalculatorBehaviourDefinitions());
		gtc.buildTestSteps(definitions, functionsWithParameters, scenariosWithSteps);
		System.assertEquals(expectedClass, gtc.returnClass(), 'The class returned is incorrect.');
	}
}