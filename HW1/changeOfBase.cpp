#include <iostream>
#include <cmath>
#include <string>
#include <algorithm> 
using namespace std;
int main()
{
	string digits="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	int oldBase,newBase;
	string inputString;
	cout<<"Please enter the number's base: ";
	cin>>oldBase;
	cout<<"Please enter the number: ";
	cin>>inputString;
	cout<<"Please enter the new base: ";
	cin>>newBase;
	unsigned int decimalMode=0;
    int inputlen=inputString.length();
	for(int i=0;i<inputlen;i++)
	{
		if(inputString[inputlen-i-1]>=97&&inputString[inputlen-i-1]<=122)
		{
			inputString[inputlen-i-1]=inputString[inputlen-i-1]-32;
		}
		decimalMode=decimalMode+digits.find(inputString[inputlen-i-1])*pow(oldBase,i);
	}
	string outputString="";
	while (decimalMode!=0)
	{
		outputString=outputString+digits[(decimalMode%newBase)];
		decimalMode=decimalMode/newBase;
	}
	reverse(outputString.begin(),outputString.end()); 
	cout<<inputString<<" base "<<oldBase<<" is "<< outputString<<" base "<<newBase<<endl;
}