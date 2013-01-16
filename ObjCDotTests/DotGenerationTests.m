//
//  DotGenerationTests.m
//  ObjCViz
//
//  Created by Graham Lee on 16/01/2013.
//
//

#import "DotGenerationTests.h"
#import "OCVContext.h"
#import "OCVDotRepresentations.h"
#import "ExampleClass.h"

@implementation DotGenerationTests
{
    NSObject *_obj;
    NSString *_objPointerString;
    ExampleClass *_example;
    NSString *_examplePointerString;
}

- (void)setUp
{
    _obj = [NSObject new];
    _objPointerString = [NSString stringWithFormat: @"%p", _obj];
    _example = [ExampleClass new];
    _examplePointerString = [NSString stringWithFormat: @"%p", _example];
}

- (void)tearDown
{
    [_obj release];
    _obj = nil;
    _objPointerString = nil;
    [_example release];
    _example = nil;
    _examplePointerString = nil;
}

- (void)testGeneratingNSObjectGraphviz
{
    NSString *expectedResult = @"digraph ObjC {\n"
    @"L%@ [label=\"NSObject\", style=rounded, shape=box];\n"
@"}\n";
    NSString *formattedResult = [NSString stringWithFormat: expectedResult, _objPointerString];
    NSString *repr = [_obj graphvizRepresentation];
    STAssertEqualObjects(repr, formattedResult, @"Actual representation was %@", repr);
}

- (void)testGeneratingExampleClassGraphviz
{
    NSString *expectedResult = @"digraph ObjC {\n"
    @"L%@ [label=\"{ExampleClass}|{integerVariable=42}\", style=rounded, shape=Mrecord];\n"
    @"}\n";
    _example->integerVariable = 42;
    NSString *formattedResult = [NSString stringWithFormat: expectedResult, _examplePointerString];
    NSString *repr = [_example graphvizRepresentation];
    STAssertEqualObjects(repr, formattedResult, @"Actual representation was %@", repr);
}

@end
