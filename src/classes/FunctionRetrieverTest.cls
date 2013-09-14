@isTest
public with sharing class FunctionRetrieverTest
{
	private static Map<String, String> getTestMap()
	{
		Map<String, String> testMap = new Map<String, String>();
		testMap.put('I have a calculator', 'methodZero');
		testMap.put('I have entered (\\d+) into the calculator', 'methodOne');
		testMap.put('I press add', 'methodTwo');
		testMap.put('the result should be (\\d+)', 'methodThree');
		return testMap;
	}

	private static Set<String> getTestSet()
	{
		Set<String> testSet = new Set<String>();
		testSet.add('I have a calculator');
		testSet.add('I have entered 5 into the calculator');
		testSet.add('I have entered 7 into the calculator');
		testSet.add('I press add');
		testSet.add('the result should be 12');
		return testSet;
	}

	@isTest
	private static void testNullMapInConstructorNoError()
	{
		try
		{
			FunctionRetriever retriever = new FunctionRetriever(null);
			System.assert(true);	
		}
		catch(Exception e)
		{
			System.assert(false, e.getMessage());
		}
	}

	@isTest
	private static void testInstantiateWithValidMap()
	{
		Map<String, String> testMap = getTestMap();
		try
		{
			FunctionRetriever retriever = new FunctionRetriever(testMap);
			System.assert(true);	
		}
		catch(Exception e)
		{
			System.assert(false, e.getMessage());
		}	
	}

	@isTest
	private static void testRetrieveEmptyFunctionMap()
	{
		try
		{
			FunctionRetriever retriever = new FunctionRetriever(null);
			Map<String, String> retrievedMatches = retriever.retrieveCorrectStepDefinition(new Set<String>());
			System.assertNotEquals(retrievedMatches, null);	
		}
		catch(Exception e)
		{
			System.assert(false, e.getMessage());
		}
	}

	@isTest
	private static void testRetrieveEmpty()
	{
		try
		{
			FunctionRetriever retriever = new FunctionRetriever(null);
			Map<String, String> retrievedMatches = retriever.retrieveCorrectStepDefinition(new Set<String>());
			System.assertNotEquals(retrievedMatches, null);	
		}
		catch(Exception e)
		{
			System.assert(false, e.getMessage());
		}
	}

	@isTest
	private static void testRetrieve()
	{
		FunctionRetriever retriever = new FunctionRetriever(getTestMap());
		Map<String, String> matches = retriever.retrieveCorrectStepDefinition(getTestSet());

		System.assertEquals('I have entered (\\d+) into the calculator', matches.get('I have entered 5 into the calculator'));
		System.assertEquals('I have entered (\\d+) into the calculator', matches.get('I have entered 7 into the calculator'));
		System.assertEquals('I press add', matches.get('I press add'));
		System.assertEquals('the result should be (\\d+)', matches.get('the result should be 12'));
	}

	@isTest
	private static void testRetrieveFunctionWithParameters()
	{
		FunctionRetriever retriever = new FunctionRetriever(getTestMap());
		Map<String, String> matches = retriever.retrieveCorrectStepDefinition(getTestSet());

		System.assertEquals('I have entered (\\d+) into the calculator', matches.get('I have entered 5 into the calculator'));
		System.assertEquals('I have entered (\\d+) into the calculator', matches.get('I have entered 7 into the calculator'));
		System.assertEquals('I press add', matches.get('I press add'));
		System.assertEquals('the result should be (\\d+)', matches.get('the result should be 12'));

		Map<String, List<Object>> functionsWithParameters = retriever.retrieveFunctionsWithParameters(matches);

		System.assertEquals(1, (functionsWithParameters.get('I have entered 5 into the calculator').size()));
		System.assertEquals(5, Integer.valueOf(functionsWithParameters.get('I have entered 5 into the calculator')[0]));
		System.assertEquals(1, (functionsWithParameters.get('I have entered 7 into the calculator').size()));
		System.assertEquals(7, Integer.valueOf(functionsWithParameters.get('I have entered 7 into the calculator')[0]));
		System.assertEquals(0, functionsWithParameters.get('I press add').size());
		System.assertEquals(1, functionsWithParameters.get('the result should be 12').size());
		System.assertEquals(12, Integer.valueOf(functionsWithParameters.get('the result should be 12')[0]));

	}
}