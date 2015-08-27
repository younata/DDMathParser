//
//  ExpressionRewriter.swift
//  DDMathParser
//
//  Created by Dave DeLong on 8/25/15.
//
//

import Foundation

public struct ExpressionRewriter {
    private var rules: Array<RewriteRule>
    
    public init(rules: Array<RewriteRule> = RewriteRule.defaultRules) {
        self.rules = rules
    }
    
    public mutating func addRule(rule: RewriteRule) {
        rules.append(rule)
    }
    
    public func rewriteExpression(expression: Expression, evaluator: Evaluator) -> Expression {
        
        var tmp = expression
        var iterationCount = 0
        
        repeat {
            var changed = false
            
            for rule in rules {
                let rewritten = rewrite(tmp, usingRule: rule, evaluator: evaluator)
                if rewritten != tmp {
                    changed = true
                    tmp = rewritten
                }
            }
        
            if changed == false { break }
            iterationCount++
            
        } while iterationCount < 256
        
        if iterationCount >= 256 {
            NSLog("replacement limit reached")
        }
        
        return tmp
    }
    
    private func rewrite(expression: Expression, usingRule rule: RewriteRule, evaluator: Evaluator) -> Expression {
        
        let rewritten = rule.rewrite(expression, evaluator: evaluator)
        if rewritten !== expression { return rewritten }
        
        guard case let .Function(f, args) = rewritten.kind else { return rewritten }
        
        let newArgs = args.map { rewrite($0, usingRule: rule, evaluator: evaluator) }
        
        // if nothing changed, reture
        guard args != newArgs else { return rewritten }
        
        return Expression(kind: .Function(f, args), range: rewritten.range)
    }
}
