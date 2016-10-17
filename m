From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: fix DEFAULT values
Date: Mon, 17 Oct 2016 18:32:01 +0200
Message-ID: <20161017163201.26755-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

replace RR_WEIGHT_NONE with DEFAULT_RR_WEIGHT, and define DEFAULT_FLUSH

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/defaults.h | 1 +
 libmultipath/propsel.c  | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 9bf27d6..d00a86f 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -31,6 +31,7 @@
 #define DEFAULT_PRIO		"const"
 #define DEFAULT_PRIO_ARGS	""
 #define DEFAULT_CHECKER		TUR
+#define DEFAULT_FLUSH		FLUSH_DISABLED
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 1625990..88a1916 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -137,7 +137,7 @@ select_rr_weight (struct config *conf, struct multipath * mp)
 	mp_set_ovr(rr_weight);
 	mp_set_hwe(rr_weight);
 	mp_set_conf(rr_weight);
-	mp_set_default(rr_weight, RR_WEIGHT_NONE);
+	mp_set_default(rr_weight, DEFAULT_RR_WEIGHT);
 out:
 	print_rr_weight(buff, 13, &mp->rr_weight);
 	condlog(3, "%s: rr_weight = %s %s", mp->alias, buff, origin);
@@ -550,7 +550,7 @@ select_flush_on_last_del(struct config *conf, struct multipath *mp)
 	mp_set_ovr(flush_on_last_del);
 	mp_set_hwe(flush_on_last_del);
 	mp_set_conf(flush_on_last_del);
-	mp_set_default(flush_on_last_del, FLUSH_DISABLED);
+	mp_set_default(flush_on_last_del, DEFAULT_FLUSH);
 out:
 	condlog(3, "%s: flush_on_last_del = %s %s", mp->alias,
 		(mp->flush_on_last_del == FLUSH_ENABLED)? "yes" : "no", origin);
-- 
2.10.1
