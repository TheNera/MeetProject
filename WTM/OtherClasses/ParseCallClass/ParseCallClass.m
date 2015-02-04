//
//  ParseCallClass.m
//  WTM
//

#import "ParseCallClass.h"
static ParseCallClass *sharedObject=nil;

@implementation ParseCallClass

+(id)sharedClass{    
    if(!sharedObject){
        sharedObject = [[ParseCallClass alloc]init];
    }
    return sharedObject;
}


@end
