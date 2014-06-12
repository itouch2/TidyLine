//
//  TidyLineHandler.h
//  TidyLine
//
//  Created by Tu You on 14-6-12.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject

@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) BOOL discard;

@end

@interface TidyLineHandler : NSObject

+ (NSString *)tidyLine:(NSString *)text;

+ (NSString *)eraseExtraLine:(NSString *)text;
+ (NSString *)eraseExtraLineAfterLeftCurlyBrace:(NSString *)text;
+ (NSString *)eraseExtraLineBeforeRightCurlyBrace:(NSString *)text;

@end

