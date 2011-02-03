echo -n "testing markedoc - Linux:  "

echo -n "1 ... "
sed -E -f bin/markedoc.sed samples/SAMPLE1.md > samples/doc/SAMPLE.edoc
erl -noshell -run edoc_run application "'myapp'" '"samples"' '[{def,{vsn,""}},{stylesheet, "markedoc.css"}]'
mv samples/doc/overview-summary.html samples/your-test-results/sample1.html
mv samples/doc/SAMPLE.edoc samples/your-test-results/SAMPLE1.edoc	

echo -n "2 ... "
sed -E -f bin/markedoc.sed samples/SAMPLE2.md > samples/doc/SAMPLE.edoc
erl -noshell -run edoc_run application "'myapp'" '"samples"' '[]'
mv samples/doc/overview-summary.html samples/your-test-results/sample2.html
mv samples/doc/SAMPLE.edoc samples/your-test-results/SAMPLE2.edoc

echo -n "3 ... "
sed -E -f bin/markedoc.sed samples/SAMPLE3.md > samples/doc/SAMPLE.edoc
erl -noshell -run edoc_run application "'myapp'" '"samples"' '[{def,{vsn,""}},{stylesheet, "markedoc.css"}]'
mv samples/doc/overview-summary.html samples/your-test-results/sample3.html
mv samples/doc/SAMPLE.edoc samples/your-test-results/SAMPLE3.edoc	

echo "done."
echo "=> now check samples/your-test-results/sample1.html - sample3.html"
echo "compare with samples/what-you-should-see/sample1.html, sample2.html"
echo "and samples/what-you-could-see/sample3.html"