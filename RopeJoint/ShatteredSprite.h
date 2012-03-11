/*
 * ShatteredSprite
 *
 * Copyright (c) 2011 Michael Burford  (http://www.headlightinc.com)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"

//Can change this for what's really used...or really could alloc the memory too
//200 works for a 10x10 grid (with 2 triangles per square)
//128 = 8x8 *2
//98  = 7x7 *2
//64  = 6x6 *2
//50  = 5x5 *2
//32  = 4x4 *2
#define SHATTER_VERTEX_MAX	128


#ifndef DEFTriangleVertices
//Helper things, since it moves the triangles separately
typedef struct _TriangleVertices {
	CGPoint		pt1;
	CGPoint		pt2;
	CGPoint		pt3;
} TriangleVertices;

static inline TriangleVertices
tri(CGPoint	pt1, CGPoint pt2, CGPoint pt3) {
	TriangleVertices t;
	t.pt1 = pt1; t.pt2 = pt2; t.pt3 = pt3;
	//= {pt1, pt2, pt3 };
	return t;
}

typedef struct _TriangleColors {
	ccColor4B		c1;
	ccColor4B		c2;
	ccColor4B		c3;
} TriangleColors;
#define DEFTriangleVertices
#endif


//Subclass of CCSprite, so all the color & opacity things work by just overriding updateColor, and can use the sprite's texture too.
@interface ShatteredSprite : CCSprite {
	TriangleVertices	vertices[SHATTER_VERTEX_MAX];
	TriangleVertices	shadowVertices[SHATTER_VERTEX_MAX];
    TriangleVertices	texCoords[SHATTER_VERTEX_MAX];
	TriangleColors		colorArray[SHATTER_VERTEX_MAX];
	
	float				adelta[SHATTER_VERTEX_MAX];
	CGPoint				vdelta[SHATTER_VERTEX_MAX];
	CGPoint				centerPt[SHATTER_VERTEX_MAX];
	
	float				shatterSpeedVar, shatterRotVar;
	
	NSInteger			numVertices;
	NSInteger			subShatterPercent;
	
	Boolean				radial;
	Boolean				slowExplosion;	
	NSInteger			fallOdds, fallPerSec;
	CGPoint				gravity;
	
	Boolean				shadowed;
	CCTexture2D			*shadowTexture;
}
@property (assign) NSInteger	subShatterPercent;
@property (assign) CGPoint		gravity;

//Regular version, like breaking glass that shatters all at once.
+ (id) shatterWithSprite:(CCSprite*)sprite piecesX:(NSInteger)piecesX piecesY:(NSInteger)piecesY speed:(float)speedVar rotation:(float)rotVar radial:(Boolean)radial;
- (id) initWithSprite:(CCSprite*)sprite piecesX:(NSInteger)piecesX piecesY:(NSInteger)piecesY speed:(float)speedVar rotation:(float)rotVar radial:(Boolean)radial;

//"Slow" that drops out pieces at a time, you should also set Gravity so they move off the correct direction.
+ (id) shatterWithSpriteSlow:(CCSprite*)sprite piecesX:(NSInteger)piecesX piecesY:(NSInteger)piecesY speed:(float)speedVar rotation:(float)rotVar radial:(Boolean)radial fallPerSec:(NSInteger)fallPS;
- (id) initWithSpriteSlow:(CCSprite*)sprite piecesX:(NSInteger)piecesX piecesY:(NSInteger)piecesY speed:(float)speedVar rotation:(float)rotVar radial:(Boolean)radial fallPerSec:(NSInteger)fallPS;

- (void)shatterSprite:(CCSprite*)sprite piecesX:(NSInteger)piecesX piecesY:(NSInteger)piecesY speed:(float)speedVar rotation:(float)rotVar radial:(Boolean)radial;
- (void)subShatter;
- (void)shadowedPieces;

@end
