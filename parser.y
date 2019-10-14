%{
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#define MAXCHILD 10
void yyerror (char *s);
int yylex();
extern int yyparse();
extern FILE* yyin;
extern int yylineno;

int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);


char* tab="  ";
char indent[100]="";

char* integer="INT";
char* floating="float";
char* none = "none";
char* assign = "=";

void incIndent(){
    strcat(indent, tab);
}
void decIndent(){
    int len = strlen(indent);
    indent[len-2]='\0';
}

struct treeNode{
    struct treeNode *child[MAXCHILD];
    char* nodeType;
    char* string;
    char* value;
    char* dataType;
    int lineNo;
    int Nchildren;
};
void printNode(struct treeNode* node){
    printf("%s<Tree lineNo=\"%d\" nodeType=\"%s\" string=\"%s\" value=\"%s\" dataType=\"%s\">\n", 
        indent,
        node->lineNo,
        node->nodeType,
        node->string,
        node->value, 
        node->dataType);
    int i;
    if (node->Nchildren > 0){
        printf("%s<Child>\n", indent);
        incIndent();
        for (i=0;i<node->Nchildren;i++){
            printNode(node->child[i]);
        }
        decIndent();
        printf("%s</Child>\n", indent);
    }
    printf("%s</Tree>\n", indent);
}

struct treeNode * newnode(int lineNo, char* nodeType, 
							char* string, char* value, 
								char* dataType, int Nchildren, ...){

    struct treeNode * node = (struct treeNode*) malloc(sizeof(struct treeNode));
    node->nodeType = nodeType;
    node->string = string;
    node->value = value;
    node->dataType = dataType;
    node->lineNo = lineNo;
    node->Nchildren = Nchildren;
    va_list ap;
    int i;
    va_start(ap, Nchildren);
    for (i=0;i<Nchildren;i++){
        node->child[i]=va_arg(ap, struct treeNode *);
    }
    va_end(ap);
    return node;
}


%}

%union {
	char* str;
	struct treeNode * ast;
}

%start Program
%token VOID INTEGER DOUBLE BOOL STRING 
%token CLASS INTERFACE NULLN THIS EXTENDS IMPLEMENTS 
%token FOR WHILE IF ELSE RETURN BREAK NEW NEWARRAY 
%token PRINT READINTEGER READLINE TRUE FALSE 
%token<str> ID
%token COMMA POINT LFTBRCKT RGHBRCKT LFTPARTH RGHPARTH SEMICLN 
%token LFTGATE RGHGATE STRINGERROR INVCHAR INVESCP 
%token LINEJMP TAB SPACE INTVAL DOUBLEVAL STRINGVAL

%left SUM SUB MULT DIV LESSTHN LESSEQL GREATERTHN
%left GREATEREQL EQUAL SAME DIFF AND OR NOT

%type<str> Type
%type<ast> Variable VariableDecl Decl Program
%%

Program: Decl {printf("f");printNode($1);}
;
Decl: VariableDecl {printf("d");$$=$1;}
;
VariableDecl: Variable {printf("c");$$=$1;}
;
Variable: Type SPACE ID  {
			printf("b");
			$$=newnode(yylineno, "variable", none, none, $1, 0); 
			}
;
Type: 	INTEGER 	{printf("a");$$="INTEGER";}
		| DOUBLE 	{printf("double");}
		| BOOL 		{printf("boolean");} 
		| STRING 	{printf("string");}
		| ID 		{printf("identificador");}
;

%%        
             /* C code */

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror (char *s) {
	fprintf (stderr, "%s\n", s);} 
