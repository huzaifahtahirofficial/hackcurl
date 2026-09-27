# Create the repo structure
mkdir -p hackcurl-pro/docs/screenshots
cd hackcurl-pro

# Create README.md (paste the content above)
nano README.md

# Create LICENSE (paste the MIT text above)
nano LICENSE

# Add your script
cp ~/sh/easy_hackcurl.sh ./hackcurl.sh
chmod +x hackcurl.sh

# Fix line endings just in case
sed -i 's/\r$//' hackcurl.sh

# Initialize git
git init
git add .
git commit -m "Initial commit: HACKCURL PRO v2.1"

# Push to GitHub
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/hackcurl-pro.git
git push -u origin main
