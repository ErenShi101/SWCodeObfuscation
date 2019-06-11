//
//  main.m
//  SWCodeObfuscation
//
//  Created by Eren on 2019/6/11.
//  Copyright © 2019 skyline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWObfuscationTool.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [SWObfuscationTool obfuscateAtDir:@"\/Users\/eren\/Everest\/rmc-mobile-ios\/nxrmc\/nxrmc\/NXNXLOperationManager.m" prefixes:nil progress:nil completion:nil];
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}
