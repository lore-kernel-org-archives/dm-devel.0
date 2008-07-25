From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH] dm_set_device_limits: when ignoring
	q->merge_bvec_fn, set
	rs->max_phys_segments to one to avoid violating it
Date: Fri, 25 Jul 2008 14:52:52 +0200
Message-ID: <20080725125252.GC28245@soda.linbit>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Restricting max_sectors is not enough.
If someone uses bio_add_page to add 8 disjunct 512 byte
partial pages to a bio, it would succeed,
but could still cross a border of whatever restrictions
are below us (raid0 stripe boundary).  An attempted
bio_split would not succeed, because bi_vcnt is 8.
E.g. the xen io layer is known to do trigger this.

Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---

should maybe be "backported" to the stable series kernels as well,
at least if one plans to use xen vm's on top of lvm on top of
md or drbd.

 drivers/md/dm-table.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 798e468..5995381 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -512,11 +512,22 @@ void dm_set_device_limits(struct dm_target *ti, struct block_device *bdev)
 	 * smaller I/O, just to be safe.
 	 */
 
-	if (q->merge_bvec_fn && !ti->type->merge)
+	if (q->merge_bvec_fn && !ti->type->merge) {
 		rs->max_sectors =
 			min_not_zero(rs->max_sectors,
 				     (unsigned int) (PAGE_SIZE >> 9));
 
+		/* Restricting max_sectors is not enough.
+		 * If someone uses bio_add_page to add 8 disjunct 512 byte
+		 * partial pages to a bio, it would succeed,
+		 * but could still cross a border of whatever restrictions
+		 * are below us (raid0 stripe boundary).  An attempted
+		 * bio_split would not succeed, because bi_vcnt is 8.
+		 * E.g. the xen io layer is known to do trigger this.
+		 */
+		rs->max_phys_segments = 1;
+	}
+
 	rs->max_phys_segments =
 		min_not_zero(rs->max_phys_segments,
 			     q->max_phys_segments);
-- 
1.5.5.GIT

-- 
: Lars Ellenberg                            Tel +43-1-8178292-55 :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
