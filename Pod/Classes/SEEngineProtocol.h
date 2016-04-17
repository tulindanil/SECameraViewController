//
//  SEEngineProtocol.h
//  Pods
//
//  Created by Danil Tulin on 3/14/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SEShape.h"

@protocol EngineProtocol <NSObject>

@required

- (void)feedBGRAImageData:(NSData *)data
					width:(NSUInteger)width
				   height:(NSUInteger)height
                     area:(SEShape *)area;

@property (nonatomic) float progress;
@property (nonatomic) BOOL isAbleToProcess;

- (void)startSession;
- (void)stopSession;

@end