@isTest
public with sharing class PepinoTest 
{
	private static Map<String, List<String>> getTestSet()
	{
		List<String> testSet = new List<String>();
		testSet.add('I have a calculator');
		testSet.add('I have entered 5 into the calculator');
		testSet.add('I have entered 7 into the calculator');
		testSet.add('I press add');
		testSet.add('the result should be 12');
		
		Map<String, List<String>> testMap = new Map<String, List<String>>();
		testMap.put('Addition Testing', testSet);
		return testMap;
	}

	@isTest
	private static void testAddition()
	{
		Pepino pep = new Pepino('Calculator Testing', getTestSet(), new CalculatorBehaviourDefinitions());
		Blob bob = pep.createTestClassForFeature();
		System.debug('\n\n\n\n' + bob.toString() + '\n\n');
		System.assert(true);
	}
}