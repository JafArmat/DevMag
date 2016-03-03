//
//  Produs.m
//  DevMag
//
//  Created by Alexandru Antonica on 12/17/15.
//  Copyright © 2015 Alexandru Antonica. All rights reserved.
//

#import "Produs.h"

@implementation Produs

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    return self;
}


-(id)initWithName:(NSString *)nume descriere:(NSString *)descriere features:(NSString*)features thumbnail:(NSString*)thumbnail
             pret:(NSString*)pret rating:(NSNumber*)rating photos:(NSArray*)photos uniqueID:(NSNumber*)uniqueID mobileURL:(NSString*)mobileURL{
                  

    self = [super init];
    if(self){
        
        self.nume               = nume;
        self.descriere          = descriere;
        self.thumbnail          = thumbnail;
        self.rating             = rating;
        self.photos             = photos;
        self.pret               = pret;
        self.rating             = rating;
        self.uniqueID           = uniqueID;
        self.features           = features;
        self.mobileURL          = mobileURL;
        
    }
    
    return self;
}


-(id)initWithDictionary:(NSDictionary *)dictionary{

    //BESTBUY API
    NSArray *pictures           = @[[dictionary objectForKey:@"image"],
                                    [dictionary objectForKey:@"angleImage"]
                                           ];
    NSMutableArray *copyPictures = [pictures mutableCopy];
    [copyPictures removeObjectIdenticalTo:[NSNull null]];
    
    pictures = [[NSArray alloc] initWithArray:copyPictures];
    
    NSString *thumbnail         = [dictionary objectForKey:@"thumbnailImage"];
    NSString *nume              = [dictionary objectForKey:@"name"];
    NSString *descriere         = [dictionary objectForKey:@"longDescription"];
    NSString *pret              = [dictionary objectForKey:@"regularPrice"];
    NSString *features          = [dictionary objectForKey:@"shortDescription"];
    NSNumber *rating            = [dictionary objectForKey:@"customerReviewAverage"];
    NSNumber *uniqueID          = [dictionary objectForKey:@"productId"];
    NSString *mobileUrl         = [dictionary objectForKey:@"mobileUrl"];
    //Check to see if any is null
    if (thumbnail == nil) {
        NSLog(@"thumbnail nil");
    }

    if (nume == nil) {
        NSLog(@"nume nil");
    }
    
    if (descriere == nil) {
        NSLog(@"descriere nil");
    }
    
    if (pret == nil) {
        NSLog(@"pret nil");
    }
    
    if (features == nil) {
        NSLog(@"features nil");
    }
    
    if (rating == nil) {
        NSLog(@"rating nil");
    }
    
    if (uniqueID == nil) {
        NSLog(@"uniqueID nil");
    }
    
    return [self initWithName:nume
                    descriere:descriere
                     features:features
                thumbnail:thumbnail
                         pret:pret
                    rating:rating
                       photos:pictures
                     uniqueID:uniqueID
                    mobileURL:mobileUrl];
    
}



+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToHeight: (float) i_height
{
    float oldHeight = sourceImage.size.height;
    float scaleFactor = i_height / oldHeight;
    
    float newWidth = sourceImage.size.width* scaleFactor;
    float newHeight = oldHeight * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
