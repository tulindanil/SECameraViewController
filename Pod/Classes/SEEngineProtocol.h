//
//  SEEngineProtocol.h
//  Pods
//
//  Created by Danil Tulin on 3/14/16.
//
//

#import <Foundation/Foundation.h>

@protocol EngineProtocol <NSObject>

@required

- (void)feedBGRAImageData:(u_int8_t *)data
					width:(NSUInteger)width
				   height:(NSUInteger)height;

@property (nonatomic) float progress;
@property (nonatomic) BOOL isAbleToProcess;

@end
