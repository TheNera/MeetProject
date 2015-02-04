//
//  Utility.m
//  CDS Mobile
//
//  Created by Prashant Bhayani on 24/09/14.
//
//

#import "Utility.h"

@implementation Utility

+ (BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+ (NSString *) removeWhiteSpaceFromString:(NSString *)aStrwhiteSpace
{
    NSString *strFinal = [aStrwhiteSpace stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return strFinal;
}
@end