//
//  ZGPhotoEditModel.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/23.
//  Copyright © 2017年 saina. All rights reserved.
//
#define kBitsPerComponent (8)
#define kBitsPerPixel (32)
#define kPixelChannelCount (4)


#import "ZGPhotoEditModel.h"
typedef NS_ENUM(NSInteger, Pixel) {
        Alpha = 0,
        Blue = 1,
        Green = 2,
        Red = 3,
}pixel;

@implementation ZGPhotoEditModel
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
        label.text = title;
        label.font = font;
        label.numberOfLines = 0;
        [label sizeToFit];
        CGFloat height = label.frame.size.height;
        return height;
}
- (void)strokeWithContext:(CGContextRef)context {
        CGContextSetStrokeColorWithColor(context, [_lineColor CGColor]);
        CGContextSetLineWidth(context, _strokeWidth);
        CGContextSetBlendMode(context, _blendMode);
        CGContextBeginPath(context);
        CGContextAddPath(context, _path);
        CGContextStrokePath(context);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineCap(context, kCGLineCapRound);
}

/*
 *转换成马赛克,level代表一个点转为多少level*level的正方形
 */
+ (UIImage *)transToMosaicImage:(UIImage*)orginImage blockLevel:(NSUInteger)level
{
        //获取BitmapData
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGImageRef imgRef = orginImage.CGImage;
        CGFloat width = CGImageGetWidth(imgRef);
        CGFloat height = CGImageGetHeight(imgRef);
        CGContextRef context = CGBitmapContextCreate (nil,
                                                      width,
                                                      height,
                                                      kBitsPerComponent,        //每个颜色值8bit
                                                      width*kPixelChannelCount, //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit
                                                      colorSpace,
                                                      kCGImageAlphaPremultipliedLast);
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
        
        void *data = CGBitmapContextGetData (context);
        char *bitmapData = (char *)data;
        
        //这里把BitmapData进行马赛克转换,就是用一个点的颜色填充一个level*level的正方形
        unsigned char pixel[kPixelChannelCount] = {0};
        NSUInteger index,preIndex;
        for (NSUInteger i = 0; i < height - 1 ; i++) {
                for (NSUInteger j = 0; j < width - 1; j++) {
                        index = i * width + j;
                        if (i % level == 0) {
                                if (j % level == 0) {
                                        memcpy(pixel, bitmapData + kPixelChannelCount*index, kPixelChannelCount);
                                }else{
                                        memcpy(bitmapData + kPixelChannelCount*index, pixel, kPixelChannelCount);
                                }
                        } else {
                                preIndex = (i-1)*width +j;
                                memcpy(bitmapData + kPixelChannelCount*index, bitmapData + kPixelChannelCount*preIndex, kPixelChannelCount);
                        }
                }
        }
        
        NSInteger dataLength = width*height* kPixelChannelCount;
        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData, dataLength, NULL);
        //创建要输出的图像
        CGImageRef mosaicImageRef = CGImageCreate(width, height,
                                                  kBitsPerComponent,
                                                  kBitsPerPixel,
                                                  width*kPixelChannelCount ,
                                                  colorSpace,
                                                  kCGBitmapByteOrderDefault,
                                                  provider,
                                                  NULL, NO,
                                                  kCGRenderingIntentDefault);
        CGContextRef outputContext = CGBitmapContextCreate(nil,
                                                           width,
                                                           height,
                                                           kBitsPerComponent,
                                                           width*kPixelChannelCount,
                                                           colorSpace,
                                                           kCGImageAlphaPremultipliedLast);
        CGContextDrawImage(outputContext, CGRectMake(0.0f, 0.0f, width, height), mosaicImageRef);
        CGImageRef resultImageRef = CGBitmapContextCreateImage(outputContext);
        UIImage *resultImage = nil;
        if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
                float scale = [[UIScreen mainScreen] scale];
                resultImage = [UIImage imageWithCGImage:resultImageRef scale:scale orientation:UIImageOrientationUp];
        } else {
                resultImage = [UIImage imageWithCGImage:resultImageRef];
        }
        //释放
        if(resultImageRef){
                CFRelease(resultImageRef);
        }
        if(mosaicImageRef){
                CFRelease(mosaicImageRef);
        }
        if(colorSpace){
                CGColorSpaceRelease(colorSpace);
        }
        if(provider){
                CGDataProviderRelease(provider);
        }
        if(context){
                CGContextRelease(context);
        }
        if(outputContext){
                CGContextRelease(outputContext);
        }
        //改变mosaicImage的大小之后在返回新的image
        CGSize targetSize = orginImage.size;
        UIGraphicsBeginImageContext(targetSize);
        CGRect thumbnailRect = CGRectZero;
        CGFloat targetWidth = targetSize.width;
        CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
        CGFloat targetHeight = targetSize.height;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width  = targetWidth;
        thumbnailRect.size.height = targetHeight;
        
        [resultImage drawInRect:thumbnailRect];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return newImage;
        
}
#pragma mark - 转换mosaic图片的颜色
+ (UIImage *)textureWithTintColor:(UIColor *)color image:(UIImage *)imag{
        CGFloat red, green, blue, alpha;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        // 1
        uint8_t blendRed = ( (1 - alpha) + alpha * red) * 255;
        uint8_t blendGreen = ( (1 - alpha) + alpha * green ) * 255;
        uint8_t blendBlue = ( (1 - alpha) + alpha * blue ) * 255;
        
        CGSize size = imag.size;
        int width = size.width;
        int height = size.height;
        
        uint32_t *pixels = (uint32_t *)malloc(width * height * sizeof(uint32_t));
        
        memset(pixels, 0, width * height * sizeof(uint32_t));
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef ctx = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
        
        CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), imag.CGImage);
        
        for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                        uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
                        uint8_t pixelRed = rgbaPixel[Red];
                        uint8_t dgreen = rgbaPixel[Green] / 255.0 * blendGreen;
                        uint8_t dblue = rgbaPixel[Blue] / 255.0 * blendBlue;
                        uint8_t dred = rgbaPixel[Red] / 255.0 * blendRed;
                        rgbaPixel[Red] = dred;
                        rgbaPixel[Green] = dgreen;
                        rgbaPixel[Blue] = dblue;
                        rgbaPixel[Alpha] = pixelRed;
                }
        }
        CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
        CGContextRelease(ctx);
        CGColorSpaceRelease(colorSpace);
        UIImage *texture = [UIImage imageWithCGImage: cgImage];
        CGImageRelease(cgImage);
        return texture;
}
#pragma mark - 获取触摸点的颜色
+ (UIColor*)colorAtPixel:(CGPoint)point view:(UIImage *)view
{
        // Cancel if point is outside image coordinates
        if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, view.size.width, view.size.height), point)) {
                return nil;
        }
        NSInteger pointX = trunc(point.x);
        NSInteger pointY = trunc(point.y);
        CGImageRef cgImage = view.CGImage;
        NSUInteger width = view.size.width;
        NSUInteger height = view.size.height;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        int bytesPerPixel = 4;
        int bytesPerRow = bytesPerPixel * 1;
        NSUInteger bitsPerComponent = 8;
        unsigned char pixelData[4] = { 0, 0, 0, 0 };
        CGContextRef context = CGBitmapContextCreate(pixelData,1,1,
                                                     bitsPerComponent,
                                                     bytesPerRow,
                                                     colorSpace,
                                                     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
        CGContextSetBlendMode(context, kCGBlendModeCopy);
        // Draw the pixel we are interested in onto the bitmap context
        CGContextTranslateCTM(context, -pointX, pointY - (CGFloat)height);
        CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
        CGContextRelease(context);
        // Convert color values [0..255] to floats [0.0..1.0]
        CGFloat red = (CGFloat)pixelData[0] / 255.0f;
        CGFloat green = (CGFloat)pixelData[1] / 255.0f;
        CGFloat blue = (CGFloat)pixelData[2] / 255.0f;
        CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


#pragma mark - 获取Asset对应的图片
+(UIImage *)obtainImage:(PHAsset *)asset imageSize:(CGSize)size{
        __block UIImage *image = [[UIImage alloc] init];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                image = result;
        }];
        
        return image;
}
// 滤镜处理事件
+ (UIImage *)fliterEvent:(NSString *)filterName image:(UIImage *)image{
                if ([filterName isEqualToString:@"OriginImage"]) {
                        return image;
                }else{
                        //将UIImage转换成CIImage
                        CIImage *ciImage = [[CIImage alloc] initWithImage:image];
                        //创建滤镜
                        CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
                        //已有的值不改变，其他的设为默认值
                        [filter setDefaults];
                        //获取绘制上下文
                        CIContext *context = [CIContext contextWithOptions:nil];
                        //渲染并输出CIImage
                        CIImage *outputImage = [filter outputImage];
                        //创建CGImage句柄
                        CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
                        //获取图片
                       UIImage *filterImage = [UIImage imageWithCGImage:cgImage];
                        //释放CGImage句柄
                        CGImageRelease(cgImage);
                        return filterImage;
                }
        return nil;
}

+ (CGRect)obtainFrame:(UIImage *)image frame:(CGRect)frame{
        CGSize size;
        size = CGSizeMake(frame.size.width , frame.size.height);
        CGFloat scaleX = image.size.width / size.width;
        CGFloat scaleY = image.size.height / size.height;
        CGFloat scale = MAX(scaleX, scaleY);
        CGRect bounds = CGRectMake(0, 0, floorf(image.size.width / scale), floorf(image.size.height / scale));
        return bounds;
}

+ (BOOL) isEmpty:(NSString *) str {
        if(!str) {
                return true;

        }else {
                //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and next line characters (U+000A–U+000D,U+0085).
                NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
                NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
                if([trimedString length] == 0) {
                        return true;
                }else {
                        return false;
                }
        }
}

@end
