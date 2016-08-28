From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: request to update man
	pages/TEMPLATE if "device subsection" keywords are changed
Date: Mon, 29 Aug 2016 00:41:04 +0200
Message-ID: <1472424064-9669-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

and s/keywork/keyword

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/dict.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index e8c6804..7c21e72 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1330,7 +1330,7 @@ snprint_deprecated (struct config *conf, char * buff, int len, void * data)
 #define __deprecated
 
 /*
- * If you add or remove a keywork also update multipath/multipath.conf.5
+ * If you add or remove a keyword also update multipath/multipath.conf.5
  */
 void
 init_keywords(vector keywords)
@@ -1421,7 +1421,10 @@ init_keywords(vector keywords)
 	__deprecated install_keyword("product", &ble_product_handler, &snprint_bled_product);
 	__deprecated install_sublevel_end();
 #endif
-
+/*
+ * If you add or remove a "device subsection" keyword also update
+ * multipath/multipath.conf.5 and the TEMPLATE in libmultipath/hwtable.c
+ */
 	install_keyword_root("devices", &devices_handler);
 	install_keyword_multi("device", &device_handler, NULL);
 	install_sublevel();
-- 
2.7.4
