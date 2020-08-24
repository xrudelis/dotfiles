(setq package-archives
  '(
    ("gnu" . "https://elpa.gnu.org/packages/")
    ("melpa" . "https://melpa.org/packages/")
    ("org" . "http://orgmode.org/elpa/")
  )
)
(package-initialize)

;; if you find a community package you want, it's just (use-package packagename)
(unless (package-installed-p 'use-package)
  (progn
    (unless package-archive-contents (package-refresh-contents))
    (package-install 'use-package)
  )
)

; this tells use-package to always install the package by default if it is missing
(require 'use-package-ensure)
(setq use-package-always-ensure t)

; for undo AND redo
(use-package undo-tree)
(global-undo-tree-mode)

;; indentation

(setq-default indent-tabs-mode nil)

(setq tab-space-width 2)
(setq-default python-indent-offset tab-space-width)
(setq-default c-basic-offset tab-space-width)

(setq-default tab-always-indent nil)

(setq-default electric-indent-inhibit t)
(setq backward-delete-char-untabify-method 'hungry)

(defun shift-text (distance)
  (if (use-region-p)
    (let ((mark (mark))
	  (beg (save-excursion (goto-char (region-beginning))
                               (line-beginning-position)))
          (end (region-end))
         )
      (save-excursion
        (indent-rigidly beg end distance)
        (push-mark mark t t)
        (setq deactivate-mark nil)
      )
    )
    ; else, no region selected
    (progn
      ; todo: behavior if before smarthome, want to move cursor to smarthome?
      (indent-rigidly (line-beginning-position) (line-end-position) distance)
    )
  )
)

(defun shift-right (count)
  (interactive)
  (shift-text count)
)

(defun shift-left (count)
  (interactive)
  (shift-text (- count))
)

;; Cut command

(defun cut-line-or-region ()
  (interactive)
  (if current-prefix-arg
      kill-region
    (progn (if (use-region-p)
               (kill-region (region-beginning) (region-end) t)
             (kill-region (line-beginning-position) (line-beginning-position 2))))))

;; Copy command

(defun copy-line-or-region ()
  (interactive)
  (if (use-region-p) (copy-region-as-kill (region-beginning) (region-end))
    (progn
      (let ((beg (line-beginning-position 1))
          (end (line-beginning-position 2)))
        (if (eq last-command 'copy-line-or-region)
          (kill-append (buffer-substring beg end) (< end beg))
          (kill-new (buffer-substring beg end))
        )
      )
      (beginning-of-line 2)
    )
  )
)

;; Delete command

(defun delete-line-or-region ()
  (interactive)
  (if (use-region-p)
    (delete-region (region-beginning) (region-end))
    (delete-region (line-beginning-position 1) (line-beginning-position 2))
  )
)

;; Toggle mark

(defun toggle-mark ()
  (interactive)
  (if (use-region-p)
      (keyboard-quit)
    (set-mark-command nil)
    )
  )

;; Nano mode
(define-minor-mode nano-mode "Behave like my GNU Nano config"
  :lighter " Nano" ; mode display name
  :global t ; apply to all buffers
  :init-value t

  :keymap (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-X") 'Control-X-prefix) ; for C-x
    (define-key map (kbd "C-C") 'mode-specific-command-prefix) ; for C-c

    (define-key map (kbd "C-q") 'save-buffers-kill-terminal) ; close all
    (define-key map (kbd "C-s") 'save-buffer) ; save file
    (define-key map (kbd "C-o") 'find-file) ; open file

    ; Window navigation
    (define-key map (kbd "C-n") (lambda () (interactive) (other-window 1))) ; next window
    (define-key map (kbd "C-p") (lambda () (interactive) (other-window -1))) ; prev window
    (define-key map (kbd "C-w") 'delete-window) ; close window

    (define-key map (kbd "C-f") 'isearch-forward) ;
    (define-key map (kbd "C-b") 'isearch-backward) ;
    (define-key map (kbd "C-r") 'query-replace-regexp)

    ;(define-key map (kbd "C-z") '(lambda () (interactive) (undo-tree))) ;
    ;(define-key map (kbd "C-y") '(lambda () (interactive) (redo-tree))) ;
    (define-key map (kbd "C-z") 'undo-tree-undo) ;
    (define-key map (kbd "C-y") 'undo-tree-redo)
    (define-key map (kbd "C-x") 'cut-line-or-region)
    (define-key map (kbd "C-c") 'copy-line-or-region)
    (define-key map (kbd "C-v") 'yank) ;
    (define-key map (kbd "C-k") 'delete-line-or-region)

    (define-key map (kbd "C-i") (lambda () (interactive) (shift-right tab-space-width))) ;
    (define-key map (kbd "C-u") (lambda () (interactive) (shift-left tab-space-width))) ;

    ; Text navigation
    (define-key map (kbd "C-a") 'back-to-indentation) ; "smart home"
    (define-key map (kbd "C-SPC") 'toggle-mark)
    (define-key map (kbd "C-l") 'goto-line)

    map
  )
)
(defvar nano-mode-hook nil)

;; Commenting

(defun select-current-line ()
  "Select the current line"
  (interactive)
 (beginning-of-line) ; move to end of line
  (set-mark (line-end-position)))

(defun comment-or-uncomment-line-or-region ()
  "comment-or-uncomment-line-or-region"
  (interactive)
(save-excursion (if (region-active-p) (comment-dwim nil)
  (select-current-line) (comment-dwim nil)
  )))

(global-set-key (kbd "C-3") 'comment-or-uncomment-line-or-region)

;; scrolling behavior, see https://www.emacswiki.org/emacs/SmoothScrolling

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
    (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
    (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
    (setq scroll-step 1) ;; keyboard scroll one line at a time

;; system clipboard
(setq x-select-enable-clipboard t)

;; replace highlighted text with what I type rather than just inserting at point
(delete-selection-mode t)

;; truncate long lines
(setq-default truncate-lines t)

;; All settings clicked in the Options menu are saved here by Emacs.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(display-battery-mode t)
 '(display-line-numbers-mode t)
 '(display-time-24hr-format t)
 '(display-time-day-and-date nil)
 '(display-time-default-load-average nil)
 '(display-time-mail-file 'none)
 '(display-time-mode t)
 '(indicate-buffer-boundaries '((t . right) (top . left)))
 '(indicate-empty-lines t)
 '(package-selected-packages '(use-package))
 '(save-place t nil (saveplace))
 '(scroll-bar-mode 'right)
 '(show-paren-mode t)
 '(text-mode-hook '(turn-on-auto-fill text-mode-hook-identify))
 '(uniquify-buffer-name-style 'forward nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
