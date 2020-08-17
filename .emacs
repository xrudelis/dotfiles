  (setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
               ("melpa" . "https://melpa.org/packages/")
               ("org" . "http://orgmode.org/elpa/")))
  (package-initialize)

;; if you find a community package you want, it's just (use-package packagename)
  (unless (package-installed-p 'use-package)
    (progn
      (unless package-archive-contents
    (package-refresh-contents))
      (package-install 'use-package)))

;; indentation commands		
(defun shift-text (distance)
  (if (use-region-p)
      (let ((mark (mark)))
        (save-excursion
          (indent-rigidly (region-beginning)
                          (region-end)
                          distance)
          (push-mark mark t t)
          (setq deactivate-mark nil)))
    (indent-rigidly (line-beginning-position)
                    (line-end-position)
                    distance)))
(defun shift-right (count)
  (interactive)
  (shift-text count))
(defun shift-left (count)
  (interactive)
  (shift-text (- count)))

;; Cut command

(defun cut-line-or-region ()
  (interactive)
  (if current-prefix-arg
      kill-region
    (progn (if (use-region-p)
               (kill-region (region-beginning) (region-end) t)
             (kill-region (line-beginning-position) (line-beginning-position 2))))))

;; Rebind prefixes, see: https://www.reddit.com/r/emacs/comments/4k5gu3/can_i_reliably_remap_the_cc_and_cx_prefixes/
; What previously was C-c now requires C-t, what previously was C-x requires C-r
(global-set-key (kbd "C-t") 'mode-specific-command-prefix)
(global-set-key (kbd "C-r") 'Control-X-prefix)

;; Key bindings

(global-set-key (kbd "C-q") 'save-buffers-kill-terminal) ; close all

(global-set-key (kbd "C-s") 'save-buffer) ; save file
(global-set-key (kbd "C-o") 'find-file) ; open file

(global-set-key (kbd "C-n") (lambda () (interactive) (other-window 1))) ; next window
(global-set-key (kbd "C-p") (lambda () (interactive) (other-window -1))) ; previous window
(global-set-key (kbd "C-w") 'delete-window) ; close window

(global-set-key (kbd "C-f") 'isearch-forward)
(global-set-key (kbd "C-M-f") 'isearch-backward)

(global-set-key (kbd "C-z") 'undo) ; undo
(global-set-key (kbd "C-x") 'cut-line-or-region)
(global-set-key (kbd "C-c") 'kill-ring-save) ; copy
(global-set-key (kbd "C-v") 'yank) ; paste

(global-set-key (kbd "C-i") (lambda () (interactive) (shift-right 4))) ; indent once
(global-set-key (kbd "C-u") (lambda () (interactive) (shift-left 4))) ; unindent once

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

;; All settings clicked in the Options menu are saved here by Emacs.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(display-battery-mode t)
 '(display-time-24hr-format t)
 '(display-time-day-and-date nil)
 '(display-time-default-load-average nil)
 '(display-time-mail-file (quote none))
 '(display-time-mode t)
 '(display-line-numbers-mode t)
 '(indicate-buffer-boundaries (quote ((t . right) (top . left))))
 '(indicate-empty-lines t)
 '(package-selected-packages (quote (use-package)))
 '(save-place t nil (saveplace))
 '(scroll-bar-mode (quote right))
 '(show-paren-mode t)
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
