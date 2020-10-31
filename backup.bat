set current_path_project=%~dp0

cd /D  %current_path_project%

for %%I in (.) do set current_folder_name=%%~nxI

E:\sirc_workspace\sirc-dev-notes\bkp_project\copy_folder.bat %current_path_project%\..\ E:\BKP_CODE\ %current_folder_name% E:\sirc_workspace\sirc-dev-notes\bkp_project\exclude_bkp.txt