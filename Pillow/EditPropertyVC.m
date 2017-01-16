//
//  EditPropertyVC.m
//  Pillow
//
//  Created by Lucas Luo on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "EditPropertyVC.h"
#import "SellerPropertyVC.h"
#import "Contants.h"
#import "ImageStoreManager.h"
#import <AFNetworking.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <SDwebImage/UIImageView+WebCache.h>

@interface EditPropertyVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,GMSMapViewDelegate,GMSAutocompleteResultsViewControllerDelegate,UITextFieldDelegate>
@property (nonatomic) NSInteger userID;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFld;
@property (weak, nonatomic) IBOutlet UITextField *typeTextFld;
@property (weak, nonatomic) IBOutlet UITextField *costTextFld;
@property (weak, nonatomic) IBOutlet UITextField *sizeFld;
@property (weak, nonatomic) IBOutlet UITextField *descTextFld;
@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;
@property (assign,nonatomic) NSInteger imageBtnTag;

@property (strong,nonatomic) NSString *address1;
@property (strong,nonatomic) NSString *address2;
@property (strong,nonatomic) NSString *zipCode;
@property (strong,nonatomic) NSString *longtitude;
@property (strong,nonatomic) NSString *latitude;
@property (strong,nonatomic) NSString *propertyID;
@property (nonatomic,strong)UIImagePickerController*picker;
@property (weak, nonatomic) IBOutlet UIImageView *pickerImage1;
@property (weak, nonatomic) IBOutlet UIImageView *pickerImage2;
@property (weak, nonatomic) IBOutlet UIImageView *pickerImage3;
@property (strong,nonatomic) NSData *imageData1;
@property (strong,nonatomic) NSData *imageData2;
@property (strong,nonatomic) NSData *imageData3;

@property (strong,nonatomic) NSDictionary *userInfoDic;

@property(nonatomic,strong) GMSAutocompleteResultsViewController* resultsViewController;
@property(nonatomic,strong) UISearchController* searchController;

@end

@implementation EditPropertyVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.aProperty != nil) {
        self.propertyID = self.aProperty.propertyID;
        self.searchController.searchBar.text = self.aProperty.propertyAdd1;
        self.nameTextFld.text = self.aProperty.propertyName;
        self.typeTextFld.text = self.aProperty.propertyType;
        self.address1 = self.aProperty.propertyAdd1;
        self.address2 = self.aProperty.propertyadd2;
        self.zipCode = self.aProperty.propertyZip;
        self.costTextFld.text = self.aProperty.propertyCost;
        self.sizeFld.text = self.aProperty.propertySize;
        self.descTextFld.text = self.aProperty.propertyDesc;
        if ([self.aProperty.propertyStatus isEqualToString:@"yes"]) {
            self.statusSwitch.on = YES;
        }
        else{
            self.statusSwitch.on = NO;
        }
        NSString* urlStr1 = [self dealWithURLFormate:self.aProperty.propertyImage1];
        NSString* urlStr2 = [self dealWithURLFormate:self.aProperty.propertyImage2];
        NSString* urlStr3 = [self dealWithURLFormate:self.aProperty.propertyImage3];

        [self.pickerImage1 sd_setImageWithURL:[NSURL URLWithString:urlStr1] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [self.pickerImage2 sd_setImageWithURL:[NSURL URLWithString:urlStr2] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [self.pickerImage3 sd_setImageWithURL:[NSURL URLWithString:urlStr3] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _resultsViewController = [[GMSAutocompleteResultsViewController alloc] init];
    _resultsViewController.delegate = self;
    _searchController = [[UISearchController alloc]
                         initWithSearchResultsController:_resultsViewController];
    _searchController.searchResultsUpdater = _resultsViewController;
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(81, 90, 273, 50)];
    [subView addSubview:_searchController.searchBar];
    [_searchController.searchBar sizeToFit];
    _searchController.hidesNavigationBarDuringPresentation = NO;
    [self.view insertSubview:subView aboveSubview:self.nameTextFld];

    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    self.userInfoDic = [userdefault objectForKey:userKey];
    self.userID = [[self.userInfoDic objectForKey:useridKey] integerValue];
    
    UIBarButtonItem *updateBtn = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(UploadButtonClicked)];
    self.navigationItem.rightBarButtonItem = updateBtn;

}

- (void)UploadButtonClicked{
    NSDictionary *dic = @{
                          useridKey:[NSString stringWithFormat:@"%ld",self.userID],
                          uppropNameKey:self.nameTextFld.text,
                          uppropTypeKey:self.typeTextFld.text,
                          uppropCataKey:@"1",
                          uppropAddr1Key:self.address1,
                          uppropAddr2Key:self.address2,
                          uppropZipKey:self.zipCode,
                          uppropLatKey:self.latitude,
                          uppropLongKey:self.longtitude,
                          uppropCostKey:self.costTextFld.text,
                          uppropSizeKey:self.sizeFld.text,
                          uppropDescKey:self.descTextFld.text,
                          uppropStatusKey:[NSString stringWithFormat:@"%@",self.statusSwitch.on ? @"yes" : @"no"],
                          uppropImg1Key:self.imageData1,
                          uppropImg2Key:self.imageData2,
                          uppropImg3Key:self.imageData3,
                          };
    if (self.aProperty == nil) {
        [Property sellerAddWithParameters:dic];
    }
    else{
        [Property sellerEditWithParameters:self.propertyID parameter:dic];
    }
}


-(void)SourceISCamera{
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.picker animated:YES completion:nil];
}

