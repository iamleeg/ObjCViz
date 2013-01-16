//
//  DotGenerationTests.m
//  ObjCViz
//
//  Created by Graham Lee on 16/01/2013.
//
//

#import "DotGenerationTests.h"
#import "OCVContext.h"

@implementation DotGenerationTests

- (void)testGeneratingNSObjectGraphviz
{
    NSObject *obj = [NSObject new];
    NSString *repr = [obj graphvizRepresentation];
    STAssertNotNil(repr, @"Generating graphviz representations");
    [obj release];
}

@end
