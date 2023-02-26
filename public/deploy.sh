echo "確定要上傳到 github 嗎？請輸入 yes 或 no"
read answer

if [ "$answer" != "yes" ]; then
  echo "腳本執行已中斷"
  exit 1
fi

echo "繼續上傳..."

# deploy.sh
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
./hugo.exe

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin main
git subtree push --prefix=public https://github.com/Roykesydon/Blog.git gh-pages
