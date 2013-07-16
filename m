From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/30] multipath.conf.annotated: Document
	rr_min_io_rq
Date: Tue, 16 Jul 2013 09:13:06 +0200
Message-ID: <1373958801-103613-16-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

rr_min_io_rq wasn't documented in multipath.conf.annotated.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath.conf.annotated | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index 15ec468..7ed62de 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -128,10 +128,24 @@
 #	# name    : rr_min_io
 #	# scope   : multipath & multipathd
 #	# desc    : the number of IO to route to a path before switching
-#	#           to the next in the same path group
+#	#           to the next in the same path group for the bio-based
+#	#           multipath implementation. This parameter is used for
+#	#           kernels version up to 2.6.31; newer kernel version
+#	#           use the parameter rr_min_io_rq
 #	# default : 1000
 #	#
-#	rr_min_io	100
+#	rr_min_io	1000
+#
+#	#
+#	# name    : rr_min_io_rq
+#	# scope   : multipath & multipathd
+#	# desc    : the number of IO to route to a path before switching
+#	#           to the next in the same path group for the request-based
+#	#           multipath implementation. This parameter is used for
+#	#           kernels versions later than 2.6.31.
+#	# default : 1
+#	#
+#	rr_min_io_rq	1
 #
 #	#
 #	# name    : flush_on_last_del
-- 
1.7.12.4
