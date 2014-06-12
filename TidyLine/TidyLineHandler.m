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

+ (NSString *)eraseExtraLine:(NSString *)text withType:(TidyLineType)type
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
            flag = NO;
            
            // delete the extra lines between
            for (int j = begin; j < end; j++)
            {
                Line *line = (Line *)copyArray[j];
                line.discard = YES;
            }
        }
        else
        {
            flag = NO;
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
    return result;
}

@end
