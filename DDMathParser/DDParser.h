//
//  DDParser.h
//  DDMathParser
//
//  Created by Dave DeLong on 11/24/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMathOperatorTypes.h"

@class DDMathTokenizer;
@class DDMathOperatorSet;
@class DDExpression;

@interface DDParser : NSObject

@property (readonly) DDMathOperatorSet *operatorSet;

+ (id)parserWithTokenizer:(DDMathTokenizer *)tokenizer error:(NSError **)error;
- (id)initWithTokenizer:(DDMathTokenizer *)tokenizer error:(NSError **)error;

+ (id)parserWithString:(NSString *)string error:(NSError **)error;
- (id)initWithString:(NSString *)string error:(NSError **)error;

- (DDExpression *)parsedExpressionWithError:(NSError **)error;
- (DDMathOperatorAssociativity)associativityForOperatorFunction:(NSString *)function;

@end
