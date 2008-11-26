From: jvrao <jvrao@linux.vnet.ibm.com>
Subject: Re:  [PATCHES] new solution for dm_any_congested crash
Date: Wed, 26 Nov 2008 13:41:32 -0800
Message-ID: <492DC28C.8070508@linux.vnet.ibm.com>
References: <1226688863.8998.67.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060705000002030105040707"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1226688863.8998.67.camel@chandra-ubuntu>
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
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Chandra <sekharan@linux.vnet.ibm.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------060705000002030105040707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I was the one who initially stumbled onto this problem, and when I 
realized that it is the ABBA deadlock, I approached Chandra and Mike.
Chandra came up with the initial fix, and it worked fine.
 
Later Chandra pointed me to this patch, and when I tried it on.. I ran 
into system hang.

Please note that, I am running it on -rt kernel based on 2.6.24. I could 
not apply the patch directly, so I ported it onto my kernel.
I am attaching the ported version(new_dm_patch)..I already ran this 
ported patch by Chandra.

I ran IO stress test with this patch while one of the paths is 
constantly bounced . Bounced the same path all the time. (20min between 
the bounces)
System hung few hours into the test..and I forced the dump. I am still 
analyzing the dump.
If you want to have the dump, please let me know where I can upload it 
to. Core is around 8G

Here are few things from the dump that might be interesting.

crash> ps |grep udev | wc -l
425 << <<<425 udevd threads at the time of hang.
crash> ps | wc -l
782
crash> foreach bt| grep rt_mutex_slowlock | wc -l
416 < <<<<416 of the the total 782 threads are waiting for a lock.
crash>
crash> struct rt_mutex ffff81024ec6cca0
struct rt_mutex {
  wait_lock = {
    raw_lock = {
      slock = 49858
    },
    break_lock = 0
  },
  wait_list = {
    prio_list = {
      next = 0xffff8101007f5ae0,
      prev = 0xffff8101007f5ae0
    },
    node_list = {
      next = 0xffff8101007f5af0,
      prev = 0xffff81007cb51af0
    }
  },
  owner = 0xffff8102400c2b22
}
Following task is holding the lock that many other udevs are waiting for.
PID: 21896  TASK: ffff8102400c2b20  CPU: 6   COMMAND: "udevd" << Holding
 #0 [ffff810100667848] schedule at ffffffff8128531c
 #1 [ffff810100667900] io_schedule at ffffffff81285859
 #2 [ffff810100667920] sync_buffer at ffffffff810d1fc1
 #3 [ffff810100667930] __wait_on_bit at ffffffff81285ad1
 #4 [ffff810100667970] out_of_line_wait_on_bit at ffffffff81285b71
 #5 [ffff8101006679e0] __wait_on_buffer at ffffffff810d1f41
 #6 [ffff8101006679f0] ext3_find_entry at ffffffff8803c1d2
 #7 [ffff810100667b60] ext3_lookup at ffffffff8803dbae
 #8 [ffff810100667ba0] do_lookup at ffffffff810b78cf
 #9 [ffff810100667bf0] __link_path_walk at ffffffff810b94ef
#10 [ffff810100667c90] link_path_walk at ffffffff810b9f99
#11 [ffff810100667d60] path_walk at ffffffff810ba04b
#12 [ffff810100667d70] do_path_lookup at ffffffff810ba352
#13 [ffff810100667dc0] __path_lookup_intent_open at ffffffff810bae88
#14 [ffff810100667e10] path_lookup_open at ffffffff810baf38
#15 [ffff810100667e20] open_exec at ffffffff810b41e3
#16 [ffff810100667ed0] do_execve at ffffffff810b53a2
#17 [ffff810100667f20] sys_execve at ffffffff8100ac30
#18 [ffff810100667f50] stub_execve at ffffffff8100c5c7

PID: 21946  TASK: ffff81007f090b20  CPU: 4   COMMAND: "udevd" << One of 
the udevds waiting for the lock.
 #0 [ffff81007f0e59f8] schedule at ffffffff8128531c
 #1 [ffff81007f0e5ab0] rt_mutex_slowlock at ffffffff81286a95
 #2 [ffff81007f0e5b80] rt_mutex_lock at ffffffff81285f84
 #3 [ffff81007f0e5b90] _mutex_lock at ffffffff812873f9
 #4 [ffff81007f0e5ba0] do_lookup at ffffffff810b788b
 #5 [ffff81007f0e5bf0] __link_path_walk at ffffffff810b94ef
 #6 [ffff81007f0e5c90] link_path_walk at ffffffff810b9f99
 #7 [ffff81007f0e5d60] path_walk at ffffffff810ba04b
 #8 [ffff81007f0e5d70] do_path_lookup at ffffffff810ba352
 #9 [ffff81007f0e5dc0] __path_lookup_intent_open at ffffffff810bae88
