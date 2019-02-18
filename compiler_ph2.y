%{
#include<stdio.h>
#include<stdlib.h>
%}

%token PROGRAM_KW WHILE_KW IF_KW FOR_KW SWITCH_KW CASE_KW DEFAULT_KW RETURN_KW BREAK_KW CONTINUE_KW READ_KW 
%token WRITE_KW ELSE_KW THEN_KW INT_KW FLOAT_KW CHAR_KW BOOL_KW VOID_KW CALLOUT_KW BOOL_CONSTANT
%token '[' ']' '{' '}' '(' ')' ',' ';' '=' 
%token ID CHAR_CONSTANT INT_CONSTANT FLOAT_CONSTANT STRING_CONSTANT
%left AND_THEN OR_ELSE
%left AND OR EQ NE LT LE GT GE
%left MINUS PLUS 
%left MULT DIV REM 
%left SHR SHL NOT

%%
program :
		PROGRAM_KW ID  '{' field_decl_list method_decl_list '}'  {printf(" Rule 1:  Rule : program: PROGRAM_KW ID  '{' field_decl_list method_decl_list '}'\n");}
		|PROGRAM_KW ID  '{' field_decl_list '}'  {printf(" Rule 1:  Rule : program: PROGRAM_KW ID  '{' field_decl_list '}'\n");}
		|PROGRAM_KW ID  '{' method_decl_list '}'  {printf(" Rule 1:  Rule : program: PROGRAM_KW ID  '{'  method_decl_list '}'\n");}
		|PROGRAM_KW ID  '{'  '}'  {printf(" Rule 1:  Rule : program: PROGRAM_KW ID  '{'  '}'\n");}
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
		|type ID '(' ')' block {printf(" Rule 7: method_decl: return_type ID '(' ')' block \n");}
		|VOID_KW ID '(' ')' block {printf(" Rule 7: method_decl: return_type ID '(' ')' block \n");}
				
		;
		
method_call :
		ID '(' actual_parameters ')' {printf(" Rule 8.1: method_call : ID '(' actual_parameters ')'\n");}
		|CALLOUT_KW '(' STRING_CONSTANT callout_parameters ')' {printf(" Rule 8.2: method_call : CALLOUT_KW '(' STRING_CONSTANT callout_parameters ')' \n");}
		| ID '(' ')' {printf(" Rule 8.1: method_call : ID '(' ')'\n");}
		;
actual_parameters:
		actual_parameters_list {printf(" Rule 9: actual_parameters: actual_parameters_list\n");}
		;
actual_parameters_list :
		expr ',' actual_parameters_list {printf(" Rule 10.1: actual_parameters_list : expr ',' actual_parameters_list\n");}
		|expr {printf(" Rule 10.2: actual_parameters_list : expr\n");}
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
		INT_CONSTANT    {printf(" Rule 16.1: constant : INT_CONSTANT\n");}
		|FLOAT_CONSTANT {printf(" Rule 16.2: constant : FLOAT_CONSTANT\n");}
		|CHAR_CONSTANT  {printf(" Rule 16.3: constant : CHAR_CONSTANT\n");}		
		|BOOL_CONSTANT  {printf(" Rule 16.4: constant : BOOL_CONSTANT\n");}
		;

return_expr :
		expr        {printf(" Rule 18: return_expr : expr\n");}
		;
		
block : 
		'{' var_decl_list statement_list '}'  {printf(" Rule 19: block : '{' var_decl_list statement_list '}'\n");}
		| '{' var_decl_list'}'  {printf(" Rule 19: block : '{' var_decl_list'}'\n");}
		| '{' statement_list '}'  {printf(" Rule 19: block : '{' statement_list '}'\n");}
		| '{' '}'  {printf(" Rule 19: block : '{' '}'\n");}
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
		statement statement_list {printf(" Rule 22: statement_list : statement statement_list\n");}
		| statement {printf(" Rule 22: statement_list : statement\n");}
		;
