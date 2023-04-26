#include <iostream>
#include <stdexcept>
#include <fstream>
#include <string>
#include <cmath>
using namespace std;
int main(int argc, char **argv)
{
	ifstream file1(argv[1]);
	ifstream file2(argv[2]);
	string temp;
	getline(file1,temp);
	getline(file2,temp);
	int size=stoi(temp);
	int matrixSize=size*size;
	int mat1[matrixSize];
	int mat2[matrixSize];
	int mat3[matrixSize];
	int i=0;
	int count=1;
	if(size<2)
	{
		getline(file1,temp);
		mat1[i]=stoi(temp);
		getline(file2,temp);
		mat2[i]=stoi(temp);
	}
	else
	{
		while(true)
		{
			getline(file1,temp);
			if((i+1)%size==0)
			{
				mat1[i]=stoi(temp);
				getline(file1,temp);
				i++;
				for(int j=1;j<=count;j++)
				{
					mat1[i]=0;
					i++;
				}
				count++;
			}
			mat1[i]=stoi(temp);
			i++;
			if(i==matrixSize)
			{
				break;
			}
		}
		i=0;
		count=1;
		while(true)
		{
			getline(file2,temp);
			if(!temp.empty()&&(i+1)%size==0)
			{
				mat2[i]=stoi(temp);
				getline(file2,temp);
				i++;
				for(int j=1;j<=count;j++)
				{
					mat2[i]=0;
					i++;
				}
				count++;
			}
			mat2[i]=stoi(temp);
			i++;
			if(i==matrixSize)
			{
				break;
			}
		}
	}
	file1.close();
	file2.close();
	for (int i=0;i<size;i++)
	{
    	for (int j=0;j<size;j++)
		{
			int sum=0;
        	for (int k=0;k<size;k++)
			{
				sum+=mat1[i*size+k]*mat2[k*size+j];
        	}
			mat3[i*size+j]=sum;
    	}
	}
	for(int j=0;j<size;j++)
	{
		for(int i=0;i<size;i++)
		{
			if(i>=j)
			{
				cout<<mat3[j*size+i]<<' ';
			}
		}
	}
	cout<<endl;
	return 0;
}