//
//  OCVContext.m
//  ObjCViz
//
//  Created by Olivier Gutknecht on 12/17/06.
//  Copyright 2006 No Distance. See LICENSE.txt file.
//

#import "OCVContext.h"
#import "OCVField.h"
#import "OCVDotRepresentations.h"


@implementation NSObject (OCVContext)

-(NSString*)graphvizRepresentation
{
	OCVContext* c = [[OCVContext alloc] init];
	NSMutableString* m = [[NSMutableString alloc] init];
	[m appendString:@"digraph ObjC {\n"];
    [c appendGraphvizRepresentationFor:self toString:m];
	[m appendString:@"}\n"];
	[c release];
    return [m autorelease];
}

@end

@implementation OCVContext

-(id)init
{
	self = [super init];
    if (self)
    {
        visited = [[NSMutableSet alloc] init];
    }
	return self;
}

-(void)dealloc
{
	[visited release];
	[super dealloc];
}

-(void)processFieldsForObject:(id)obj fields:(NSArray*)f toString:(NSMutableString*)s
{
	OCVField* field;
	NSEnumerator* e = [f objectEnumerator];
	while (field = [e nextObject])
	{
		if (![field isPrimitive]) {
			NSString* name = [field name];
			id ref = [field getValueForObject:obj];
			if (ref==nil) {
				NSString* refName = [NSString stringWithFormat:@"%@%@",[obj dotName],name];
				[s appendFormat:@"%@ -> %@ [label=\"%@\",fontsize=12];\n",[obj dotName],refName, name];
				[s appendFormat:@"%@ [label=\"nil\"];\n",refName];
			}
			else 
			{
				[s appendFormat:@"%@ -> %@ [label=\"%@\",fontsize=12];\n",[obj dotName],[ref dotName], name];
				[self appendGraphvizRepresentationFor:ref toString:s];
			}
		}
	}
}

-(void)appendGraphvizRepresentationFor:(id)obj toString:(NSMutableString*)s
{
	if (obj==nil)
		obj = [NSNull null];
	
	if ([visited containsObject:obj])
        return;
    
    [visited addObject:obj];    
    [obj appendDotRepresentationToString:s withContext:self];
    if ([obj processFields])
        [self processFieldsForObject:obj fields:[obj getFields] toString:s];
}

@end
