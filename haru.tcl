# Copyright (c) 2022-2025 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
# haru - Tcl bindings for libharu (http://libharu.org/) PDF library.

# 10-Feb-2022 : v1.0   Initial release
# 12-Jun-2022 : v1.1
               # Fixes u3d_demo.tcl, to make it work with libharu 2.3.
               # Ignore some functions if not available. (Windows OS)
# 24-May-2023 : v1.2
               # Bumped libharu to v2.4.3.
               # Cosmetic changes.
               # Tested on Windows and MacOS.
# 19-Jun-2025 : v2.0
               # Bumped libharu to `v2.4.5`.
               # Bumped package `tcl-cffi` to v2.*.
               # Support for Tcl9.
               # Try checking several places for the location of `libharu` lib.
               # Tested on Windows and MacOS.
               # Incompatibility with previous versions of this package :
               #   - Use `cffi::enum` instead of global variables 
               #    (see haru_enum.tcl : HPDF_TRUE, HPDF_COMP_ALL, etc...).
               # Cosmetic changes.

package require Tcl 8.6-
package require cffi 2.0

namespace eval haru {
    variable hpdfversion "2.4.5"
    variable version 2.0
}

# Try checking several places..
set lib_names [subst {
    libhpdf 
    hpdf
    /usr/local/lib/libhpdf
    libhpdf.$::haru::hpdfversion
    libhpdf-$::haru::hpdfversion
}]

set lib_found 0
set lname {}

foreach name $lib_names {
    if {![catch {
        cffi::Wrapper create HPDF ${name}[info sharedlibextension]
    } err]
    } {
        set lib_found 1; break
    }; lappend lname $err
}

# Generate error message if lib not found.
if {!$lib_found} {return -code error [join $lname \n]}

# Gets hpdf version.
HPDF stdcall HPDF_GetVersion string {}

if {[package vcompare [HPDF_GetVersion] $::haru::hpdfversion] < 0} {
    error "libhpdf version '[HPDF_GetVersion]' is\
           unsupported. Need '$::haru::hpdfversion' or later."
}

package provide haru $::haru::version