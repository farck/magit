TOP := $(dir $(lastword $(MAKEFILE_LIST)))

PREFIX   ?= /usr/local
sharedir ?= $(PREFIX)/share
lispdir  ?= $(sharedir)/emacs/site-lisp/magit
infodir  ?= $(sharedir)/info
docdir   ?= $(sharedir)/doc/magit
statsdir ?= ./stats

CP    ?= install -p -m 644
MKDIR ?= install -p -m 755 -d
RMDIR ?= rm -rf
TAR   ?= tar

PACKAGES = magit magit-popup with-editor
PACKAGE_VERSIONS = $(addsuffix -$(VERSION),$(PACKAGES))
PACKAGE_TARBALLS = $(addsuffix .tar,$(PACKAGE_VERSIONS))

INFOPAGES = $(addsuffix .info,$(PACKAGES))
TEXIPAGES = $(addsuffix .texi,$(PACKAGES))

ELS  = with-editor.el
ELS += git-commit.el
ELS += magit-popup.el
ELS += magit-utils.el
ELS += magit-section.el
ELS += magit-git.el
ELS += magit-mode.el
ELS += magit-process.el
ELS += magit-core.el
ELS += magit-diff.el
ELS += magit-wip.el
ELS += magit-apply.el
ELS += magit-log.el
ELS += magit.el
ELS += magit-sequence.el
ELS += magit-commit.el
ELS += magit-remote.el
ELS += magit-bisect.el
ELS += magit-stash.el
ELS += magit-blame.el
ELS += magit-ediff.el
ELS += magit-extras.el
ELS += git-rebase.el
ELCS = $(ELS:.el=.elc)
ELGS = magit-autoloads.el magit-version.el

EMACSBIN ?= emacs

ELPA_DIR ?= $(HOME)/.emacs.d/elpa

DASH_DIR ?= $(shell \
  find -L $(ELPA_DIR) -maxdepth 1 -regex '.*/dash-[.0-9]*' 2> /dev/null | \
  sort | tail -n 1)
ifeq "$(DASH_DIR)" ""
  DASH_DIR = $(TOP)../dash
endif

CYGPATH := $(shell cygpath --version 2>/dev/null)

ifdef CYGPATH
  LOAD_PATH ?= -L $(TOP)/lisp -L $(shell cygpath --mixed $(DASH_DIR))
else
  LOAD_PATH ?= -L $(TOP)/lisp -L $(DASH_DIR)
endif

BATCH = $(EMACSBIN) -batch -Q $(LOAD_PATH)

VERSION = $(shell \
  test -e $(TOP).git\
  && git describe --tags --dirty 2> /dev/null\
  || $(BATCH) --eval "(progn\
  (fset 'message (lambda (&rest _)))\
  (load-file \"magit-version.el\")\
  (princ magit-version))")
