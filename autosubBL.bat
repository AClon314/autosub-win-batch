@echo off
cd %~dp0
%~d0
setlocal enabledelayedexpansion
set null=
cls
if not exist autosub.exe (color 0c
echo 请将本bat放置在autosub.exe同目录下，否则不能使用
title 请将本bat放置在autosub.exe同目录下，否则不能使用
pause
exit)
set /p=<nul >>bat.inf
::set /p=<nul >>bat_m.inf
( set /p pm= && set /p mode=)<bat.inf
set mode=1

:begin
cls
set /p pm=<bat.inf
title Autosub自动处理(冰灵_nuitka版) by Nolca v0.2.1
if not "%~1"=="" title [多文件自动]Autosub自动处理(冰灵_nuitka版) by Nolca v0.2.1
echo Autosub自动处理(冰灵_nuitka版) by Nolca v0.2.1
if not "%~1"=="" echo 即将处理以下文件：
for %%i in (%*) do echo %%i
echo.
echo 当前参数:%pm%
set /p="当前模式:" <nul
if %mode%=="" echo 仅时间轴
if %mode%==1 echo 时间轴+语音识别
if %mode%==2 echo unfinished
if %mode%==3 echo 仅识别
echo.

echo 　1.设置　^>2^<开始　3.帮助　4.调试　Q.退出
echo.
choice /c 1234q /t 1 /d 2 >nul
if %errorlevel%==1 goto setting
if %errorlevel%==2 goto work
if %errorlevel%==3 goto about
if %errorlevel%==4 goto debug
if %errorlevel%==5 exit
goto begin

:work
::if %errorlevel%==2 set /p=<nul>bat.inf
set p=
set /a done=0
if not "%~1"=="" (
	::set /a all
	for %%i in (%*) do (
	set /a done+=1
	title [!done!/]%%~nxi 工作中
	autosub -i %%i !pm!
	)
) else (
	echo 拖拽文件到本窗口，回车（单文件）
	set /p p="路径:"
	if "!p!"=="" goto begin
	set /p tf="外部时间轴文件:"
	if not "!tf!"=="" set tf=-er !tf! %null%
	title [工作中] !p!
	autosub -i !p! !pm! !tf!
	set /a done+=1
)
title [完成%done%个] %p%
pause
goto begin


:setting
set /p pm=<bat.inf
echo.
echo _____________________________
echo ^>^>设置^>^>（当前参数：%pm%）
echo Tip1:请注意参数间必须有空格！
echo Tip2:目前不支持替换参数，请先手动输参删除对应参数，否则会出错
echo.
echo 　1.导出模式　　2.翻译　　3.　　4.ffmpeg（卡顿相关）　　5.Auditok断句　　6.API　　7.dos语言环境　　8.缓存清理　　9.手动输参　　0.网络代理　　Q.返回　　
echo.
choice /c 123456789q0 >nul
if %errorlevel%==1 goto s_mode
if %errorlevel%==2 goto s_trans
if %errorlevel%==3 goto s_
if %errorlevel%==4 goto s_ffmpeg
if %errorlevel%==5 goto s_auditok
if %errorlevel%==6 goto s_api
if %errorlevel%==7 goto s_doslang
if %errorlevel%==8 goto s_clean
if %errorlevel%==9 (
	if not "!pm!"=="" (
		choice /t 2 /d n /m 清除参数
		if !errorlevel!==1 set /p=<nul>bat.inf
	)
	echo 查看帮助文档，调整参数
	start bat.inf
	pause
	)
if %errorlevel%==10 goto begin

if %errorlevel%==11 (
	netsh winhttp import proxy source=ie|findstr /i "127.0.0.1:*" && (
		echo  1.走代理　　^>2^<直连/不加参数
		choice /c 12 /t 2 /d 2 >nul
		if !errorlevel!== 1 (
		set /p port=手动输入端口号（添加一次即可）：
		set /p="-hsp [127.0.0.1:!port!] "<nul>>bat.inf
		)
	echo.
))
goto setting

:s_mode
::echo 　^>1^<时间轴+识别　　2.unfinished　　3.仅时间轴　　4.仅识别　　Q.返回
::echo.
::choice /c 12340 >nul
::set /p=<nul >bat_m.inf
::if %errorlevel%==2 set /p=""<nul >>bat_m.inf
::if %errorlevel%==3 (echo 删除-S参数
::goto s_mode_1)
::if %errorlevel%==4 set /p=""<nul >>bat_m.inf
::-er xxx.srt
::if %errorlevel%==5 goto setting

echo ^>^>^>^>识别的语言类型（-S xx-xx）
echo 　1.简体  2.繁體  3.粵語  4.English(US)  5.日本語  6.韩语  9.其他  Q.返回
choice /c 123456789q >nul
if %errorlevel%==1 set /p="-S cmn-hans-cn %null%"<nul>>bat.inf
if %errorlevel%==2 set /p="-S cmn-hant-tw %null%"<nul>>bat.inf 
if %errorlevel%==3 set /p="-S yue-hant-hk %null%"<nul>>bat.inf 
if %errorlevel%==4 set /p="-S en-us %null%"<nul>>bat.inf 
if %errorlevel%==5 set /p="-S ja-jp %null%"<nul>>bat.inf 
if %errorlevel%==6 set /p="-S ko-kr %null%"<nul>>bat.inf 
if %errorlevel%==7 set /p="-S  %null%"<nul>>bat.inf 
if %errorlevel%==8 set /p="-S %null%"<nul>>bat.inf 
if %errorlevel%==9 (autosub -lsc
msg %USERNAME% /w /v 自行添加
start bat.inf
)
if %errorlevel%==10 goto setting

