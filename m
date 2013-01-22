From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath: add HSV3[46]0 to
	multipath.conf.defaults
Date: Tue, 22 Jan 2013 12:49:03 +0100
Message-ID: <1358855343-3160-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath.conf.defaults | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index c9f58d5..ad32343 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -151,7 +151,7 @@
 #	}
 #	device {
 #		vendor "(COMPAQ|HP)"
-#		product "HSV1[01]1|HSV2[01]0|HSV300|HSV4[05]0"
+#		product "HSV1[01]1|HSV2[01]0|HSV3[046]0|HSV4[05]0"
 #		path_grouping_policy "group_by_prio"
 #		path_checker "tur"
 #		features "0"
-- 
1.7.11.7
