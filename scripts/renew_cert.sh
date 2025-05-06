#!/usr/bin/env bash
set -e

LE_DIR="/home/winhome/docker-web/certs"
WEBROOT="/var/www/certbot"
DOMAIN="twwinhome.com"
LOG_FILE="/home/winhome/docker-web/scripts/renew_cert.log"

echo "=== $(date '+%F %T') Renew start ===" >> "$LOG_FILE"

# 檢查現有憑證的到期日期
EXPIRY_DATE=$(openssl x509 -in "${LE_DIR}/live/${DOMAIN}/fullchain.pem" -noout -enddate | cut -d= -f2)
echo "Current certificate expiry date: $EXPIRY_DATE" >> "$LOG_FILE"

# 執行續簽，並顯示是否更新
OUTPUT=$(sudo certbot renew --webroot -w ${WEBROOT} --quiet --force-renewal 2>&1)
RET=$?

# 打印 certbot 輸出
echo "certbot output: $OUTPUT" >> "$LOG_FILE"

if grep -q "No renewals were attempted" <<< "$OUTPUT"; then
  echo "No cert renewal needed. Current certificate expiry date: $EXPIRY_DATE" >> "$LOG_FILE"
else
  if [ $RET -eq 0 ]; then
    # 如果有成功更新憑證，重啟 nginx
    sudo docker exec nginx_web nginx -s reload
    EXP=$(openssl x509 -in "${LE_DIR}/live/${DOMAIN}/fullchain.pem" \
          -noout -enddate | cut -d= -f2)
    echo "Renew succeeded; new expiry: ${EXP}" >> "$LOG_FILE"
  else
    echo "Renew failed with exit code $RET" >> "$LOG_FILE"
  fi
fi

echo "=== Renew end ===" >> "$LOG_FILE"
