# Run sharness tests
#
# Copyright (c) 2014 Christian Couder
# MIT Licensed; see the LICENSE file in this repository.
#
# NOTE: run with TEST_VERBOSE=1 for verbose sharness tests.

T = $(sort $(wildcard t[0-9][0-9][0-9][0-9]-*.sh))
SHARNESS = lib/sharness/sharness.sh

# Add below the binaries that this project generates or needs.
# For example:
# BINS = bin/ipfs
BINS =

all: aggregate

clean: clean-test-results
	@echo "*** $@ ***"
	# Clean binaries below.
	# For example:
	# -rm -rf bin/ipfs

clean-test-results:
	@echo "*** $@ ***"
	-rm -rf test-results

$(T): clean-test-results deps
	@echo "*** $@ ***"
	./$@

aggregate: clean-test-results $(T)
	@echo "*** $@ ***"
	ls test-results/t*-*.sh.*.counts | lib/sharness/aggregate-results.sh

# Add below some needed dependencies.
# For example:
# deps: $(SHARNESS) $(BINS) curl
deps: $(SHARNESS) $(BINS)

$(SHARNESS): FORCE
	@echo "*** checking $@ ***"
	lib/install-sharness.sh

# Add below other targets like:
# - the targets needed to build binaries,
# - targets using special compile flags,
# - targets to check or install dependencies.
#
# For example:
#
# bin/%: FORCE
# 	cd .. && make GOFLAGS=$(GOFLAGS) $@
#
# race:
# 	make GOFLAGS=-race all
#
# curl:
#	@which curl >/dev/null || (echo "Please install curl!" && false)

.PHONY: all clean $(T) aggregate FORCE

