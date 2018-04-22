//
//  ChatsController.h
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import "ChatsController.h"

@implementation ChatsController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser != nil)
            [currentUser fetch];
        
        self.parseClassName = @"Channels";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self loadObjects];
    [self.searchBar resignFirstResponder];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self loadObjects];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query1 = [PFQuery queryWithClassName:@"Channel"];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Channel"];
    
    PFUser *currentUser = [[PFUser currentUser] fetch];
    
    NSMutableArray *channels = [[NSMutableArray alloc] init];
    [channels addObjectsFromArray:[currentUser objectForKey:@"channels"]];
    [query1 whereKey:@"objectId" containedIn:channels];
    
    //Check for search
    if (_searchBar.text.length > 0) {
        [query2 whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)%@", _searchBar.text]];
    }
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
    [query whereKey:@"objectId" containedIn:channels];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"name"];
    
    return query;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    AccountCell *cell = (AccountCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AccountCell" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (AccountCell *) currentObject;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
                break;
            }
        }
    }
    
    // Hide organization specific labels
    //cell.nameLabel.text = [[NSString alloc] initWithFormat:@"%@", object[@"name"]];
    [cell.nameLabel setHidden:YES];
    
    
    // Configure the cell to be for a channel
    [cell.fullnameLabel setHidden:NO];
    [cell.usernameLabel setHidden:NO];
    cell.fullnameLabel.text = [[NSString alloc] initWithFormat:@"%@", object[@"name"]];
    
    PFQuery *countMembersInChannel = [PFUser query];
    [countMembersInChannel whereKey:@"channels" containsString:object.objectId];
    [countMembersInChannel findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            cell.usernameLabel.text = [[NSString alloc] initWithFormat:@"%lu Members", [objects count]]; }
        
        if ([object[@"isOrganization"] boolValue])
            cell.profileImageView.image = [UIImage imageNamed:@"org-chatroom.pdf"];
        else {
            if ([objects count] > 2)
                cell.profileImageView.image = [UIImage imageNamed:@"multi-user-chatroom.pdf"];
            else
                cell.profileImageView.image = [UIImage imageNamed:@"single-user-chatroom.pdf"];
        }
    }];
    
    if ([object objectForKey:@"profileImage"] != nil) {
        cell.profileImageView.file = (PFFile *)[object objectForKey:@"profileImage"];
        [cell.profileImageView loadInBackground];
    }
    else {
        
    }
    
    cell.object = object;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}


 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
     if (indexPath.row == self.objects.count) {
         return nil;
     } else {
         return [super objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
     }
 }



 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NextPage";
    
    LoadCell *cell = (LoadCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LoadCell" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (LoadCell *) currentObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            }
        }
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"joinChannel"]) {
        //AccountCell *cell = (AccountCell *) sender;
        
        // Join a channel
    }
}

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat scrollViewHeight = scrollView.bounds.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height;
    CGFloat bottomInset = scrollView.contentInset.bottom;
    CGFloat scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight;
    
    if(scrollView.contentOffset.y >= scrollViewBottomOffset){
        // Fetch resources
        [self loadNextPage];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    NSIndexPath *pathToLastRow = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
    
    if ((lastRowIndex == 0) || (indexPath <= pathToLastRow)) {
        AccountCell *cell = (AccountCell *) [tableView cellForRowAtIndexPath:indexPath];
        //[self performSegueWithIdentifier:@"showProfile" sender:cell];
        
        PFObject *channel = [[[PFQuery queryWithClassName:@"Channel"] whereKey:@"objectId" equalTo:cell.object.objectId] getFirstObject];
        [self openChatRoom:channel];
    }
}

-(void)openChatRoom:(PFObject *)channel {
    MessagesController *vc = [MessagesController messagesViewController];
    vc.delegateModal = self;
    vc.channelObject = channel;
    vc.objectId = channel.objectId;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nc animated:YES completion:nil];
}

@end
