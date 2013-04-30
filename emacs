;;;;;;;;;;;;;;;;;;;;;;;;
;: ben swift's .emacs ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; dotfiles repo: https://github.com/benswift/.dotfiles

;;;;;;;;;;;
;; cedet ;;
;;;;;;;;;;;

;; On Windows (where there's no make), you can install CEDET by 'cd'ing
;; into the directory and running (e.g.)
;; "C:\Program Files (x86)\emacs-24.2\bin\emacs" emacs -Q -l cedet-build.el -f cedet-build

;; Load CEDET.
;; See cedet/common/cedet.info for configuration details.
;; IMPORTANT: For Emacs >= 23.2, you must place this *before* any
;; CEDET component (including EIEIO) gets activated by another
;; package (Gnus, auth-source, ...).
;; (load-file "~/.emacs.d/cedet/cedet-devel-load.el")

;; Add further minor-modes to be enabled by semantic-mode.
;; See doc-string of `semantic-default-submodes' for other things
;; you can use here.
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode t)

;; this one messes with autocomplete?
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode t)

;; Enable Semantic
(semantic-mode 1)

;; customize Semantic
;; (semanticdb-enable-cscope-databases)
(setq semantic-imenu-bucketize-file nil)
(setq semantic-complete-inline-analyzer-idle-displayor-class nil)

;; (require 'semantic/bovine/clang)

(add-hook 'c-mode-common-hook
          '(lambda ()
             (local-set-key (kbd "C-<return>") 'semantic-ia-complete-symbol)
             (local-set-key (kbd "C-c ?") 'semantic-ia-complete-symbol-menu)
             (local-set-key (kbd "C-c >") 'semantic-complete-analyze-inline)
             (local-set-key (kbd "C-c p") 'semantic-analyze-proto-impl-toggle)
             (local-set-key (kbd "C-c j") 'semantic-ia-fast-jump)
             (local-set-key "." 'semantic-complete-self-insert)
             (local-set-key ">" 'semantic-complete-self-insert)))

;; Enable EDE (Project Management) features
(global-ede-mode 1)

(ede-cpp-root-project "Extempore"
                      :name "Extempore"
                      :file "~/Code/extempore/README.md"
                      :web-site-url "http://extempore.moso.com.au"
                      :spp-table '(("TARGET_OS_MAC" . "")))

;;;;;;;;;;
;; elpa ;;
;;;;;;;;;;

(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

(when (null package-archive-contents)
  (package-refresh-contents))

(dolist (p '(auctex
             ess
             gist
             htmlize
             ido-ubiquitous
             iedit
             magit
             markdown-mode
             monokai-theme
             org
             paredit
             scss-mode
             smex
             ttl-mode
             unfill
             yaml-mode
             yasnippet
             yasnippet-bundle))
  (if (not (package-installed-p p))
      (package-install p)))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cross-platform setup ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq ben-home-dir (getenv "HOME"))
(setq source-directory (concat ben-home-dir "/Code/emacs-24.3"))

(defun nix-specific-setup ()
  (setq ben-path (append (list
                          (concat ben-home-dir  "/.rbenv/shims")
                          (concat ben-home-dir  "/bin")
                          "/usr/local/bin" "/usr/bin" "/bin"
                          "/usr/local/sbin" "/usr/sbin" "/sbin"
                          "/usr/X11/bin" "/usr/texbin")
                         ben-path))
  (setenv "PATH" (mapconcat 'identity ben-path ":"))
  (setq exec-path ben-path))

(defun linux-specific-setup ()
  (setq base-face-height 140)
  (setq ben-path '())
  (nix-specific-setup))

(defun osx-specific-setup ()
  (setq base-face-height 160)
  (setq browse-default-macosx-browser "/Applications/Safari.app")
  (setq ben-path '())
  (nix-specific-setup))

(defun windows-specific-setup ()
  (setq base-face-height 160)
  (setq w32-pass-lwindow-to-system nil)
  (setq w32-lwindow-modifier 'super))

(cond ((string-equal system-type "gnu/linux") (linux-specific-setup))
      ((string-equal system-type "darwin") (osx-specific-setup))
      ((string-equal system-type "windows-nt") (windows-specific-setup))
      (t (message "Unknown operating system")))

;;;;;;;;;;;;;;;;;;;
;; customisation ;;
;;;;;;;;;;;;;;;;;;;

(setq custom-file (concat user-emacs-directory "custom.el"))
(if (file-readable-p custom-file)
    (load custom-file))

;;;;;;;;;;
;; smex ;;
;;;;;;;;;;

(setq smex-save-file (concat user-emacs-directory ".smex-items"))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

;;;;;;;;;;;;;;;;
;; one-liners ;;
;;;;;;;;;;;;;;;;

(column-number-mode 1)
(global-auto-revert-mode t)
(setq special-display-regexps nil)
(remove-hook 'text-mode-hook 'smart-spacing-mode)
(setq bidi-display-reordering nil)
(setq ispell-dictionary "en_GB")
(setq recentf-max-saved-items 100)

;;;;;;;;;;;;;;
;; from ESK ;;
;;;;;;;;;;;;;;

(setq save-place t)
(hl-line-mode t)

(setq visible-bell t
      inhibit-startup-message t
      color-theme-is-global t
      sentence-end-double-space nil
      shift-select-mode nil
      mouse-yank-at-point t
      uniquify-buffer-name-style 'forward
      whitespace-style '(face trailing lines-tail tabs)
      whitespace-line-column 80
      ediff-window-setup-function 'ediff-setup-windows-plain
      save-place-file (concat user-emacs-directory "places")
      backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
      diff-switches "-u")

(add-to-list 'safe-local-variable-values '(lexical-binding . t))
(add-to-list 'safe-local-variable-values '(whitespace-line-column . 80))

;; Set this to whatever browser you use
;; (setq browse-url-browser-function 'browse-url-firefox)
;; (setq browse-url-browser-function 'browse-default-macosx-browser)
;; (setq browse-url-browser-function 'browse-default-windows-browser)
;; (setq browse-url-browser-function 'browse-default-kde)
;; (setq browse-url-browser-function 'browse-default-epiphany)
;; (setq browse-url-browser-function 'browse-default-w3m)
;; (setq browse-url-browser-function 'browse-url-generic
;;       browse-url-generic-program "~/src/conkeror/conkeror")

;; Highlight matching parentheses when the point is on them.
(show-paren-mode 1)

;; ido-mode is like magic pixie dust!
(ido-mode t)
(ido-ubiquitous t)
(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-auto-merge-work-directories-length nil
      ido-create-new-buffer 'always
      ido-use-filename-at-point 'guess
      ido-use-virtual-buffers t
      ido-handle-duplicate-virtual-buffers 2
      ido-max-prospects 10)

(set-default 'indent-tabs-mode nil)
(set-default 'indicate-empty-lines t)
(set-default 'imenu-auto-rescan t)

(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook 'turn-on-flyspell)

(define-key lisp-mode-shared-map (kbd "RET") 'reindent-then-newline-and-indent)

(defalias 'yes-or-no-p 'y-or-n-p)

;;;;;;;;;;;;;;;;
;; appearance ;;
;;;;;;;;;;;;;;;;

(load-theme 'monokai t)
(add-to-list 'default-frame-alist '(background-mode . dark))

(set-cursor-color "white")

(dolist (mode '(menu-bar-mode tool-bar-mode scroll-bar-mode))
  (when (fboundp mode) (funcall mode -1)))

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (mouse-wheel-mode t)
  (blink-cursor-mode -1))

;; pretty lambdas

(add-hook 'prog-mode-hook
          '(lambda ()
             (font-lock-add-keywords
              nil `(("(?\\(lambda\\>\\)"
                     (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                               ,(make-char 'greek-iso8859-7 107))
                               nil)))))))

