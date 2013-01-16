//
//  OCVContext.h
//  ObjCViz
//
//  Created by Olivier Gutknecht on 12/17/06.
//  Copyright 2006 No Distance. See LICENSE.txt file.
//

#import <Foundation/Foundation.h>


@interface OCVContext : NSObject {
	NSMutableSet* visited;
}

-(void)appendGraphvizRepresentationFor:(id)obj toString:(NSMutableString*)s;

@end


@interface NSObject (OCVContext)

-(NSString*)graphvizRepresentation;

@end
