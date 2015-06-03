From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3.10] add dm_internal_suspend and dm_internal_resume
Date: Wed, 3 Jun 2015 11:02:34 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506031100260.14129@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is partial backport of fd2ed4d252701d3bbed4cd3e3d267ad469bb832a 
(only the dm_internal_suspend and dm_internal_resume functions are 
backported). This is needed for further patches.

Mikulas


commit fd2ed4d252701d3bbed4cd3e3d267ad469bb832a
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Fri Aug 16 10:54:23 2013 -0400

    dm: add statistics support
    
    Support the collection of I/O statistics on user-defined regions of
    a DM device.  If no regions are defined no statistics are collected so
    there isn't any performance impact.  Only bio-based DM devices are
    currently supported.
    
    Each user-defined region specifies a starting sector, length and step.
    Individual statistics will be collected for each step-sized area within
    the range specified.
    
    The I/O statistics counters for each step-sized area of a region are
    in the same format as /sys/block/*/stat or /proc/diskstats but extra
    counters (12 and 13) are provided: total time spent reading and
    writing in milliseconds.  All these counters may be accessed by sending
    the @stats_print message to the appropriate DM device via dmsetup.
    
    The creation of DM statistics will allocate memory via kmalloc or
    fallback to using vmalloc space.  At most, 1/4 of the overall system
    memory may be allocated by DM statistics.  The admin can see how much
    memory is used by reading
    /sys/module/dm_mod/parameters/stats_current_allocated_bytes
    
    See Documentation/device-mapper/statistics.txt for more details.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
    Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm.c |   33 +++++++++++++++++++++++++++++++++
 drivers/md/dm.h |    3 +++
 2 files changed, 36 insertions(+)

Index: linux-stable/drivers/md/dm.c
===================================================================
--- linux-stable.orig/drivers/md/dm.c	2015-06-03 16:46:06.000000000 +0200
+++ linux-stable/drivers/md/dm.c	2015-06-03 16:54:13.000000000 +0200
@@ -2680,6 +2680,39 @@ out:
 	return r;
 }
 
+/*
+ * Internal suspend/resume works like userspace-driven suspend. It waits
+ * until all bios finish and prevents issuing new bios to the target drivers.
+ * It may be used only from the kernel.
+ *
+ * Internal suspend holds md->suspend_lock, which prevents interaction with
+ * userspace-driven suspend.
+ */
+
+void dm_internal_suspend(struct mapped_device *md)
+{
+	mutex_lock(&md->suspend_lock);
+	if (dm_suspended_md(md))
+		return;
+
+	down_write(&md->io_lock);
+	set_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
+	up_write(&md->io_lock);
+	flush_workqueue(md->wq);
+	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
+}
+
+void dm_internal_resume(struct mapped_device *md)
+{
+	if (dm_suspended_md(md))
+		goto done;
+
+	dm_queue_flush(md);
+
+done:
+	mutex_unlock(&md->suspend_lock);
+}
+
 /*-----------------------------------------------------------------
  * Event notification.
  *---------------------------------------------------------------*/
Index: linux-stable/drivers/md/dm.h
===================================================================
--- linux-stable.orig/drivers/md/dm.h	2015-06-03 16:54:17.000000000 +0200
+++ linux-stable/drivers/md/dm.h	2015-06-03 16:54:32.000000000 +0200
@@ -167,6 +167,9 @@ int dm_lock_for_deletion(struct mapped_d
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
 		      unsigned cookie);
 
+void dm_internal_suspend(struct mapped_device *md);
+void dm_internal_resume(struct mapped_device *md);
+
 int dm_io_init(void);
 void dm_io_exit(void);
 
