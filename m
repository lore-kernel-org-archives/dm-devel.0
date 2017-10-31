From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: allocate struct mapped_device with kvzalloc
Date: Tue, 31 Oct 2017 19:33:02 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1710311931190.28120@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The structure srcu_struct can be very big, its size is proportional to the 
value CONFIG_NR_CPUS. The Fedora kernel has CONFIG_NR_CPUS 8192, the field 
io_barrier in the struct mapped_device has 84kB in the debugging kernel 
and 50kB in the non-debugging kernel. The large size may result in failure 
of the function kzalloc_node.

In order to avoid the allocation failure, we use the function
kvzalloc_node, this function falls back to vmalloc if a large contiguous
chunk of memory is not available. This patch also moves the field
io_barrier to the last position of struct mapped_device - the reason is
that on many processor architectures, short memory offsets result in
smaller code than long memory offsets - on x86-64 it reduces code size by
320 bytes.

Note to stable kernel maintainers - the kernels 4.11 and older don't have
the function kvzalloc_node, you can use the function vzalloc_node instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-core.h |    3 ++-
 drivers/md/dm.c      |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h
+++ linux-2.6/drivers/md/dm-core.h
@@ -29,7 +29,6 @@ struct dm_kobject_holder {
  * DM targets must _not_ deference a mapped_device to directly access its members!
  */
 struct mapped_device {
-	struct srcu_struct io_barrier;
 	struct mutex suspend_lock;
 
 	/*
@@ -127,6 +126,8 @@ struct mapped_device {
 	struct blk_mq_tag_set *tag_set;
 	bool use_blk_mq:1;
 	bool init_tio_pdu:1;
+
+	struct srcu_struct io_barrier;
 };
 
 void dm_init_md_queue(struct mapped_device *md);
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -1695,7 +1695,7 @@ static struct mapped_device *alloc_dev(i
 	struct mapped_device *md;
 	void *old_md;
 
-	md = kzalloc_node(sizeof(*md), GFP_KERNEL, numa_node_id);
+	md = kvzalloc_node(sizeof(*md), GFP_KERNEL, numa_node_id);
 	if (!md) {
 		DMWARN("unable to allocate device, out of memory.");
 		return NULL;
@@ -1795,7 +1795,7 @@ bad_io_barrier:
 bad_minor:
 	module_put(THIS_MODULE);
 bad_module_get:
-	kfree(md);
+	kvfree(md);
 	return NULL;
 }
 
@@ -1814,7 +1814,7 @@ static void free_dev(struct mapped_devic
 	free_minor(minor);
 
 	module_put(THIS_MODULE);
-	kfree(md);
+	kvfree(md);
 }
 
 static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
