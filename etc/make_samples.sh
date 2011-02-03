echo "making markedoc samples"

sed -E -f bin/markedoc.sed samples/SAMPLE1.md > samples/doc/SAMPLE.edoc
erl -noshell -run edoc_run application "'myapp'" '"samples"' '[]'
mv samples/doc/overview-summary.html samples/what-you-could-see/sample1.html
mv samples/doc/SAMPLE.edoc samples/what-you-should-see/SAMPLE1.edoc

sed -E -f bin/markedoc.sed samples/SAMPLE2.md > samples/doc/SAMPLE.edoc
erl -noshell -run edoc_run application "'myapp'" '"samples"' '[]'
mv samples/doc/overview-summary.html samples/what-you-could-see/sample2.html
mv samples/doc/SAMPLE.edoc samples/what-you-should-see/SAMPLE2.edoc

sed -E -f bin/markedoc.sed samples/SAMPLE3.md > samples/doc/SAMPLE.edoc
erl -noshell -run edoc_run application "'myapp'" '"samples"' '[]'
mv samples/doc/overview-summary.html samples/what-you-could-see/sample3.html
mv samples/doc/SAMPLE.edoc samples/what-you-should-see/SAMPLE3.edoc

sed -E -f bin/markedoc.sed samples/SAMPLE1.md > samples/doc/SAMPLE.edoc
erl -noshell -run edoc_run application "'myapp'" '"samples"' '[{def,{vsn,""}},{stylesheet, "markedoc.css"}]'
mv samples/doc/overview-summary.html samples/what-you-could-see/sample1.html
mv samples/doc/SAMPLE.edoc samples/what-you-could-see/SAMPLE1.edoc

sed -E -f bin/markedoc.sed samples/SAMPLE2.md > samples/doc/SAMPLE.edoc
erl -noshell -run edoc_run application "'myapp'" '"samples"' '[{def,{vsn,""}},{stylesheet, "markedoc.css"}]'
mv samples/doc/overview-summary.html samples/what-you-could-see/sample2.html
mv samples/doc/SAMPLE.edoc samples/what-you-could-see/SAMPLE2.edoc

sed -E -f bin/markedoc.sed samples/SAMPLE3.md > samples/doc/SAMPLE.edoc
erl -noshell -run edoc_run application "'myapp'" '"samples"' '[{def,{vsn,""}},{stylesheet, "markedoc.css"}]'
mv samples/doc/overview-summary.html samples/what-you-could-see/sample3.html
mv samples/doc/SAMPLE.edoc samples/what-you-could-see/SAMPLE3.edoc	

echo "done"
echo "see samples/what-you-should-see/sample1.html - sample3.html"
echo "and samples/what-you-could-see/sample1.html - sample3.html"