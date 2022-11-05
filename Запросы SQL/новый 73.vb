Sub HyperSsylka()
Dim cell As Range, ra As Range: Application.ScreenUpdating = False
Set ra = Range([e2], Range("e" & Rows.Count).End(xlUp))
For Each cell In ra.Cells
If Len(cell) Then cell.Hyperlinks.Add cell And Selection.Hyperlinks(1).TextToDisplay = "Скачать", cell
Next cell
End Sub
If Len(cell) Then Selection.Hyperlinks(1).TextToDisplay = "Скачать"

Sub HyperSsylka1()
Dim cell As Range, ra As Range: Application.ScreenUpdating = False
Set ra = Range([e2], Range("e" & Rows.Count).End(xlUp))
For Each cell In ra.Cells
If Len(cell) Then Selection.Hyperlinks(1).TextToDisplay = "Скачать" cell, cell
Next cell
End Sub
