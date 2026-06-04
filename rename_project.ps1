$baseDir = "C:\Users\omar7\AndroidStudioProjects\headofdepartment"

$filesToUpdate = @(
    "$baseDir\README.md",
    "$baseDir\android\app\build.gradle.kts",
    "$baseDir\android\app\src\main\AndroidManifest.xml",
    "$baseDir\android\app\src\main\kotlin\com\example\headofdepartment\MainActivity.kt",
    "$baseDir\ios\Runner.xcodeproj\project.pbxproj",
    "$baseDir\ios\Runner\Info.plist",
    "$baseDir\pubspec.yaml",
    "$baseDir\test\widget_test.dart",
    "$baseDir\web\index.html",
    "$baseDir\web\manifest.json",
    "$baseDir\.idea\modules.xml"
)

foreach ($file in $filesToUpdate) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        $content = $content -replace "headofdepartment", "program_manager"
        Set-Content -Path $file -Value $content -Encoding UTF8
    }
}

# Rename MainActivity package folder
$oldPkgDir = "$baseDir\android\app\src\main\kotlin\com\example\headofdepartment"
$newPkgDir = "$baseDir\android\app\src\main\kotlin\com\example\program_manager"
if (Test-Path $oldPkgDir) {
    Rename-Item -Path $oldPkgDir -NewName "program_manager"
}

# Rename IML files
if (Test-Path "$baseDir\headofdepartment.iml") {
    Rename-Item -Path "$baseDir\headofdepartment.iml" -NewName "program_manager.iml"
}
if (Test-Path "$baseDir\android\headofdepartment_android.iml") {
    Rename-Item -Path "$baseDir\android\headofdepartment_android.iml" -NewName "program_manager_android.iml"
}

Write-Host "Internal rename complete."
