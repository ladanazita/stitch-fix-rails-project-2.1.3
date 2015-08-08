##Stitch Fix Take Home Test##

##### Built by Ladan Nasserian#####
###### *and coffee, lots and lots of coffee* ######


###Understanding the User###
I like to start building an app by understanding the user, and how they will be using the application. The users are the **warehouse employees**, and **the vendors** (in this case the reports being provided to the vendors by the warehouse employees making them indirect users). 

So I know that the warehouse employee will require some easy to use/simple interface, and the resulting report should provide exactly what the vendor would like to see. In this case, I believe the vendor would like to see :

* Clearanced Batch ID 
*  Item Number 	
* Status 
* Size 	
* Color 	
* Price Sold 	
* Retail Price 	
* Wholesale Price 	
* Style

For the Warehouse Employee, I believed the important points where:

* Item Number 	
* Batch Number 	
* Status 	
* Price Sold 	
* Wholesale Price 	
* Style 

The relationship between the style and price sold is important, and a warehouse employee can notice if things were not discounted correctly. I saw this view as mainly to look over items to put on clearance, so those details about the Items style did not seem necessary. 

### Wireframing ###
Next I wire frame the exact specifications the consumer is asking for. I create a MVP wireframe which includes the same select batch file feature, an additional enter item ID’s feature (with accompanying instructions to allow users to choose one method of uploading batches, and the chart of batch uploads with a view batch button to lead the warehouse employee to a list of items within this batch.

I also moved the root file to an index page leading the user to either the item list,  or upload clearance batch feature. I decided to not overcrowd the batch upload page with too many features, and wanted to keep the items shown on that page limited to ones which were associated with a clearance_batch_id.

The item list allows the warehouse employee to view all items on hand, and for another iteration of this application, I think it would be nice to allow the employee to select from the list and perform a batch upload as well. 

The wire framing process was extremely useful, because one feature allows the vendor to browse items, and groups them by **status** or by **batch**, while the other feature focuses on clearance batch uploading. What was important to me here was that I didn’t over flow that page with too much information. I thought about what exactly does the User need in order to complete his work. 

With my visual objectives in place, I was ready to start. 

###Setting up the environment, repository, and running tests###

I initially attempted my usual flow of bundle installing and rake db:migrate, however I received the error "rbenv: version `2.2.2' is not installed”
I attempted to upgrade my ruby version, however it wasn’t working out. I reverted to version 2.2.1
I ran my migrations and bundle installed my gems. 
Added some gems I like to use such as Better Errors.

As per the instructions I tested uploading the example CSV file. I received many errors, mostly that the item id * was not found. Then I saw the seed file… of course it couldn’t run the request without having the item number already in the database! Silly me!! Now that things are working as they should be, I can add these new features!

I made sure to setup a git repo, and initialized it with a first commit once I new the tests were passing.

From reading Stitch Fix blog, I know you have a simple workflow, and check out into branches when adding new features. I started with the routing and creating a browse items page. I checked out into a branch names browse_items. I wanted to start here so I could have a visual of  what items came through the batch clearance method, and how much they were discounted for. 

###Browse Item Feature###

I wanted to start with showing all the items in the inventory. So I generated an items controller, grabbed the index of items, and fixed my routing so the user would select a batch and through that ID be led to the list of items associated with it.

When thinking about queries to a database I start by going into rails console. I practice making queries to understand how to get exactly what I wanted from the DB. Once I had my rails console returning the data I wanted, I began building a controller for my items , with a simple index method to generate a list of all the items in the view. 

The main feature of this page is the browse aspect, and I knew I wanted to group by either status or batch. I didn’t want to use the Ransack gem, since it was a simple search. I decided to keep it simple and incorporated the search feature in the model. I have a simple query, that searches the params status or batch id based on the user's input, and returns an updated index view. 

###Clearance Batch Report###

My next step was to included the clearance_batch report in an show action in the clearance batch controller. I wanted the user flow to be simple, and so the user could go directly to that item list associated with a clearance batch. I added a simple show action to the clearance_batch_controller, which grabs the clearance batch by id, and searchs Items with that foreign key. 

###Set Minimum###

Next up was setting up the minimum prices when a batch clearance method was enacted. 
I knew there were certain things I needed to return in order to satisfy this. For style I am trying to grab the type, from there I need to assess if it is pants and/or dresses, the min they can be sold for is $5. Everyother item the minimum is $2.

I had the logic understood… but *where, pray tell, should this code live?* I researched services, looked through the clearance_batch service, and I thought I would have to have this in an item_service. But I noticed the update_attributes! method in Item.rb. A validation would be perfect in order to maintain that the correct price is saved to my db. This is where the actual attribute is being changed, and I thought it would be simple enough to add a validation. But this would require a custom validation, since the price is dependent on the style.

I created a private method to assess the custom value of the style.type attribute, and added that method as a validation. 

###Input by Item ID###

Finally, I had to allow the user to input item IDs as an alternative way to add a clearance batch. I know there is already a create method in the Clearance Batch Controller, so I will have to deconstruct what is going on there in order to add another create method. 

I also had to be sure that it new there were two methods for the create action in the Clearance_Batch_Controller, so a simple boolean to see if the csv_batch_file was present did the trick. 

Breaking it down simply, I created a method and a text field in my view that takes in item numbers. The input is separated by commas to indicate end of one item number. So the input is coming in as a string, but I have an indication to treat is as an array by adding "item_number[]". 

The problems came when testing it. I had setup my logic in way that would take the index value if a string was inputted. So my errors were not showing correctly. If I had “no thanks” inputted, it returned “Item id 0 is invalid”. On top of that, my factory was returning an array, where my method was conflicting with it due to the (to_i) aspect of my logic. 

So understanding this, I had to refactor my code to make sure it cleaned up the input. I ended up with this 

	numbers_input = input.join(",").split(",").map(&:to_i)

I think the hardest part was writing the tests, mainly due to simulating the factory to input the same way a user would.

###Testing###

I tested during each feature's as I built them. Some things I learned were the importance of how you build your Factory, and to really understand what the User is inputting, and how I am handling that input.

With the Input by Item ID method, my errors exposed that I wasn't giving back the correct errors for invalid factories. This allowed me to catch something that misleadingly worked on the GUI. 

The heaviest testing I implemented was on the Item ID method, mainly because it was complex, dealt with another evenly complex method, and is the most essential aspect of the application. 

I consulted with Megan, the recruiter I was talking with, to indicate the additional time I would need to be sure I had this feature tested.

###Styling###

I added pagination and a simple image to lively up the app. The footer is just a Bootstrap default, and the pagination style was infulenced by Flickr. I didn't want to do too much, since I know the objective of the project was a bare bones application that shows my methodologies and coding abilities.

###Thank you!###
I had a lot of fun making this app. It was a new way of interviewing for a job, and I think it worked out great. I really admire you guys for simulating a realistic work environment, and hope to continue this type of work with you all at Stitch Fix. I really appreciate this opportunity, I learned a lot, and really enjoyed the project. Thanks again :)

####LadanAzita@gmail.com####
#####*310 594 0780* #####
