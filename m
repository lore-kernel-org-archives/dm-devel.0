From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH]: scsidh - fix a panic in 2.6.27 due to a race
	during path activation in dm multipath
Date: Fri, 29 Aug 2008 16:21:27 -0700
Message-ID: <1220052087.14830.229.camel@chandra-ubuntu>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Moving the path activation to workqueue along with scsi_dh patches introduced
a race. It is due to the fact that the current_pgpath (in the multipath data
structure) can be modified if changes happen in any of the paths leading to
the lun. If the changes lead to current_pgpath being set to NULL, then it
leads to the invalid access which results in the panic below.

This patch fixes that by storing the pgpath to activate in the multipath data
structure and properly protecting it.

Note that if activate_path is called twice in succession with different pgpath,
with the second one being called before the first one is done, then activate
path will be called twice for the second pgpath, which is fine.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
--------------------
Unable to handle kernel paging request for data at address 0x00000020
Faulting instruction address: 0xd000000000aa1844
cpu 0x1: Vector: 300 (Data Access) at [c00000006b987a80]
    pc: d000000000aa1844: .activate_path+0x30/0x218 [dm_multipath]
    lr: c000000000087a2c: .run_workqueue+0x114/0x204
    sp: c00000006b987d00
   msr: 8000000000009032
   dar: 20
 dsisr: 40000000
  current = 0xc0000000676bb3f0
  paca    = 0xc0000000006f3680
    pid   = 2528, comm = kmpath_handlerd
enter ? for help
[c00000006b987da0] c000000000087a2c .run_workqueue+0x114/0x204
[c00000006b987e40] c000000000088b58 .worker_thread+0x120/0x144
[c00000006b987f00] c00000000008ca70 .kthread+0x78/0xc4
[c00000006b987f90] c000000000027cc8 .kernel_thread+0x4c/0x68
---------------------

---
 drivers/md/dm-mpath.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

Index: linux-2.6.27-rc4/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.27-rc4.orig/drivers/md/dm-mpath.c
+++ linux-2.6.27-rc4/drivers/md/dm-mpath.c
@@ -63,6 +63,7 @@ struct multipath {
 
 	const char *hw_handler_name;
 	struct work_struct activate_path;
+	struct pgpath *pgpath_to_activate;
 	unsigned nr_priority_groups;
 	struct list_head priority_groups;
 	unsigned pg_init_required;	/* pg_init needs calling? */
@@ -146,6 +147,7 @@ static struct priority_group *alloc_prio
 
 static void free_pgpaths(struct list_head *pgpaths, struct dm_target *ti)
 {
+	unsigned long flags;
 	struct pgpath *pgpath, *tmp;
 	struct multipath *m = ti->private;
 
@@ -154,6 +156,11 @@ static void free_pgpaths(struct list_hea
 		if (m->hw_handler_name)
 			scsi_dh_detach(bdev_get_queue(pgpath->path.dev->bdev));
 		dm_put_device(ti, pgpath->path.dev);
+		if (m->pgpath_to_activate == pgpath) {
+			spin_lock_irqsave(&m->lock, flags);
+			m->pgpath_to_activate = NULL;
+			spin_unlock_irqrestore(&m->lock, flags);
+		}
 		free_pgpath(pgpath);
 	}
 }
@@ -421,6 +428,7 @@ static void process_queued_ios(struct wo
 		__choose_pgpath(m);
 
 	pgpath = m->current_pgpath;
+	m->pgpath_to_activate = m->current_pgpath;
 
 	if ((pgpath && !m->queue_io) ||
 	    (!pgpath && !m->queue_if_no_path))
@@ -1097,8 +1105,15 @@ static void activate_path(struct work_st
 	int ret;
 	struct multipath *m =
 		container_of(work, struct multipath, activate_path);
-	struct dm_path *path = &m->current_pgpath->path;
+	struct dm_path *path;
+	unsigned long flags;
 
+	spin_lock_irqsave(&m->lock, flags);
+	path = &m->pgpath_to_activate->path;
+	m->pgpath_to_activate = NULL;
+	spin_unlock_irqrestore(&m->lock, flags);
+	if (!path)
+		return;
 	ret = scsi_dh_activate(bdev_get_queue(path->dev->bdev));
 	pg_init_done(path, ret);
 }
