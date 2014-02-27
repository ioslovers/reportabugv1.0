

#import <Foundation/Foundation.h>

#define ERROR_CODE_NETWORK @"1001"
#define ERROR_CODE_API @"1002"
#define ERROR_CODE_DB @"1003"
#define ERROR_CODE_PARSING @"1004"
#define ERROR_CODE_UI @"1005"

@interface Logger : NSObject
{
	
}
+ (void)createLogFile;
+ (void)error:(NSString *)errorcode exception:(NSException *)e;
+ (void) writeDataToLogFile:(NSString*)fileName content:(NSString*)content;

@end
