From: Eric Ren <zren@suse.com>
Subject: [PATCH] dm mirror: fix crash caused by NULL-pointer
	dereference
Date: Mon, 26 Jun 2017 17:08:48 +0800
Message-ID: <20170626090848.21585-1-zren@suse.com>
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
To: dm-devel@redhat.com
Cc: snitzer@redhat.com, zren@suse.com, neilb@suse.com, jtang@suse.com, agk@redhat.com
List-Id: dm-devel.ids

When the primary mirror device fails, activating a mirrored
LV will crash the kernel. It can be reproduced 100% with the
scripts below:

"""
dd if=/dev/zero of=file.raw bs=1G count=1
loopdev=$(losetup -f)
losetup $loopdev file.raw
dmsetup create pv1 --table "0 102399 linear $loopdev 0"
dmsetup create pv2 --table "0 102399 linear $loopdev 102400"
vgcreate vgtest /dev/mapper/pv1 /dev/mapper/pv2
lvcreate -l1 --type mirror -m1 -n mirror12 --mirrorlog core \
                 vgtest /dev/mapper/pv1 /dev/mapper/pv2
vgchange -an vgtest
echo 0 10000000 error | dmsetup load /dev/mapper/pv1
dmsetup resume /dev/mapper/pv1
vgchange -ay vgtest
"""

The call trace:
"""
[  287.008629] device-mapper: raid1: Unable to read primary mirror during recovery
[  287.008632] device-mapper: raid1: Primary mirror (254:10) failed while out-of-sync: Reads may fail.
...
[  287.012480] BUG: unable to handle kernel NULL pointer dereference at 0000000000000019
[  287.012515] IP: [<ffffffffa00d944f>] mirror_end_io+0x7f/0x130 [dm_mirror]
...
[  291.994645] Call Trace:
[  291.994671]  [<ffffffffa007b215>] clone_endio+0x35/0xe0 [dm_mod]
[  291.994675]  [<ffffffffa0589ced>] do_reads+0x17d/0x1d0 [dm_mirror]
[  291.994680]  [<ffffffffa058af5c>] do_mirror+0xec/0x250 [dm_mirror]
[  291.994687]  [<ffffffff810958fe>] process_one_work+0x14e/0x410
[  291.994691]  [<ffffffff81096156>] worker_thread+0x116/0x490
[  291.994694]  [<ffffffff8109b627>] kthread+0xc7/0xe0
"""

Fixes it by setting "details.bi_bdev" to NULL in error path beforing
calling into mirror_end_io(), which will fail the IO properly.

Reported-by: Jerry Tang <jtang@suse.com>
Signed-off-by: Eric Ren <zren@suse.com>
---
 drivers/md/dm-raid1.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 4da8858..696e308 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -568,6 +568,7 @@ static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 	region_t region;
 	struct bio *bio;
 	struct mirror *m;
+	struct dm_raid1_bio_record *bio_record;
 
 	while ((bio = bio_list_pop(reads))) {
 		region = dm_rh_bio_to_region(ms->rh, bio);
@@ -583,8 +584,16 @@ static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 
 		if (likely(m))
 			read_async_bio(m, bio);
-		else
+		else {
+			/*
+			 * In mirror_end_io(), we will fail the IO properly
+			 * if details.bi_bdev is NULL.
+			 */
+			bio_record = dm_per_bio_data(bio,
+					sizeof(struct dm_raid1_bio_record));
+			bio_record->details.bi_bdev = NULL;
 			bio_io_error(bio);
+		}
 	}
 }
 
-- 
2.10.2
