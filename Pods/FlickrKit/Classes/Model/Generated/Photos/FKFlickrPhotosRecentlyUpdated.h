//
//  FKFlickrPhotosRecentlyUpdated.h
//  FlickrKit
//
//  Generated by FKAPIBuilder on 19 Sep, 2014 at 10:49.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrAPIMethod.h"

typedef enum {
	FKFlickrPhotosRecentlyUpdatedError_RequiredArgumentMissing = 1,		 /* Some or all of the required arguments were not supplied. */
	FKFlickrPhotosRecentlyUpdatedError_NotAValidDate = 2,		 /* The date argument did not pass validation. */
	FKFlickrPhotosRecentlyUpdatedError_SSLIsRequired = 95,		 /* SSL is required to access the Flickr API. */
	FKFlickrPhotosRecentlyUpdatedError_InvalidSignature = 96,		 /* The passed signature was invalid. */
	FKFlickrPhotosRecentlyUpdatedError_MissingSignature = 97,		 /* The call required signing but no signature was sent. */
	FKFlickrPhotosRecentlyUpdatedError_LoginFailedOrInvalidAuthToken = 98,		 /* The login details or auth token passed were invalid. */
	FKFlickrPhotosRecentlyUpdatedError_UserNotLoggedInOrInsufficientPermissions = 99,		 /* The method requires user authentication but the user was not logged in, or the authenticated method call did not have the required permissions. */
	FKFlickrPhotosRecentlyUpdatedError_InvalidAPIKey = 100,		 /* The API key passed was not valid or has expired. */
	FKFlickrPhotosRecentlyUpdatedError_ServiceCurrentlyUnavailable = 105,		 /* The requested service is temporarily unavailable. */
	FKFlickrPhotosRecentlyUpdatedError_WriteOperationFailed = 106,		 /* The requested operation failed due to a temporary issue. */
	FKFlickrPhotosRecentlyUpdatedError_FormatXXXNotFound = 111,		 /* The requested response format was not found. */
	FKFlickrPhotosRecentlyUpdatedError_MethodXXXNotFound = 112,		 /* The requested method was not found. */
	FKFlickrPhotosRecentlyUpdatedError_InvalidSOAPEnvelope = 114,		 /* The SOAP envelope send in the request could not be parsed. */
	FKFlickrPhotosRecentlyUpdatedError_InvalidXMLRPCMethodCall = 115,		 /* The XML-RPC request document could not be parsed. */
	FKFlickrPhotosRecentlyUpdatedError_BadURLFound = 116,		 /* One or more arguments contained a URL that has been used for abuse on Flickr. */

} FKFlickrPhotosRecentlyUpdatedError;

/*

<p>Return a list of your photos that have been recently created or which have been recently modified.</p>

<p>Recently modified may mean that the photo's metadata (title, description, tags) may have been changed or a comment has been added (or just modified somehow :-)</p>

<p>Photos are sorted by their date updated timestamp, in descending order.</p>

Response:

<photos page="1" pages="1" perpage="100" total="2">
        <photo id="169885459" owner="35034348999@N01" 
               secret="c85114c195" server="46" title="Doubting Michael"
               ispublic="1" isfriend="0" isfamily="0" lastupdate="1150755888" />
        <photo id="85022332" owner="35034348999@N01"
               secret="23de6de0c0" server="41"
               title="&quot;Do you think we're allowed to tape stuff to the walls?&quot;"
               ispublic="1" isfriend="0" isfamily="0" lastupdate="1150564974" />
</photos>

*/
@interface FKFlickrPhotosRecentlyUpdated : NSObject <FKFlickrAPIMethod>

/* A Unix timestamp or any English textual datetime description indicating the date from which modifications should be compared. */
@property (nonatomic, copy) NSString *min_date; /* (Required) */

/* A comma-delimited list of extra information to fetch for each returned record. Currently supported fields are: <code>description</code>, <code>license</code>, <code>date_upload</code>, <code>date_taken</code>, <code>owner_name</code>, <code>icon_server</code>, <code>original_format</code>, <code>last_update</code>, <code>geo</code>, <code>tags</code>, <code>machine_tags</code>, <code>o_dims</code>, <code>views</code>, <code>media</code>, <code>path_alias</code>, <code>url_sq</code>, <code>url_t</code>, <code>url_s</code>, <code>url_q</code>, <code>url_m</code>, <code>url_n</code>, <code>url_z</code>, <code>url_c</code>, <code>url_l</code>, <code>url_o</code> */
@property (nonatomic, copy) NSString *extras;

/* Number of photos to return per page. If this argument is omitted, it defaults to 100. The maximum allowed value is 500. */
@property (nonatomic, copy) NSString *per_page;

/* The page of results to return. If this argument is omitted, it defaults to 1. */
@property (nonatomic, copy) NSString *page;


@end
