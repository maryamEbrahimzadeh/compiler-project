%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#include</home/vt40753/compiler/stack.h>
#include</home/vt40753/compiler/quad.h>
#include</home/vt40753/compiler/union.h>
#include</home/vt40753/compiler/queue.h>


extern int symbolval(char* symbol);
extern int insert(char* token );
extern void symbol_display();

Eval* codegen();
void codegen_assign();
Eval* codegen_uminus();
Eval* or_action(Eval* e1,Eval* e2, int mquad);
Eval* and_action(Eval* e1,Eval* e2, int mquad);
Eval* not_action(Eval* e1);
Eval* par(Eval* e1);
Eval* bool_id(char* input);
Eval* bool_emit_lt();
Eval* bool_emit_gt();
Eval* bool_emit_eq();
Eval* bool_emit_le();
Eval* bool_emit_ge();
Eval* bool_emit_ne();
Eval* func();


Eval* while_action(int m1quad,int m2quad,Eval* e,Eval* s);
Eval* block_action(Eval* l);
Eval* assignment_action();
Eval* statement_list1_action(int m1quad , Eval* l1, Eval* s);
Eval* statement_list2_action(Eval* s);
Eval* empty_block_action();
Eval* if_action(int m1quad,Eval* e,Eval* s);
Eval* if_else_action(int m1quad, int m2quad, Eval* e,Eval* s1,Eval* n,Eval* s2);


Eval* constant_action(char* input);
Eval* method_call_action();
void method_action(char* name);
void return_action(char* tr);
Eval* true_action(char* bl);
void tocode();
%}
%union {
	char* strValue;
	Eval* evalptr;
	int quad;
  	}
%type <quad> M M1
%type <evalptr> operational_expr expr location statement  block statement_list N constant
%type <strValue> ID PLUS MULT MINUS DIV REM INT_CONSTANT FLOAT_CONSTANT EQ NE LT LE GT GE CHAR_CONSTANT BOOL_CONSTANT 
%type <strValue> return_expr
%token PROGRAM_KW WHILE_KW IF_KW FOR_KW SWITCH_KW CASE_KW DEFAULT_KW RETURN_KW BREAK_KW CONTINUE_KW READ_KW 
%token WRITE_KW ELSE_KW THEN_KW INT_KW FLOAT_KW CHAR_KW BOOL_KW VOID_KW CALLOUT_KW BOOL_CONSTANT
%token '[' ']' '{' '}' '(' ')' ',' ';' '=' 
%token ID CHAR_CONSTANT INT_CONSTANT FLOAT_CONSTANT STRING_CONSTANT
%left  OR_ELSE
%left AND_THEN
%left AND OR EQ NE LT LE GT GE
%left MINUS PLUS 
%left MULT DIV REM 
%right SHR SHL NOT UMINUS


%%
program :
		PROGRAM_KW ID  '{' field_decl_list method_decl_list '}'  {printf(" Rule 1:  Rule : program: PROGRAM_KW ID  '{' field_decl_list method_decl_list '}'\n"); symbol_display();printf("\n");quad_display();printf("\n");tocode();}
		|PROGRAM_KW ID  '{' field_decl_list '}'  {quad_display();printf(" Rule 1:  Rule : program: PROGRAM_KW ID  '{' field_decl_list '}'\n");}
		|PROGRAM_KW ID  '{' method_decl_list '}'  {quad_display();printf(" Rule 1:  Rule : program: PROGRAM_KW ID  '{'  method_decl_list '}'\n");}
		|PROGRAM_KW ID  '{'  '}'  {quad_display();printf(" Rule 1:  Rule : program: PROGRAM_KW ID  '{'  '}'\n");}
		;

method_decl_list:
		method_decl method_decl_list {printf(" Rule 6: method_decl_list: method_decl method_decl_list\n");}
		|method_decl {printf(" Rule 6: method_decl_list: method_decl\n");}
		;

field_decl_list :
		 field_decl_list field_decl  {printf(" Rule 2:  Rule : field_decl_list: field_decl field_decl_list\n");}
		|field_decl {}
		;
field_decl :
		type field_name_list ';' {printf(" Rule 3: field_decl : type field_name_list ';'\n");}
		;
	
