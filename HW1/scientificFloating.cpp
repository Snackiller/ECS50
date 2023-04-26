#include <iostream>
#include <iomanip>
#include <string>
#include <algorithm> 
using namespace std;
int main()
{
    float f;
    string digits="01";
    cout<<"Please enter a float: ";
    cin>>f;
    string sign="\0";
    if(f<0)
    {
        sign='-';
    }
    int float_int = abs(f);
    float float_float=abs(f)-float_int;
    string binum="";
	while(float_int!=0)
	{
		binum=binum+digits[(float_int%2)];
	    float_int=float_int/2;
	}
    reverse(binum.begin(),binum.end());
    string bifloat=".";
    while(float_float!=0)
    {
        if(float_float*2>=1)
        {
            float_float=float_float*2;
            bifloat=bifloat+'1';
            float_float=float_float-1;
        }
        if(float_float*2<1)
        {
            float_float=float_float*2;
            bifloat=bifloat+'0';
        }
    }
    binum=binum+bifloat;
    binum.pop_back();
    float result=stof(binum);
    int count=0;
    while(result>10)
    {
        result=result/10;
        count++;
    }
    binum.erase(remove(binum.begin(), binum.end(), '.'), binum.end());
    binum=binum.insert(1,1,'.');
    result=stof(binum);
	cout<<sign<<binum<<'E'<<count<<endl;
    return 0;
}