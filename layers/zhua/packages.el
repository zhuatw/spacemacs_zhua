;;; packages.el --- zhua Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq zhua-packages
    '(
      ;; package names go here
      ace-window
      helm-github-stars
      org-tree-slide
      swiper
      chinese-fonts-setup
      youdao-dictionary
      ))
;; List of packages to exclude.
(setq zhua-excluded-packages '())
;; For each package, define a function zhua/init-<package-name>
;;
;; (defun zhua/init-my-package ()
;;   "Initialize my package"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package

;;$$$$$$$$$zhua_test
(defun zhua/post-init-ace-window ()
  (use-package ace-window
    :defer t
    :init
    (global-set-key (kbd "C-x C-o") #'ace-window)))

(defun zhua/init-helm-github-stars ()
  (use-package helm-github-stars
    :defer t
    :config
    (progn
      (setq helm-github-stars-username "zhuatw")
      (setq helm-github-stars-cache-file "~/.emacs.d/.cache/hgs-cache"))))

(defun zhua/init-org-tree-slide ()
  (use-package org-tree-slide
    :init
    (evil-leader/set-key "oto" 'org-tree-slide-mode)))

(defun zhua/init-youdao-dictionary ()
  (use-package youdao-dictionary
    :init
    (progn
      (setq url-automatic-caching t)
      (global-set-key (kbd "<f7>") 'youdao-dictionary-play-voice-at-point)
      (global-set-key (kbd "<f8>") 'youdao-dictionary-search-at-point+)
      (global-set-key (kbd "<f9>") 'youdao-dictionary-play-audacity-at-point)
      ;; Set file path for saving search history
      (setq youdao-dictionary-search-history-file "~/.emacs.d/.youdao")
      ;; Enable Chinese word segmentation support (支持中文分词)
      (setq youdao-dictionary-use-chinese-word-segmentation t)
      )))


(defun zhua/init-chinese-fonts-setup()
  (use-package chinese-fonts-setup
    :init
    (progn
      )))

(defun zhua/init-swiper ()
  "Initialize my package"
  (use-package swiper
    :init
    (progn
      (setq ivy-display-style 'fancy)

      (defun counsel-git-grep-function (string &optional _pred &rest _u)
        "Grep in the current git repository for STRING."
        (split-string
         (shell-command-to-string
          (format
           "git --no-pager grep --full-name -n --no-color -i -e \"%s\""
           string))
         "\n"
         t))

      (defun counsel-git-grep ()
        "Grep for a string in the current git repository."
        (interactive)
        (let ((default-directory (locate-dominating-file
                                  default-directory ".git"))
              (val (ivy-read "pattern: " 'counsel-git-grep-function))
              lst)
          (when val
            (setq lst (split-string val ":"))
            (find-file (car lst))
            (goto-char (point-min))
            (forward-line (1- (string-to-number (cadr lst)))))))
      (use-package ivy
        :defer t
        :config
        (progn
          (define-key ivy-minibuffer-map (kbd "C-j") 'ivy-next-line)
          (define-key ivy-minibuffer-map (kbd "C-k") 'ivy-previous-line)))

      (define-key global-map (kbd "C-s") 'swiper)
      (setq ivy-use-virtual-buffers t)
      (global-set-key (kbd "C-c C-r") 'ivy-resume)
      (global-set-key (kbd "C-c j") 'counsel-git-grep))))
