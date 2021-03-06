;-*- coding: utf-8 -*-
 
(provide 'swing-keynames)

(defconst GOLD        "GOLD")
(defconst BLUE        "BLUE")
(defconst RED         "RED")
(defconst GREEN       "GREEN")
(defconst GRAY        "GRAY")
(defconst PINK        "PINK")
(defconst BLUE-TAB    "BLUE-TAB")

;;;  Tables translating between logical key names and physical character
;;;  sequences generated by terminal keys.
(defvar               swing-key-nam@table        nil)
(defvar               swing-key-nam@table@sorted nil)
(defvar               swing-key-seq@table        nil)
(define-abbrev-table 'swing-key-seq@table        nil)

(defun swing-register-key-name+seq (seq nam)
  (if (not swing-key-nam@table)
      ;; first key registered
      (setq swing-key-nam@table (list (list seq nam)))
    ;; add to existing keys
    (let ((new t))
      (mapcar (function (lambda (elt)
                          (if (string= seq (car elt))
                              (setq new nil)
                          )
                        )
              )
              swing-key-nam@table
      )
      (if new 
          (progn
            (setq swing-key-nam@table@sorted nil)
            (setq swing-key-nam@table
                  (append swing-key-nam@table (list (list seq nam)))
            )
          )
      )
    )
  )
)

(defun swing-sort-key-nam@table ()
  (if swing-key-nam@table@sorted
      nil
    (setq swing-key-nam@table 
          (sort swing-key-nam@table 
                (function (lambda (x y)
                            (cond ((= (length (car x)) (length (car y)))
                                   (string-lessp (car y) (car x))
                                  ) ; this is just for demonstration
                                  (t
                                   (> (length (car x)) (length (car y)))
                                  )
                            )
                          ) 
                )
          )
    )
    (setq swing-key-nam@table@sorted t)
    (message "Swing-Key-Name table sorted.")
  )
)

(defun swing@key@name (key-seq)
  (let ((key-nam nil) 
        (key-seq-rest "") 
        (len (length key-seq))
       )
    (mapcar (function (lambda (elt)
                        (if (string= (car elt)
                                     (substring key-seq 0
                                                (min (length (car elt)) len)
                                     )
                            )
                            (if (not (stringp key-nam))
                                (progn
                                  (setq key-nam (car (cdr elt)))
                                  (setq key-seq-rest
                                    (substring key-seq (length (car elt)))
                                  )
                                )
                            )
                        )
                      )
            )
            swing-key-nam@table
    )
    (if (stringp key-nam)
        (cons key-nam key-seq-rest)
      (cons t key-seq)
    )
  )
)

(defun lse-key-name (key-seq)
  (interactive "kPress key")
  (if (stringp key-seq)
      (let ((key-nam      nil) 
            (key-seq-rest "") 
            (result       "")
            (i            0) 
            r 
            s
            c
           )
        (swing-sort-key-nam@table)
        (setq r (swing@key@name key-seq))
        (setq key-nam      (car r))
        (setq key-seq-rest (cdr r))
        (if (stringp key-nam)
            (setq result key-nam)
        )
        (if (and (stringp key-seq-rest) (not (string= key-seq-rest "")))
            (progn
              (setq s (swing@key@name key-seq-rest))
              (if (equal key-seq-rest (cdr s))
                  ;; No change by swing@key@name. Use standard Emacs key description
                  (progn
                    (setq key-seq-rest 
                          (emacs-key-description@internal key-seq-rest)
                    )
                    (setq i 0)
                    (setq r "")
                    (while (< i (length key-seq-rest))
                      (setq c (aref key-seq-rest i))
                      (if (not (equal c ? ))
                          (setq r (concat r (char-to-string c)))
                        (if (< (1+ i) (length key-seq-rest))
                            (setq r (concat r "-"))
                        )
                      )
                      (setq i (1+ i))
                    )
                    (setq key-seq-rest r)
                  )
                ;; translate rest of key sequence
                (setq key-seq-rest (lse-key-name key-seq-rest))
              )
            )
        )
        (if (string= result "")
            key-seq-rest
          (if (string= key-seq-rest "")
              result
            (concat result "-" key-seq-rest)
          )
        )
      )
    (emacs-key-description@internal key-seq)
  )
)

(if (not (fboundp 'emacs-key-description@internal))
    (progn
      (fset 'emacs-key-description@internal (symbol-function 'key-description))
      (fset 'key-description                'lse-key-name)
    )
)

(defun swing-define-key-name+seq (nam seq)
  (define-abbrev swing-key-seq@table nam seq)
  (swing-register-key-name+seq       seq nam)
)

(swing-define-key-name+seq "GOLD"         "\eOP")    ; PF1
(swing-define-key-name+seq "BLUE"         "\eOQ")    ; PF2
(swing-define-key-name+seq "RED"          "\e[31~")  ; F17
(swing-define-key-name+seq "GREEN"        "\e[32~")  ; F18
(swing-define-key-name+seq "PINK"         "\e[33~")  ; F19
(swing-define-key-name+seq "GRAY"         "\e[34~")  ; F20
(swing-define-key-name+seq "BLUE-TAB"     "\eOQ\C-i")

(swing-define-key-name+seq "PF1"          "\eOP")
(swing-define-key-name+seq "PF2"          "\eOQ")
(swing-define-key-name+seq "PF3"          "\eOR")
(swing-define-key-name+seq "PF4"          "\eOS")
(swing-define-key-name+seq "KP0"          "\eOp")
(swing-define-key-name+seq "KP1"          "\eOq")
(swing-define-key-name+seq "KP2"          "\eOr")
(swing-define-key-name+seq "KP3"          "\eOs")
(swing-define-key-name+seq "KP4"          "\eOt")
(swing-define-key-name+seq "KP5"          "\eOu")
(swing-define-key-name+seq "KP6"          "\eOv")
(swing-define-key-name+seq "KP7"          "\eOw")
(swing-define-key-name+seq "KP8"          "\eOx")
(swing-define-key-name+seq "KP9"          "\eOy")
(swing-define-key-name+seq "COMMA"        "\eOl")
(swing-define-key-name+seq "MINUS"        "\eOm")
(swing-define-key-name+seq "PERIOD"       "\eOn")
(swing-define-key-name+seq "ENTER"        "\eOM")
(swing-define-key-name+seq "KP,"          "\eOl"); synonym for COMMA
(swing-define-key-name+seq "KP-"          "\eOm"); synonym for MINUS
(swing-define-key-name+seq "KP."          "\eOn"); synonym for PERIOD
(swing-define-key-name+seq "KPE"          "\eOM"); synonym for ENTER

(swing-define-key-name+seq "UP"           "\eOA")
(swing-define-key-name+seq "DOWN"         "\eOB")
(swing-define-key-name+seq "RIGHT"        "\eOC")
(swing-define-key-name+seq "LEFT"         "\eOD")
               
(swing-define-key-name+seq "CSI-UP"       "\e[A")
(swing-define-key-name+seq "CSI-DOWN"     "\e[B")
(swing-define-key-name+seq "CSI-RIGHT"    "\e[C")
(swing-define-key-name+seq "CSI-LEFT"     "\e[D")
               
(swing-define-key-name+seq "E1"           "\e[1~")
(swing-define-key-name+seq "E2"           "\e[2~")
(swing-define-key-name+seq "E3"           "\e[3~")
(swing-define-key-name+seq "E4"           "\e[4~")
(swing-define-key-name+seq "E5"           "\e[5~")
(swing-define-key-name+seq "E6"           "\e[6~")
               
(swing-define-key-name+seq "HELP"         "\e[28~"); synonym for F15
(swing-define-key-name+seq "DO"           "\e[29~"); synonym for F16
(swing-define-key-name+seq "F1"           "\e[11~")
(swing-define-key-name+seq "F2"           "\e[12~")
(swing-define-key-name+seq "F3"           "\e[13~")
(swing-define-key-name+seq "F4"           "\e[14~")
(swing-define-key-name+seq "F5"           "\e[15~")
(swing-define-key-name+seq "F6"           "\e[17~")
(swing-define-key-name+seq "F7"           "\e[18~")
(swing-define-key-name+seq "F8"           "\e[19~")
(swing-define-key-name+seq "F9"           "\e[20~")
(swing-define-key-name+seq "F10"          "\e[21~")
(swing-define-key-name+seq "F11"          "\e[23~")
(swing-define-key-name+seq "F12"          "\e[24~")
(swing-define-key-name+seq "F13"          "\e[25~")
(swing-define-key-name+seq "F14"          "\e[26~")
(swing-define-key-name+seq "F15"          "\e[28~")
(swing-define-key-name+seq "F16"          "\e[29~")
(swing-define-key-name+seq "F17"          "\e[31~")
(swing-define-key-name+seq "F18"          "\e[32~")
(swing-define-key-name+seq "F19"          "\e[33~")
(swing-define-key-name+seq "F20"          "\e[34~")

;;;++
;;; swing-key-seq
;;;     Returns the string sent by terminal when `key' is pressed.
;;;     'key' is either a single character or a string which can assume
;;;     the values:
;;;       PF1 .. PF4                   : function keys of keypad
;;;       KP0 .. KP9                   : numeric  keys of keypad
;;;       COMMA, MINUS, PERIOD, ENTER  : rest          of keypad
;;;       UP, DOWN, LEFT, RIGHT        : cursor keys
;;;       CSI-UP, CSI-DOWN,            : cursor keys (in numeric keypad mode)
;;;       CSI-LEFT, CSI-RIGHT          : ---------------"--------------------
;;;       E1  .. E6                    : keys of minikeypad (above cursor keys)
;;;       F1  .. F20                   : function keys
;;;--
(defun swing-key-seq (key &rest modifier)
  (if (listp (car modifier)) 
      (setq modifier (car modifier))
  )
  (let ((result (if (not (stringp key))
                    (char-to-string key) ; a single character
                  (if (> (length key) 1)
                      (abbrev-expansion (upcase key) swing-key-seq@table) 
                    key ; a single character disguised as string
                  )
                )
       ))
    (if result
        (if (car modifier)
            (concat result (swing-key-seq (car modifier) (cdr modifier)))
          result
        )
      (error "Unknown key-seq `%s' encountered" key)
      nil
    )
  )
)
(fset 'key-seq 'swing-key-seq)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; some test cases
;(message (swing-key-seq BLUE-TAB "period")) 
;(message (swing-key-seq BLUE-TAB ?\C-o)) 
;(message (swing-key-seq BLUE-TAB "\C-o")) 
;(message (swing-key-seq GOLD "A")) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun swing-create-map (map-sym map-name prefix-key &optional in-map)
  (define-prefix-command              map-sym                   )
  (swing-register-key-name+seq        prefix-key     map-name   )
  (define-key (or in-map global-map)  prefix-key     map-sym    )
  (define-key (or in-map global-map)  
                  (concat prefix-key prefix-key)     'undefined )
)

