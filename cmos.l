%{
	// Declarations

#include <iostream>

using namespace std;

#define CTOKEN 69
#define TKUNMATCHED 70
int linecount = 1;
int num_of_c = 0;

void check_for_newline(char c) {if(c == '\n') linecount++;}

void increment_c() {num_of_c++;}

int line_num() {return linecount;}

int num_c() {return num_of_c;}

%}

D [0-9]
OD [0-9Xx#*$]

%%
	// Translation Rules

c							{ 	increment_c();
								return CTOKEN;
							}

[ \t\n\f]					{	check_for_newline(yytext[0]); }

.							{ 	return TKUNMATCHED;	}

%%
	// Auxilliary

int yywrap() {return 1;}

int main() {
	int token = 0;
	token = yylex();
	while(token){
		switch (token) {
			case CTOKEN:
				cout << "Found C #" << num_c() << " on line " << line_num() << "\n";
				break;
			case TKUNMATCHED:
				break;
			}
		token = yylex();
	}
}	