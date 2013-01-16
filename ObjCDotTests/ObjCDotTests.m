//
//  ObjCDotTests.m
//  ObjCDotTests
//
//  Created by Graham Lee on 16/01/2013.
//
//

#import "ObjCDotTests.h"
#import "OCVField.h"

@interface ExampleClass : NSObject
{
    @public
    int integerVariable;
}
@end
@implementation ExampleClass
@end

@implementation ObjCDotTests
{
    NSObject *_obj;
    ExampleClass *_example;
    NSArray *_fieldsInNSObject;
    NSArray *_fieldsInExampleClass;
}

- (void)setUp
{
    _obj = [NSObject new];
    _example = [ExampleClass new];
    _fieldsInNSObject = [_obj OCV_fields];
    _fieldsInExampleClass = [_example OCV_fields];
}

- (void)tearDown
{
    _fieldsInExampleClass = nil;
    _fieldsInNSObject = nil;
    [_obj release];
    _obj = nil;
    [_example release];
    _example = nil;
}

- (void)testOneFieldAddedForOneIvar
{
    STAssertEquals([_fieldsInExampleClass count] - [_fieldsInNSObject count], (NSUInteger)1, @"NSObject has %ld fields while ExampleClass has %ld", (long)[_fieldsInNSObject count], (long)[_fieldsInExampleClass count]);
}

- (void)testNSObjectHasIsaField
{
    OCVField *isaField = _fieldsInNSObject[0];
    STAssertEqualObjects([isaField name], @"isa", @"NSObject's ivar is the 'isa' variable");
    STAssertFalse([isaField isPrimitive], @"isa is a class, not a primitive");
    STAssertEqualObjects([isaField valueForObject: _example], [ExampleClass class], @"isa has the expected value of the object's class");
}

- (void)testExampleClassHasPrimitiveField
{
    OCVField *integerVariableField = _fieldsInExampleClass[0];
    STAssertEqualObjects([integerVariableField name], @"integerVariable", @"integerVariable field is present");
    STAssertTrue([integerVariableField isPrimitive], @"integer types are primitive");
    STAssertNil([integerVariableField valueForObject: _example], @"Don't support getting primitives");
}

@end
