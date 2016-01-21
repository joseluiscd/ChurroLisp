%lex

%%
\s+                              /* skip */
[0-9]+("."[0-9]+)?\b             return 'NUMBER';
"("                              return '(';
")"                              return ')';
[\"\']([^\"\'\\]|\\.)*[\"\']     return 'STRING';
[*/+-^!?]                        return 'OPERATOR';
\w+                              return 'WORD';
<<EOF>>                          return 'EOF';

/lex

%start global

%% /* The Grammar */

global:
    expression EOF{
        console.log($1);
    };

expression:
    list | NUMBER | OPERATOR | WORD
    |
    STRING {
        $$ = $1.replace(/^"|"$/g, "");
    };

list:
    '(' list_slice ')'{
        $$ = $2;
    };

list_slice:
    list_slice expression {
        $1.push($2);
        $$ = $1;
    }
    |
    expression {
        $$ = [];
        $$.push($1);
    };
