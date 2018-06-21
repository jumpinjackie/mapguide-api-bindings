@echo off
pushd packages\Php\Release\x86
7z a ..\..\..\MapGuidePhpApi_%MG_VER_MAJOR%.%MG_VER_MINOR%.%MG_VER_REV%.%MG_VER_BUILD%_x86.zip *.*
popd
pushd packages\Php\Release\x64
7z a ..\..\..\MapGuidePhpApi_%MG_VER_MAJOR%.%MG_VER_MINOR%.%MG_VER_REV%.%MG_VER_BUILD%_x64.zip *.*
popd
pushd packages\Java\Release\x86
7z a ..\..\..\MapGuideJavaApi_%MG_VER_MAJOR%.%MG_VER_MINOR%.%MG_VER_REV%.%MG_VER_BUILD%_x86.zip *.*
popd
pushd packages\Java\Release\x64
7z a ..\..\..\MapGuideJavaApi_%MG_VER_MAJOR%.%MG_VER_MINOR%.%MG_VER_REV%.%MG_VER_BUILD%_x64.zip *.*
popd
