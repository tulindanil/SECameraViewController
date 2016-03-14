//
//  SEEngineProtocol.h
//  Pods
//
//  Created by Danil Tulin on 3/14/16.
//
//

@protocol EngineProtocol <NSObject>

- (void)feedBGRAImageData:(u_int8_t *)data
					width:(NSUInteger)width
				  heieght:(NSUInteger)height;

@property (nonatomic) CGFloat progress;

@end
