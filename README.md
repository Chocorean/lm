<div align="center">
  <a href="https://codeclimate.com/github/Chocorean/lm/test_coverage"><img src="https://api.codeclimate.com/v1/badges/811f98f93675d9e90a36/test_coverage" /></a>
  <a href="https://codeclimate.com/github/Chocorean/lm/maintainability"><img src="https://api.codeclimate.com/v1/badges/811f98f93675d9e90a36/maintainability" /></a>
</div>

# lm

lm - list last modified files in directories

> Almost like `find . -exec ls --full-time {} \; | grep -v 'total ' | sort -rk 6,7 | awk -F\  '{ print $9 }' | head -n5` !!


