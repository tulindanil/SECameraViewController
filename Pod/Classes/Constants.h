//
//  Constants.h
//  Pods
//
//  Created by Danil Tulin on 1/30/16.
//
//

@import Foundation;

#ifndef Constants_h
#define Constants_h

const static NSString *defaultPrimaryColor = @"1A1A1C";
const static NSString *darkPrimaryColor = @"121315";

const static NSInteger bottomToolbarHeight = 50;

const static CGFloat defaultAnimationDuration = .3f;

const static NSInteger predscriptionViewCornerViewOffset = 25;

const static CGSize SERoundButtonsContainerOffset = {25, 20};

#ifndef RUN_IF_SIMULATOR
#ifdef TARGET_IPHONE_SIMULATOR
#define RUN_IF_SIMULATOR(code) code
#else
#define RUN_IF_SIMULATOR(code)
#endif
#endif

#endif /* Constants_h */