:s_mode_1
echo.
echo ^>^>^>^>输出字幕格式（-F xxx）
echo 1.srt  2.ass  3.sub  4.ssa  5.json  6.ass.json  7.tmp  8.txt  9.其他  Q.返回
choice /c 123456789q >nul
if %errorlevel%==1 set /p="-F srt %null%"<nul>>bat.inf
if %errorlevel%==2 set /p="-F ass %null%"<nul>>bat.inf 
if %errorlevel%==3 set /p="-F sub %null%"<nul>>bat.inf 
if %errorlevel%==4 set /p="-F ssa %null%"<nul>>bat.inf 
if %errorlevel%==5 set /p="-F json %null%"<nul>>bat.inf 
if %errorlevel%==6 set /p="-F ass.json %null%"<nul>>bat.inf 
if %errorlevel%==7 set /p="-F tmp %null%"<nul>>bat.inf 
if %errorlevel%==8 set /p="-F txt %null%"<nul>>bat.inf 
if %errorlevel%==9 (autosub -lf
msg %USERNAME% /w /v 自行添加
start bat.inf
)
goto setting

:s_trans
echo ^>^>^>^>把（源语言-SRC）……
echo 　W.与识别语言相同  1.简体  2.繁體  3.  4.English  5.日本語  6.韩语  9.其他  Q.返回
choice /c 123456789qw >nul
if %errorlevel%==1 set /p="-SRC zh-cn %null%"<nul>>bat.inf
if %errorlevel%==2 set /p="-SRC zh-tw %null%"<nul>>bat.inf 
if %errorlevel%==3 set /p="-SRC  %null%"<nul>>bat.inf 
if %errorlevel%==4 set /p="-SRC en %null%"<nul>>bat.inf 
if %errorlevel%==5 set /p="-SRC ja %null%"<nul>>bat.inf 
if %errorlevel%==6 set /p="-SRC ko %null%"<nul>>bat.inf 
if %errorlevel%==7 set /p="-SRC  %null%"<nul>>bat.inf 
if %errorlevel%==8 set /p="-SRC %null%"<nul>>bat.inf 
if %errorlevel%==9 (autosub -ltc
msg %USERNAME% /w /v 自行添加
start bat.inf
)
if %errorlevel%==10 goto setting

echo ^>^>^>^>把（%errorlevel%号源语言）翻译成（目标语言-D）……
echo 　1.简体  2.繁體  3.粵語  4.English(US)  5.日本語  6.韩语  9.其他  Q.返回
choice /c 123456789q >nul
if %errorlevel%==1 set /p="-D zh-cn %null%"<nul>>bat.inf
if %errorlevel%==2 set /p="-D zh-tw %null%"<nul>>bat.inf 
if %errorlevel%==3 set /p="-D  %null%"<nul>>bat.inf 
if %errorlevel%==4 set /p="-D en %null%"<nul>>bat.inf 
if %errorlevel%==5 set /p="-D ja %null%"<nul>>bat.inf 
if %errorlevel%==6 set /p="-D ko %null%"<nul>>bat.inf 
if %errorlevel%==7 set /p="-D  %null%"<nul>>bat.inf 
if %errorlevel%==8 set /p="-D %null%"<nul>>bat.inf 
if %errorlevel%==9 (autosub -ltc
msg %USERNAME% /w /v 自行添加
start bat.inf
)
if %errorlevel%==10 goto setting

set /p slp=几秒后开始下一个翻译请求（-slp,默认5秒）:
if not "%slp%"=="" set /p="-slp %slp% %null%"<nul>>bat.inf

choice /m 用"translate.google.cn"翻译
if %errorlevel%==1 set /p="-surl "translate.google.cn" %null%"<nul>>bat.inf

goto setting

:s_ffmpeg
echo ^>^>^>^>文件转码
echo 未完工……
goto setting

:s_auditok
echo ^>^>^>^>时间轴生成
set /p power=百分之几音量值以下算静默（-er,默认50,0~100）:
if not "%power%"=="" set /p="-et %power% %null%"<nul>>bat.inf
set /p mxcs="停顿?秒后断句（-mxcs,默认0.2秒）:"
if not "%mxcs%"=="" set /p="-mxcs %mxcs% %null%"<nul>>bat.inf
set /p mnrs="最短语音区域时间（-mnrs,默认0.8秒）:"
if not "%mnrs%"=="" set /p="-mnrs %mnrs% %null%"<nul>>bat.inf
set /p mxrs="最长语音区域时间（-mxrs,默认6.0秒）:"
if not "%mxrs%"=="" set /p="-mxrs %mxrs% %null%"<nul>>bat.inf
choice /m 严格最小划分的持续时间（-nsml,默认y）
if %errorlevel%==2 set /p="-nsml %null%"<nul>>bat.inf
choice /m 丢弃静默的语音区域（-dts,默认n）:
if %errorlevel%==1 set /p="-dts %null%"<nul>>bat.inf

