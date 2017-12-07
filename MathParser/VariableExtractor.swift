//
//  VariableExtractor.swift
//  DDMathParser
//
//  Created by Dave DeLong on 8/7/15.
//
//

import Foundation

internal struct VariableExtractor: TokenExtractor {
    private let identifierExtractor: IdentifierExtractor
    private let prefix: Character?
    
    init(operatorTokens: OperatorTokenSet, variablePrefix: Character?) {
        identifierExtractor = IdentifierExtractor(operatorTokens: operatorTokens, prefix: variablePrefix)
        prefix = variablePrefix
    }
    
    func matchesPreconditions(_ buffer: TokenCharacterBuffer) -> Bool {
        if let prefix = prefix {
            return buffer.peekNext() == prefix
        } else {
            return buffer.peekNext() != nil
        }
    }
    
    func extract(_ buffer: TokenCharacterBuffer) -> TokenIterator.Element {
        let start = buffer.currentIndex

        if prefix != nil {
            buffer.consume() // consume the opening $
        }
        
        guard identifierExtractor.matchesPreconditions(buffer) else {
            // the stuff that follow "$" must be a valid identifier
            let range: Range<Int> = start ..< start
            let error = MathParserError(kind: .cannotParseVariable, range: range)
            return TokenIterator.Element.error(error)
        }
    
        let identifierResult = identifierExtractor.extract(buffer)
    
        let result: TokenIterator.Element
        
        switch identifierResult {
            case .error(let e):
                let range: Range<Int> = start ..< e.range.upperBound
                let error = MathParserError(kind: .cannotParseVariable, range: range)
                result = .error(error)
            case .value(let t):
                let range: Range<Int> = start ..< t.range.upperBound
                let token = RawToken(kind: .variable, string: t.string, range: range)
                result = .value(token)
        }
        
        return result
    }
    
}
