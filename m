From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath-tools: Change default configs to look
	for "hp_sw" not "hp-sw"
Date: Tue, 20 Oct 2009 13:20:42 -0500
Message-ID: <20091020182042.GO3555@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The kernel hp_sw handler now wants the hwhandler string to be "hp_sw", not
"hp-sw".  This fixes the default configs to match.

Signed-off-by: Fabio M. Di Nitto <fdinitto@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
:100644 100644 2f1699f... a207fc6... M	libmultipath/hwtable.c
:100644 100644 fb1dd6c... d24a801... M	multipath.conf.defaults
 libmultipath/hwtable.c  |    4 ++--
 multipath.conf.defaults |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 2f1699f..a207fc6 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -85,7 +85,7 @@ static struct hwentry default_hw[] = {
 		.product       = "HSG80",
 		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = "1 hp-sw",
+		.hwhandler     = "1 hp_sw",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
@@ -116,7 +116,7 @@ static struct hwentry default_hw[] = {
 		.product       = "(MSA|HSV)1.0.*",
 		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = "1 hp-sw",
+		.hwhandler     = "1 hp_sw",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index fb1dd6c..d24a801 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -54,7 +54,7 @@
 #		product			"HSG80"
 #		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"1 queue_if_no_path"
-#		hardware_handler	"1 hp-sw"
+#		hardware_handler	"1 hp_sw"
 #		path_selector		"round-robin 0"
 #		path_grouping_policy	multibus
 #		rr_weight		uniform
@@ -81,7 +81,7 @@
 #		product			"(MSA|HSV)1.0.*"
 #		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"1 queue_if_no_path"
-#		hardware_handler	"1 hp-sw"
+#		hardware_handler	"1 hp_sw"
 #		path_selector		"round-robin 0"
 #		path_grouping_policy	group_by_prio
 #		rr_weight		uniform
-- 
1.6.5.rc2
