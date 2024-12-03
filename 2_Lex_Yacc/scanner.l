%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Token definitions
#define INT 1
#define BOOL 2
#define STRUCT 3
#define IF 4
#define ELSE 5
#define WHILE 6
#define DO 7
#define READ 8
#define WRITE 9
#define PROGRAM_START 10
#define END 11
#define THEN 12
#define TRUE 13
#define FALSE 14
#define IDENTIFIER 15
#define INTEGER 16
#define ASSIGN 17
#define EQUALS 18
#define EQEQ 19
#define LESS_THAN 20
#define LESS_THAN_EQUAL 21
#define GREATER_THAN 22
#define GREATER_THAN_EQUAL 23
#define MOD 24
#define PLUS 25
#define MINUS 26
#define STAR 27
#define SLASH 28
#define LPAREN 29
#define RPAREN 30
#define LBRACE 31
#define RBRACE 32
#define LBRACKET 33
#define RBRACKET 34
#define SEMICOLON 35
#define WHITESPACE 36

// Define a basic symbol table structure
typedef struct {
    char *name;
    int token;
} Symbol;

// Global list for Symbol Table (ST)
Symbol symbol_table[100];
int symbol_count = 0;

%}

%%

"int"          { return INT; }
"bool"         { return BOOL; }
"struct"       { return STRUCT; }
"if"           { return IF; }
"else"         { return ELSE; }
"while"        { return WHILE; }
"do"           { return DO; }
"read"         { return READ; }
"write"        { return WRITE; }
"begin"        { return PROGRAM_START; }
"end"          { return END; }
"then"         { return THEN; }
"true"         { return TRUE; }
"false"        { return FALSE; }

[0-9]+         { return INTEGER; }
[a-zA-Z][a-zA-Z0-9]* {
    // Check if identifier is in symbol table, if not add it
    for(int i = 0; i < symbol_count; i++) {
        if(strcmp(symbol_table[i].name, yytext) == 0) {
            return IDENTIFIER;
        }
    }
    symbol_table[symbol_count].name = strdup(yytext);  // Add new identifier to symbol table
    symbol_table[symbol_count].token = IDENTIFIER;
    symbol_count++;
    return IDENTIFIER;
}

"="            { return EQUALS; }
":="           { return ASSIGN; }
"=="           { return EQEQ; }
"<"            { return LESS_THAN; }
"<="           { return LESS_THAN_EQUAL; }
">"            { return GREATER_THAN; }
">="           { return GREATER_THAN_EQUAL; }
"%"            { return MOD; }
"+"            { return PLUS; }
"-"            { return MINUS; }
"*"            { return STAR; }
"/"            { return SLASH; }

"("            { return LPAREN; }
")"            { return RPAREN; }
"{"            { return LBRACE; }
"}"            { return RBRACE; }
"["            { return LBRACKET; }
"]"            { return RBRACKET; }
";"            { return SEMICOLON; }

[ \t\n\r]+     { /* Ignore whitespace */ }

.              { printf("Lexical error at line %d: Invalid token %s\n", yylineno, yytext); }

%%

int yywrap(void) {
    return 1;
}

int main() {
    int token;
    printf("Scanning input...\n");

    while((token = yylex()) != 0) {
        // Output PIF (Program Internal Form) with line number
        printf("Line %d: Token: %d, Lexeme: %s\n", yylineno, token, yytext);

        // Print symbol table for identifiers
        if (token == IDENTIFIER) {
            printf("Symbol Table Entry: %s\n", yytext);
        }
    }

    // Print entire Symbol Table at the end
    printf("\nSymbol Table:\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("Symbol: %s\n", symbol_table[i].name);
    }

    return 0;
}
