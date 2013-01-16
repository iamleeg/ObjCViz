#import <Foundation/Foundation.h>

#import "OCVContext.h"

@interface Bu : NSObject {
	NSString* superclassIvar;
}
@end

@implementation Bu 
@end

@interface Meu : NSObject {
	id obj;
}
@end

@implementation Meu 

-(id)init
{
	[super init];
	obj = @"hello";
	return self;
}

-(void)dealloc
{
    [obj release];
    [super dealloc];
}
@end


@interface Zo : Bu {
	NSString* d;
	id e;
}

@end

@implementation Zo 
-(id)init
{
	[super init];
	e = [[NSScanner scannerWithString:@"scannedString"] retain];
	return self;
}

@end

@interface Ga : NSObject {
	NSString* strIvar;
	NSMutableArray* arrayIvar;
	NSMutableDictionary* dictIvar;
	Zo* boIvar;
}
@end

@implementation Ga 
-(id)init
{
	[super init];
	strIvar = @"aString";
	boIvar = [[Zo alloc] init];
	arrayIvar = [[NSArray alloc] initWithObjects:@"aStringInArray",[[[NSDate alloc] init] autorelease], nil];
	dictIvar = [[NSMutableDictionary alloc] initWithObjectsAndKeys:boIvar,@"Key1",@"Obj2",@"Key2",nil];
	return self;
}

-(void)dealloc
{
    [strIvar release];
    [boIvar release];
    [arrayIvar release];
    [dictIvar release];
    [super dealloc];
}
@end

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		
	Ga* g = [[[Ga alloc] init] autorelease];
	NSString* m = [g graphvizRepresentation];

    NSLog(@"\n%@",m);
    [m writeToFile:[NSString stringWithFormat:@"%@-%p.dot",[g class],g] atomically:TRUE];
    
	[pool release];
    
    return 0;
}