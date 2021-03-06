; <COMPILER: v1.1.33.06>
Class RichEdit {
Static Class := "RICHEDIT50W"
Static DLL := "Msftedit.dll"
Static Instance := DllCall("Kernel32.dll\LoadLibrary", "Str", RichEdit.DLL, "UPtr")
Static SubclassCB := 0
Static Controls := 0
GuiName := ""
GuiHwnd := ""
HWND := ""
DefFont := ""
__New(GuiName, Options, MultiLine := True) {
Static WS_TABSTOP := 0x10000, WS_HSCROLL := 0x100000, WS_VSCROLL := 0x200000, WS_VISIBLE := 0x10000000
, WS_CHILD := 0x40000000
, WS_EX_CLIENTEDGE := 0x200, WS_EX_STATICEDGE := 0x20000
, ES_MULTILINE := 0x0004, ES_AUTOVSCROLL := 0x40, ES_AUTOHSCROLL := 0x80, ES_NOHIDESEL := 0x0100
, ES_WANTRETURN := 0x1000, ES_DISABLENOSCROLL := 0x2000, ES_SUNKEN := 0x4000, ES_SAVESEL := 0x8000
, ES_SELECTIONBAR := 0x1000000
If !(SubStr(A_AhkVersion, 1, 1) > 1) && !(A_IsUnicode) {
MsgBox, 16, % A_ThisFunc, % This.__Class . " requires a unicode version of AHK!"
Return False
}
If (This.Base.HWND)
Return False
Gui, %GuiName%:+LastFoundExist
GuiHwnd := WinExist()
If !(GuiHwnd) {
ErrorLevel := "ERROR: Gui " . GuiName . " does not exist!"
Return False
}
If (This.Base.Instance = 0) {
This.Base.Instance := DllCall("Kernel32.dll\LoadLibrary", "Str", This.Base.DLL, "UPtr")
If (ErrorLevel) {
ErrorLevel := "ERROR: Error loading " . This.Base.DLL . " - " . ErrorLevel
Return False
}
}
Styles := WS_TABSTOP | WS_VISIBLE | WS_CHILD | ES_AUTOHSCROLL
If (MultiLine)
Styles |= WS_HSCROLL | WS_VSCROLL | ES_MULTILINE | ES_AUTOVSCROLL | ES_NOHIDESEL | ES_WANTRETURN
| ES_DISABLENOSCROLL | ES_SAVESEL
ExStyles := WS_EX_STATICEDGE
CtrlClass := This.Class
Gui, %GuiName%:Add, Custom, Class%CtrlClass% %Options% hwndHWND +%Styles% +E%ExStyles%
If (MultiLine) {
VarSetCapacity(RECT, 16, 0)
SendMessage, 0xB2, 0, &RECT, , ahk_id %HWND%
NumPut(NumGet(RECT, 0, "Int") + 10, RECT, 0, "Int")
NumPut(NumGet(RECT, 4, "Int") + 2,  RECT, 4, "Int")
SendMessage, 0xB3, 0, &RECT, , ahk_id %HWND%
SendMessage, 0x04CA, 0x01, 0x01, , ahk_id %HWND%
}
SendMessage, 0x0478, 0, 0x03, , ahk_id %HWND%
If (This.Base.SubclassCB = 0)
This.Base.SubclassCB := RegisterCallback("RichEdit.SubclassProc")
DllCall("Comctl32.dll\SetWindowSubclass", "Ptr", HWND, "Ptr", This.Base.SubclassCB, "Ptr", HWND, "Ptr", 0)
This.GuiName := GuiName
This.GuiHwnd := GuiHwnd
This.HWND := HWND
This.DefFont := This.GetFont(1)
This.DefFont.Default := 1
If (Round(This.DefFont.Size) <> This.DefFont.Size) {
This.DefFont.Size := Round(This.DefFont.Size)
This.SetDefaultFont()
}
This.Base.Controls += 1
This.GetMargins()
This.LimitText(2147483647)
}
__Delete() {
If (This.HWND) {
DllCall("Comctl32.dll\RemoveWindowSubclass", "Ptr", This.HWND, "Ptr", This.Base.SubclassCB, "Ptr", 0)
DllCall("User32.dll\DestroyWindow", "Ptr", This.HWND)
This.HWND := 0
This.Base.Controls -= 1
If (This.Base.Controls = 0) {
DllCall("Kernel32.dll\FreeLibrary", "Ptr", This.Base.Instance)
This.Base.Instance := 0
}
}
}
Class CF2 {
__New() {
Static CF2_Size := 116
This.Insert(":", {Mask: {O: 4, T: "UInt"}, Effects: {O: 8, T: "UInt"}
, Height: {O: 12, T: "Int"}, Offset: {O: 16, T: "Int"}
, TextColor: {O: 20, T: "Int"}, CharSet: {O: 24, T: "UChar"}
, PitchAndFamily: {O: 25, T: "UChar"}, FaceName: {O: 26, T: "Str32"}
, Weight: {O: 90, T: "UShort"}, Spacing: {O: 92, T: "Short"}
, BackColor: {O: 96, T: "UInt"}, LCID: {O: 100, T: "UInt"}
, Cookie: {O: 104, T: "UInt"}, Style: {O: 108, T: "Short"}
, Kerning: {O: 110, T: "UShort"}, UnderlineType: {O: 112, T: "UChar"}
, Animation: {O: 113, T: "UChar"}, RevAuthor: {O: 114, T: "UChar"}
, UnderlineColor: {O: 115, T: "UChar"}})
This.Insert(".")
This.SetCapacity(".", CF2_Size)
Addr :=  This.GetAddress(".")
DllCall("Kernel32.dll\RtlZeroMemory", "Ptr", Addr, "Ptr", CF2_Size)
NumPut(CF2_Size, Addr + 0, 0, "UInt")
}
__Get(Name) {
Addr := This.GetAddress(".")
If (Name = "CF2")
Return Addr
If !This[":"].HasKey(Name)
Return ""
Attr := This[":"][Name]
If (Name <> "FaceName")
Return NumGet(Addr + 0, Attr.O, Attr.T)
Return StrGet(Addr + Attr.O, 32)
}
__Set(Name, Value) {
Addr := This.GetAddress(".")
If !This[":"].HasKey(Name)
Return ""
Attr := This[":"][Name]
If (Name <> "FaceName")
NumPut(Value, Addr + 0, Attr.O, Attr.T)
Else
StrPut(Value, Addr + Attr.O, 32)
Return Value
}
}
Class PF2 {
__New() {
Static PF2_Size := 188
This.Insert(":", {Mask: {O: 4, T: "UInt"}, Numbering: {O: 8, T: "UShort"}
, StartIndent: {O: 12, T: "Int"}, RightIndent: {O: 16, T: "Int"}
, Offset: {O: 20, T: "Int"}, Alignment: {O: 24, T: "UShort"}
, TabCount: {O: 26, T: "UShort"}, Tabs: {O: 28, T: "UInt"}
, SpaceBefore: {O: 156, T: "Int"}, SpaceAfter: {O: 160, T: "Int"}
, LineSpacing: {O: 164, T: "Int"}, Style: {O: 168, T: "Short"}
, LineSpacingRule: {O: 170, T: "UChar"}, OutlineLevel: {O: 171, T: "UChar"}
, ShadingWeight: {O: 172, T: "UShort"}, ShadingStyle: {O: 174, T: "UShort"}
, NumberingStart: {O: 176, T: "UShort"}, NumberingStyle: {O: 178, T: "UShort"}
, NumberingTab: {O: 180, T: "UShort"}, BorderSpace: {O: 182, T: "UShort"}
, BorderWidth: {O: 184, T: "UShort"}, Borders: {O: 186, T: "UShort"}})
This.Insert(".")
This.SetCapacity(".", PF2_Size)
Addr :=  This.GetAddress(".")
DllCall("Kernel32.dll\RtlZeroMemory", "Ptr", Addr, "Ptr", PF2_Size)
NumPut(PF2_Size, Addr + 0, 0, "UInt")
}
__Get(Name) {
Addr := This.GetAddress(".")
If (Name = "PF2")
Return Addr
If !This[":"].HasKey(Name)
Return ""
Attr := This[":"][Name]
If (Name <> "Tabs")
Return NumGet(Addr + 0, Attr.O, Attr.T)
Tabs := []
Offset := Attr.O - 4
Loop, 32
Tabs[A_Index] := NumGet(Addr + 0, Offset += 4, "UInt")
Return Tabs
}
__Set(Name, Value) {
Addr := This.GetAddress(".")
If !This[":"].HasKey(Name)
Return ""
Attr := This[":"][Name]
If (Name <> "Tabs") {
NumPut(Value, Addr + 0, Attr.O, Attr.T)
Return Value
}
If !IsObject(Value)
Return ""
Offset := Attr.O - 4
For Each, Tab In Value
NumPut(Tab, Addr + 0, Offset += 4, "UInt")
Return Tabs
}
}
GetBGR(RGB) {
Static HTML := {BLACK:  0x000000, SILVER: 0xC0C0C0, GRAY:   0x808080, WHITE:   0xFFFFFF
, MAROON: 0x000080, RED:    0x0000FF, PURPLE: 0x800080, FUCHSIA: 0xFF00FF
, GREEN:  0x008000, LIME:   0x00FF00, OLIVE:  0x008080, YELLOW:  0x00FFFF
, NAVY:   0x800000, BLUE:   0xFF0000, TEAL:   0x808000, AQUA:    0xFFFF00}
If HTML.HasKey(RGB)
Return HTML[RGB]
Return ((RGB & 0xFF0000) >> 16) + (RGB & 0x00FF00) + ((RGB & 0x0000FF) << 16)
}
GetRGB(BGR) {
Return ((BGR & 0xFF0000) >> 16) + (BGR & 0x00FF00) + ((BGR & 0x0000FF) << 16)
}
GetMeasurement() {
Static Metric := 2.54
, Inches := 1.00
, Measurement := ""
, Len := A_IsUnicode ? 2 : 4
If (Measurement = "") {
VarSetCapacity(LCD, 4, 0)
DllCall("Kernel32.dll\GetLocaleInfo", "UInt", 0x400, "UInt", 0x2000000D, "Ptr", &LCD, "Int", Len)
Measurement := NumGet(LCD, 0, "UInt") ? Inches : Metric
}
Return Measurement
}
SubclassProc(M, W, L, I, R) {
If (M = 0x87)
Return 4
Return DllCall("Comctl32.dll\DefSubclassProc", "Ptr", This, "UInt", M, "Ptr", W, "Ptr", L)
}
GetCharFormat() {
CF2 := New This.CF2
SendMessage, 0x043A, 1, % CF2.CF2, , % "ahk_id " . This.HWND
Return (CF2.Mask ? CF2 : False)
}
SetCharFormat(CF2) {
SendMessage, 0x0444, 1, % CF2.CF2, , % "ahk_id " . This.HWND
Return ErrorLevel
}
GetParaFormat() {
PF2 := New This.PF2
SendMessage, 0x043D, 0, % PF2.PF2, , % "ahk_id " . This.HWND
Return (PF2.Mask ? PF2 : False)
}
SetParaFormat(PF2) {
SendMessage, 0x0447, 0, % PF2.PF2, , % "ahk_id " . This.HWND
Return ErrorLevel
}
IsModified() {
SendMessage, 0xB8, 0, 0, , % "ahk_id " . This.HWND
Return ErrorLevel
}
SetModified(Modified := False) {
SendMessage, 0xB9, % !!Modified, 0, , % "ahk_id " . This.HWND
Return ErrorLevel
}
SetEventMask(Events := "") {
Static ENM := {NONE: 0x00, CHANGE: 0x01, UPDATE: 0x02, SCROLL: 0x04, SCROLLEVENTS: 0x08, DRAGDROPDONE: 0x10
, PARAGRAPHEXPANDED: 0x20, PAGECHANGE: 0x40, KEYEVENTS: 0x010000, MOUSEEVENTS: 0x020000
, REQUESTRESIZE: 0x040000, SELCHANGE: 0x080000, DROPFILES: 0x100000, PROTECTED: 0x200000
, LINK: 0x04000000}
If !IsObject(Events)
Events := ["NONE"]
Mask := 0
For Each, Event In Events {
If ENM.HasKey(Event)
Mask |= ENM[Event]
Else
Return False
}
SendMessage, 0x0445, 0, %Mask%, , % "ahk_id " . This.HWND
Return ErrorLevel
}
GetRTF(Selection := False) {
Static GetRTFCB := 0
Flags := 0x4022 | (1200 << 16) | (Selection ? 0x8000 : 0)
GetRTFCB := RegisterCallback("RichEdit.GetRTFProc")
VarSetCapacity(ES, (A_PtrSize * 2) + 4, 0)
NumPut(This.HWND, ES, 0, "Ptr")
NumPut(GetRTFCB, ES, A_PtrSize + 4, "Ptr")
SendMessage, 0x044A, %Flags%, &ES, , % "ahk_id " . This.HWND
DllCall("Kernel32.dll\GlobalFree", "Ptr", GetRTFCB)
Return This.GetRTFProc("Get", 0, 0)
}
GetRTFProc(pbBuff, cb, pcb) {
Static RTF := ""
If (cb > 0) {
RTF .= StrGet(pbBuff, cb, "CP0")
Return 0
}
If (pbBuff = "Get") {
Out := RTF
VarSetCapacity(RTF, 0)
Return Out
}
Return 1
}
LoadRTF(FilePath, Selection := False) {
Static LoadRTFCB := RegisterCallback("RichEdit.LoadRTFProc")
Flags := 0x4002 | (Selection ? 0x8000 : 0)
If !(File := FileOpen(FilePath, "r"))
Return False
VarSetCapacity(ES, (A_PtrSize * 2) + 4, 0)
NumPut(File.__Handle, ES, 0, "Ptr")
NumPut(LoadRTFCB, ES, A_PtrSize + 4, "Ptr")
SendMessage, 0x0449, %Flags%, &ES, , % "ahk_id " . This.HWND
Result := ErrorLevel
File.Close()
Return Result
}
LoadRTFProc(pbBuff, cb, pcb) {
Return !DllCall("ReadFile", "Ptr", This, "Ptr", pbBuff, "UInt", cb, "Ptr", pcb, "Ptr", 0)
}
GetScrollPos() {
VarSetCapacity(PT, 8, 0)
SendMessage, 0x04DD, 0, &PT, , % "ahk_id " . This.HWND
Return {X: NumGet(PT, 0, "Int"), Y: NumGet(PT, 4, "Int")}
}
SetScrollPos(X, Y) {
VarSetCapacity(PT, 8, 0)
NumPut(X, PT, 0, "Int")
NumPut(Y, PT, 4, "Int")
SendMessage, 0x04DE, 0, &PT, , % "ahk_id " . This.HWND
Return ErrorLevel
}
ScrollCaret() {
SendMessage, 0x00B7, 0, 0, , % "ahk_id " . This.HWND
Return True
}
ShowScrollBar(SB, Mode := True) {
SendMessage, 0x0460, %SB%, %Mode%, , % "ahk_id " . This.HWND
Return True
}
FindText(Find, Mode := "") {
Static FR:= {DOWN: 1, WHOLEWORD: 2, MATCHCASE: 4}
Flags := 0
For Each, Value In Mode
If FR.HasKey(Value)
Flags |= FR[Value]
Sel := This.GetSel()
Min := (Flags & FR.DOWN) ? Sel.E : Sel.S
Max := (Flags & FR.DOWN) ? -1 : 0
VarSetCapacity(FTX, 16 + A_PtrSize, 0)
NumPut(Min, FTX, 0, "Int")
NumPut(Max, FTX, 4, "Int")
NumPut(&Find, FTX, 8, "Ptr")
SendMessage, 0x047C, %Flags%, &FTX, , % "ahk_id " . This.HWND
S := NumGet(FTX, 8 + A_PtrSize, "Int"), E := NumGet(FTX, 12 + A_PtrSize, "Int")
If (S = -1) && (E = -1)
Return False
This.SetSel(S, E)
This.ScrollCaret()
Return
}
FindWordBreak(CharPos, Mode := "Left") {
Static WB := {LEFT: 0, RIGHT: 1, ISDELIMITER: 2, CLASSIFY: 3, MOVEWORDLEFT: 4, MOVEWORDRIGHT: 5, LEFTBREAK: 6
, RIGHTBREAK: 7}
Option := WB.HasKey(Mode) ? WB[Mode] : 0
SendMessage, 0x044C, %Option%, %CharPos%, , % "ahk_id " . This.HWND
Return ErrorLevel
}
GetSelText() {
VarSetCapacity(CR, 8, 0)
SendMessage, 0x0434, 0, &CR, , % "ahk_id " . This.HWND
L := NumGet(CR, 4, "Int") - NumGet(CR, 0, "Int") + 1
If (L > 1) {
VarSetCapacity(Text, L * 2, 0)
SendMessage, 0x043E, 0, &Text, , % "ahk_id " . This.HWND
VarSetCapacity(Text, -1)
}
Return Text
}
GetSel() {
VarSetCapacity(CR, 8, 0)
SendMessage, 0x0434, 0, &CR, , % "ahk_id " . This.HWND
Return {S: NumGet(CR, 0, "Int"), E: NumGet(CR, 4, "Int")}
}
GetText() {
Text := ""
If (Length := This.GetTextLen() * 2) {
VarSetCapacity(GTX, (4 * 4) + (A_PtrSize * 2), 0)
NumPut(Length + 2, GTX, 0, "UInt")
NumPut(1200, GTX, 8, "UInt")
VarSetCapacity(Text, Length + 2, 0)
SendMessage, 0x045E, &GTX, &Text, , % "ahk_id " . This.HWND
VarSetCapacity(Text, -1)
}
Return Text
}
GetTextLen() {
VarSetCapacity(GTL, 8, 0)
NumPut(1200, GTL, 4, "UInt")
SendMessage, 0x045F, &GTL, 0, , % "ahk_id " . This.HWND
Return ErrorLevel
}
GetTextRange(Min, Max) {
If (Max <= Min)
Return ""
VarSetCapacity(Text, (Max - Min) << !!A_IsUnicode, 0)
VarSetCapacity(TEXTRANGE, 16, 0)
NumPut(Min, TEXTRANGE, 0, "UInt")
NumPut(Max, TEXTRANGE, 4, "UInt")
NumPut(&Text, TEXTRANGE, 8, "UPtr")
SendMessage, 0x044B, 0, % &TEXTRANGE, , % "ahk_id " . This.HWND
VarSetCapacity(Text, -1)
Return Text
}
HideSelection(Mode) {
SendMessage, 0x043F, %Mode%, 0, , % "ahk_id " . This.HWND
Return True
}
LimitText(Limit)  {
SendMessage, 0x0435, 0, %Limit%, , % "ahk_id " . This.HWND
Return True
}
ReplaceSel(Text := "") {
SendMessage, 0xC2, 1, &Text, , % "ahk_id " . This.HWND
Return ErrorLevel
}
SetText(ByRef Text := "", Mode := "") {
Static ST := {DEFAULT: 0, KEEPUNDO: 1, SELECTION: 2}
Flags := 0
For Each, Value In Mode
If ST.HasKey(Value)
Flags |= ST[Value]
CP := 1200
BufAddr := &Text
If (SubStr(Text, 1, 5) = "{\rtf") || (SubStr(Text, 1, 5) = "{urtf") {
Len := StrPut(Text, "CP0")
VarSetCapacity(Buf, Len, 0)
StrPut(Text, &Buf, "CP0")
BufAddr := &Buf
CP := 0
}
VarSetCapacity(STX, 8, 0)
NumPut(Flags, STX, 0, "UInt")
NumPut(CP  ,  STX, 4, "UInt")
SendMessage, 0x0461, &STX, BufAddr, , % "ahk_id " . This.HWND
Return ErrorLevel
}
SetSel(Start, End) {
VarSetCapacity(CR, 8, 0)
NumPut(Start, CR, 0, "Int")
NumPut(End,   CR, 4, "Int")
SendMessage, 0x0437, 0, &CR, , % "ahk_id " . This.HWND
Return ErrorLevel
}
AutoURL(On) {
SendMessage, 0x45B, % !!On, 0, , % "ahk_id " . This.HWND
WinSet, Redraw, , % "ahk_id " . This.HWND
Return ErrorLevel
}
GetOptions() {
Static ECO := {AUTOWORDSELECTION: 0x01, AUTOVSCROLL: 0x40, AUTOHSCROLL: 0x80, NOHIDESEL: 0x100
, READONLY: 0x800, WANTRETURN: 0x1000, SAVESEL: 0x8000, SELECTIONBAR: 0x01000000
, VERTICAL: 0x400000}
SendMessage, 0x044E, 0, 0, , % "ahk_id " . This.HWND
O := ErrorLevel
Options := []
For Key, Value In ECO
If (O & Value)
Options.Insert(Key)
Return Options
}
GetStyles() {
Static SES := {1: "EMULATESYSEDIT", 1: "BEEPONMAXTEXT", 4: "EXTENDBACKCOLOR", 32: "NOXLTSYMBOLRANGE", 64: "USEAIMM"
, 128: "NOIME", 256: "ALLOWBEEPS", 512: "UPPERCASE", 1024: "LOWERCASE", 2048: "NOINPUTSEQUENCECHK"
, 4096: "BIDI", 8192: "SCROLLONKILLFOCUS", 16384: "XLTCRCRLFTOCR", 32768: "DRAFTMODE"
, 0x0010000: "USECTF", 0x0020000: "HIDEGRIDLINES", 0x0040000: "USEATFONT", 0x0080000: "CUSTOMLOOK"
, 0x0100000: "LBSCROLLNOTIFY", 0x0200000: "CTFALLOWEMBED", 0x0400000: "CTFALLOWSMARTTAG"
, 0x0800000: "CTFALLOWPROOFING"}
SendMessage, 0x04CD, 0, 0, , % "ahk_id " . This.HWND
Result := ErrorLevel
Styles := []
For Key, Value In SES
If (Result & Key)
Styles.Insert(Value)
Return Styles
}
GetZoom() {
VarSetCapacity(N, 4, 0), VarSetCapacity(D, 4, 0)
SendMessage, 0x04E0, &N, &D, , % "ahk_id " . This.HWND
N := NumGet(N, 0, "Int"), D := NumGet(D, 0, "Int")
Return (N = 0) && (D = 0) ? 100 : Round(N / D * 100)
}
SetBkgndColor(Color) {
If (Color = "Auto")
System := True, Color := 0
Else
System := False, Color := This.GetBGR(Color)
SendMessage, 0x0443, %System%, %Color%, , % "ahk_id " . This.HWND
Return This.GetRGB(ErrorLevel)
}
SetOptions(Options, Mode := "SET") {
Static ECO := {AUTOWORDSELECTION: 0x01, AUTOVSCROLL: 0x40, AUTOHSCROLL: 0x80, NOHIDESEL: 0x100, READONLY: 0x800
, WANTRETURN: 0x1000, SAVESEL: 0x8000, SELECTIONBAR: 0x01000000, VERTICAL: 0x400000}
, ECOOP := {SET: 0x01, OR: 0x02, AND: 0x03, XOR: 0x04}
If !ECOOP.HasKey(Mode)
Return False
O := 0
For Each, Option In Options {
If ECO.HasKey(Option)
O |= ECO[Option]
Else
Return False
}
SendMessage, 0x044D, % ECOOP[Mode], %O%, , % "ahk_id " . This.HWND
Return ErrorLevel
}
SetStyles(Styles) {
Static SES = {EMULATESYSEDIT: 1, BEEPONMAXTEXT: 2, EXTENDBACKCOLOR: 4, NOXLTSYMBOLRANGE: 32, USEAIMM: 64
, NOIME: 128, ALLOWBEEPS: 256, UPPERCASE: 512, LOWERCASE: 1024, NOINPUTSEQUENCECHK: 2048
, BIDI: 4096, SCROLLONKILLFOCUS: 8192, XLTCRCRLFTOCR: 16384, DRAFTMODE: 32768
, USECTF: 0x0010000, HIDEGRIDLINES: 0x0020000, USEATFONT: 0x0040000, CUSTOMLOOK: 0x0080000
, LBSCROLLNOTIFY: 0x0100000, CTFALLOWEMBED: 0x0200000, CTFALLOWSMARTTAG: 0x0400000
, CTFALLOWPROOFING: 0x0800000}
Flags := Mask := 0
For Style, Value In Styles {
If SES.HasKey(Style) {
Mask |= SES[Style]
If (Value <> 0)
Flags |= SES[Style]
}
}
If (Mask) {
SendMessage, 0x04CC, %Flags%, %Mask%, ,, % "ahk_id " . This.HWND
Return ErrorLevel
}
Return False
}
SetZoom(Ratio := "") {
SendMessage, 0x4E1, % (Ratio > 0 ? Ratio : 100), 100, , % "ahk_id " . This.HWND
Return ErrorLevel
}
CanRedo() {
SendMessage, 0x0455, 0, 0, , % "ahk_id " . This.HWND
Return ErrorLevel
}
CanUndo() {
SendMessage, 0x00C6, 0, 0, , % "ahk_id " . This.HWND
Return ErrorLevel
}
Clear() {
SendMessage, 0x303, 0, 0, , % "ahk_id " . This.HWND
Return ErrorLevel
}
Copy() {
SendMessage, 0x301, 0, 0, , % "ahk_id " . This.HWND
Return ErrorLevel
}
Cut() {
SendMessage, 0x300, 0, 0, , % "ahk_id " . This.HWND
Return ErrorLevel
}
Paste() {
SendMessage, 0x302, 0, 0, , % "ahk_id " . This.HWND
Return ErrorLevel
}
Redo() {
SendMessage, 0x454, 0, 0, , % "ahk_id " . This.HWND
Return ErrorLevel
}
Undo() {
SendMessage, 0xC7, 0, 0, , % "ahk_id " . This.HWND
Return ErrorLevel
}
SelAll() {
Return This.SetSel(0, -1)
}
Deselect() {
Sel := This.GetSel()
Return This.SetSel(Sel.S, Sel.S)
}
ChangeFontSize(Diff) {
Font := This.GetFont()
If (Diff > 0 && Font.Size < 160) || (Diff < 0 && Font.Size > 4)
SendMessage, 0x04DF, % (Diff > 0 ? 1 : -1), 0, , % "ahk_id " . This.HWND
Else
Return False
Font := This.GetFont()
Return Font.Size
}
GetFont(Default := False) {
Static Mask := 0xEC03001F
Static Effects := 0xEC000000
CF2 := New This.CF2
CF2.Mask := Mask
CF2.Effects := Effects
SendMessage, 0x043A, % (Default ? 0 : 1), % CF2.CF2, , % "ahk_id " . This.HWND
Font := {}
Font.Name := CF2.FaceName
Font.Size := CF2.Height / 20
CFS := CF2.Effects
Style := (CFS & 1 ? "B" : "") . (CFS & 2 ? "I" : "") . (CFS & 4 ? "U" : "") . (CFS & 8 ? "S" : "")
. (CFS & 0x10000 ? "L" : "") . (CFS & 0x20000 ? "H" : "") . (CFS & 16 ? "P" : "")
Font.Style := Style = "" ? "N" : Style
Font.Color := This.GetRGB(CF2.TextColor)
If (CF2.Effects & 0x04000000)
Font.BkColor := "Auto"
Else
Font.BkColor := This.GetRGB(CF2.BackColor)
Font.CharSet := CF2.CharSet
Return Font
}
SetDefaultFont(Font := "") {
If IsObject(Font) {
For Key, Value In Font
If This.DefFont.HasKey(Key)
This.DefFont[Key] := Value
}
Return This.SetFont(This.DefFont)
}
SetFont(Font) {
CF2 := New This.CF2
Mask := Effects := 0
If (Font.Name != "") {
Mask |= 0x20000000, Effects |= 0x20000000
CF2.FaceName := Font.Name
}
Size := Font.Size
If (Size != "") {
If (Size < 161)
Size *= 20
Mask |= 0x80000000, Effects |= 0x80000000
CF2.Height := Size
}
If (Font.Style != "") {
Mask |= 0x3001F
If InStr(Font.Style, "B")
Effects |= 1
If InStr(Font.Style, "I")
Effects |= 2
If InStr(Font.Style, "U")
Effects |= 4
If InStr(Font.Style, "S")
Effects |= 8
If InStr(Font.Style, "P")
Effects |= 16
If InStr(Font.Style, "L")
Effects |= 0x10000
If InStr(Font.Style, "H")
Effects |= 0x20000
}
If (Font.Color != "") {
Mask |= 0x40000000
If (Font.Color = "Auto")
Effects |= 0x40000000
Else
CF2.TextColor := This.GetBGR(Font.Color)
}
If (Font.BkColor != "") {
Mask |= 0x04000000
If (Font.BkColor = "Auto")
Effects |= 0x04000000
Else
CF2.BackColor := This.GetBGR(Font.BkColor)
}
If (Font.CharSet != "") {
Mask |= 0x08000000, Effects |= 0x08000000
CF2.CharSet := Font.CharSet = 2 ? 2 : 1
}
If (Mask != 0) {
Mode := Font.Default ? 0 : 1
CF2.Mask := Mask
CF2.Effects := Effects
SendMessage, 0x0444, %Mode%, % CF2.CF2, , % "ahk_id " . This.HWND
Return ErrorLevel
}
Return False
}
ToggleFontStyle(Style) {
CF2 :=This.GetCharFormat()
CF2.Mask := 0x3001F
If (Style = "N")
CF2.Effects := 0
Else
CF2.Effects ^= Style = "B" ? 1 : Style = "I" ? 2 : Style = "U" ? 4 : Style = "S" ? 8
: Style = "H" ? 0x20000 : Style = "L" ? 0x10000 : 0
SendMessage, 0x0444, 1, % CF2.CF2, , % "ahk_id " . This.HWND
Return ErrorLevel
}
AlignText(Align := 1) {
If (Align >= 1) && (ALign <= 8) {
PF2 := New This.PF2
PF2.Mask := 0x08
PF2.Alignment := Align
SendMessage, 0x0447, 0, % PF2.PF2, , % "ahk_id " . This.HWND
Return True
}
Return False
}
SetBorder(Widths, Styles) {
If !IsObject(Widths)
Return False
W := S := 0
For I, V In Widths {
If (V)
W |= V << ((A_Index - 1) * 4)
If Styles[I]
S |= Styles[I] << ((A_Index - 1) * 4)
}
PF2 := New This.PF2
PF2.Mask := 0x800
PF2.BorderWidth := W
PF2.Borders := S
SendMessage, 0x0447, 0, % PF2.PF2, , % "ahk_id " . This.HWND
Return ErrorLevel
}
SetLineSpacing(Lines) {
PF2 := New This.PF2
PF2.Mask := 0x100
PF2.LineSpacing := Abs(Lines) * 20
PF2.LineSpacingRule := 5
SendMessage, 0x0447, 0, % PF2.PF2, , % "ahk_id " . This.HWND
Return ErrorLevel
}
SetParaIndent(Indent := "Reset") {
Static PFM := {STARTINDENT: 0x01, RIGHTINDENT: 0x02, OFFSET: 0x04}
Measurement := This.GetMeasurement()
PF2 := New This.PF2
If (Indent = "Reset")
PF2.Mask := 0x07
Else If !IsObject(Indent)
Return False
Else {
PF2.Mask := 0
If (Indent.HasKey("Start")) {
PF2.Mask |= PFM.STARTINDENT
PF2.StartIndent := Round((Indent.Start / Measurement) * 1440)
}
If (Indent.HasKey("Offset")) {
PF2.Mask |= PFM.OFFSET
PF2.Offset := Round((Indent.Offset / Measurement) * 1440)
}
If (Indent.HasKey("Right")) {
PF2.Mask |= PFM.RIGHTINDENT
PF2.RightIndent := Round((Indent.Right / Measurement) * 1440)
}
}
If (PF2.Mask) {
SendMessage, 0x0447, 0, % PF2.PF2, , % "ahk_id " . This.HWND
Return ErrorLevel
}
Return False
}
SetParaNumbering(Numbering := "Reset") {
Static PFM := {Type: 0x0020, Style: 0x2000, Tab: 0x4000, Start: 0x8000}
Static PFN := {Bullet: 1, Arabic: 2, LCLetter: 3, UCLetter: 4, LCRoman: 5, UCRoman: 6}
Static PFNS := {Paren: 0x0000, Parens: 0x0100, Period: 0x0200, Plain: 0x0300, None: 0x0400, New: 0x8000}
PF2 := New This.PF2
If (Numbering = "Reset")
PF2.Mask := 0xE020
Else If !IsObject(Numbering)
Return False
Else {
If (Numbering.HasKey("Type")) {
PF2.Mask |= PFM.Type
PF2.Numbering := PFN[Numbering.Type]
}
If (Numbering.HasKey("Style")) {
PF2.Mask |= PFM.Style
PF2.NumberingStyle := PFNS[Numbering.Style]
}
If (Numbering.HasKey("Tab")) {
PF2.Mask |= PFM.Tab
PF2.NumberingTab := Round((Numbering.Tab / This.GetMeasurement()) * 1440)
}
If (Numbering.HasKey("Start")) {
PF2.Mask |= PFM.Start
PF2.NumberingStart := Numbering.Start
}
}
If (PF2.Mask) {
SendMessage, 0x0447, 0, % PF2.PF2, , % "ahk_id " . This.HWND
Return ErrorLevel
}
Return False
}
SetParaSpacing(Spacing := "Reset") {
Static PFM := {Before: 0x40, After: 0x80}
PF2 := New This.PF2
If (Spacing = "Reset")
PF2.Mask := 0xC0
Else If !IsObject(Spacing)
Return False
Else {
If (Spacing.Before >= 0) {
PF2.Mask |= PFM.Before
PF2.SpaceBefore := Round(Spacing.Before * 20)
}
If (Spacing.After >= 0) {
PF2.Mask |= PFM.After
PF2.SpaceAfter := Round(Spacing.After * 20)
}
}
If (PF2.Mask) {
SendMessage, 0x0447, 0, % PF2.PF2, , % "ahk_id " . This.HWND
Return ErrorLevel
}
Return False
}
SetDefaultTabs(Distance) {
Static DUI := 64
, MinTab := 0.20
, MaxTab := 3.00
IM := This.GetMeasurement()
StringReplace, Distance, Distance, `,, .
Distance := Round(Distance / IM, 2)
If (Distance < MinTab)
Distance := MinTab
If (Distance > MaxTab)
Distance := MaxTab
VarSetCapacity(TabStops, 4, 0)
NumPut(Round(DUI * Distance), TabStops, "Int")
SendMessage, 0xCB, 1, &TabStops, , % "ahk_id " . This.HWND
Result := ErrorLevel
DllCall("User32.dll\UpdateWindow", "Ptr", This.HWND)
Return Result
}
SetTabStops(TabStops := "Reset") {
Static MinT := 30
Static MaxT := 830
Static Align := {L: 0x00000000
, C: 0x01000000
, R: 0x02000000
, D: 0x03000000}
Static MAX_TAB_STOPS := 32
IC := This.GetMeasurement()
PF2 := New This.PF2
PF2.Mask := 0x10
If (TabStops = "Reset") {
SendMessage, 0x0447, 0, % PF2.PF2, , % "ahk_id " . This.HWND
Return !!(ErrorLevel)
}
If !IsObject(TabStops)
Return False
TabCount := 0
Tabs  := []
For Position, Alignment In TabStops {
Position /= IC
If (Position < MinT) Or (Position > MaxT)
Or !Align.HasKey(Alignment) Or (A_Index > MAX_TAB_STOPS)
Return False
Tabs[A_Index] := (Align[Alignment] | Round((Position / 100) * 1440))
TabCount := A_Index
}
If (TabCount) {
PF2.TabCount := TabCount
PF2.Tabs := Tabs
SendMessage, 0x0447, 0, % PF2.PF2, , % "ahk_id " . This.HWND
Return ErrorLevel
}
Return False
}
GetLineCount() {
SendMessage, 0xBA, 0, 0, , % "ahk_id " . This.HWND
Return ErrorLevel
}
GetCaretLine() {
SendMessage, 0xBB, -1, 0, , % "ahk_id " . This.HWND
SendMessage, 0x0436, 0, %ErrorLevel%, , % "ahk_id " . This.HWND
Return ErrorLevel + 1
}
GetStatistics() {
Stats := {}
VarSetCapacity(GTL, 8, 0)
SB := 0
SendMessage, 0xB0, &SB, 0, , % "ahk_id " . This.HWND
SB := NumGet(SB, 0, "UInt") + 1
SendMessage, 0xBB, -1, 0, , % "ahk_id " . This.HWND
Stats.LinePos := SB - ErrorLevel
SendMessage, 0xC9, -1, 0, , % "ahk_id " . This.HWND
Stats.Line := ErrorLevel + 1
SendMessage, 0xBA, 0, 0, , % "ahk_id " . This.HWND
Stats.LineCount := ErrorLevel
Stats.CharCount := This.GetTextLen()
Return Stats
}
WordWrap(On) {
Sel := This.GetSel()
SendMessage, 0x0448, 0, % (On ? 0 : -1), , % "ahk_id " . This.HWND
This.SetSel(Sel.S, Sel.E)
SendMessage, 0xB7, 0, 0,  % "ahk_id " . This.HWND
Return On
}
WYSIWYG(On) {
Static PDC := 0
Static PD_Size := (A_PtrSize = 4 ? 66 : 120)
Static OffFlags := A_PtrSize * 5
Sel := This.GetSel()
If !(On) {
DllCall("User32.dll\LockWindowUpdate", "Ptr", This.HWND)
DllCall("Gdi32.dll\DeleteDC", "Ptr", PDC)
SendMessage, 0x0448, 0, -1, , % "ahk_id " . This.HWND
This.SetSel(Sel.S, Sel.E)
SendMessage, 0xB7, 0, 0,  % "ahk_id " . This.HWND
DllCall("User32.dll\LockWindowUpdate", "Ptr", 0)
Return ErrorLevel
}
Numput(VarSetCapacity(PD, PD_Size, 0), PD)
NumPut(0x0100 | 0x0400, PD, A_PtrSize * 5, "UInt")
If !DllCall("Comdlg32.dll\PrintDlg", "Ptr", &PD, "Int")
Return
DllCall("Kernel32.dll\GlobalFree", "Ptr", NumGet(PD, A_PtrSize * 2, "UPtr"))
DllCall("Kernel32.dll\GlobalFree", "Ptr", NumGet(PD, A_PtrSize * 3, "UPtr"))
PDC := NumGet(PD, A_PtrSize * 4, "UPtr")
DllCall("User32.dll\LockWindowUpdate", "Ptr", This.HWND)
Caps := This.GetPrinterCaps(PDC)
UML := This.Margins.LT
UMR := This.Margins.RT
PML := Caps.POFX
PMR := Caps.PHYW - Caps.HRES - Caps.POFX
LPW := Caps.HRES
UML := UML > PML ? (UML - PML) : 0
UMR := UMR > PMR ? (UMR - PMR) : 0
LineLen := LPW - UML - UMR
SendMessage, 0x0448, %PDC%, %LineLen%, , % "ahk_id " . This.HWND
This.SetSel(Sel.S, Sel.E)
SendMessage, 0xB7, 0, 0,  % "ahk_id " . This.HWND
DllCall("User32.dll\LockWindowUpdate", "Ptr", 0)
Return ErrorLevel
}
LoadFile(File, Mode = "Open") {
If !FileExist(File)
Return False
SplitPath, File, , , Ext
If (Ext = "rtf") {
If (Mode = "Open") {
Selection := False
} Else If (Mode = "Insert") {
Selection := True
} Else If (Mode = "Append") {
This.SetSel(-1, -2)
Selection := True
}
This.LoadRTF(File, Selection)
} Else {
FileRead, Text, %File%
If (Mode = "Open") {
This.SetText(Text)
} Else If (Mode = "Insert") {
This.ReplaceSel(Text)
} Else If (Mode = "Append") {
This.SetSel(-1, -2)
This.ReplaceSel(Text)
}
}
Return True
}
SaveFile(File) {
GuiName := This.GuiName
Gui, %GuiName%:+OwnDialogs
SplitPath, File, , , Ext
Text := Ext = "rtf" ? This.GetRTF() : This.GetText()
If IsObject(FileObj := FileOpen(File, "w")) {
FileObj.Write(Text)
FileObj.Close()
Return True
}
Return False
}
Print() {
Static PD_ALLPAGES := 0x00, PD_SELECTION := 0x01, PD_PAGENUMS := 0x02, PD_NOSELECTION := 0x04
, PD_RETURNDC := 0x0100, PD_USEDEVMODECOPIES := 0x040000, PD_HIDEPRINTTOFILE := 0x100000
, PD_NONETWORKBUTTON := 0x200000, PD_NOCURRENTPAGE := 0x800000
, MM_TEXT := 0x1
, EM_FORMATRANGE := 0x0439, EM_SETTARGETDEVICE := 0x0448
, DocName := "AHKRichEdit"
, PD_Size := (A_PtrSize = 8 ? (13 * A_PtrSize) + 16 : 66)
ErrorMsg := ""
VarSetCapacity(PD, PD_Size, 0)
Numput(PD_Size, PD, 0, "UInt")
Numput(This.GuiHwnd, PD, A_PtrSize, "UPtr")
Sel := This.GetSel()
Flags := PD_ALLPAGES | PD_RETURNDC | PD_USEDEVMODECOPIES | PD_HIDEPRINTTOFILE | PD_NONETWORKBUTTON
| PD_NOCURRENTPAGE
If (Sel.S = Sel.E)
Flags |= PD_NOSELECTION
Else
Flags |= PD_SELECTION
Offset := A_PtrSize * 5
NumPut(Flags, PD, Offset, "UInt")
NumPut( 1, PD, Offset += 4, "UShort")
NumPut( 1, PD, Offset += 2, "UShort")
NumPut( 1, PD, Offset += 2, "UShort")
NumPut(-1, PD, Offset += 2, "UShort")
NumPut( 1, PD, Offset += 2, "UShort")
If !DllCall("Comdlg32.dll\PrintDlg", "Ptr", &PD, "UInt") {
ErrorLevel := "Function: " . A_ThisFunc . " - DLLCall of 'PrintDlg' failed."
Return False
}
If !(PDC := NumGet(PD, A_PtrSize * 4, "UPtr")) {
ErrorLevel := "Function: " . A_ThisFunc . " - Couldn't get a printer's device context."
Return False
}
DllCall("Kernel32.dll\GlobalFree", "Ptr", NumGet(PD, A_PtrSize * 2, "UPtr"))
DllCall("Kernel32.dll\GlobalFree", "Ptr", NumGet(PD, A_PtrSize * 3, "UPtr"))
Offset := A_PtrSize * 5
Flags := NumGet(PD, OffSet, "UInt")
If (Flags & PD_PAGENUMS) {
PageF := NumGet(PD, Offset += 4, "UShort")
PageL := NumGet(PD, Offset += 2, "UShort")
} Else {
PageF := 1
PageL := 65535
}
Caps := This.GetPrinterCaps(PDC)
UML := This.Margins.LT
UMT := This.Margins.TT
UMR := This.Margins.RT
UMB := This.Margins.BT
PML := Caps.POFX
PMT := Caps.POFY
PMR := Caps.PHYW - Caps.HRES - Caps.POFX
PMB := Caps.PHYH - Caps.VRES - Caps.POFY
LPW := Caps.HRES
LPH := Caps.VRES
UML := UML > PML ? (UML - PML) : 0
UMT := UMT > PMT ? (UMT - PMT) : 0
UMR := UMR > PMR ? (UMR - PMR) : 0
UMB := UMB > PMB ? (UMB - PMB) : 0
VarSetCapacity(FR, (A_PtrSize * 2) + (4 * 10), 0)
NumPut(PDC, FR, 0, "UPtr")
NumPut(PDC, FR, A_PtrSize, "UPtr")
Offset := A_PtrSize * 2
NumPut(UML, FR, Offset += 0, "Int")
NumPut(UMT, FR, Offset += 4, "Int")
NumPut(LPW - UMR, FR, Offset += 4, "Int")
NumPut(LPH - UMB, FR, Offset += 4, "Int")
NumPut(0, FR, Offset += 0, "Int")
NumPut(0, FR, Offset += 4, "Int")
NumPut(LPW, FR, Offset += 4, "Int")
NumPut(LPH, FR, Offset += 4, "Int")
If (Flags & PD_SELECTION) {
PrintS := Sel.S
PrintE := Sel.E
} Else {
PrintS := 0
PrintE := -1
}
Numput(PrintS, FR, Offset += 4, "Int")
NumPut(PrintE, FR, Offset += 4, "Int")
VarSetCapacity(DI, A_PtrSize * 5, 0)
NumPut(A_PtrSize * 5, DI, 0, "UInt")
NumPut(&DocName, DI, A_PtrSize, "UPtr")
NumPut(0       , DI, A_PtrSize * 2, "UPtr")
If (Flags & PD_SELECTION) {
PrintM := Sel.E
} Else {
PrintM := This.GetTextLen()
}
DllCall("Gdi32.dll\SetMapMode", "Ptr", PDC, "Int", MM_TEXT)
PrintJob := DllCall("Gdi32.dll\StartDoc", "Ptr", PDC, "Ptr", &DI, "Int")
If (PrintJob <= 0) {
ErrorLevel := "Function: " . A_ThisFunc . " - DLLCall of 'StartDoc' failed."
Return False
}
PageC  := 0
PrintC := 0
While (PrintC < PrintM) {
PageC++
If (PageC > PageL)
Break
If (PageC >= PageF) && (PageC <= PageL) {
If (DllCall("Gdi32.dll\StartPage", "Ptr", PDC, "Int") <= 0) {
ErrorMsg := "Function: " . A_ThisFunc . " - DLLCall of 'StartPage' failed."
Break
}
}
If (PageC >= PageF) && (PageC <= PageL)
Render := True
Else
Render := False
SendMessage, %EM_FORMATRANGE%, %Render%, &FR, , % "ahk_id " . This.HWND
PrintC := ErrorLevel
If (PageC >= PageF) && (PageC <= PageL) {
If (DllCall("Gdi32.dll\EndPage", "Ptr", PDC, "Int") <= 0) {
ErrorMsg := "Function: " . A_ThisFunc . " - DLLCall of 'EndPage' failed."
Break
}
}
Offset := (A_PtrSize * 2) + (4 * 8)
Numput(PrintC, FR, Offset += 0, "Int")
NumPut(PrintE, FR, Offset += 4, "Int")
}
DllCall("Gdi32.dll\EndDoc", "Ptr", PDC)
DllCall("Gdi32.dll\DeleteDC", "Ptr", PDC)
SendMessage %EM_FORMATRANGE%, 0, 0, , % "ahk_id " . This.HWND
If (ErrorMsg) {
ErrorLevel := ErrorMsg
Return False
}
Return True
}
GetMargins() {
Static PSD_RETURNDEFAULT := 0x00000400, PSD_INTHOUSANDTHSOFINCHES := 0x00000004
, I := 1000
, M := 2540
, PSD_Size := (4 * 10) + (A_PtrSize * 11)
, PD_Size := (A_PtrSize = 8 ? (13 * A_PtrSize) + 16 : 66)
, OffFlags := 4 * A_PtrSize
, OffMargins := OffFlags + (4 * 7)
If !This.HasKey("Margins") {
VarSetCapacity(PSD, PSD_Size, 0)
NumPut(PSD_Size, PSD, 0, "UInt")
NumPut(PSD_RETURNDEFAULT, PSD, OffFlags, "UInt")
If !DllCall("Comdlg32.dll\PageSetupDlg", "Ptr", &PSD, "UInt")
Return false
DllCall("Kernel32.dll\GobalFree", UInt, NumGet(PSD, 2 * A_PtrSize, "UPtr"))
DllCall("Kernel32.dll\GobalFree", UInt, NumGet(PSD, 3 * A_PtrSize, "UPtr"))
Flags := NumGet(PSD, OffFlags, "UInt")
Metrics := (Flags & PSD_INTHOUSANDTHSOFINCHES) ? I : M
Offset := OffMargins
This.Margins := {}
This.Margins.L := NumGet(PSD, Offset += 0, "Int")
This.Margins.T := NumGet(PSD, Offset += 4, "Int")
This.Margins.R := NumGet(PSD, Offset += 4, "Int")
This.Margins.B := NumGet(PSD, Offset += 4, "Int")
This.Margins.LT := Round((This.Margins.L / Metrics) * 1440)
This.Margins.TT := Round((This.Margins.T / Metrics) * 1440)
This.Margins.RT := Round((This.Margins.R / Metrics) * 1440)
This.Margins.BT := Round((This.Margins.B / Metrics) * 1440)
}
Return True
}
GetPrinterCaps(DC) {
Static HORZRES         := 0x08, VERTRES         := 0x0A
, LOGPIXELSX      := 0x58, LOGPIXELSY      := 0x5A
, PHYSICALWIDTH   := 0x6E, PHYSICALHEIGHT  := 0x6F
, PHYSICALOFFSETX := 0x70, PHYSICALOFFSETY := 0x71
, Caps := {}
LPXX := DllCall("Gdi32.dll\GetDeviceCaps", "Ptr", DC, "Int", LOGPIXELSX, "Int")
LPXY := DllCall("Gdi32.dll\GetDeviceCaps", "Ptr", DC, "Int", LOGPIXELSY, "Int")
Caps.PHYW := Round((DllCall("Gdi32.dll\GetDeviceCaps", "Ptr", DC, "Int", PHYSICALWIDTH, "Int") / LPXX) * 1440)
Caps.PHYH := Round((DllCall("Gdi32.dll\GetDeviceCaps", "Ptr", DC, "Int", PHYSICALHEIGHT, "Int") / LPXY) * 1440)
Caps.POFX := Round((DllCall("Gdi32.dll\GetDeviceCaps", "Ptr", DC, "Int", PHYSICALOFFSETX, "Int") / LPXX) * 1440)
Caps.POFY := Round((DllCall("Gdi32.dll\GetDeviceCaps", "Ptr", DC, "Int", PHYSICALOFFSETY, "Int") / LPXY) * 1440)
Caps.HRES := Round((DllCall("Gdi32.dll\GetDeviceCaps", "Ptr", DC, "Int", HORZRES, "Int") / LPXX) * 1440)
Caps.VRES := Round((DllCall("Gdi32.dll\GetDeviceCaps", "Ptr", DC, "Int", VERTRES, "Int") / LPXY) * 1440)
Return Caps
}
}
Class RichEditDlgs {
ChooseColor(RE, Color := "") {
Static CC_Size := A_PtrSize * 9, CCU := "Init"
GuiHwnd := RE.GuiHwnd
If (Color = "T")
Font := RE.GetFont(), Color := Font.Color = "Auto" ? 0x0 : RE.GetBGR(Font.Color)
Else If (Color = "B")
Font := RE.GetFont(), Color := Font.BkColor = "Auto" ? 0x0 : RE.GetBGR(Font.BkColor)
Else If (Color != "")
Color := RE.GetBGR(Color)
Else
Color := 0x000000
If (CCU = "Init")
VarSetCapacity(CCU, 64, 0)
VarSetCapacity(CC, CC_Size, 0)
NumPut(CC_Size, CC, 0, "UInt")
NumPut(GuiHwnd, CC, A_PtrSize, "UPtr")
NumPut(Color, CC, A_PtrSize * 3, "UInt")
NumPut(&CCU, CC, A_PtrSize * 4, "UPtr")
NumPut(0x0101, CC, A_PtrSize * 5, "UInt")
R := DllCall("Comdlg32.dll\ChooseColor", "Ptr", &CC, "UInt")
If (ErrorLevel <> 0) || (R = 0)
Return False
Return RE.GetRGB(NumGet(CC, A_PtrSize * 3, "UInt"))
}
ChooseFont(RE) {
DC := DllCall("User32.dll\GetDC", "Ptr", RE.GuiHwnd, "Ptr")
LP := DllCall("GetDeviceCaps", "Ptr", DC, "UInt", 90, "Int")
DllCall("User32.dll\ReleaseDC", "Ptr", RE.GuiHwnd, "Ptr", DC)
Font := RE.GetFont()
VarSetCapacity(LF, 92, 0)
Size := -(Font.Size * LP / 72)
NumPut(Size, LF, 0, "Int")
If InStr(Font.Style, "B")
NumPut(700, LF, 16, "Int")
If InStr(Font.Style, "I")
NumPut(1, LF, 20, "UChar")
If InStr(Font.Style, "U")
NumPut(1, LF, 21, "UChar")
If InStr(Font.Style, "S")
NumPut(1, LF, 22, "UChar")
NumPut(Font.CharSet, LF, 23, "UChar")
StrPut(Font.Name, &LF + 28, 32)
Flags := 0x00002141
Color := RE.GetBGR(Font.Color)
CF_Size := (A_PtrSize = 8 ? (A_PtrSize * 10) + (4 * 4) + A_PtrSize : (A_PtrSize * 14) + 4)
VarSetCapacity(CF, CF_Size, 0)
NumPut(CF_Size, CF, "UInt")
NumPut(RE.GuiHwnd, CF, A_PtrSize, "UPtr")
NumPut(&LF, CF, A_PtrSize * 3, "UPtr")
NumPut(Flags, CF, (A_PtrSize * 4) + 4, "UInt")
NumPut(Color, CF, (A_PtrSize * 4) + 8, "UInt")
OffSet := (A_PtrSize = 8 ? (A_PtrSize * 11) + 4 : (A_PtrSize * 12) + 4)
NumPut(4, CF, Offset, "Int")
NumPut(160, CF, OffSet + 4, "Int")
If !DllCall("Comdlg32.dll\ChooseFont", "Ptr", &CF, "UInt")
Return false
Font.Name := StrGet(&LF + 28, 32)
Font.Size := NumGet(CF, A_PtrSize * 4, "Int") / 10
Font.Style := ""
If NumGet(LF, 16, "Int") >= 700
Font.Style .= "B"
If NumGet(LF, 20, "UChar")
Font.Style .= "I"
If NumGet(LF, 21, "UChar")
Font.Style .= "U"
If NumGet(LF, 22, "UChar")
Font.Style .= "S"
OffSet := A_PtrSize * (A_PtrSize = 8 ? 11 : 12)
FontType := NumGet(CF, Offset, "UShort")
If (FontType & 0x0100) && !InStr(Font.Style, "B")
Font.Style .= "B"
If (FontType & 0x0200) && !InStr(Font.Style, "I")
Font.Style .= "I"
If (Font.Style = "")
Font.Style := "N"
Font.CharSet := NumGet(LF, 23, "UChar")
Return RE.SetFont(Font)
}
FileDlg(RE, Mode, File := "") {
Static OFN_ALLOWMULTISELECT := 0x200,    OFN_EXTENSIONDIFFERENT := 0x400, OFN_CREATEPROMPT := 0x2000
, OFN_DONTADDTORECENT := 0x2000000, OFN_FILEMUSTEXIST := 0x1000,     OFN_FORCESHOWHIDDEN := 0x10000000
, OFN_HIDEREADONLY := 0x4,          OFN_NOCHANGEDIR := 0x8,          OFN_NODEREFERENCELINKS := 0x100000
, OFN_NOVALIDATE := 0x100,          OFN_OVERWRITEPROMPT := 0x2,      OFN_PATHMUSTEXIST := 0x800
, OFN_READONLY := 0x1,              OFN_SHOWHELP := 0x10,            OFN_NOREADONLYRETURN := 0x8000
, OFN_NOTESTFILECREATE := 0x10000,  OFN_ENABLEXPLORER := 0x80000
, OFN_Size := (4 * 5) + (2 * 2) + (A_PtrSize * 16)
Static FilterN1 := "RichText",   FilterP1 :=  "*.rtf"
, FilterN2 := "All Files",       FilterP2 := "*.*"
, FilterN3 := "", FilterP3 := ""
, DefExt := "rtf", DefFilter := 1
SplitPath, File, Name, Dir
Flags := OFN_ENABLEXPLORER
Flags |= Mode = "O" ? OFN_FILEMUSTEXIST | OFN_PATHMUSTEXIST | OFN_HIDEREADONLY
: OFN_OVERWRITEPROMPT
VarSetCapacity(FileName, 1024, 0)
FileName := Name
LenN1 := (StrLen(FilterN1) + 1) * 2, LenP1 := (StrLen(FilterP1) + 1) * 2
LenN2 := (StrLen(FilterN2) + 1) * 2, LenP2 := (StrLen(FilterP2) + 1) * 2
LenN3 := (StrLen(FilterN3) + 1) * 2, LenP3 := (StrLen(FilterP3) + 1) * 2
VarSetCapacity(Filter, LenN1 + LenP1 + LenN2 + LenP2 + LenN3 + LenP3 + 4, 0)
Adr := &Filter
StrPut(FilterN1, Adr)
StrPut(FilterP1, Adr += LenN1)
StrPut(FilterN2, Adr += LenP1)
StrPut(FilterP2, Adr += LenN2)
StrPut(FilterN3, Adr += LenP2)
StrPut(FilterP3, Adr += LenN3)
VarSetCapacity(OFN , OFN_Size, 0)
NumPut(OFN_Size, OFN, 0, "UInt")
Offset := A_PtrSize
NumPut(RE.GuiHwnd, OFN, Offset, "Ptr")
Offset += A_PtrSize * 2
NumPut(&Filter, OFN, OffSet, "Ptr")
OffSet += (A_PtrSize * 2) + 4
OffFilter := Offset
NumPut(DefFilter, OFN, Offset, "UInt")
OffSet += 4
NumPut(&FileName, OFN, OffSet, "Ptr")
Offset += A_PtrSize
NumPut(512, OFN, Offset, "UInt")
OffSet += A_PtrSize * 3
NumPut(&Dir, OFN, Offset, "Ptr")
Offset += A_PtrSize * 2
NumPut(Flags, OFN, Offset, "UInt")
Offset += 8
NumPut(&DefExt, OFN, Offset, "Ptr")
R := Mode = "S" ? DllCall("Comdlg32.dll\GetSaveFileNameW", "Ptr", &OFN, "UInt")
: DllCall("Comdlg32.dll\GetOpenFileNameW", "Ptr", &OFN, "UInt")
If !(R)
Return ""
DefFilter := NumGet(OFN, OffFilter, "UInt")
Return StrGet(&FileName)
}
JEE_ControlGetPosClient(hWnd, hCtl, ByRef vPosX, ByRef vPosY, ByRef vPosW, ByRef vPosH)
{
VarSetCapacity(RECT, 16, 0)
DllCall("GetWindowRect", Ptr,hCtl, Ptr,&RECT)
DllCall("MapWindowPoints", Ptr,0, Ptr,hWnd, Ptr,&RECT, UInt,2)
vPosX := NumGet(RECT, 0, "Int"), vPosY := NumGet(RECT, 4, "Int")
vPosW := NumGet(RECT, 8, "Int")-vPosX, vPosH := NumGet(RECT, 12, "Int")-vPosY
return
}
FindText(RE) {
Static FINDMSGSTRING := "commdlg_FindReplace"
, FR_DOWN := 1, FR_MATCHCASE := 4, FR_WHOLEWORD := 2
, Buf := "", FR := "", Len := 256
, FR_Size := A_PtrSize * 10
Text := RE.GetSelText()
VarSetCapacity(FR, FR_Size, 0)
NumPut(FR_Size, FR, 0, "UInt")
VarSetCapacity(Buf, Len, 0)
If (Text && !RegExMatch(Text, "\W"))
Buf := Text
Offset := A_PtrSize
NumPut(RE.GuiHwnd, FR, Offset, "UPtr")
OffSet += A_PtrSize * 2
NumPut(FR_DOWN, FR, Offset, "UInt")
OffSet += A_PtrSize
NumPut(&Buf, FR, Offset, "UPtr")
OffSet += A_PtrSize * 2
NumPut(Len,	FR, Offset, "Short")
This.FindTextProc("Init", RE.HWND, "")
OnMessage(DllCall("User32.dll\RegisterWindowMessage", "Str", FINDMSGSTRING), "RichEditDlgs.FindTextProc")
Return DllCall("Comdlg32.dll\FindTextW", "Ptr", &FR, "UPtr")
}
FindTextProc(L, M, H) {
Static FINDMSGSTRING := "commdlg_FindReplace"
, FR_DOWN := 1, FR_MATCHCASE := 4, FR_WHOLEWORD := 2 , FR_FINDNEXT := 0x8, FR_DIALOGTERM := 0x40
, HWND := 0
If (L = "Init") {
HWND := M
Return True
}
Flags := NumGet(L + 0, A_PtrSize * 3, "UInt")
If (Flags & FR_DIALOGTERM) {
OnMessage(DllCall("User32.dll\RegisterWindowMessage", "Str", FINDMSGSTRING), "")
ControlFocus, , ahk_id %HWND%
HWND := 0
Return
}
VarSetCapacity(CR, 8, 0)
SendMessage, 0x0434, 0, &CR, , ahk_id %HWND%
Min := (Flags & FR_DOWN) ? NumGet(CR, 4, "Int") : NumGet(CR, 0, "Int")
Max := (Flags & FR_DOWN) ? -1 : 0
OffSet := A_PtrSize * 4
Find := StrGet(NumGet(L + Offset, 0, "UPtr"))
VarSetCapacity(FTX, 16 + A_PtrSize, 0)
NumPut(Min, FTX, 0, "Int")
NumPut(Max, FTX, 4, "Int")
NumPut(&Find, FTX, 8, "Ptr")
SendMessage, 0x047C, %Flags%, &FTX, , ahk_id %HWND%
S := NumGet(FTX, 8 + A_PtrSize, "Int"), E := NumGet(FTX, 12 + A_PtrSize, "Int")
If (S = -1) && (E = -1)
MsgBox, 262208, Find, ಹುಡುಕುವ ಕಾರ್ಯ ಮುಗಿದಿದೆ..!
Else {
Min := (Flags & FR_DOWN) ? E : S
SendMessage, 0x0437, 0, % (&FTX + 8 + A_PtrSize), , ahk_id %HWND%
SendMessage, 0x00B7, 0, 0, , ahk_id %HWND%
}
}
PageSetup(RE) {
Static PSD_DEFAULTMINMARGINS             := 0x00000000
, PSD_INWININIINTLMEASURE           := 0x00000000
, PSD_MINMARGINS                    := 0x00000001
, PSD_MARGINS                       := 0x00000002
, PSD_INTHOUSANDTHSOFINCHES         := 0x00000004
, PSD_INHUNDREDTHSOFMILLIMETERS     := 0x00000008
, PSD_ENABLEMARGINS                := 0x00000010
, PSD_DISABLEPRINTER                := 0x00000020
, PSD_NOWARNING                     := 0x00000080
, PSD_DISABLEORIENTATION            := 0x00000100
, PSD_RETURNDEFAULT                 := 0x00000400
, PSD_ENABLEPAPER                  := 0x00000200
, PSD_SHOWHELP                      := 0x00000800
, PSD_DISABLEPAGESETUPHOOK           := 0x00002000
, PSD_DISABLEPAGESETUPTEMPLATE       := 0x00008000
, PSD_DISABLEPAGESETUPTEMPLATEHANDLE := 0x00020000
, PSD_DISABLEPAGEPAINTHOOK         := 0x00040000
, PSD_DISABLEPAGEPAINTING           := 0x00080000
, PSD_NONETWORKBUTTON               := 0x00200000
, I := 1000
, M := 2540
, Margins := {}
, Metrics := ""
, PSD_Size := (4 * 10) + (A_PtrSize * 11)
, PD_Size := (A_PtrSize = 8 ? (13 * A_PtrSize) + 16 : 66)
, OffFlags := 4 * A_PtrSize
, OffMargins := OffFlags + (4 * 7)
VarSetCapacity(PSD, PSD_Size, 0)
NumPut(PSD_Size, PSD, 0, "UInt")
NumPut(RE.GuiHwnd, PSD, A_PtrSize, "UPtr")
Flags := PSD_MARGINS | PSD_DISABLEPRINTER | PSD_DISABLEORIENTATION | PSD_DISABLEPAPER
NumPut(Flags, PSD, OffFlags, "Int")
Offset := OffMargins
NumPut(RE.Margins.L, PSD, Offset += 0, "Int")
NumPut(RE.Margins.T, PSD, Offset += 4, "Int")
NumPut(RE.Margins.R, PSD, Offset += 4, "Int")
NumPut(RE.Margins.B, PSD, Offset += 4, "Int")
If !DllCall("Comdlg32.dll\PageSetupDlg", "Ptr", &PSD, "UInt")
Return False
DllCall("Kernel32.dll\GobalFree", "Ptr", NumGet(PSD, 2 * A_PtrSize, "UPtr"))
DllCall("Kernel32.dll\GobalFree", "Ptr", NumGet(PSD, 3 * A_PtrSize, "UPtr"))
Flags := NumGet(PSD, OffFlags, "UInt")
Metrics := (Flags & PSD_INTHOUSANDTHSOFINCHES) ? I : M
Offset := OffMargins
RE.Margins.L := NumGet(PSD, Offset += 0, "Int")
RE.Margins.T := NumGet(PSD, Offset += 4, "Int")
RE.Margins.R := NumGet(PSD, Offset += 4, "Int")
RE.Margins.B := NumGet(PSD, Offset += 4, "Int")
RE.Margins.LT := Round((RE.Margins.L / Metrics) * 1440)
RE.Margins.TT := Round((RE.Margins.T / Metrics) * 1440)
RE.Margins.RT := Round((RE.Margins.R / Metrics) * 1440)
RE.Margins.BT := Round((RE.Margins.B / Metrics) * 1440)
Return True
}
ReplaceText(RE) {
Static FINDMSGSTRING := "commdlg_FindReplace"
, FR_DOWN := 1, FR_MATCHCASE := 4, FR_WHOLEWORD := 2
, FBuf := "", RBuf := "", FR := "", Len := 256
, FR_Size := A_PtrSize * 10
Text := RE.GetSelText()
VarSetCapacity(FBuf, Len, 0)
VarSetCapacity(RBuf, Len, 0)
VarSetCapacity(FR, FR_Size, 0)
NumPut(FR_Size, FR, 0, "UInt")
If (Text && !RegExMatch(Text, "\W"))
FBuf := Text
Offset := A_PtrSize
NumPut(RE.GuiHwnd, FR, Offset, "UPtr")
OffSet += A_PtrSize * 2
NumPut(FR_DOWN, FR, Offset, "UInt")
OffSet += A_PtrSize
NumPut(&FBuf, FR, Offset, "UPtr")
OffSet += A_PtrSize
NumPut(&RBuf, FR, Offset, "UPtr")
OffSet += A_PtrSize
NumPut(Len,	FR, Offset, "Short")
NumPut(Len,	FR, Offset + 2, "Short")
This.ReplaceTextProc("Init", RE.HWND, "")
OnMessage(DllCall("User32.dll\RegisterWindowMessage", "Str", FINDMSGSTRING), "RichEditDlgs.ReplaceTextProc")
Return DllCall("Comdlg32.dll\ReplaceText", "Ptr", &FR, "UPtr")
}
ReplaceTextProc(L, M, H) {
Static FINDMSGSTRING := "commdlg_FindReplace"
, FR_DOWN := 1, FR_MATCHCASE := 4, FR_WHOLEWORD := 2, FR_FINDNEXT := 0x8
, FR_REPLACE := 0x10, FR_REPLACEALL=0x20, FR_DIALOGTERM := 0x40
, HWND := 0, Min := "", Max := "", FS := "", FE := ""
, OffFind := A_PtrSize * 4, OffRepl := A_PtrSize * 5
If (L = "Init") {
HWND := M, FS := "", FE := ""
Return True
}
Flags := NumGet(L + 0, A_PtrSize * 3, "UInt")
If (Flags & FR_DIALOGTERM) {
OnMessage(DllCall("User32.dll\RegisterWindowMessage", "Str", FINDMSGSTRING), "")
ControlFocus, , ahk_id %HWND%
HWND := 0
Return
}
If (Flags & FR_REPLACE) {
IF (FS >= 0) && (FE >= 0) {
SendMessage, 0xC2, 1, % NumGet(L + 0, OffRepl, "UPtr" ), , ahk_id %HWND%
Flags |= FR_FINDNEXT
} Else {
Return
}
}
If (Flags & FR_FINDNEXT) {
VarSetCapacity(CR, 8, 0)
SendMessage, 0x0434, 0, &CR, , ahk_id %HWND%
Min := NumGet(CR, 4)
FS := FE := ""
Find := StrGet(NumGet(L + OffFind, 0, "UPtr"))
VarSetCapacity(FTX, 16 + A_PtrSize, 0)
NumPut(Min, FTX, 0, "Int")
NumPut(-1, FTX, 4, "Int")
NumPut(&Find, FTX, 8, "Ptr")
SendMessage, 0x047C, %Flags%, &FTX, , ahk_id %HWND%
S := NumGet(FTX, 8 + A_PtrSize, "Int"), E := NumGet(FTX, 12 + A_PtrSize, "Int")
If (S = -1) && (E = -1)
MsgBox, 262208, Replace, ಬದಲಿಸುವ ಕಾರ್ಯ ಮುಗಿದಿದೆ..!
Else {
SendMessage, 0x0437, 0, % (&FTX + 8 + A_PtrSize), , ahk_id %HWND%
SendMessage, 0x00B7, 0, 0, , ahk_id %HWND%
FS := S, FE := E
}
Return
}
If (Flags & FR_REPLACEALL) {
VarSetCapacity(CR, 8, 0)
SendMessage, 0x0434, 0, &CR, , ahk_id %HWND%
If (FS = "")
FS := FE := 0
DllCall("User32.dll\LockWindowUpdate", "Ptr", HWND)
Find := StrGet(NumGet(L + OffFind, 0, "UPtr"))
VarSetCapacity(FTX, 16 + A_PtrSize, 0)
NumPut(FS, FTX, 0, "Int")
NumPut(-1, FTX, 4, "Int")
NumPut(&Find, FTX, 8, "Ptr")
While (FS >= 0) && (FE >= 0) {
SendMessage, 0x044F, %Flags%, &FTX, , ahk_id %HWND%
FS := NumGet(FTX, A_PtrSize + 8, "Int"), FE := NumGet(FTX, A_PtrSize + 12, "Int")
If (FS >= 0) && (FE >= 0) {
SendMessage, 0x0437, 0, % (&FTX + 8 + A_PtrSize), , ahk_id %HWND%
SendMessage, 0xC2, 1, % NumGet(L + 0, OffRepl, "UPtr" ), , ahk_id %HWND%
NumPut(FE, FTX, 0, "Int")
}
}
SendMessage, 0x0437, 0, &CR, , ahk_id %HWND%
DllCall("User32.dll\LockWindowUpdate", "Ptr", 0)
Return
}
}
}
#NoEnv
DLL=%A_WinDir%\System32\shell32.dll
DLL2=%A_WinDir%\System32\Nudi icon.dll
SendMode, Input
GUI_RichNoteEditor()
return
NEWRichEdit:
GUI_RichNoteEditor()
return
GUI_RichNoteEditor(FileToOpen="")
{
global
SetBatchLines, -1
SetWinDelay, -1
SetControlDelay, -1
if !(GuiNum)
{
SBHelp := {"BTSTB": "ದಪ್ಪ   ಅಕ್ಷರ (Ctrl+B)"
, "BTSTI": "ಓರೆ ಅಕ್ಷರ (Ctrl+I)"
, "BTSTU": "ಗೆರೆ ಎಳೆ (Ctrl+U)"
, "BTSTS": "ಅಡ್ಡ ಗೆರೆ ಎಳೆ (Alt+S)"
, "BTSTH": "ಕ ^ (Ctrl+Shift+""+"")"
, "BTSTL": "ಕ _ (Ctrl+Shift+""+"")"
, "BTSTN": "ಸಾಮಾನ್ಯ (Alt+N)"
, "BTTXC": "ಅಕ್ಷರಗಳ ಬಣ್ಣ (Alt+T)"
, "BTBGC": "ಅಕ್ಷರಗಳ ಹಿಂಬದಿ ಬಣ್ಣ"
, "BTCHF": "ಅಕ್ಷರ ವಿನ್ಯಾಸ"
, "BTSIP": "ಅಕ್ಷರ ಗಾತ್ರ ಹಿಗ್ಗಿಸು"
, "BTSIM": "ಅಕ್ಷರ ಗಾತ್ರ ಕುಗ್ಗಿಸು"
, "BTTAL": "ಎಡಕ್ಕೆ ಹೊಂದಿಸು (Ctrl+L)"
, "BTTAC": "ಮಧ್ಯಕ್ಕೆ (Ctrl+E)"
, "BTTAR": "ಬಲಕ್ಕೆ ಹೊಂದಿಸು (Ctrl+R)"
, "BTTAJ": "ಸರಿಹೊಂದಿಸು (Ctrl+J)"
,"SBTSIM":"ಅರೋಹಣ"
,"DSBTSIM":"ಅವರೋಹಣ"
,"OpenN":"ಹೊಸದು ತೆರೆ (Ctrl+N)"
,"OpenO":"ಕಡತ ತೆರೆ (Ctrl+O)"
,"OpenS":"ಉಳಿಸು (Ctrl+S)"
,"OpenSs":"ಅಂತೆಉಳಿಸು (Ctrl+Alt+S)"
,"OpenC":"ಕತ್ತರಿಸು (Ctrl+X)"
,"OpenCp":"ನಕಲಿಸು (Ctrl+C)"
,"OpenP":"ಆಂಟಿಸು (Ctrl+V)"
,"Vundo":"ಹಿಂದಿನ ಹಾಗೆ ಮಾಡು (Ctrl+Z)"
,"Vredo":"ಮುಂಚಿನ ಹಾಗೆ ಮಾಡು (Ctrl+Y)"
,"Vykaya":"ವಾಕ್ಯಕ್ಕೆ ಮುಂಚೆ ಬಿಂದು ಸೇರಿಸು"
, "BTL10": "Linespacing 1 line (Ctrl+1)"
, "BTL15": "Linespacing 1,5 lines (Ctrl+5)"
, "BTL20": "Linespacing 2 lines (Ctrl+2)"}
Menu, Zoom, Add, 200 `%, Zoom
Menu, Zoom, Add, 150 `%, Zoom
Menu, Zoom, Add, 125 `%, Zoom
Menu, Zoom, Add, 100 `%, Zoom100
Menu, Zoom, Check, 100 `%
Menu, Zoom, Add, 75 `%, Zoom
Menu, Zoom, Add, 50 `%, Zoom
Menu, File, Add, &ಹೊಸ `tCtrl+N,NEWRichEdit
Menu, File, Add, &ತೆರೆ `tCtrl+O,FileOpen
Menu, File, Add, &ಉಳಿಸು `tCtrl+S,FileSave
Menu, File, Add, &ಅಂತೆ ಉಳಿಸು `tCtrl+Alt+S,FileSaveAs
Menu, File, Add
Menu, File, Add, &ಮುಚ್ಚು , RichEditGuiClose
Menu, File, Add, &ಪುಟದ ಅಂಚು ,PageSetup
Menu, File, Add, &ಮುದ್ರಿಸು `tCtrl+P,Print
Menu, File, Add
Menu, File, Add, &ಹೊರಕ್ಕೆ ,RichEditGuiClose
Menu, Edit, Add, &ಹಿಂದಿನ ಹಾಗೆ ಮಾಡು `tCtrl+Z, Undo
Menu, Edit, Add, &ಮೊದಲಿನ ಹಾಗೆ ಮಾಡು `tCtrl+Y, Redo
Menu, Edit, Add
Menu, Edit, Add, &ಕತ್ತರಿಸು `tCtrl+X, Cut
Menu, Edit, Add, &ನಕಲಿಸು `tCtrl+C, Copy
Menu, Edit, Add, &ಅಂಟಿಸು `tCtrl+V, Paste
Menu, Edit, Add
Menu, Edit, Add, &ಎಲ್ಲಾ ಆಯ್ಕೆ ಮಾಡು `tCtrl+A, SelALL
Menu, Edit, Add, &ಎಲ್ಲಾ ಆಯ್ಕೆ ರದ್ದು ಮಾಡು, Deselect
Menu, Search, Add, &ಹುಡುಕು `tCtrl+F, Find
Menu, Search, Add, &ಬದಲಿಸು , Replace
Menu, Alignment, Add, Align &left`tCtrl+L, AlignLeft
Menu, Alignment, Add, Align &center`tCtrl+E, AlignCenter
Menu, Alignment, Add, Align &right`tCtrl+R, AlignRight
Menu, Alignment, Add, Align &justified`tCtrl+J, AlignRight
Menu, Indentation, Add, &Set, Indentation
Menu, Indentation, Add, &Reset, ResetIndentation
Menu, LineSpacing, Add, 1 line`tCtrl+1, Spacing10
Menu, LineSpacing, Add, 1.5 lines`tCtrl+5, Spacing15
Menu, LineSpacing, Add, 2 lines`tCtrl+2, Spacing20
Menu, Numbering, Add, &ರಚಿಸು, Numbering
Menu, Numbering, Add, &ಎಲ್ಲಾ ಅಳಿಸು, ResetNumbering
Menu, Tabstops, Add, &Set Tabstops, SetTabstops
Menu, Tabstops, Add, &Reset to Default, ResetTabStops
Menu, Tabstops, Add
Menu, Tabstops, Add, Set &Default Tabs, SetDefTabs
Menu, ParaSpacing, Add, &Set, ParaSpacing
Menu, ParaSpacing, Add, &Reset, ResetParaSpacing
Menu, Paragraph, Add, &Alignment, :Alignment
Menu, Paragraph, Add, &Indentation, :Indentation
Menu, Paragraph, Add, &ವಿವಿದ ಆಯ್ಕೆಗಳು, :Numbering
Menu, Character, Add, &ಅಕ್ಷರ ವಿನ್ಯಾಸ, ChooseFont
Menu, TextColor, Add, &ಆಯ್ಕೆ, MTextColor
Menu, TextColor, Add, &ನಿರ್ದಿಷ್ಟ, MTextColor
Menu, Character, Add
Menu, Character, Add, &ಅಕ್ಷರಗಳ ಬಣ್ಣ, :TextColor
Menu, TextBkColor, Add, &ಆಯ್ಕೆ, MTextBkColor
Menu, TextBkColor, add, &ನಿರ್ದಿಷ್ಟ, MTextBkColor
Menu, Character, Add
Menu, Character, Add, &ಅಕ್ಷರ ಹಿಂಬದಿ ಬಣ್ಣ, :TextBkColor
Menu, Background, Add, &ಆಯ್ಕೆ, BackGroundColor
Menu, Background, Add, &ನಿರ್ದಿಷ್ಟ, BackgroundColor
Menu, Format, Add, &ಅಕ್ಷರ ಬಣ್ಣ ವಿನ್ಯಾಸ ,:Character
Menu, Format, Add
Menu, Format, Add, &ವಾಕ್ಯಪರಿಚ್ಛೇದ ,:Paragraph
Menu, Format, Add
MenuWordWrap := "&Word-wrap"
Menu, View, Add, %MenuWordWrap%, WordWrap
MenuWysiwyg := "Wrap as &printed"
Menu, View, Add, %MenuWysiwyg%, Wysiwyg
Menu, View, Add, &Linespacing, :LineSpacing
Menu, View, Add, &Space before/after, :ParaSpacing
Menu, View, Add, &Tabstops, :Tabstops
Menu, View, Add
Menu, View, Add, &Zoom, :Zoom
Menu, GuiMenu, Add
Menu, GuiMenu, Color, merun
Menu, GuiMenu,Add, &ಕಡತ , :File
Menu, GuiMenu, Add
Menu, GuiMenu, Add
Menu, GuiMenu, Add, &ಸಂಪಾದನೆ, :Edit
Menu, GuiMenu, Add
Menu, GuiMenu, Add
Menu, GuiMenu, Add, &ಹುಡುಕು, :Search
Menu, GuiMenu, Add
Menu, GuiMenu, Add
Menu, GuiMenu, Add, &ವಿನ್ಯಾಸ ಆಯ್ಕೆ, :Format
Menu, GuiMenu, Add
Menu, GuiMenu, Add
Menu, ContextMenu, Add, &ಕಡತ, :File
Menu, ContextMenu, Add
Menu, ContextMenu, Add, &ಸಂಪಾದನೆ, :Edit
Menu, ContextMenu, Add
Menu, ContextMenu, Add, &ಹುಡುಕು, :Search
Menu, ContextMenu, Add
Menu, ContextMenu, Add, &ವಿನ್ಯಾಸ ಆಯ್ಕೆ, :Format
Menu, ContextMenu, Add
Menu, Tray, NoStandard
menu, tray, add
menu, tray, add,ನಿಷ್ಕ್ರಿಯ ,testing
menu, tray, add
menu, tray, add,ಪುನಃಸ್ಥಾಪಿಸು ,testing1
menu, tray, add
menu, tray, add
Menu, Tray, Add , &ಹೊರಕ್ಕೆ, Exi
menu, tray, add
}
Menu, Tray, Icon,,, 1.
EditW := 800
EditH := 400
MarginX := 10
MarginY := 10
BackColor := "Auto"
FontName := "NudiParijatha"
FontSize := "14"
FontStyle := "N"
FontCharSet := 1
TextColor := "Auto"
TextBkColor := "Lime"
WordWrap := False
AutoURL := True
Zoom := "100 %"
ShowWysiwyg :=False
CurrentLine := 0
CurrentLineCount := 0
HasFocus := False
GuiNum=70
Gui %GuiNum%:Default
loop 20
{
try  Gui, Add, Statusbar
catch e
{
GuiNum := GuiNum + 1
if GuiNum=99
{
msgbox sorry but you cannot currently have more than 20 notes opened at the same time
exit
}
Gui %GuiNum%:Default
continue
}
break
}
GuiNumInstance:=GuiNum-69
CurrentGuiN:=GuiNum
if !(FileToOpen)
GuiTitle= ನುಡಿ ಕಡತ ನಂ°%GuiNumInstance%
else
GuiTitle := FileToOpen
Gui, +ReSize +MinSize400x200 +hwndGuiID
Gui %GuiNum%:+LabelRichEditGui
Num=3
Num1=4
Num2=7
Num3=281
Num4=260
Num5=55
Num6=261
Num8=39
Num9=247
Num10=248
SNumb=4
SNumb1=32
NNumb1=9
NNumb2=7
NNumb3=10
NNumb4=5
NNumb5=8
NNumb6=14
NNumb7=6
NNumb8=1
NNumb9=11
NNumb10=3
NNumb11=2
Gui, Menu, GuiMenu
Gui, Margin, %MarginX%, %MarginY%
Gui, Add, Pic,x+1 y+1  w35 h30 vOpenN Icon%Num% gIconn, %DLL%
Gui, Add, Pic,x+0 yp wp hp vOpenO Icon%Num1% gIconp, %DLL%
Gui, Add, Pic,x+0 yp wp hp vOpenS Icon%NNumb11% gIcons, %DLL2%
Gui, Add, Pic,x+2 yp wp hp vOpenSs Icon%NNumb10% gIcons, %DLL2%
Gui, Add, Pic,x+0 yp wp hp vOpenC Icon%Num4% gIconc, %DLL%
Gui, Add, Pic,x+0 yp wp hp vOpenCp Icon%Num5% gIconcp, %DLL%
Gui,Add,button,x+0 yp wp hp vOpenP gPaste1, 【P】
Gui, Add, Pic,x+0 yp wp hp vVundo Icon%NNumb1%  gUndo, %DLL2%
Gui, Add, Pic,x+0 yp wp hp vVredo Icon%NNumb2%  gRedo, %DLL2%
Gui, Font, Bold, Times New Roman
Gui, Add, Button, x+3 yp w25 h30 vBTSTB gSetFontStyle, &B
Gui, Font, Norm Italic
Gui, Add, Button, x+0 yp wp hp vBTSTI gSetFontStyle, &I
Gui, Font, Norm Underline
Gui, Add, Button, x+0 yp wp hp vBTSTU gSetFontStyle, &U
Gui, Font, Norm Strike
Gui, Add, Button, x+0 yp wp hp vBTSTS gSetFontStyle, &S
Gui, Font, Norm, Arial
Gui, Add, Button, x+0 yp wp hp vBTSTH gSetFontStyle, X ^
Gui, Add, Button, x+0 yp wp hp vBTSTL gSetFontStyle, X _
Gui, Add, Button, x+0 yp wp hp vBTSTN gSetFontStyle, &N
Gui, Add, Pic,x+5 yp w+25 hp vBTCHF Icon%Num8% gChooseFont, %DLL%
Gui, Add, Pic,x+5 yp w+25 hp vBTSIP Icon%Num9% gChangeSize, %DLL%
Gui, Add, Pic,x+5 yp w+25 hp vBTSIM Icon%Num10% gChangeSize, %DLL%
Gui,Menu,GuiMenu
Gui,Margin,%MarginX%,%MarginY%
Gui, Add, Text, xm y+5 w%EditW% h2 0x1000
Gui, Add, Pic, x10 y+3 w30 h25 vBTTAL Icon%NNumb3% gAlignLeft, %DLL2%
Gui, Add, Pic, x+0 yp wp hp vBTTAC Icon%NNumb4% gAlignCenter, %DLL2%
Gui, Add, Pic, x+0 yp wp hp vBTTAR Icon%NNumb5% gAlignRight, %DLL2%
Gui, Add, Pic, x+0 yp wp hp vBTTAJ Icon%NNumb6% gAlignJustify, %DLL2%
Gui, Add, Pic, x+0 yp wp hp vVykaya Icon%NNumb7% gNumbering, %DLL2%
Gui, Add, Pic, x+0 yp wp hp vSBTSIM Icon%NNumb8% gSorting, %DLL2%
Gui, Add, Pic, x+0 yp wp hp vDSBTSIM Icon%NNumb9% gDSorting, %DLL2%
Gui, Font, s12, NudiParijatha
try Gui, Add, Text, x+10 yp hp vT1,
GuiControlGet, T, Pos, T1
TX := EditW - TW + MarginX
GuiControl, Move, T1, x%TX%
Gui, Font, s10, Arial
Options := " x" . TX . " y" . TY . " w" . TW . " h" . TH
RE%GuiNum%1.AlignText("CENTER")
RE%GuiNum%1.SetOptions(["READONLY"], "SET")
Gui, Font, Norm, Arial
Gui, Font, s10, Arial
Gui,Add,button,x+16 yp w50 h30  vOpenH gHelpfile,Help
Gui, Font, s10, Arial
Gui,Add,button,x+18 yp w65 h30  vOpenH1 gHelpfileimg, Keyboard
Gui, Font, s14, NudiParijatha
Options := "x20 y+1 w" . EditW . " r5 gRE2MessageHandler"
RE%GuiNum%2 := New RichEdit(GuiNum, Options)
GuiControlGet, RE, Pos, % RE%GuiNum%2.HWND
RE%GuiNum%2.SetBkgndColor(BackColor)
RE%GuiNum%2.SetEventMask(["SELCHANGE"])
if (FileToOpen)
{
RE%GuiNum%2.LoadRTF(FileToOpen)
Open_File%GuiNum%:=FileToOpen
}
RE%GuiNum%2.AutoURL(1)
RE%GuiNum%2.WordWrap(1)
RE%GuiNum%2.SetModified()
Gui, Font
SB_SetParts(10, 200)
GuiW := GuiH := 0
Gui Show, , %GuiTitle%
OnMessage(WM_MOUSEMOVE := 0x200, "ShowSBHelp")
GuiControl, Focus, % RE%GuiNum%2.HWND
CurrentGuiN:=GuiNum
GoSub, UpdateGui
SetBatchLines, -1
SetWinDelay, -1
SetControlDelay, -1
}
ShowSBHelp() {
Global SBHelp, GuiNum
Static Current := 0
If (A_Gui = GuiNum) && (A_GuiControl <> Current)
SB_SetText(SBHelp[(Current := A_GuiControl)], 3)
Return
}
RE2MessageHandler:
If (A_Gui!=CurrentGuiN)
CurrentGuiN:=A_Gui
If (A_GuiEvent = "N") && (NumGet(A_EventInfo + 0, A_PtrSize * 2, "Int") = 0x0702)
{
SetTimer, UpdateGui, -10
}
Else {
If (A_EventInfo = 0x0100)
{
HasFocus := True
}
Else If (A_EventInfo = 0x0200)
{
HasFocus := False
}
}
Return
#If (HasFocus)
^!b::
^!h::
^!i::
^!l::
^!n::
^!p::
^!s::
^!u::
RE%CurrentGuiN%2.ToggleFontStyle(SubStr(A_ThisHotkey, 3))
GoSub, UpdateGui
Return
#If
UpdateGui:
Font := RE%CurrentGuiN%2.GetFont()
If (FontName != Font.Name || FontCharset != Font.CharSet || FontStyle != Font.Style || FontSize != Font.Size
|| TextColor != Font.Color || TextBkColor != Font.BkColor) {
FontStyle := Font.Style
TextColor := Font.Color
TextBkColor := Font.BkColor
FontCharSet := Font.CharSet
If (FontName != Font.Name) {
FontName := Font.Name
GuiControl, , FNAME, %FontName%
}
If (FontSize != Font.Size) {
FontSize := Round(Font.Size)
GuiControl, , FSIZE, %FontSize%
}
Font.Size := 8
RE%CurrentGuiN%1.SetSel(0, -1)
RE%CurrentGuiN%1.SetFont(Font)
RE%CurrentGuiN%1.SetSel(0, 0)
}
Stats := RE%CurrentGuiN%2.GetStatistics()
Gui %CurrentGuiN%:Default
Return
RichEditGuiClose:
If RE%CurrentGuiN%2.IsModified()
{
Gui, +OwnDialogs
MsgBox, 35, Close File, Content has been modified!`nDo you want to save changes?
IfMsgBox, Cancel
{
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
}
IfMsgBox, Yes
GoSub, FileSave
}
If IsObject(RE%CurrentGuiN%1)
RE%CurrentGuiN%1 := ""
If IsObject(RE%CurrentGuiN%2)
RE%CurrentGuiN%2 := ""
Gui, %A_Gui%:Destroy
ExitApp
return
RichEditGuiSize:
Critical
If (A_EventInfo = 1)
Return
If (GuiW = 0) {
GuiW := A_GuiWidth
GuiH := A_GuiHeight
Return
}
If (A_GuiWidth != GuiW || A_GuiHeight != GuiH) {
REW += A_GuiWidth - GuiW
REH += A_GuiHeight - GuiH
GuiControl, Move, % RE%CurrentGuiN%2.HWND, w%REW% h%REH%
GuiW := A_GuiWidth
GuiH := A_GuiHeight
}
Return
RichEditGuiContextMenu:
CurrentGuiN:=A_Gui
MouseGetPos, , , , HControl, 2
WinGetClass, Class, ahk_id %HControl%
If (Class = RichEdit.Class)
Menu, ContextMenu, Show
Return
SetFontStyle:
RE%CurrentGuiN%2.ToggleFontStyle(SubStr(A_GuiControl, 0))
GoSub, UpdateGui
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
ChangeSize:
Size := RE%CurrentGuiN%2.ChangeFontSize(SubStr(A_GuiControl, 0) = "P" ? 1 : -1)
GoSub, UpdateGui
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
testing:
Suspend
if (A_IsSuspended)
{
if (singlef = 1)
SendInput, {U+200C}
flagszero()
menu, tray, ToggleCheck, ನಿಷ್ಕ್ರಿಯ
}
else
{
flagszero()
menu, tray, ToggleCheck, ನಿಷ್ಕ್ರಿಯ
}
flagszero()
return
testing1:
reload
menu, tray, ToggleCheck, ಪುನಃಸ್ಥಾಪಿಸು
menu, tray, Enable,ನಿಷ್ಕ್ರಿಯ
return
Exi:
ExitApp
Return
FileAppend:
FileInsert:
FileOpen:
If (File := RichEditDlgs.FileDlg(RE%CurrentGuiN%2, "O")) {
RE%CurrentGuiN%2.LoadFile(File, SubStr(A_ThisLabel, 5))
If (A_ThisLabel = "FileOpen") {
Gui, +LastFound
WinGetTitle, Title
StringSplit, Title, Title, -, %A_Space%
WinSetTitle, %Title1% - %File%
Open_File%CurrentGuiN% := File
}
GoSub, UpdateGui
}
RE%CurrentGuiN%2.SetModified()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
FileClose:
If (Open_File%CurrentGuiN%) {
If RE%CurrentGuiN%2.IsModified() {
Gui, +OwnDialogs
MsgBox, 35, Close File, Content has been modified!`nDo you want to save changes?
IfMsgBox, Cancel
{
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
}
IfMsgBox, Yes
GoSub, FileSave
}
If RE%CurrentGuiN%2.SetText() {
Gui, +LastFound
WinGetTitle, Title
StringSplit, Title, Title, -, %A_Space%
WinSetTitle, %Title1%
Open_File%CurrentGuiN% := ""
}
GoSub, UpdateGui
}
RE%CurrentGuiN%2.SetModified()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
FileSave:
If !(Open_File%CurrentGuiN%) {
GoSub, FileSaveAs
Return
}
RE%CurrentGuiN%2.SaveFile(Open_File%CurrentGuiN%)
RE%CurrentGuiN%2.SetModified()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
FileSaveAs:
If (File := RichEditDlgs.FileDlg(RE%CurrentGuiN%2, "S")) {
RE%CurrentGuiN%2.SaveFile(File)
Gui, +LastFound
WinGetTitle, Title
StringSplit, Title, Title, -, %A_Space%
WinSetTitle, %Title1% - %File%
Open_File%CurrentGuiN% := File
}
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
PageSetup:
RichEditDlgs.PageSetup(RE%CurrentGuiN%2)
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Print:
RE%CurrentGuiN%2.Print()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Undo:
RE%CurrentGuiN%2.Undo()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Redo:
RE%CurrentGuiN%2.Redo()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Cut:
RE%CurrentGuiN%2.Cut()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Copy:
RE%CurrentGuiN%2.Copy()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Paste:
RE%CurrentGuiN%2.Paste()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Clear:
RE%CurrentGuiN%2.Clear()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
SelAll:
RE%CurrentGuiN%2.SelAll()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Deselect:
RE%CurrentGuiN%2.Deselect()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
WordWrap:
WordWrap ^= True
RE%CurrentGuiN%2.WordWrap(WordWrap)
Menu, %A_ThisMenu%, ToggleCheck, %A_ThisMenuItem%
If (WordWrap)
Menu, %A_ThisMenu%, Disable, %MenuWysiwyg%
Else
Menu, %A_ThisMenu%, Enable, %MenuWysiwyg%
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Zoom:
Zoom100:
Menu, Zoom, UnCheck, %Zoom%
If (A_ThisLabel = "Zoom100")
Zoom := "100 %"
Else
Zoom := A_ThismenuItem
Menu, Zoom, Check, %Zoom%
RegExMatch(Zoom, "\d+", Ratio)
RE%CurrentGuiN%2.SetZoom(Ratio)
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
WYSIWYG:
ShowWysiwyg ^= True
If (ShowWysiwyg)
GoSub, Zoom100
RE%CurrentGuiN%2.WYSIWYG(ShowWysiwyg)
Menu, %A_ThisMenu%, ToggleCheck, %A_ThisMenuItem%
If (ShowWysiwyg)
Menu, %A_ThisMenu%, Disable, %MenuWordWrap%
Else
Menu, %A_ThisMenu%, Enable, %MenuWordWrap%
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
BackgroundColor:
If InStr(A_ThisMenuItem, "Auto")
RE%CurrentGuiN%2.SetBkgndColor("Auto")
Else If ((NC := RichEditDlgs.ChooseColor(RE%CurrentGuiN%2, BackColor)) <> "")
RE%CurrentGuiN%2.SetBkgndColor(BackColor := BGC := NC)
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
AutoURLDetection:
RE%CurrentGuiN%2.AutoURL(AutoURL ^= True)
Menu, %A_ThisMenu%, ToggleCheck, %A_ThisMenuItem%
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
ChooseFont:
RichEditDlgs.ChooseFont(RE%CurrentGuiN%2)
Font := RE%CurrentGuiN%2.GetFont()
Gui, ListView, FNAME
LV_Modify(1, "", Font.Name)
Gui, ListView, FSIZE
LV_Modify(1, "", Font.Size)
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
MTextColor:
BTextColor:
If (A_ThisLabel = "MTextColor") && InStr(A_ThisMenuItem, "Auto")
RE%CurrentGuiN%2.SetFont({Color: "Auto"}), TXC := ""
Else If (StrLen(NC := RichEditDlgs.ChooseColor(RE%CurrentGuiN%2, "T")) <> "")
RE%CurrentGuiN%2.SetFont({Color: NC}), TXC := NC
ControlFocus,, % "ahk_id " . RE%CurrentGuiN%2.HWND
Return
MTextBkColor:
BTextBkColor:
If (A_ThisLabel = "MTextBkColor") && InStr(A_ThisMenuItem, "Auto")
RE%CurrentGuiN%2.SetFont({BkColor: "Auto"}), TBC := ""
Else If (StrLen(NC := RichEditDlgs.ChooseColor(RE%CurrentGuiN%2, "B")) <> "")
RE%CurrentGuiN%2.SetFont({BkColor: NC}), TBC := NC
ControlFocus,, % "ahk_id " . RE%CurrentGuiN%2.HWND
Return
AlignLeft:
AlignCenter:
AlignRight:
AlignJustify:
RE%CurrentGuiN%2.AlignText({AlignLeft: 1, AlignRight: 2, AlignCenter: 3, AlignJustify: 4}[A_ThisLabel])
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Indentation:
ParaIndentGui(RE%CurrentGuiN%2)
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
ResetIndentation:
RE%CurrentGuiN%2.SetParaIndent()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Numbering:
ParaNumberingGui(RE%CurrentGuiN%2)
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
ResetNumbering:
RE%CurrentGuiN%2.SetParaNumbering()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
ParaSpacing:
ParaSpacingGui(RE%CurrentGuiN%2)
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
ResetParaSpacing:
RE%CurrentGuiN%2.SetParaSpacing()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Spacing10:
Spacing15:
Spacing20:
RegExMatch(A_ThisLabel, "\d+$", S)
RE%CurrentGuiN%2.SetLineSpacing(S / 10)
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Sorting:
Clipboard =
Send ^c
ClipWait 2
if ErrorLevel
return
Sort Clipboard,CL,A-Z
Send {LCtrl Down}v{LCtrl Up}
MsgBox ಆರೋಹಣ ಕ್ರಮ ಮುಗಿದಿದೆ
Return
DSorting:
Clipboard =
Send ^c
ClipWait 2
if ErrorLevel
return
Sort, Clipboard,R,CL
Send {LCtrl Down}v{LCtrl Up}
MsgBox ಅವರೋಹಣ ಕ್ರಮ ಮುಗಿದಿದೆ
return
return
SetTabStops:
SetTabStopsGui(RE%CurrentGuiN%2)
Return
ResetTabStops:
RE%CurrentGuiN%2.SetTabStops()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
SetDefTabs:
RE%CurrentGuiN%2.SetDefaultTabs(1)
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Find:
RichEditDlgs.FindText(RE%CurrentGuiN%2)
Return
Replace:
RichEditDlgs.ReplaceText(RE%CurrentGuiN%2)
Return
ParaIndentGui(RE) {
Static Owner := ""
, Success := False
Metrics := RE.GetMeasurement()
PF2 := RE.GetParaFormat()
Owner := RE.GuiName
Gui, ParaIndentGui: New
Gui, +Owner%Owner% +ToolWindow +LastFound +LabelParaIndentGui
Gui, Margin, 20, 10
Gui, Add, Text, Section h20 0x200, First line left indent (absolute):
Gui, Add, Text, xs hp 0x200, Other lines left indent (relative):
Gui, Add, Text, xs hp 0x200, All lines right indent (absolute):
Gui, Add, Edit, ys hp Limit5 hwndhLeft1
Gui, Add, Edit, hp Limit6 hwndhLeft2
Gui, Add, Edit, hp Limit5 hwndhRight
Left1 := Round((PF2.StartIndent / 1440) * Metrics, 2)
If (Metrics = 2.54)
Left1 := RegExReplace(Left1, "\.", ",")
GuiControl, , %hLeft1%, %Left1%
Left2 := Round((PF2.Offset / 1440) * Metrics, 2)
If (Metrics = 2.54)
Left2 := RegExReplace(Left2, "\.", ",")
GuiControl, , %hLeft2%, %Left2%
Right := Round((PF2.RightIndent / 1440) * Metrics, 2)
If (Metrics = 2.54)
Right := RegExReplace(Right, "\.", ",")
GuiControl, , %hRight%, %Right%
Gui, Add, Button, xs gParaIndentGuiApply hwndhBtn1, Apply
Gui, Add, Button, x+10 yp gParaIndentGuiClose hwndhBtn2, Cancel
GuiControlGet, B, Pos, %hBtn2%
GuiControl, Move, %hBtn1%, w%BW%
GuiControlGet, E, Pos, %hLeft1%
GuiControl, Move, %hBtn2%, % "x" . (EX + EW - BW)
Gui, %Owner%:+Disabled
Gui, Show, , Paragraph Indentation
WinWaitActive
WinWaitClose
Return Success
ParaIndentGuiClose:
Success := False
Gui, %Owner%:-Disabled
Gui, Destroy
Return
ParaIndentGuiApply:
GuiControlGet, Start, , %hLeft1%
If !RegExMatch(Start, "^\d{1,2}((\.|,)\d{1,2})?$") {
GuiControl, , %hLeft1%
GuiControl, Focus, %hLeft1%
Return
}
GuiControlGet, Offset, , %hLeft2%
If !RegExMatch(Offset, "^(-)?\d{1,2}((\.|,)\d{1,2})?$") {
GuiControl, , %hLeft2%
GuiControl, Focus, %hLeft2%
Return
}
GuiControlGet, Right, , %hRight%
If !RegExMatch(Right, "^\d{1,2}((\.|,)\d{1,2})?$") {
GuiControl, , %hRight%
GuiControl, Focus, %hRight%
Return
}
Success := RE.SetParaIndent({Start: Start, Right: Right, Offset: Offset})
Gui, %Owner%:-Disabled
Gui, Destroy
Return
}
ParaNumberingGui(RE) {
Static Owner := ""
, Bullet := "•"
, PFN := ["Bullet", "Arabic", "LCLetter", "UCLetter", "LCRoman", "UCRoman"]
, PFNS := ["Paren", "Parens", "Period", "Plain", "None"]
, Success := False
Metrics := RE.GetMeasurement()
PF2 := RE.GetParaFormat()
Owner := RE.GuiName
Gui, ParaNumberingGui: New
Gui, +Owner%Owner% +ToolWindow +LastFound +LabelParaNumberingGui
Gui, Margin, 30, 15
Gui, Font, s12, arial
Gui, Add, Text, Section h20 w100 0x200, ವಿದಗಳು:
Gui, Add, DDL, xp y+0 wp AltSubmit hwndhType, %Bullet%|0, 1, 2|a, b, c|A, B, C|i, ii, iii|I, I, III
If (PF2.Numbering)
GuiControl, Choose, %hType%, % PF2.Numbering
Gui, Add, Text, xs h20 w100 0x200, ಪ್ರಾರಭಿಸು:
Gui, Add, Edit, y+0 wp hp Limit5 hwndhStart
GuiControl, , %hStart%, % PF2.NumberingStart
Gui, Add, Text, ys h20 w100 0x200, ವಿನ್ಯಾಸಗಳು:
Gui, Add, DDL, y+0 wp AltSubmit hwndhStyle Choose1, 1)|(1)|1.|1|
If (PF2.NumberingStyle)
GuiControl, Choose, %hStyle%, % ((PF2.NumberingStyle // 0x0100) + 1)
Gui, Add, Text, h20 w100 0x200, % "ದೂರ ವಿದಿಸು:  (" . (Metrics = 1.00 ? "in." : "cm") . ")"
Gui, Add, Edit, y+0 wp hp Limit5 hwndhDist
Tab := Round((PF2.NumberingTab / 1440) * Metrics, 2)
If (Metrics = 2.54)
Tab := RegExReplace(Tab, "\.", ",")
GuiControl, , %hDist%, %tab%
Gui, Add, Button, xs gParaNumberingGuiApply hwndhBtn1, ಅಳವಡಿಸು
Gui, Add, Button, x+10 yp gParaNumberingGuiClose hwndhBtn2, ರದ್ದು ಮಾಡು
GuiControlGet, B, Pos, %hBtn2%
GuiControl, Move, %hBtn1%, w%BW%
GuiControlGet, D, Pos, %hStyle%
GuiControl, Move, %hBtn2%, % "x" . (DX + DW - BW)
Gui, %Owner%:+Disabled
Gui, Show, ,  ಪರಿಚ್ಛೇದ ಬಿಂದುಗಳ ಆಯ್ಕೆ
WinWaitActive
WinWaitClose
Return Success
ParaNumberingGuiClose:
Success := False
Gui, %Owner%:-Disabled
Gui, Destroy
Return
ParaNumberingGuiApply:
GuiControlGet, Type, , %hType%
GuiControlGet, Style, , %hStyle%
GuiControlGet, Start, , %hStart%
GuiControlGet, Tab, , %hDist%
If !RegExMatch(Tab, "^\d{1,2}((\.|,)\d{1,2})?$") {
GuiControl, , %hDist%
GuiControl, Focus, %hDist%
Return
}
Numbering := {Type: PFN[Type], Style: PFNS[Style]}
Numbering.Tab := RegExReplace(Tab, ",", ".")
Numbering.Start := Start
Success := RE.SetParaNumbering(Numbering)
Gui, %Owner%:-Disabled
Gui, Destroy
Return
}
ParaSpacingGui(RE) {
Static Owner := ""
, Success := False
PF2 := RE.GetParaFormat()
Owner := RE.GuiName
Gui, ParaSpacingGui: New
Gui, +Owner%Owner% +ToolWindow +LastFound +LabelParaSpacingGui
Gui, Margin, 20, 10
Gui, Add, Text, Section h20 0x200, Space before in points:
Gui, Add, Text, xs y+10 hp 0x200, Space after in points:
Gui, Add, Edit, ys hp hwndhBefore Number Limit2 Right, 00
GuiControl, , %hBefore%, % (PF2.SpaceBefore // 20)
Gui, Add, Edit, xp y+10 hp hwndhAfter Number Limit2 Right, 00
GuiControl, , %hAfter%, % (PF2.SpaceAfter // 20)
Gui, Add, Button, xs gParaSpacingGuiApply hwndhBtn1, Apply
Gui, Add, Button, x+10 yp gParaSpacingGuiClose hwndhBtn2, Cancel
GuiControlGet, B, Pos, %hBtn2%
GuiControl, Move, %hBtn1%, w%BW%
GuiControlGet, E, Pos, %hAfter%
X := EX + EW - BW
GuiControl, Move, %hBtn2%, x%X%
Gui, %Owner%:+Disabled
Gui, Show, , Paragraph Spacing
WinWaitActive
WinWaitClose
Return Success
ParaSpacingGuiClose:
Success := False
Gui, %Owner%:-Disabled
Gui, Destroy
Return
ParaSpacingGuiApply:
GuiControlGet, Before, , %hBefore%
GuiControlGet, After, , %hAfter%
Success := RE.SetParaSpacing({Before: Before, After: After})
Gui, %Owner%:-Disabled
Gui, Destroy
Return
}
SetTabStopsGui(RE) {
Static Owner   := ""
, Metrics := 0
, MinTab  := 0.30
, MaxTab  := 8.30
, AL := 0x00000000
, AC := 0x01000000
, AR := 0x02000000
, AD := 0x03000000
, Align := {0x00000000: "L", 0x01000000: "C", 0x02000000: "R", 0x03000000: "D"}
, TabCount := 0
, MAX_TAB_STOPS := 32
, Success := False
Metrics := RE.GetMeasurement()
PF2 := RE.GetParaFormat()
TL := ""
TabCount := PF2.TabCount
Tabs := PF2.Tabs
Loop, %TabCount% {
Tab := Tabs[A_Index]
TL .= Round(((Tab & 0x00FFFFFF) * Metrics) / 1440, 2) . ":" . (Tab & 0xFF000000) . "|"
}
If (TabCount)
TL := SubStr(TL, 1, -1)
Owner := RE.GuiName
Gui, SetTabStopsGui: New
Gui, +Owner%Owner% +ToolWindow +LastFound +LabelSetTabStopsGui
Gui, Margin, 10, 10
Gui, Add, Text, Section, % "Position: (" . (Metrics = 1.00 ? "in." : "cm") . ")"
Gui, Add, ComboBox, xs y+2 w120 r6 Simple +0x800 hwndCBBID AltSubmit gSetTabStopsGuiSelChanged
If (TabCount) {
Loop, Parse, TL, |
{
StringSplit, T, A_LoopField, :
SendMessage, 0x0143, 0, &T1, , ahk_id %CBBID%
SendMessage, 0x0151, ErrorLevel, T2, , ahk_id %CBBID%
}
}
Gui, Add, Text, ys Section, Alignment:
Gui, Add, Radio, xs w60 Section y+2 hwndRLID Checked Group, Left
Gui, Add, Radio, wp hwndRCID, Center
Gui, Add, Radio, ys wp hwndRRID, Right
Gui, Add, Radio, wp hwndRDID, Decimal
Gui, Add, Button, xs Section w60 gSetTabStopsGuiAdd Disabled hwndBTADDID, &Add
Gui, Add, Button, ys w60 gSetTabStopsGuiRemove Disabled hwndBTREMID, &Remove
GuiControlGet, P1, Pos, %BTADDID%
GuiControlGet, P2, Pos, %BTREMID%
W := P2X + P2W - P1X
Gui, Add, Button, xs w%W% gSetTabStopsGuiRemoveAll hwndBTCLAID, &Clear all
Gui, Add, Text, xm h5
Gui, Add, Button, xm y+0 w60 gSetTabStopsGuiOK, &OK
X := P2X + P2W - 60
Gui, Add, Button, x%X% yp wp gSetTabStopsGuiClose, &Cancel
Gui, %Owner%:+Disabled
Gui, Show, , Set Tabstops
WinWaitActive
WinWaitClose
Return Success
SetTabStopsGuiClose:
Success := False
Gui, %Owner%:-Disabled
Gui, Destroy
Return
SetTabStopsGuiSelChanged:
If (TabCount < MAX_TAB_STOPS) {
GuiControlGet, T, , %CBBID%, Text
If RegExMatch(T, "^\s*$")
GuiControl, Disable, %BTADDID%
Else
GuiControl, Enable, %BTADDID%
}
SendMessage, 0x0147, 0, 0, , ahk_id %CBBID%
I := ErrorLevel
If (I > 0x7FFFFFFF) {
GuiControl, Disable, %BTREMID%
Return
}
GuiControl, Enable, %BTREMID%
SendMessage, 0x0150, I, 0, , ahk_id %CBBID%
A := ErrorLevel
C := A = AC ? RCID : A = AR ? RRID : A = AD ? RDID : RLID
GuiControl, , %C%, 1
Return
SetTabStopsGuiAdd:
GuiControlGet, T, ,%CBBID%, Text
If !RegExMatch(T, "^\d*[.,]?\d+$") {
GuiControl, Focus, %CBBID%
Return
}
StringReplace, T, T, `,, .
T := Round(T, 2)
If (Round(T / Metrics, 2) < MinTab) {
GuiControl, Focus, %CBBID%
Return
}
If (Round(T / Metrics, 2) > MaxTab) {
GuiControl, Focus, %CBBID%
Return
}
GuiControlGet, RL, , %RLID%
GuiControlGet, RC, , %RCID%
GuiControlGet, RR, , %RRID%
GuiControlGet, RD, , %RDID%
A := RC ? AC : RR ? AR : RD ? AD : AL
ControlGet, TL, List, , , ahk_id %CBBID%
P := -1
Loop, Parse, TL, `n
{
If (T < A_LoopField) {
P := A_Index - 1
Break
}
IF (T = A_LoopField) {
P := A_Index - 1
SendMessage, 0x0144, P, 0, , ahk_id %CBBID%
Break
}
}
SendMessage, 0x014A, P, &T, , ahk_id %CBBID%
SendMessage, 0x0151, ErrorLevel, A, , ahk_id %CBBID%
TabCount++
If !(TabCount < MAX_TAB_STOPS)
GuiControl, Disable, %BTADDID%
GuiControl, Text, %CBBID%
GuiControl, Focus, %CBBID%
Return
SetTabStopsGuiRemove:
SendMessage, 0x0147, 0, 0, , ahk_id %CBBID%
I := ErrorLevel
If (I > 0x7FFFFFFF)
Return
SendMessage, 0x0144, I, 0, , ahk_id %CBBID%
GuiControl, Text, %CBBID%
TabCount--
GuiControl, , %RLID%, 1
GuiControl, Focus, %CBBID%
Return
SetTabStopsGuiRemoveAll:
GuiControl, , %CBBID%, |
TabCount := 0
GuiControl, , %RLID%, 1
GuiControl, Focus, %CBBID%
Return
SetTabStopsGuiOK:
SendMessage, 0x0146, 0, 0, , ahk_id %CBBID%
If ((TabCount := ErrorLevel) > 0x7FFFFFFF)
Return
If (TabCount > 0) {
ControlGet, TL, List, , , ahk_id %CBBID%
TabStops := {}
Loop, Parse, TL, `n
{
SendMessage, 0x0150, A_Index - 1, 0, , ahk_id %CBBID%
TabStops[A_LoopField * 100] := Align[ErrorLevel]
}
}
Success := RE.SetTabStops(TabStops)
Gui, %Owner%:-Disabled
Gui, Destroy
Return
}
Iconn:
GUI_RichNoteEditor()
return
Iconp:
If (File := RichEditDlgs.FileDlg(RE%CurrentGuiN%2, "O")) {
RE%CurrentGuiN%2.LoadFile(File, SubStr(A_ThisLabel, 5))
If (A_ThisLabel = "FileOpen") {
Gui, +LastFound
WinGetTitle, Title
StringSplit, Title, Title, -, %A_Space%
WinSetTitle, %Title1% - %File%
Open_File%CurrentGuiN% := File
}
GoSub, UpdateGui
}
RE%CurrentGuiN%2.SetModified()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Icons:
If !(Open_File%CurrentGuiN%) {
GoSub, FileSaveAs
Return
}
RE%CurrentGuiN%2.SaveFile(Open_File%CurrentGuiN%)
RE%CurrentGuiN%2.SetModified()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Iconc:
RE%CurrentGuiN%2.Cut()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Iconcp:
RE%CurrentGuiN%2.Copy()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Paste1:
RE%CurrentGuiN%2.Paste()
GuiControl, Focus, % RE%CurrentGuiN%2.HWND
Return
Helpfile:
Run, Open "Nudi 6.1 Help file.doc"
Return
Helpfileimg:
Run, Open "New KEYBOARD.gif"
Return
FileEncoding, UTF-16
SendMode Input
SetWorkingDir %A_ScriptDir%
#EscapeChar \
#InstallKeybdHook
#KeyHistory MaxEvents
SetBatchLines, -1
#SingleInstance Force
Return
global flag = 0,wistle = 0,doubleff = 0,singlef = 0,swaraflag = 0,position = 0,bar := 0,oldclip := 0,kai = 0,car := 0,shiftflag = 0,vyanjanaflag = 0,capsflag = 0,special = 0,leftshiftflag = 0, rightshiftflag = 0,symbols = 0,saflag = 0,kAAA = 0,singlef1 = 0,vyanjanaflag1 = 0,kaAAA = 0,gAAA = 0,gaAAA = 0,zaAAA = 0,cAAA = 0,caAAA = 0,jAAA = 0,jaAAA = 0,zAAA = 0,qAAA = 0,qaAAA = 0,wAAA = 0,waAAA = 0,naAAA = 0,tAAA = 0,taAAA = 0,dAAA = 0,daAAA = 0,nAAA = 0,pAAA = 0,paAAA = 0,bAAA = 0,baAAA = 0,mAAA = 0,yAAA = 0,rAAA = 0,lAAA = 0,vAAA = 0,saAAA = 0,xAAA = 0,sAAA = 0,hAAA = 0,laAAA = 0,hlAAA = 0,hrAAA = 0,hrrpc = 0,hlrpc =0
$>#Space::
Suspend
if (A_IsSuspended)
{
if (singlef = 1)
SendInput, {U+200C}
flagszero()
menu, tray, ToggleCheck, ನಿಷ್ಕ್ರಿಯ
}
else
{
flagszero()
menu, tray, ToggleCheck, ನಿಷ್ಕ್ರಿಯ
}
flagszero()
return
$<#Space::
Suspend
if (A_IsSuspended)
{
if (singlef = 1)
SendInput, {U+200C}
flagszero()
menu, tray, ToggleCheck, ನಿಷ್ಕ್ರಿಯ
}
else
{
flagszero()
menu, tray, ToggleCheck, ನಿಷ್ಕ್ರಿಯ
}
flagszero()
return
#if GetKeyState("CapsLock","T")
4::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+20B9}
return
0::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0c81}
return
1::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0306}
return
2::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0304}
return
,::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {left}{U+0327}{right}
return
-::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0332}
return
3::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {left}{U+0333}{right}
return
5::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+093A}
return
6::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+1CDA}
return
7::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+093C}
return
'::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0301}
return
8::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {Left}{U+0307}{right}
return
9::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {Left}{U+0308}{right}
return
.::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0324}
return
a::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0061}
return
>+A::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0041}
return
<+A::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0041}
return
b::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0062}
return
>+B::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0042}
return
<+B::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0042}
return
c::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0063}
return
>+C::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0043}
return
<+C::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0043}
return
d::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0064}
return
>+D::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0044}
return
<+D::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0044}
return
e::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0065}
return
>+E::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0045}
return
<+E::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0045}
return
f::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0066}
return
>+F::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0046}
return
<+F::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0046}
return
g::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0067}
return
>+G::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0047}
return
<+G::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0047}
return
h::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0068}
return
>+H::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0048}
return
<+H::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0048}
return
i::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0069}
return
>+I::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0049}
return
<+I::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0049}
return
j::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+006A}
return
>+J::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+004A}
return
<+J::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+004A}
return
k::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+006B}
return
>+K::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+004B}
return
<+K::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+004B}
return
l::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+006C}
return
>+L::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+004C}
return
<+L::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+004C}
return
m::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+006D}
return
>+M::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+004D}
return
<+M::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+004D}
return
n::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+006E}
return
>+N::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+004E}
return
<+N::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+004E}
return
o::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+006F}
return
>+O::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+004F}
return
<+O::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+004F}
return
p::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0070}
return
>+P::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0050}
return
<+P::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0050}
return
q::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0071}
return
>+q::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0051}
return
<+q::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0051}
return
r::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0072}
return
>+R::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0052}
return
<+R::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0052}
return
s::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0073}
return
>+S::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0053}
return
<+S::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0053}
return
t::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0074}
return
>+T::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0054}
return
<+T::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0054}
return
u::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0075}
return
>+U::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0055}
return
<+U::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0055}
return
v::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0076}
return
>+V::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0056}
return
<+V::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0056}
return
w::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0077}
return
>+W::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0057}
return
<+W::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0057}
return
x::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0078}
return
>+X::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0058}
return
<+X::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0058}
return
y::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0079}
return
>+Y::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0059}
return
<+Y::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0059}
return
z::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+007A}
return
>+Z::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+005A}
return
<+Z::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+005A}
return
#if GetKeyState("ScrollLock","T")
1::
flagszero()
SendInput, {U+0031}
return
2::
flagszero()
SendInput, {U+0032}
return
3::
flagszero()
SendInput, {U+0033}
return
4::
flagszero()
SendInput, {U+0034}
return
5::
flagszero()
SendInput, {U+0035}
return
6::
flagszero()
SendInput, {U+0036}
return
7::
flagszero()
SendInput, {U+0037}
return
8::
flagszero()
SendInput, {U+0038}
return
9::
flagszero()
SendInput, {U+0039}
return
0::
flagszero()
SendInput, {U+0030}
return
#If
$BackSpace::
flagszero()
SendInput {BS}
return
#If
#If GetKeyState("NumLock","T")
#If
$LShift::
capsflag = 1
leftshiftflag = 1
shiftflag = 0
$LShift::LShift
return
$RShift::
capsflag = 1
rightshiftflag = 1
shiftflag = 0
$RShift::RShift
return
0::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0ce6}
return
1::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0ce7}
return
2::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0ce8}
return
3::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0ce9}
return
4::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0ceA}
return
5::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0ceb}
return
6::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0cec}
return
7::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0ced}
return
8::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0cee}
return
9::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+0cef}
return
`::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+02bb}
return
'::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+02bc}
return
,::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+002c}
return
<+`::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+007e}
return
>+`::
if (singlef = 1)
SendInput, {U+200C}
flagszero()
SendInput, {U+007e}
zwj(){
if (flag = 1 && (A_PriorHotkey = "<+f")||(A_PriorHotkey = ">+f"))
{
SendInput, {BS}{U+200D}{U+0ccd}
flag = 0
return
}
flag = 0
return
}
onef(){
if (singlef = 1)
singlef = -1
else
singlef = 0
return
}
vyanjanaflagszero(){
doubleff = 0
kai = 0
swaraflag = 0
wistle = 0
shiftflag = 0
capsflag = 0
special = 0
leftshiftflag = 0
rightshiftflag = 0
symbols = 0
saflag = 0
}
flagszero1()
{
singlef1 = 0
vyanjanaflag1 = 0
}
flagszero3()
{
hlAAA = 0
}
flagszero2()
{
kAAA = 0
kaAAA = 0
gAAA = 0
gaAAA = 0
zaAAA = 0
cAAA = 0
caAAA = 0
jAAA = 0
jaAAA = 0
zAAA = 0
qAAA = 0
qaAAA = 0
wAAA = 0
waAAA = 0
naAAA = 0
tAAA = 0
taAAA = 0
dAAA = 0
daAAA = 0
nAAA = 0
pAAA = 0
paAAA = 0
bAAA = 0
baAAA = 0
mAAA = 0
yAAA = 0
rAAA = 0
lAAA = 0
vAAA = 0
saAAA = 0
xAAA = 0
sAAA = 0
hAAA = 0
laAAA = 0
hlAAA = 0
hrAAA = 0
}
flagszero(){
doubleff = 0
kai = 0
swaraflag = 0
wistle = 0
shiftflag = 0
vyanjanaflag = 0
capsflag = 0
special = 0
leftshiftflag = 0
rightshiftflag = 0
symbols = 0
saflag = 0
flag = 0
singlef = 0
}
vyanjana(){
if (A_PriorHotKey = "r" || A_PriorHotKey = "w" || A_PriorHotKey = "<+w" || A_PriorHotKey = ">+w" || A_PriorHotKey = "q" || A_PriorHotKey = "<+q" || A_PriorHotKey = ">+q" || A_PriorHotKey = "t" || A_PriorHotKey = "<+t" || A_PriorHotKey = ">+t" || A_PriorHotKey = "y" || A_PriorHotKey = "p" || A_PriorHotKey = "<+p" || A_PriorHotKey = ">+p" || A_PriorHotKey = "s" || A_PriorHotKey = "<+s" || A_PriorHotKey = ">+s" || A_PriorHotKey = "d" || A_PriorHotKey = "<+d" || A_PriorHotKey = ">+d" || A_PriorHotKey = "g" || A_PriorHotKey = "<+g" || A_PriorHotKey = ">+g" || A_PriorHotKey = "h" || A_PriorHotKey = "j" || A_PriorHotKey = "<+j" || A_PriorHotKey = ">+j" || A_PriorHotKey = "k" || A_PriorHotKey = "<+k" || A_PriorHotKey = ">+k" || A_PriorHotKey = "l" || A_PriorHotKey = "<+l" || A_PriorHotKey = ">+l" || A_PriorHotKey = "z" || A_PriorHotKey = "<+z" || A_PriorHotKey = ">+z" || A_PriorHotKey = "x" || A_PriorHotKey = "c" || A_PriorHotKey = "<+c" || A_PriorHotKey = ">+c" || A_PriorHotKey = "v" || A_PriorHotKey = "b" || A_PriorHotKey = "<+b" || A_PriorHotKey = ">+b" || A_PriorHotKey = "n" || A_PriorHotKey = "<+n" || A_PriorHotKey = ">+n" || A_PriorHotKey = "m" || A_PriorHotKey = "<+x" || A_PriorHotKey = ">+x" || singlef = 1 || (A_PriorHotKey = "<+x" && symbols = 0) || (A_PriorHotKey = ">+x" && symbols = 0))
{
return 1
}
else
return 0
}
funsinglef(){
if (singlef = 1)
{
SendInput, {BS}
singlef = 0
}
return
}
r::
if (singlef1 = 1)
{
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB0}
hrrpc = 1
vyanjanaflag1 = 1
return
}
if (singlef = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}{U+0CC3}
flagszero()
special = 1
return
}
if (doubleff = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C8B}
flagszero()
special = 1
wistle = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C8B}
flagszero()
special = 1
wistle = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 1)
{
flagszero2()
SendInput, {U+0CC3}
flagszero()
vyanjanaflag1 = 1
special = 1
return
}
if (singlef = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}{U+0CC3}
flagszero()
special = 1
return
}
if (doubleff = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C8B}
flagszero()
special = 1
wistle = 1
return
}
if (capsflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C8B}
flagszero()
special = 1
wistle = 1
return
}
if (capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0CC3}
flagszero()
special = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB0}
rAAA = 1
return
a::
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CBE}
flagszero()
vyanjanaflag1 = 1
return
}
if (((A_PriorHotKey != "r") && (A_PriorHotKey != "w") && (A_PriorHotKey != ">+w")  && (A_PriorHotKey != "<+w") && (A_PriorHotKey != "q") && (A_PriorHotKey != ">+q") && (A_PriorHotKey != "<+q") && (A_PriorHotKey != "t") && (A_PriorHotKey != ">+t") && (A_PriorHotKey != "<+t") && (A_PriorHotKey != "y") && (A_PriorHotKey != "p") && (A_PriorHotKey != ">+p") && (A_PriorHotKey != "<+p") && (A_PriorHotKey != "s") && (A_PriorHotKey != ">+s") && (A_PriorHotKey != "<+s") && (A_PriorHotKey != "d") && (A_PriorHotKey != ">+d") && (A_PriorHotKey != "<+d") && (A_PriorHotKey != "g") && (A_PriorHotKey != ">+g") && (A_PriorHotKey != "<+g") && (A_PriorHotKey != "h") && (A_PriorHotKey != "j") && (A_PriorHotKey != ">+j") && (A_PriorHotKey != "<+j") && (A_PriorHotKey != "k") && (A_PriorHotKey != ">+k") && (A_PriorHotKey != "<+k") && (A_PriorHotKey != "l") && (A_PriorHotKey != ">+l") && (A_PriorHotKey != "z") && (A_PriorHotKey != ">+z") && (A_PriorHotKey != "<+z") && (A_PriorHotKey != "x") && (A_PriorHotKey != "c") && (A_PriorHotKey != ">+c") && (A_PriorHotKey != "<+c") && (A_PriorHotKey != "v") && (A_PriorHotKey != "b") && (A_PriorHotKey != ">+b") && (A_PriorHotKey != "<+b") && (A_PriorHotKey != "n") && (A_PriorHotKey != ">+n") && (A_PriorHotKey != "<+n") && (A_PriorHotKey != "m") && (A_PriorHotKey != "x") && (A_PriorHotkey != ">+l")  && (A_PriorHotkey != "<+l") && (singlef = 0)) || (doubleff =1))
{
SendInput, {U+0C85}
flagszero()
return
}
funsinglef()
flagszero()
return
s::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB8}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
saflag = 1
SendInput, {U+0CB8}
sAAA = 1
return
d::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA6}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA6}
dAAA = 1
return
w::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA1}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA1}
wAAA = 1
return
q::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9F}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9f}
qAAA = 1
return
t::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA4}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA4}
tAAA = 1
return
y::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAF}
vyanjanaflag1 = 1
return
}
if (singlef = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}{U+0CC8}
flagszero()
special = 1
return
}
if (doubleff = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C90}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C90}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0CC8}
flagszero()
special = 1
return
}
if (singlef = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}{U+0CC8}
flagszero()
special = 1
return
}
if (doubleff = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C90}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C90}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0CC8}
flagszero()
special = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAF}
yAAA = 1
return
p::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAA}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAA}
pAAA = 1
return
g::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C97}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C97}
gAAA = 1
return
h::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB9}
vyanjanaflag1 = 1
return
}
if (singlef = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}
flagszero()
special = 1
return
}
if (doubleff = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C83}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C83}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C83}
flagszero()
special = 1
return
}
if (singlef = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}
flagszero()
special = 1
return
}
if (doubleff = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C83}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C83}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C83}
flagszero()
special = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB9}
hAAA = 1
return
j::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9C}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9C}
jAAA = 1
return
l::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB2}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB2}
lAAA = 1
return
k::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C95}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C95}
vyanjanaflag1 = 1
kAAA = 1
return
z::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9E}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9E}
zAAA = 1
return
x::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB7}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB7}
xAAA = 1
return
c::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9A}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9A}
cAAA = 1
return
v::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB5}
vyanjanaflag1 = 1
return
}
if (singlef = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}{U+0CCC}
flagszero()
special = 1
return
}
if (doubleff = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C94}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C94}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0CCC}
flagszero()
special = 1
return
}
if (singlef = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}{U+0CCC}
flagszero()
special = 1
return
}
if (doubleff = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C94}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C94}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0CCC}
flagszero()
special = 1
return
}
zwj()
onef()
if ((saflag = 1) && (A_PriorHotkey = "f"))
{
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB5}
return
}
flagszero1()
flagszero2()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB5}
vAAA = 1
return
b::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAC}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAC}
bAAA = 1
return
n::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA8}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA8}
nAAA = 1
return
m::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAE}
vyanjanaflag1 = 1
return
}
if (singlef = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}
flagszero()
special = 1
return
}
if (doubleff = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C82}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C82}
flagszero()
special = 1
return
}
if (capsflag = 1)
{
SendInput, {U+0C82}
flagszero()
special = 1
return
}
if (shiftflag = 1)
{
SendInput, {U+0CAE}{U+0CCD}{U+0CAE}
vyanjanaflagszero()
vyanjanaflag = 1
return
}
if (singlef = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}
flagszero()
special = 1
return
}
if (doubleff = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C82}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C82}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C82}
flagszero()
special = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAE}
mAAA = 1
return
>+q::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA0}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA0}
qaAAA = 1
return
<+q::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA0}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA0}
qaAAA = 1
return
>+w::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA2}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA2}
waAAA = 1
return
<+w::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA2}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA2}
waAAA = 1
return
>+t::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA5}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA5}
taAAA = 1
return
<+t::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA5}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA5}
taAAA = 1
return
>+p::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAB}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAB}
paAAA = 1
return
<+p::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAB}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAB}
paAAA = 1
return
>+s::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB6}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB6}
saAAA = 1
return
<+s::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB6}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB6}
saAAA = 1
return
>+d::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA7}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA7}
daAAA = 1
return
<+d::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA7}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA7}
daAAA = 1
return
>+g::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C98}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C98}
gaAAA = 1
return
<+g::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C98}
vyanjanaflag1 = 1
return
}
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C98}
gaAAA = 1
return
>+j::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9D}
vyanjanaflag1 = 1
return
}
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9D}
gaAAA = 1
return
<+j::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9D}
vyanjanaflag1 = 1
return
}
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9D}
gaAAA = 1
return
>+k::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C96}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C96}
kaAAA = 1
return
<+k::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C96}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C96}
kaAAA = 1
return
>+l::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB3}
hlrpc =1
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB3}
laAAA = 1
return
<+l::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB3}
hlrpc = 1
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CB3}
laAAA = 1
return
>+z::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C99}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C99}
zaAAA = 1
return
<+z::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C99}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C99}
zaAAA = 1
return
>+c::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9B}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9B}
caAAA = 1
return
<+c::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9B}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0C9B}
caAAA = 1
return
>+b::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAD}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAD}
baAAA = 1
return
<+b::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAD}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CAD}
baAAA = 1
return
>+n::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA3}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA3}
naAAA = 1
return
<+n::
if (singlef1 = 1)
{
flagszero1()
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA3}
vyanjanaflag1 = 1
return
}
flagszero2()
zwj()
onef()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {U+0CA3}
naAAA = 1
return
i::
if (A_PriorHotkey = "m" && special = 1 && capsflag = 1)
{
SendInput, {U+0C88}
flagszero()
return
}
if (A_PriorHotkey = "m" && special = 1)
{
SendInput, {U+0C87}
flagszero()
return
}
if (A_PriorHotkey = "h" && special = 1 && capsflag = 1)
{
SendInput, {U+0C88}
flagszero()
return
}
if (A_PriorHotkey = "h" && special = 1)
{
SendInput, {U+0C87}
flagszero()
return
}
if (singlef = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}{U+0CBF}{U+0CD5}
flagszero()
special = 1
return
}
if (doubleff = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C88}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C88}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0CC0}
flagszero()
special = 1
return
}
if (singlef = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}{U+0CBF}{U+0CD5}
flagszero()
special = 1
return
}
if (doubleff = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C88}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C88}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0CC0}
flagszero()
special = 1
return
}
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CBF}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CBF}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C87}
return
o::
if (A_PriorHotkey = "m" && special = 1 && capsflag = 1)
{
SendInput, {U+0C93}
flagszero()
return
}
if (A_PriorHotkey = "m" && special = 1 && shiftflag = 1)
{
SendInput, {U+0C93}
flagszero()
return
}
if (A_PriorHotkey = "m" && special = 1)
{
SendInput, {U+0C92}
flagszero()
return
}
if (A_PriorHotkey = "h" && special = 1 && capsflag = 1)
{
SendInput, {U+0C93}
flagszero()
return
}
if (A_PriorHotkey = "h" && special = 1 && shiftflag = 1)
{
SendInput, {U+0C93}
flagszero()
return
}
if (A_PriorHotkey = "h" && special = 1)
{
SendInput, {U+0C92}
flagszero()
return
}
if (singlef = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}{U+0CCA}{U+0CD5}
flagszero()
special = 1
return
}
if (doubleff = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C93}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C93}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0CCB}
flagszero()
special = 1
return
}
if (singlef = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}{U+0CCA}{U+0CD5}
flagszero()
special = 1
return
}
if (doubleff = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C93}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C93}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0CCB}
flagszero()
special = 1
return
}
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CCA}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CCA}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C92}
return
e::
if (A_PriorHotkey = "m" && special = 1 && capsflag = 1)
{
SendInput, {U+0C8F}
flagszero()
return
}
if (A_PriorHotkey = "m" && special = 1)
{
SendInput, {U+0C8E}
flagszero()
return
}
if (A_PriorHotkey = "h" && special = 1 && capsflag = 1)
{
SendInput, {U+0C8F}
flagszero()
return
}
if (A_PriorHotkey = "h" && special = 1)
{
SendInput, {U+0C8E}
flagszero()
return
}
if (singlef = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}{U+0CC6}{U+0CD5}
flagszero()
special = 1
return
}
if (doubleff = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C8F}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C8F}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0CC7}
flagszero()
special = 1
return
}
if (singlef = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}{U+0CC6}{U+0CD5}
flagszero()
special = 1
return
}
if (doubleff = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C8F}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C8F}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0CC7}
flagszero()
special = 1
return
}
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CC6}
flagszero()
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CC6}
flagszero()
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C8E}
return
u::
if (A_PriorHotkey = "m" && special = 1 && capsflag = 1)
{
SendInput, {U+0C8A}
flagszero()
return
}
if (A_PriorHotkey = "m" && special = 1)
{
SendInput, {U+0C89}
flagszero()
return
}
if (A_PriorHotkey = "h" && special = 1 && capsflag = 1)
{
SendInput, {U+0C8A}
flagszero()
return
}
if (A_PriorHotkey = "h" && special = 1)
{
SendInput, {U+0C89}
flagszero()
return
}
if (singlef = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}{U+0CC2}
flagszero()
special = 1
return
}
if (doubleff = 1 && shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C8A}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C8A}
flagszero()
special = 1
return
}
if (shiftflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0CC2}
flagszero()
special = 1
return
}
if (singlef = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {BS}{U+0CC2}
flagszero()
special = 1
return
}
if (doubleff = 1 && capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0C8A}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 0)
{
SendInput, {U+0C8A}
flagszero()
special = 1
return
}
if (capsflag = 1 && vyanjanaflag = 1)
{
SendInput, {U+0CC2}
flagszero()
special = 1
return
}
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CC1}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CC1}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C89}
return
>+h::
if (singlef = 1)
{
SendInput, {BS}
flagszero()
return
}
flagszero()
SendInput, {U+0C83}
return
<+h::
if (singlef = 1)
{
SendInput, {BS}
flagszero()
return
}
flagszero()
SendInput, {U+0C83}
return
>+m::
if (singlef = 1)
{
SendInput, {BS}
flagszero()
return
}
flagszero()
SendInput, {U+0C82}
return
<+m::
if (singlef = 1)
{
SendInput, {BS}
flagszero()
return
}
flagszero()
SendInput, {U+0C82}
return
>+e::
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CC7}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CC7}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C8F}
return
<+e::
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CC7}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CC7}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C8F}
return
>+y::
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CC8}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CC8}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C90}
return
<+y::
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CC8}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CC8}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C90}
return
>+u::
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CC2}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CC2}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C8A}
return
<+u::
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CC2}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CC2}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C8A}
return
>+i::
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CC0}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CC0}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C88}
return
<+i::
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CC0}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CC0}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C88}
return
>+o::
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CCB}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CCB}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C93}
return
<+o::
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CCB}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CCB}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C93}
return
>+a::
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CBE}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CBE}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C86}
return
<+a::
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CBE}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CBE}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C86}
return
>+r::
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CC3}
flagszero()
vyanjanaflag1 = 1
swaraflag = 1
return
}
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
SendInput, {U+0CC3}
flagszero()
return
}
if (A_PriorHotKey != "r" && A_PriorHotKey != "w" && A_PriorHotKey != "<+w" && A_PriorHotKey != ">+w" && A_PriorHotKey != "q" && A_PriorHotKey != "<+q" && A_PriorHotKey != ">+q" && A_PriorHotKey != "t" && A_PriorHotKey != "<+t" && A_PriorHotKey != ">+t" && A_PriorHotKey != "y" && A_PriorHotKey != "p" && A_PriorHotKey != "<+p" && A_PriorHotKey != ">+p" && A_PriorHotKey != "s" && A_PriorHotKey != "<+s" && A_PriorHotKey != ">+s" && A_PriorHotKey != "d" && A_PriorHotKey != "<+d" && A_PriorHotKey != ">+d" && A_PriorHotKey != "g" && A_PriorHotKey != "<+g" && A_PriorHotKey != ">+g" && A_PriorHotKey != "h" && A_PriorHotKey != "j" && A_PriorHotKey != "<+j" && A_PriorHotKey != ">+j" && A_PriorHotKey != "k" && A_PriorHotKey != "<+k" && A_PriorHotKey != ">+k" && A_PriorHotKey != "l" && A_PriorHotKey != "<+l" && A_PriorHotKey != ">+l" && A_PriorHotKey !="x" && A_PriorHotKey != "c" && A_PriorHotKey != "<+c" && A_PriorHotKey != ">+c" && A_PriorHotKey != "v" && A_PriorHotKey != "b" && A_PriorHotKey != "<+b" && A_PriorHotKey != ">+b" && A_PriorHotKey != "n" && A_PriorHotKey != "<+n" && A_PriorHotKey != ">+n" && A_PriorHotKey != "m" && A_PriorHotKey != "z" && A_PriorHotKey != "<+z" && A_PriorHotKey != ">+z")
{
flagszero()
wistle = 1
SendInput, {U+0C8b}
return
}
<+r::
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CC3}
flagszero()
vyanjanaflag1 = 1
swaraflag = 1
return
}
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
SendInput, {U+0CC3}
flagszero()
return
}
if (A_PriorHotKey != "r" && A_PriorHotKey != "w" && A_PriorHotKey != "<+w" && A_PriorHotKey != ">+w" && A_PriorHotKey != "q" && A_PriorHotKey != "<+q" && A_PriorHotKey != ">+q" && A_PriorHotKey != "t" && A_PriorHotKey != "<+t" && A_PriorHotKey != ">+t" && A_PriorHotKey != "y" && A_PriorHotKey != "p" && A_PriorHotKey != "<+p" && A_PriorHotKey != ">+p" && A_PriorHotKey != "s" && A_PriorHotKey != "<+s" && A_PriorHotKey != ">+s" && A_PriorHotKey != "d" && A_PriorHotKey != "<+d" && A_PriorHotKey != ">+d" && A_PriorHotKey != "g" && A_PriorHotKey != "<+g" && A_PriorHotKey != ">+g" && A_PriorHotKey != "h" && A_PriorHotKey != "j" && A_PriorHotKey != "<+j" && A_PriorHotKey != ">+j" && A_PriorHotKey != "k" && A_PriorHotKey != "<+k" && A_PriorHotKey != ">+k" && A_PriorHotKey != "l" && A_PriorHotKey != "<+l" && A_PriorHotKey != ">+l" && A_PriorHotKey !="x" && A_PriorHotKey != "c" && A_PriorHotKey != "<+c" && A_PriorHotKey != ">+c" && A_PriorHotKey != "v" && A_PriorHotKey != "b" && A_PriorHotKey != "<+b" && A_PriorHotKey != ">+b" && A_PriorHotKey != "n" && A_PriorHotKey != "<+n" && A_PriorHotKey != ">+n" && A_PriorHotKey != "m" && A_PriorHotKey != "z" && A_PriorHotKey != "<+z" && A_PriorHotKey != ">+z")
{
flagszero()
wistle = 1
SendInput, {U+0C8b}
return
}
>+x::
if((A_PriorHotKey = "<+r" || A_PriorHotKey = ">+r") && special = 1 && wistle = 0)
{
SendInput, {BS}{U+0CC4}
flagszero()
symbols = 1
return
}
if ((A_PriorHotKey = "<+r" || A_PriorHotKey = ">+r") && (wistle = 0))
{
SendInput, {BS}{U+0CC4}
flagszero()
symbols = 1
return
}
if ((A_PriorHotkey = "<+r") || (A_PriorHotkey = ">+r") && (if A_PriorHotKey != "r" || A_PriorHotKey != "w" || A_PriorHotKey != "<+w" || A_PriorHotKey != ">+w" || A_PriorHotKey != "q" || A_PriorHotKey != "<+q" || A_PriorHotKey != ">+q" || A_PriorHotKey != "t" || A_PriorHotKey != "<+t" || A_PriorHotKey != ">+t" || A_PriorHotKey != "y" || A_PriorHotKey != "p" || A_PriorHotKey != "<+p" || A_PriorHotKey != ">+p" || A_PriorHotKey != "s" || A_PriorHotKey != "<+s" || A_PriorHotKey != ">+s" || A_PriorHotKey != "d" || A_PriorHotKey != "<+d" || A_PriorHotKey != ">+d" || A_PriorHotKey != "g" || A_PriorHotKey != "<+g" || A_PriorHotKey != ">+g" || A_PriorHotKey != "h" || A_PriorHotKey != "j" || A_PriorHotKey != "<+j" || A_PriorHotKey != ">+j" || A_PriorHotKey != "k" || A_PriorHotKey != "<+k" || A_PriorHotKey != ">+k" || A_PriorHotKey != "l" || A_PriorHotKey != "<+l" || A_PriorHotKey != ">+l" || A_PriorHotKey != "z" || A_PriorHotKey != "<+z" || A_PriorHotKey != ">+z" || A_PriorHotKey != "x" || A_PriorHotKey != "c" || A_PriorHotKey != "<+c" || A_PriorHotKey != ">+c" || A_PriorHotKey != "v" || A_PriorHotKey != "b" || A_PriorHotKey != "<+b" || A_PriorHotKey != ">+b" || A_PriorHotKey != "n" || A_PriorHotKey != "<+n" || A_PriorHotKey != ">+n" || A_PriorHotKey != "m" || A_PriorHotKey != "<+x" || A_PriorHotKey != ">+x"))
{
SendInput, {BS}{U+0CE0}
flagszero()
symbols = 1
return
}
if(singlef1 = 1)
{
flagszero3()
flagszero2()
flagszero1()
SendInput, {U+0CDE}
flagszero()
vyanjanaflag1 = 1
return
}
if (A_PriorHotKey = "r")
{
if (singlef = 1)
{
flagszero()
return
}
SendInput, {BS}{U+0CB1}
flagszero()
hrAAA = 1
return
}
if (A_PriorHotKey = ">+l" || A_PriorHotKey = "<+l")
{
flagszero2()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {BS}{U+0CDE}
flagszero()
hlAAA = 1
return
}
if (A_PriorHotKey = "s" && special = 0)
{
SendInput, {BS}{U+0CBD}
flagszero()
symbols = 1
return
}
SendInput, {U+0CBC}
flagszero()
return
<+x::
if((A_PriorHotKey = "<+r" || A_PriorHotKey = ">+r") && special = 1 && wistle = 0)
{
SendInput, {BS}{U+0CC4}
flagszero()
symbols = 1
return
}
if ((A_PriorHotKey = "<+r" || A_PriorHotKey = ">+r") && (wistle = 0))
{
SendInput, {BS}{U+0CC4}
flagszero()
symbols = 1
return
}
if ((A_PriorHotkey = "<+r") || (A_PriorHotkey = ">+r") && (if A_PriorHotKey != "r" || A_PriorHotKey != "w" || A_PriorHotKey != "<+w" || A_PriorHotKey != ">+w" || A_PriorHotKey != "q" || A_PriorHotKey != "<+q" || A_PriorHotKey != ">+q" || A_PriorHotKey != "t" || A_PriorHotKey != "<+t" || A_PriorHotKey != ">+t" || A_PriorHotKey != "y" || A_PriorHotKey != "p" || A_PriorHotKey != "<+p" || A_PriorHotKey != ">+p" || A_PriorHotKey != "s" || A_PriorHotKey != "<+s" || A_PriorHotKey != ">+s" || A_PriorHotKey != "d" || A_PriorHotKey != "<+d" || A_PriorHotKey != ">+d" || A_PriorHotKey != "g" || A_PriorHotKey != "<+g" || A_PriorHotKey != ">+g" || A_PriorHotKey != "h" || A_PriorHotKey != "j" || A_PriorHotKey != "<+j" || A_PriorHotKey != ">+j" || A_PriorHotKey != "k" || A_PriorHotKey != "<+k" || A_PriorHotKey != ">+k" || A_PriorHotKey != "l" || A_PriorHotKey != "<+l" || A_PriorHotKey != ">+l" || A_PriorHotKey != "z" || A_PriorHotKey != "<+z" || A_PriorHotKey != ">+z" || A_PriorHotKey != "x" || A_PriorHotKey != "c" || A_PriorHotKey != "<+c" || A_PriorHotKey != ">+c" || A_PriorHotKey != "v" || A_PriorHotKey != "b" || A_PriorHotKey != "<+b" || A_PriorHotKey != ">+b" || A_PriorHotKey != "n" || A_PriorHotKey != "<+n" || A_PriorHotKey != ">+n" || A_PriorHotKey != "m" || A_PriorHotKey != "<+x" || A_PriorHotKey != ">+x"))
{
SendInput, {BS}{U+0CE0}
flagszero()
symbols = 1
return
}
if(singlef1 = 1)
{
flagszero3()
flagszero2()
flagszero1()
SendInput, {U+0CDE}
flagszero()
vyanjanaflag1 = 1
return
}
if (A_PriorHotKey = "r")
{
if (singlef = 1)
{
flagszero()
return
}
SendInput, {BS}{U+0CB1}
flagszero()
hrAAA = 1
return
}
if (A_PriorHotKey = ">+l" || A_PriorHotKey = "<+l")
{
flagszero2()
vyanjanaflagszero()
vyanjanaflag = 1
SendInput, {BS}{U+0CDE}
flagszero()
hlAAA = 1
return
}
if (A_PriorHotKey = "s" && special = 0)
{
SendInput, {BS}{U+0CBD}
flagszero()
symbols = 1
return
}
SendInput, {U+0CBC}
flagszero()
return
>+v::
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CCC}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CCC}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C94}
return
<+v::
if ((vyanjanaflag = 1) && (singlef = 0 || singlef = -1))
{
flagszero2()
funsinglef()
SendInput, {U+0CCC}
flagszero()
vyanjanaflag1 = 1
return
}
if (vyanjana())
{
flagszero2()
funsinglef()
SendInput, {U+0CCC}
flagszero()
vyanjanaflag1 = 1
return
}
flagszero()
swaraflag = 1
SendInput, {U+0C94}
return
$Tab::
if (singlef = 1)
SendInput, {U+200C}
SendInput, {Tab}
flagszero()
return
$Space::
if (singlef = 1)
SendInput, {U+200C}
SendInput, {Space}
flagszero()
return
$Enter::
if (singlef = 1)
SendInput, {U+200C}
SendInput, {Enter}
flagszero()
return
>+F::
if(vyanjanaflag = 1)
{
flagszero2()
SendInput, {left 3}{bs}{left 0}{U+0ccd}{Right 5}
flagszero1()
return
}
<+F::
if (A_Priorhotkey = "r" && singlef = 0)
{
flagszero()
singlef = 1
flag = 1
SendInput, {U+0ccd}
return
}
return
f::
if (capsflag = 1 || leftshiftflag = 1 || rightshiftflag = 1 || shiftflag = 1)
{
flagszero()
return
}
if (A_PriorHotkey = "a" || if A_PriorHotKey = "<+a" || if A_PriorHotKey = ">+a" || A_PriorHotKey = "e" || A_PriorHotKey = "<+e" || A_PriorHotKey = ">+e" || A_PriorHotKey = "<+r" || A_PriorHotKey = ">+r" || A_PriorHotKey = "<+y" || A_PriorHotKey = ">+y" || A_PriorHotKey = "u" || A_PriorHotKey = "<+u" || A_PriorHotKey = ">+u" || A_PriorHotKey = "i" || A_PriorHotKey = "<+i" || A_PriorHotKey = ">+i" || A_PriorHotKey = "o" || A_PriorHotKey = "<+o" || A_PriorHotKey = ">+o" || A_PriorHotKey = "<+h" || A_PriorHotKey = ">+h" || A_PriorHotKey = "<+m" || A_PriorHotKey = ">+m" || kai = 1 || (A_PriorHotkey = "r" && special = 1) || (A_PriorHotkey = "y" && special = 1) || (A_PriorHotkey = "v" && special = 1) || (A_PriorHotkey = "m" && special = 1) || (A_PriorHotkey = "h" && special = 1))
{
flagszero()
return
}
if (A_PriorHotkey = "f" && doubleff = 1)
{
flagszero()
return
}
if (A_PriorHotKey = "f" && doubleff = 0 && singlef = 1)
{
SendInput, {U+200C}
flagszero()
doubleff = 1
return
}
if (A_Priorhotkey = "r" && singlef = 0)
{
flagszero()
singlef = 1
flag = 1
SendInput, {U+0ccd}
return
}
if(hlAAA = 1)
{
SendInput, {U+0ccd}
singlef1 = 1
doubleff = 0
shiftflag = 0
capsflag = 0
rightshiftflag = 0
leftshiftflag = 0
return
}
if(hrAAA = 1)
{
SendInput, {U+0ccd}
singlef = 1
doubleff = 0
shiftflag = 0
capsflag = 0
rightshiftflag = 0
leftshiftflag = 0
return
}
if (A_PriorHotKey = "r" || A_PriorHotKey = "w" || A_PriorHotKey = "<+w" || A_PriorHotKey = ">+w" || A_PriorHotKey = "q" || A_PriorHotKey = "<+q" ||A_PriorHotKey = ">+q" || A_PriorHotKey = "t" || A_PriorHotKey = "<+t" || A_PriorHotKey = ">+t" || A_PriorHotKey = "y" || A_PriorHotKey = "p" || A_PriorHotKey = "<+p" || A_PriorHotKey = ">+p" || A_PriorHotKey = "s" || A_PriorHotKey = "<+s" || A_PriorHotKey = ">+s" || A_PriorHotKey = "d" || A_PriorHotKey = "<+d" || A_PriorHotKey = ">+d" || A_PriorHotKey = "g" || A_PriorHotKey = "<+g" || A_PriorHotKey = ">+g" || A_PriorHotKey = "h" || A_PriorHotKey = "j" || A_PriorHotKey = "<+j" || A_PriorHotKey = ">+j" || A_PriorHotKey = "k" || A_PriorHotKey = "<+k" || A_PriorHotKey = ">+k" || A_PriorHotKey = "l" || A_PriorHotKey = "<+l" || A_PriorHotKey = ">+l" || A_PriorHotKey = "z" || A_PriorHotKey = "<+z" || A_PriorHotKey = ">+z" || A_PriorHotKey = "x" || A_PriorHotKey = "c" || A_PriorHotKey = "<+c" || A_PriorHotKey = ">+c" || A_PriorHotKey = "v" || A_PriorHotKey = "b" || A_PriorHotKey = "<+b" || A_PriorHotKey = ">+b" || A_PriorHotKey = "n" || A_PriorHotKey = "<+n" || A_PriorHotKey = ">+n" || A_PriorHotKey = "m")
{
SendInput, {U+0ccd}
singlef = 1
doubleff = 0
shiftflag = 0
capsflag = 0
rightshiftflag = 0
leftshiftflag = 0
return
}
flagszero()
return