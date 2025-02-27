
###Corduro Demos

####Example REGEX Testing:
[EXAMPLE](https://github.com/sitting-duck/stuff/blob/master/Java%20Dev/REGEX%20Practice/src/REGEXPracticeTests.java)

#####Disclaimor: 
Any comments made about code quality are not disparaging of any development done by the developers at Corduro. I am referring to problems caused by
outsourcing development to a third party company.

#####Description:
I wrote these tests to inform the developer that the client side GUI had broken because of changes on the backend.  

#####BackStory:
There was a class called WalletItem.  Conceptually, there are two types of wallet items, bank accounts and credit cards.
So one would think that the logical thing to do would be to create classes BankAccount and CreditCard that extend WalletItem.
Well, for whatever reason, that didn't happen, so instead of doing that an attribute called description was added
to WalletItem which contained information such as WalletItem type and and everything specific to that type. The implications of this were, 
bad, because that meant different functions had to be written for each different WalletItem type or each function had to be twice as long at least
because of all the extra checks for wallet type.

#####What I did:
I ended up taking the "good enough for now" approach and  added all the extra little checks and parsing functions into the WalletItem class itself, 			wrote their tests, reducing repeated code greatly, while writing the new polymorphic structure in a separate project until it was finished so as not to 		break existing code.

#####Why I did it:
Since I didn't have the authority to change anything on the backend, nor did I have the authority to force an update, I wrote some 
REGEX into some modular little funcions for fetching these attributes with exceptions that would be thrown in case these attributes were not found.
Since there was always the possibility that someone in the future may change the way these attributes are stored in the object, or change the way
the description is made on the backend I made these tests that would loudly inform the developer that something needs to be fixed pronto.

#####Why I had to do it:
After a request a the server would respond with some JSON which is pretty much just text.  The client app would have to convert this JSON into 
usable objects.  While we did use GSON to serialize and deserialize JSON objects/text, a bunch of attributes were still jammed into a long string 
called "Description". The bad thing about this is that an extra step is needed every time to get attributes inside this description.  Another bad 
thing about this was that every time in the app a credit card number was needed some variation of a text parsing function for "getCreditCardNumber" was 		rewritten (if it was even encapsulated in a fuction) The other bad thing about this is that GSON won't thrown an exception if needed about these 			attributes inside the description because as far as it's concerned, it's just text.

	


####Example Demo App Tutorial:
[EXAMPLE](https://github.com/sitting-duck/stuff/blob/master/Android%20Dev/Corduro%20Demo%20App/app/src/main/java/com/corduro/corduropaymobilesdkdemoapp/login/CorduroLoginActivity.java)

#####Description: 
I made a modified code example of what my demo app was like to show the basic idea of the demo app that I wrote.  In this way I can respect the NDA but
also basically show that I wrote an app that other developers can look at to see how to use the Corduro SDK. 

This page just shows how one would use the CurdoroSDK object to login to the Corduro network.

###Parasol Demo:

####Abstract:
[ABSTRACT](https://parasol.tamu.edu/people/atharp/project.php)
####Paper:
[PAPER](https://parasol.tamu.edu/people/atharp/rp.pdf)

#####Results: 
Decreased computation time with no noticable decrease in quality of results.

#####Description:
The size and complexity of geometric models is continually increasing due to improved tools and techniques for generating them and the computational 			resources available to render and process them. As such, there is an increased need for techniques to manipulate them.

ACD algorithm essentially searches for good 'cuts' using vertex concavity as a metric. (high concavity eg. armpit)

#####Challenges:
1. Selecting an appropriate tolerance (how concave is concave enough?)
2. Selected concavity can be 'too sensitive' for certain parts of the model.

#####Solution:
1. "Simplify" the model by "averaging" the locations of several vertices into one vertex
2. Use a more "relative" tolerance. Sample the current area for the average concavity and set the tolerance somewhere in that range.


	
