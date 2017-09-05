//
//  SNPEViewModel.m
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/10.
//  Copyright © 2017年 saina. All rights reserved.
//
#define kBitsPerComponent (8)
#define kBitsPerPixel (32)
#define kPixelChannelCount (4)



#import "SNPEViewModel.h"
#import "ZGCIPHeader.h"

typedef NS_ENUM(NSInteger, Pixel) {
        Alpha = 0,
        Blue = 1,
        Green = 2,
        Red = 3,
}pixel;
@implementation SNPEViewModel
/**
 *  以image调整界面
 *
 *  @param image 参数image
 *
 *  @return 返回尺寸
 */
+ (CGRect)adjustTheUIInTheImage:(UIImage *)image oldImage:(UIImage *)oldImage{
        
        CGSize size = image.size;

        /**
        
         *  按照image的大小调整View的大小
         */
         
        //比原图高， 且 原图比屏幕矮
        if (size.width > ZGCIP_MAINSCREEN_WIDTH) {
                size.height *= (ZGCIP_MAINSCREEN_WIDTH / size.width);
                size.width = ZGCIP_MAINSCREEN_WIDTH;
        }else{
                size.height *= (ZGCIP_MAINSCREEN_WIDTH / size.width);
                size.width = ZGCIP_MAINSCREEN_WIDTH;
   
        }

        
        
        if (size.height > ZGCIP_MAINSCREEN_HEIGHT) {
                size.width *= (ZGCIP_MAINSCREEN_WIDTH / + size.width);
                size.height = ZGCIP_MAINSCREEN_HEIGHT;
        }else{
                size.width *= (ZGCIP_MAINSCREEN_WIDTH / + size.width);
                size.height = size.height;
        }
        
        
        if (size.width < minSize.width) {
                size.height *= (minSize.width / size.width);
                size.width = minSize.width;
        }
        
        if (size.height < minSize.height) {
                size.width *= (minSize.height / size.height);
                size.height = minSize.height;
        }
        
        CGRect frame;
        frame.size = size;
        return frame;
}
+ (CGRect)adjust:(UIImage *)image oldImage:(UIImage *)oldImage{
        CGSize size = image.size;
        CGSize oldSize = oldImage.size;


        /**
         
         *  按照image的大小调整View的大小
         */
        CGFloat timesH = oldSize.height / size.height;
        //比原图高， 且 原图比屏幕矮
        if (oldSize.width > ZGCIP_MAINSCREEN_WIDTH) {
                oldSize.height *= (ZGCIP_MAINSCREEN_WIDTH / oldSize.width);
                oldSize.width = ZGCIP_MAINSCREEN_WIDTH;
        }else{
                oldSize.height *= (ZGCIP_MAINSCREEN_WIDTH / oldSize.width);
                oldSize.width = ZGCIP_MAINSCREEN_WIDTH;
                
        }
        if (oldSize.height > ZGCIP_MAINSCREEN_HEIGHT) {
                oldSize.width *= (ZGCIP_MAINSCREEN_WIDTH / + oldSize.width);
                oldSize.height = ZGCIP_MAINSCREEN_HEIGHT;
        }else{
                oldSize.width *= (ZGCIP_MAINSCREEN_WIDTH / + oldSize.width);
                oldSize.height = oldSize.height;
        }

        
        if (size.width > ZGCIP_MAINSCREEN_WIDTH) {
                size.height *= (ZGCIP_MAINSCREEN_WIDTH / size.width);
                size.width = ZGCIP_MAINSCREEN_WIDTH;
        }else{
                size.height *= (ZGCIP_MAINSCREEN_WIDTH / size.width);
                size.width = ZGCIP_MAINSCREEN_WIDTH;
                
        }
        if (size.height > ZGCIP_MAINSCREEN_HEIGHT) {
                size.width *= (ZGCIP_MAINSCREEN_WIDTH / + size.width);
                size.height = ZGCIP_MAINSCREEN_HEIGHT;
        }else{
                size.width *= (ZGCIP_MAINSCREEN_WIDTH / + size.width);
                size.height = size.height;
        }



        if (size.height > oldSize.height) {
                size.width = size.width * timesH;
                size.height = oldSize.height;
        }
        
        if (size.width < minSize.width) {
                size.height *= (minSize.width / size.width);
                size.width = minSize.width;
        }
        if (size.height < minSize.height) {
                size.width *= (minSize.height / size.height);
                size.height = minSize.height;
        }
        
        
        CGRect frame;
        frame.size = size;
        return frame;
   
}

