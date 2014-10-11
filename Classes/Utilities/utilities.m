//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <MobileCoreServices/MobileCoreServices.h>

#import "utilities.h"
#import "WelcomeView.h"
#import "NavigationController.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
BOOL ShouldStartPhotoLibrary(id object, BOOL canEdit)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
		 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) return NO;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
		&& [[UIImagePickerController availableMediaTypesForSourceType:
			 UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage])
	{
		cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
	}
	else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
			 && [[UIImagePickerController availableMediaTypesForSourceType:
				  UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage])
	{
		cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
	}
	else return NO;
	
	cameraUI.allowsEditing = canEdit;
	cameraUI.delegate = object;
	
	[object presentViewController:cameraUI animated:YES completion:nil];
	
	return YES;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void LoginUser(id target)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:[[WelcomeView alloc] init]];
	[target presentViewController:navigationController animated:YES completion:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
UIImage* ResizeImage(UIImage *image, CGFloat width, CGFloat height)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	CGSize size = CGSizeMake(width, height);
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void PostNotification(NSString *notification)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
NSString* TimeElapsed(NSTimeInterval seconds)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *elapsed;
	if (seconds < 60 * 60)
	{
		int minutes = (int) (seconds / 60);
		elapsed = [NSString stringWithFormat:@"%d %@", minutes, (minutes > 1) ? @"mins" : @"min"];
	}
	else if (seconds < 24 * 60 * 60)
	{
		int hours = (int) (seconds / (60 * 60));
		elapsed = [NSString stringWithFormat:@"%d %@", hours, (hours > 1) ? @"hours" : @"hour"];
	}
	else
	{
		int days = (int) (seconds / (24 * 60 * 60));
		elapsed = [NSString stringWithFormat:@"%d %@", days, (days > 1) ? @"days" : @"day"];
	}
	return elapsed;
}