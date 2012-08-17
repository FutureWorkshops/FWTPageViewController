#import "PageView.h"

@interface PageView ()
@property (nonatomic, readwrite, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *imageView;
@end

@implementation PageView
@synthesize label = _label;
@synthesize imageView = _imageView;

- (void)dealloc
{
    self.imageView = nil;
    self.label = nil;
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.imageView.superview)
        [self addSubview:self.imageView];
    
    UIEdgeInsets imageViewEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.imageView.frame = UIEdgeInsetsInsetRect(self.bounds, imageViewEdgeInsets);
    
    if (!self.label.superview)
        [self addSubview:self.label];
    
    self.label.frame = self.bounds;
}

#pragma mark - Getters
- (UILabel *)label
{
    if (!self->_label)
    {
        self->_label = [[UILabel alloc] init];
        self->_label.backgroundColor = [UIColor clearColor];
//        self->_label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noise.png"]];
        self->_label.textAlignment = UITextAlignmentCenter;
        self->_label.font = [UIFont boldSystemFontOfSize:120];
        self->_label.textColor = [UIColor colorWithWhite:.8f alpha:.7f];
        self->_label.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:.5f];
        self->_label.shadowOffset = CGSizeMake(.0f, 1.0f);
        self->_label.text = @"...";
    }
    
    return self->_label;
}

- (UIImageView *)imageView
{
    if (!self->_imageView)
    {
        //
        CGSize size = CGSizeMake(31, 31);
        CGRect ctxRect = CGRectMake(.0f, .0f, size.width, size.height);
        UIGraphicsBeginImageContextWithOptions(size, NO, .0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGRect bpRect = CGRectInset(ctxRect, 5, 5);
        CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:.925f alpha:1.0f].CGColor);
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:.9f alpha:1.0f].CGColor);
        UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:bpRect cornerRadius:10.0f];
        CGContextSaveGState(ctx);
        CGContextSetShadowWithColor(ctx, CGSizeMake(.0f, .0f), 5.0f, [[UIColor blackColor] colorWithAlphaComponent:.7f].CGColor);
        [bp fill];
        CGContextRestoreGState(ctx);
        [bp stroke];        
        
        //
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
        self->_imageView = [[UIImageView alloc] initWithImage:image];
    }
    
    return self->_imageView;
}

@end
