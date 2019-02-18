%{
#include</home/vt40753/compiler/union.h>
#include </home/vt40753/compiler/y.tab.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char symboltbl[10000][50];
int head = 0;

char removeqoute(char* input);
void concat(char* str, char out[]);
int symbolval(char* symbol);

int insert(char* token );
%}



LETTER  [a-zA-Z]

NONZERO_DIGIT  [1-9]

DIGIT  "0"|{NONZERO_DIGIT}

DIGITS  ({NONZERO_DIGIT}{DIGIT}*)|"0"

opt_frac  (.(({DIGIT}*{NONZERO_DIGIT})|"0"))?

opt_exp  ("E"("+"|"-")?{DIGITS})?





%%


[\ \t\n]                             ;

"program"                       {return(PROGRAM_KW);};

"while"                         { return(WHILE_KW); };

"if" 	 						{return(IF_KW); };

"for"  							{return(FOR_KW); };

"switch"  						{ return(SWITCH_KW); };

"case"  						{ return(CASE_KW); };

"default"  						{ return(DEFAULT_KW); };

"return"  						{  return(RETURN_KW); };

"break"  						{ return(BREAK_KW); };

"continue"  					{  return(CONTINUE_KW); };

"read"  						{ return(READ_KW); };

"write"  						{ return(WRITE_KW); };

"else"  						{ return(ELSE_KW); };

"then"  						{return(THEN_KW); };

"integer"  						{ return(INT_KW); };

"float"  						{ return(FLOAT_KW); };

"character"  					{ return(CHAR_KW); };

"bool"  						{return(BOOL_KW); };

"void"  						{return(VOID_KW); };

"callout"  						{  return(CALLOUT_KW); };

"TRUE"  						{ yylval.strValue =yytext; return(BOOL_CONSTANT); };

"FALSE"  						{yylval.strValue =yytext; return(BOOL_CONSTANT); };

"["  							{ return('['); };

"]"  							{ return(']'); };

"{"  							{ return('{'); };

"}"  							{ return('}'); };

"("  							{ return('('); };

")"  							{ return(')'); };

","  							{ return(','); };

";"  							{ return(';'); };

":"  							{ return(':'); };

"="  							{return('='); };

"=="  							{  return(EQ); };

"!="  							{ return(NE); };

"<"  							{yylval.strValue =yytext; return(LT); };

"<="  							{  return(LE); };

">"  							{  return(GT); };

">="		  					{ return(GE); };

"!"  							{  return(NOT); };

"+"  							{yylval.strValue =yytext; return(PLUS); };

"-"			  				{yylval.strValue =yytext; return(MINUS); };

"*"  							{yylval.strValue =yytext; return(MULT); };

"/"  							{yylval.strValue =yytext; return(DIV); };

"%"  							{ yylval.strValue =yytext; return(REM); };

"&&"  							{ return(AND_THEN); };

"&"  							{  return(AND); };

"||"  							{  return(OR_ELSE); };

"|"  							{  return(OR); };

">>"  							{  return(SHR); };

