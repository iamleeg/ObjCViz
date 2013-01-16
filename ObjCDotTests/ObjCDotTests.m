//
//  ObjCDotTests.m
//  ObjCDotTests
//
//  Created by Graham Lee on 16/01/2013.
//
//

#import "ObjCDotTests.h"
#import "OCVField.h"
#import "ExampleClass.h"

@implementation ObjCDotTests
{
    NSObject *_obj;
    ExampleClass *_example;
    NSArray *_fieldsInNSObject;
    NSArray *_fieldsInExampleClass;
    OCVField *_integerVariableField;
}

- (void)setUp
{
    _obj = [NSObject new];
    _example = [ExampleClass new];
    _example->integerVariable = 42;
    _fieldsInNSObject = [_obj OCV_fields];
    _fieldsInExampleClass = [_example OCV_fields];
    _integerVariableField = _fieldsInExampleClass[0];
}

- (void)tearDown
{
    _fieldsInExampleClass = nil;
    _fieldsInNSObject = nil;
    [_obj release];
    _obj = nil;
    [_example release];
    _example = nil;
    _integerVariableField = nil;
}

- (void)testOneFieldAddedForOneIvar
{
    STAssertEquals([_fieldsInExampleClass count] - [_fieldsInNSObject count], (NSUInteger)1, @"NSObject has %ld fields while ExampleClass has %ld", (long)[_fieldsInNSObject count], (long)[_fieldsInExampleClass count]);
}

- (void)testNSObjectHasIsaField
{
    OCVField *isaField = _fieldsInNSObject[0];
    STAssertEqualObjects([isaField name], @"isa", @"NSObject's ivar is the 'isa' variable");
    STAssertTrue([isaField isPrimitive], @"isa is a class, not a primitive");
    STAssertEqualObjects([isaField valueForObject: _example], nil, @"isa has the expected value of the object's class");
}

- (void)testExampleClassHasPrimitiveField
{
    STAssertEqualObjects([_integerVariableField name], @"integerVariable", @"integerVariable field is present");
    STAssertTrue([_integerVariableField isPrimitive], @"integer types are primitive");
    STAssertNil([_integerVariableField valueForObject: _example], @"Don't support getting primitives");
}

- (void)testPrimitiveFieldCanBeDescribed
{
    NSString *description = [_integerVariableField primitiveValueDescriptionForObject: _example];
    STAssertEqualObjects(description, @"42", @"Can get string descriptions of primitives");
}

@end