/**
 *  Description
 *
 *  @param source      <#source description#>
 *  @param orientation <#orientation description#>
 *  @param size        <#size description#>
 *  @param quality     <#quality description#>
 *
 *  @return <#return value description#>
 */
+ (CGImageRef)newScaledImage:(CGImageRef)source withOrientation:(UIImageOrientation)orientation toSize:(CGSize)size withQuality:(CGInterpolationQuality)quality{
        CGSize srcSize = size;
        CGFloat rotation = 0.0;
        
        switch(orientation){
                case UIImageOrientationUp: {
                        rotation = 0;
                } break;
                case UIImageOrientationDown: {
                        rotation = M_PI;
                } break;
                case UIImageOrientationLeft:{
                        rotation = M_PI_2;
                        srcSize = CGSizeMake(size.height, size.width);
                } break;
                case UIImageOrientationRight: {
                        rotation = -M_PI_2;
                        srcSize = CGSizeMake(size.height, size.width);
                } break;
                default:
                        break;
        }
        
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8,  //CGImageGetBitsPerComponent(source),
                                                     0,
                                                     rgbColorSpace,//CGImageGetColorSpace(source),
                                                     kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big//(CGBitmapInfo)kCGImageAlphaNoneSkipFirst  //CGImageGetBitmapInfo(source)
                                                     );
        CGColorSpaceRelease(rgbColorSpace);
        
        CGContextSetInterpolationQuality(context, quality);
        CGContextTranslateCTM(context,  size.width / 2,  size.height / 2);
        CGContextRotateCTM(context,rotation);
        
        CGContextDrawImage(context, CGRectMake(-srcSize.width/2 ,
                                               -srcSize.height/2,
                                               srcSize.width,
                                               srcSize.height),
                           source);
        
        CGImageRef resultRef = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        
        return resultRef;
}

/**
 *  创建色板
 *
 *  @param color           <#color description#>
 *  @param ScrollViewFrame <#ScrollViewFrame description#>
 *  @param width           <#width description#>
 *  @param target          <#target description#>
 *  @param action          <#action description#>
 *  @param name            <#name description#>
 *
 *  @return <#return value description#>
 */
+(UIScrollView *)initWithfilterScrollViewBackgroundColor:(UIColor *)color frame:(CGRect)ScrollViewFrame frameWidth:(CGFloat)width  addTarget:(id)target action:(SEL)action nameArr:(NSArray *)name{
        UIScrollView *scrollView  = [[UIScrollView alloc] initWithFrame:ScrollViewFrame];
        scrollView.backgroundColor = color;
        //滚动范围
        scrollView.contentSize = CGSizeMake(width * name.count, width);
        //隐藏水平滚动条
        scrollView.showsHorizontalScrollIndicator = NO;
        //隐藏垂直滚动条
        scrollView.showsVerticalScrollIndicator = NO;
        
        for (int i =0; i < name.count; i++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(width * i, 0, width - 10, width)];
                [btn setBackgroundImage:[UIImage imageNamed:name[i]] forState:UIControlStateNormal];
                btn.tag = i;
                [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:btn];
        }
        
        return scrollView;
}



