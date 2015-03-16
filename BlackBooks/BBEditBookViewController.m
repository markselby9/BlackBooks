//
//  BBEditBookViewController.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/3/2.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "XLForm.h"
#import "BBEditBookViewController.h"
#import "BBBook.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface BBEditBookViewController ()

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

@implementation BBEditBookViewController

-(id)init
{
    NSString * kName = @"bookname";
    NSString * kAuthor = @"author";
    NSString * kOriginalPrice = @"originalprice";
    NSString * kPrice = @"price";
    NSString * kPhoto = @"photo";
    NSString * kSituation = @"situation";
    NSString * kContact = @"contact";
    NSString * kStory = @"story";
    
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"修改发布信息"];
    XLFormSectionDescriptor * section;
    //    XLFormRowDescriptor * row;
    
    formDescriptor.assignFirstResponderOnShow = YES;
    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"这本书"];
    section.footerTitle = @"基本信息";
    [formDescriptor addFormSection:section];
    
    // Name
    _nameRow = [XLFormRowDescriptor formRowDescriptorWithTag:kName rowType:XLFormRowDescriptorTypeText title:@"的名字"];
    _nameRow.required = YES;
    [section addFormRow:_nameRow];
    
    // Author
    _authorRow = [XLFormRowDescriptor formRowDescriptorWithTag:kAuthor rowType:XLFormRowDescriptorTypeName title:@"的作者"];
    _authorRow.required = YES;
    [section addFormRow:_authorRow];
    
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:@"originalowner" rowType:XLFormRowDescriptorTypeName title:@"的主人"];
    row.disabled = YES;
    row.value = [AVUser currentUser].username;
    [section addFormRow:row];
    
    // original
    _originalPriceRow = [XLFormRowDescriptor formRowDescriptorWithTag:kOriginalPrice rowType:XLFormRowDescriptorTypeInteger title:@"的原价"];
    _originalPriceRow.required = YES;
    [section addFormRow:_originalPriceRow];
    
    _situationRow = [XLFormRowDescriptor formRowDescriptorWithTag:kSituation rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"当前状态"];
    _situationRow.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"全新刚买没翻过"],
                                      [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"刚看完了"],
                                      [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"有些笔记"],
                                      [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"已经破万卷"],
                                      [XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"吃了很久灰"]
                                      ];
//    _situationRow.value = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"全新刚买没翻过"];
    [section addFormRow:_situationRow];
    
    _photoRow = [XLFormRowDescriptor formRowDescriptorWithTag:kPhoto rowType:XLFormRowDescriptorTypeButton title:@"添加照片"];
    [_photoRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:0.0 alpha:1.0] forKey:@"textLabel.textColor"];
    _photoRow.action.formSelector = @selector(didTouchEditPhoto:);
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [_nameRow setValue:_book.bookname];
    [_authorRow setValue:_book.author];
    [_originalPriceRow setValue:[NSNumber numberWithInt:_book.originalprice]];
    [_priceRow setValue:[NSNumber numberWithInt:_book.price]];
    [_storyRow setValue:_book.story];
    [_contactRow setValue:_book.contact];
    [_situationRow setValue:_book.situation];
    if (_book.photo){
        self.photoFile = _book.photo;
        _photoRow.title = @"换一张照片";
        [self reloadFormRow:_photoRow];
    }
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithTitle:@"完成修改" style:UIBarButtonItemStyleDone target:self action:@selector(saveEditPressed:)];
    self.navigationItem.rightBarButtonItem = save;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveEditPressed:(id)sender{
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
    
    _book.bookname = bookname;
    _book.author = author;
    _book.originalprice = originalprice;
    _book.situation = situation;
    _book.price = price;
    _book.bookOwnerName = [[AVUser currentUser] username];
    _book.story = _storyRow.value;
    _book.contact = _contactRow.value;
    if (_photoFile){
        _book.photo = self.photoFile;
        NSLog(@"%@ added", _book.photo);
    }
    
    [_book saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            UIAlertView *success = [[UIAlertView alloc]initWithTitle:@"success" message:@"修改成功。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [success show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            
            UIAlertView *errorview = [[UIAlertView alloc]initWithTitle:@"error" message:error.displayText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorview show];
        }
    }];
}
#pragma mark - edit photo
-(IBAction)didTouchEditPhoto:(id)sender{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
