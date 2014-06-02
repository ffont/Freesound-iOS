Freesound-iOS
=============

iOS/Objective-c client to interface with the Freesound APIv2 and sample iPhone application.

This client only provides functions to interface with basic Freesound APIv2 resources.
OAuth2 required resources are not yet supported. 
Check the Freesound API docummentation here: www.freesound.org/docs/api.


How to use
----------

Set up the client files in your project:

  1) Add the 'Freesound-iOS' folder of this repositiry to your project tree.

  2) Request a Freesound API key at www.freesound.org/apiv2/apply.

  3) Edit the file 'FreesoundAPIKey.example.h' and add your api key.

  4) Rename 'FreesoundAPIKey.example.h' to 'FreesoundAPIKey.h'.


After setting up, you can include 'Freesound-iOS.h' in your view controllers and use the functions provided by the client. Freesound-iOS defines a series of functions that return NSURL* objects to access several Freesound APIv2 resources. You can use these urls to perform requests yourself. 

Alternatively, the client provides three functions that can handle the request for you and may easy up things in some situations. These functions are:

+ + (NSDictionary *)fetchURL:(NSURL *)url; <- retrieves the contents given by the NSURL* object and return them as an NSDictionary*. This method is synchronous therefore if used as is it will block your current queue (not recommended!).

+ + (void)fetchURL:(NSURL *)url withCompletionHandler:(void(^)(NSDictionary *results))handler; <- retrieves the contents given by the NSURL* object performing the request asynchronously (thus non blocking your current queue). Once response is received, the block ('withCompletionHandler') is executed on the main queue. This block has a parameter ('results') that contains an NSDictionary* with the contents of the response.

+ + (void)fetchURL:(NSURL *)url withCompletionHandler:(void(^)(NSDictionary *results))handler onQueue:(dispatch_queue_t)queue; <- retrieves the contents given by the NSURL* object performing the request asynchronously (thus non blocking your current queue). Once response is received, the block ('withCompletionHandler') is executed on the queue specified in the function call ('onQueue'). This block has a parameter ('results') that contains an NSDictionary* with the contents of the response.

The NSDictionary* with the results returned in any of the above functions will return 'nil' if no response is successfully obtained from the request.
Note that these functions do not correctly do error handling and are only intented to help you getting started with the api. Use them with care ;)




