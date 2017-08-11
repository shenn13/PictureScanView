//
//  LOTAnimationView
//  LottieAnimator
//
//  Created by Brandon Withrow on 12/14/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import "LOTAnimationView.h"
#import "LOTPlatformCompat.h"
#import "LOTModels.h"
#import "LOTHelpers.h"
#import "LOTAnimationView_Internal.h"
#import "LOTAnimationCache.h"
#import "LOTCompositionContainer.h"

@implementation LOTAnimationView {
  CAAnimation *_playAnimation;
  LOTCompositionContainer *_compContainer;
  NSBundle *_bundle;
}

# pragma mark - Initializers

+ (nonnull instancetype)animationNamed:(nonnull NSString *)animationName {
  return [self animationNamed:animationName inBundle:[NSBundle mainBundle]];
}

+ (nonnull instancetype)animationNamed:(nonnull NSString *)animationName inBundle:(nonnull NSBundle *)bundle {
  NSArray *components = [animationName componentsSeparatedByString:@"."];
  animationName = components.firstObject;
  
  LOTComposition *comp = [[LOTAnimationCache sharedCache] animationForKey:animationName];
  if (comp) {
    return [[LOTAnimationView alloc] initWithModel:comp inBundle:bundle];
  }
  
  NSError *error;
  NSString *filePath = [bundle pathForResource:animationName ofType:@"json"];
  NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
  NSDictionary  *JSONObject = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData
                                                                         options:0 error:&error] : nil;
  if (JSONObject && !error) {
    LOTComposition *laScene = [[LOTComposition alloc] initWithJSON:JSONObject withAssetBundle:bundle];
    [[LOTAnimationCache sharedCache] addAnimation:laScene forKey:animationName];
    LOTAnimationView *animationView = [[LOTAnimationView alloc] initWithModel:laScene inBundle:bundle];
    animationView.cacheKey = animationName;
    return animationView;
  }
  NSLog(@"%s: Animation Not Found", __PRETTY_FUNCTION__);
  return [[LOTAnimationView alloc] initWithModel:nil inBundle:nil];
}

+ (nonnull instancetype)animationFromJSON:(nonnull NSDictionary *)animationJSON {
    return [self animationFromJSON:animationJSON inBundle:[NSBundle mainBundle]];
}

+ (nonnull instancetype)animationFromJSON:(nullable NSDictionary *)animationJSON inBundle:(nullable NSBundle *)bundle {
  LOTComposition *laScene = [[LOTComposition alloc] initWithJSON:animationJSON withAssetBundle:bundle];
  return [[LOTAnimationView alloc] initWithModel:laScene inBundle:bundle];
}

+ (nonnull instancetype)animationWithFilePath:(nonnull NSString *)filePath {
  NSString *animationName = filePath;
  
  LOTComposition *comp = [[LOTAnimationCache sharedCache] animationForKey:animationName];
  if (comp) {
    return [[LOTAnimationView alloc] initWithModel:comp inBundle:[NSBundle mainBundle]];
  }
  
  NSError *error;
  NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
  NSDictionary  *JSONObject = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData
                                                                         options:0 error:&error] : nil;
  if (JSONObject && !error) {
    LOTComposition *laScene = [[LOTComposition alloc] initWithJSON:JSONObject withAssetBundle:[NSBundle mainBundle]];
    laScene.rootDirectory = [filePath stringByDeletingLastPathComponent];
    [[LOTAnimationCache sharedCache] addAnimation:laScene forKey:animationName];
    LOTAnimationView *animationView = [[LOTAnimationView alloc] initWithModel:laScene inBundle:[NSBundle mainBundle]];
    animationView.cacheKey = animationName;
    return animationView;
  }
  
  NSLog(@"%s: Animation Not Found", __PRETTY_FUNCTION__);
  return [[LOTAnimationView alloc] initWithModel:nil inBundle:nil];
}

- (instancetype)initWithContentsOfURL:(NSURL *)url {
  self = [super initWithFrame:CGRectZero];
  if (self) {
    LOTComposition *laScene = [[LOTAnimationCache sharedCache] animationForKey:url.absoluteString];
    if (laScene) {
      self.cacheKey = url.absoluteString;
      [self _initializeAnimationContainer];
      [self _setupWithSceneModel:laScene];
    } else {
      dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSData *animationData = [NSData dataWithContentsOfURL:url];
        if (!animationData) {
          return;
        }
        NSError *error;
        NSDictionary  *animationJSON = [NSJSONSerialization JSONObjectWithData:animationData
                                                                       options:0 error:&error];
        if (error || !animationJSON) {
          return;
        }
        
        LOTComposition *laScene = [[LOTComposition alloc] initWithJSON:animationJSON withAssetBundle:[NSBundle mainBundle]];
        dispatch_async(dispatch_get_main_queue(), ^(void){
          [[LOTAnimationCache sharedCache] addAnimation:laScene forKey:url.absoluteString];
          self.cacheKey = url.absoluteString;
          [self _initializeAnimationContainer];
          [self _setupWithSceneModel:laScene];
        });
      });
    }
  }
  return self;
}

