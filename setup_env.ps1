Write-Host "🧠 Setting up AI Handwriting Recognizer Environment..." -ForegroundColor Cyan

# --- Step 1: Check Python 3.11 ---
$pythonVersion = (python --version 2>$null)
if ($pythonVersion -notmatch "3\.11") {
    Write-Host "`n⚠️  Python 3.11 not detected!" -ForegroundColor Yellow
    Write-Host "👉 Download it from: https://www.python.org/downloads/release/python-3118/"
    Write-Host "Make sure to check 'Add Python 3.11 to PATH' during installation."
    exit
}

# --- Step 2: Clean any previous venv ---
if (Test-Path ".venv") {
    Write-Host "`n🧹 Removing old virtual environment..."
    Remove-Item -Recurse -Force ".venv"
}

# --- Step 3: Create new venv ---
Write-Host "`n📦 Creating new virtual environment (.venv)..."
python -m venv .venv

# --- Step 4: Activate venv ---
Write-Host "`n🚀 Activating virtual environment..."
& .\.venv\Scripts\activate

# --- Step 5: Upgrade pip ---
Write-Host "`n⬆️  Upgrading pip, setuptools, and wheel..."
python -m pip install --upgrade pip setuptools wheel

# --- Step 6: Create requirements file ---
$reqs = @"
numpy==1.26.4
opencv-python==4.9.0.80
matplotlib==3.8.4
tensorflow==2.16.1
streamlit==1.38.0
pytesseract==0.3.10
Pillow==10.3.0
"@
Set-Content -Path "requirements.txt" -Value $reqs -Encoding UTF8

# --- Step 7: Install dependencies ---
Write-Host "`n📥 Installing project dependencies..."
pip install -r requirements.txt

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n❌ Installation failed. Check above for errors." -ForegroundColor Red
    exit
}

# --- Step 8: Verify core imports ---
Write-Host "`n🔍 Verifying imports..."
python - <<EOF
import cv2, numpy, tensorflow, streamlit, pytesseract, PIL
print("✅ All core libraries loaded successfully!")
EOF

# --- Step 9: Launch Streamlit app ---
Write-Host "`n🚀 Launching the app..."
streamlit run src/app.py