field_name_list :
		field_name ',' field_name_list {printf(" Rule 4.1: field_name_list : field_name ',' field_name_list\n");}
		|ID '[' INT_CONSTANT ']'  {printf(" Rule 4.2: field_name_list : field_name\n");}
		|ID {printf(" Rule 4.2: field_name_list : ID\n");}
		;
field_name :
		ID '[' INT_CONSTANT ']' {printf(" Rule 5.1: field_name : ID '[' INT_CONSTANT ']'\n");}
		| ID {printf(" Rule 5.2: field_name :ID\n");}
		;

method_decl:
		type ID '('formal_parameter_list ')' block {printf(" Rule 7: method_decl: return_type ID '('formal_parameter_list ')' block \n");}
		|VOID_KW ID '('formal_parameter_list ')' block {printf(" Rule 7: method_decl: return_type ID '('formal_parameter_list ')' block \n");}
		|type ID '(' ')' block { printf(" Rule 7: method_decl: return_type ID '(' ')' block \n");}
		|VOID_KW ID '(' ')' block { printf(" Rule 7: method_decl: return_type ID '(' ')' block \n");}
				
		;
		
method_call :
		ID '(' actual_parameters ')' {method_action($1);printf(" Rule 8.1: method_call : ID '(' actual_parameters ')'\n");}
		|CALLOUT_KW '(' STRING_CONSTANT callout_parameters ')' {printf(" Rule 8.2: method_call : CALLOUT_KW '(' STRING_CONSTANT callout_parameters ')' \n");}
		| ID '(' ')' {printf(" Rule 8.1: method_call : ID '(' ')'\n");}
		;
actual_parameters:
		actual_parameters_list {printf(" Rule 9: actual_parameters: actual_parameters_list\n");}
		;
actual_parameters_list :
		expr ',' actual_parameters_list {enqueue($1->t_value);   printf(" Rule 10.1: actual_parameters_list : expr ',' actual_parameters_list\n");}
		|expr {  enqueue(((Eval *)$1)->t_value);     printf(" Rule 10.2: actual_parameters_list : expr\n");}
		;
callout_parameters :
		',' callout_parameters_list {printf(" Rule 11: callout_parameters : ',' callout_parameters_list\n");}
		;
callout_parameters_list :
		expr ',' callout_parameters_list {printf(" Rule 12.1: callout_parameters_list : expr ',' callout_parameters_list\n");}
		| expr {printf(" Rule 12.2: callout_parameters_list : expr\n");}
		;
formal_parameter_list :
		argument_list {printf(" Rule 13: formal_parameter_list : argument_list\n");}
		;
argument_list :
		type ID ',' argument_list {printf(" Rule 14.1: argument_list : type ID ',' argument_list\n");}
		|type ID {printf(" Rule 14.2: argument_list : type ID \n");}
		;
type :
		INT_KW    {printf(" Rule 15.1: type : INT_KW\n");}
		|FLOAT_KW {printf(" Rule 15.2: type : FLOAT_KW\n");}
		|CHAR_KW  {printf(" Rule 15.3: type : CHAR_KW\n");}
		|BOOL_KW  {printf(" Rule 15.4: type : BOOL_KW\n");}
		;
constant :
		INT_CONSTANT {  $$=constant_action( $1 ); push($1);printf(" Rule 16.1: constant : INT_CONSTANT\n"); }
		|FLOAT_CONSTANT {$$=constant_action( $1 ); push($1);printf(" Rule 16.2: constant : FLOAT_CONSTANT\n");}
		|CHAR_CONSTANT  {$$=constant_action($1); printf(" Rule 16.3: constant : CHAR_CONSTANT\n");}		
		|BOOL_CONSTANT  {$$=true_action($1);  printf(" Rule 16.4: constant : BOOL_CONSTANT\n");}
		;

return_expr :
		expr        {$$ = $1->t_value; printf(" Rule 18: return_expr : expr\n");}
		;
		
block : 
		'{' var_decl_list statement_list '}'  {$$ = block_action($3);printf(" Rule 19: block : '{' var_decl_list statement_list '}'\n");}
		| '{' var_decl_list'}'  {printf(" Rule 19: block : '{' var_decl_list'}'\n");}
		| '{' statement_list '}'  {$$ = block_action($2); printf(" Rule 19: block : '{' statement_list '}'\n");}
		| '{''}'  {printf("blooooooock");$$ = empty_block_action(); printf(" Rule 19: block : '{' '}'\n");}
		;

