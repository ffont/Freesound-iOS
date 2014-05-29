//
//  Freesound-iOS.m
//
//  Created by Frederic Font Corbera on 22/05/14.
//  Copyright (c) 2014 Frederic Font Corbera. All rights reserved.
//

#import "Freesound-iOS.h"

@implementation FreesoundFetcher


# pragma mark - Utils

+ (NSURL *)prepareURL:(NSString *) url
{
    //  Add base url, "token" parameter, "format" parameter and encodes "url"
    return [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@&token=%@&format=%@", FREESOUND_BASE_URL, url, FreesoundAPIKey, PreferredFormat] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)serializeParameterDictionary:(NSDictionary *) parameters
{
    //  Serializes the keys and values of an NSDictionary by converting them into a string of url parameters (&key1=value1&key2=value2...)
    //  Keys and values are only added to the serialized string if they are NSStrings
    NSString *serialized_parameters = @"";
    for(id key in parameters){
        if ([key isKindOfClass:[NSString class]] && [[parameters objectForKey:key] isKindOfClass:[NSString class]]){
            serialized_parameters = [serialized_parameters stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, [parameters objectForKey:key]]];
        }
    }
    return serialized_parameters;
}


# pragma mark - Search resources

+ (NSURL *)URLforTextSearchWithParameters:(NSDictionary *)parameters
{
    //  "parameters" must be a dictionary with text search parameters as defined in Freesound API docummentation (www.freesound.org/docs/api/resources_apiv2.html#text-search)
    //  Both keys and values of the dictionary must be of the class NSString
    NSString *url = [NSString stringWithFormat:@"%@?%@", TEXT_SEARCH_URL, [self serializeParameterDictionary:parameters]];
    return [self prepareURL:url];
}

+ (NSURL *)URLforContentSearchWithParameters:(NSDictionary *)parameters
{
    //  "parameters" must be a dictionary with content search parameters as defined in Freesound API docummentation (www.freesound.org/docs/api/resources_apiv2.html#content-search)
    //  Both keys and values of the dictionary must be of the class NSString
    NSString *url = [NSString stringWithFormat:@"%@?%@", CONTENT_SEARCH_URL, [self serializeParameterDictionary:parameters]];
    return [self prepareURL:url];
}

+ (NSURL *)URLforCombinedSearchWithParameters:(NSDictionary *)parameters
{
    //  "parameters" must be a dictionary with combined search parameters as defined in Freesound API docummentation (www.freesound.org/docs/api/resources_apiv2.html#combined-search)
    //  Both keys and values of the dictionary must be of the class NSString
    NSString *url = [NSString stringWithFormat:@"%@?%@", COMBINED_SEARCH_URL, [self serializeParameterDictionary:parameters]];
    return [self prepareURL:url];
}


# pragma mark - Sound resources

+ (NSURL *)URLforSoundWithId:(NSInteger)sound_id
{
    NSString *url = [NSString stringWithFormat:SOUND_URL, [NSString stringWithFormat:@"%i", sound_id]];
    return [self prepareURL:url];
}


# pragma mark - Pack resources

+ (NSURL *)URLforPackWithId:(NSInteger)pack_id
{
    NSString *url = [NSString stringWithFormat:PACK_URL, [NSString stringWithFormat:@"%i", pack_id]];
    return [self prepareURL:url];
}


# pragma mark - User resources

+ (NSURL *)URLforUserWithUsername:(NSString *)username
{
    NSString *url = [NSString stringWithFormat:USER_URL, username];
    return [self prepareURL:url];
}



@end