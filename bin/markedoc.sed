# markedoc 0.2 - 02/02/11 - H. Diedrich <hd2010@eonblast.com>
# ----------------------------------------------------------
# sed command file to convert markdown format to edoc format
# FreeBSD flavour, superset of IEEE Std 1003.2 (``POSIX.2'') 
# Does work with Mac OS X, partially with non-FreeBSD *xes.
# ----------------------------------------------------------
# Use it to make a markdown readme file part of an edoc file:
# sed -E -f <this file> <markdown file> > <edoc file>
# ----------------------------------------------------------
# SAMPLE USE (FreeBSD):
# sed -E -f markedoc.sed README.markdown > overview.edoc
# ----------------------------------------------------------
# SAMPLE FILES:
# https://github.com/hdiedrich/markedoc/tree/master/samples
# ----------------------------------------------------------
# SAMPLE WORKFLOW (FreeBSD):
# sed -E -f markedoc.sed README.md > doc/README.edoc
# erl -noshell -run edoc_run application "'myapp'" '"."' '[]' 
# ----------------------------------------------------------
# REQUIREMENTS: FreeBSD / Mac OS X sed, Erlang
# ----------------------------------------------------------
# STATUS: Alpha. 
# You can do nice things but it likes to trip up EDoc.
# With a bit of patience, and mostly with pretty clean md
# markup, and some blank lines sometimes, most things work.
# ----------------------------------------------------------
# LICENSE: Free software, no warranties.
# ----------------------------------------------------------
# On edown: http://www.erlang.org/doc/apps/edoc/ 
# On Markdown: http://daringfireball.net/projects/markdown/
# On Edoc: http://www.erlang.org/doc/apps/edoc/ 
# On sed: http://www.gnu.org/software/sed/manual/sed.html
# ----------------------------------------------------------
# There are  many ways to create formats that will make the
# EDoc creator tilt and the  errors it throws are not quite
# illuminating to the reader sometimes. Make an incremental
# approach and see what works. As you can see from the live
# sample, it's quite a lot that does work and some bits can
# be worked out. Please experiment and push your fixes.
# - Thanks!
# ----------------------------------------------------------
# Repository: https://github.com/hdiedrich/markedoc/
# ----------------------------------------------------------
# Issues: https://github.com/hdiedrich/markedoc/issues
# ----------------------------------------------------------
# TODO:
# * robust alternates not tested for some time  
# * protect ampersands
# ----------------------------------------------------------

# **********************************************************
# SCRIPT
# **********************************************************
# Ach, da kommt der Meister! Herr, die Not ist gro�!   ~~~
#   ~~~  Die ich rief, die Geister, Werd ich nun nicht los.
# ----------------------------------------------------------
# This is a sed script for use with -E regexes, but not -n.
# s/<find>/<replace>/<flag>  is the basic sed regex replace
# command.  sed  normally works strictly line by line.  'N'
# is used to join lines. 't' is a conditional branch. ':'
# is a label. The order of replacement functions matters.
# See 'man sed' for more info. If you are a sed master, 
# your help making this better is much appreciated.
# ----------------------------------------------------------

:start

# as first line, make the @doc tag
# --------------------------------
1 i\
@doc\

# code sample blocks, trying to get them into one <pre> block
# -----------------------------------------------------------
# tabs are consumed for 'navigation'. sed is Turing complete.
# inserted space is needed by edocs.
# There are tabs in this pattern.
/^	/ {
	# break ... on last line ('N' would exit)
	$ b end_collect_with_last_line_hit
	s/^	(.*)$/ \1/
	# do ...
	: do_collect
		# append next line
		N
		# break ... if we are now into the last line
		# (or the test below will eat the tab away.)
		$ b end_collect_with_last_line_hit
		# does the current last line start with a tab, too?
		s/(\n)	(.*)$/\1 \2/
		# while: ... yes, then loop
		t do_collect
	# normal end of collect: got all indendet lines, plus one too many.
	# -----------------------------------------------------------------
	b normal_course
	#
	# Run into file end while looping
	# -------------------------------
	: end_collect_with_last_line_hit
	# and does that last line start with a tab, too?
	s/(\n)	(.*)$/\1 \2/
	s/^	(.*)$/ \1/
	# yes, then we're done actually
	t wrap_rest_and_done
	# else, cut it off and such, as normal
	# debug i\
	# debug normal
	#
	: normal_course
	# ... ok, we have multiple lines, and we have one line too much, back it all up.
	h
	# Handle the <pre> block to be (*):
	# ---------------------------------
	# cut off the last line, that doesn't belong and insert newlines
	s/^(.*)(\n)(.*)$/\2\1\2/
	# wrap all in the docs code tags ```...'''
	s/^(.*)$/```\1'''/
	# protect @ (for edoc related texts that explain @-tags). There is a tab in [].
	s/([ 	\"\'\`]+@)/\1@/g
	# send result to stdout  
	p
	# Now make sure that that last line is not lost:
	# ----------------------------------------------
	# get stored back
	g
	# this time discard all but the last line, which is processed further
	s/^.*\n(.*)$/\1/
	# jump to end
	b end_of_code_blocks_handling
	#
	# File End Remedy: wrap all to end and done.
	# ------------------------------------------
	: wrap_rest_and_done
	# debug i\
	# debug rest and done
 	# wrap all in the docs code tags ```...'''
	s/^(.*)$/```\1'''/
	# protect @ (for edoc related texts that explain @-tags). There is a tab in [].
	s/([ 	\"\'\`]+@)/\1@/g
	b end
	#
} 

:end_of_code_blocks_handling

# robust alternate for code blocks: each tabbed line
# --------------------------------------------------
# If the above keeps being difficult, use this more robust 
# version. The main difference is simply that it will tag each 
# line separately. If you work out the right margins and 
# paddings for <pre> in your css file, that might give just as
# nice results as the above. There are tabs in this pattern.
# s/^	(.+)$/```	\1'''/

# Erlang comments
# ---------------
# doesn't work yet 
# s/(\n\s*)(%[^\n]+)/\1<span class="comment">\2<\/span>/g

# links
# -----
# external links
s/\[([^]]+)\]\(([^)]+)\)/<a href=\"\2\">\1<\/a>/

