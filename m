From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath-tools: Minor doc fix
Date: Tue, 20 Oct 2009 14:48:54 -0500
Message-ID: <20091020194854.GP3555@ether.msp.redhat.com>
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

The polling_interval increases caused some confusion, so I'm adding it
to the documentation.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath.conf.annotated   |    4 +++-
 multipath/multipath.conf.5 |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

Index: multipath-tools-091013/multipath.conf.annotated
===================================================================
--- multipath-tools-091013.orig/multipath.conf.annotated
+++ multipath-tools-091013/multipath.conf.annotated
@@ -18,7 +18,9 @@
 #	#
 #	# name    : polling_interval
 #	# scope   : multipathd
-#	# desc    : interval between two path checks in seconds
+#	# desc    : interval between two path checks in seconds. For
+#	#           properly functioning paths, the interval between checks
+#	#           will gradually increase to (4 * polling_interval).
 #	# values  : n > 0
 #	# default : 5
 #	#
Index: multipath-tools-091013/multipath/multipath.conf.5
===================================================================
--- multipath-tools-091013.orig/multipath/multipath.conf.5
+++ multipath-tools-091013/multipath/multipath.conf.5
@@ -67,7 +67,9 @@ The
 section recognizes the following keywords:
 .TP 17
 .B polling_interval
-interval between two path checks in seconds; default is
+interval between two path checks in seconds For properly functioning paths,
+the interval between checks will gradually increase to (4 * polling_interval);
+default is
 .I 5
 .TP
 .B udev_dir
