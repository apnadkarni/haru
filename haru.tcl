# Copyright (c) 2022-2023 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
# haru - Tcl bindings for libharu (http://libharu.org/) PDF library.

# 10-02-2022 : v1.0   Initial release
# 12-06-2022 : v1.1
               # Fixes u3d_demo.tcl, to make it work with libharu 2.3.
               # Ignore some functions if not available. (Windows OS)
# 24-05-2023 : v1.2
               # Bumped libharu to v2.4.3.
               # Cosmetic changes.
               # Tested on Windows and Mac OS.

package require Tcl 8.6
package require cffi 1.0

namespace eval haru {

    variable libname "libhpdf"
    variable hpdfversion "2.4.3"
    variable version 1.2

    # constant variables
    variable HPDF_TRUE            1
    variable HPDF_FALSE           0
    variable HPDF_COMP_NONE       0
    variable HPDF_COMP_TEXT       1
    variable HPDF_COMP_IMAGE      2
    variable HPDF_COMP_METADATA   4
    variable HPDF_COMP_ALL        15
    variable HPDF_HIDE_TOOLBAR    1
    variable HPDF_HIDE_MENUBAR    2
    variable HPDF_HIDE_WINDOW_UI  4
    variable HPDF_FIT_WINDOW      8
    variable HPDF_CENTER_WINDOW   16
    variable HPDF_ENABLE_READ     0
    variable HPDF_ENABLE_PRINT    4
    variable HPDF_ENABLE_EDIT_ALL 8
    variable HPDF_ENABLE_COPY     16
    variable HPDF_ENABLE_EDIT     32
}

# Loading the library 
if {[catch {
    cffi::Wrapper create HPDF $::haru::libname-$::haru::hpdfversion[info sharedlibextension]
}]} {
    # Could not find the version-labeled library. Load without version.
    # We will check actual version later.
    cffi::Wrapper create HPDF $::haru::libname[info sharedlibextension]
}

# Gets hpdf version.
HPDF stdcall HPDF_GetVersion string {}
set ::haru::hpdfversion [HPDF_GetVersion]

if {![regexp {^2\.4\.} $::haru::hpdfversion]} {
    error "libhpdf version $::haru::hpdfversion is unsupported. Need 2.4.*"
}

package provide haru $::haru::version