-(void)sourceIsPhotoLibrary{
    self.picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (IBAction)selectImageAction:(UIButton *)sender {
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.allowsEditing = YES;
    self.picker.delegate = self;//Need confirm NagivationColler Delegate
    
    self.imageBtnTag = sender.tag;
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Image Source" message:@"Select Image Source" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction*cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
        [self SourceISCamera];
    }];
    UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
        [self sourceIsPhotoLibrary];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [actionSheet addAction:cameraAction];
    }
    [actionSheet addAction:galleryAction];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}
#pragma mark-UIImagePickViewController Delegate Netgids
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    ImageStoreManager *imageManager = [[ImageStoreManager alloc]init];
    switch (self.imageBtnTag) {
        case 100:
            self.pickerImage1.image = image;
            self.imageData1 = UIImageJPEGRepresentation(self.pickerImage1.image,0.5);
            [imageManager storeImageToFile:self.imageData1 ImageName:@"image1"];
            break;
        case 101:
            self.pickerImage2.image = image;
            self.imageData2 = UIImageJPEGRepresentation(self.pickerImage2.image,0.5);
            [imageManager storeImageToFile:self.imageData2 ImageName:@"image2"];
            break;
        case 102:
            self.pickerImage3.image = image;
            self.imageData3 = UIImageJPEGRepresentation(self.pickerImage3.image,0.5);
            [imageManager storeImageToFile:self.imageData3 ImageName:@"image3"];
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//
//}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - GoogleMapDelegate
- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
 didAutocompleteWithPlace:(GMSPlace *)place {
    _searchController.active = NO;
    // Do something with the selected place.
    NSString *fullAddress = place.formattedAddress;
    NSArray *addressArray = [fullAddress componentsSeparatedByString:@","];
    if (addressArray.count >= 4) {
        self.address1 = [[addressArray objectAtIndex:0] stringByAppendingString:[addressArray objectAtIndex:1]];
        self.searchController.searchBar.text = self.address1;
        self.address2 =  [[addressArray objectAtIndex:2] stringByAppendingString:[addressArray objectAtIndex:3]];
    }
    else{
        assert(NO);
    }

    self.latitude = [NSString stringWithFormat:@"%f",place.coordinate.latitude];
    self.longtitude = [NSString stringWithFormat:@"%f",place.coordinate.longitude];
    
    [[GMSGeocoder geocoder]reverseGeocodeCoordinate:CLLocationCoordinate2DMake(place.coordinate.latitude,place.coordinate.longitude)
                                  completionHandler:^(GMSReverseGeocodeResponse * response, NSError *error){
                                      for(GMSReverseGeocodeResult *result in response.results){
                                          if(result.postalCode){
                                              NSLog(@"postal code :%@", result.postalCode);
                                              self.zipCode = result.postalCode;
                                          }
                                      }
                                  }];
}

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictionsForResultsController:
(GMSAutocompleteResultsViewController *)resultsController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictionsForResultsController:
(GMSAutocompleteResultsViewController *)resultsController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(NSString *)dealWithURLFormate:(NSString *)imageURL{
    NSString *step1 = [imageURL stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSString *step2 = [NSString stringWithFormat:@"%@%@",@"http://",step1];
    return step2;
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
