From: tang.wenji@zte.com.cn
Subject: [PATCH] multipath-tools: increase the print length of
	the multipath fields
Date: Thu, 10 Nov 2016 20:32:01 +0800
Message-ID: <1478781121-10924-1-git-send-email-tang.wenji@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.wenji" <tang.wenji@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.wenji" <tang.wenji@zte.com.cn>

The maximum field length is set to 64, which may be truncated when
displayed.
E.g:the multipath's 'features' field sets as "6 queue_if_no_path
pg_init_retries 3 pg_init_delay_msecs 30 retain_attached_hw_handler",  but
it shows as "6 queue_if_no_path pg_init_retries 3 pg_init_delay_msecs 30 ret" .

Signed-off-by: tang.wenji <tang.wenji@zte.com.cn>
---
 libmultipath/print.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/print.h b/libmultipath/print.h
index 6839fc7..b8c3436 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -66,7 +66,7 @@
 
 #define MAX_LINE_LEN  80
 #define MAX_LINES     64
-#define MAX_FIELD_LEN 64
+#define MAX_FIELD_LEN 128
 #define PROGRESS_LEN  10
 
 struct path_data {
-- 
2.8.1.windows.1
