//
//  OCVDotRepresentations.h
//  ObjCViz
//
//  Created by Olivier Gutknecht on 12/17/06.
//  Copyright 2006 No Distance. See LICENSE.txt file.
//

#import <Cocoa/Cocoa.h>
#import "OCVContext.h"


@interface NSObject (DotRepresentation)

-(BOOL)processFields;
-(NSString*)dotName;
-(void)appendDotRepresentationToString:(NSMutableString*)s withContext:(OCVContext*)context;

@end

@interface NSNull (DotRepresentation)

-(void)appendDotRepresentationToString:(NSMutableString*)s withContext:(OCVContext*)context;

@end

@interface NSString (DotRepresentation)

-(BOOL)processFields;
-(void)appendDotRepresentationToString:(NSMutableString*)s withContext:(OCVContext*)context;

@end

@interface NSArray (DotRepresentation)

-(BOOL)processFields;
-(void)appendDotRepresentationToString:(NSMutableString*)s withContext:(OCVContext*)context;

@end

@interface NSDictionary (DotRepresentation)

-(BOOL)processFields;
-(void)appendDotRepresentationToString:(NSMutableString*)s withContext:(OCVContext*)context;

@end