var_decl_list :
		var_decl var_decl_list  {printf(" Rule : var_decl_list : var_decl var_decl_list\n");}
		| var_decl  {printf(" Rule : var_decl_list : var_decl \n");} 
		;
var_decl :
		type id_list ';'  	{printf(" Rule 20: var_decl : type id_list ';'\n");}
		;
id_list :
		ID ',' id_list 		{printf(" Rule 21.1: id_list : ID ',' id_list\n");}
		| ID 			{printf(" Rule 21.2: id_list : ID\n");}
		;
statement_list :
		statement_list M1 statement  {$$ = statement_list1_action($2,$1,$3);printf(" Rule 22: statement_list : statement statement_list\n");}
		| statement { $$ = statement_list2_action($1);printf(" Rule 22: statement_list : statement\n");}
		;

statement :
		 assignment ';'    {$$ = assignment_action();printf(" Rule 23.1: matched_statement : assignment ';'\n");}
		| method_call ';' {$$ = method_call_action();printf(" Rule 23.2: matched_statement : method_call ';'\n");}
		| IF_KW '(' expr ')' THEN_KW M1 block ';'   {printf("hello");$$=if_action($6,$3,$7);printf(" Rule 23.3: matched_statement : IF_KW '(' expr THEN_KW block ';'\n");}
		| IF_KW '(' expr ')' THEN_KW M1 block N ELSE_KW M1 block ';' {printf("hello2");$$=if_else_action($6,$10,$3,$7,$8,$11); printf(" Rule 23.3: statement : IF_KW '(' expr THEN_KW block ELSE_KW block ';'\n");}
		| WHILE_KW '(' M1 expr ')' M1 block ';' {$$ = while_action($3,$6,$4,$7);printf(" Rule 23.4: matched_statement : WHILE_KW '(' expr ')' block ';'\n");}
		| FOR_KW '(' for_initialize ';' expr ';' assignment ')' block ';' {printf(" Rule 23.5: matched_statement : FOR_KW '(' for_initialize ';' expr ';' assignment ')' block ';'\n");}
		|FOR_KW '(' ';' expr ';' assignment ')' block ';' {printf(" Rule 23.5: matched_statement : FOR_KW '(' ';' expr ';' assignment ')' block ';'\n");}
		|SWITCH_KW '(' ID ')' '{' case_statements '}' ';'  {printf(" Rule 23.6: matched_statement : SWITCH_KW '(' ID ')' '{' case_statements '}' ';'\n");}
		| SWITCH_KW '(' ID ')' '{'  '}' ';'  {printf(" Rule 23.6: matched_statement : SWITCH_KW '(' ID ')' '{'  '}' ';'\n");}
		| RETURN_KW return_expr ';'  {return_action($2);printf(" Rule 23.7: matched_statement : RETURN_KW return_expr ';'\n");}
		| BREAK_KW ';'  {printf(" Rule 23.8: matched_statement : BREAK_KW ';'\n");}
		| CONTINUE_KW ';'  {printf(" Rule 23.9: matched_statement : CONTINUE_KW ';'\n");}
		| block {printf(" Rule 23.10: matched_statement : block \n");}
		| READ_KW '(' ID ')' ';'  {printf(" Rule 23.11: matched_statement : READ_KW '(' ID ')' ';'\n");}
		| WRITE_KW '(' write_parameter ')' ';' {printf(" Rule 23.12: matched_statement : WRITE_KW '(' write_parameter ')' ';'\n");}
		| ';' {printf(" Rule 23.13: matched_statement : ';' \n");}
		;
		
		
case_statements :
		CASE_KW constant ':' statement case_statements {printf(" Rule 24.1: case_statement : CASE_KW constant ';' matched_statement case_statements\n");}
		| DEFAULT_KW ':' statement 	{printf(" Rule 24.2: case_statement : DEFAULT_KW ';' matched_statement\n");}
		| CASE_KW constant ':' statement {printf(" Rule 24.1: case_statement : CASE_KW constant ';' matched_statement \n");}
		;
write_parameter :
		expr 			{printf(" Rule 25.1: write_parameter : expr\n");}
		| STRING_CONSTANT 	{printf(" Rule 25.2: write_parameter : STRING_CONSTANT\n");}
		;
