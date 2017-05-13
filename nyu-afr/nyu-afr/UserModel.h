//
//  UserModel.h
//  nyu-afr
//
//  Created by Chairuni Aulia Nusapati on 4/21/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (strong, nonatomic) NSMutableDictionary *userData;
/* DATA SCHEME */
/*
userData: {
    badges: {
        (badge_id_1): (timestamp),
        ..
        (badge_id_n): (timestamp)
    },
    categories: {
        (category_id_1): (timestamp),
        ..
        (category_id_n): (timestamp)
    },
    current_quest: {
        category: (category_id),
        clue: (clue),
        key: (quest_id),
        latitude: (latitude),
        longitude: (longitude),
        placename: (placename),
        street_address: (street_address)
    },
    deception_quest1: {
        category: (category_id),
        clue: (clue),
        key: (quest_id),
        latitude: (latitude),
        longitude: (longitude),
        placename: (placename),
        street_address: (street_address)
    },
    deception_quest2: {
        category: (category_id),
        clue: (clue),
        key: (quest_id),
        latitude: (latitude),
        longitude: (longitude),
        placename: (placename),
        street_address: (street_address)
    },
    display_name: (display_name),
    email: (email_address),
    quests: {
        (quest_id_1): {
            selfie_url: (selfie_url),
            timestamp: (timestamp)
        },
        ..
        (quest_id_n): {
            selfie_url: (selfie_url),
            timestamp: (timestamp)
        }
    },
    photo_url: (profile_picture_url),
    summary: {
        bronze: (num_of_bronzes),
        gold: (num_of_golds),
        silver: (num_of_silvers),
        quests: (num_of_quests)
    }
}
*/

- (id)initWithUserData:(NSMutableDictionary *)userData;

@end
