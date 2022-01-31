File = all:BBML+ { 
    return all.filter(expr => expr); 
}

BBML =  Comment / Screen / NewLine {}

Screen = "screen" _ name: ScreenName _ "{" __ items: ScreenItems __ "}" { 
    return { 
        type: "screen", 
        name, 
        items: items || [] 
    };
}

VStack = "vstack" _ "{" __ items: ScreenItems __ "}" { 
    return { 
        type: "vstack",
        items: items || [] 
    };
}

HStack = "hstack" _ "{" __ items: ScreenItems __ "}" { 
    return { 
        type: "hstack",
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
    / Conditional
    / Comment
    / VStack
    / HStack

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

// TODO: Figure out how components are going to work, and maybe use ComponentName instead of String
// ComponentName = Name
Component = "component" _ name: String { 
    return { 
        type: "component", 
        name 
    };
}

GoTo = "goto" _ destination: ScreenName { 
    return { 
        type: "goto", 
        destination 
    };
}

Conditional = ifStmt: IfStatement __ elseStmt:(ElseStatement)* { 
    const [ firstElse ] = elseStmt || [];
    return { 
        type: "conditional", 
        condition: ifStmt.condition,
        ifItems: ifStmt.items, 
        elseItems: firstElse ? firstElse.items : undefined
    };
}

IfStatement = "if" _ condition: String _ "{" __ items: ScreenItems __ "}" {
    return {
        condition,
        items
    }
}

ElseStatement = "else" _ "{" __ items: ScreenItems __ "}" { 
    return { 
        items 
    };
}

Comment = _ "//" _ value:LineOfText { 
    return { 
        type: "comment", 
        value 
    }; 
}

// Utilities
Name = [a-zA-Z_][a-zA-Z_0-9]* { 
    return text(); 
}

String = '"' content:[^"\n\r]* '"' { 
    return content.join(""); 
}

LineOfText = text:$([^\n\r]*)
EOL = NewLine / (Comment NewLine) / EOF
NewLine = '\n' / '\r' '\n'
EOF = !.

// Whitespace
_ "space" = [ \t]*
__ "whitespace" = [ \t\n\r]*