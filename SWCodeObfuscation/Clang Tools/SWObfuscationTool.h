//
//  SWObfuscationTool.h
//  SWCodeObfuscation
//
//  Created by Eren on 2019/6/11.
//  Copyright © 2019 skyline. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWObfuscationTool : NSObject

+ (void)obfuscateAtDir:(NSString *)dir
              prefixes:(NSArray *)prefixes
              progress:(void(^)(NSString *details))progress
            completion:(void(^)(NSString *fileContent))completion;
@end

NS_ASSUME_NONNULL_END
