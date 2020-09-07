From: Brian Bunker <brian@purestorage.com>
Subject: fix for kernel BUG at
 drivers/scsi/device_handler/scsi_dh_alua.c:662!
Date: Mon, 7 Sep 2020 12:55:05 -0700
Message-ID: <EA072C02-DFA6-440C-88CB-5E379FBB23FD@purestorage.com>
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.0.3\))
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello all,

From my earlier post:
https://www.redhat.com/archives/dm-devel/2020-September/msg00083.html

Would it be better to move the unsetting the address of sdev to NULL lower? This would protect
against the crash we see when the alua_rtpg function tries to access the sdev address
that has been set to NULL in alua_bus_detach by another thread.

--- a/linux-5.4.17/drivers/scsi/device_handler/scsi_dh_alua.c	2020-07-29 22:48:30.000000000 -0600
+++ b/linux-5.4.17/drivers/scsi/device_handler/scsi_dh_alua.c	2020-09-07 13:38:23.771575702 -0600
@@ -1146,15 +1146,15 @@
 
 	spin_lock(&h->pg_lock);
 	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
-	rcu_assign_pointer(h->pg, NULL);
-	h->sdev = NULL;
-	spin_unlock(&h->pg_lock);
 	if (pg) {
 		spin_lock_irq(&pg->lock);
 		list_del_rcu(&h->node);
 		spin_unlock_irq(&pg->lock);
 		kref_put(&pg->kref, release_port_group);
 	}
+	rcu_assign_pointer(h->pg, NULL);
+	h->sdev = NULL;
+	spin_unlock(&h->pg_lock);
 	sdev->handler_data = NULL;
 	kfree(h);
 }

Thanks,
Brian

Brian Bunker
SW Eng
brian@purestorage.com
