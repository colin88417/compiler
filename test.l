%{
#include <string>
#include <vector>
#include <map>
using namespace std;

#define LIST strcat(buf,yytext)
#define token(t) {LIST; printf("<%s>\n",#t);}
#define tokenInteger(t,i) {LIST; printf("<%s:%d>\n",#t,i);}
#define tokenString(t,s) {LIST; printf("<%s:%s>\n",#t,s);}
#define tokenChar(t){LIST;printf("<%c>\n",t)}

#define MAX_LINE_LENG 256

class SymbolTable {
  private:
    vector<string> symbols;
    map<string, int> table_map;
    int index;
  public:
    SymbolTable();
    int lookup(string stringwords);
    int insert(string stringwords);
    int dump();
};
int linenum = 1;
char buf[MAX_LINE_LENG];

	SymbolTable *table;
%}

DELIMITER               (,:,:;()[\]{}])
single_COMMENT          (\/\/[^\n]*)
begin_COMMENT           (\/\*)
end_COMMENT             (\*\/)
IDENTIFIER              ([A-Za-z_][0-9A-Za-z_]*))
DIGIT                  	([0-9]+)
INTEGER                 ({DIGIT})
STRING                  (\"(\"\"|[^"\n])*\")
REAL                    ([+-]?{DIGIT}\.{DIGIT}?([Ee](+-)?{DIGIT})?)

%x COMMENT

%%
 /* DELIMITER */
"," {
  token(',');
}
":" {
  token(':');
}
"." {
  token('.');
}
";" {
  token(';');
}
"(" {
  token('(');
}
")" {
  token(')');
}
"[" {
  token('[');
}
"]" {
  token(']');
}
"{" {
  token('{');
}
"}" {
  token('}');
}

/* Arithmetic, Relational, and Logical Operators */
"+" {
	token('+');
}
"-" {
	token('-');
}
"*" {
	token('*');
}
"/" {
	token('/');
}
"%" {
	token('%');REAL
}
"<" {
	token('<');
}
"<=" { 
    token('<='); 
}
">=" {
	token('>=');
}
">" {
	token('>');
}
"==" {
	token('==');
}
"!=" {
	token('!=');
}
"&&" {
	token('%%');
}
"||" {
	token('||');
}
"!" {
	token('!');
}
  /* comment */
{begin_COMMENT} {
    LIST;
    BEGIN COMMENT;
}
{single_COMMENT} {
  LIST;
}
<COMMENT>{end_COMMENT}  {
  LIST;
  BEGIN INITIAL;
}
<COMMENT>[^\n] {
  LIST;
}
<COMMENT>\n {
  LIST;
  printf("%d: %s", linenum, buf);
  linenum++;
  buf[0] = '\0';
}
\n      {
        LIST;
        printf("%d: %s", linenum++, buf);
        buf[0] = '\0';
}
[ \t]*  {LIST;}

.       {
          LIST;
          printf("%d:%s\n", linenum+1, buf);
          printf("bad character:'%s'\n",yytext);
          exit(-1);
}

 /* KEYWORDS */
boolean                 { token(BOOLEAN); }
break                   { token(BREAK); }
char                    { token(CHAR); }
case                    { token(CASE); }
class                   { token(CLASS); }
continue                { token(CONTINUE); }
def                     { token(def); }
do                      { token(DO); }
else                    { token(ELSE); }
exit                    { token(EXIT); }
flase                   { token(flase);}
flaot                   { token(FLAOT);}
for                     { token(FOR); }
if                      { token(IF); }
int                     { token(INT); }
null                    { token(NULL); }
object                  { token(OBJECT); }
print                   { token(PRINT); }
println                 { token(PRINTLN); }
repeat                  { token(REPEAT); }
return                  { token(RETURN); }
string                  { token(STRING); }
to                      { token(TO); }
ture                    { token(TURE); }
type                    { token(TYPE); }
val                     { token(val); }
var                     { token(VAR); }
while                   { token(WHILE); }

ture {

}
flase {

}
 /* {IDENTIFIER} push to symbol table */
{IDENTIFIER} {
	tokenString(IDENTIFIER, yytext);
    table->insert(yytext);
}
{DELIMITER} {

}
{INTEGER} {
	tokenInteger(IDENTIFIER,atoi(yytext));
}
{REAL} {
	tokenString(REAL,yytext)
}
{STRING} {
	LIST;
  char _buf[MAX_LINE_LENG] = { 0 }; 
  unsigned int idx = 1, j = 1;
  _buf[0] = '"';
  while(yytext[idx]) {
    if(idx == yyleng - 1)
  break;
  if(yytext[idx] == '\\') {
    _buf[j++] = yytext[idx++];
    _buf[j++] = yytext[idx];
  }
  else if(yytext[idx] == '"')
    _buf[j++] = yytext[++idx];
  else
  _buf[j++] = yytext[idx];
  ++idx;
  }
_buf[j] = '"';
}


%%
int yywrap(){
	return 0;
}
int main(){
	yylex();
}