@isTest
public with sharing class FunctionRetrieverTest
{
	private static Map<String, String> getTestMap()
	{
		Map<String, String> testMap = new Map<String, String>();
		testMap.put('Given I have a calculator', 'methodZero');
		testMap.put('And I have entered (\\d+) into the calculator', 'methodOne');
		testMap.put('When I press add', 'methodTwo');
		testMap.put('Then the result should be (\\d+)', 'methodThree');
		return testMap;
	}

	private static Set<String> getTestSet()
	{
		Set<String> testSet = new Set<String>();
		testSet.add('Given I have a calculator');
		testSet.add('And I have entered 5 into the calculator');
		testSet.add('And I have entered 7 into the calculator');
		testSet.add('When I press add');
		testSet.add('Then the result should be 12');
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

		System.assertEquals('And I have entered (\\d+) into the calculator', matches.get('And I have entered 5 into the calculator'));
		System.assertEquals('And I have entered (\\d+) into the calculator', matches.get('And I have entered 7 into the calculator'));
		System.assertEquals('When I press add', matches.get('When I press add'));
		System.assertEquals('Then the result should be (\\d+)', matches.get('Then the result should be 12'));
	}

	@isTest
	private static void testRetrieveFunctionWithParameters()
	{
		FunctionRetriever retriever = new FunctionRetriever(getTestMap());
		Map<String, String> matches = retriever.retrieveCorrectStepDefinition(getTestSet());

		System.assertEquals('And I have entered (\\d+) into the calculator', matches.get('And I have entered 5 into the calculator'));
		System.assertEquals('And I have entered (\\d+) into the calculator', matches.get('And I have entered 7 into the calculator'));
		System.assertEquals('When I press add', matches.get('When I press add'));
		System.assertEquals('Then the result should be (\\d+)', matches.get('Then the result should be 12'));

		Map<String, List<Object>> functionsWithParameters = retriever.retrieveFunctionsWithParameters(matches);

		System.assertEquals(1, (functionsWithParameters.get('And I have entered 5 into the calculator').size()));
		System.assertEquals(5, Integer.valueOf(functionsWithParameters.get('And I have entered 5 into the calculator')[0]));
		System.assertEquals(1, (functionsWithParameters.get('And I have entered 7 into the calculator').size()));
		System.assertEquals(7, Integer.valueOf(functionsWithParameters.get('And I have entered 7 into the calculator')[0]));
		System.assertEquals(0, functionsWithParameters.get('When I press add').size());
		System.assertEquals(1, functionsWithParameters.get('Then the result should be 12').size());
		System.assertEquals(12, Integer.valueOf(functionsWithParameters.get('Then the result should be 12')[0]));

	}
}