SHELL := /bin/bash
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell uname -s | tr A-Z a-z)

export XDG_CONFIG_HOME = $(HOME)/.config
export XDG_CACHE_HOME = $(HOME)/.cache
export XDG_DATA_HOME = $(HOME)/.local/share


all: setup link
	chmod 700 $(XDG_CONFIG_HOME)/gnupg
	chmod 600 $(XDG_CONFIG_HOME)/gnupg/*

	mkdir -p $(XDG_CACHE_HOME)/ssh

setup:
	cd $(DOTFILES_DIR)/$(OS) && . ./setup.sh

link:
	for f in $$(ls -A $(DOTFILES_DIR)/env); do \
		tf=$(HOME)/$$f; \
		if [[ -e $$tf && ! -L $$tf ]]; then \
			mv -v $$tf{,.bak}; \
		fi \
	done
	mkdir -p $(XDG_CONFIG_HOME) $(HOME)/.local
	stow -v -t $(HOME) env
	stow -v -t $(XDG_CONFIG_HOME) config

unlink:
	stow -v -D -t $(HOME) env
	stow -v -D -t $(XDG_CONFIG_HOME) config
	for f in $$(ls -A $(DOTFILES_DIR)/env); do \
		tf=$(HOME)/$$f; \
		if [[ -f $$tf{.bak} ]]; then \
			mv -v $tf{.bak,}; \
		fi \
	done
