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
PYTHON ?= python

OPENSCAD ?= openscad

ALL_POWER_SUPPLIES = \
	default \
	Mean-Well-RS-50

WARN_IGNORE = Exported object may not be a valid 2-manifold and may need repair

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

	$(OPENSCAD) \
		-o "./out/.build-$(*)/result.stl" \
		"./mean-well-ps-cover.scad" 2>&1 | tee "./out/.build-$(*)/openscad.log"
	if $(GREP) --ignore-case --fixed-strings "WARNING" "./out/.build-$(*)/openscad.log" \
			| grep --ignore-case --fixed-strings --invert-match "$(WARN_IGNORE)"; then \
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

