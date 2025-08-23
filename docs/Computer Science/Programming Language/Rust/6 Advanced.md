# Advanced Topics

## 1. Unsafe Rust

## 2. Advanced Types

## 3. Advanced Functions and Closures

## 4. Macros

按照语法层面来讲，宏按照如下方式被形式化定义：

```ocaml
MacroRulesDefinition -> macro_rules! IDENTIFIER MacroRulesDef
MacroRulesDef -> { MacroRules } | ( MacroRules ); | [ MacroRules ];
MacroRules -> MacroRule ( : MacroRule )* ;
MacroRule -> MacroMatcher => MacroTranscriber
MacroMatcher -> ( MacroMatch* )
```

## 5. Building CLI Applications

## 6. Building Web Servers

## 7. Release Profiles

## 8. Custom Cargo Commands
