Option Explicit


Private Sub refresh_Click()

z.Rows("3:500").EntireRow.Hidden = False
If s.[A4].Value <> 1 Then ' Если не 1 У Вас не прав для записи
MsgBox ("У Вас не прав для записи.")
End
End If

Dim msgboxSure As VbMsgBoxResult ' проверка на случайное нажатие
msgboxSure = MsgBox("Вы уверены что хотите продолжить?", vbYesNo, "Запись в БД!")
If msgboxSure = vbNo Then Exit Sub



Dim i As Byte
Dim ii As Byte
Dim j As Long
Dim k As Byte
Dim pscn As ADODB.Connection
Dim q As ADODB.Recordset
Dim counter As Integer


   
For ii = 3 To z.Range("Q3").End(xlDown).Row ' проверка на уникальное значение
      
    If z.Application.CountIf(Range("Q3", z.Range("Q3").End(xlDown)), Cells(ii, 17).Value) > 1 Then  ' 17 столбец shells_id
        MsgBox ("Повторяющееся значение в поле ""id отчёта"", загрузка прервана, ошибка на строке: " & ii)
        End
    End If
    
    If z.Cells(ii, 2).Value = "" Then  ' 17 столбец shells_id
        z.Cells(ii, 2).Value = "Не заполнено"
    End If
    If z.Cells(ii, 1).Value = "" Then  ' 17 столбец shells_id
        z.Cells(ii, 1).Value = "Не заполнено"
    End If
    If z.Cells(ii, 6).Value = "" Then  ' 17 столбец shells_id
        MsgBox ("Пустое значение в поле ""Версия отчета / Дата обновления"", загрузка прервана, ошибка на строке: " & ii)
        End
    End If
'    If z.Cells(ii, 3).Value = "" Then  ' 17 столбец shells_id
'        z.Cells(ii, 3).Value = "Не заполнено"
'    End If
        
   
Next ii

For ii = 3 To z.Range("A3").End(xlDown).Row
    If z.Cells(ii, 17).Value = "" Then  ' 17 столбец shells_id
        MsgBox ("Пустое значение в поле ""id отчёта"", загрузка прервана, ошибка на строке: " & ii)
        End
    End If
Next ii
 
 
  
Set pscn = New ADODB.Connection
pscn.Open ConnectionString:="DRIVER={MySQL ODBC 5.2 Unicode Driver};SERVER=serverus.komus.net;DataBase=serverus;UID=root;PWD=ltnbytw;charset=cp1251;option=3"
With z
' Запись данных в БД
    Set q = New ADODB.Recordset 'открытие обмена
        q.CursorLocation = adUseServer
        q.Open Source:="shells", _
        ActiveConnection:=pscn, _
        CursorType:=adOpenDynamic, _
        LockType:=adLockPessimistic, _
        Options:=adCmdTable
        pscn.Execute "truncate table shells"
    For j = 3 To .[B65000].End(xlUp).Row
        q.AddNew
        For i = 8 To 27 ' нужна замена при добавлении столбцов
            q(s.Cells(2, i).Value) = .Cells(j, s.Cells(3, i)).Value ' запись данных => страница s
        Next i
    Next j
    q.Update
    q.Close
    pscn.Close
    
MsgBox (" Запись прошла успешно. ")
End With

End Sub
Private Sub TextBox1_GotFocus() ' по выделению TextBox1 стираем "Выделение текста"
 
    If TextBox1.Value = "Выделение текста" Then
    TextBox1.Value = ""
    End If
    
End Sub

Private Sub TextBox1_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer) ' Вызываем процедуру для подкраски  KeyCode = 13(enter)

    If KeyCode = 13 Then
       Call Find_n_Highlight
    End If
End Sub

Private Sub zapros_Click() ' Записываем данные на лист z
    z.Rows("3:500").EntireRow.Hidden = False
    
    Call data_take
       Application.EnableEvents = True
       Application.ScreenUpdating = True
End Sub

Sub data_take() ' процедура для записи данных на лист

Application.ScreenUpdating = False
Application.EnableEvents = False

Dim i As Byte
Dim j As Integer
Dim ij As Byte

