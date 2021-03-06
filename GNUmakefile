# Parametric 3D printed covers for various Mean Well power supplies.
# Copyright (C) 2018  Ivan Mironov <mironov.ivan@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#

$(RM) ?= rm
MKDIR ?= mkdir
CP ?= cp
TEE ?= tee
GREP ?= grep
SED ?= sed
SHA512SUM ?= sha512sum
PYTHON ?= python

OPENSCAD ?= openscad

ROTATE_FOR_3D_PRINTER ?= true

ALL_POWER_SUPPLIES = \
	Mean-Well-RS-25 \
	Mean-Well-RS-50

.PHONY: help
help:
	@echo "Usage:"
	@echo "    make help"
	@echo "        Print this help message"
	@echo "    make clean"
	@echo "        Remove all generated files"
	@echo "    make all"
	@echo "        Generate STL files for all known power supplies"
	@echo
	@echo "    make default"
	@echo "        Generate STL file for default power supply"
	@echo "    make out/\$$PS_NAME.stl"
	@echo "        Generate STL file for specific power supply"

.PHONY: clean
clean:
	$(RM) --verbose --recursive ./out/.build-*
	$(RM) --verbose --recursive ./out/*.stl

out/%.stl: ps/%.scad mean-well-ps-cover.scad cover-defaults.scad local-overrides.scad
	$(RM) --verbose --recursive "./out/.build-$(*)"
	$(MKDIR) --verbose --parents "./out/.build-$(*)/ps"
	$(CP) --verbose --recursive ./*.scad "./out/.build-$(*)/"
	$(CP) --verbose --dereference "$(<)" "./out/.build-$(*)/ps/default.scad"

	cd "./out/.build-$(*)/" && $(OPENSCAD) \
		-D ROTATE_FOR_3D_PRINTER=$(ROTATE_FOR_3D_PRINTER) \
		-o "./result.stl" \
		"./mean-well-ps-cover.scad" 2>&1 | tee "./openscad.log"
	if $(GREP) --ignore-case --fixed-strings "WARNING" "./out/.build-$(*)/openscad.log"; then \
		false; \
	else \
		true; \
	fi
	$(PYTHON) "./c14n_stl" "./out/.build-$(*)/result.stl"
	$(CP) --verbose "./out/.build-$(*)/result.stl" "$(@)"

	$(RM) --recursive "./out/.build-$(*)"

.PHONY: default
default: out/default.stl

.PHONY: all
all: $(patsubst %,out/%.stl,$(ALL_POWER_SUPPLIES))

$(patsubst %,downloadable/%.stl,$(ALL_POWER_SUPPLIES)): $(patsubst %,out/%.stl,$(ALL_POWER_SUPPLIES))
	$(CP) --verbose $(^) "./downloadable/"

downloadable/sha512sum.txt: $(patsubst %,downloadable/%.stl,$(ALL_POWER_SUPPLIES))
	$(SHA512SUM) $(^) | $(SED) "s,downloadable/,," >"$(@)"

.PHONY: downloadable
downloadable: downloadable/sha512sum.txt

