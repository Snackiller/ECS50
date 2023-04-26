#include <iostream>
#include <stdexcept>
#include <string>
#include <algorithm> 
using namespace std;
int main(int argc, char* argv[]) {
    string lowercase = "abcdefghijklmnopqrstuvwxyz";
    string uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    string digits="01";
    string word="";
    int input;
    for(int i = 1; i < argc; i++)
	{
		input = stoi(argv[i]);
        string binum="";
        if(input<67108865)
        {
            while (input!=0)
	        {
		        binum=binum+digits[(input%2)];
    		    input=input/2;
	        }
            reverse(binum.begin(),binum.end());
            word=word+lowercase[binum.length()-1];
        }
        else
        {
            input=input-67108864;
            while (input!=0)
	        {
		        binum=binum+digits[(input%2)];
    		    input=input/2;
	        }
            reverse(binum.begin(),binum.end());
            word=word+uppercase[binum.length()-1];
        }
    }
    cout << "You entered the word: " << word << endl;
    return 0;
}