With z
    .Range(.[A2], .Cells(.Rows.Count, .Columns.Count)).Clear ' clear all
    Dim cnn As ADODB.Connection
    Dim rst As ADODB.Recordset
    Set cnn = New ADODB.Connection
    With cnn
        .Open ConnectionString:="DRIVER={MySQL ODBC 5.2 Unicode Driver};SERVER=serverus.komus.net;DataBase=serverus;UID=slp;PWD=16052016;charset=cp1251;option=3"
    End With
    Set rst = New ADODB.Recordset
    rst.CursorLocation = adUseServer
    rst.Open Source:="call shells_v", _
    ActiveConnection:=cnn, _
    CursorType:=adOpenForwardOnly, _
    LockType:=adLockOptimistic, _
    Options:=adCmdText
    
    ij = 0 ' счет строк в shellb
    rst.MoveFirst
    Do Until rst.EOF
    ij = ij + 1
    rst.MoveNext
    Loop
   ' MsgBox ("Строк в shellb" & ij)
    rst.MoveFirst
    Range("Q3:Q" & ij + 20).NumberFormat = "@" ' форматируем поле id_отчёта в text
    With .[A2]
    For j = 1 To rst.Fields.Count ' вывод полей
        .Offset(0, j - 1).Value = rst.Fields(j - 1).Name
    Next j
    Do Until rst.EOF
    i = i + 1
    For j = 1 To rst.Fields.Count
        .Offset(i, j - 1).Value = rst.Fields(j - 1).Value 'запись строка
        If .Offset(i, j - 1).Text Like "http://*" Then  ' добавление гиперссылок
            .Offset(i, j - 1).Hyperlinks.Add .Offset(i, j - 1), .Offset(i, j - 1).Text
        End If
    Next j
    rst.MoveNext
    Loop
    End With
  rst.Close
    cnn.Close
    .[A2].Copy
    .[A2].PasteSpecial Paste:=xlPasteValues
    Application.CutCopyMode = False
End With
    ' начинаем форматирование
    Set cnn = New ADODB.Connection
    With cnn
        .Open ConnectionString:="DRIVER={MySQL ODBC 5.2 Unicode Driver};SERVER=serverus.komus.net;DataBase=serverus;UID=slp;PWD=16052016;charset=cp1251;option=3"
    End With
    Set rst = New ADODB.Recordset
    rst.CursorLocation = adUseServer
    rst.Open Source:="select * from formaty where table_name='Reestr_otch'", _
    ActiveConnection:=cnn, _
    CursorType:=adOpenForwardOnly, _
    LockType:=adLockReadOnly, _
    Options:=adCmdText
        Do Until rst.EOF
            With z.Range(z.Cells(3, rst("position").Value), z.Cells(z.[A65000].End(xlUp).Offset(5, 0).Row, rst("position").Value)) 'форматирование таблицы
                .ColumnWidth = rst("width").Value
                .Interior.Color = RGB(CInt(Left(rst("column_color").Value, 3)), CInt(Mid(rst("column_color").Value, 5, 3)), CInt(Mid(rst("column_color").Value, 9, 3)))
                .NumberFormat = rst("column_format").Value
                .Borders.Weight = rst("borders_l")
                .VerticalAlignment = xlTop
            End With
            With z.Cells(2, rst("position").Value) 'форматирование заголовка
                .Interior.Color = RGB(CInt(Left(rst("header_color").Value, 3)), CInt(Mid(rst("header_color").Value, 5, 3)), CInt(Mid(rst("header_color").Value, 9, 3))) ' цвет сцепление через точку
                .Value = rst("column_name").Value
                .WrapText = True
                .BorderAround Weight:=rst("borders_h")
                .Font.Bold = True
                .VerticalAlignment = xlTop ' выравнивание шапки по центру
            End With
            rst.MoveNext
        Loop
        cnn.Close

End Sub

'lColumn = z.Cells(1, Columns.Count).End(xlToLeft).Column

Private Function tt(t)
    If Day(t) < 10 Then
        tt = "0" & Day(t)
    Else
        tt = Day(t)
    End If
    If Month(t) < 10 Then
        tt = "0" & Month(t) & "-" & tt
    Else
        tt = Month(t) & "-" & tt
    End If
    tt = Year(t) & "-" & tt & " "
    If Hour(t) < 10 Then
        tt = tt & "0" & Hour(t)
    Else
        tt = tt & Hour(t)
    End If
    tt = tt & ":"
    If Minute(t) < 10 Then
        tt = tt & "0" & Minute(t)
    Else
        tt = tt & Minute(t)
    End If
    tt = tt & ":"
    If Second(t) < 10 Then
        tt = tt & "0" & Second(t)
    Else
        tt = tt & Second(t)
    End If
    
End Function

Private Sub Filter_Click()

