From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Fix rr_min_io_rq keyword name in multipath.conf.5
Date: Fri, 22 Mar 2013 13:02:55 +0100
Message-ID: <1363953775-16166-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Leonardo Chiquitto <lchiquitto@suse.com>
List-Id: dm-devel.ids

From: Leonardo Chiquitto <lchiquitto@suse.com>

Fix typo.

Signed-off-by: Leonardo Chiquitto <lchiquitto@suse.com>
Acked-by: Hannes Reinecke <hare@suse.de>

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 29106b0..7d689e6 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -270,7 +270,7 @@ The number of IO to route to a path before switching to the next in
 the same path group. This is only for BIO based multipath. Default is
 .I 1000
 .TP
-.B rr_min_io_q
+.B rr_min_io_rq
 The number of IO requests to route to a path before switching to the
 next in the same path group. This is only for request based multipath.
 Default is
@@ -496,7 +496,7 @@ section:
 .TP
 .B rr_min_io
 .TP
-.B rr_min_io_q
+.B rr_min_io_rq
 .TP
 .B features
 .TP
