//
//  SWClangTool.m
//  SWCodeObfuscation
//
//  Created by Eren on 2019/6/11.
//  Copyright © 2019 skyline. All rights reserved.
//

#import "SWClangTool.h"
#import "clang-c/Index.h"

/** 类名、方法名 */
@interface SWTokensClientData : NSObject
@property (nonatomic, strong) NSArray *prefixes;
@property (nonatomic, strong) NSMutableSet *tokens;
@property (nonatomic, copy) NSString *file;
@end

@implementation SWTokensClientData
@end

@implementation SWClangTool

static const char *_getFilename(CXCursor cursor) {
    CXSourceRange range = clang_getCursorExtent(cursor);
    CXSourceLocation location = clang_getRangeStart(range);
    CXFile file;
    clang_getFileLocation(location, &file, NULL, NULL, NULL);
    return clang_getCString(clang_getFileName(file));
}

static bool _isFromFile(const char *filepath, CXCursor cursor) {
    if (filepath == NULL) return 0;
    const char *cursorPath = _getFilename(cursor);
    if (cursorPath == NULL) return 0;
    return strstr(cursorPath, filepath) != NULL;
}

static const char *_getCursorName(CXCursor cursor) {
    return clang_getCString(clang_getCursorSpelling(cursor));
}

+ (NSSet *)classesAndMethodsWithFile:(NSString *)file
                            prefixes:(NSArray *)prefixes
                          searchPath:(NSString *)searchPath {
    if (file.length == 0) return nil;
    
    // 文件路径
    const char *filepath = file.UTF8String;
    
    // 创建index
    CXIndex index = clang_createIndex(1, 1);
    // 搜索路径
    int argCount = 5;
    int argIndex = 0;
    const char **args = malloc(sizeof(char *) * argCount);
    args[argIndex++] = "-c";
    args[argIndex++] = "-arch";
    args[argIndex++] = "i386";
    args[argIndex++] = "-isysroot";
    args[argIndex++] = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk";
    
    // 解析语法树，返回根节点TranslationUnit
    CXTranslationUnit tu = clang_parseTranslationUnit(index, filepath,
                                                      args,
                                                      argCount,
                                                      NULL, 0, CXTranslationUnit_None);
    
    free(args);
    
    if (!tu) return nil;

    // 解析语法树
    SWTokensClientData *clientData = [SWTokensClientData new];
    clientData.file = file;
    clientData.prefixes = prefixes;
    clientData.tokens = [NSMutableSet set];
    clang_visitChildren(clang_getTranslationUnitCursor(tu),
                        _visitTokens, (__bridge void *)clientData);
    
    // 销毁
    clang_disposeTranslationUnit(tu);
    clang_disposeIndex(index);
    return clientData.tokens;
}

#pragma mark - private
// 遍历语法树
enum CXChildVisitResult _visitTokens(CXCursor cursor,
                                      CXCursor parent,
                                     CXClientData clientData) {
    if (clientData == NULL) return CXChildVisit_Break;
    SWTokensClientData *data = (__bridge SWTokensClientData *)clientData;
    //不是来自指定的文件的token，忽略
    if (!_isFromFile(data.file.UTF8String, cursor)) return CXChildVisit_Continue;
    
    if (cursor.kind == CXCursor_ObjCInstanceMethodDecl ||
        cursor.kind == CXCursor_ObjCClassMethodDecl ||
        cursor.kind == CXCursor_ObjCImplementationDecl) {
        NSString *name = [NSString stringWithUTF8String:_getCursorName(cursor)];
        NSArray *tokens = [name componentsSeparatedByString:@":"];
        
        // 前缀过滤
        for (NSString *token in tokens) {
            for (NSString *prefix in data.prefixes) {
                if ([token rangeOfString:prefix].location == 0) {
                    [data.tokens addObject:token];
                }
            }
        }
    }
    
    return CXChildVisit_Recurse;
    
}

+ (void)_visitAWTWithFile:(NSString *)file
               searchPath:(NSString *)searchPath
                  visitor:(CXCursorVisitor)visitor
               clientData:(CXClientData)clientData {
    if (file.length == 0) return;
    
    // 文件路径
    const char *filepath = file.UTF8String;
    
    // 创建index
    CXIndex index = clang_createIndex(1, 1);
    // 搜索路径
    int argCount = 5;
    int argIndex = 0;
    const char **args = malloc(sizeof(char *) * argCount);
    args[argIndex++] = "-c";
    args[argIndex++] = "-arch";
    args[argIndex++] = "i386";
    args[argIndex++] = "-isysroot";
    args[argIndex++] = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk";
    
    // 解析语法树，返回根节点TranslationUnit
    CXTranslationUnit tu = clang_parseTranslationUnit(index, filepath,
                                                      args,
                                                      argCount,
                                                      NULL, 0, CXTranslationUnit_None);
    
    free(args);
    
    if (!tu) return;
    
    // 解析语法树
    clang_visitChildren(clang_getTranslationUnitCursor(tu),
                        visitor, clientData);
    
    // 销毁
    clang_disposeTranslationUnit(tu);
    clang_disposeIndex(index);
    return;
}
@end
