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
{
    Ivar instanceVariable;
}

-(id)initWithIVar:(Ivar)ivar
{
	self = [super init];
    if (self)
    {
        instanceVariable = ivar;
    }
	return self;
}

-(void)dealloc
{
    instanceVariable = NULL;
	[super dealloc];
}

- (const char *)cName
{
    return ivar_getName(instanceVariable);
}

- (NSString*)name
{
	return [NSString stringWithUTF8String: [self cName]];
}

- (const char *)objcType
{
    return ivar_getTypeEncoding(instanceVariable);
}

- (char)typeEncoding
{
    return [self objcType][0];
}

- (NSString *) typeForCode
{
	char fc = [self typeEncoding];
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
    char encoding = [self typeEncoding];
    BOOL isObject = (encoding == '@');
	return (!isObject);
}

-(id)valueForObject:(id)o 
{
	if ([self isPrimitive])
		return nil;
    
	id res;
	res = object_getIvar(o, instanceVariable);
    
	return res;
}

-(NSString*)primitiveValueDescriptionForObject:(id)anObject
{
    id value = [anObject valueForKey: [self name]];
    
    return [NSString stringWithFormat: @"%@", value];
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"%@ %@",[self typeForCode],[self name]];
}

@end


@implementation NSObject (OCVReflect)

- (NSArray*)OCV_fieldsForClass:(Class)klass 
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
		[array addObjectsFromArray:[self OCV_fieldsForClass:superclass]];
	return array;
}

- (NSArray*)OCV_fields
{
	Class klass = [self class];
	return [self OCV_fieldsForClass:klass];
}

@end

