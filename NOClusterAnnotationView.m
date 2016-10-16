//
//  NOClusterAnnotationView.m
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 27/8/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import "NOClusterAnnotationView.h"

@implementation NOClusterAnnotationView
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpLabel];
        [self setCount:1];
    }
    return self;
}

- (void)setUpLabel
{
    _countLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _countLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.minimumScaleFactor = 2;
    _countLabel.numberOfLines = 1;
    _countLabel.font = [UIFont boldSystemFontOfSize:12];
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    [self addSubview:_countLabel];
}

- (void)setCount:(NSUInteger)count
{
    _count = count;
    
    self.countLabel.text = [@(count) stringValue];
    [self setNeedsLayout];
}

- (void)setUniqueLocation:(BOOL)uniqueLocation
{
    _uniqueLocation = uniqueLocation;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    // Images are faster than using drawRect:
    UIImage *image;
    CGPoint centerOffset;
    CGRect countLabelFrame;
    if (self.isUniqueLocation)
    {
        // Si es el usuario
        if (self.idEmpresa == -1)
        {
            image = [SPUtilidades crearMarcador:[SPUtilidades leerImagen:@"Noctua"
                                                                 Archivo:@"fotoNoctua.jpg"]];
        }
        else
        {
            if ([self.tipo isEqual:@"P"])
                image = [SPUtilidades crearMarcador:[UIImage imageNamed:@"markerdancing.png"]];
            if ([self.tipo isEqual:@"E"])
                image = [SPUtilidades crearMarcador:[UIImage imageNamed:@"markerdj.png"]];
            if ([self.tipo isEqual:@"B"])
                image = [SPUtilidades crearMarcador:[UIImage imageNamed:@"markerbeer.png"]];
            if ([self.tipo isEqual:@"R"])
                image = [SPUtilidades crearMarcador:[UIImage imageNamed:@"markerfood.png"]];
        }
        
        centerOffset = CGPointMake(0, -image.size.height * 0.5);
        CGRect frame = self.bounds;
        frame.origin.y -= 2;
        countLabelFrame = frame;
        self.countLabel.hidden = YES;
    }
    else
    {
        int suffix;
        if (self.count > 1000)
        {
            suffix = 90;
        }
        else if (self.count > 100)
        {
            suffix = 60;
        }
        else if (self.count > 50)
        {
            suffix = 50;
        }
        else if (self.count > 20)
        {
            suffix = 45;
        }
        else if (self.count > 10)
        {
            suffix = 40;
        }
        else if (self.count > 5)
        {
            suffix = 35;
        }
        else
        {
            suffix = 30;
        }
        
        image = [SPUtilidades imageWithImage:[UIImage imageNamed:@"cluster.png"] scaledToSize:CGSizeMake(suffix, suffix)];
        
        centerOffset = CGPointZero;
        countLabelFrame = self.bounds;
        self.countLabel.hidden = NO;
    }
    
    self.countLabel.frame = countLabelFrame;
    self.image = image;
    self.centerOffset = centerOffset;
}

@end
