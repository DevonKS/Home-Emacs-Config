(require 'package)
(add-to-list 'package-archives
	 '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'load-path "/home/devon/.emacs.d/lisp/")
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(ido-enable-flex-matching t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(when (memq window-system '(x mac ns))
    (exec-path-from-shell-initialize))

;; General Setup

;; Powerline
(require 'init-powerline)

;; Line numbers
(linum-relative-global-mode t)
(setq linum-relative-current-symbol "")

;; Backup Files
(setq backup-files-directory "~/Documents/Emacs-Backup")
(setq backup-directory-alist
        `((".*" . ,backup-files-directory)))
(setq auto-save-file-name-transforms
        `((".*" ,backup-files-directory t)))

;; Recent files on start
(recentf-mode 1)
(setq init-open-recentf-interface 'default)
(init-open-recentf)

(setq column-number-mode t)

(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0)
(show-paren-mode t)
(set-default 'truncate-lines t)
(setq truncate-partial-width-windows nil)
(yas-global-mode 1)
(global-flycheck-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(window-numbering-mode t)
(ido-mode t)
(ido-vertical-mode t)

;; Setting frame title to file path
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; General keybindings setup
(global-set-key (kbd "C-x e") 'eval-buffer)
(global-set-key (kbd "C-c /") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "C-x r") 'replace-string)
(global-set-key (kbd "C-c f p") 'flycheck-previous-error)
(global-set-key (kbd "C-c f n") 'flycheck-next-error)
(global-set-key (kbd "C-c j") 'ace-jump-word-mode)
(global-set-key (kbd "C-c C-r") 'recentf-open-files)
(global-set-key (kbd "C-c C-v") 'browse-kill-ring)
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
(global-set-key (kbd "<f8>") 'neotree-toggle)


(global-evil-leader-mode t)
(evil-leader/set-leader ",")
(evil-leader/set-key "e" 'eval-buffer)
(evil-leader/set-key "/" 'comment-or-uncomment-region-or-line)
(evil-leader/set-key "f n" 'flycheck-next-error)
(evil-leader/set-key "f p" 'flycheck-previous-error)
(evil-leader/set-key "j w" 'ace-jump-word-mode)
(evil-leader/set-key "j c" 'ace-jump-char-mode)
(evil-leader/set-key "v" 'split-window-right)
(evil-leader/set-key "b" 'ido-switch-buffer)
(evil-leader/set-key "r f" 'recentf-open-files)
(evil-leader/set-key "p" 'browse-kill-ring)
(evil-leader/set-key "t" 'neotree-toggle)
(evil-leader/set-key "k" 'kill-buffer)
(evil-leader/set-key "m" 'delete-other-windows)
(evil-leader/set-key "r b" 'revert-buffer)


;; Neotree setup
(setq neo-smart-open t)
(add-hook 'neotree-mode-hook
        (lambda ()
            (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
            (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))


(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments current current line or whole lines in region."
  (interactive)
  (save-excursion
    (let (min max)
      (if (region-active-p)
          (setq min (region-beginning) max (region-end))
        (setq min (point) max (point)))
      (comment-or-uncomment-region
       (progn (goto-char min) (line-beginning-position))
       (progn (goto-char max) (line-end-position))))))

(eldoc-in-minibuffer-mode 1)



;; Evil-Mode
(require 'evil)
(evil-mode 1)
(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))
(key-chord-mode t)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(key-chord-define evil-visual-state-map "jk" 'evil-normal-state)
;; Evil-Mode end.

;; Hack to make evil mode colours work in terminal
(defun evil-set-cursor-including-terminal (orig-fn specs)
  (if (display-graphic-p)
      (funcall orig-fn specs)
    (when (= (display-color-cells) 256) ; otherwise messes up tmux under xfce4-terminal
      (pcase specs
        ((and (or `(,colour) `(,colour . ,shape))
              (guard (stringp colour)))
         (send-string-to-terminal (concat "\033]12;" colour "\007")))))))
(advice-add #'evil-set-cursor :around #'evil-set-cursor-including-terminal)


;; Go Setup
(setenv "GOPATH" "/home/devon/development/go")

(setq exec-path (cons "/usr/local/go/bin" exec-path))
(add-to-list 'exec-path (concat (getenv "GOPATH") "/bin"))

;; Navigate to a go file
(defun goto-go-file (filename)
  (interactive "sFilename:")
  (find-name-dired "/home/devon/development/go/src" filename))

(global-set-key (kbd "C-c C-n") 'goto-go-file)
(evil-leader/set-key "o" 'goto-go-file)

(defun my-go-mode-hook ()

  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  
  ; Call Gofmt before saving                                                    
  (add-hook 'before-save-hook 'gofmt-before-save)

  ; Go oracle
  (load-file (concat (getenv "GOPATH") "/src/golang.org/x/tools/cmd/oracle/oracle.el"))
  
  ; Go eldoc
  (go-eldoc-setup)
  
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
	   "go build -v && go test -v && go vet"))

  (with-eval-after-load 'go-mode
    (require 'go-autocomplete))
  
  (add-to-list 'load-path (concat (getenv "GOPATH") "/src/github.com/dougm/goflymake"))
  (require 'go-flycheck)

  ;; Go keybindings setup
  (global-set-key (kbd "C-c g") 'godef-jump)
;;  (global-set-key (kbd "C-c i") 'find impl)
;;  (global-set-key (kbd "C-c m") 'go to memeber)
  (global-set-key (kbd "C-c r") 'go-rename)
;;  (global-set-key (kbd "C-c f") 'fix code/ refactor)
  (global-set-key (kbd "C-c u") 'go-oracle-callers)
  (global-set-key (kbd "C-c p") 'godef-describe)
  (global-set-key (kbd "C-c q") 'godoc)
  (global-set-key (kbd "C-c SPC") 'company-complete)
  (global-set-key (kbd "C-c s") 'go-oracle-set-scope)
  (global-set-key (kbd "C-c b") 'compile)

  (evil-leader/set-key "g" 'godef-jump)
  (evil-leader/set-key "r" 'go-rename)
  (evil-leader/set-key "u" 'go-oracle-callers)
  (evil-leader/set-key "p" 'godef-describe)
  (evil-leader/set-key "q" 'godoc)
  (evil-leader/set-key "." 'company-complete)
  (evil-leader/set-key "b" 'compile)
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)

(add-to-list 'load-path "~/.emacs.d/gosense")
(require 'create-struct)

