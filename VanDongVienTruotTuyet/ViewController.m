//
//  ViewController.m
//  VanDongVienTruotTuyet
//
//  Created by iOS17 on 10/24/13.
//  Copyright (c) 2013 iOS17. All rights reserved.
//

#import "ViewController.h"
@interface CustomView : UIView
@property(nonatomic, strong) NSMutableArray *points;
@property(nonatomic) BOOL newLine;
- (void) addPoint: (NSValue *) point;

@end
@implementation CustomView


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _points = [NSMutableArray new];
        _newLine = YES;
    }
    return self;
}

- (void) addPoint:(NSValue *)point{
    NSMutableArray *array = _points.lastObject;
    if (_newLine) {
        _newLine = NO;
        array = [NSMutableArray new];
        [_points addObject:array];
    }
    [array addObject:point];
    [self setNeedsDisplay];
}

- (void) endPoint{
    _newLine = YES;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 2.0f);
    for (NSArray *array in self.points) {
        CGPoint firstPoint = [array.firstObject CGPointValue];
        CGContextMoveToPoint(ctx, firstPoint.x, firstPoint.y);
        for (NSValue *point in array) {
            CGContextAddLineToPoint(ctx, point.CGPointValue.x, point.CGPointValue.y);
        }
    }
    CGContextStrokePath(ctx);
}

@end

@interface ViewController ()
@property(nonatomic, strong) CustomView *customview;
@property(nonatomic) BOOL draw;
@property(nonatomic) CGPoint currentpoint;
@property(nonatomic, strong) UIDynamicAnimator *animator;
@property(nonatomic, strong) UIGravityBehavior *gravity;
@property(nonatomic,strong) UICollisionBehavior *collision;

@end

@implementation ViewController
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _draw = YES;
        _currentpoint = CGPointZero;
    }
    return self;
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    _draw = YES;
    _currentpoint = CGPointZero;
    self.customview = [[CustomView alloc] initWithFrame:self.view.bounds];
    self.customview.backgroundColor = [UIColor clearColor];
    _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[]];
    _collision = [[UICollisionBehavior alloc]initWithItems:@[]];
    [_animator addBehavior:_gravity];
  //  _gravity.angle = 0.1* M_PI_2;
    _gravity.magnitude = 0.5f;
    [_animator addBehavior:_collision];
    [self.view addSubview:self.customview];
    _collision.translatesReferenceBoundsIntoBoundary = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    if (_draw) {
        if (sender.state == UIGestureRecognizerStateEnded) {
            [self.customview endPoint];
            self.currentpoint = [sender locationInView:self.view];
        }
        else if (sender.state == UIGestureRecognizerStateBegan){
            CGPoint point = [sender locationInView:self.view];
            self.currentpoint = point;
            [self.customview addPoint:[NSValue valueWithCGPoint:point ]];
        }
        else{
            CGPoint point = [sender locationInView:self.view];
            [self.customview addPoint:[NSValue valueWithCGPoint:point]];
           [_collision addBoundaryWithIdentifier:@"hehe" fromPoint:self.currentpoint toPoint:point];
            self.currentpoint = point;
            
        }
        
    }
}
- (IBAction)tap:(id)sender {
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.jpg" ]];
    imageview.center = [sender locationInView:self.view];
    [self.view addSubview:imageview];
    [_gravity addItem:imageview];
    [_collision addItem:imageview];
    
    
}

@end