# references - must have trailing double space! (could learn to look at next line for "...")
s/(\[([^]]+)\]): +\[?(http[s]?:\/\/[^.>" ]+\.[^>" ]+)\]? *	*("([^"]+)")? *	*$/\1 <a name="\2" id="\2" href="\3" target="_parent">\3<\/a>\5<br \/>/ 
s/(\[([^]]+)\]): +<?([^@>" ]+@[^.>" ]+\.[^>" ]+)>? *	*("([^"]+)")? *	*$/\1 <a name="\2" id="\2" href="mailto:\3">\3<\/a>\5<br \/>/ 

# smart reference for the [x]: ... format, jumping right to the referenced page.
# ------------------------------------------------------------------------------
s/\[([^]]+)\]\[\]/<a href="javascript:goto('\1')" onMouseOver="this.title=url('\1')">\1<\/a>/g
s/\[([^]]+)\]\[([^]]+)\]/<a href="javascript:goto('\2')" onMouseOver="this.title=url('\2')">\1<\/a>/g

# robust alternate reference for the [x]: ... format, jumping to footnote.
# ------------------------------------------------------------------------
# If you don't like the javascript tags, comment out the previous 'smart' 
# reference patterns and uncomment these.
# s/\[([^]]+)\]\[\]/<a href="#\1">\1<\/a>/g
# s/\[([^]]+)\]\[([^]]+)\]/<a href="#\2">\1<\/a>/g

# headlines by #
# --------------
# h1 demoted to h2 as h1 is reserved in edoc
s/^####(.+)$/====\1 ====/
s/^###(.+)$/===\1 ===/
s/^##(.+)$/==\1 ==/
s/^#(.+)$/==\1 ==/

# bullet points
# -------------
# edoc must see closing </li>
s/^\*(.+)$/<li>\1<\/li>/

# emails, urls
# ------------
s/<([^aA][^@>]+@[^.>]+.[^>]+)>/<a href=\"mailto:\1\">\1<\/a>/
s/<(http[s]?:\/\/[^.>]+.[^>]+)>/<a href=\"\1\">\1<\/a>/

# line breaks
# -----------
s/  $/<br \/>/

# italics, bold
# -------------
s/\*\*([^*]+)\*\*/<b>\1<\/b>/
s/\*([^*]+)\*/<em>\1<\/em>/

# single backticks
# ----------------
# make code quotes
s/`([^`]+)`/<code>\1<\/code>/g

# protect @
# ---------
# leading space or tab indicates use as code sample for, well, edoc
# itself most likely, so escape it. 
s/([ 	\"\'\`]+@)/\1@/g

# headlines by underline === or ---
# ---------------------------------
# demoted to h2 and h3, as h1 is reserved in edoc
{
	# don't check this for the last line ('N' would exit)
	$ b skip_alt_headlines
	# get next line
	N
	# contract === with previous to headline h2
	s/^(.+)\n=+ *$/== \1 ==/
	# if substitution took place, goto ...
	t substi
	# contract --- with previous to headline h2
	s/^(.+)\n-+ *$/=== \1 ===/g
	# if substitution took place, goto ...
	t substi
	# no substitution: print the previous line and start with latest from top
	# -----------------------------------------------------------------------
	# store the two lines we have now, one is the one formatting is done with
	# the next is the fresh one we just pulled.
	h
	# cut off the last line, print the ready formatted one
	P
	D
	# and this is the goto for successful headline substitutions above:
	:substi
} 

:skip_alt_headlines
:end

# at the bottom, add JS for the 'smart' direct jump
# -------------------------------------------------
# to a reference url in trailing '[]:...'-notation
$ a\
<script>\
// Jump directly to a referenced url given in trailing '[]:...'-notation\
function goto(tag) { parent.document.location.href = url(tag); }\
function url(tag) { var o=document.getElementById(tag); return o ? o.href : '#'+tag; }\
</script>

# debugger stable
# ---------------
#	i\
#	>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#	p
#	i\
#	<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# -----------------------------------------------------------------
# t,b "In most cases, use of these commands indicates that you are
# probably better off programming in something like awk or Perl."
# sed manual: http://www.gnu.org/software/sed/manual/sed.html
# -----------------------------------------------------------------
# 'powered by Eonblast' http://www.eonblast.com - all the new tech