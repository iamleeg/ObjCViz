//
//  OCVField.h
//  ObjCViz
//
//  Created by Olivier Gutknecht on 12/17/06.
//  Copyright 2006 No Distance. See LICENSE.txt file.
//

#import <Foundation/Foundation.h>

@interface OCVField : NSObject

- (NSString*)name;
- (BOOL)isPrimitive;
- (id)getValueForObject:(id)o;

@end


@interface NSObject (OCVReflect)
- (NSArray*)getFields;
@end

