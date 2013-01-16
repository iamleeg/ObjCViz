//
//  OCVDotRepresentations.m
//  ObjCViz
//
//  Created by Olivier Gutknecht on 12/17/06.
//  Copyright 2006 No Distance. See LICENSE.txt file.
//

#import "OCVDotRepresentations.h"
#import "OCVField.h"

@implementation NSObject (DotRepresentation)

-(BOOL)processFields
{
    // We could do smart processing here based on [obj class] and [[NSBundle bundleForClass:[obj class]] bundlePath]
    // to know if we really want to process the class or not
    return YES;
}

-(NSString*)dotName
{
    return [NSString stringWithFormat:@"L%p",self];
}

-(NSString*)OCV_label
{
    NSArray *primitiveFields = [[self OCV_fields] filteredArrayUsingPredicate: [NSPredicate predicateWithBlock: ^(OCVField *field, NSDictionary *bindings){
        if ([field isPrimitive])
        {
            //ignore isa
            return (BOOL)!([[field name] isEqualToString: @"isa"]);
        }
        return NO;
    }]];
    NSString *labelValue = nil;
    NSString *classString = NSStringFromClass([self class]);
    if ([primitiveFields count] == 0)
    {
        labelValue = classString;
    }
    else
    {
        NSMutableString *dotName = [NSMutableString stringWithFormat: @"{%@}", classString];
        for (OCVField *field in primitiveFields)
        {
            [dotName appendString: [NSString stringWithFormat: @"{%@=%@}", [field name], [field primitiveValueDescriptionForObject: self]]];
        }
        labelValue = [[dotName mutableCopy] autorelease];
    }
    return labelValue;
}

-(void)appendDotRepresentationToString:(NSMutableString*)s withContext:(OCVContext*)context
{
	[s appendFormat:@"%@ [label=\"%@\", style=rounded, shape=box];\n",[self dotName],[self OCV_label]];
}
@end

@implementation NSNull (DotRepresentation)

-(void)appendDotRepresentationToString:(NSMutableString*)s withContext:(OCVContext*)context
{
    [s appendFormat:@"%@ [label=\"nil\"];\n",[self dotName]];
}
@end

@implementation NSString (DotRepresentation)

-(BOOL)processFields
{
    return NO;
}

-(void)appendDotRepresentationToString:(NSMutableString*)s withContext:(OCVContext*)context
{
	[s appendFormat:@"%@ [label=\"@\\\"%@\\\"\"];\n",[self dotName],[self description]];
}
@end

@implementation NSDictionary (DotRepresentation)

-(BOOL)processFields
{
    return NO;
}

-(void)appendDotRepresentationToString:(NSMutableString*)s withContext:(OCVContext*)context
{
	NSInteger i;
    NSString* dotName = [self dotName];
	NSArray* keys = [self allKeys];
	NSUInteger c = [keys count];
	
    [s appendFormat:@"\n%@ [label=\"{%@|{",dotName,[self class]];
	for (i=0;i<c;i++)
	{
		if (i!=0)
			[s appendString:@"|"];
		[s appendFormat:@"<f%ld> %@",(long)i,[keys objectAtIndex:i]];
	}
	[s appendString:@"}}\",shape=Mrecord];\n"];
	
	for (i=0;i<c;i++)
	{
		id ref = [self objectForKey:[keys objectAtIndex:i]];
		if([ref isEqual:[NSNull null]])
			continue;
		[s appendFormat:@"%@:f%ld -> %@",dotName,(long)i,[ref dotName]];
		[s appendFormat:@"[label=\"%@\",fontsize=12];\n",[keys objectAtIndex:i]];
		[context appendGraphvizRepresentationFor:ref toString:s];
    }
	[s appendString:@"\n"];
}

@end

@implementation NSArray (DotRepresentation)

-(BOOL)processFields
{
    return NO;
}

-(void)appendDotRepresentationToString:(NSMutableString*)s withContext:(OCVContext*)context
{
	int i;
	NSUInteger c = [self count];
    NSString* dotName = [self dotName];
    
    [s appendFormat:@"\n%@ [label=\"{%@|{",dotName,[self class]];
	for (i=0;i<c;i++)
	{
		if (i!=0)
			[s appendString:@"|"];
		[s appendFormat:@"<f%d>",i];
	}
	[s appendString:@"}}\",shape=Mrecord];\n"];
    
	for (i=0;i<c;i++)
	{
		id ref = [self objectAtIndex:i];
		if([ref isEqual:[NSNull null]])
			continue;
		[s appendFormat:@"%@:f%d -> %@",dotName,i,[ref dotName]];
		[s appendFormat:@"[label=\"%d\",fontsize=12];\n",i];
		[context appendGraphvizRepresentationFor:ref toString:s];
    }
	[s appendString:@"\n"];
}

@end