(defun swing-create-sparse-map (map-sym map-name prefix-key &optional in-map)
  (fset                               map-sym        (make-sparse-keymap) )
  (define-key (or in-map global-map)  prefix-key     map-sym              )
  (swing-register-key-name+seq        prefix-key     map-name             )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; example : (swing-create-map 'RED-map "RED" (swing-key-seq "F17"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; Functions for generating keymap descriptions
(defconst swing-describe-key-if-undefined nil)
;;; (setq swing-describe-key-if-undefined nil)

(defvar swing@prefixed@keymaps nil)

(defun swing@insert@key@description (kname binding); (prefix kname binding)
;  (insert (format "%s" prefix))
  (insert (format "%s" kname))
  (indent-to 30)
  (insert (format "%s" binding)) 
  (insert "\n"); (newline)
)

(defun swing@describe@key (map-name key binding)
  (cond ((not binding)
         (if swing-describe-key-if-undefined
             (if (or (string< key "A") (string< "Z" key))
                 (swing@insert@key@description  
                     (lse-key-name (concat map-name key))
                     "* undefined *"
                 )
             )
         )
        )
        ((stringp binding)
         (swing@insert@key@description (lse-key-name (concat map-name key))
                                       (format "Keyboard Macro"); binding
         )
        )
        ((keymapp binding)
         (cond ((vectorp binding)
;                (swing@insert@key@description 
;                    (lse-key-name (concat map-name key) )
;                    (format "Prefix : full  keymap")
;                )
                (lse-add-to-list swing@prefixed@keymaps 
                                   (list binding (concat map-name key))
                )
               )
               ((listp binding)
;                (swing@insert@key@description 
;                    (lse-key-name (concat map-name key))
;                    (format "Prefix : sparse keymap")
;                )
                (lse-add-to-list swing@prefixed@keymaps 
                                   (list binding (concat map-name key))
                )
               )
               (t
;                (swing@insert@key@description
;                    (lse-key-name (concat map-name key))
;                    (format "Prefix : %s (symbol to full keymap)" binding)
;                )
                (lse-add-to-list swing@prefixed@keymaps 
                                   (list binding (concat map-name key))
                )
               )
         )
        )
        ((commandp binding)
         (swing@insert@key@description (lse-key-name (concat map-name key))
                                       (format "Command: %s" binding)
         )
        )
        ((symbolp binding)
         (swing@insert@key@description (lse-key-name (concat map-name key))
                                       (format "Symbol : %s" binding)
         )
        )
        ((listp binding)
         (swing@insert@key@description (lse-key-name (concat map-name key))
                                       "Some kind of list"
         )
        )
        (t
         (swing@insert@key@description (lse-key-name (concat map-name key))
                                       "Something else"
         )
        )
  )
)

(defun swing@describe@full@keymap (map &optional prefix)
  (let ((k -1)
        (map-name (or prefix ""))
        key
        swing@prefixed@keymaps
       )
    (while (< k 127)
      (setq k (1+ k))
      (setq key (char-to-string k))
      (swing@describe@key map-name key (lookup-key map key))
    )
    (mapcar 'swing@describe@prefixed@keymap (reverse swing@prefixed@keymaps))
  )
)

(defun swing@describe@sparse@keymap (map &optional prefix)
  (let ((map-name (or prefix ""))
        (entry    (car map))
        swing@prefixed@keymaps
       )
    (setq map     (cdr map))
    (setq entry   (car map))
    (while (consp entry)
      (swing@describe@key map-name (char-to-string (car entry)) (cdr entry))
      (setq map     (cdr map))
      (setq entry   (car map))
    )
    (mapcar 'swing@describe@prefixed@keymap (reverse swing@prefixed@keymaps))
  )
)

(defun swing@describe@prefixed@-@keymap 
           (swing@describe@-@keymap map &optional prefix)
  (let (swing@prefixed@keymaps)
    (funcall swing@describe@-@keymap map prefix)
    (mapcar 'swing@describe@prefixed@keymap (reverse swing@prefixed@keymaps))
  )
)

(defun swing@describe@prefixed@keymap (x)
  (let ((pmap    (car x))
        (pprefix (car (cdr x)))
       )
    (if (listp pmap)
        (swing@describe@prefixed@-@keymap 
             'swing@describe@sparse@keymap pmap pprefix
        )
      (swing@describe@prefixed@-@keymap 
           'swing@describe@full@keymap pmap pprefix
      )
    )
  )
)

(defun swing@describe@keymap (swing@describe@-@keymap map &optional prefix)
  (save-excursion
    (set-buffer (get-buffer-create "*key-bindings*"))
    (erase-buffer)
    (funcall swing@describe@-@keymap map prefix)
    (goto-char (point-min))
    (replace-regexp "(lambda.*(interactive[^)]*) \\(.\\)*)$" "\\1")
  )
  (lse-message "Keymap description put into buffer *key-bindings*")
)

(defun swing-describe-full-keymap (map &optional prefix)
  (swing@describe@keymap 'swing@describe@full@keymap map prefix)
)

(defun swing-describe-sparse-keymap (map &optional prefix)
  (swing@describe@keymap 'swing@describe@sparse@keymap map prefix)
)

;;; (swing-describe-full-keymap   global-map)
;;; (swing-describe-sparse-keymap (current-local-map))
;;; (swing-describe-sparse-keymap minibuffer-local-ns-map)
;;; (swing-describe-full-keymap   GOLD-map                      (key-seq GOLD))
;;; (swing-describe-full-keymap   'BLUE-map                     (key-seq BLUE))
;;; (swing-describe-full-keymap   'RED-map                      (key-seq RED))
;;; (swing-describe-full-keymap   'ESC-prefix                   "\e")
;;; (swing-describe-full-keymap   'Control-X-prefix             "\^X")
;;; (swing-describe-full-keymap   'mode-specific-command-prefix "\^C")

;;; (setq debug-on-error t)
;;; (setq debug-on-error nil)
