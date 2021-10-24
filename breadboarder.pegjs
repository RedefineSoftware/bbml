File = all:BBML+ { 
    return all.filter(expr => expr); 
}

BBML = 
    Comment
    / Screen
    / NewLine {}

Screen = "screen" _ name: ScreenName _ "{" __ items: ScreenItems __ "}" { 
    return { 
        type: "screen", 
        name, 
        items: items || [] 
    };
}

ScreenName =  Name
ScreenItems = (head:ScreenItem tail:(EOL __ item:ScreenItem { return item; })* { return [head, ...tail]; })?
ScreenItem = 
    Button 
    / Label
    / Field
    / Component
    / GoTo
    / IfStatement
    / Comment

Button = "button" _ label: ButtonLabel _ "->" _ destination: ScreenName { 
    return { 
        type: "button", 
        label, 
        destination 
    };
}

ButtonLabel = String

Label = "label" _ value: String { 
    return { 
        type: "label", 
        value 
    };
}

Field = "field" _ label: String { 
    return { 
        type: "field", 
        label 
    };
}

Component = "component" _ label: String { 
    return { 
        type: "component", 
        label 
    };
}

GoTo = "goto" _ destination: ScreenName { 
    return { 
        type: "goto", 
        destination 
    };
}

IfStatement = "if" _ condition: String _ "{" __ items: ScreenItems __ "}" __ ElseStatement*
ElseStatement = "else" _ "{" __ items: ScreenItems __ "}"

// Utilities
Name = [a-zA-Z_][a-zA-Z_0-9]* { return text(); }
String = '"' content:[^"\n\r]* '"' { return content.join(""); }
Comment = _ "//" _ value:LineOfText { return { type: "comment", value }; }
LineOfText = text:$([^\n\r]*)
EOL = NewLine / (Comment NewLine) / EOF
NewLine = '\n' / '\r' '\n'
EOF = !.

// Whitespace
_ "space" = [ \t]*
__ "whitespace" = [ \t\n\r]*