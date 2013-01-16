//
//  OCVField.m
//  ObjCViz
//
//  Created by Olivier Gutknecht on 12/17/06.
//  Copyright 2006 No Distance. See LICENSE.txt file.
//

#import "OCVField.h"
#include <objc/objc-class.h>


@implementation OCVField

-(id)initWithIVar:(Ivar)ivar
{
	self = [super init];
    if (self)
    {
        type = [[NSString alloc] initWithUTF8String:ivar_getTypeEncoding(ivar)];
        name = [[NSString alloc] initWithUTF8String:ivar_getName(ivar)];
        offset = ivar_getOffset(ivar);
    }
	return self;
}

-(void)dealloc {
	[type release];
	[name release];
	[super dealloc];
}

- (NSString*)getName {
	return name;
}

- (NSString *) typeForCode
{
	char fc = [type characterAtIndex:0];
    NSString *rs;
    switch (fc) {
        case '@' :
            rs = @"id";
            break;
        case '#' :
            rs = @"Class";
            break;
        case ':' :
            rs = @"SEL";
            break;
        case 'c' :
            rs = @"char";
            break;
        case 'C' :
            rs = @"unsigned char";
            break;
        case 's' :
            rs = @"short";
            break;
        case 'S' :
            rs = @"unsigned short";
            break;
        case 'i' :
            rs = @"int";
            break;
        case 'I' :
            rs = @"unsigned int";
            break;
        case 'l' :
            rs = @"long";
            break;
        case 'L' :
            rs = @"unsigned long";
            break;
        case 'q' :
            rs = @"long long";
            break;
        case 'Q' :
            rs = @"unsigned long long";
            break;
        case 'f' :
            rs = @"float";
            break;
        case 'd' :
            rs = @"double";
            break;
        case 'v' :
            rs = @"void";
            break;
        case '*' :
        case '%' : // _C_ATOM
            rs = @"char *";
            break;
        default :
			rs = @"UNKNOWN";
            break;
    }	
    return rs;
}

- (BOOL)isPrimitive
{
	return (![[self typeForCode] isEqualToString:@"id"]);
}

-(id)getValueForObject:(id)o 
{
	if ([self isPrimitive])
		return nil;
    
	id res;
	res = *(void**)(((void*)o) + offset);
    
	return res;
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"%@ %@",[self typeForCode],name];
}

@end


@implementation NSObject (OCVReflect)

- (NSArray*)getFieldsForClass:(Class)klass 
{
	NSMutableArray* array = [NSMutableArray array];
	int i;
	Ivar rtIvar;
    unsigned int ivarCount = 0;
    Class superclass = Nil;
    Ivar *ivars = class_copyIvarList(klass, &ivarCount);
	if (ivars!= NULL && (ivarCount>0)) {
		for ( i = 0; i < ivarCount; ++i ) {
			rtIvar = ivars[i];
			OCVField* t = [[OCVField alloc] initWithIVar:rtIvar];
			[array addObject:t];
			[t release];
		}
        free(ivars);
        ivars = NULL;
	}
    superclass = class_getSuperclass(klass);
	if (superclass!=Nil)
		[array addObjectsFromArray:[self getFieldsForClass:superclass]];
	return array;
}

- (NSArray*)getFields
{
	Class klass = [self class];
	return [self getFieldsForClass:klass];
}

@end

