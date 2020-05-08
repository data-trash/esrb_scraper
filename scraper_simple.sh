#!/bin/bash
echo "certificate,game,esrb_rating,platform_name,company" > ./datasets/games_esrb_ratings_short.csv
for ((i=1; i < 3500; i++))
do
curl 'https://www.esrb.org/wp-admin/admin-ajax.php' \
  -H 'authority: www.esrb.org' \
  -H 'pragma: no-cache' \
  -H 'cache-control: no-cache' \
  -H 'accept: application/json, text/javascript, */*; q=0.01' \
  -H 'dnt: 1' \
  -H 'x-requested-with: XMLHttpRequest' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4128.3 Safari/537.36' \
  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'origin: https://www.esrb.org' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-dest: empty' \
  -H 'referer: https://www.esrb.org/search/?searchKeyword=GTA%20Compilation&platform=All%20Platforms&rating=E&descriptor=All%20Content&pg=1&searchType=All' \
  -H 'accept-language: en-CA,en-US,en-GB,en;q=0.9,fr-CA,fr-FR,fr-CH,fr;q=0.8' \
  --data "action=search_rating&args%5BsearchKeyword%5D=&args%5BsearchType%5D=All&args%5Bpg%5D=$i&args%5Bplatform%5D%5B%5D=All+Platforms&args%5Bdescriptor%5D%5B%5D=All+Content" \
  --compressed | \
  jq -r '.games[]|[.certificate,.title,.rating,.platforms,.company] | @csv' \
  >> ./datasets/games_esrb_ratings_short.csv
done
