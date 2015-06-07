//
//  InputsFormViewController.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2014 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XLForm.h"
#import "BBAddBookViewController.h"
#import "BBBook.h"
#import <MobileCoreServices/MobileCoreServices.h>

NSString *const kName = @"bookname";
NSString *const kAuthor = @"author";
NSString *const kOriginalPrice = @"originalprice";
NSString *const kPrice = @"price";
NSString *const kPhoto = @"photo";
NSString *const kSituation = @"situation";
NSString *const kContact = @"contact";
NSString *const kStory = @"story";

@interface BBAddBookViewController()

@property (nonatomic) XLFormRowDescriptor *nameRow;
@property (nonatomic) XLFormRowDescriptor *authorRow;
@property (nonatomic) XLFormRowDescriptor *originalPriceRow;
@property (nonatomic) XLFormRowDescriptor *priceRow;
@property (nonatomic) XLFormRowDescriptor *situationRow;
@property (nonatomic) XLFormRowDescriptor *contactRow;
@property (nonatomic) XLFormRowDescriptor *storyRow;
@property (nonatomic) XLFormRowDescriptor *photoRow;
@property (nonatomic) AVFile *photoFile;

@end

@implementation BBAddBookViewController

-(id)init
{
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"添加一本书"];
    XLFormSectionDescriptor * section;
//    XLFormRowDescriptor * row;
    
    formDescriptor.assignFirstResponderOnShow = YES;
    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"这本书"];
    section.footerTitle = @"基本信息";
    [formDescriptor addFormSection:section];
    
    // Name
    _nameRow = [XLFormRowDescriptor formRowDescriptorWithTag:kName rowType:XLFormRowDescriptorTypeText title:@"名字"];
    _nameRow.required = YES;
    [section addFormRow:_nameRow];
    
    // Author
    _authorRow = [XLFormRowDescriptor formRowDescriptorWithTag:kAuthor rowType:XLFormRowDescriptorTypeName title:@"作者"];
    _authorRow.required = YES;
    [section addFormRow:_authorRow];
    
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:@"originalowner" rowType:XLFormRowDescriptorTypeName title:@"现在的主人"];
    row.disabled = YES;
    row.value = [AVUser currentUser].username;
    [section addFormRow:row];
    
    // original
    _originalPriceRow = [XLFormRowDescriptor formRowDescriptorWithTag:kOriginalPrice rowType:XLFormRowDescriptorTypeInteger title:@"购买的原价"];
    _originalPriceRow.required = YES;
    [section addFormRow:_originalPriceRow];
    
    _situationRow = [XLFormRowDescriptor formRowDescriptorWithTag:kSituation rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"当前状态"];
    _situationRow.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"全新刚买没翻过"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"刚看完了"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"有些笔记"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"已经破万卷"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"吃了很久灰"]
                            ];
    _situationRow.value = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"全新刚买没翻过"];
    [section addFormRow:_situationRow];
    
    _photoRow = [XLFormRowDescriptor formRowDescriptorWithTag:kPhoto rowType:XLFormRowDescriptorTypeButton title:@"添加照片"];
    [_photoRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:0.0 alpha:1.0] forKey:@"textLabel.textColor"];
    _photoRow.action.formSelector = @selector(didTouchAddPhoto:);
    [section addFormRow:_photoRow];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"您和这本书的故事"];
    section.footerTitle = @"没准认识个有缘人";
    [formDescriptor addFormSection:section];
    _storyRow = [XLFormRowDescriptor formRowDescriptorWithTag:kStory rowType:XLFormRowDescriptorTypeTextView];
    [_storyRow.cellConfigAtConfigure setObject:@"这本书给了您什么帮助？什么启发？有什么特别的经历？分享给大家吧" forKey:@"textView.placeholder"];
    _storyRow.required = YES;
    [section addFormRow:_storyRow];
    
    _contactRow = [XLFormRowDescriptor formRowDescriptorWithTag:kContact rowType:XLFormRowDescriptorTypeTextView];
    [_contactRow.cellConfigAtConfigure setObject:@"除了手机号码，其他您想留下的联系方式？（可选）" forKey:@"textView.placeholder"];
//    _contactRow.required = YES;
    [section addFormRow:_contactRow];

    section = [XLFormSectionDescriptor formSectionWithTitle:@"现在我想..."];
    section.footerTitle = @"点击右上角的按钮将书放到书店里";
    [formDescriptor addFormSection:section];
    
    _priceRow = [XLFormRowDescriptor formRowDescriptorWithTag:kPrice rowType:XLFormRowDescriptorTypeInteger title: @"这个价格卖出去:"];
    _priceRow.required = YES;
    [section addFormRow:_priceRow];
    
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
        
    return [super initWithForm:formDescriptor];
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithTitle:@"放到书店" style:UIBarButtonItemStyleDone target:self action:@selector(savePressed:)];
    self.navigationItem.rightBarButtonItem = save;
}


-(IBAction)savePressed:(UIBarButtonItem * __unused)button
{
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];
    NSString *bookname = _nameRow.value;
    NSString *author = _authorRow.value;
    int originalprice = [_originalPriceRow.value intValue];
    NSString *situation = ((XLFormOptionsObject*)_situationRow.value).formDisplayText;
    int price = [_priceRow.value intValue];
    // set book
    BBBook *newBook = [BBBook object];
    newBook.bookname = bookname;
    newBook.author = author;
    newBook.originalprice = originalprice;
    newBook.situation = situation;
    newBook.price = price;
    newBook.story = _storyRow.value;
    newBook.contact = _contactRow.value;
    newBook.bookOwnerName = [[AVUser currentUser] username];
    
    if (self.photoFile){
        newBook.photo = self.photoFile;
        NSLog(@"%@ added", newBook.photo);
//        [newBook setObject:self.photoFile forKey:@"photo"];
    }
    
    [newBook saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            UIAlertView *success = [[UIAlertView alloc]initWithTitle:@"success" message:@"您的书本已经被放到书架上了。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [success show];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            UIAlertView *errorview = [[UIAlertView alloc]initWithTitle:@"error" message:error.displayText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorview show];
        }
    }];
}

#pragma mark - add photo
-(IBAction)didTouchAddPhoto:(id)sender{
    UIActionSheet *addPhotoAS = [[UIActionSheet alloc]initWithTitle:@"给书添加一张照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中挑一张", @"现在拍一张", nil];
    [addPhotoAS showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clicked at row %ld", (long)buttonIndex);
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    if (buttonIndex == 0){
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:imagePicker animated:YES completion:^{
            ;
        }];
    }else if (buttonIndex == 1){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:imagePicker animated:YES completion:^{
            ;
        }];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        // ensure the user has taken a picture
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToUse = editedImage;
        }
        else {
            imageToUse = originalImage;
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{
        NSData *photodata = UIImageJPEGRepresentation(imageToUse, 1.0);
        self.photoFile = [AVFile fileWithName:[NSString stringWithFormat:@"bookimage"] data:photodata];
        _photoRow.title = @"重新拍一张";
        [self reloadFormRow:_photoRow];
    }];
}

@end
