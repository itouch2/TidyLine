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

typedef NS_ENUM(NSUInteger, TidyLineType) {
    TidyLineTypeAll,
    TidyLineTypeInMethod,
    TidyLineTypeByMethod
};

@interface TidyLineHandler : NSObject

+ (NSString *)eraseExtraLine:(NSString *)text withType:(TidyLineType)type;

@end