#10 [ffff81007f0e5e10] path_lookup_open at ffffffff810baf38
#11 [ffff81007f0e5e20] open_exec at ffffffff810b41e3
#12 [ffff81007f0e5ed0] do_execve at ffffffff810b53a2
#13 [ffff81007f0e5f20] sys_execve at ffffffff8100ac30
#14 [ffff81007f0e5f50] stub_execve at ffffffff8100c5c7
   

Thanks,
Venkateswararao Jujjuri (JV)
Realtime Team, LTC,
Beaverton, OR 97006
>
> ------------------------------------------------------------------------
>
> Subject:
> [PATCHES] new solution for dm_any_congested crash
> From:
> Mikulas Patocka <mpatocka@redhat.com>
> Date:
> Thu, 13 Nov 2008 20:55:27 -0500 (EST)
> To:
> Alasdair G Kergon <agk@redhat.com>, Chandra Seetharaman 
> <sekharan@us.ibm.com>
>
> To:
> Alasdair G Kergon <agk@redhat.com>, Chandra Seetharaman 
> <sekharan@us.ibm.com>
> CC:
> dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
>
>
> Hi
>
> The Chandra's patch was correct, but the problem is more serious (the same 
> crash could happen in dm_merge_bvec, dm_unplug_all or at some other dm 
> places), so I had to rework reference counting.
>
> These are three patches.
> 1. reverts Chadra's changes
> 2. just a little swap of two calls, to prepare for the third
> 3. the reference counting rework
>
> Chandra, please test the patches at your system (without your original 
> patch) and verify that they avoid the crashes as well as your patch does.
>
> Mikulas


--------------060705000002030105040707
Content-Type: text/plain;
 name="new_dm_patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="new_dm_patch"

