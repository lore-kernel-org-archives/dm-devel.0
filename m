From: Neil Brown <neilb@suse.de>
Subject: [PATCH-RFC] Bug in dm-raid1 as used by pvmove
Date: Tue, 9 May 2006 14:55:28 +1000
Message-ID: <17504.8384.533148.557081@cse.unsw.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


Hi,
 We have a report of a system oops during pvmove.

 What appears to be happening is core_in_sync is being passed
 a 'region' is which much too large.  When this is indexed into the
 bitset at lc->sync_bits it hits an unmapped page, and results in an
 oops.

 I believe the problem is in bio_to_region.  See the patch below.

 If a section of an lv which is *not* at the start of the lv is being
 moved using dm-raid1, I think the region number is being calculated
 wrongly resulting in the inappropriately large index.  We really
 need to subtract ti->begin from bi_sector before shifting.

 We will try to get this patch tested on the machine that showed the
 fault, but I would appreciate any feedback about the patch and I am
 still not very familiar with this code.

Thanks,
NeilBrown



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/dm-raid1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/dm-raid1.c~current~ ./drivers/md/dm-raid1.c
--- ./drivers/md/dm-raid1.c~current~	2006-05-09 14:47:35.000000000 +1000
+++ ./drivers/md/dm-raid1.c	2006-05-09 14:47:35.000000000 +1000
@@ -111,7 +111,7 @@ struct region {
  */
 static inline region_t bio_to_region(struct region_hash *rh, struct bio *bio)
 {
-	return bio->bi_sector >> rh->region_shift;
+	return (bio->bi_sector - rh->ms->ti->begin) >> rh->region_shift;
 }
 
 static inline sector_t region_to_sector(struct region_hash *rh, region_t region)
