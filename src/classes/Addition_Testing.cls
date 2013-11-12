@isTest
public with sharing class Addition_Testing
{
	@isTest
	private static void Addition_of_5_and_7_gives_12()
	{
		Calculator calc = new Calculator();
		calc.enterNumber(double.valueOf(5.0));
		calc.enterNumber(double.valueOf(7.0));
		Double output = 0.0;
		try
		{
			output = calc.add();
		}
		catch(Exception ex)
		{
			System.assert(false, ex.getMessage());
		}
		System.assertEquals(double.valueOf(12.0), output, 'Incorrect value output from calculator');

	}
}