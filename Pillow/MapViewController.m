//
//  MapViewController.m
//  MyEstate
//
//  Created by Yangbin on 1/10/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import "MapViewController.h"

#define METERS_PER_MILE  1609

@interface MapViewController ()<GMSMapViewDelegate,GMSAutocompleteResultsViewControllerDelegate>
{
    UIPickerView *pickerDemo;
    
    //UITextField *tryTF;
    
    NSString *textStr;
    
    UIToolbar *toolBar;
    
    NSArray *demoArray;
}

@property(nonatomic,strong) GMSAutocompleteResultsViewController* resultsViewController;
@property(nonatomic,strong) UISearchController* searchController;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //config the searchBar
    _resultsViewController = [[GMSAutocompleteResultsViewController alloc] init];
    _resultsViewController.delegate = self;
    
    _searchController = [[UISearchController alloc]
                         initWithSearchResultsController:_resultsViewController];
    _searchController.searchResultsUpdater = _resultsViewController;
    
    self.searchBarView = [[UIView alloc]initWithFrame:CGRectMake(0,65, self.view.bounds.size.width, 50)];
    
    [_searchController.searchBar sizeToFit];
    _searchController.hidesNavigationBarDuringPresentation = NO;
    [self.searchBarView addSubview:_searchController.searchBar];
    self.navigationController.navigationBar.translucent = YES;
    [self.view addSubview:self.searchBarView];
    
    
    //add the buttons on navigation bar
    UIBarButtonItem* filter = [[UIBarButtonItem alloc]initWithTitle:@"certainSearch" style:UIBarButtonItemStylePlain target:self action:@selector(filerButton)];
    UIBarButtonItem* showAll = [[UIBarButtonItem alloc]initWithTitle:@"showAll" style:UIBarButtonItemStylePlain target:self action:@selector(shwoAll)];
    NSMutableArray* buttonArray = [[NSMutableArray alloc]initWithObjects:showAll,filter, nil];
    self.navigationItem.rightBarButtonItems = buttonArray;

    
    //self.range.text = @"5";
    
    //prepare the customized picker for use
    demoArray = @[@"5",@"7",@"9",@"11",@"13",@"15",@"17",@"19",@"21",@"23"];
    
    pickerDemo = [[UIPickerView alloc]init];
    pickerDemo.dataSource = (id)self;
    pickerDemo.delegate = (id)self;
    
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(changeFromLabel:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor blackColor];
    
    self.range.inputView = pickerDemo;
    self.range.inputAccessoryView = toolBar;
    
    // config the default location to Chicago below
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:41.942526 longitude:-88.26734 zoom:8 bearing:0 viewingAngle:0];
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 110, self.view.bounds.size.width, self.view.bounds.size.height-150) camera:camera];
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    [self.mapView setMinZoom:5 maxZoom:12];
    
    self.mapView.delegate = self;
    self.markers = [[NSMutableSet alloc]init];
    
    //have the connection with web stuff
    self.mapProvider = [webProvider sharedInstance];
    //get data from web and translate
    self.mapManager = [GetMarkerManager sharedInstance];
    
    
    //customize the certain search view
    self.certainSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 175, self.view.bounds.size.width, 150)];
    self.certainSearchView.alpha = 0.6;
    self.certainSearchView.backgroundColor = [UIColor lightGrayColor];
    
    //finally to add the map view
    [self.view addSubview:self.mapView];
    
}


- (void)shwoAll {
    
    NSMutableArray* propertyArray = [NSMutableArray array];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:@"http://www.rjtmobile.com/realestate/getproperty.php?all"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@",error);
        }
        else{
            for (NSDictionary *dic in responseObject) {
                Property *property = [[Property alloc] initWithDictionary:dic];
                [propertyArray addObject:property];
            }
            //self.markers = [self.mapManager createMarkerArrayWithArray:propertyArray];
            NSMutableSet* mutableSet = [[NSMutableSet alloc]initWithSet:self.markers];
            for(Property* d in propertyArray){
                
                CSMarker* marker = [[CSMarker alloc]init];
                marker.objectID = d.propertyID;
                marker.position = CLLocationCoordinate2DMake(d.propertyLatitute.doubleValue, d.propertyLongitute.doubleValue);
                marker.title = d.propertyName;
                marker.snippet = d.propertyType;
                [mutableSet addObject:marker];
            }
            self.markers = mutableSet;
            [self drawMarkers];
        }
    }];
    [dataTask resume];
//

}

- (IBAction)certainSearch:(UIButton *)sender {
    
    
    
}

- (IBAction)searchAround:(UIButton *)sender {
}


