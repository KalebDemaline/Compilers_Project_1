	// Jansen Craft & Kaleb Demaline 
	
%{
	// Declarations

#include <iostream>
#include <algorithm>
#include <map>
#include <iomanip>

using namespace std;

#define TK_OPEN_P 1
#define TK_CLOSED_P 2
#define TK_OPEN_CB 3
#define TK_CLOSED_CB 4
#define TK_OPEN_SB 5
#define TK_CLOSED_SB 6
#define TK_SEMICOLON 7
#define TK_COMMA 8
#define TK_NUMBER_LITERAL 9
#define TK_STRING_LITERAL 10
#define TK_CHAR_LITERAL 11
#define TK_PLUS 12
#define TK_MINUS 13
#define TK_EXCLAMATION 14
#define TK_TILDA 15
#define TK_AMPERSAND 16
#define TK_ASTERISK 17
#define TK_EQUAL 18
#define TK_FORWARD_SLASH 19
#define TK_PERCENT 20
#define TK_CARET 21
#define TK_GREATER 22
#define TK_LESS 23
#define TK_QUESTION 24
#define TK_PIPE 25
#define TK_INT 26
#define TK_FLOAT 27
#define TK_CHAR 28
#define TK_VOID 29
#define TK_WHILE 30
#define TK_FOR 31
#define TK_DO 32
#define TK_IF 33
#define TK_ELSE 34
#define TK_SWITCH 35
#define TK_CASE 36
#define TK_DEFAULT 37
#define TK_BREAK 38
#define TK_CONTINUE 39
#define TK_RETURN 40
#define TK_GOTO 41
#define TK_IDENTIFIER 42

int linecount = 1;

void count_newlines(const char* yytext) {linecount += count(yytext, yytext + strlen(yytext), '\n');}

%}

F [a-zA-Z0-9_]
D [0-9]
INT "int"|"short"|"unsigned int"|"unsigned short"|"long"|"unsigned long"|"long long"|"unsigned long long"
FLOAT "float"|"double"|"long double"

%%
	// Translation Rules

\/\/.*\n					{	linecount++;				}
"/*"([^*]*|[*][^/])*"*/"	{	count_newlines(yytext);		}
#include\ *<[a-z.]*>		{ 	/*Do Nothing*/				}
#include\ *\"[a-z.]*\"		{ 	/*Do Nothing*/				}
\(							{	return TK_OPEN_P;			}
\)							{	return TK_CLOSED_P;			}
\{							{	return TK_OPEN_CB;			}
\}							{	return TK_CLOSED_CB;		}
\[							{	return TK_OPEN_SB;			}
\]							{	return TK_CLOSED_SB;		}
\;							{	return TK_SEMICOLON;		}
\,							{	return TK_COMMA;			}
\"[^\"]*\"					{	count_newlines(yytext);
								return TK_STRING_LITERAL;	}
\'[^\']{1,2}\'				{	return TK_CHAR_LITERAL;		}
({D}*\.{D}*)|{D}+			{	return TK_NUMBER_LITERAL;	}
\+							{	return TK_PLUS;				}
\-							{	return TK_MINUS;			}
\!							{	return TK_EXCLAMATION;		}
\~							{	return TK_TILDA;			}
\&							{	return TK_AMPERSAND;		}
\*							{	return TK_ASTERISK;			}
\=							{	return TK_EQUAL;			}
\/							{	return TK_FORWARD_SLASH;	}
\%							{	return TK_PERCENT;			}
\^							{	return TK_CARET;			}
\>							{	return TK_GREATER;			}
\<							{	return TK_LESS;				}
\?							{	return TK_QUESTION;			}
\|							{	return TK_PIPE;				}
{INT}						{	return TK_INT;				}
{FLOAT}						{	return TK_FLOAT;			}
"void"						{	return TK_VOID;				}
"char"						{	return TK_CHAR;				}
"while"						{	return TK_WHILE;			}
"for" 						{ 	return TK_FOR;				}
"do" 						{ 	return TK_DO;				}
"if" 						{ 	return TK_IF;				}
"else" 						{ 	return TK_ELSE;				}
"switch" 					{ 	return TK_SWITCH;			}
"case" 						{ 	return TK_CASE;				}
"default" 					{ 	return TK_DEFAULT;			}
"break" 					{ 	return TK_BREAK;			}
"continue" 					{ 	return TK_CONTINUE;			}
"return" 					{ 	return TK_RETURN;			}
"goto"						{ 	return TK_GOTO;				}
{F}+						{	return TK_IDENTIFIER;		}
[ \t\n\f]					{	count_newlines(yytext);		}
.							{ 	/*Do Nothing*/				}

%%
	// Auxilliary

int yywrap() {return 1;}

int main() {
	int token = 0;
	token = yylex();
	while(token){
		cout << setfill ('0') << std::setw (2) << token << ' ';
		token = yylex();
	}
}	