Index: linux-2.6.24.7-ibmrt2.16-view/drivers/md/dm.c
===================================================================
--- linux-2.6.24.7-ibmrt2.16-view.orig/drivers/md/dm.c
+++ linux-2.6.24.7-ibmrt2.16-view/drivers/md/dm.c
@@ -876,20 +876,16 @@ static void dm_unplug_all(struct request
 
 static int dm_any_congested(void *congested_data, int bdi_bits)
 {
-	int r = bdi_bits;
+	int r;
 	struct mapped_device *md = (struct mapped_device *) congested_data;
-	struct dm_table *map;
+	struct dm_table *map = dm_get_table(md);
 
-	atomic_inc(&md->pending);
-	if (!test_bit(DMF_BLOCK_IO, &md->flags)) {
-		map = dm_get_table(md);
-		if (map) {
-			r = dm_table_any_congested(map, bdi_bits);
-			dm_table_put(map);
-		}
-	}
-	if (!atomic_dec_return(&md->pending))
-		wake_up(&md->wait);
+	if (!map || test_bit(DMF_BLOCK_IO, &md->flags))
+		r = bdi_bits;
+	else
+		r = dm_table_any_congested(map, bdi_bits);
+
+	dm_table_put(map);
 	return r;
 }
 
@@ -1143,10 +1139,11 @@ static int __bind(struct mapped_device *
 
 	if (md->suspended_bdev)
 		__set_size(md, size);
-	if (size == 0)
+	if (size == 0) {
+		dm_table_destroy(t);
 		return 0;
+	}
 
-	dm_table_get(t);
 	dm_table_event_callback(t, event_callback, md);
 
 	write_lock(&md->map_lock);
@@ -1168,7 +1165,7 @@ static void __unbind(struct mapped_devic
 	write_lock(&md->map_lock);
 	md->map = NULL;
 	write_unlock(&md->map_lock);
-	dm_table_put(map);
+	dm_table_destroy(map);
 }
 
 /*
@@ -1256,8 +1253,8 @@ void dm_put(struct mapped_device *md)
 			dm_table_presuspend_targets(map);
 			dm_table_postsuspend_targets(map);
 		}
-		__unbind(md);
 		dm_table_put(map);
+		__unbind(md);
 		free_dev(md);
 	}
 }
Index: linux-2.6.24.7-ibmrt2.16-view/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.24.7-ibmrt2.16-view.orig/drivers/md/dm-ioctl.c
+++ linux-2.6.24.7-ibmrt2.16-view/drivers/md/dm-ioctl.c
@@ -232,7 +232,7 @@ static void __hash_remove(struct hash_ce
 	}
 
 	if (hc->new_map)
-		dm_table_put(hc->new_map);
+		dm_table_destroy(hc->new_map);
 	dm_put(hc->md);
 	free_cell(hc);
 }
@@ -826,8 +826,8 @@ static int do_resume(struct dm_ioctl *pa
 
 		r = dm_swap_table(md, new_map);
 		if (r) {
+			dm_table_destroy(new_map);
 			dm_put(md);
-			dm_table_put(new_map);
 			return r;
 		}
 
@@ -835,8 +835,6 @@ static int do_resume(struct dm_ioctl *pa
 			set_disk_ro(dm_disk(md), 0);
 		else
 			set_disk_ro(dm_disk(md), 1);
-
-		dm_table_put(new_map);
 	}
 
 	if (dm_suspended(md))
@@ -1079,7 +1077,7 @@ static int table_load(struct dm_ioctl *p
 	}
 
 	if (hc->new_map)
-		dm_table_put(hc->new_map);
+		dm_table_destroy(hc->new_map);
 	hc->new_map = t;
 	up_write(&_hash_lock);
 
@@ -1108,7 +1106,7 @@ static int table_clear(struct dm_ioctl *
 	}
 
 	if (hc->new_map) {
-		dm_table_put(hc->new_map);
+		dm_table_destroy(hc->new_map);
 		hc->new_map = NULL;
 	}
 
Index: linux-2.6.24.7-ibmrt2.16-view/drivers/md/dm-table.c
===================================================================
--- linux-2.6.24.7-ibmrt2.16-view.orig/drivers/md/dm-table.c
+++ linux-2.6.24.7-ibmrt2.16-view/drivers/md/dm-table.c
@@ -59,6 +59,19 @@ struct dm_table {
 	void *event_context;
 };
 
+ /*
+ * New table reference rules:
+ *
+ * The table has always exactly one reference from either mapped_device->map
+ * or hash_cell->new_map. This reference is not counted in table->holders.
+ * A pair of dm_create_table/dm_destroy_table functions is used for table
+ * creation/destruction.
+ *
+ * Temporary references from the other code increase table->holders. A pair
+ * of dm_table_get/dm_table_put functions is used to manipulate it.
+ *
+ * When the table is about to be destroyed, we wait for table->holders.
+ */
 /*
  * Similar to ceiling(log_size(n))
  */
@@ -226,7 +239,7 @@ int dm_table_create(struct dm_table **re
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&t->devices);
-	atomic_set(&t->holders, 1);
+	atomic_set(&t->holders, 0);
 
 	if (!num_targets)
 		num_targets = KEYS_PER_NODE;
@@ -294,10 +307,14 @@ static void free_devices(struct list_hea
 	}
 }
 
-static void table_destroy(struct dm_table *t)
+void dm_table_destroy(struct dm_table *t)
 {
 	unsigned int i;
 
+	while (atomic_read(&t->holders))
+		yield();
+	smp_mb();
+
 	/* free the indexes (see dm_table_complete) */
 	if (t->depth >= 2)
 		vfree(t->index[t->depth - 2]);
@@ -335,8 +352,9 @@ void dm_table_put(struct dm_table *t)
 	if (!t)
 		return;
 
-	if (atomic_dec_and_test(&t->holders))
-		table_destroy(t);
+	smp_mb__before_atomic_dec();
+	atomic_dec(&t->holders);
+
 }
 
 /*
Index: linux-2.6.24.7-ibmrt2.16-view/drivers/md/dm.h
===================================================================
--- linux-2.6.24.7-ibmrt2.16-view.orig/drivers/md/dm.h
+++ linux-2.6.24.7-ibmrt2.16-view/drivers/md/dm.h
@@ -100,6 +100,7 @@ struct dm_table;
 /*-----------------------------------------------------------------
  * Internal table functions.
  *---------------------------------------------------------------*/
+void dm_table_destroy(struct dm_table *t);
 void dm_table_event_callback(struct dm_table *t,
 			     void (*fn)(void *), void *context);
 struct dm_target *dm_table_get_target(struct dm_table *t, unsigned int index);

--------------060705000002030105040707
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060705000002030105040707--
