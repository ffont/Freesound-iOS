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


# pragma mark - Text Search

+ (NSURL *)URLforTextSearchWithSearchParameters:(NSDictionary *)parameters
{
    //  "parameters" must be a dictionary with text search parameters as defined in Freesound API docummentation (www.freesound.org/docs/api/resources_apiv2.html#text-search)
    //  Both keys and values of the dictionary must be of the class NSString
    NSString *url = [NSString stringWithFormat:@"%@?%@", TEXT_SEARCH_URL, [self serializeParameterDictionary:parameters]];
    return [self prepareURL:url];
}


@end