'd_d.Range(d_d.[A1], d_d.Cells(d_d.Rows.Count, d_d.Columns.Count)).Clear

 If z.Filter.Caption = "Скрыть" Then

 Application.ScreenUpdating = False
 On Error Resume Next: Err.Clear

    Dim j As Integer
    Dim i As Integer
    Dim indexRow As Integer
    Dim redRowsArray() As Integer
    Dim lastRow As Integer
    indexRow = 1
    lastRow = z.Range("A3").End(xlDown).Row

    z.Rows("3:500").EntireRow.Hidden = False

    For j = 1 To z.Range("A2").End(xlToRight).Column
            z.Range([A2], Cells(z.Range("A2").End(xlDown).Row, z.Range("A2").End(xlToRight).Column)).AutoFilter , Field:=j, Criteria1:=RGB(255, 0, 0), Operator:=xlFilterFontColor ' фильтр по цвету
           ' z.AutoFilter.Range.Columns(1).SpecialCells(xlVisible).Count для проверки
            For i = 3 To lastRow
                If z.Rows(i).EntireRow.Hidden = False Then
                   ReDim Preserve redRowsArray(indexRow + 1) ' указываем размер массива Preserve сохранить значения
                   redRowsArray(indexRow) = i ' записываем скрытые строки
                   indexRow = indexRow + 1
                End If
            Next i
       z.Rows("3:500").EntireRow.Hidden = True
       z.Rows("3:500").EntireRow.Hidden = False
    Next j
    z.Range([A2], Cells(z.Range("A2").End(xlDown).Row, z.Range("A2").End(xlToRight).Column)).AutoFilter
    z.Rows("3:500").EntireRow.Hidden = True
             
    For i = 0 To UBound(redRowsArray)
        z.Rows(redRowsArray(i)).EntireRow.Hidden = False ' отображаем скрытые строки
    Next i
    
       z.Filter.Caption = "Отобразить"
       Application.ScreenUpdating = True
    Else
       z.Rows("3:500").EntireRow.Hidden = False
       z.Filter.Caption = "Скрыть"
    End If
    
End Sub


Private Sub Find_n_Highlight()

    Application.ScreenUpdating = False
    On Error Resume Next: Err.Clear
    Dim ra As Range, cell As Range, res, txt$, v, pos&
    Dim Arr
    
    
   
    txt$ = LCase(TextBox1.Value) ' меняем регистр на LCase для того чтобы регистр не имел значения
    Set ra = Range([A3], Cells(z.Range("A3").End(xlDown).Row, z.Range("A2").End(xlToRight).Column))    ' диапазон для поиска
    Application.ScreenUpdating = False
   ' ra.Font.Color = 0: ra.Font.Bold = 0  ' del by colour
    For Each cell In ra.Cells    ' перебираем все ячейки
        pos = 1
        If LCase(cell.Text) Like "*" & txt & "*" Then ' тоже меняем регистр на LCase
            Arr = Split(cell.Text, txt, , vbTextCompare)   ' разбивает текст ячейки на части
            If UBound(Arr) > 0 Then    ' если подстрока найдена
                For Each v In Arr    ' перебираем все вхождения
                    pos = pos + Len(v)    ' начальная позиция
                    With cell.Characters(pos, Len(txt))
                        .Font.ColorIndex = 3    ' выделяем цветом
                        .Font.Bold = True    ' и полужирным начертанием
                    End With
                    pos = pos + Len(txt)
                Next v
            End If
        End If
    Next cell
    Application.ScreenUpdating = True

End Sub

' перевод курсора на 2 строку
Private Sub Worksheet_SelectionChange(ByVal target As Range)
    Application.EnableEvents = False
    Dim rrow As Long
    Dim clom As Integer
    rrow = target.Row
    clom = target.Column
    If rrow < 2 Then
        ActiveWorkbook.ActiveSheet.Cells(2, clom).Select
    End If
    Application.EnableEvents = True
    
End Sub

' раб вариант для слова
' Dim i As Integer, j As Integer
' Dim Checking As String
' For j = 0 To z.Range("A2").End(xlToRight).Column
' For i = 0 To z.Range("A3").End(xlDown).Row
'       If z.[A2].Offset(i, j).Text = Paint_text Then
'             With Cells(i + 2, j + 1)
'                .Font.ColorIndex = 3
'                .Font.Bold = True
'             End With
'       End If
' Next i
' Next j
' интересный метод
' Dim firstResult As String
' Dim c As Object
' With z.Range("A1:A50")
'  Set c = .Find("Test_", LookIn:=xlValues)
'  If Not c Is Nothing Then
'    firstResult = c.Address
'    Do
'      c.Font.Bold = True
'      Set c = .Find("asd", After:=c, LookIn:=xlValues)
'      If c Is Nothing Then Exit Do
'    Loop While c.Address <> firstResult
'  End If
'End With