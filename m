From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: remove pointless ".*" from
	devnode blacklists
Date: Mon,  3 Oct 2016 17:53:20 +0200
Message-ID: <20161003155320.17792-1-xose.vazquez@gmail.com>
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

".*" is useless at the end of a regex, and just "*" is a bug.
And document them.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/blacklist.c   | 8 ++++----
 multipath/multipath.conf.5 | 6 +++++-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 9687399..aa8d975 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -172,7 +172,7 @@ setup_default_blist (struct config * conf)
 	char * str;
 	int i;
 
-	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*");
+	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]");
 	if (!str)
 		return 1;
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
@@ -184,19 +184,19 @@ setup_default_blist (struct config * conf)
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
 		return 1;
 
-	str = STRDUP("^dcssblk[0-9]*");
+	str = STRDUP("^dcssblk[0-9]");
 	if (!str)
 		return 1;
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
 		return 1;
 
-	str = STRDUP("^nvme.*");
+	str = STRDUP("^nvme");
 	if (!str)
 		return 1;
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
 		return 1;
 
-	str = STRDUP("(SCSI_IDENT_.*|ID_WWN)");
+	str = STRDUP("(SCSI_IDENT_|ID_WWN)");
 	if (!str)
 		return 1;
 	if (store_ble(conf->elist_property, str, ORIGIN_DEFAULT))
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 7dd997a..7bb847a 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -849,6 +849,10 @@ The following keywords are recognized:
 .TP 17
 .B devnode
 Regular expression of the device nodes to be excluded.
+.RS
+.TP
+Default value is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]\fR, \fB^(td|hd|vd)[a-z]\fR, \fB^dcssblk[0-9]\fR and \fB^nvme\fR
+.RE
 .TP
 .B wwid
 The \fIWorld Wide Identification\fR of a device.
@@ -888,7 +892,7 @@ The \fIWorld Wide Identification\fR of a device.
 Regular expression of the udev property to be whitelisted.
 .RS
 .TP
-Default value is: \fB(ID_WWN|SCSI_IDENT_.*)\fR
+Default value is: \fB(SCSI_IDENT_|ID_WWN)\fR
 .RE
 .TP
 .B device
-- 
2.10.0