;; buffer-local text size adjustment

(global-set-key (kbd "C-c +") 'text-scale-increase)
(global-set-key (kbd "C-c -") 'text-scale-decrease)

;;;;;;;;;;;;;;;;;;;
;; time and date ;;
;;;;;;;;;;;;;;;;;;;

(setq display-time-string-forms '(day "/" month "  " 24-hours ":" minutes))
(display-time-mode 1)

;;;;;;;;;;;;;;;
;; powerline ;;
;;;;;;;;;;;;;;;

;; a modified version of powerline-default-theme

(defun powerline-ben-theme ()
  (set-face-attribute 'powerline-active1 nil :background "grey40")
  (set-face-attribute 'powerline-active2 nil :background "grey60")
  (setq-default mode-line-format
                '("%e"
                  (:eval
                   (let* ((active (powerline-selected-window-active))
                          (mode-line (if active 'mode-line 'mode-line-inactive))
                          (face1 (if active 'powerline-active1
                                   'powerline-inactive1))
                          (face2 (if active 'powerline-active2
                                   'powerline-inactive2))
                          (lhs (list
                                (powerline-raw "%*" nil 'l)
                                ;; (powerline-buffer-size nil 'l)
                                (powerline-buffer-id nil 'l)

                                (powerline-raw " ")
                                (powerline-arrow-right mode-line face1)

                                (when (boundp 'erc-modified-channels-object)
                                  (powerline-raw erc-modified-channels-object
                                                 face1 'l))

                                (powerline-major-mode face1 'l)
                                (powerline-process face1)
                                ;; (powerline-minor-modes face1 'l)
                                ;; (powerline-narrow face1 'l)

                                (powerline-raw " " face1)
                                (powerline-arrow-right face1 face2)

                                (powerline-vc face2)))
                          (rhs (list
                                (powerline-raw global-mode-string face2 'r)

                                (powerline-arrow-left face2 face1)

                                (powerline-raw "%4l" face1 'r)
                                (powerline-raw ":" face1)
                                (powerline-raw "%3c" face1 'r)

                                (powerline-arrow-left face1 mode-line)
                                (powerline-raw " ")

                                (powerline-raw "%3p" nil 'r)

                                (powerline-hud face2 face1))))
                     (concat
                      (powerline-render lhs)
                      (powerline-fill face2 (powerline-width rhs))
                      (powerline-render rhs)))))))

(powerline-ben-theme)

;;;;;;;;;;;
;; faces ;;
;;;;;;;;;;;

(set-face-attribute 'default nil :height base-face-height :family "Source Code Pro")
(set-face-attribute 'variable-pitch nil :height base-face-height :family "Ubuntu")
(set-face-attribute 'highlight nil :background "#141411")

;; ANSI colors in terminal (based on monokai theme)

(defun ben-set-monokai-term-colors ()
  (set-face-attribute 'term-color-black nil :background "#141411" :foreground "#141411")
  (set-face-attribute 'term-color-blue nil :background "#89BDFF" :foreground "#89BDFF")
  (set-face-attribute 'term-color-cyan nil :background "#A6E22E" :foreground "#A6E22E")
  (set-face-attribute 'term-color-green nil :background "#A6E22A" :foreground "#A6E22A")
  (set-face-attribute 'term-color-magenta nil :background "#FD5FF1" :foreground "#FD5FF1")
  (set-face-attribute 'term-color-red nil :background "#F92672" :foreground "#F92672")
  (set-face-attribute 'term-color-white nil :background "#595959" :foreground "#595959")
  (set-face-attribute 'term-color-yellow nil :background "#E6DB74" :foreground "#E6DB74"))

(add-hook 'term-hook 'ben-set-monokai-term-colors)

;;;;;;;;;;;;;;;;;
;; keybindings ;;
;;;;;;;;;;;;;;;;;

;; handy shortcuts

(global-set-key (kbd "<f5>") 'magit-status)
(global-set-key (kbd "<f6>") 'compile)
(global-set-key (kbd "C-x g") 'find-grep)
(global-set-key (kbd "C-x u") 'find-dired)
(global-set-key (kbd "C-x i") 'imenu)
(global-set-key (kbd "C-;") 'iedit-mode)

;; window navigation

(global-set-key (kbd "s-[")
                (lambda ()
                  (interactive)
                  (other-window -1)))

(global-set-key (kbd "s-]")
                (lambda ()
                  (interactive)
                  (other-window 1)))

(global-set-key (kbd "s-{") 'shrink-window-horizontally)
(global-set-key (kbd "s-}") 'enlarge-window-horizontally)

;; Mac OS X-like

(global-set-key (kbd "s-z") 'undo)

(global-set-key (kbd "<s-left>")
                (lambda ()
                  (interactive)
                  (move-beginning-of-line 1)))

(global-set-key (kbd "<s-right>")
                (lambda ()
                  (interactive)
                  (move-end-of-line 1)))

(global-set-key (kbd "<s-up>")
                (lambda ()
                  (interactive)
                  (goto-char (point-min))))

(global-set-key (kbd "<s-down>")
                (lambda ()
                  (interactive)
                  (goto-char (point-max))))

(global-set-key (kbd "<M-kp-delete>")
                (lambda ()
                  (interactive)
                  (kill-word 1)))

(global-set-key (kbd "<M-backspace>")
                (lambda ()
                  (interactive)
                  (backward-kill-word 1)))

(global-set-key (kbd "<s-backspace>")
                (lambda ()
                  (interactive)
                  (kill-visual-line 0)))

(global-set-key (kbd "<s-kp-delete>")
                (lambda ()
                  (interactive)
                  (kill-visual-line)))

(global-set-key (kbd "<A-backspace>")
                (lambda ()
                  (interactive)
                  (kill-visual-line 0)))

;;;;;;;;;;;;
;; eshell ;;
;;;;;;;;;;;;

(setq eshell-aliases-file "~/.dotfiles/eshell-alias")
(global-set-key (kbd "C-c s") 'eshell)

(setq eshell-cmpl-cycle-completions nil
      eshell-save-history-on-exit t
      eshell-buffer-shorthand t
      eshell-cmpl-dir-ignore "\\`\\(\\.\\.?\\|CVS\\|\\.svn\\|\\.git\\)/\\'")

(defun ben-set-eshell-faces ()
  (set-face-attribute 'eshell-ls-archive nil :foreground nil :inherit 'font-lock-warning-face)
  (set-face-attribute 'eshell-ls-backup nil :foreground nil :inherit 'font-lock-constant-face)
  (set-face-attribute 'eshell-ls-clutter nil :foreground nil :inherit 'font-lock-comment-face)
  (set-face-attribute 'eshell-ls-directory nil :foreground nil :inherit 'font-lock-type-face)
  (set-face-attribute 'eshell-ls-executable nil :foreground nil :inherit 'font-lock-function-name-face)
  (set-face-attribute 'eshell-ls-missing nil :foreground nil :inherit 'font-lock-warning-face)
  (set-face-attribute 'eshell-ls-product nil :foreground nil :inherit 'font-lock-comment-face)
  (set-face-attribute 'eshell-ls-readonly nil :foreground nil :inherit 'font-lock-string-face)
  (set-face-attribute 'eshell-ls-special nil :foreground nil :inherit 'font-lock-keyword-face)
  (set-face-attribute 'eshell-ls-symlink nil :foreground nil :inherit 'font-lock-string-face)
  (set-face-attribute 'eshell-ls-unreadable nil :foreground nil :inherit 'font-lock-comment-face))

(add-hook 'eshell-mode-hook
          '(lambda ()
             ;; environment vars
             (setenv "EDITOR" "export EDITOR=\"emacsclient --alternate-editor=emacs --no-wait\"")
             ;; keybindings
             (define-key eshell-mode-map (kbd "<C-up>") 'eshell-previous-matching-input-from-input)
             (define-key eshell-mode-map (kbd "<C-down>") 'eshell-next-matching-input-from-input)
             (define-key eshell-mode-map (kbd "<up>") 'previous-line)
             (define-key eshell-mode-map (kbd "<down>") 'next-line)
             ;;faces
             (set-face-attribute 'eshell-prompt nil :foreground nil :inherit font-lock-function-name-face)
             (ben-set-eshell-faces)
             ;; prompt helpers
             (setq eshell-directory-name (concat user-emacs-directory "eshell/"))
             (setq eshell-prompt-regexp "^[^@]*@[^ ]* [^ ]* [$#] ")
             (setq eshell-prompt-function
                   (lambda ()
                     (concat (user-login-name) "@" (host-name) " "
                             (base-name (eshell/pwd))
                             (if (= (user-uid) 0) " # " " $ "))))
             ;; helpful bits and pieces
             (turn-on-eldoc-mode)
             (add-to-list 'eshell-command-completions-alist
                          '("gunzip" "gz\\'"))
             (add-to-list 'eshell-command-completions-alist
                          '("tar" "\\(\\.tar|\\.tgz\\|\\.tar\\.gz\\)\\'"))
             (add-to-list 'eshell-visual-commands "ssh")))

(defun base-name (path)
  "Returns the base name of the given path."
  (let ((path (abbreviate-file-name path)))
    (if (string-match "\\(.*\\)/\\(.*\\)$" path)
        (if (= 0 (length (match-string 1 path)))
            (concat "/" (match-string 2 path))
          (match-string 2 path))
      path)))

(defun host-name ()
  "Returns the name of the current host minus the domain."
  (let ((hostname (downcase (system-name))))
    (save-match-data
      (substring hostname
                 (string-match "^[^.]+" hostname)
                 (match-end 0)))))

;;;;;;;;;;;
;; elisp ;;
;;;;;;;;;;;

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)

;;;;;;;;;;;
;; dired ;;
;;;;;;;;;;;

(setq dired-listing-switches "-alh")

;;;;;;;;;;;
;; magit ;;
;;;;;;;;;;;

(setq magit-save-some-buffers nil)

(eval-after-load 'magit
  '(progn
     (set-face-foreground 'magit-diff-add "green4")
     (set-face-foreground 'magit-diff-del "red3")))

;;;;;;;;;;;;;
;; cc-mode ;;
;;;;;;;;;;;;;

;; (setq c-default-style "k&r")

;;;;;;;;;;;;;
;; ebrowse ;;
;;;;;;;;;;;;;

(add-hook 'ebrowse-tree-mode
          '(lambda ()
             (set-face-attribute 'ebrowse-root-class nil :foreground nil :inherit font-lock-type-face)
             (set-face-attribute 'ebrowse-member-class nil :foreground nil :inherit font-lock-function-name-face)
             (set-face-attribute 'ebrowse-member-attribute nil :foreground nil :inherit font-lock-string-face)))

;;;;;;;;;;;;;;
;; org mode ;;
;;;;;;;;;;;;;;

(setq org-completion-use-ido t)

(add-hook 'org-mode-hook
          '(lambda ()
             ;; keymappings
             (define-key org-mode-map (kbd "<M-left>") 'backward-word)
             (define-key org-mode-map (kbd "<M-right>") 'forward-word)
             (define-key org-mode-map (kbd "<C-left>") 'org-metaleft)
             (define-key org-mode-map (kbd "<C-right>") 'org-metaright)
             ;;faces
             (set-face-attribute 'outline-2 nil :inherit font-lock-string-face)
             (set-face-attribute 'outline-3 nil :inherit font-lock-type-face)
             (set-face-attribute 'outline-4 nil :inherit font-lock-keyword-face)
             (set-face-attribute 'outline-5 nil :inherit font-lock-constant-face)
             (set-face-attribute 'outline-6 nil :inherit font-lock-comment-face)))

;;;;;;;;;;;;;;
;; blogging ;;
;;;;;;;;;;;;;;

(setq org-publish-project-alist
      '(("biott-posts"
         ;; Path to your org files.
         :base-directory "~/Documents/biott/org/"
         :base-extension "org"
         :exclude "drafts/*"
         ;; Path to your Jekyll project.
         :publishing-directory "~/Code/octopress/source/"
         :recursive t
         :publishing-function org-publish-org-to-html
         :headline-levels 4
         :html-extension "html"
         :body-only t)
        ("biott-images"
         :base-directory "~/Documents/biott/images/"
         :base-extension "png\\|jpg\\|pdf"
         :publishing-directory "/Users/ben/Code/octopress/source/images/"
         :recursive t
         :publishing-function org-publish-attachment)
        ("biott" :components ("biott-posts" "biott-images"))))

(setq org-export-html-mathjax-options
      '((path "http://orgmode.org/mathjax/MathJax.js")
        (scale "100")
        (align "center")
        (indent "2em")
        (mathml t)))

(defun biott-new-post (post-name)
  (interactive "sPost title: ")
  (find-file (concat "~/Documents/biott/org/_posts/drafts/"
                     (format-time-string "%Y-%m-%d-")
                     (downcase (subst-char-in-string 32 45 post-name))
                     ".org"))
  (insert (concat
           "#+begin_html
---
layout: post
title: \"" post-name "\"
date: " (format-time-string "%Y-%m-%d %R") "
comments: true
categories:
---
#+end_html
")))

;;;;;;;;;
;; erc ;;
;;;;;;;;;

(erc-services-mode 1)
(setq erc-nick "benswift")
(load "~/.dotfiles/secrets/ercpass")
(setq erc-prompt-for-password nil)
(setq erc-prompt-for-nickserv-password nil)
(setq erc-autojoin-channels-alist '(("freenode.net" "#extempore")))

(add-hook 'erc-mode-hook
          '(lambda ()
             ;; faces
             (set-face-attribute 'erc-input-face nil :foreground nil :inherit font-lock-string-face)
             (set-face-attribute 'erc-my-nick-face nil :foreground nil :inherit font-lock-keyword-face)
             (set-face-attribute 'erc-notice-face nil :foreground nil :inherit font-lock-comment-face)))

;;;;;;;;;;;
;; LaTeX ;;
;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.cls" . LaTeX-mode))

(defun ben-latex-setup ()
  (setq TeX-master 't)
  (setq TeX-engine 'xetex)
  (setq TeX-PDF-mode t)
  (setq TeX-auto-untabify t)
  (setq TeX-parse-self t) ; Enable parse on load.
  (setq TeX-auto-save t) ; Enable parse on save.
  (setq TeX-view-program-selection '(output-pdf "Skim"))
  (add-to-list 'TeX-command-list
               '("Biber" "biber %s" TeX-run-Biber nil t :help "Run Biber"))
  (add-to-list 'TeX-command-list
               '("Glossary" "makeglossaries %s" TeX-run-command nil t :help "Create glossaries"))
  (setq ispell-tex-skip-alists
        '((;; in their own commands:
           ("\\\\addcontentsline"                          ispell-tex-arg-end 2)
           ("\\\\add\\(tocontents\\|vspace\\)"             ispell-tex-arg-end)
           ("\\\\\\([aA]lph\\|arabic\\)"                   ispell-tex-arg-end)
           ("\\\\author"                                   ispell-tex-arg-end)
           ("\\\\gls\\(pl\\|reset\\)?"                     ispell-tex-arg-end)
           ("\\\\newacronym"                               ispell-tex-arg-end 2)
           ("\\\\\\(re\\)?newcommand"                      ispell-tex-arg-end 0)
           ("\\\\\\(full\\|text\\|paren\\)cite\\*?"        ispell-tex-arg-end)
           ("\\\\cite\\(t\\|p\\|year\\|yearpar\\|title\\|author\\)" ispell-tex-arg-end)
           ("\\\\bibliographystyle"                        ispell-tex-arg-end)
           ("\\\\\\(block\\|text\\)cquote"                 ispell-tex-arg-end 1)
           ("\\\\c?ref"                                    ispell-tex-arg-end)
           ("\\\\makebox"                                  ispell-tex-arg-end 0)
           ("\\\\e?psfig"                                  ispell-tex-arg-end)
           ("\\\\document\\(class\\|style\\)" .
            "\\\\begin[ \t\n]*{[ \t\n]*document[ \t\n]*}"))
          (;; delimited with \begin
           ("\\(figure\\|table\\)\\*?"                     ispell-tex-arg-end 0)
           ("tabular"                                      ispell-tex-arg-end 1)
           ("tabularx"                                     ispell-tex-arg-end 2)
           ("list"                                         ispell-tex-arg-end 2)
           ("program"             . "\\\\end[ \t\n]*{[ \t\n]*program[ \t\n]*}")
           ("verbatim\\*?"        . "\\\\end[ \t\n]*{[ \t\n]*verbatim\\*?[ \t\n]*}")))))

(defun ben-latex-keybindings ()
  (define-key LaTeX-mode-map (kbd "C-c t") 'switch-to-toc-other-frame)
  (define-key LaTeX-mode-map (kbd "C-c w") 'latex-word-count))

(defun ben-reftex-setup ()
  (turn-on-reftex)
  (setq reftex-default-bibliography '("papers.bib"))
  (setq reftex-enable-partial-scans t)
  (setq reftex-save-parse-info t)
  (setq reftex-use-multiple-selection-buffers t)
  (setq reftex-plug-into-AUCTeX t)
  (setq reftex-cite-prompt-optional-args nil)
  (setq reftex-cite-cleanup-optional-args t)
  ;; RefTeX formats for biblatex (not natbib)
  (setq reftex-cite-format
        '((?\C-m . "\\cite[]{%l}")
          (?t . "\\textcite{%l}")
          (?a . "\\autocite[]{%l}")
          (?p . "\\parencite{%l}")
          (?f . "\\footcite[][]{%l}")
          (?F . "\\fullcite[]{%l}")
          (?x . "[]{%l}")
          (?X . "{%l}")))
  (setq font-latex-match-reference-keywords
        '(("cite" "[{")
          ("cites" "[{}]")
          ("footcite" "[{")
          ("footcites" "[{")
          ("parencite" "[{")
          ("textcite" "[{")
          ("fullcite" "[{")
          ("citetitle" "[{")
          ("citetitles" "[{")
          ("headlessfullcite" "[{"))))

(defun latex-word-count ()
  (interactive)
  (let*
      ((tex-file (if (stringp TeX-master)
                     TeX-master
                   (buffer-file-name)))
       (enc-str (symbol-name buffer-file-coding-system))
       (enc-opt
        (cond
         ((string-match "utf-8" enc-str) "-utf8")
         ((string-match "latin" enc-str) "-latin1")
         ("-encoding=guess")))
       (word-count
        (with-output-to-string
          (with-current-buffer standard-output
            (call-process "texcount" nil t nil "-1" "-merge" enc-opt tex-file)))))
    (message word-count)))

(defun switch-to-toc-other-frame ()
  (interactive)
  (if (not (get-buffer "*toc*"))
      (progn (reftex-toc)
             (delete-window)))
  (switch-to-buffer-other-window "*toc*"))

(add-hook 'LaTeX-mode-hook 'ben-latex-setup)
(add-hook 'LaTeX-mode-hook 'ben-latex-keybindings)
(add-hook 'LaTeX-mode-hook 'ben-reftex-setup)

;; Biber under AUCTeX
(defun TeX-run-Biber (name command file)
  "Create a process for NAME using COMMAND to format FILE with Biber."
  (let ((process (TeX-run-command name command file)))
    (setq TeX-sentinel-function 'TeX-Biber-sentinel)
    (if TeX-process-asynchronous
        process
      (TeX-synchronous-sentinel name file process))))

(defun TeX-Biber-sentinel (process name)
  "Cleanup TeX output buffer after running Biber."
  (goto-char (point-max))
  (cond
   ;; Check whether Biber reports any warnings or errors.
   ((re-search-backward (concat
                         "^(There \\(?:was\\|were\\) \\([0-9]+\\) "
                         "\\(warnings?\\|error messages?\\))") nil t)
    ;; Tell the user their number so that she sees whether the
    ;; situation is getting better or worse.
    (message (concat "Biber finished with %s %s. "
                     "Type `%s' to display output.")
             (match-string 1) (match-string 2)
             (substitute-command-keys
              "\\\\[TeX-recenter-output-buffer]")))
   (t
    (message (concat "Biber finished successfully. "
                     "Run LaTeX again to get citations right."))))
  (setq TeX-command-next TeX-command-default))

;;;;;;;;;;;;;;;
;; extempore ;;
;;;;;;;;;;;;;;;

(setq extempore-path (concat ben-home-dir "/Code/extempore"))
(autoload 'extempore-mode (concat extempore-path "/extras/extempore.el") "" t)
(add-to-list 'auto-mode-alist '("\\.xtm$" . extempore-mode))
(add-to-list 'auto-mode-alist '("\\.xtmh$" . extempore-mode))
(setq extempore-tab-completion nil)
(setq extempore-eldoc-active nil)

(add-hook 'extempore-mode-hook
          '(lambda ()
             (turn-on-eldoc-mode)
             (setq eldoc-documentation-function
                   'extempore-eldoc-documentation-function)))

;; syntax highlighting for LLVM IR files
(load-file (concat extempore-path "/extras/llvm-mode.el"))
(add-to-list 'auto-mode-alist '("\\.ir$" . llvm-mode))

;; session setup

(defun ben-new-xtm-session (name)
  "Set up the directory structure and files for a new extempore session/gig."
  (interactive "sSession name: ")
  (let ((base-path (concat ben-home-dir "/Code/xtm/sessions/" name "/")))
    (make-directory base-path)
    ;; practice files
    (find-file (concat base-path "practice-scm.xtm"))
    (insert ";-*- mode: Extempore; extempore-default-port: 7098; -*-\n")
    (insert (concat "(ipc:load \"primary\" \"" base-path "setup.xtm\")\n"))
    (insert (concat "(load \"" ben-home-dir "/Code/xtm/lib/ben-lib.xtm\")\n"))    (save-buffer)
    (find-file (concat base-path "practice-xtlang.xtm"))
    (insert (concat "(load \"" base-path "setup.xtm\")\n"))
    (save-buffer)
    ;; gig files
    (save-buffer (find-file (concat base-path "gig-scm.xtm")))
    (insert ";-*- mode: Extempore; extempore-default-port: 7098; -*-\n")
    (insert (concat "(ipc:load \"primary\" \"" base-path "setup.xtm\")\n"))
    (insert (concat "(load \"" ben-home-dir "/Code/xtm/lib/ben-lib.xtm\")\n"))    (save-buffer)
    (save-buffer (find-file (concat base-path "gig-xtlang.xtm")))
    (insert (concat "(load \"" base-path "setup.xtm\")\n"))
    (save-buffer)
    ;; setup file
    (find-file (concat base-path "setup" ".xtm"))
    (insert "(load \"libs/core/audio_dsp.xtm\")\n")
    (insert (concat "(load \"" ben-home-dir "/Code/xtm/lib/ben-lib.xtm\")\n"))
    (save-buffer)))

;;;;;;;;;;;;;
;; paredit ;;
;;;;;;;;;;;;;

(defface paredit-paren-face
  '((((class color) (background dark))
     (:foreground "grey50"))
    (((class color) (background light))
     (:foreground "grey55")))
  "Face for parentheses.  Taken from ESK.")

(add-hook 'paredit-mode-hook
          '(lambda ()
             (define-key paredit-mode-map (kbd "<s-left>") 'paredit-backward-up)
             (define-key paredit-mode-map (kbd "<s-S-left>") 'paredit-backward-down)
             (define-key paredit-mode-map (kbd "<s-right>") 'paredit-forward-up)
             (define-key paredit-mode-map (kbd "<s-S-right>") 'paredit-forward-down)
             (define-key paredit-mode-map (kbd "<M-S-up>") 'paredit-raise-sexp)
             (define-key paredit-mode-map (kbd "<M-S-down>") 'paredit-wrap-sexp)
             (define-key paredit-mode-map (kbd "<M-S-left>") 'paredit-convolute-sexp)
             (define-key paredit-mode-map (kbd "<M-S-right>") 'transpose-sexps)))

(dolist (mode '(scheme emacs-lisp lisp clojure clojurescript extempore))
  (when (> (display-color-cells) 8)
    (font-lock-add-keywords (intern (concat (symbol-name mode) "-mode"))
                            '(("(\\|)" . 'paredit-paren-face))))
  (add-hook (intern (concat (symbol-name mode) "-mode-hook"))
            'paredit-mode))

;;;;;;;;;;;;;;
;; markdown ;;
;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.md" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown" . markdown-mode))

;;;;;;;;;;
;; yaml ;;
;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;;;;;;;;;;;;;;;
;; yasnippet ;;
;;;;;;;;;;;;;;;

(setq yas/root-directory "~/.dotfiles/yasnippets")
(yas/load-directory yas/root-directory)
(setq yas/prompt-functions '(yas/ido-prompt
                             yas/dropdown-prompt
                             yas/completing-prompt
                             yas/no-prompt))

;;;;;;;;;;;;;;;;;;
;; autocomplete ;;
;;;;;;;;;;;;;;;;;;

;; autocomplete needs to be set up after yasnippet

(require 'auto-complete-config)

;; (ac-set-trigger-key "<tab>")
(add-to-list 'ac-dictionary-directories (concat ben-home-dir "/.emacs.d/ac-dict"))
(setq ac-auto-start 2)
(ac-config-default)

;; for using Clang autocomplete

;; (require 'auto-complete-clang)

;; (defun my-ac-cc-mode-setup ()
;;   (setq ac-sources (append '(ac-source-clang ac-source-yasnippet ac-source-gtags) ac-sources)))

;; (defun my-ac-config ()
;;   (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
;;   (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
;;   (add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
;;   (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
;;   (add-hook 'css-mode-hook 'ac-css-mode-setup)
;;   (add-hook 'auto-complete-mode-hook 'ac-common-setup)
;;   (global-auto-complete-mode t))

;; (my-ac-config)

;;;;;;;;;
;; git ;;
;;;;;;;;;

(add-to-list 'auto-mode-alist '(".*gitconfig$" . conf-unix-mode))
(add-to-list 'auto-mode-alist '(".*gitignore$" . conf-unix-mode))

;;;;;;;
;; R ;;
;;;;;;;

;; (require 'ess-site)

(add-hook 'ess-mode-hook
          '(lambda()
             (setq-default ess-language "R")
             (setq ess-my-extra-R-function-keywords
                   (read-lines (concat user-emacs-directory
                                       "R-function-names.txt")))
             (setq ess-R-mode-font-lock-keywords
                   (append ess-R-mode-font-lock-keywords
                           (list (cons (concat "\\<" (regexp-opt
                                                      ess-my-extra-R-function-keywords 'enc-paren) "\\>")
                                       'font-lock-function-name-face))))))

;;;;;;;;;;;;;;;;;;;;;;;
;; ttl (Turtle) mode ;;
;;;;;;;;;;;;;;;;;;;;;;;

(autoload 'ttl-mode "ttl-mode" "Major mode for OWL or Turtle files" t)
(add-to-list 'auto-mode-alist '("\\.n3" . ttl-mode))
(add-to-list 'auto-mode-alist '("\\.ttl" . ttl-mode))
(add-hook 'ttl-mode-hook 'turn-on-font-lock)

;;;;;;;;;;;;;;
;; lilypond ;;
;;;;;;;;;;;;;;

(autoload 'LilyPond-mode "lilypond-mode")
(add-to-list 'auto-mode-alist '("\\.ly$" . LilyPond-mode))
(add-hook 'LilyPond-mode-hook 'turn-on-font-lock)

;;;;;;;;;
;; abc ;;
;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.abc\\'"  . abc-mode))
(add-to-list 'auto-mode-alist '("\\.abp\\'"  . abc-mode))
(autoload 'abc-mode "abc-mode" "abc music files" t)

;;;;;;;;;;
;; misc ;;
;;;;;;;;;;

(defun read-lines (fpath)
  "Return a list of lines of a file at at FPATH."
  (with-temp-buffer
    (insert-file-contents fpath)
    (split-string (buffer-string) "\n" t)))

(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))

;; from http://www.emacswiki.org/emacs/CommentingCode
(defun comment-dwim-line (&optional arg)
  "Replacement for the `comment-dwim' command.
If no region is selected and current line is not blank and we are not at the end of the line,
then comment current line.
Replaces default behaviour of `comment-dwim', when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))

(global-set-key (kbd "s-'") 'comment-dwim-line)

;; from
;; http://stackoverflow.com/questions/88399/how-do-i-duplicate-a-whole-line-in-emacs

(defun duplicate-line ()
  "Clone line at cursor, leaving the latter intact."
  (interactive "*")
  (save-excursion
    ;; The last line of the buffer cannot be killed
    ;; if it is empty. Instead, simply add a new line.
    (if (and (eobp) (bolp))
        (newline)
      ;; Otherwise kill the whole line, and yank it back.
      (let ((kill-read-only-ok t)
            deactivate-mark)
        (toggle-read-only 1)
        (kill-whole-line)
        (toggle-read-only 0)
        (yank)))))

(global-set-key (kbd "C-c d") 'duplicate-line)

;;;;;;;;;;;;;;;;;;
;; emacs server ;;
;;;;;;;;;;;;;;;;;;

(server-start)
