# remove, public folder will created later
rm -rf public

git add .
git commit -m 'hugo project init'

# push
git push -u origin main

# Create a new orphand branch (no commit history) named gh-pages
git checkout --orphan gh-pages

# Unstage all files
# -rf themes/hyde
git rm -rf --cached $(git ls-files)

# Add and commit that file
git add .
git commit -m "init: initial commit on gh-pages branch"

# Push to remote gh-pages branch
git push origin gh-pages

# Return to main branch
git checkout main

# Remove the public folder to make room for the gh-pages subtree
rm -rf public

# Add the gh-pages branch of the repository. It will look like a folder named public
git subtree add --prefix=public https://github.com/Roykesydon/Blog.git gh-pages --squash

# Pull down the file we just committed. This helps avoid merge conflicts
git subtree pull --prefix=public https://github.com/Roykesydon/Blog.git gh-pages

# Run hugo. Generated site will be placed in public directory (or omit -t ThemeName if you're not using a theme)
./hugo.exe

# Add everything
git add -A

# Commit and push to main
git commit -m "Updating site" && git push origin main

# Push the public subtree to the gh-pages branch
git subtree push --prefix=public https://github.com/Roykesydon/Blog.git gh-pages
