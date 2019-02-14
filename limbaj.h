#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>

struct Table{
	char* type;
	char* denumire;
	int valoare;
	char* scope;
	char* scope_Name;
}vals[1024];
struct Table2{
	char* type;
	char* denumire;
	char* scope;
	char* scope_Name;
	char* parametersList;
	char* declarations;
	char* loops;
}fcts[1024];
int nr=0;
int nr2=0;
int okFuncts=0;
int Compar(char *S,char *S1)
{
	if(strlen(S)!=strlen(S1))
		return 0;
	for(int ij=0;ij<strlen(S);ij++)
		if(S[ij]!=S1[ij])
			return 0;
	return 1;
}
void Check(char *S)
{
	int ok=0;
	for(int ij=0;ij<nr;ij++)
		if(Compar(vals[ij].denumire,S)==1)
		{
			ok=1;
		}
	if(ok==0)
	{
		printf("ERROR!Variables not declared!");
		exit(0);
	}
}
void Af(char* S)
{
	printf("%s\n",S);
	return;
}
void Calcul(char *S)
{
	int val=0;
	char cuv[15];
	int li=0;
	bzero(cuv,15);
	int i=0;
	if((S[0]>='a' && S[0]<='z') || (S[0]>='A' && S[0]<='Z')){
		while(S[i]!='+')
		{
			cuv[li]=S[i];
			li++;
			i++;
		}
		for(int ii=0;ii<nr;ii++)
			if(Compar(vals[ii].denumire,cuv)==1)
				val=vals[ii].valoare;
		printf("%i\n",(val+(S[2]-'0')));
		return;
	}
	for(int i=0;i<strlen(S);i+=3)
	{
		if(S[i+1]=='+')
			val+=(S[i]-'0'+S[i+2]-'0');
		if(S[i+1]=='-')
			val+=(S[i]-'0'-(S[i+2]-'0'));
		if(S[i+1]=='*')
			val+=((S[i]-'0')*(S[i+2]-'0'));
		if(S[i+1]=='/')
			val+=((S[i]-'0')/(S[i+2]-'0'));
		if(S[i+1]=='%')
			val+=((S[i]-'0')%(S[i+2]-'0'));
	}
	printf("%i\n",val);
}
void MakeOk()
{
	okFuncts=0;
}
void Procesez(char *S,char *S2,char *S3,char *S4)
{
	int vivi=0;
	for(int ii=0;ii<nr;ii++)
	{
		if(Compar(vals[ii].denumire,S2)==1)
		{
			printf("REdeclarare!");
			exit(0);
		}
	}
	if(strcmp(S3,"--")!=0 && strcmp(S4,"--")!=0)
	{
		for(int i=0;i<strlen(S4);i++)
			vivi=vivi*10+(S4[i]-'0');
		vals[nr].valoare=vivi;
	}
	else
		vals[nr].valoare=0;
	vals[nr].type=S;
	vals[nr].denumire=S2;
	printf("%s %s %i %s %s\n",vals[nr].type,vals[nr].denumire,vals[nr].valoare,vals[nr].scope,vals[nr].scope_Name);
	nr++;
}
void Functions(char *S,char *S2,char *S3,char *S4)
{
	okFuncts=1;
	int Vow=0;
	fcts[nr2].type=S;
	fcts[nr2].denumire=S2;
	fcts[nr2].parametersList=S3;
	fcts[nr2].declarations=S4;
	for(int ii1=0;ii1<nr2;ii1++)
	{
		if(Compar(fcts[ii1].denumire,fcts[nr2].denumire)==1)
		{
			if(Compar(fcts[ii1].parametersList,fcts[nr2].parametersList)==1)
			{
				printf("Two identical functions can't exist!");
				exit(0);
			}
		}
	}
	int fp=open("symbol_table.txt",O_RDWR|O_CREAT,0666);
	char car;
	while(read(fp,&car,1)!=0);
	char s[222];
	strcpy(s,"FUNCTION ");
	//strcat(s,fcts[nr2].type);
	for(int ii=0;ii<strlen(s);ii++)
		write(fp,&s[ii],1);
	for(int ii=0;ii<strlen(fcts[nr2].type);ii++)
		write(fp,&fcts[nr2].type[ii],1);
	for(int ii=0;ii<strlen(fcts[nr2].denumire);ii++)
		write(fp,&fcts[nr2].denumire[ii],1);
	for(int ii=0;ii<strlen(fcts[nr2].parametersList);ii++)
		write(fp,&fcts[nr2].parametersList[ii],1);
	for(int ii=0;ii<strlen(fcts[nr2].declarations);ii++)
		write(fp,&fcts[nr2].declarations[ii],1);
	char cc='\n';
	write(fp,&cc,1);
	close(fp);
	//printf("%s %s ( %s  )\n %s\n",fcts[nr2].type,fcts[nr2].denumire,fcts[nr2].parametersList,S4);
	nr2++;
}
void CheckIn(char *S1,char *S)
{
	char var[32];
	int ll=0;
	bzero(var,32);
	for(int ii=0;ii<strlen(S);ii++)
	{
		printf("%c",S[ii]);
		if(S[ii]=='+' || S[ii]=='*' || S[ii]=='-' || S[ii]=='/' || S[ii]=='%')
		{
			printf("%s_________\n",var);
			if(var[0]<'0' || var[0]>'9')
			for(int tt=0;tt<nr;tt++)
				if(Compar(vals[tt].denumire,var)==1)
					if(vals[tt].valoare==0)
					{
						printf("Unitialized variable!");
						exit(0);
					}
			int id1=-1,id2=-1;
			for(int tt=0;tt<nr;tt++)
			{
				if(Compar(vals[tt].denumire,S1)==1)
					id1=tt;
				if(Compar(vals[tt].denumire,var)==1)
					id2=tt;
			}
			if(id1!=-1 && id2!=-1)
			{
				if(Compar(vals[id1].type,vals[id2].type)==0)
				{
					printf("Not the same type!");
					exit(0);
				}
			}

			ll=0;
			bzero(var,13);
		}
		else
			if(S[ii]!='(' && S[ii]!=')')
			{
				var[ll]=S[ii];
				ll++;
			}
	}
}
void Functions3(char *S)
{
	int fp=open("symbol_table.txt",O_RDWR,0666);
	char cc;
	while(read(fp,&cc,1)!=0);
	for(int ii=0;ii<strlen(S);ii++)
	{
		write(fp,&S[ii],1);
	}
	char c='\n';
	write(fp,&c,1);
	close(fp);
}
void Check2(char *S,char *S2)
{
	int ok=0;
	for(int ij=0;ij<nr2;ij++)
		if(Compar(fcts[ij].denumire,S)==1)
		{
			int n1=0,n2=0;
			for(int it=0;it<strlen(fcts[ij].parametersList);it++)
				if(fcts[ij].parametersList[it]==',')
					n1++;
			for(int it=0;it<strlen(S2);it++)
				if(S[it]==',')
					n2++;
			if(n1==n2)
			{
				ok=1;
				break;
			}
		}
	if(ok==0)
	{
		printf("ERROR!Function not defined!");
		exit(0);
	}
}
void Functions2(char *S,char *S2,char *S3,char *S4,char *S5,char *S6)
{
	okFuncts=1;
	int Vow=0;
	int fp=open("symbol_table.txt",O_RDWR|O_CREAT,0666);
	char ci;
	while(read(fp,&ci,1)!=0);
	for(int ii=0;ii<strlen(S);ii++)
		write(fp,&S[ii],1);
	write(fp," ",1);
	for(int ii=0;ii<strlen(S2);ii++)
		write(fp,&S2[ii],1);
	write(fp," ",1);
	write(fp,"\n",1);
	for(int ii=0;ii<strlen(S4);ii++)
		write(fp,&S4[ii],1);
	write(fp,"\n",1);
	for(int ii=0;ii<strlen(S5);ii++)
		write(fp,&S5[ii],1);
	write(fp,"\n",1);
	for(int ii=0;ii<strlen(S6);ii++)
		write(fp,&S6[ii],1);
	char c='\n';
	write(fp,&c,1);
	close(fp);
	printf("%s %s ( %s  )\n %s\n %s \n %s",fcts[nr2].type,fcts[nr2].denumire,fcts[nr2].parametersList,S4,S5,S6);
	nr2++;
}