"<<"  							{ return(SHL); };
\"([A-Za-z ]|\t)*(\n)*\"((\n|\t|\ )*"+"(\n|\t|\ )*\"([A-Za-z ]|\t)*(\n)*\")* 		{ char* txt = yytext; char s[5000];concat(txt,s); insert(s);  yylval.strValue =yytext; return (STRING_CONSTANT);}
((({LETTER}({LETTER}{LETTER})*|{LETTER}({LETTER}{LETTER})*{DIGIT}{LETTER}({LETTER}{LETTER})*|{LETTER}({LETTER}{LETTER})*{DIGIT}({LETTER}{LETTER}{DIGIT}({LETTER}{LETTER}{DIGIT}{LETTER}{LETTER}{DIGIT})*)({LETTER}{LETTER})*|{LETTER}({LETTER}{LETTER})*{DIGIT}({LETTER}{LETTER}{LETTER}{DIGIT}*){LETTER}({LETTER}{LETTER})*|{LETTER}({LETTER}{LETTER})*{DIGIT}({LETTER}{LETTER}{LETTER}{LETTER}{DIGIT}({LETTER}{LETTER}{LETTER}{LETTER}{DIGIT}{LETTER}{LETTER}{LETTER}{LETTER}{DIGIT})*)({LETTER}{LETTER})*|{LETTER}({LETTER}{LETTER})*{DIGIT}({LETTER}{LETTER}{LETTER}{LETTER}{LETTER}{DIGIT}*){LETTER}({LETTER}{LETTER})*)_)?[A-Za-z][A-Za-z0-9]*)	{insert(yytext);yylval.strValue=strdup(yytext); return(ID);}
({LETTER}|{DIGIT})+_({LETTER}|{DIGIT})+		{}
(\'[A-Za-z]\'|\'\t\'|\'\n\'|\'\\\\\')  					{ char* a = yytext; char* b ;b[0]=removeqoute(a); insert(b);yylval.strValue =yytext; return(CHAR_CONSTANT);}

[1-9][0-9]*|1(0|1)*b|([1-9]|[A-F])([A-F]|[0-9])*X	  			{insert(yytext);yylval.strValue =yytext; return(INT_CONSTANT);}

{DIGIT}{opt_frac}{opt_exp}				{insert(yytext); yylval.strValue =yytext; return(FLOAT_CONSTANT);}



(("//".*)|("/*"([^*]|\*+[^*/])*\*+"/"))											{}

. 																					{}











%%

int symbolval(char* symbol){

	int i ;
	//printf("hello   %s",symbol);
	for(i=0;i<10000;i++)
	{
		//printf("%s,%s",symboltable[i],symbol);
		int j =0;
		int flag = 0;
		while(symbol[j]!='\0')                                                   
   	 	{
			if(symboltbl[i][j]!=symbol[j])
			{
			flag =1;
			break;
			}                                                   
        		j++;
    		}		
		if(flag == 0){return i;}
	}

	return -1;

}



int insert(char* token ){
	

	int s = symbolval(token);
	if(s == -1){
		int i =0;
		while(token[i]!='\0')                                                   
   	 	{
        		symboltbl[head][i] = token[i];                                                    
        		i++;
    		}
		head = head + 1;
		//File* symbol = fopen("symbol.out", "a");
		//fprintf(symbol,token );
		//fclose(symbol);
		return head-1;

	}else{

		return s;

	}

}
void symbol_display(){
int i;
for(i=0; i<=head; i++){
	int j = 0;
	printf("\n symboltbl:");
	while(symboltbl[i][j]!='\0')                                                   
   	 	{
			printf("%c",symboltbl[i][j]);	                                                  
        		j++;
    		}
}
	
}


char removeqoute(char* input){
char temp[50];  
int i =0;
	while(input[i+2]!='\0')                                                   
   	 {
        	temp[i] = input[i+1];                                                    
        	i++;
    	}
    	temp[i]='\0'; 

	return temp[0]; 	
}

void concat(char* str, char out[]){
int i=0;
int j=0;
	while(str[i+2]!='\0')                                                   
   	 {
		if(str[i+1] != '+' && str[i+1] != '\"' && str[i+1] != '\t' && str[i+1] != ' ' && str[i+1] != '\n'){
			out[j++] = str[i+1];				
		}
		i++;       	                                                    
    	}

}


int yywrap(){}
/*main(){
int i = 0;
	for(i=0;i<10000;i++){
		//symboltbl[i] = "";
		//printf("symbol:   %s",symboltbl[i]);
	}
	extern FILE *yyin, *yyout;
	//yyin = fopen("test.in","r");
	//yyout = fopen("output.out", "w");
	yylex();
return 0;
//fclose(yyin);
}*/
