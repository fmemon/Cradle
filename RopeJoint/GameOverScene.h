//
//  GameOverScene.h
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 2/10/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "cocos2d.h"

@interface GameOverScene : CCLayer {
	CCLabelTTF *winner1;
    CCLabelTTF *winner2;
    CCLabelTTF *winner3;
	CCLabelTTF *HS1;
    CCLabelTTF *HS2;
    CCLabelTTF *HS3;

}

- (void)restoreData;
+(id) scene;

@end
