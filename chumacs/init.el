;; Start Garbage Collection performance tweak:
(setq gc-cons-threshold (* 50 1000 1000))

;; Initialize vim keybindings
(evil-mode)

;; Display line numbers in every buffer
(global-display-line-numbers-mode 1)

;; Set frame fringe
(set-fringe-mode 10)

;; Make escape key (ESC) kill prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t)

;; Start installing & configuring packages

;; Make UI more minimal
(use-package command-log-mode)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package all-the-icons)

(use-package doom-themes
  :init (load-theme 'doom-dracula t))

;; Load the Modus Vivendi dark theme
;; (load-theme 'modus-vivendi t)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 1))

(use-package ivy-rich
  :init (ivy-rich-mode 1))

(recentf-mode 1) ; remember recent file history

;; Save what you enter into minibuffer prompts
(setq history-length 25)
(savehist-mode 1)

;; Remember and restore the last cursor location of opened files
(save-place-mode 1)

;; Don't pop up UI dialogs when prompting
(setq use-dialog-box nil)

;; Buffer auto-reversion
;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)
;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq inhibit-startup-message t) ; Don't show a splash screen

(setq menu-bar-mode -1) ; Don't show a menu bar

(setq tool-bar-mode -1) ; Don't show a tool bar

(setq scroll-bar-mode -1) ; Don't show a scroll bar

(setq standard-indent 2) ; Set standard indentation to 2 spaces

(setq visible-bell t) ; Visible flashing bell

;; End Garbage Collection performance tweak:
(setq gc-cons-threshold (* 2 1000 1000))
