//
//  Produs.h
//  DevMag
//
//  Created by Alexandru Antonica on 12/17/15.
//  Copyright © 2015 Alexandru Antonica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Produs : NSObject <NSCoding>

@property (nonatomic,strong) NSString *nume;
@property (nonatomic,strong) NSString *descriere;
@property (nonatomic,strong) NSString *features;
@property (nonatomic,strong) NSString *thumbnail;
@property (nonatomic,strong) NSString *pret;
@property (nonatomic)        NSNumber *rating;
@property (nonatomic,strong) NSArray *photos;
@property (nonatomic,strong) NSNumber *uniqueID;
@property (nonatomic,strong) NSString *mobileURL;

-(id)initWithName:(NSString *)nume descriere:(NSString *)descriere features:(NSString*)features thumbnail:(NSString*)thumbnail
             pret:(NSString*)pret rating:(NSNumber*)rating photos:(NSArray*)photos uniqueID:(NSNumber*)uniqueID mobileURL:(NSString*)mobileURL;
    
+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToHeight: (float) i_height;
-(id) initWithDictionary:(NSDictionary*)dictionary;
@end