- (instancetype)initWithModel:(LOTComposition *)model inBundle:(NSBundle *)bundle {
  self = [super initWithFrame:model.compBounds];
  if (self) {
    _bundle = bundle;
    [self _initializeAnimationContainer];
    [self _setupWithSceneModel:model];
  }
  return self;
}

# pragma mark - Internal Methods

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

- (void)_initializeAnimationContainer {
  self.clipsToBounds = YES;
}

#else

- (void)_initializeAnimationContainer {
  self.wantsLayer = YES;
}

#endif

- (void)_setupWithSceneModel:(LOTComposition *)model {
  _cacheEnable = YES;
  _animationSpeed = 1;
  _sceneModel = model;
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  _compContainer = [[LOTCompositionContainer alloc] initWithModel:nil inLayerGroup:nil withLayerGroup:_sceneModel.layerGroup withAssestGroup:_sceneModel.assetGroup];
  [self.layer addSublayer:_compContainer];
  _compContainer.currentFrame = @0;
  [CATransaction commit];
}

# pragma mark - External Methods

- (void)play {
  [self playFromFrame:_sceneModel.startFrame toFrame:_sceneModel.endFrame withCompletion:nil];
}

- (void)playWithCompletion:(LOTAnimationCompletionBlock)completion {
  [self playFromFrame:_sceneModel.startFrame toFrame:_sceneModel.endFrame withCompletion:completion];
}

- (void)playToProgress:(CGFloat)progress withCompletion:(nullable LOTAnimationCompletionBlock)completion {
  [self playFromProgress:0 toProgress:progress withCompletion:completion];
}

- (void)playFromProgress:(CGFloat)fromStartProgress
              toProgress:(CGFloat)toEndProgress
          withCompletion:(nullable LOTAnimationCompletionBlock)completion{
  CGFloat startFrame = ((_sceneModel.endFrame.floatValue - _sceneModel.startFrame.floatValue) * fromStartProgress) + _sceneModel.startFrame.floatValue;
  CGFloat endFrame = ((_sceneModel.endFrame.floatValue - _sceneModel.startFrame.floatValue) * toEndProgress) + _sceneModel.startFrame.floatValue;
  [self playFromFrame:@(startFrame) toFrame:@(endFrame) withCompletion:completion];
}

- (void)playToFrame:(nonnull NSNumber *)toFrame
     withCompletion:(nullable LOTAnimationCompletionBlock)completion{
  [self playFromFrame:_sceneModel.startFrame toFrame:toFrame withCompletion:completion];
}

- (void)playFromFrame:(nonnull NSNumber *)fromStartFrame
              toFrame:(nonnull NSNumber *)toEndFrame
       withCompletion:(nullable LOTAnimationCompletionBlock)completion {
  if (_isAnimationPlaying) {
    return;
  }
  NSTimeInterval offset = MAX(0, (_animationProgress * (_sceneModel.endFrame.floatValue - _sceneModel.startFrame.floatValue)) - fromStartFrame.floatValue) / _sceneModel.framerate.floatValue;
  NSTimeInterval duration = ((toEndFrame.floatValue - fromStartFrame.floatValue) / _sceneModel.framerate.floatValue);
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"currentFrame"];
  animation.speed = _animationSpeed;
  animation.fromValue = fromStartFrame;
  animation.toValue = toEndFrame;
  animation.duration = duration;
  animation.fillMode = kCAFillModeBoth;
  animation.repeatCount = _loopAnimation ? HUGE_VALF : 1;
  animation.autoreverses = _autoReverseAnimation;
  animation.delegate = self;
  animation.removedOnCompletion = NO;
  if (completion) {
    self.completionBlock = completion;
  }
  _playAnimation = animation;
  _playAnimation.beginTime = CACurrentMediaTime() - offset;
  [_compContainer addAnimation:animation forKey:@"play"];
  _isAnimationPlaying = YES;
}

- (void)stop {
  self.animationProgress = 0;
}

- (void)pause {
  _playAnimation.delegate = nil;
  _playAnimation.speed = 0;
  NSNumber *frame = [_compContainer.presentationLayer.currentFrame copy];
  _animationProgress = frame.floatValue / _sceneModel.endFrame.floatValue;
  [self _removeCurrentAnimationIfNecessary];
  [self _callCompletionIfNecessary:NO];
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  _compContainer.currentFrame = frame;
  [CATransaction commit];
}


