/**
  * @description This class is a calculator we use in testing the BDD system (the original cukes example uses such an example)
  */
public with sharing class Calculator 
{
	private List<Double> values = new List<Double>();

	public Calculator() 
	{
		
	}

	public void enterNumber(double value)
	{
		values.add(value);
	}

	public Double add()
	{
		Double output = 0.00;
		
		for(Double val : values)
		{
			output += val;
		}

		return output;
	}

	public Double divide()
	{
		if(values.size() > 1 && values[1] == 0)
		{
			throw new PepinoException('Only Chuck Norris can divide by 0.');
		}

		return values[0]/values[1];
	}
}