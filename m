From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 02/12] kpartx: don't delete partitions from
	partitions
Date: Thu,  7 Dec 2017 12:48:56 -0600
Message-ID: <1512672546-12785-3-git-send-email-bmarzins@redhat.com>
References: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The current del-part-nodes rules try to run partx on the partitions
themselves, which will ofen fail with an error in the log, because the
partitions will have been deleted before partx can run on them.

Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/del-part-nodes.rules | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kpartx/del-part-nodes.rules b/kpartx/del-part-nodes.rules
index cee945d..17bc505 100644
--- a/kpartx/del-part-nodes.rules
+++ b/kpartx/del-part-nodes.rules
@@ -12,6 +12,7 @@
 SUBSYSTEM!="block", GOTO="end_del_part_nodes"
 KERNEL!="sd*|dasd*|rbd*", GOTO="end_del_part_nodes"
 ACTION!="add|change", GOTO="end_del_part_nodes"
+ENV{DEVTYPE}=="partition", GOTO="end_del_part_nodes"
 
 IMPORT{cmdline}="dont_del_part_nodes"
 ENV{dont_del_part_nodes}=="1", GOTO="end_del_part_nodes"
-- 
2.7.4
