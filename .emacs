
;;; My .emacs file

;; by Phil Hagelberg
;; Much thanks to emacswiki.org and RMS.

;; Note: this relies on files found in my .emacs.d:
;; http://dev.technomancy.us/phil/browser/dotfiles/.emacs.d

;; "Emacs outshines all other editing software in approximately the
;; same way that the noonday sun does the stars. It is not just bigger
;; and brighter; it simply makes everything else vanish."
;; -Neal Stephenson, "In the Beginning was the Command Line"

;; "What you want is probably already in Emacs. If you don't use Emacs,
;; start. If do use Emacs, use it more. If you *still* can't do what you
;; want to do, you probably shouldn't do it."
;; -Shawn Betts, Ratpoison FAQ

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq load-path (append '("~/.emacs.d") load-path))
;(setq load-path (append '("~/.emacs.d/arorem2") load-path))
(setq load-path (append '("~/.emacs.d/rinari") load-path))
(setq load-path (append '("~/.emacs.d/rinari/rhtml") load-path))
(toggle-debug-on-error)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; loading modes

(autoload 'php-mode "php-mode")
(autoload 'yaml-mode "yaml-mode")
(autoload 'css-mode "css-mode")

(add-to-list 'auto-mode-alist '("\\.js$" . c-mode))
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(autoload 'tabbar-mode "tabbar")
(autoload 'lisppaste-paste-region "lisppaste" "" t)
(autoload 'ebby "ebby" "" t)
(autoload 'htmlize-region "htmlize" "" t)
(autoload 'htmlize-buffer "htmlize" "" t)
(autoload 'color-theme-zenburn "zenburn")
(autoload 'textile-to-html-region "textilize")

(require 'psvn)
(require 'pastie)
(require 'compile)
(require 'which-func)
(require 'elunit)
;(color-theme-zenburn)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ruby help

;; syntax highlighting needs to be done before ruby-electric
(global-font-lock-mode t)

;(setq erb-background "grey18") ; must do before rhtml-mode is loaded, i think

(require 'ruby-electric)
(require 'rinari)
(require 'ri-ruby)

;(set-face-background 'erb-face "grey18")

(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode)) ; d'oh!

(add-hook 'ruby-mode-hook 'my-ruby-mode-hook)

(defun my-ruby-mode-hook ()
  (ruby-electric-mode)
  (hs-minor-mode)
  (if (= emacs-major-version 22) (reveal-mode))
  (define-key ruby-mode-map "\C-\M-h" 'backward-kill-word) ; ruby-mode redefines this badly
  (local-set-key (kbd "RET") 'ruby-reindent-then-newline-and-indent))

(setq ri-ruby-script (expand-file-name "~/.emacs.d/ri-emacs.rb"))

(when (= emacs-major-version 22)
  (ido-mode t)
  (ido-toggle-prefix)
  (setq ido-enable-flex-matching t)
  (setq ido-create-new-buffer 'always)
  (file-name-shadow-mode t)
  (add-to-list 'hs-special-modes-alist
	       (list 'ruby-mode
		     (concat ruby-block-beg-re "\|{")
		     (concat ruby-block-end-re "\|}")
		     "#"
		     'ruby-forward-sexp nil)))

;; Thanks PragDave:

(defun ruby-xmp-region (reg-start reg-end)
  "Pipe the region through Ruby's xmp utility and replace
     the region with the result."
  (interactive "r")
  (shell-command-on-region reg-start reg-end
			   "ruby -r xmp -n -e 'xmp($_, \"%l\t\t# %r\n\")'" t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lisp
;;

(add-to-list 'load-path "~/.emacs.d/slime-2.0/")
(setq inferior-lisp-program "/usr/local/bin/lisp")
(autoload 'slime "slime-setup")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IRC

(if (functionp 'rcirc)
    (load "rcirc-config"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Jabber

;; not included in my .emacs.d; need to apt-get install emacs-jabber here

(when (functionp 'jabber-connect)
  (setq jabber-nickname "")
  (setq jabber-password nil)
  (setq jabber-resource "emacs-memex")
  (setq jabber-server "hagelb.org")
  (setq jabber-username "phil"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     key bindings

(global-set-key "\C-\M-h" 'backward-kill-word)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-x\C-r" 'jump-to-register)
(global-set-key "\C-x-" 'shrink-window)
(global-set-key "\C-x=" 'enlarge-window)
(global-set-key "\C-xO" (lambda () (interactive) (other-window -1)))
(global-set-key "\C-x." (lambda () (interactive) (enlarge-window 1 t)))
(global-set-key "\C-x," (lambda () (interactive) (shrink-window 1 t)))
(setq outline-minor-mode-prefix [(control o)])

; hide-show
(global-set-key "\M-[" 'hs-hide-block)
(global-set-key "\M-]" 'hs-show-block)
(global-set-key "\M-{" 'hs-hide-level)
(global-set-key "\M-}" 'hs-show-all)

; linear buffer-switching
(global-set-key "\M-p" 'bs-cycle-next)
(global-set-key "\M-n" 'bs-cycle-previous)
(global-set-key [XF86Back] 'bs-cycle-next)
(global-set-key [XF86Forward] 'bs-cycle-previous)
(setq bs-cycle-configuration-name "files")

; 2D spatial buffer-switching
(global-set-key [(control shift p)] 'tabbar-backward-group)
(global-set-key [(control shift n)] 'tabbar-forward-group)
(global-set-key [(control shift b)] 'tabbar-backward)
(global-set-key [(control shift f)] 'tabbar-forward)

; sometimes my hands aren't in the right place
(global-set-key [(control shift up)] 'tabbar-backward-group)
(global-set-key [(control shift down)] 'tabbar-forward-group)
(global-set-key [(control shift left)] 'tabbar-backward)
(global-set-key [(control shift right)] 'tabbar-forward)

; just useful for learning new modes
(global-set-key [f1] 'menu-bar-mode)

(global-set-key [f2] 'color-theme-zenburn)
(global-set-key [(control shift 2)] 'mark-string)
(global-set-key [(shift f2)] 'color-theme-standard)

(global-set-key [f3] 'rename-buffer)

; music management
(global-set-key [f4] (lambda ()
		       (interactive)
		       (shell-command "ssh philisha.net mpc toggle")))

(global-set-key [(shift f4)] (lambda ()
			       (interactive)
			       (shell-command "ssh philisha.net mpc next")))

(global-set-key [(control f4)] (lambda (dir)
				 (interactive (list (completing-read "Play directory: " (split-string (shell-command-to-string "ls ~/music") "\n"))))
				 (shell-command (concat 
						 "ssh philisha.net mpc clear; "
						 "ssh philisha.net mpc add " dir
						 "; ssh philisha.net mpc play"))))

(global-set-key [f5] 'compile)


;; For Ebby debugging, mostly
(global-set-key [f7] (lambda () (interactive) (message "%s" (point))))

(global-set-key [f9] '(lambda () 
			(interactive) 
			(if (get-buffer "*ansi-term*")
			    (switch-to-buffer "*ansi-term*")
			  (ansi-term "/bin/bash"))))

; great for quick googles
(global-set-key [f10] 'w3m)

(global-set-key [(meta f10)] 'ruby-xmp-region)

(global-set-key [f11] 'ri)

(global-set-key [f12] '(lambda ()
			 (interactive)
			 (write-file "~/mjolnir/apps/technomancy/public/tmp/tmp.txt")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; defuns

(defun lorem ()
  "Insert a lorem ipsum."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do "
          "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad "
          "minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
          "aliquip ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
          "pariatur. Excepteur sint occaecat cupidatat non proident, sunt in "
          "culpa qui officia deserunt mollit anim id est laborum."))

(defun display-image ()
  "display images using imagemagick"
  (interactive) 
  (shell-command (concat "display " 
			 (thing-at-point 'filename))))

(defun flickr-grab ()
  "Display only the photo from a flickr url"
  (interactive)
  (w3m-browse-url
   (with-current-buffer (url-retrieve-synchronously (thing-at-point 'filename))
     (save-excursion
       (re-search-backward "src=\"\\(http://static\\.flickr\\.com/[[:digit:]]*/[[:digit:]]*\_[[:alnum:]]*\\.jpg\\)")
       (match-string 1)))))

(defun map-coords (lat lon)
  (interactive "BLatitude: \nBLongitude")
  (w3m-browse-url (concat "http://maps.yahoo.com/maps_result?mag=12&lat="
			  lat "&lon=" lng)))

(defun smallish (&optional font-size)
  (interactive)
  (set-default-font (concat "terminus-" (or font-size "12")))
  (tabbar-mode -1)
  (scroll-bar-mode -1))

(defun mark-string ()
  (interactive)
  (setq deactivate-mark nil)
  (push-mark (search-forward "\"") t t)
  (search-backward "\""))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     registers (C-x C-r)

(set-register ?e '(file . "~/.emacs"))
(set-register ?d '(file . "~/.emacs.d"))
(set-register ?r '(file . "~/.emacs.d/rinari/rinari.el"))
(set-register ?y '(file . "~/.emacs.d/ebby.el"))
(set-register ?g '(file . "~/.gnus.el"))
(set-register ?b '(file . "~/.bashrc"))
(set-register ?s '(file . "~/.screenrc"))
(set-register ?t '(file . "~/mjolnir/paxtel_timecard.2006"))
(set-register ?u '(file . "~/mjolnir/ujive_timecard.2006"))
(set-register ?c '(file . "~/.contacts"))
(set-register ?p '(file . "~/paxtel/app/views/vehicles/index.rhtml"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     misc things

(when window-system
  (mouse-wheel-mode t)
  (global-hl-line-mode t)
  (set-scroll-bar-mode 'right) ; mostly for seeing how far down we are, not for clicking
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
;  (set-default-font "terminus-16") ; apt-get install xfonts-terminus
  (setq browse-url-browser-function 'browse-url-epiphany)
  (tooltip-mode -1)
  (tool-bar-mode -1)
  (blink-cursor-mode -1)
  (add-hook 'erc-text-matched-hook 'erc-notify-keyword))

(when (not window-system)
  (keyboard-translate ?\C-h ?\C-?))

(add-to-list 'comint-mode-hook 'ansi-color-for-comint-mode-on)

(setq font-lock-maximum-decoration t)
(setq inhibit-startup-message t)
(setq transient-mark-mode t)
(auto-compression-mode t) ; load .gz's automatically
(global-font-lock-mode t)
(menu-bar-mode -1) ; toggled by F1
(show-paren-mode 1)
(setq color-theme-is-global nil)
(put 'narrow-to-region 'disabled nil)
(defalias 'yes-or-no-p 'y-or-n-p)

;; don't clutter directories!
(setq backup-directory-alist `(("." . ,(expand-file-name "~/.emacs.d/backups"))))
(setq auto-save-directory (expand-file-name "~/.emacs.d/backups"))

;; w3m
(setq w3m-use-cookies t)
(setq w3m-default-save-directory "~/")

(mapc (lambda (v) (set v nil))
      '(w3m-show-graphic-icons-in-header-line
        w3m-show-graphic-icons-in-mode-line
        w3m-track-mouse
        w3m-use-favicon
        w3m-use-toolbar))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;    Nifty things to remember and hopefully use

; M-z zap to char
; C-u C-SPC jump to previous edit
; M-/ autocomplete word 
; M-! insert output of shell command
; M-| replace region with shell output
; M-x thumbs
; C-r k Rectangle kill

; C-x h select all
; C-M-\ indent

; Macros
; C-m C-r to begin
; name it, and do stuff
; C-s to save

; temp macros
; C-m C-m to start recording
; C-m C-s to stop
; C-m C-p to play

; M-C-p, M-C-n back and forward blocks
; C-c C-s irb when in ruby-mode

; C-x n n narrow visibility of buffer to selection
; C-x n w widen to full buffer

; Dired
; mark with 'm', press 'Q' for multi-file find/replace
; C-j launch dired when ido-mode is enabled