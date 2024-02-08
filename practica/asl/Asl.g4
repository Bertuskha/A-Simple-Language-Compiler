//////////////////////////////////////////////////////////////////////
//
//    Asl - Another simple language (grammar)
//
//    Copyright (C) 2017-2023  Universitat Politecnica de Catalunya
//
//    This library is free software; you can redistribute it and/or
//    modify it under the terms of the GNU General Public License
//    as published by the Free Software Foundation; either version 3
//    of the License, or (at your option) any later version.
//
//    This library is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//    Affero General Public License for more details.
//
//    You should have received a copy of the GNU Affero General Public
//    License along with this library; if not, write to the Free Software
//    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
//
//    contact: José Miguel Rivero (rivero@cs.upc.edu)
//             Computer Science Department
//             Universitat Politecnica de Catalunya
//             despatx Omega.110 - Campus Nord UPC
//             08034 Barcelona.  SPAIN
//
//////////////////////////////////////////////////////////////////////

grammar Asl;

//////////////////////////////////////////////////
/// Parser Rules
//////////////////////////////////////////////////

// A program is a list of functions
program : function+ EOF
        ;

// A function has a name, a list of parameters and a list of statements
function
        : FUNC ID PAREOP (param (',' param)*)? PARECL (':' basic_type=type)? declarations statements ENDFUNC
        ;

declarations
        : (variable_decl)*
        ;

variable_decl
        : VAR ID (',' ID)* ':' type
        ;
param
        : ID ':' type
        ;

type    : BASIC_TYPE           # basicType
        | 'array' CLAUOP INTVAL CLAUCL 'of' BASIC_TYPE # arrayType 
        ;

statements
        : (statement)*
        ;

// The different types of instructions
statement
          // Assignment
        : left_expr ASSIGN expr ';'           # assignStmt
          // if-then-else statement (else is optional)
        | IF expr THEN statements (ELSE statements)? ENDIF   # ifStmt
          // A function/procedure call has a list of arguments in parenthesis (possibly empty)
        | WHILE expr DO statements ENDWHILE   # whileStmt
        | ident PAREOP PARECL ';'                   # procCall
          // Read a variable
        | READ left_expr ';'                  # readStmt
          // Write an expression
        | WRITE expr ';'                      # writeExpr
          // Write a string
        | WRITE STRING ';'                    # writeString
        | ID PAREOP (expr(','expr)*)? PARECL ';'        # methodCall    
        | RETURN (expr)? ';'                  # return         
        ;

// Grammar for left expressions (l-values in C++)
left_expr
        : PAREOP left_expr PARECL
        | left_expr CLAUOP expr CLAUCL
        | ident
        ;

// Grammar for expressions with boolean, relational and aritmetic operators
expr    : (op=MINUS | op=PLUS | op=NOT) expr  # unary
        | left_expr CLAUOP expr CLAUCL            #arrayIndex
        | PAREOP expr PARECL                  # parenthesis
        | expr (op=MUL | op=DIV | op=MOD) expr         # arithmetic
        | expr (op=PLUS| op=MINUS) expr       # arithmetic
        | expr (op=EQUAL |op= NOTEQUAL|  op=GT | op= GE | op=LT | op=LE) expr # relational
        | expr (op=AND) expr # and
        | expr (op= OR) expr # or
        | (INTVAL| BOOLVAL | FLOATVAL | CHARVAL)  # value
        | ID PAREOP (expr(','expr)*)? PARECL         # functionCall
        | ident                              # exprIdent
        ;

// Identifiers
ident   : ID
        ;

//////////////////////////////////////////////////
/// Lexer Rules
//////////////////////////////////////////////////
PAREOP    : '(';
PARECL    : ')';
CLAUOP    :'[';
CLAUCL    :']';   
LT        : '<';
LE        : '<=';
GT        : '>';
GE        : '>=';
ASSIGN    : '=' ;
EQUAL     : '==' ;
NOTEQUAL  : '!=';
NOT       : 'not';
AND       : 'and';
OR        : 'or';
PLUS      : '+' ;
MINUS     : '-';
MUL       : '*';
DIV       : '/';
MOD       : '%';
VAR       : 'var';
BASIC_TYPE:(INT | BOOL | CHAR |FLOAT);
INT       : 'int';
BOOL      : 'bool';
CHAR      : 'char';
FLOAT     : 'float';
IF        : 'if' ;
THEN      : 'then' ;
ELSE      : 'else' ;
ENDIF     : 'endif' ;
WHILE     : 'while' ;
DO        : 'do' ;
ENDWHILE  : 'endwhile' ;
FUNC      : 'func' ;
RETURN    : 'return' ;
ENDFUNC   : 'endfunc' ;
READ      : 'read' ;
WRITE     : 'write' ;
BOOLVAL   : ('true' | 'false');
INTVAL    : ('0'..'9')+ ;
CHARVAL   : '\'' (. | '\\n' | '\\t' | '\\\'') '\'' ;
FLOATVAL  : ('0'..'9')+ '.' ('0'..'9')+;
ID        : ('a'..'z'|'A'..'Z') ('a'..'z'|'A'..'Z'|'_'|'0'..'9')* ;


// Strings (in quotes) with escape sequences
STRING    : '"' ( ESC_SEQ | ~('\\'|'"') )* '"' ;

fragment
ESC_SEQ   : '\\' ('b'|'t'|'n'|'f'|'r'|'"'|'\''|'\\') ;

// Comments (inline C++-style)
COMMENT   : '//' ~('\n'|'\r')* '\r'? '\n' -> skip ;

// White spaces
WS        : (' '|'\t'|'\r'|'\n')+ -> skip ;
// Alternative description
// WS        : [ \t\r\n]+ -> skip ;