statement :
		assignment ';'    {printf(" Rule 23.1: statement : assignment ';'\n");}
		| method_call ';' {printf(" Rule 23.2: statement : method_call ';'\n");}
		| IF_KW '(' expr ')' THEN_KW block ';'   {printf(" Rule 23.3: statement : IF_KW '(' expr THEN_KW block ';'\n");}
		| IF_KW '(' expr ')' THEN_KW block ELSE_KW block ';' {printf(" Rule 23.3: statement : IF_KW '(' expr THEN_KW block ELSE_KW block ';'\n");}
		| WHILE_KW '(' expr ')' block ';' {printf(" Rule 23.4: statement : WHILE_KW '(' expr ')' block ';'\n");}
		| FOR_KW '(' for_initialize ';' expr ';' assignment ')' block ';' {printf(" Rule 23.5: statement : FOR_KW '(' for_initialize ';' expr ';' assignment ')' block ';'\n");}
		|FOR_KW '(' ';' expr ';' assignment ')' block ';' {printf(" Rule 23.5: statement : FOR_KW '(' ';' expr ';' assignment ')' block ';'\n");}
		|SWITCH_KW '(' ID ')' '{' case_statements '}' ';'  {printf(" Rule 23.6: statement : SWITCH_KW '(' ID ')' '{' case_statements '}' ';'\n");}
		| SWITCH_KW '(' ID ')' '{'  '}' ';'  {printf(" Rule 23.6: statement : SWITCH_KW '(' ID ')' '{'  '}' ';'\n");}
		| RETURN_KW return_expr ';'  {printf(" Rule 23.7: statement : RETURN_KW return_expr ';'\n");}
		| BREAK_KW ';'  {printf(" Rule 23.8: statement : BREAK_KW ';'\n");}
		| CONTINUE_KW ';'  {printf(" Rule 23.9: statement : CONTINUE_KW ';'\n");}
		| block {printf(" Rule 23.10: statement : block \n");}
		| READ_KW '(' ID ')' ';'  {printf(" Rule 23.11: statement : READ_KW '(' ID ')' ';'\n");}
		| WRITE_KW '(' write_parameter ')' ';' {printf(" Rule 23.12: statement : WRITE_KW '(' write_parameter ')' ';'\n");}
		| ';' {printf(" Rule 23.13: statement : ';' \n");}
		;
case_statements :
		CASE_KW constant ':' statement case_statements {printf(" Rule 24.1: case_statement : CASE_KW constant ';' statement case_statements\n");}
		| DEFAULT_KW ':' statement 	{printf(" Rule 24.2: case_statement : DEFAULT_KW ';' statement\n");}
		| CASE_KW constant ':' statement {printf(" Rule 24.1: case_statement : CASE_KW constant ';' statement \n");}
		;
write_parameter :
		expr 			{printf(" Rule 25.1: write_parameter : expr\n");}
		| STRING_CONSTANT 	{printf(" Rule 25.2: write_parameter : STRING_CONSTANT\n");}
		;
assignment :
		location '=' expr 	{printf(" Rule 26.1: assignment : location '=' expr\n");}
		|location 		{printf(" Rule 26.2: assignment : location\n");}
		;

for_initialize :
		assignment {printf(" Rule 27: for_initialize : assignment\n");}
		;
	
location :
		ID {printf(" Rule 28.1: location : ID\n");}
		|ID '[' expr ']'{printf(" Rule 28.2: location : ID '[' expr ']'\n");}
		;
		
expr :
		 location 		{printf(" Rule 29.1: expr : location\n");}
		 |constant 		{printf(" Rule 29.2: expr : constant\n");}
		 |'(' expr ')' 		{printf(" Rule 29.3: expr : '(' expr ')'  \n");}
		 |method_call 		{printf(" Rule 29.4: expr : method_call\n");}
		 |operational_expr	{printf(" Rule 29.5: expr : operational_expr\n");}
		 ;


operational_expr:
		expr LT expr 			{printf(" Rule 30.1: operational_expr: LT\n");}
		| expr LE expr 			{printf(" Rule 30.2: operational_expr: LE\n");}
		| expr GT  expr 		{printf(" Rule 30.3: operational_expr: GT\n");}
		| expr GE  expr 		{printf(" Rule 30.4: operational_expr: GE\n");}
		| expr EQ  expr 		{printf(" Rule 30.5: operational_expr: EQ\n");}
		| expr NE  expr 		{printf(" Rule 30.6: operational_expr: NE\n");}
		| expr AND  expr 		{printf(" Rule 30.7: operational_expr: AND\n");}
		| expr OR  expr 		{printf(" Rule 30.8: operational_expr: OR\n");}
		| expr AND_THEN expr 		{printf(" Rule 30.9: operational_expr: AND_THEN\n");}
		| expr OR_ELSE expr 		{printf(" Rule 30.10: operational_expr: OR_ELSE\n");}
		| expr PLUS expr 		{printf(" Rule 30.11: operational_expr: PLUS\n");}
		| expr MINUS expr 		{printf(" Rule 30.12: operational_expr: MINUS\n");}
		| expr MULT expr 		{printf(" Rule 30.13: operational_expr: MULT\n");}
		| expr DIV expr 		{printf(" Rule 30.14: operational_expr: DIV\n");}
		| expr REM expr 		{printf(" Rule 30.15: operational_expr: REM\n");}
		| SHR expr 			{printf(" Rule 30.16: operational_expr: SHR\n");}
		| SHL  expr 			{printf(" Rule 30.17: operational_expr: SHL\n");}
		| MINUS  expr  			{printf(" Rule 30.18: operational_expr: MINUS\n");}
		| NOT expr			{printf(" Rule 30.19: operational_expr: NOT\n");}
		;

%%
char *s;
yyerror(s)
{
fprintf(stderr, "%s\n", s);
}
int main(void){
return yyparse();
}

