From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 7 of 10] LVM:  monitor mirrored logs
Date: Fri, 26 Feb 2010 17:36:50 -0600
Message-ID: <201002262336.o1QNaooR024496@hydrogen.msp.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: lvm-monitor-mirrored-logs.patch

Log volume of a mirror can also be a mirror with the following patchset.
http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/10232
If so, monitor such log volumes.

Signed-off-by: Malahal Naineni (malahal@us.ibm.com)

Index: LVM2/lib/activate/activate.c
===================================================================
--- LVM2.orig/lib/activate/activate.c
+++ LVM2/lib/activate/activate.c
@@ -737,6 +737,7 @@ int monitor_dev_for_events(struct cmd_co
 	int r = 1;
 	struct dm_list *tmp, *snh, *snht;
 	struct lv_segment *seg;
+	struct lv_segment *log_seg;
 	int (*monitor_fn) (struct lv_segment *s, int e);
 	uint32_t s;
 
@@ -772,6 +773,16 @@ int monitor_dev_for_events(struct cmd_co
 		return r;
 	}
 
+	/*
+	 * If the volume is mirrored and its log is also mirrored, monitor
+	 * the log volume as well.
+	 */
+	if ((seg = first_seg(lv)) != NULL && seg->log_lv != NULL &&
+	    (log_seg = first_seg(seg->log_lv)) != NULL &&
+	    seg_is_mirrored(log_seg))
+		if (!monitor_dev_for_events(cmd, seg->log_lv, monitor))
+			r = 0;
+
 	dm_list_iterate(tmp, &lv->segments) {
 		seg = dm_list_item(tmp, struct lv_segment);
 
