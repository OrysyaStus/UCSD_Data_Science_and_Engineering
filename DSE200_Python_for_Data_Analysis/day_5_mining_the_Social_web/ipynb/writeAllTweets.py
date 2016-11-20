import tweetstream
import codecs
stream = tweetstream.SampleStream("ID", "password");
f = codecs.open("dumpfile", "w", encoding="UTF-8");
counter=0;
for tweet in stream:
   counter=counter+1;
   
   try:
      f.write(counter+" TEXT: "+tweet["text"]);
   except KeyError:
      print "No text field";

   try:
      g=tweet["geo"];  #try to print the geographical location of the twitter
      try:
         if(not g is None):
            print counter," LOCATION: ",g;
      except AttributeError:
         g=None; #print "AttributeError, g=|",g,"|";
   except KeyError:
      g=None;
      
