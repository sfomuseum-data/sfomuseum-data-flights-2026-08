OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')

export-all:
	python utils/python/export.py -r .

# See the way we're egrep '.geojson$$' the new files
# that's so we don't try to export .attrs files
# (20200110/thisisaaronland)

export-new:
	git status --porcelain --untracked-files=all | egrep '.geojson$$' | awk '{ print $$2 }' > new.txt
	python utils/python/export.py -r . -f new.txt
	rm new.txt

prune:
	git gc --aggressive --prune

rm-empty:
	find data -type d -empty -print -delete

scrub: rm-empty prune

count:
	find data -name '*.geojson' -print | wc -l

# metafiles:
# 	utils/$(OS)/wof-build-metafiles -out meta .

# stats:
# 	if test ! -d docs/stats; then mkdir -p docs/stats; fi
# 	utils/$(OS)/wof-stats-counts -pretty -custom 'properties.sfomuseum:placetype' -out docs/stats/counts.json ./
# 	utils/$(OS)/wof-stats-du -pretty > docs/stats/diskusage.json ./
