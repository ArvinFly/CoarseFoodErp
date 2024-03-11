@echo off

:START
echo #############################################################################
echo sourceFolder���������vs������Ŀ��·��Debug
echo md5File�����������ļ�ִ�е�md5����Ч��ֵ
echo destinationFolder ��������µ�����,ȫ��
echo differentialFolder�����������µ��ļ�(����Ҫ����,ֻ��Ҫ�����ⲿ��)
echo �޸�Ŀ¼·��,��ʹ�ñ༭�ı�;���߲���,ֱ��д��vs���ɺ��¼�,��ȡ·������
echo ���ʹ��vs���ɺ� ����д:  call "C:\Users\Administrator.DESKTOP-KTHCAT9\Desktop\��ָ���.bat" $(ProjectName) $(ProjectDir) ǰ�����������λ��
echo ����Ҫѹ���ĸ�ʽ,Ŀ¼ "E:\WinRar\WinRAR.exe" a -r -ep1 -u -x"002.bat" "C:\Users\Administrator.DESKTOP-KTHCAT9\Desktop\!ProjectName!.zip"
echo #############################################################################

echo ����ִ�����������...

setlocal enabledelayedexpansion

rem ��������������
set "sourceFolder=%2\bin\Debug"
set "md5File=md5_hashes.txt"
set "destinationFolder=%2\bin\Update"
set "differentialFolder=%2\bin\DiffUpDate"
set ProjectName=%1

if not exist "%destinationFolder%" mkdir "%destinationFolder%"
if not exist "%differentialFolder%" mkdir "%differentialFolder%"

cd /d "%sourceFolder%"

(for %%F in (*) do (
    set "fileName=%%F"
    for /f %%H in ('certutil -hashfile "%%F" MD5 ^| findstr /i /v "MD5 CertUtil ���"') do (
        echo !fileName! : %%H
    )
)) > "%destinationFolder%\%md5File%"

cd /d "%destinationFolder%"
set "updateCount=0"

for /f "tokens=1,2" %%A in (%md5File%) do (
    set "fileName=%%A"
    set "hash=%%B"
    set "existingFile=%sourceFolder%\!fileName!"
    set "destinationFile=%destinationFolder%\!fileName!"

    if not exist "!destinationFile!" (
        copy "!existingFile!" "%destinationFolder%\!fileName!" > nul
        echo Copied: "!fileName!"
        set /a updateCount+=1
    ) else (
        certutil -hashfile "!existingFile!" MD5 | findstr /i /v "MD5 CertUtil ���" > "%destinationFolder%\temp_hash.txt"
        certutil -hashfile "!destinationFile!" MD5 | findstr /i /v "MD5 CertUtil ���" > "%destinationFolder%\temp_hash_dest.txt"
        fc /b "%destinationFolder%\temp_hash.txt" "%destinationFolder%\temp_hash_dest.txt" > nul

        if errorlevel 1 (
            copy "!existingFile!" "%destinationFolder%\!fileName!" > nul
            echo Updated: "!fileName!"
            set /a updateCount+=1
            copy "!existingFile!" "%differentialFolder%" > nul
        )

        del /q "%destinationFolder%\temp_hash.txt" "%destinationFolder%\temp_hash_dest.txt" > nul
    )
)

if %updateCount% gtr 0 (
    echo Files Updated. Copying updated files to A folder...
  "E:\WinRar\WinRAR.exe" a -r -ep1 -u -x"002.bat" "C:\Users\Administrator.DESKTOP-KTHCAT9\Desktop\!ProjectName!.zip" "%2\bin\DiffUpDate\*.*"
) else (
    echo No updates found.
)

pause
endlocal