- (void)setLoopAnimation:(BOOL)loopAnimation {
  _loopAnimation = loopAnimation;
  _playAnimation.repeatCount = _loopAnimation ? HUGE_VALF : 1;
}

- (void)setProgressWithFrame:(nonnull NSNumber *)currentFrame {
  [self _removeCurrentAnimationIfNecessary];
  [self _callCompletionIfNecessary:NO];
  _animationProgress = currentFrame.floatValue / (_sceneModel.endFrame.floatValue - _sceneModel.startFrame.floatValue);
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  _compContainer.currentFrame = currentFrame;
  [_compContainer setNeedsDisplay];
  [CATransaction commit];
}

- (void)setCacheEnable:(BOOL)cacheEnable{
  _cacheEnable = cacheEnable;
  if (!self.cacheKey) {
    return;
  }
  if (cacheEnable) {
    [[LOTAnimationCache sharedCache] addAnimation:_sceneModel forKey:self.cacheKey];
  }else {
    [[LOTAnimationCache sharedCache] removeAnimationForKey:self.cacheKey];
  }
}

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

- (void)addSubview:(nonnull LOTView *)view
      toLayerNamed:(nonnull NSString *)layer
    applyTransform:(BOOL)applyTransform {
  CGRect viewRect = view.frame;
  LOTView *wrapperView = [[LOTView alloc] initWithFrame:viewRect];
  view.frame = view.bounds;
  view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [wrapperView addSubview:view];
  [self addSubview:wrapperView];
  [_compContainer addSublayer:wrapperView.layer toLayerNamed:layer applyTransform:applyTransform];
  CGRect newRect = [self.layer convertRect:viewRect toLayer:wrapperView.layer.superlayer];
  wrapperView.layer.frame = newRect;
  view.frame = newRect;
}

#else

- (void)addSubview:(nonnull LOTView *)view
      toLayerNamed:(nonnull NSString *)layer
    applyTransform:(BOOL)applyTransform {
  CGRect viewRect = view.frame;
  LOTView *wrapperView = [[LOTView alloc] initWithFrame:viewRect];
  view.frame = view.bounds;
  view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
  [wrapperView addSubview:view];
  [self addSubview:wrapperView];
  [_compContainer addSublayer:wrapperView.layer toLayerNamed:layer applyTransform:applyTransform];
  CGRect newRect = [self.layer convertRect:viewRect toLayer:wrapperView.layer.superlayer];
  wrapperView.layer.frame = newRect;
  view.frame = newRect;
}

#endif
- (void)setValue:(nonnull id)value
      forKeypath:(nonnull NSString *)keypath
         atFrame:(nullable NSNumber *)frame{
  BOOL didUpdate = [_compContainer setValue:value forKeypath:keypath atFrame:frame];
  if (didUpdate) {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_compContainer displayWithFrame:_compContainer.currentFrame forceUpdate:YES];
    [CATransaction commit];
  }
}

- (void)_removeCurrentAnimationIfNecessary {
  _playAnimation.speed = 0;
  _isAnimationPlaying = NO;
  _playAnimation.delegate = nil;
  [_compContainer removeAllAnimations];
  _playAnimation = nil;
}


# pragma mark - Completion Block

- (void)_callCompletionIfNecessary:(BOOL)complete {
  if (self.completionBlock) {
    self.completionBlock(complete);
    self.completionBlock = nil;
  }
}

# pragma mark - Getters and Setters

- (void)setAnimationProgress:(CGFloat)animationProgress {
  [self _removeCurrentAnimationIfNecessary];
  [self _callCompletionIfNecessary:NO];
  CGFloat duration = _sceneModel.endFrame.floatValue - _sceneModel.startFrame.floatValue;
  CGFloat frame = (duration * animationProgress) + _sceneModel.startFrame.floatValue;
  _animationProgress = animationProgress;
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  _compContainer.currentFrame = @(frame);
  [_compContainer setNeedsDisplay];
  [CATransaction commit];
}

-(void)setAnimationSpeed:(CGFloat)animationSpeed {
  _animationSpeed = animationSpeed;
  _playAnimation.speed = animationSpeed;
}

