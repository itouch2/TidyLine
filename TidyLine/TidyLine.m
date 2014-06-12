//
//  TidyLine.m
//  TidyLine
//
//  Created by Tu You on 14-6-10.
//    Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "TidyLine.h"
#import "TidyLineHandler.h"

static NSString * const IDESourceCodeEditorDidFinishSetupNotification = @"IDESourceCodeEditorDidFinishSetup";
static NSString * const IDEEditorDocumentDidChangeNotification = @"IDEEditorDocumentDidChangeNotification";
static NSString * const IDESourceCodeEditorTextViewBoundsDidChangeNotification = @"IDESourceCodeEditorTextViewBoundsDidChangeNotification";

static TidyLine *sharedPlugin;

@interface TidyLine()

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSTextView *editorTextView;

@end

@implementation TidyLine

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init])
    {
        // reference to plugin's bundle, for resource acccess
        self.bundle = plugin;
        
        // Create menu item
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Window"];
        if (menuItem) {
            [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"TidyLine"
                                                                    action:@selector(doTidyText)
                                                             keyEquivalent:@"u"];
            [actionMenuItem setKeyEquivalentModifierMask:NSControlKeyMask|NSShiftKeyMask];
            [actionMenuItem setTarget:self];
            [[menuItem submenu] addItem:actionMenuItem];
        }
        
        [self registerNotifications];
    }
    return self;
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDidFinishSetup:)
                                                 name:IDESourceCodeEditorDidFinishSetupNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDocumentDidChange:)
                                                 name:IDEEditorDocumentDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onCodeEditorBoundsChange:)
                                                 name:IDESourceCodeEditorTextViewBoundsDidChangeNotification
                                               object:nil];
}

- (void)onDidFinishSetup:(NSNotification *)notification
{
    self.editorTextView = [[notification object] performSelector:@selector(textView)];
}

- (void)onDocumentDidChange:(NSNotification *)notification
{
}

- (void)onCodeEditorBoundsChange:(NSNotification *)notification
{
}

- (void)doTidyText
{
    NSString *result = [TidyLineHandler eraseExtraLine:self.editorTextView.textStorage.string withType:TidyLineTypeAll];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:result attributes:nil];
    [self.editorTextView.textStorage setAttributedString:string];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