/***  初始化色板*/
+(UIScrollView *)initWithColorScrollViewBackgroundColor:(UIColor *)color frame:(CGRect)ScrollViewFrame frameWidth:(CGFloat)width  addTarget:(nullable id)target action:(nonnull SEL)action{
        
        UIScrollView *colorScrollView  = [[UIScrollView alloc] initWithFrame:ScrollViewFrame];
        colorScrollView.backgroundColor = color;

        //创建每个色块
        NSArray *colors = [NSArray arrayWithObjects: [UIColor blackColor], [UIColor brownColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor cyanColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor darkGrayColor], [UIColor grayColor], [UIColor lightGrayColor], [UIColor groupTableViewBackgroundColor] ,nil];
        //滚动范围
        colorScrollView.contentSize = CGSizeMake(width * colors.count, width);
        //隐藏水平滚动条
        colorScrollView.showsHorizontalScrollIndicator = NO;
        //隐藏垂直滚动条
        colorScrollView.showsVerticalScrollIndicator = NO;
        
        for (int i =0; i < colors.count; i++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(width * i + 20, width / 4, width / 2, width / 2)];
                //将图层的边框设置为圆脚
                btn.layer.cornerRadius =  width / 4;
                btn.layer.masksToBounds = YES;
                //色板样式
                btn.layer.borderWidth = 1;
                btn.layer.borderColor = [UIColor whiteColor].CGColor;
                [btn setBackgroundColor:colors[i]];
                
                [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:[UIImage imageNamed:@"PE_ColorSelected@2x_091"] forState:UIControlStateSelected];
                [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [colorScrollView addSubview:btn];
        }
        return colorScrollView;
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
        long double rotate = 0.0;
        CGRect rect;
        float translateX = 0;
        float translateY = 0;
        float scaleX = 1.0;
        float scaleY = 1.0;
        
        switch (orientation) {
                case UIImageOrientationLeft:
                        rotate = M_PI_2;
                        rect = CGRectMake(0, 0, image.size.height, image.size.width);
                        translateX = 0;
                        translateY = -rect.size.width;
                        scaleY = rect.size.width/rect.size.height;
                        scaleX = rect.size.height/rect.size.width;
                        break;
                case UIImageOrientationRight:
                        rotate = 33 * M_PI_2;
                        rect = CGRectMake(0, 0, image.size.height, image.size.width);
                        translateX = -rect.size.height;
                        translateY = 0;
                        scaleY = rect.size.width/rect.size.height;
                        scaleX = rect.size.height/rect.size.width;
                        break;
                case UIImageOrientationDown:
                        rotate = M_PI;
                        rect = CGRectMake(0, 0, image.size.width, image.size.height);
                        translateX = -rect.size.width;
                        translateY = -rect.size.height;
                        break;
                default:
                        rotate = 0.0;
                        rect = CGRectMake(0, 0, image.size.width, image.size.height);
                        translateX = 0;
                        translateY = 0;
                        break;
        }
        
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        //做CTM变换
        CGContextTranslateCTM(context, 0.0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextRotateCTM(context, rotate);
        CGContextTranslateCTM(context, translateX, translateY);
        
        CGContextScaleCTM(context, scaleX, scaleY);
        //绘制图片
        CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
        
        UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
        
        return newPic;
}
//初始化按钮
+(UIButton *)createBtnFrame:(CGRect)frame image:(UIImage *)image SelectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action{
        UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [createButton setImage:image forState:UIControlStateNormal];
        [createButton setImage:selectedImage forState:UIControlStateSelected];
        [createButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        createButton.frame = frame;
        return createButton;
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
        CGPoint thumbnailPoint = CGPointMake(-10.0,0.0);
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
+(UIColor*)colorAtPixel:(CGPoint)point view:(UIImage *)view
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


/**
 * 图片压缩到指定大小
 * @param targetSize 目标图片的大小
 * @param sourceImage 源图片
 * @return 目标图片
 */
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
        UIImage *newImage = nil;
        CGSize imageSize = sourceImage.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        CGFloat targetWidth = targetSize.width;
        CGFloat targetHeight = targetSize.height;
        CGFloat scaleFactor = 0.0;
        CGFloat scaledWidth = targetWidth;
        CGFloat scaledHeight = targetHeight;
        CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
        if (CGSizeEqualToSize(imageSize, targetSize) == NO)
                                                                                                            {
                CGFloat widthFactor = targetWidth / width;
                CGFloat heightFactor = targetHeight / height;
                if (widthFactor > heightFactor)
                        scaleFactor = widthFactor; // scale to fit height
                else
                        scaleFactor = heightFactor; // scale to fit width
                scaledWidth= width * scaleFactor;
                scaledHeight = height * scaleFactor;
                // center the image
                if (widthFactor > heightFactor)
                                                                                                                    {
                        thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
                                                                                                                    }
                else if (widthFactor < heightFactor)
                                                                                                                    {
                        thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
                                                                                                                    }
                                                                                                            }
        UIGraphicsBeginImageContext(targetSize); // this will crop
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width= scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        [sourceImage drawInRect:thumbnailRect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        if(newImage == nil)
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
        
        return newImage;
}/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
        NSData * data = UIImageJPEGRepresentation(image, size);
        CGFloat dataKBytes = data.length/1000.0;
        CGFloat maxQuality = 0.9f;
        CGFloat lastData = dataKBytes;
        while (dataKBytes > size && maxQuality > 0.01f) {
                maxQuality = maxQuality - 0.01f;
                data = UIImageJPEGRepresentation(image, maxQuality);
                dataKBytes = data.length / 1000.0;
                if (lastData == dataKBytes) {
                        break;
                }else{
                        lastData = dataKBytes;
                }
        }
        return data;
}

@end