assignment :
		location '=' expr 	{codegen_assign(); printf(" Rule 26.1: assignment : location '=' expr\n");}
		|location 		{printf(" Rule 26.2: assignment : location\n");}
		;

for_initialize :
		assignment {printf(" Rule 27: for_initialize : assignment\n");}
		;
	
location :
		ID '[' expr ']'{$$ = bool_id($1); push($1); printf(" Rule 28.2: location : ID '[' expr ']'\n");}
		|ID {  $$ = bool_id($1); push($1);printf(" Rule 28.1: location : ID \n"); }
		;
		
expr :
		 location 		{$$ =$1; printf(" Rule 29.1: expr : location\n");}
		 |constant 		{$$ =$1; printf(" Rule 29.2: expr : constant\n");}
		 |'(' expr ')' 		{$$ =$2; printf(" Rule 29.3: expr : '(' expr ')'  \n");}
		 |method_call 		{printf(" Rule 29.4: expr : method_call\n");}
		 |operational_expr	{printf(" Rule 29.5: expr : operational_expr\n");}
		 ;


operational_expr:
		expr LT expr {$$=bool_emit_lt();  printf(" Rule 30.1: operational_expr: LT\n");}
		| expr LE expr 	{$$=bool_emit_le();printf(" Rule 30.2: operational_expr: LE\n");}
		| expr GT  expr {$$=bool_emit_gt();printf(" Rule 30.3: operational_expr: GT\n");}
		| expr GE  expr {$$=bool_emit_ge();printf(" Rule 30.4: operational_expr: GE\n");}
		| expr EQ  expr {$$=bool_emit_eq();printf(" Rule 30.5: operational_expr: EQ\n");}
		| expr NE  expr {$$=bool_emit_ne();printf(" Rule 30.6: operational_expr: NE\n");}
		| expr AND  expr 		{printf(" Rule 30.7: operational_expr: AND\n");}
		| expr OR  expr		{printf(" Rule 30.8: operational_expr: OR\n");}
		| expr AND_THEN M expr 		{$$ = and_action($1,$4,$3); printf(" Rule 30.9: operational_expr: AND_THEN\n");}
		| expr OR_ELSE M expr 		{$$ = or_action($1,$4,$3); printf(" Rule 30.10: operational_expr: OR_ELSE\n");}
		| expr PLUS {push($2);} expr	{codegen(); printf(" Rule 30.11: operational_expr: PLUS\n");}
		| expr MINUS {push($2); } expr	{codegen(); printf(" Rule 30.12: operational_expr: MINUS\n");}
		| expr MULT  {push($2);} expr 	{codegen(); printf(" Rule 30.13: operational_expr: MULT\n");}
		| expr DIV {push($2); } expr 	{codegen(); printf(" Rule 30.14: operational_expr: DIV\n");}
		| expr REM {push($2); } expr 	{codegen(); printf(" Rule 30.15: operational_expr: REM\n");}
		| SHR expr 			{printf(" Rule 30.16: operational_expr: SHR\n");}
		| SHL  expr 			{printf(" Rule 30.17: operational_expr: SHL\n");}
		| MINUS  expr %prec UMINUS	{codegen_uminus(); printf(" Rule 30.18: operational_expr: MINUS\n");}
		| NOT expr			{$$ = not_action($2); printf(" Rule 30.19: operational_expr: NOT\n");}
		;
M :  	        {$$=nextquad;};
M1 :  	        {$$=nextquad;};
N :		{$$=func();};
%%
int t = 0;
char num[5];

