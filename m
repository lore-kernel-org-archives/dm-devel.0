From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 4/8] dm-integrity: add ic->start in
	get_data_sector
Date: Tue, 01 May 2018 15:55:20 +0200
Message-ID: <20180501135602.961941544@debian.vm>
References: <20180501135516.961417937@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline;
	filename=dm-integrity-move-start-to-get_data_sector.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

A small refactoring. Add the variable ic->start in get_data_sector and not
in the callers. This is a prerequisite for the patch that uses external
metadata device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2018-02-01 20:38:17.038213000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2018-02-06 17:31:35.816018000 +0100
@@ -386,6 +386,8 @@ static sector_t get_data_sector(struct d
 		result += (area + 1) * ic->metadata_run;
 
 	result += (sector_t)ic->initial_sectors + offset;
+	result += ic->start;
+
 	return result;
 }
 
@@ -857,7 +859,7 @@ static void copy_from_journal(struct dm_
 	io_req.notify.context = data;
 	io_req.client = ic->io;
 	io_loc.bdev = ic->dev->bdev;
-	io_loc.sector = ic->start + target;
+	io_loc.sector = target;
 	io_loc.count = n_sectors;
 
 	r = dm_io(&io_req, 1, &io_loc, NULL);
@@ -1701,7 +1703,6 @@ sleep:
 	bio->bi_end_io = integrity_end_io;
 
 	bio->bi_iter.bi_size = dio->range.n_sectors << SECTOR_SHIFT;
-	bio->bi_iter.bi_sector += ic->start;
 	generic_make_request(bio);
 
 	if (need_sync_io) {
@@ -2339,7 +2340,7 @@ static int calculate_device_limits(struc
 	get_area_and_offset(ic, ic->provided_data_sectors - 1, &last_area, &last_offset);
 	last_sector = get_data_sector(ic, last_area, last_offset);
 
-	if (ic->start + last_sector < last_sector || ic->start + last_sector >= ic->device_sectors)
+	if (last_sector < ic->start || last_sector >= ic->device_sectors)
 		return -EINVAL;
 
 	return 0;
