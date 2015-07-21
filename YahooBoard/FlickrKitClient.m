//
//  FlickrKitClient.m
//  YahooBoard
//

#import "FlickrKitClient.h"
#import "Flickr.h"

@interface FlickrKitClient ()

@property (nonatomic, retain) FlickrKit *flickrKit;

@end

static NSString *_apikey = @"9174b922a25a0436de9628c702c86a83";
static NSString *_apiSecret = @"a8ec9e22490aa357";

@implementation FlickrKitClient

+ (FlickrKitClient *)sharedInstance {
    static FlickrKitClient *sharedInstance = nil;
    static dispatch_once_t initializer;
    
    dispatch_once(&initializer, ^{
        sharedInstance = [[FlickrKitClient alloc] init];
    });
    return sharedInstance;
}

- (void) searchPhotoWithText:(NSString *)searchText page:(int)page pageCount:(int)pageCount sortBy:(NSString *)sortBy completion:(void (^)(NSArray *, NSError *))callback{
    static FKFlickrPhotosSearch *search = nil;
    static dispatch_once_t initializer;
    dispatch_once(&initializer, ^{
        search = [[FKFlickrPhotosSearch alloc] init];
    });
    
    if (sortBy == nil || [sortBy isEqualToString:@""]) {
        sortBy = @"relevance";
    }
    
    search.text     = searchText;
    search.per_page = [NSString stringWithFormat:@"%d", pageCount];
    search.sort     = sortBy;
    search.page     = [NSString stringWithFormat:@"%d", page];
    
    __weak typeof(self) weakSelf = self;
    
    [self.flickrKit call:search completion: ^(NSDictionary *response, NSError *error) {
        NSArray *data = nil;
        if (response) {
            data = [weakSelf flickrsFromSearchResponse:response];
        }
        callback(data, error);
    }];
    
}

- (NSArray *)flickrsFromSearchResponse:(NSDictionary *)response {
    NSDictionary *info = response[@"photos"];
    NSMutableArray *flickrsObjs = [[NSMutableArray alloc] init];
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSURL *url;
        for (id photoInfo in info[@"photo"]) {
            //NSLog(@"photo in %@", photoInfo);
            url = [[FlickrKitClient sharedInstance].flickrKit photoURLForSize:FKPhotoSizeSmall320 fromPhotoDictionary:photoInfo];
            Flickr *flickrObj = [[Flickr alloc] initWithDictionary:photoInfo potoUrl:url];
            [flickrsObjs addObject:flickrObj];
        }
    }
    return flickrsObjs;
}


- (FlickrKit *)flickrKit {
    return _flickrKit;
}

- (id)init {
    if (self = [super init]) {
        _flickrKit = [FlickrKit sharedFlickrKit];
        [_flickrKit initializeWithAPIKey:_apikey sharedSecret:_apiSecret];
    }
    return self;
}

@end