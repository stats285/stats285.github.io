
git checkout master

if [ $? -eq 0 ]; then
echo "ON MASTER"

cp -r _site/* .
# add html files only
git add *.html
git commit -am "updated the website"


echo "pushing master"
git push

echo "Going back to DEV"
git checkout dev


else
echo "CANNOT SWITCH TO MASTER"

fi


