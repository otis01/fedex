
## DIGITAL DATA ANALYST Assessment

### Setup

To install Jupyter Notebook on MacOS
```commandline
brew install jupyter    
```

To run the Notebook:
```commandline
jupyter notebook
```

### Data source
File: assessment_database.sqlite
- CustomerList1 (primary key: Customer_id)
- CustomerList2 (primary key: Customer_id)
- ListOfOrders (consists of customers’ orders)
- OrderBreakdown (consists of products of each order)

### Tasks

#### PART 1 (SQL)

There are two customer tables, both have missing values in each field. 
They’re not exclusive to each other, meaning they have some unique customers and also some duplicate customers. 
Please use SQL to get 
- a unique customer list and segment customers into 10 age groups
- calculate number of unique customers of each gender in these age groups

#### PART 2 (Data Wrangling)
What is our most profitable customer group? 
Feel free to define your own customer group, as long as you provide a rationale for why you chose this group.
Open question: demonstrate your data wrangling and visualization skills by summarizing the dataset
provided with this assessment. 

Answer:
- Most profitable group is Men of the age of 50-60 in the UK 
that are interested in technology and office supplies.

#### Deliverable
- Data wrangling
- Data visualization
- Storytelling

Create a single Jupyter notebook that contains both data wrangling and storytelling. 
Share the entire notebook with us.

