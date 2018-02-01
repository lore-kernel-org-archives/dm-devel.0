From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 1/4] dm unstriped: support non power of 2 chunk
	size
Date: Thu,  1 Feb 2018 19:06:09 +0100
Message-ID: <5fb708419717b6a0508de258f061cdefc8538a8c.1517504857.git.heinzm@redhat.com>
References: <cover.1517504857.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1517504857.git.heinzm@redhat.com>
In-Reply-To: <cover.1517504857.git.heinzm@redhat.com>
References: <cover.1517504857.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

Address "FIXME: must support non power of 2 chunk_size, dm-stripe.c does".

Bump target version to indicate change.

Allow for module loading adding alias as long as we keep dm-unstripe.ko.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/unstriped.txt |  5 +++++
 drivers/md/dm-unstripe.c                  | 23 +++++++++++------------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/Documentation/device-mapper/unstriped.txt b/Documentation/device-mapper/unstriped.txt
index 0b2a306c54ee..00c904f74a4f 100644
--- a/Documentation/device-mapper/unstriped.txt
+++ b/Documentation/device-mapper/unstriped.txt
@@ -122,3 +122,8 @@ dmsetup create raid_disk0 --table '0 512 unstriped 4 256 0 /dev/mapper/striped 0
 dmsetup create raid_disk1 --table '0 512 unstriped 4 256 1 /dev/mapper/striped 0'
 dmsetup create raid_disk2 --table '0 512 unstriped 4 256 2 /dev/mapper/striped 0'
 dmsetup create raid_disk3 --table '0 512 unstriped 4 256 3 /dev/mapper/striped 0'
+
+Version history
+---------------
+1.0.0	- initial version
+1.0.1	- support non power of 2 chunk size
diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index 65f838fa2e99..c06a386bcc79 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -69,12 +69,6 @@ static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto err;
 	}
 
-	// FIXME: must support non power of 2 chunk_size, dm-stripe.c does
-	if (!is_power_of_2(uc->chunk_size)) {
-		ti->error = "Non power of 2 chunk_size is not supported yet";
-		goto err;
-	}
-
 	if (kstrtouint(argv[2], 10, &uc->unstripe)) {
 		ti->error = "Invalid stripe number";
 		goto err;
@@ -98,7 +92,7 @@ static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	uc->unstripe_offset = uc->unstripe * uc->chunk_size;
 	uc->unstripe_width = (uc->stripes - 1) * uc->chunk_size;
-	uc->chunk_shift = fls(uc->chunk_size) - 1;
+	uc->chunk_shift = is_power_of_2(uc->chunk_size) ? fls(uc->chunk_size) - 1 : 0;
 
 	tmp_len = ti->len;
 	if (sector_div(tmp_len, uc->chunk_size)) {
@@ -129,14 +123,18 @@ static sector_t map_to_core(struct dm_target *ti, struct bio *bio)
 {
 	struct unstripe_c *uc = ti->private;
 	sector_t sector = bio->bi_iter.bi_sector;
+	sector_t tmp_sector = sector;
 
 	/* Shift us up to the right "row" on the stripe */
-	sector += uc->unstripe_width * (sector >> uc->chunk_shift);
+	if (uc->chunk_shift)
+		tmp_sector >>= uc->chunk_shift;
+	else
+		sector_div(tmp_sector, uc->chunk_size);
 
-	/* Account for what stripe we're operating on */
-	sector += uc->unstripe_offset;
+	sector += uc->unstripe_width * tmp_sector;
 
-	return sector;
+	/* Account for what stripe we're operating on */
+	return sector + uc->unstripe_offset;
 }
 
 static int unstripe_map(struct dm_target *ti, struct bio *bio)
@@ -185,7 +183,7 @@ static void unstripe_io_hints(struct dm_target *ti,
 
 static struct target_type unstripe_target = {
 	.name = "unstriped",
-	.version = {1, 0, 0},
+	.version = {1, 0, 1},
 	.module = THIS_MODULE,
 	.ctr = unstripe_ctr,
 	.dtr = unstripe_dtr,
@@ -215,5 +213,6 @@ module_init(dm_unstripe_init);
 module_exit(dm_unstripe_exit);
 
 MODULE_DESCRIPTION(DM_NAME " unstriped target");
+MODULE_ALIAS("dm-unstriped");
 MODULE_AUTHOR("Scott Bauer <scott.bauer@intel.com>");
 MODULE_LICENSE("GPL");
-- 
2.14.3
