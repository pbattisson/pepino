
public with sharing class GenerateTestClassTest 
{
	public GenerateTestClassTest() {
		
	}

	private static Map<String, String> getTestMap()
	{
		Map<String, String> testMap = new Map<String, String>();
		testMap.put('Given I have a calculator', 'createCalculator');
		testMap.put('And I have entered (\\d+) into the calculator', 'enterValue');
		testMap.put('When I press add', 'addValues');
		testMap.put('Then the result should be (\\d+)', 'assertResult');
		return testMap;
	}

	private static List<String> getTestSet()
	{
		List<String> testSet = new List<String>();
		testSet.add('Given I have a calculator');
		testSet.add('And I have entered 5 into the calculator');
		testSet.add('And I have entered 7 into the calculator');
		testSet.add('When I press add');
		testSet.add('Then the result should be 12');
		return testSet;
	}

	public static void myExample()
	{

		FunctionRetriever retriever = new FunctionRetriever(getTestMap());
		Map<String, String> definitions = retriever.retrieveCorrectStepDefinition(getTestSet());
		Map<String, List<Object>> functionsWithParameters = retriever.retrieveFunctionsWithParameters(definitions);
		
		Map<String, List<String>> scenariosWithSteps = new Map<String, List<String>>();
		scenariosWithSteps.put('Addition of 5 and 7 gives 12', getTestSet());

		GenerateTestClass gtc = new GenerateTestClass('Addition Testing', getTestMap(), 'CalculatorBehaviourDefinitions');
		gtc.buildTestSteps(definitions, functionsWithParameters, scenariosWithSteps);
		System.debug(gtc.returnClass());
	}
}