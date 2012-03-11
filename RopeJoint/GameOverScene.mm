//
//  GameOverScene.m
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 2/10/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "GameOverScene.h"
#import "ComboSeeMe.h"

@implementation GameOverScene

+(id) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	GameOverScene *layer = [GameOverScene node];
    
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init] )) {
        CCSprite *sprite2 = [CCSprite spriteWithFile:@"bg.png"];
        sprite2.anchorPoint = CGPointZero;
        [self addChild:sprite2 z:-11];
        
        HS1 = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:32];
        HS1.position = ccp(240.0f, 100.0f);
        HS1.color = ccc3(26, 46, 149);
        [self addChild:HS1];
        
        winner1 = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:32];
        winner1.position = ccp(240.0f, 140.0f);
        winner1.color = ccc3(26, 46, 149);
        [self addChild:winner1];
        
        
        [self restoreData];

        tapLabel = [CCLabelTTF labelWithString:@"Tap to Restart"
                                                fontName:@"Marker Felt"
                                                fontSize:35];
		tapLabel.position = ccp(240, 131.67f);        
		[self addChild: tapLabel];
        
		myText = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 300, 28)];
		[myText setTextColor:[UIColor blackColor]];
		[myText setTextAlignment:UITextAlignmentLeft];
		[myText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[myText setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
		[myText setClearsOnBeginEditing:YES];
		[myText setBorderStyle:UITextBorderStyleRoundedRect];
		
		[myText setDelegate:self];
		[myText setReturnKeyType:UIReturnKeyDone];
		[myText setAutocapitalizationType:UITextAutocapitalizationTypeWords];
		[[[CCDirector sharedDirector] openGLView] addSubview: myText];

        
        // Enable touches
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}	
	return self;
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
	//Terminate editing 
	[textField resignFirstResponder];  
	return YES; 
} 

- (void)textFieldDidEndEditing:(UITextField*)textField { 
	NSLog(@"textFieldDidEndEditing");
    if (textField==myText) {    
		
		[myText endEditing:YES]; 
        [myText removeFromSuperview];     
		// here is where you should do something with the data they entered   
		NSLog(@"%@", myText.text);    
        [self saveData];
	}
} 


- (void)saveData {   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myText.text forKey:@"Winner1"];
    [defaults synchronize];
}


- (void)restoreData {
    
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
    if ([defaults integerForKey:@"HS1"]) {
        [HS1 setString:[NSString stringWithFormat:@"HighScore: %i",[defaults integerForKey:@"HS1"]]];
    }
    if ([defaults objectForKey:@"Winner1"]) {
        
        NSString *won = [NSString stringWithFormat:@"winner: %@",[defaults objectForKey:@"Winner1"]];
        [winner1 setString: won];
    }
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [[CCDirector sharedDirector] replaceScene:[ComboSeeMe scene]];
    return YES;
}


- (void)dealloc {
	[super dealloc];
}

@end