goto setting

:s_api
echo ^>^>^>^>api setting
echo 选择您要使用的api
echo 　1.Google Speech v2          2.Google Cloud Speech-to-Text v1          Q.返回
choice /c 120 >nul
if %errorlevel%== 1 set /p="-sapi gsv2 %null%"<nul>>bat.inf
if %errorlevel%== 2 set /p="-sapi gcsv1 %null%"<nul>>bat.inf
if %errorlevel%== 3 goto setting
set /p skey="api key:"
if not "%skey%"=="" set /p="-skey %skey% %null%"<nul>>bat.inf
set /p sc="请求并行线程量（默认4，过大可能被封）:"
if not "%sc%"=="" set /p="-sc %sc% %null%"<nul>>bat.inf
set /p sconf="使用语音转文字识别配置文件来发送请求，路径:"
if not "%sconf%"=="" set /p="-sconf %sconf% %null%"<nul>>bat.inf
set /p mnc="低于几的识别结果会被删除（默认0,取0~1内小数）:"
if not "%mnc%"=="" set /p="-mnc %mnc% %null%"<nul>>bat.inf
choice /m 删除所有没有识别结果的空轴
if %errorlevel%== 1 set /p="-der %null%"<nul>>bat.inf
goto setting

:s_doslang
echo ^>^>^>^>dos Language environment
echo      1.GBK简体    2.BIG-5繁體    3.English    4.UTF-8    Q.Back返回
choice /c 12340 >nul
if %errorlevel%==1 chcp 936
if %errorlevel%==2 chcp 950
if %errorlevel%==3 chcp 437
if %errorlevel%==4 chcp 65001
if %errorlevel%==5 goto setting
goto s_lang

:s_clean
set /a n=0
for /f "delims=" %%i in ('dir C:\Users\%USERNAME%\AppData\Local\Temp\tmp*.wav  /b') do set /a n+=1
for /f "delims=" %%i in ('dir C:\Users\%USERNAME%\AppData\Local\Temp\tmp*.flac  /b') do set /a n+=1
if %n%==0 ( echo 没有什么要清理的。
goto setting)
choice /m 共有%n%个缓存音频，删除
if %errorlevel%==1 (del /q C:\Users\%USERNAME%\AppData\Local\Temp\tmp*.wav
del /q C:\Users\%USERNAME%\AppData\Local\Temp\tmp*.flac
echo 清理成功！)
goto setting



:about
echo.
echo ___________________________________
echo 配合AutoSub(冰灵_nuitka)，创建快捷方式以方便日常使用
set /p="当前版本:"<nul
autosub -V
echo Tip1:多文件自动模式，关闭窗口，拖拽文件到图标上（文件名、路径都不可含小括号）
echo Tip2:音频文件不可含非英文编码的元信息（歌名，否则会转换失败
echo.
echo 　1.使用手册（网页）　　2.检查更新 　　3.更新日志　　4.常见问题　　5.反馈　　6.支持的语言　　Q.返回
echo.
:about_1
choice /c 1234560 >nul
if %errorlevel%==1 start https://github.com/BingLingGroup/autosub/blob/dev/docs/README.zh-Hans.md#
if %errorlevel%==3 (
echo  v0.1:诞生了!（重写）支持基本功能
echo  v0.2:支持外部时间轴参数读入
echo  v0.2.1:取消多余的代理设置
echo  v0.2.2:增加翻译！更改默认用Q键返回；优化体验
start ..\docs\CHANGELOG.zh-Hans.md
)
if %errorlevel%==2 ( start https://github.com/BingLingGroup/autosub/releases
start https://tc5.us/dir/24781388-37986511-e27ea8)
if %errorlevel%==6 autosub -lsc
if %errorlevel%==4 ( echo 1.pyinstaller与nuitka版的区别
echo nuitka是冰灵经过编译的版本，运行更快；python版则只是打包了程序代码
echo.
)
if %errorlevel%==5 ( echo AutoSub（BingLingGroup）内核：请到项目issue中询问
echo 批处理：https://www.cnblogs.com/-AClon-/p/12538989.html（反馈在评论区）
choice /m 打开batURL
if !errorlevel!==1 start https://www.cnblogs.com/-AClon-/p/12538989.html
)
if %errorlevel%==7 goto begin
goto about_1

:debug
echo @echo off>autosubBL_debug.bat
echo title [调试]AutoSubBL>>autosubBL_debug.bat
echo cmd>>autosubBL_debug.bat
echo cls>>autosubBL_debug.bat
echo 在新窗口中调试
start /w autosubBL_debug.bat
::del .\autosubBL_debug.bat
goto begin

::编写批处理的总结
::小括号内的语句是同时执行的，需要声明延迟环境变量，并把要延迟传递的变量用!!括起来
::小括号内不能有注释，否则会出错
pause
