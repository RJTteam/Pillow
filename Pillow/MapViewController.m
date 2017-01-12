//
//  MapViewController.m
//  MyEstate
//
//  Created by Yangbin on 1/10/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import "MapViewController.h"

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
    
    _resultsViewController = [[GMSAutocompleteResultsViewController alloc] init];
    _resultsViewController.delegate = self;
    
    _searchController = [[UISearchController alloc]
                         initWithSearchResultsController:_resultsViewController];
    _searchController.searchResultsUpdater = _resultsViewController;
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 50)];
    
    
    [subView addSubview:_searchController.searchBar];
    [_searchController.searchBar sizeToFit];
     _searchController.hidesNavigationBarDuringPresentation = NO;
    self.navigationController.navigationBar.translucent = YES;
    //[self.view addSubview:subView];
    self.navigationItem.titleView = subView;
    
    self.range.text = @"5";
    
    demoArray = @[@"5",@"7",@"9",@"11",@"13",@"15",@"17",@"19",@"21",@"23"];
    
    pickerDemo = [[UIPickerView alloc]init];
    pickerDemo.dataSource = (id)self;
    pickerDemo.delegate = (id)self;
    
    
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(changeFromLabel:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor blackColor];
    
    self.range.inputView = pickerDemo;
    self.range.inputAccessoryView = toolBar;
    
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:41.942526 longitude:-88.26734 zoom:8 bearing:0 viewingAngle:0];
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 110, self.view.bounds.size.width, self.view.bounds.size.height-150) camera:camera];
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    [self.mapView setMinZoom:5 maxZoom:12];
    
    self.mapView.delegate = self;
    self.markers = [[NSSet alloc]init];
    
//    webService* service = [webService sharedInstance];
//    manager* m = [manager sharedInstance];
//    [service returnSearchAll:nil completionHandler:^(NSArray *array, NSError *error, NSString *httpStatus) {
//        self.markers = [m createMarkerArrayWithJson:array];
//        [self drawMarkers];
//    }];
    
    
    [self.view addSubview:self.mapView];
    
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
    _searchController.active = NO;
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    CSMarker* marker = [[CSMarker alloc]init];
    marker.position = place.coordinate;
    marker.title = @"Input Address";
    marker.snippet = place.formattedAddress;
    marker.map = self.mapView;
    marker.icon = [UIImage imageNamed:@"self"];
    [self.mapView animateToLocation:marker.position];
    
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

//delegate from GMSMapViewDelegate
-(UIView*)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    
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


//slider to set range of search
//- (IBAction)setRange:(UISlider *)sender {
//        NSLog(@"SliderValue ... %.2f",sender.value);
//    //self.range.text = [NSString stringWithFormat:@"%f",sender.value];
//}

- (IBAction)searchWithRange:(UIButton *)sender {
    
    
    
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
