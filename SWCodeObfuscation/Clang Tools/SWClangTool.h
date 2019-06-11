//
//  SWClangTool.h
//  SWCodeObfuscation
//
//  Created by Eren on 2019/6/11.
//  Copyright © 2019 skyline. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWClangTool : NSObject
+ (NSSet *)classesAndMethodsWithFile:(NSString *)file
                            prefixes:(NSArray *)prefixes
                          searchPath:(NSString *)searchPath;
@end

NS_ASSUME_NONNULL_END
