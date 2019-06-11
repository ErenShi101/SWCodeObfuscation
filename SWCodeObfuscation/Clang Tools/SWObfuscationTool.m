//
//  SWObfuscationTool.m
//  SWCodeObfuscation
//
//  Created by Eren on 2019/6/11.
//  Copyright © 2019 skyline. All rights reserved.
//

#import "SWObfuscationTool.h"
#import "SWClangTool.h"

@implementation SWObfuscationTool
+ (void)obfuscateAtDir:(NSString *)dir
              prefixes:(NSArray *)prefixes
              progress:(void(^)(NSString *details))progress
            completion:(void(^)(NSString *fileContent))completion {
    NSSet *result = [SWClangTool classesAndMethodsWithFile:dir prefixes:nil searchPath:nil];
}
@end
