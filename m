From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: standardize on path_selector
Date: Fri, 3 Dec 2010 17:58:46 -0600
Message-ID: <20101203235846.GM25172@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Since the devices and multipaths sections of multipath.conf use
"path_selector", set the defaults section to use it was well, instead of
"selector".

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c        |    2 +-
 multipath.conf.annotated   |    4 ++--
 multipath.conf.defaults    |    2 +-
 multipath.conf.synthetic   |    2 +-
 multipath/multipath.conf.5 |   18 +++++++++++++++---
 5 files changed, 20 insertions(+), 8 deletions(-)

Index: multipath-tools-101104/libmultipath/dict.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/dict.c
+++ multipath-tools-101104/libmultipath/dict.c
@@ -2220,7 +2220,7 @@ init_keywords(void)
 	install_keyword("polling_interval", &polling_interval_handler, &snprint_def_polling_interval);
 	install_keyword("udev_dir", &udev_dir_handler, &snprint_def_udev_dir);
 	install_keyword("multipath_dir", &multipath_dir_handler, &snprint_def_multipath_dir);
-	install_keyword("selector", &def_selector_handler, &snprint_def_selector);
+	install_keyword("path_selector", &def_selector_handler, &snprint_def_selector);
 	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint_def_path_grouping_policy);
 	install_keyword("getuid_callout", &def_getuid_callout_handler, &snprint_def_getuid_callout);
 	install_keyword("prio", &def_prio_handler, &snprint_def_prio);
Index: multipath-tools-101104/multipath.conf.annotated
===================================================================
--- multipath-tools-101104.orig/multipath.conf.annotated
+++ multipath-tools-101104/multipath.conf.annotated
@@ -27,14 +27,14 @@
 #	polling_interval 10
 #
 #	#
-#	# name    : selector
+#	# name    : path_selector
 #	# scope   : multipath & multipathd
 #	# desc    : the default path selector algorithm to use
 #	#           these algorithms are offered by the kernel multipath target
 #	# values  : "round-robin 0"
 #	# default : "round-robin 0"
 #	#
-#	selector	"round-robin 0"
+#	path_selector	"round-robin 0"
 #
 #	#
 #	# name    : path_grouping_policy
Index: multipath-tools-101104/multipath.conf.defaults
===================================================================
--- multipath-tools-101104.orig/multipath.conf.defaults
+++ multipath-tools-101104/multipath.conf.defaults
@@ -4,7 +4,7 @@
 #defaults {
 #	udev_dir		/dev
 #	polling_interval	5
-#	selector		"round-robin 0"
+#	path_selector		"round-robin 0"
 #	path_grouping_policy	failover
 #	getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #	prio			const
Index: multipath-tools-101104/multipath.conf.synthetic
===================================================================
--- multipath-tools-101104.orig/multipath.conf.synthetic
+++ multipath-tools-101104/multipath.conf.synthetic
@@ -5,7 +5,7 @@
 #defaults {
 #	udev_dir		/dev
 #	polling_interval 	10
-#	selector		"round-robin 0"
+#	path_selector		"round-robin 0"
 #	path_grouping_policy	multibus
 #	getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #	prio			const
Index: multipath-tools-101104/multipath/multipath.conf.5
===================================================================
--- multipath-tools-101104.orig/multipath/multipath.conf.5
+++ multipath-tools-101104/multipath/multipath.conf.5
@@ -101,10 +101,22 @@ default verbosity. Higher values increas
 levels are between 0 and 6; default is
 .I 2
 .TP
-.B selector
+.B path_selector
 The default path selector algorithm to use; they are offered by the
-kernel multipath target. The only currently implemented is
-.I "round-robin 0"
+kernel multipath target. There are three selector algorithms.
+.RS
+.TP 12
+.B "round-robin 0"
+Loop through every path in the path group, sending the same amount of IO to
+each.
+.TP
+.B "queue-length 0"
+Send the next bunch of IO down the path with the least amount of outstanding IO.
+.TP
+.B "service-time 0"
+Choose the path for the next bunch of IO based on the amount of outstanding IO
+to the path and its relative throughput.
+.RE
 .TP
 .B path_grouping_policy
 The default path grouping policy to apply to unspecified
