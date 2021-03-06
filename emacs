;; -*- mode: emacs-lisp -*-
(tool-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode)
(show-paren-mode)

(unless window-system
  (menu-bar-mode -1))

(when (memq window-system '(mac ns))
  (set-frame-font "Monaco")
  (set-frame-size (selected-frame) 100 55))

(setq inhibit-startup-message t
      initial-scratch-message nil
      mac-option-modifier nil
      mac-command-modifier 'meta
      vc-follow-symlinks t
      ring-bell-function 'ignore)

(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-.") 'kill-region)
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-x C-m") 'execute-extended-command)
(global-set-key (kbd "RET") 'newline-and-indent)

(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(require 'cl-lib)
(defvar package-list
  '(rainbow-mode
    solarized-theme
    exec-path-from-shell
    evil
    evil-leader
    helm
    key-chord
    flycheck
    jedi))

(defun list-uninstalled-packages ()
  (cl-remove-if #'package-installed-p package-list))

(let ((uninstalled-packages (list-uninstalled-packages)))
  (when uninstalled-packages
    (package-refresh-contents)
    (mapcar #'package-install uninstalled-packages)))

(load-theme 'solarized-dark t)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(global-evil-leader-mode)
(evil-mode)
(setq key-chord-two-keys-delay 0.5)
(define-key evil-normal-state-map (kbd "C-h") 'windmove-left)
(define-key evil-normal-state-map (kbd "C-l") 'windmove-right)
(define-key evil-normal-state-map (kbd "C-k") 'windmove-up)
(define-key evil-normal-state-map (kbd "C-j") 'windmove-down)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-define evil-normal-state-map ",," 'evil-buffer)
(key-chord-mode 1)
(evil-leader/set-leader ",")
(evil-leader/set-key
  "w" 'save-buffer
  "o" 'delete-other-windows)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(require 'dired-x)
(add-to-list 'dired-omit-extensions ".pyc")
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

(load (expand-file-name "~/quicklisp/slime-helper.el"))
;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "sbcl")
