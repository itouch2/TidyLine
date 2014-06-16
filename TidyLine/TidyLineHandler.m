//
//  TidyLineHandler.m
//  TidyLine
//
//  Created by Tu You on 14-6-12.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "TidyLineHandler.h"

@implementation Line

@end

@implementation TidyLineHandler

+ (NSString *)tidyLine:(NSString *)text
{
    NSString *result;
    result = [TidyLineHandler eraseExtraLine:text];
    result = [TidyLineHandler eraseExtraLineAfterLeftCurlyBrace:result];
    result = [TidyLineHandler eraseExtraLineBeforeRightCurlyBrace:result];
    return result;
}

+ (NSString *)eraseExtraLine:(NSString *)text
{
    NSArray *array = [text componentsSeparatedByString:@"\n"];
    
    NSMutableArray *copyArray = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Line *line = [[Line alloc] init];
        line.content = (NSString *)obj;
        [copyArray addObject:line];
    }];
    
    int begin = 0, end = 0;
    
    BOOL flag = NO;
    
    for (int i = 0; i < array.count; i++)
    {
        NSString *str = array[i];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (!flag && str.length == 0)
        {
            begin = i;
            flag = YES;
            continue;
        }
        
        if (str.length == 0)
        {
            continue;
        }
        
        if (!flag)
        {
            continue;
        }
        
        end = i;
        flag = NO;
        
        // delete the extra lines between
        for (int j = begin + 1; j < end; j++)
        {
            Line *line = (Line *)copyArray[j];
            line.discard = YES;
        }
    }
    
    NSMutableString *result = [NSMutableString string];
    [copyArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Line *line = (Line *)obj;
        if (!line.discard)
        {
            [result appendString:line.content];
            [result appendString:@"\n"];
        }
    }];
    
    NSString *finalResult = [[NSString alloc] initWithString:result];
    finalResult = [finalResult substringToIndex:(finalResult.length - 1)];
    return finalResult;
}

+ (NSString *)eraseExtraLineAfterLeftCurlyBrace:(NSString *)text
{
    NSArray *array = [text componentsSeparatedByString:@"\n"];
    
    NSMutableArray *copyArray = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Line *line = [[Line alloc] init];
        line.content = (NSString *)obj;
        [copyArray addObject:line];
    }];
    
    int begin = 0, end = 0;
    
    BOOL flag = NO;
    
    for (int i = 0; i < array.count; i++)
    {
        NSString *str = array[i];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ([str isEqualToString:@"{"] && !flag)
        {
            begin = i;
            flag = YES;
            continue;
        }
        
        if (str.length == 0)
        {
            continue;
        }
        
        if (flag && str.length != 0)
        {
            end = i;
            flag = NO;
            
            // delete the extra lines between
            for (int j = begin + 1; j < end; j++)
            {
                Line *line = (Line *)copyArray[j];
                line.discard = YES;
            }
        }
    }
    
    NSMutableString *result = [NSMutableString string];
    [copyArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Line *line = (Line *)obj;
        if (!line.discard)
        {
            [result appendString:line.content];
            [result appendString:@"\n"];
        }
    }];
    
    NSString *finalResult = [[NSString alloc] initWithString:result];
    finalResult = [finalResult substringToIndex:(finalResult.length - 1)];
    return finalResult;
}

+ (NSString *)eraseExtraLineBeforeRightCurlyBrace:(NSString *)text
{
    NSArray *array = [text componentsSeparatedByString:@"\n"];
    
    NSMutableArray *copyArray = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Line *line = [[Line alloc] init];
        line.content = (NSString *)obj;
        [copyArray addObject:line];
    }];
    
    int begin = 0, end = 0;
    
    BOOL flag = NO;
    
    for (int i = 0; i < array.count; i++)
    {
        NSString *str = array[i];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (!flag && str.length == 0)
        {
            begin = i;
            flag = YES;
        }
        
        if (str.length == 0)
        {
            continue;
        }
        
        if ([str isEqualToString:@"}"] && flag)
        {
            end = i;
            
            // delete the extra lines between
            for (int j = begin; j < end; j++)
            {
                Line *line = (Line *)copyArray[j];
                line.discard = YES;
            }
        }
        
        flag = NO;
    }
    
    NSMutableString *result = [NSMutableString string];
    [copyArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Line *line = (Line *)obj;
        if (!line.discard)
        {
            [result appendString:line.content];
            [result appendString:@"\n"];
        }
    }];
    
    NSString *finalResult = [[NSString alloc] initWithString:result];
    finalResult = [finalResult substringToIndex:(finalResult.length - 1)];
    return finalResult;
}

@end