Eval* func(){
	Eval* n;
	if((n=malloc(sizeof(Eval)))==NULL)
		yyerror("out of memory");
	n->nextlist = makelist(nextquad);
	emit("goto","","","");
	return n;
}
Eval* codegen(){
  char tmp[2] = "t";
  snprintf(num,5,"%d",t);
  strcat(tmp,num);
  printf("t%d = %s %s %s\n",t,place.stk[place.top-2],place.stk[place.top-1],place.stk[place.top]);
  emit(place.stk[place.top-1],place.stk[place.top-2],place.stk[place.top],tmp);
  pop();
  pop();
  pop();
  push(tmp);
  t++;
  Eval* e;
  if((e=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
  //e->t_value = tmp;
int i =0;
	while(tmp[i]!='\0')                                                   
   	 {
        	e->t_value[i] = tmp[i];                                                    
        	i++;
    	 }
	 e->t_value[i] = tmp[i]; 
  return e;
}
void codegen_assign()
 {
 printf("%s = %s\n",place.stk[place.top-1],place.stk[place.top]);
 emit("=","",place.stk[place.top],place.stk[place.top-1]);
 pop();
 pop();
 }

Eval* codegen_uminus(){
  char tmp[2] = "t";
  snprintf(num,5,"%d",t);
  strcat(tmp,num);
  printf("t%d = -%s\n",t,place.stk[place.top]);
  emit("UMINUS",place.stk[place.top],"",tmp);
  pop();
  push(tmp);
  t++;
  Eval* e;
  if((e=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
  //e->t_value = tmp;
int i =0;
	while(tmp[i]!='\0')                                                   
   	 {
        	e->t_value[i] = tmp[i];                                                    
        	i++;
    	 }
	 e->t_value[i] = tmp[i]; 
  return e;
}
Eval* bool_emit_lt(){
  Eval* e;
  if((e=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
  e->truelist = makelist(nextquad+1);
  e->falselist = makelist(nextquad+2);
  
  char tmp[2] = "t";
 // display();
  char arg1[50] ; strcpy(arg1,place.stk[place.top-1]);
  char arg2[50] ;strcpy(arg2,place.stk[place.top]); 
  
  pop();
  pop();
  snprintf(num,5,"%d",t);
  strcat(tmp,num);
  push(tmp);
  t++;
  char arg[50] ;strcpy(arg,place.stk[place.top]);
  emit("<",arg1,arg2,tmp);
  emit("check",arg,"","");
  emit("goto","","","-"); 
  //e->t_value = tmp;
int i =0;
	while(tmp[i]!='\0')                                                   
   	 {
        	e->t_value[i] = tmp[i];                                                    
        	i++;
    	 }
	 e->t_value[i] = tmp[i]; 
  return e;
}
Eval* bool_emit_le(){
  Eval* e;
  if((e=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
  e->truelist = makelist(nextquad+1);
  e->falselist = makelist(nextquad+2);
  
  char tmp[2] = "t";
  //display();
  char arg1[50] ; strcpy(arg1,place.stk[place.top-1]);
  char arg2[50] ;strcpy(arg2,place.stk[place.top]); 
  
  pop();
  pop();
  snprintf(num,5,"%d",t);
  strcat(tmp,num);
  push(tmp);
  t++;
  char arg[50] ;strcpy(arg,place.stk[place.top]);
  emit("<=",arg1,arg2,tmp);
  emit("check",arg,"","");
  emit("goto","","","-"); 
  //e->t_value = tmp;
int i =0;
	while(tmp[i]!='\0')                                                   
   	 {
        	e->t_value[i] = tmp[i];                                                    
        	i++;
    	 }
	 e->t_value[i] = tmp[i]; 
  return e;
}
Eval* bool_emit_gt(){
  Eval* e;
  if((e=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
  e->truelist = makelist(nextquad+1);
  e->falselist = makelist(nextquad+2);
  
  char tmp[2] = "t";
 // display();
  char arg1[50] ; strcpy(arg1,place.stk[place.top-1]);
  char arg2[50] ;strcpy(arg2,place.stk[place.top]); 
  
  pop();
  pop();
  snprintf(num,5,"%d",t);
  strcat(tmp,num);
  push(tmp);
  t++;
  char arg[50] ;strcpy(arg,place.stk[place.top]);
  emit(">",arg1,arg2,tmp);
  emit("check",arg,"","");
  emit("goto","","","-"); 
  //e->t_value = tmp;
int i =0;
	while(tmp[i]!='\0')                                                   
   	 {
        	e->t_value[i] = tmp[i];                                                    
        	i++;
    	 }
	 e->t_value[i] = tmp[i]; 
  return e;
}
Eval* bool_emit_ge(){
  Eval* e;
  if((e=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
  e->truelist = makelist(nextquad+1);
  e->falselist = makelist(nextquad+2);
  
  char tmp[2] = "t";
 // display();
  char arg1[50] ; strcpy(arg1,place.stk[place.top-1]);
  char arg2[50] ;strcpy(arg2,place.stk[place.top]); 
  
  pop();
  pop();
  snprintf(num,5,"%d",t);
  strcat(tmp,num);
  push(tmp);
  t++;
  char arg[50] ;strcpy(arg,place.stk[place.top]);
  emit(">=",arg1,arg2,tmp);
  emit("check",arg,"","");
  emit("goto","","","-"); 
 // e->t_value = tmp;
int i =0;
	while(tmp[i]!='\0')                                                   
   	 {
        	e->t_value[i] = tmp[i];                                                    
        	i++;
    	 }
	 e->t_value[i] = tmp[i]; 
  return e;
}
Eval* bool_emit_eq(){
  Eval* e;
  if((e=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
  e->truelist = makelist(nextquad+1);
  e->falselist = makelist(nextquad+2);
  
  char tmp[2] = "t";
 // display();
  char arg1[50] ; strcpy(arg1,place.stk[place.top-1]);
  char arg2[50] ;strcpy(arg2,place.stk[place.top]); 
  
  pop();
  pop();
  snprintf(num,5,"%d",t);
  strcat(tmp,num);
  push(tmp);
  t++;
  char arg[50] ;strcpy(arg,place.stk[place.top]);
  emit("==",arg1,arg2,tmp);
  emit("check",arg,"","");
  emit("goto","","","-"); 
  //e->t_value = tmp;
int i =0;
	while(tmp[i]!='\0')                                                   
   	 {
        	e->t_value[i] = tmp[i];                                                    
        	i++;
    	 }
	 e->t_value[i] = tmp[i]; 
  return e;
}
Eval* bool_emit_ne(){
  Eval* e;
  if((e=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
  e->truelist = makelist(nextquad+1);
  e->falselist = makelist(nextquad+2);
  
  char tmp[2] = "t";
 // display();
  char arg1[50] ; strcpy(arg1,place.stk[place.top-1]);
  char arg2[50] ;strcpy(arg2,place.stk[place.top]); 
  
  pop();
  pop();
  snprintf(num,5,"%d",t);
  strcat(tmp,num);
  push(tmp);
  t++;
  char arg[50] ;strcpy(arg,place.stk[place.top]);
  emit("!=",arg1,arg2,tmp);
  emit("check",arg,"","");
  emit("goto","","","-"); 
  //e->t_value = tmp;
int i =0;
	while(tmp[i]!='\0')                                                   
   	 {
        	e->t_value[i] = tmp[i];                                                    
        	i++;
    	 }
	 e->t_value[i] = tmp[i]; 
  return e;
}
Eval* or_action(Eval* e1,Eval* e2, int mquad){
	//printf("mq: %d",mquad);
	//int n =(e1->falselist)[0];
	//printf("\nn:%d\n",n);
	backpatch(e1->falselist,mquad);
	//printf("\n1 or action\n");
	Eval* e;
	if((e=malloc(sizeof(Eval)))==NULL){
		yyerror("out of memory");}
	e->truelist = merge(e1->truelist , e2->truelist);
	e->falselist = e2->falselist;
	//quad_display();
	char tmp[2] = "t";
	snprintf(num,5,"%d",t);
  	strcat(tmp,num);
  	t++;
	//e->t_value = tmp;
int i =0;
	while(tmp[i]!='\0')                                                   
   	 {
        	e->t_value[i] = tmp[i];                                                    
        	i++;
    	 }
	 e->t_value[i] = tmp[i]; 
	return e;
}
Eval* and_action(Eval* e1,Eval* e2, int mquad){

	backpatch(e1->truelist,mquad);
	Eval* e;
	if((e=malloc(sizeof(Eval)))==NULL){
		yyerror("out of memory");}
	e->falselist = merge(e1->falselist , e2->falselist);
	e->truelist = e2->truelist;
	//quad_display();
	char tmp[2] = "t";
	snprintf(num,5,"%d",t);
  	strcat(tmp,num);
  	t++;
	//e->t_value = tmp;
int i =0;
	while(tmp[i]!='\0')                                                   
   	 {
        	e->t_value[i] = tmp[i];                                                    
        	i++;
    	 }
	 e->t_value[i] = tmp[i]; 
	return e;
}
Eval* not_action(Eval* e1){
	Eval* e;
	if((e=malloc(sizeof(Eval)))==NULL){
		yyerror("out of memory");}
	e->falselist = e1->truelist;
	e->truelist  = e1->falselist;
	//quad_display();
	char tmp[2] = "t";
	snprintf(num,5,"%d",t);
  	strcat(tmp,num);
  	t++;
	emit("!",place.stk[place.top],"",tmp);
	pop();
	push(tmp);
	//e->t_value = tmp;
int i =0;
	while(tmp[i]!='\0')                                                   
   	 {
        	e->t_value[i] = tmp[i];                                                    
        	i++;
    	 }
	 e->t_value[i] = tmp[i]; 
	return e;
}
Eval* par (Eval* e1){
	Eval* e;
	if((e=malloc(sizeof(Eval)))==NULL){
		yyerror("out of memory");}
	e->falselist = e1->falselist;
	e->truelist  = e1->truelist;

	//quad_display();
	return e;
}

Eval* bool_id(char* input){
  Eval* e;
  if((e=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
  e->truelist = makelist(nextquad);
  e->falselist = makelist(nextquad+1);
  //e->t_value = input;
int i =0;
	while(input[i]!='\0')                                                   
   	 {
        	e->t_value[i] = input[i];                                                    
        	i++;
    	 }
	 e->t_value[i] = input[i]; 
  return e;
  
}



Eval* while_action(int m1quad,int m2quad,Eval* e,Eval* s){
	
	Eval* s2 ;
	if((s2=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
	s2 -> nextlist = e->falselist;
//printf("\ns.nextlist: %d\n",*(s->nextlist));
	backpatch(s->nextlist,m1quad);
//printf("\nheloooooooooooooo\n");
	backpatch(e->truelist,m2quad);
	char num[5];
	snprintf(num,5,"%d",m1quad);
	emit("goto","","",num);
	//quad_display();
	return s2;
}
Eval* block_action(Eval* l){
//printf("\nheloooooooooooooo\n");
	Eval* s ;
	if((s=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
	s -> nextlist = l->nextlist;
	return s;
}

Eval* assignment_action(){

	Eval* s ;
	if((s=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
	s -> nextlist = makelist2();
	return s;
}
Eval* method_call_action(){
	Eval* s ;
	if((s=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
	s -> nextlist = makelist2();
	return s;
}

Eval* statement_list1_action(int m1quad , Eval* l1, Eval* s){
	Eval* l ;
	if((l=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
	l -> nextlist = s->nextlist;
	backpatch(l1->nextlist,m1quad);
	return l;
}
Eval* statement_list2_action(Eval* s){
	Eval* l ;
	if((l=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
	l -> nextlist = s->nextlist;
	return l;
}
Eval* empty_block_action(){
	Eval* e ;
	if((e=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
	e -> nextlist = makelist2();
	return e;
}
Eval* if_action(int m1quad,Eval* e,Eval* s){
	Eval* s2 ;
	if((s2=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
	backpatch(e->truelist , m1quad);
	s2 -> nextlist =merge(e->falselist,s->nextlist);
	//quad_display();
	return s2;
}
Eval* if_else_action(int m1quad, int m2quad, Eval* e,Eval* s1,Eval* n,Eval* s2){
	Eval* s ;
	if((s=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
	backpatch(e->truelist , m1quad);
	backpatch(e->falselist , m2quad);
	s -> nextlist =merge(s1->nextlist,merge(n->nextlist, s2->nextlist));
	//quad_display();
	return s;
}
Eval* constant_action(char* input){
	
	Eval* e ;
	if((e=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
	//e->t_value = input;
int i =0;
	while(input[i]!='\0')                                                   
   	 {
        	e->t_value[i] = input[i];                                                    
        	i++;
    	 }
	 e->t_value[i] = input[i];
	e -> nextlist = makelist(nextquad);
	return e;
}
Eval* true_action(char* bl){
	Eval* e ;
	if((e=malloc(sizeof(Eval)))==NULL)
	yyerror("out of memory");
	if(strcmp(bl,"TRUE") == 0){
		e -> truelist = makelist(nextquad);
		e -> falselist = makelist2();
		emit("goto","","","");
	}else if (strcmp(bl,"FALSE") == 0){
		e -> falselist = makelist(nextquad);
		e -> truelist = makelist2();
		emit("goto","","","");
	}
	printf("trueactionnnnnn");
	int i =0;
	while(bl[i]!='\0')                                                   
   	 {
        	e->t_value[i] = bl[i];                                                    
        	i++;
    	 }
	e->t_value[i] = bl[i];
	e -> nextlist = makelist(nextquad);
	return e;
}
void method_action(char* name){
	//printf("\nname =                                              %s\n",name);
	int i =0,j=0;
	/*for(i=call_q.front;i<call_q.rear;i++){
		j++;
		emit("param",call_q.q[i],"","");
	}*/
	 i =0,j=0;
	for(i=call_q.front;i<call_q.rear;i++){
		j++;
		emit("push",call_q.q[i],"","");
		dequeue();
	}
	
	//emit("call",name,num,"");
	snprintf(num,5,"%d",j);	
	emit("push",num,"","");///push n
	emit("push","_","","");//return value
	snprintf(num,5,"%d",nextquad+4);
	emit("push",num,"","");//push (p1)
	emit("push","SP","","");//push SP
	emit("=","","TOP","SP");// SP=Top
	emit("goto","","",name);//goto function

	//quad_display();
	

}
void return_action(char * rt){
	//int i =0;
	//while(rt[i]!='\0')                                                   
   	// {
        //	activation.stk[SP + 1][i] = rt[i];                                                    
        //	i++;
    	 //}
	 //activation.stk[SP + 1][i] = rt[i];
	//activation.stk[SP + 1] = rt;//return value
	//activation.top = SP+2;
	//SP = *SP;
	//L = *top;
	//activation.top = activation.top+1;
	//activation.top = activation.top+1 + *activation.top;
	//goto L

	emit("+","SP","3","Top");
	emit("push",rt,"","");
	emit("+","SP","1","Top");
	emit("star","SP","","Top");
	emit("star","Top","","L");
	emit("+","TOP","2","Top");
	char tmp[2] = "t";
	snprintf(num,5,"%d",t);
  	strcat(tmp,num);
  	t++;
	emit("star","Top","",tmp);
	emit("+",tmp,"Top","Top");
	emit("+","TOP","1","Top");
	emit("goto","","","L");

		
}

void tocode(){
int i;
for(i=0; i<=nextquad-1; i++){
	//quad_ruples
	if( strcmp(quad_ruples[i][0],"goto")==0){
		printf("\n%d : goto %s ;",i,quad_ruples[i][3]);
	}else if (strcmp(quad_ruples[i][0],"check")==0){
		printf("\n%d : if( %s )  goto %s",i,quad_ruples[i][1],quad_ruples[i][3]);
	}else if (strcmp(quad_ruples[i][0],"<")==0 || strcmp(quad_ruples[i][0],"<=")==0 || 
		  strcmp(quad_ruples[i][0],">")==0  || strcmp(quad_ruples[i][0],">=")==0 
		  || strcmp(quad_ruples[i][0],"==")==0
		  || strcmp(quad_ruples[i][0],"!=")==0
		  || strcmp(quad_ruples[i][0],"+")==0
		  || strcmp(quad_ruples[i][0],"-")==0
		  || strcmp(quad_ruples[i][0],"*")==0
		  || strcmp(quad_ruples[i][0],"/")==0
		  || strcmp(quad_ruples[i][0],"%")==0){
		printf("\n%d : %s =  %s %s %s ;",i,quad_ruples[i][3] , quad_ruples[i][1] ,quad_ruples[i][0] ,quad_ruples[i][2] );}else if (strcmp(quad_ruples[i][0],"=")==0){
		printf("\n%d : %s = %s",i,quad_ruples[i][3],quad_ruples[i][2]);
	}else if (strcmp(quad_ruples[i][0],"UMINUS")==0){
		printf("\n%d : %s = -%s",i,quad_ruples[i][3],quad_ruples[i][1]);
	}else if (strcmp(quad_ruples[i][0],"push")==0){
		printf("\n%d : push %s",i,quad_ruples[i][1]);
	}else if (strcmp(quad_ruples[i][0],"star")==0){
		printf("\n%d : %s = * %s",i,quad_ruples[i][3],quad_ruples[i][1]);
	}else if (strcmp(quad_ruples[i][0],"call")==0){
		printf("\n%d : call %s, %s",i,quad_ruples[i][1],quad_ruples[i][2]);
	}else if (strcmp(quad_ruples[i][0],"!")==0){
		printf("\n%d : %s = !%s",i,quad_ruples[i][3],quad_ruples[i][1]);
	}
	
	
}

}

yyerror(s)
{
fprintf(stderr, "%d\n", s);
}
int main(void){
return yyparse();
}



