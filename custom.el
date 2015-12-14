;;; This file contains some temporary code snippets, it will be loaded after
;;; various oh-my-emacs modules. When you just want to test some code snippets
;;; and don't want to bother with the huge ome.*org files, you can put things
;;; here.

;; For example, oh-my-emacs disables menu-bar-mode by default. If you want it
;; back, just put following code here.
(menu-bar-mode t)

;;; You email address
(setq user-mail-address "xiaohanyu1988@gmail.com")

;;; Calendar settings
;; you can use M-x sunrise-sunset to get the sun time
(setq calendar-latitude 39.9)
(setq calendar-longitude 116.3)
(setq calendar-location-name "Beijing, China")

;;; Time related settings
;; show time in 24hours format
(setq display-time-24hr-format t)
;; show time and date
(setq display-time-and-date t)
;; time change interval
(setq display-time-interval 10)
;; show time
(display-time-mode t)

;;; Some tiny tool functions
(defun replace-all-chinese-quote ()
  (interactive)
  (save-excursion
    (mark-whole-buffer)
    (replace-regexp  "”\\|“" "\"")
    (mark-whole-buffer)
    (replace-regexp "’\\|‘" "'")))

;; Comment function for GAS assembly language
(defun gas-comment-region (start end)
  "Comment region for AT&T syntax assembly language The default
comment-char for gas is ';', we need '#' instead"
  (interactive "r")
  (setq end (copy-marker end t))
  (save-excursion
    (goto-char start)
    (while (< (point) end)
      (beginning-of-line)
      (insert "# ")
      (next-line))
    (goto-char end)))

(defun gas-uncomment-region (start end)
  "Uncomment region for AT&T syntax assembly language the
inversion of gas-comment-region"
  (interactive "r")
  (setq end (copy-marker end t))
  (save-excursion
    (goto-char start)
    (while (< (point) end)
      (beginning-of-line)
      (if (equal (char-after) ?#)
          (delete-char 1))
      (next-line))
    (goto-char end)))

(defun cl-struct-define (name docstring parent type named slots children-sym
                              tag print-auto)
  (cl-assert (or type (equal '(cl-tag-slot) (car slots))))
  (cl-assert (or type (not named)))
  (if (boundp children-sym)
      (add-to-list children-sym tag)
    (set children-sym (list tag)))
  (let* ((parent-class parent))
    (while parent-class
      (add-to-list (intern (format "cl-struct-%s-tags" parent-class)) tag)
      (setq parent-class (get parent-class 'cl-struct-include))))
  ;; If the cl-generic support, we need to be able to check
  ;; if a vector is a cl-struct object, without knowing its particular type.
  ;; So we use the (otherwise) unused function slots of the tag symbol
  ;; to put a special witness value, to make the check easy and reliable.
  (unless named (fset tag :quick-object-witness-check))
  (put name 'cl-struct-slots slots)
  (put name 'cl-struct-type (list type named))
  (if parent (put name 'cl-struct-include parent))
  (if print-auto (put name 'cl-struct-print print-auto))
  (if docstring (put name 'structure-documentation docstring)))

;;; 个人设置
;;; neotree etc
(add-to-list 'load-path "/home/dlls/.emacs.d/el-get/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
;;; neotree evil
(add-hook 'neotree-mode-hook
          (lambda ()
             (define-key evil-normal-state-local-map (kbd "o") 'neotree-enter)
             (define-key evil-normal-state-local-map (kbd "r") 'neotree-refresh)
             (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
             (define-key evil-normal-state-local-map (kbd "k") 'neotree-previous-node)
             (define-key evil-normal-state-local-map (kbd "u") 'neo-buffer--change-root )
             (define-key evil-normal-state-local-map (kbd "p") 'neotree-hidden-file-toggle)
             (define-key evil-normal-state-local-map (kbd "R") 'neotree-change-root)
             (define-key evil-normal-state-local-map (kbd "P") 'neotree-stretch-toggle)))

;;; switch-window
(global-set-key (kbd "C-x o") 'switch-window)


;;; 0blayout init
;;; bash-completion
;;; evil-easymotion
(evilem-default-keybindings ",")

;;; 相对行号中当前行显示绝对行号
(setq linum-relative-current-symbol "")

;;; evil-nred-commenter 快速注释
(evilnc-default-hotkeys)


;;; 调整窗口大小
(global-set-key (kbd "<S-up>") 'shrink-window)
(global-set-key (kbd "<S-down>") 'enlarge-window)
(global-set-key (kbd "<S-right>") 'shrink-window-horizontally)
(global-set-key (kbd "<S-left>") 'enlarge-window-horizontally)

;;; 初始窗口不显示文字
(setq initial-scratch-message nil)

;;; pyenv config
(pyvenv-activate "~/.pyenv/versions/2.7.10")
(defalias 'workon 'pyvenv-workon)

;;; jedi
; (setq elpy-rpc-backend "jedi")

(add-hook 'python-mode-hook 'jedi:setup)
; (add-hook 'python-mode-hook 'auto-complete-mode)

(setq jedi:complete-on-dot t)
(setq auto-complete-mode t)

;;; jedi doc太长的处理， TODO
(defadvice popup-menu-show-quick-help
           (around pos-tip-popup-menu-show-quick-help () activate)
           "Show quick help using `pos-tip-show'."
           (if (eq window-system 'x)
             (let ((doc (popup-menu-document
                          menu (or item
                                   (popup-selected-item menu)))))
               (when (stringp doc)
                 (pos-tip-show doc nil
                               (if (popup-hidden-p menu)
                                 (or (plist-get args :point)
                                     (point))
                                 (overlay-end (popup-line-overlay
                                                menu (+ (popup-offset menu)
                                                        (popup-selected-line menu)))))
                               nil 0)
                 nil))
             ad-do-it))

; (add-hook 'after-init-hook 'global-company-mode)
; (add-hook 'after-init-hook 'auto-complete-mode)
; (defcustom complete-in-region-use-popup nil
           ; "If non-NIL, complete-in-region will popup a menu with the possible completions."
           ; :type 'boolean
           ; :group 'completion)
; (autoload 'popup-menu* "popup" "Show a popup menu" nil)

; (defun popup-complete-in-region (next-func start end collection &optional predicate)
  ; (if (not complete-in-region-use-popup)
    ; (funcall next-func start end collection predicate)
    ; (let* ((prefix (buffer-substring start end))
           ; (completion (try-completion prefix collection predicate))
           ; (choice (and (stringp completion)
                        ; (string= completion prefix)
                        ; (popup-menu* (all-completions prefix collection predicate))))
           ; (replacement (or choice completion))
           ; (tail (and (stringp replacement)
                      ; (not (string= prefix replacement))
                      ; (substring replacement (- end start)))))
      ; (cond ((eq completion t)
             ; (goto-char end)
             ; (message "Sole completion")
             ; nil)
            ; ((null completion)
             ; (message "No match")
             ; nil)
            ; (tail
              ; (goto-char end)
              ; (insert tail)
              ; t)
            ; (choice
              ; (message "Nothing to do")
              ; nil)
            ; (t
              ; (message "completion: something failed!")
              ; (funcall next-func start end collection predicate))))))
; (add-hook 'completion-in-region-functions 'popup-complete-in-region)
; (provide 'popup-complete)
