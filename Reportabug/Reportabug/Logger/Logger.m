
#import "Logger.h"

#define FILENAME @"app_error_log.txt"

@implementation Logger

/**
 * Create log file
 */

+ (void)createLogFile
{
	NSString *filePath;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	//get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	@try 
	{
		NSString * directory =[NSString stringWithFormat:@"Documents/logs"];
		filePath = [NSHomeDirectory() stringByAppendingPathComponent:directory];	
		if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
		{
			BOOL success=[[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
			if (success)
				NSLog(@"Directory created %@", filePath);
		}
		
		//make a file name to write the data to using the documents directory:
		filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"logs/%@",FILENAME]];
		
		BOOL success=[fileManager createFileAtPath:filePath contents:nil attributes:nil];
		
		if (success)
			NSLog(@"File created %@", filePath);
	}
	@catch (NSException *exception) 
	{
		[Logger error:ERROR_CODE_DB exception:exception];
		//		NSLog(@"\n Error in creating log file :%@, %@",[exception name], [exception description]);
	}
}


/**
 * Stores the error string to the logs
 */

+ (void)error:(NSString *)errorcode exception:(NSException *)e
{
	@try 
	{
		//get the documents directory:
		NSArray *paths = NSSearchPathForDirectoriesInDomains
		(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		//make a file name to write the data to using the documents directory:
		NSString *fileName = [NSString stringWithFormat:@"%@/logs/%@", 
						  documentsDirectory,FILENAME];
		//create content - four lines of text
		NSString *content = [NSString stringWithFormat:@"\nErrorCode : %@ \n%@ %@ %@",errorcode,[NSDate date],[e name], [e description]];
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
										 (unsigned long)NULL), ^(void) {
			[self writeDataToLogFile:fileName content:content];
		});
	}
	@catch (NSException *exception) 
	{
		[Logger error:ERROR_CODE_DB exception:exception];
	}
}

/**
* ASynchronous function to write the file so that UI Thread is not disturbed while logging in the exception.
*/
	
+ (void) writeDataToLogFile:(NSString*)fileName content:(NSString*)content
{
	NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:fileName];
	if (fh)
	{
		@try 
		{
			//save content to the documents directory
			[fh seekToEndOfFile];
			[fh writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
			
		}
		@catch (NSException *exception) 
		{
			[Logger error:ERROR_CODE_DB exception:exception];
			//			NSLog(@"\n Error in writing data to log file :%@, %@",[exception name], [exception description]);
		}
		[fh closeFile];
	}
}

@end
