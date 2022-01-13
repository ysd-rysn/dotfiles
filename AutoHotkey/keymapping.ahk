#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;Macのショートカットキーを無変換キーで再現

;無変換キーと文字キーで上下左右に移動
vk1D & F::Send,{Blind}{Right}
vk1D & B::Send,{Blind}{Left}
vk1D & P::Send,{Blind}{Up}
vk1D & N::Send,{Blind}{Down}

;無変換キーと文字キーで行頭・行末に移動
vk1D & A::Send,{Blind}{Home}
vk1D & E::Send,{Blind}{End}

;無変換キーと文字キーで文字の削除
vk1D & H::Send,{Blind}{Backspace}
vk1D & D::Send,{Blind}{Delete}

;無変換キーと文字キーで行末まで削除
vk1D & K::Send,{Blind}+{End}{Backspace} 

;無変換キーと文字キーで改行
vk1D & O::Send,{Blind}{Enter}