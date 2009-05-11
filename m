From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] i/o errors with dm-over-md-raid0
Date: Mon, 11 May 2009 12:35:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0905111226120.1438@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is an upstream patch for upstream for 
https://bugzilla.redhat.com/show_bug.cgi?id=223947

The RHEL-5 patch is in the bugzilla, it is different but has the same 
functionality.

Milan, if you have time, please could you (or someone else in Brno lab) 
try to reproduce the bug, then apply the patch and verify that it fixed 
it?

In short, the RHEL 5 setup is:
* MD - RAID-0
* lvm on the top of it
* one of the logical volumes (linear volume) is exported to xen domU
* inside xen domU it is partitioned, the key point is that the partition 
must be unaligned on page boundary (fdisk normally aligns the partition to 
63 sectors, that will trigger it)
* install the system on the partitioned disk in domU -> I/O failures in 
dom0

In upstream kernel, there are some merge changes, the bug should no longer 
happen with linear volumes, but you should be able to reproduce it if you 
use some other dm target --- dm-raid1, dm-snapshot (with chunk size larger 
than RAID-0 stripe) or dm-stripe (with stripe size larger than RAID-0 
stripe).

Mikulas

---

Explanation of the bug and fix:
(https://bugzilla.redhat.com/show_bug.cgi?id=223947)

In Linux bio architecture, it is the responsibility of the caller that
he is not creating bio too large for the appropriate block device
driver.

There are several ways how bio size can be limited.
- There is q->max_hw_sectors that is the upper limit of total number of
  sectors.
- These are q->max_phys_segments and q->max_hw_segments that limit
  number of consecutive segments (before and after iommu merging).
- There is q->max_segment_size and q->seg_boundary_mask that determine
  how much data fits in a segment and at which points there are enforced
  segment boundaries (because some hardware have limitation on entries
  in its scatter-gather table)
- There is q->hardsect_size which determines the hardware sector size,
  and so all sector numbers and lengths must be aligned on this
  boundary.
- And there is q->merge_bvec_fn --- the process that constructs the bio
  can use this function to ask the device driver if the next vector
  entry will fit into the bio.

Additionally, by definition, it is always allowed to create a bio that
spans one page or less and has just one bio vector entry.

All of the above restrictions except q->merge_bvec_fn can be merged.
I.e. if you have several devices with different limitations, and you run
device mapper on the top of them, it is possible to combine the
limitations, take the lowest of the values (except for q->hardsect_size
where we take the highest value). If can be then assumed that the bio
submitted for device mapper (which satisfies the combined limitations)
will satisfy the limitations of every underlying device.

The problem is with q->merge_bvec_fn. If some of the underlying devices
in device mapper device set its q->merge_bvec_fn, device mapper has no
way to propagate it to its own limits (for certain targets, few of the
targets allow pripagating merge_bvec_fn). So in this case, the device
mapper sets its maximum request size to one page (because bios containes
within a page are allowed). Such small bios degrade performance but at
least it works.

And here comes the bug: raid0, raid1, raid10 and raid5 set
q->merge_bvec_fn in such a way that they reject bios crossing its
stripe. They accept bios with one vector entry crossing a stripe (they
must) and they split that bio - but they don't accept any other bios
crossing a stripe.

A bio that has two or more vector entries, size less or equal than page
size and that crosses stripe boundary is accepted by device mapper (it
conforms to all its limits) but not by the underlying raid device.

The fix is: if the device mapper set one-page maximum request size, it also
needs to set its own q->merge_bvec_fn that will reject any bios with
multiple vector entries that span more pages.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.30-rc5-fast/drivers/md/dm.c
===================================================================
--- linux-2.6.30-rc5-fast.orig/drivers/md/dm.c	2009-05-11 18:09:29.000000000 +0200
+++ linux-2.6.30-rc5-fast/drivers/md/dm.c	2009-05-11 18:25:36.000000000 +0200
@@ -973,6 +973,15 @@ static int dm_merge_bvec(struct request_
 	 */
 	if (max_size && ti->type->merge)
 		max_size = ti->type->merge(ti, bvm, biovec, max_size);
+	/*
+	 * If the target doesn't support merge method and some of the devices
+	 * provided their merge_bvec method (we know this by looking at
+	 * max_hw_sectors), then we can't allow bios with multiple vector
+	 * entries. - So always set max_size to 0 and the code below allows
+	 * just one page.
+	 */
+	else if (q->max_hw_sectors <= PAGE_SIZE >> 9)
+		max_size = 0;
 
 out_table:
 	dm_table_put(map);
