These are Matlab software (together with some examples) for 
doing DWD based Systematic Bias Adjustment for Microarray
data.

The main function is in the file:   BatchAdjustCC.m

A test program, that illustrates several ways to call this 
function is in the file:   BatchAdjustCCtest.m

The function requires a number of different subroutines, so 
it is recommended that the full subdirectory structure be 
downloaded.  This may be easiest to do by downloading and 
expanding the file:   BatchAdjust.zip
Which is web accessible at:
http://genome.unc.edu/pubsup/dwd/BatchAdjust.zip
or alternatively at:
http://www.unc.edu/depts/statistics/postscript/papers/marron/GeneArray/BatchAdjust.zip

The program BatchAdjustCCtest.m contains several parts.

itest == 1, gives a simple example of an application to a
real data set (removing a simple binary source effect).

itest == 2, gives a more complex example, that requires
several applications of BatchAdjustCC.m, (removing both a
binary source effect, and also a 3 class batch effect).

itest == 100,...,120 were used to test various aspects of 
the function, and are probably not needed for most 
practical purposes.

Some additional notes:

i.  When running itest == 1 or itest == 2, the first part 
of the program is a fairly complicated read in of the 
data from an Excel spreadsheet.

ii.  The itest == 1 example is a single application, so 
the call is quite simple.

iii.  The itest == 2 example is more complex because:

  a.  Several applications are needed to handle the 
  complex source and batch effects being addressed.

  b.  There is also a part for printing the adjusted data
  out to a tab delimited text file.

iv.  Copy and modify the program as needed for other 
tasks.

iv.  E.g. To write a program that gives tab delimited text 
output for a simple example (such as itest == 1), copy the 
block of text that does the output, and modify 
appropriately.

v.  The paper proposing DWD batch adjustment is:
Adjustment of systematic microarray data biases
Monica Benito, Joel Parker, Quan Du, Junyuan Wu, Dong Xiang, 
Charles M. Perou, and J. S. Marron
Bioinformatics 2004 20: 105-114.
Web available at:
http://bioinformatics.oupjournals.org/cgi/content/abstract/20/1/105?etoc

vi.  The web page, with access to additional details, and 
access to the software is:
https://genome.unc.edu/pubsup/dwd/


TROUBLESHOOTING:
If the software does not work the first thing to check is to make sure
your Matlab path contains all the folders you unzipped from BatchAdjust.zip
Go to 'File->Set Path...'
Choose button on left 'Add with Subfolders' and then select the
top directory of your unzipped BatchAdjust.zip file

Try running again -- hopefully it will work!

If you still get an error that mentions anything starting with 'mex' such as
  ' dim. of linear var  = 107??? Undefined function or method 'mexnnz' for input
    arguments of type 'double'.'
then you probably need to recompile some code to be compatible with your machine.
The way to do this is to run the file 'Installmex.m' which is in the 
Subroutines/SDPT3-4-beta subfolder of the BatchAdjust folder.

After running Installmex.m, try running the batch adjust test again.

Hopefully it will work.

If it does not work and you are on Windows, look at the following
tech support article from the creators of Matlab: 
	http://www.mathworks.com/support/solutions/data/1-6IJJ3L.html?solution=1-6IJJ3L 