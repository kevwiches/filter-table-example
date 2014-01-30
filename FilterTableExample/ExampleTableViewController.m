//
//  ExampleTableViewController.m
//  FilterTableExample
//
//  Created by Kevin Juneja on 1/29/14.
//
//

#import "ExampleTableViewController.h"

@interface ExampleTableViewController ()
@property (nonatomic, strong) NSMutableArray *recipes; // stores all of the recipes
@property (nonatomic, strong) NSMutableArray *filteredRecipes; // stores recipes matching query
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar; // search bar outlet
@end

@implementation ExampleTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // add recipes
    self.recipes = [[NSMutableArray alloc] init];
    [[self recipes] addObject:@"Eggs Benedict"];
    [[self recipes] addObject:@"Mushroom Risotto"];
    [[self recipes] addObject:@"Ham and Eggs Sandwich"];
    [[self recipes] addObject:@"Instant Noodles with Eggs"];
    [[self recipes] addObject:@"Toast"];
    [[self recipes] addObject:@"Hamburger"];
    [[self recipes] addObject:@"Burger with Toast"];
    
    // add recipes to filtered array to start
    self.filteredRecipes = [[NSMutableArray alloc] initWithArray:self.recipes];

    
    // gesture recognizer for dismissing keyboard when clicking out of search bar
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

// selector to dismiss search keyboard
- (void) dismissKeyboard
{
    // add self
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // number of rows will size of filteredrecipes array
    return [[self filteredRecipes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // display the filtered recipes
    if ([[self filteredRecipes] count] > 0)
        [[cell textLabel] setText:[[self filteredRecipes] objectAtIndex:[indexPath row]]];
    
    return cell;
}

#pragma mark - Filter recipes

// takes a query and filters out the recipes that don't contain the query
-(void) filterRecipesWithQuery:(NSString *)query {
    // reset the filtered recipes array
    self.filteredRecipes = [[NSMutableArray alloc] initWithArray:self.recipes];
    
    // only remove if the query has a character
    if (![query isEqualToString:@""]) {
        // loop through the recipe array
        for (int i = 0; i < self.recipes.count; i++) {
            NSString *recipe = [[self.recipes objectAtIndex:i] lowercaseString];
            
            // check if the recipe contains the query, if it doesn't we remove it
            if ([recipe rangeOfString:query].location == NSNotFound)
                [self.filteredRecipes removeObject:[self.recipes objectAtIndex:i]];
        }
    }
    
    // reload the tableview
    [self.tableView reloadData];
}

// calls the filterrecipes method as the user is typing
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // grab the query
    NSString* query = [[searchBar.text stringByReplacingCharactersInRange:range withString:text] lowercaseString];
    
    // filter recipes
    [self filterRecipesWithQuery:query];
    
    return YES;
}

// call the filterrecipes method to keep the results when the user hits search
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // filter recipes
    [self filterRecipesWithQuery:searchBar.text];
    
    // dismiss keyboard
    [searchBar resignFirstResponder];
}


@end
