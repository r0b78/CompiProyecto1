%option nounput yylineno
%{
#include "proyecto1Parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

%%
"void"                  return VOID;
"int"                   return INTEGER;
"double"                return DOUBLE;
"bool"                  return BOOL;
"string"                return STRING;
"class"                 return INTEGER;
"interface"             return INTERFACE;
"null"                  return NULLN;
"this"                  return THIS;
"extends"               return EXTENDS;
"implements"            return IMPLEMENTS;
"for"                   return FOR;
"while"                 return WHILE;
"if"                    return IF;
"else"                  return ELSE;
"return"                return RETURN;
"break"                 return BREAK;
"New"                   return NEW;
"NewArray"              return NEWARRAY;
"Print"                 return PRINT;
"ReadInteger"           return READINTEGER;
"ReadLine"              return READLINE;
"true"                  return TRUE;
"false"                 return FALSE;
[a-zA-Z][_a-zA-Z0-9]{0,30}   {yylval.str = strdup(yytext);return ID;}
[0-9]+[a-wA-WyzYZ][_a-zA-Z0-9]* return INVCHAR;
["][^"\n]*["]           return STRINGVAL;
["][^"\n]*[\n]          return STRINGERROR;
["][^"\n]*[\n]["]       return STRINGERROR;
[1-9][0-9]*             return INTVAL;
[0][Xx]+[0-9a-fA-F]*     return INTVAL;
[0-9]+[.][0-9]+          return DOUBLEVAL;
[0-9]+[.][E][+][1-9][0-9]* return DOUBLEVAL;
[+]                     return SUM;
[-]                     return SUB;
[*]                     return MULT;
[/]                     return DIV;
[<]                     return LESSTHN;
"<="                    return LESSEQL;
[>]                     return GREATERTHN;
">="                    return GREATEREQL;
"="                     return EQUAL;
"=="                    return SAME;
[!][=]                    return DIFF;
[&][&]                    return AND;
[|][|]                    return OR;
"!"                     return NOT;
[;]                     return SEMICLN;
[,]                     return COMMA;
[.]                     return POINT;
[[]                     return LFTBRCKT;
[]]                     return RGHBRCKT;
[(]                     return LFTPARTH;
[)]                     return RGHPARTH;
[{]                     return LFTGATE;
[}]                     return RGHGATE;
[/][/][ _a -zA -Z0 -9 ]*     ;
[/*][ _a -zA -Z0 -9\n]*[*/] ;
.*[\\][^ntabfnr'"\\?x].*    return INVESCP;
[\t]                 return TAB;
[\n]                 return LINEJMP;
[ ]                  return SPACE;
.                       return INVCHAR;

%%

struct Node{
    void *data;
    struct Node *next;
};

void add(struct Node** head, void *new, size_t size){
    struct Node* newNode = (struct Node*)malloc(sizeof(struct Node));
    newNode->data  = malloc(size);
    memcpy(newNode->data,new,size);
    newNode->next = NULL;
    if(*head == NULL){
        *head = newNode;

    }
    else{
        struct Node* pointer = *head;


        while(pointer->next!=NULL){
        pointer = pointer->next;
       }
        pointer->next = newNode;
    }



}

void printInt(struct Node *nodeLine,struct Node *nodeColumn,struct Node *nodeToken,struct Node *nodeValue){
    printf("Line\t\t Column\t\t Token\t\t Value\t\t\n");
    while(nodeLine!=NULL){
        printf(" %d\t\t %d\t\t %d\t\t %s\n",*(int *)nodeLine->data,*(int *)nodeColumn->data,*(int *)nodeToken->data,*(char **)nodeValue->data);
        nodeLine = nodeLine->next;
        nodeColumn = nodeColumn->next;
        nodeToken = nodeToken->next;
        nodeValue = nodeValue->next;
    }

}
// void main()
// {
//  char* p;
//  int columnNumber = 1;
//  char empty[] = " ";
//  struct Node *lineStart = NULL;
//  struct Node *columnStart = NULL;
//  struct Node *tokenStart = NULL;
//  struct Node *valueStart = NULL;
//  int token;
//  token = yylex();
//  while(token){
//         printf(" %d\n",token);
//     switch (token){
//         case STRINGERROR:
//              printf("String no cerrado en la linea %d columna %d\n",yylineno-1,columnNumber);
//              return;
//              break;
//         case INVCHAR:
//              printf("Caracter ilegal en la linea %d columna %d\n",yylineno,columnNumber);
//              return;
//              break;
//         case INVESCP:
//              printf("Secuencia de escape ilegal en la linea %d columna %d\n",yylineno,columnNumber);
//              return;
//              break;
//        case  LINEJMP:
//              columnNumber =1;
//              token = yylex();
//              continue;
//              break;
//        case TAB:
//              token = yylex();
//              columnNumber= columnNumber+1;
//              continue;
//              break;
//        case SPACE:
//             token = yylex();
//             columnNumber= columnNumber+1;
//             continue;
//             break;
//        case INTVAL:
//             add(&valueStart,&yytext,sizeof(char *));
//             add(&lineStart,&yylineno,sizeof(yylineno));
//             add(&columnStart,&columnNumber,sizeof(columnNumber));
//             add(&tokenStart,&token,sizeof(token));
//             token = yylex();
//             columnNumber= columnNumber+1;
//             continue;
//             break;
//        case DOUBLEVAL:
//             add(&valueStart,&yytext,sizeof(char *));
//             add(&lineStart,&yylineno,sizeof(yylineno));
//             add(&columnStart,&columnNumber,sizeof(columnNumber));
//             add(&tokenStart,&token,sizeof(token));
//             token = yylex();
//             columnNumber= columnNumber+1;
//             continue;
//             break;
//        case STRINGVAL:
//             add(&valueStart,&yytext,sizeof(char *));
//             add(&lineStart,&yylineno,sizeof(yylineno));
//             add(&columnStart,&columnNumber,sizeof(columnNumber));
//             add(&tokenStart,&token,sizeof(token));
//             token = yylex();
//             columnNumber= columnNumber+1;
//             continue;
//             break;
//       case TRUE:
//             add(&valueStart,&yytext,sizeof(char *));
//             add(&lineStart,&yylineno,sizeof(yylineno));
//             add(&columnStart,&columnNumber,sizeof(columnNumber));
//             add(&tokenStart,&token,sizeof(token));
//             token = yylex();
//             columnNumber= columnNumber+1;
//             continue;
//             break;
//        case FALSE:
//             add(&valueStart,&yytext,sizeof(char *));
//             add(&lineStart,&yylineno,sizeof(yylineno));
//             add(&columnStart,&columnNumber,sizeof(columnNumber));
//             add(&tokenStart,&token,sizeof(token));
//             token = yylex();
//             columnNumber= columnNumber+1;
//             continue;
//             break;

//     }

//     add(&valueStart,&empty,sizeof(char *));
//     add(&lineStart,&yylineno,sizeof(yylineno));
//     add(&columnStart,&columnNumber,sizeof(columnNumber));
//     add(&tokenStart,&token,sizeof(token));
//     columnNumber = columnNumber + yyleng-1;
//     token = yylex();
//     columnNumber = columnNumber+1;

//  }
//  printInt(lineStart,columnStart,tokenStart,valueStart);
// }
