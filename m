From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: merge dcssblk in similar
	blacklist regex
Date: Sun, 16 Oct 2016 15:59:46 +0200
Message-ID: <20161016135946.6479-1-xose.vazquez@gmail.com>
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

Similar patterns.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/blacklist.c   | 8 +-------
 multipath/multipath.conf.5 | 2 +-
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index aa8d975..f6c4506 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -172,7 +172,7 @@ setup_default_blist (struct config * conf)
 	char * str;
 	int i;
 
-	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]");
+	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]");
 	if (!str)
 		return 1;
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
@@ -184,12 +184,6 @@ setup_default_blist (struct config * conf)
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
 		return 1;
 
-	str = STRDUP("^dcssblk[0-9]");
-	if (!str)
-		return 1;
-	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
-		return 1;
-
 	str = STRDUP("^nvme");
 	if (!str)
 		return 1;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 313e21b..367688e 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -851,7 +851,7 @@ The following keywords are recognized:
 Regular expression of the device nodes to be excluded.
 .RS
 .TP
-Default value is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]\fR, \fB^(td|hd|vd)[a-z]\fR, \fB^dcssblk[0-9]\fR and \fB^nvme\fR
+Default value is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]\fR, \fB^(td|hd|vd)[a-z]\fR and \fB^nvme\fR
 .RE
 .TP
 .B wwid
-- 
2.10.1
