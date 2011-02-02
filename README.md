markedoc 0.2
============

 **markedoc** helps you keep your project's README.md in sync with your overview.edoc. It works with FreeBSD and Mac OS X sed.

Status: **alpha**. Usable. See [Status][].

markedoc translates [Markdown][] formatted texts into [Erlang][] [EDoc][] format, for inclusion into [EDoc][] generated html docs.

The actual script file is in the bin folder: bin/markedoc.sed.

markedoc is but a [sed][] command file to convert markdown to edoc. Use it to translate your project's README.md into a README.edoc to include in your Erlang project's main overview.edoc file.

markedoc is part of the **[edown][]** project.

Your contribution to make markedoc stable is highly welcome.

Use
---
At the command line:

	$ sed -E -f markedoc.sed <markdown file> > <edoc file>

Requirements
------------
* **[FreeBSD sed][sed]**: is part of any Linux FreeBSD and Mac OSX distribution.

* **[Erlang/OTP][Erlang]**: see below.  

Sample
------

From project root (were the README.md file is), try out:

	$ sed -E -f bin/markedoc.sed samples/SAMPLE1.md > samples/doc/SAMPLE.edoc
	$ erl -noshell -run edoc_run application "'myapp'" '"samples"' '[]'

This creates a SAMPLE.edoc file from SAMPLE1.md, which is then included in the EDoc generation. Point your browser at

	samples/doc/index.html
	
to see the result.

For your own projects you'd copy markedoc.sed in the right place and do something like:

	$ sed -E -f bin/markedoc.sed README.md > doc/README.edoc
	$ erl -noshell -run edoc_run application "'myapp'" '"."' '[]'	

And that's it. This could also be part of your Makefile. So that the README.edoc automatically becomes part of your generated EDoc html pages, you would use a @docfile tag in your overview.edoc file, like so:

	@docfile "doc/README.edoc"

After running sed, then edoc, this makes the README.edoc part of the overview page.

Accordingly, the sample overview.edoc used for the samples, looks like this:

	@author You 
	@title  a markedoc sample doc
	@version 0.2
	@docfile "samples/doc/SAMPLE.edoc"

Status
------

 **Alpha**. Quite usable, but still likes to trip up EDoc now and then, which is kind of easy to do.

There are  many ways to create formats that will make the EDoc generator tilt and unfortunately, the errors it throws are sometimes not quite so illuminating to the reader. But why not try an incremental approach and see what works. As you can see from this [source sample][sample], which works alright, it's quite a lot that *does* work and some bits can be worked out. Sometimes an additional line helps, some spaces at the end of line, general intuitive stuff. Please experiment and push your fixes.

 **Thanks!**

Notes
-----

 **[Erlang][]** is a programming language used to build massively scalable soft real-time systems with requirements on high availability. Some of its uses are in telecom, banking, e-commerce, computer telephony and instant messaging. Erlang's runtime system has built-in support for concurrency, distribution and fault tolerance. Erlang comes bundled with the Open Telecom Platform, OTP.

[Erlang]: http://www.erlang.org/doc/  

 **[EDoc][]** is the Erlang program documentation generator. Inspired by the Javadoc tool for the Java programming language, EDoc is adapted to the conventions of the Erlang world, and has several features not found in Javadoc. Edoc is part of the Erlang/OTP distribution.

[EDoc]: http://www.erlang.org/doc/apps/edoc/chapter.html

 **[edown][]** is an EDoc extension for generating Github-flavored Markdown. It uses edoc-style commented Erlang sources to create markdown files from them. 

[edown]: https://github.com/esl/edown

 **[Markdown][]** is a text-to-HTML conversion tool for web writers. Markdown allows you to write using an easy-to-read, easy-to-write plain text format, then convert it to structurally valid XHTML (or HTML).

[Markdown]: http://daringfireball.net/projects/markdown/ 

 **[sed][]** ('stream editor') is a Unix utility that parses text files and implements a programming language which can apply textual transformations to such files. It reads input files line by line (sequentially), applying the operation which has been specified via the command line (or a sed script), and then outputs the line. It is available today for most operating systems. There seems to be [one for Windows][winsed], too.

[sed]: http://en.wikipedia.org/wiki/Sed
[winsed]: http://gnuwin32.sourceforge.net/packages/sed.htm
[sample]: https://github.com/Eonblast/Emysql/raw/master/README.md "This markdown file is translated alright by markedoc."

Todo
----
* make work with non-FreeBSD sed
* robust alternates not tested for some time
* protect ampersands

Development
-----------
This tests markedoc with its three samples and saves the results into samples/what-you-should-get/

	sed -E -f bin/markedoc.sed samples/SAMPLE1.md > samples/doc/SAMPLE.edoc
	erl -noshell -run edoc_run application "'myapp'" '"samples"' '[]'
	mv samples/doc/overview-summary.html samples/what-you-should-get/sample1.html
	mv samples/doc/SAMPLE.edoc samples/what-you-should-get/SAMPLE1.edoc
	
	sed -E -f bin/markedoc.sed samples/SAMPLE2.md > samples/doc/SAMPLE.edoc
	erl -noshell -run edoc_run application "'myapp'" '"samples"' '[]'
	mv samples/doc/overview-summary.html samples/what-you-should-get/sample2.html
	mv samples/doc/SAMPLE.edoc samples/what-you-should-get/SAMPLE2.edoc
	
	sed -E -f bin/markedoc.sed samples/SAMPLE3.md > samples/doc/SAMPLE.edoc
	erl -noshell -run edoc_run application "'myapp'" '"samples"' '[]'
	mv samples/doc/overview-summary.html samples/what-you-should-get/sample3.html
	mv samples/doc/SAMPLE.edoc samples/what-you-should-get/SAMPLE3.edoc
	
To test README.md, use markdown.lua (credit: Niklas Frykholm, <niklas@frykholm.se>):

	lua etc/markdown.lua README.md


License
-------
This script is free software. It comes without any warranty.

Author
------

H. Diedrich <hd2010@eonblast.com>

History
-------

02/02/11 - 0.2 - **FreeBSD / Mac OS X: basics complete**
	
* both headline modes are now supported (#,## ... and ===,---)
* fixed cutting off of last lines 
* fixed page-local anchor jumps
* fixed space in javascript links
* eliminated end-space requirement at end of '[..]:...'-style references.
* eliminated need for echoing '@doc' first into edoc output file
* added javascript title tag setting for '[..]:...'-style references.

01/31/11 - 0.1 - **FreeBSD / Mac OS X: first  release**
	