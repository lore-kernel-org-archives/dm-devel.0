From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH] dm: max_segments=1 if merge_bvec_fn is not
	supported
Date: Sat, 6 Mar 2010 22:10:13 +0100
Message-ID: <20100306211012.GA9689@racke>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, jens.axboe@oracle.com
List-Id: dm-devel.ids

If the lower device exposes a merge_bvec_fn,
dm_set_device_limits() restricts max_sectors
to PAGE_SIZE "just to be safe".

This is not sufficient, however.

If someone uses bio_add_page() to add 8 disjunct 512 byte partial
pages to a bio, it would succeed, but could still cross a border
of whatever restrictions are below us (e.g. raid10 stripe boundary).
An attempted bio_split() would not succeed, because bi_vcnt is 8.

One example that triggered this frequently is the xen io layer.

raid10_make_request bug: can't convert block across chunks or bigger than 64k 209265151 1

Signed-off-by: Lars <lars.ellenberg@linbit.com>

---

Neil: you may want to double check linear.c and raid*.c for similar logic,
even though it is unlikely that someone puts md raid6 on top of something
exposing a merge_bvec_fn.

This is not the first time this has been patched, btw.
See https://bugzilla.redhat.com/show_bug.cgi?id=440093
and the patch by Mikulas:
https://bugzilla.redhat.com/attachment.cgi?id=342638&action=diff

---
 drivers/md/dm-table.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4b22feb..c686ff4 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -515,14 +515,22 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 
 	/*
 	 * Check if merge fn is supported.
-	 * If not we'll force DM to use PAGE_SIZE or
+	 * If not we'll force DM to use single bio_vec of PAGE_SIZE or
 	 * smaller I/O, just to be safe.
 	 */
 
-	if (q->merge_bvec_fn && !ti->type->merge)
+	if (q->merge_bvec_fn && !ti->type->merge) {
 		limits->max_sectors =
 			min_not_zero(limits->max_sectors,
 				     (unsigned int) (PAGE_SIZE >> 9));
+		/* Restricting max_sectors is not enough.
+		 * If someone uses bio_add_page to add 8 disjunct 512 byte
+		 * partial pages to a bio, it would succeed,
+		 * but could still cross a border of whatever restrictions
+		 * are below us (e.g. raid0 stripe boundary).  An attempted
+		 * bio_split() would not succeed, because bi_vcnt is 8. */
+		limits->max_segments = 1;
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);
-- 
1.6.3.3