//draw all markers
-(void)drawMarkers{
    
    for(CSMarker* m in self.markers){
        if(!m.map){
            m.map = self.mapView;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//GMSAutocompleteResultsViewControllerDelegate

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
 didAutocompleteWithPlace:(GMSPlace *)place {
    
    self.markers = [[NSMutableSet alloc]init];
    for(CSMarker* c in self.markers){
        c.map = nil;
    }
    if(self.markers.count > 0){
        [self.markers removeAllObjects];
    }
    [self.mapView clear];
    
    CSMarker* marker = [[CSMarker alloc]init];
    marker.position = place.coordinate;
    marker.title = @"Input Address";
    marker.snippet = place.formattedAddress;
    marker.map = self.mapView;
    marker.icon = [UIImage imageNamed:@"self"];
    self.userSearchMarker = marker;
    [self.mapView animateToLocation:self.userSearchMarker.position];
    
    _searchController.active = NO;
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    NSLog(@"placeID %@",place.placeID);
    

    
    [[GMSGeocoder geocoder]reverseGeocodeCoordinate:CLLocationCoordinate2DMake(place.coordinate.latitude,place.coordinate.longitude)
                                  completionHandler:^(GMSReverseGeocodeResponse * response, NSError *error){
                                      for(GMSReverseGeocodeResult *result in response.results){
                                         if(result.postalCode){
                                              self.zipCode = result.postalCode;
                                              NSLog(@"postal code :%@", self.zipCode);
                                         }
                                      }
                                      NSDictionary* dic = @{@"ploc":self.zipCode,
                                                            @"pnear":@"5"
                                                            };
                                      [self.mapProvider webServiceCall:dic withHandler:^(NSArray *arrayOfProperty, NSError *error, NSURLResponse *webStatus) {
                                         
                                          //NSLog(@"%@",self.markers);
                                          [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                               self.markers = [self.mapManager createMarkerArrayWithArray:arrayOfProperty];
                                              NSLog(@"num of markers %lu",(unsigned long)self.markers.count);
                                              [self drawMarkers];
                                          }];
                                      }];
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

//delegate from GMSMapViewDelegate
-(UIView*)mapView:(GMSMapView *)mapView markerInfoWindow:(CSMarker *)marker{
//    
    UIView* info = [[UIView alloc]init];
    info.frame = CGRectMake(0, 0, 200, 65);
    info.backgroundColor = [UIColor whiteColor];
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(0, 0, 185, 32);
    titleLabel.text = marker.title;
    UILabel* snippet = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 185, 32)];
    snippet.text = marker.snippet;
    [info addSubview:titleLabel];
    [info addSubview:snippet];
    
    return info;
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
//    NSString* message = [NSString stringWithFormat:@"you just tapped on the marker with title %@",marker.title];
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"tapped" message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* action = [UIAlertAction actionWithTitle:@"Alright" style:UIAlertActionStyleCancel handler:nil];
//    [alert addAction:action];
//    
//    [self presentViewController:alert animated:YES completion:nil];
    ShowPropertyViewController* spvc = [[ShowPropertyViewController alloc]init];
    [self.navigationController pushViewController:spvc animated:YES];
}

//button tapped
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(CSMarker *)marker{
    
    NSString* url = [marker.propertyStoredInMarker.propertyImage1 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    [self.view insertSubview: self.certainSearchView  aboveSubview:self.mapView];
    UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    act.frame = CGRectMake(round((self.certainSearchView.frame.size.width - 25) / 2), round((self.certainSearchView.frame.size.height - 25) / 2), 60, 60);
    [self.certainSearchView addSubview:act];
    [act startAnimating];
    
    [self.mapProvider getPic:url withHandler:^(NSData *data, NSError *error, NSURLResponse *webStatus) {
        if(error){
            self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
            self.image = [UIImage imageNamed:@"error"];
            self.imageView.image = self.image;
            self.certainSearchView.alpha = 1.0;
            [self.certainSearchView addSubview:self.imageView];
            [act stopAnimating];
            //[self.view insertSubview: self.certainSearchView  aboveSubview:self.mapView];
        }else if(!data){
            self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
            self.image = [UIImage imageNamed:@"default"];
            self.imageView.image = self.image;
            self.certainSearchView.alpha = 1.0;
            [self.certainSearchView addSubview:self.imageView];
            [act stopAnimating];
            //[self.view insertSubview: self.certainSearchView  aboveSubview:self.mapView];
        }else{
            self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
            self.image = [UIImage imageWithData:data];
            self.imageView.image = self.image;
            [self.certainSearchView addSubview:self.imageView];
            UILabel* price = [[UILabel alloc]initWithFrame:CGRectMake(0, self.certainSearchView.bounds.size.height - 50, 65, 25)];
            UILabel* showPrice = [[UILabel alloc]initWithFrame:CGRectMake(65, self.certainSearchView.bounds.size.height - 50, 100, 25)];
            price.text = @"price->";
            showPrice.text = marker.propertyStoredInMarker.propertyCost;
            [self.certainSearchView insertSubview:price aboveSubview:self.imageView];
            [self.certainSearchView insertSubview:showPrice aboveSubview:self.imageView];
            self.certainSearchView.alpha = 1.0;
            [act stopAnimating];
        }
    }];
    
    
    NSLog(@"marker tapped %@",[marker.propertyStoredInMarker.propertyImage1 stringByReplacingOccurrencesOfString:@"\\" withString:@""]);
    return YES;
}


//slider to set range of search
//- (IBAction)setRange:(UISlider *)sender {
//        NSLog(@"SliderValue ... %.2f",sender.value);
//    //self.range.text = [NSString stringWithFormat:@"%f",sender.value];
//}


//filter button
-(void)filerButton{

    //[self.view addSubview:self.certainSearchView];

}


//delegate of picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return demoArray.count;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [demoArray objectAtIndex:row];
    return title;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    textStr = [demoArray objectAtIndex:row];
}

- (void)changeFromLabel:(id)sender
{
    self.range.text = textStr;
    [self.range resignFirstResponder];
}



//get all estates from server




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
