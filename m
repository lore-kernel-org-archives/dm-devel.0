From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath-tools: Default configuration changes
Date: Tue, 20 Oct 2009 14:49:47 -0500
Message-ID: <20091020194947.GQ3555@ether.msp.redhat.com>
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

Add support for some more MSA arrays.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c  |    2 +-
 multipath.conf.defaults |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: multipath-tools-091013/libmultipath/hwtable.c
===================================================================
--- multipath-tools-091013.orig/libmultipath/hwtable.c
+++ multipath-tools-091013/libmultipath/hwtable.c
@@ -128,7 +128,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		/* MSA 1000/1500 with new firmware */
-		.vendor        = "HP",
+		.vendor        = "(COMPAQ|HP)",
 		.product       = "MSA VOLUME",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
Index: multipath-tools-091013/multipath.conf.defaults
===================================================================
--- multipath-tools-091013.orig/multipath.conf.defaults
+++ multipath-tools-091013/multipath.conf.defaults
@@ -91,7 +91,7 @@
 #		prio			hp_sw
 #	}
 #	device {
-#		vendor			"HP"
+#		vendor			"(COMPAQ|HP)"
 #		product			"MSA VOLUME"
 #		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
@@ -122,7 +122,7 @@
 #	}
 #	device {
 #		vendor			"(COMPAQ|HP)"
-#		product			"HSV1[01]1|HSV2[01]0|HSV300"
+#		product			"HSV1[01]1|HSV2[01]0|HSV300|HSV4[05]0"
 #		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