# pragma mark - Overrides

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#define LOTViewContentMode UIViewContentMode
#define LOTViewContentModeScaleToFill UIViewContentModeScaleToFill
#define LOTViewContentModeScaleAspectFit UIViewContentModeScaleAspectFit
#define LOTViewContentModeScaleAspectFill UIViewContentModeScaleAspectFill
#define LOTViewContentModeRedraw UIViewContentModeRedraw
#define LOTViewContentModeCenter UIViewContentModeCenter
#define LOTViewContentModeTop UIViewContentModeTop
#define LOTViewContentModeBottom UIViewContentModeBottom
#define LOTViewContentModeLeft UIViewContentModeLeft
#define LOTViewContentModeRight UIViewContentModeRight
#define LOTViewContentModeTopLeft UIViewContentModeTopLeft
#define LOTViewContentModeTopRight UIViewContentModeTopRight
#define LOTViewContentModeBottomLeft UIViewContentModeBottomLeft
#define LOTViewContentModeBottomRight UIViewContentModeBottomRight

- (void)removeFromSuperview {
  [super removeFromSuperview];
  self.completionBlock = nil;
  [self _removeCurrentAnimationIfNecessary];
}

- (void)setContentMode:(LOTViewContentMode)contentMode {
  [super setContentMode:contentMode];
  [self setNeedsLayout];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self _layout];
}

#else
    
- (void)setCompletionBlock:(LOTAnimationCompletionBlock)completionBlock {
    if (completionBlock) {
      _completionBlock = ^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{ completionBlock(finished); });
      };
    }
    else {
      _completionBlock = nil;
    }
}

- (void)setContentMode:(LOTViewContentMode)contentMode {
  _contentMode = contentMode;
  [self setNeedsLayout];
}

- (void)setNeedsLayout {
  self.needsLayout = YES;
}

- (BOOL)isFlipped {
  return YES;
}

- (BOOL)wantsUpdateLayer {
  return YES;
}

- (void)layout {
  [super layout];
  [self _layout];
}

#endif

- (CGSize)intrinsicContentSize {
  return _sceneModel.compBounds.size;
}

- (void)_layout {
  CGPoint centerPoint = LOT_RectGetCenterPoint(self.bounds);
  CATransform3D xform;

  if (self.contentMode == LOTViewContentModeScaleToFill) {
    CGSize scaleSize = CGSizeMake(self.bounds.size.width / self.sceneModel.compBounds.size.width,
            self.bounds.size.height / self.sceneModel.compBounds.size.height);
    xform = CATransform3DMakeScale(scaleSize.width, scaleSize.height, 1);
  } else if (self.contentMode == LOTViewContentModeScaleAspectFit) {
    CGFloat compAspect = self.sceneModel.compBounds.size.width / self.sceneModel.compBounds.size.height;
    CGFloat viewAspect = self.bounds.size.width / self.bounds.size.height;
    BOOL scaleWidth = compAspect > viewAspect;
    CGFloat dominantDimension = scaleWidth ? self.bounds.size.width : self.bounds.size.height;
    CGFloat compDimension = scaleWidth ? self.sceneModel.compBounds.size.width : self.sceneModel.compBounds.size.height;
    CGFloat scale = dominantDimension / compDimension;
    xform = CATransform3DMakeScale(scale, scale, 1);
  } else if (self.contentMode == LOTViewContentModeScaleAspectFill) {
    CGFloat compAspect = self.sceneModel.compBounds.size.width / self.sceneModel.compBounds.size.height;
    CGFloat viewAspect = self.bounds.size.width / self.bounds.size.height;
    BOOL scaleWidth = compAspect < viewAspect;
    CGFloat dominantDimension = scaleWidth ? self.bounds.size.width : self.bounds.size.height;
    CGFloat compDimension = scaleWidth ? self.sceneModel.compBounds.size.width : self.sceneModel.compBounds.size.height;
    CGFloat scale = dominantDimension / compDimension;
    xform = CATransform3DMakeScale(scale, scale, 1);
  } else {
    xform = CATransform3DIdentity;
  }

  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  _compContainer.transform = CATransform3DIdentity;
  _compContainer.bounds = _sceneModel.compBounds;
  _compContainer.viewportBounds = _sceneModel.compBounds;
  _compContainer.transform = xform;
  _compContainer.position = centerPoint;
  [CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)complete {
  if (!_isAnimationPlaying || !complete) {
    [_compContainer displayWithFrame:_compContainer.currentFrame forceUpdate:YES];
  }
  if (!_isAnimationPlaying || !complete || ![anim isKindOfClass:[CABasicAnimation class]]) return;
  NSNumber *frame = [(CABasicAnimation *)anim toValue];
  _animationProgress = frame.floatValue / (_sceneModel.endFrame.floatValue - _sceneModel.startFrame.floatValue);
  _isAnimationPlaying = NO;
  _playAnimation.delegate = nil;
  [_compContainer removeAllAnimations];
  _playAnimation = nil;
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  _compContainer.currentFrame = frame;
  [CATransaction commit];
  [self _callCompletionIfNecessary:complete];
}

@end
