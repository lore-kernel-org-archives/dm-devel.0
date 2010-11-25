From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm raid1: support discard
Date: Wed, 24 Nov 2010 21:46:59 -0500
Message-ID: <20101125024659.GA4590@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Enable discard support in the DM mirror target.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-raid1.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 19a59b0..de69ca6 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -637,6 +637,12 @@ static void do_write(struct mirror_set *ms, struct bio *bio)
 		.client = ms->io_client,
 	};
 
+	if (bio->bi_rw & REQ_DISCARD) {
+		io_req.bi_rw |= REQ_DISCARD;
+		io_req.mem.type = DM_IO_KMEM;
+		io_req.mem.ptr.bvec = NULL;
+	}
+
 	for (i = 0, m = ms->mirror; i < ms->nr_mirrors; i++, m++)
 		map_region(dest++, m, bio);
 
@@ -670,7 +676,8 @@ static void do_writes(struct mirror_set *ms, struct bio_list *writes)
 	bio_list_init(&requeue);
 
 	while ((bio = bio_list_pop(writes))) {
-		if (bio->bi_rw & REQ_FLUSH) {
+		if ((bio->bi_rw & REQ_FLUSH) ||
+		    (bio->bi_rw & REQ_DISCARD)) {
 			bio_list_add(&sync, bio);
 			continue;
 		}
@@ -1076,6 +1083,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->private = ms;
 	ti->split_io = dm_rh_get_region_size(ms->rh);
 	ti->num_flush_requests = 1;
+	ti->num_discard_requests = 1;
 
 	ms->kmirrord_wq = create_singlethread_workqueue("kmirrord");
 	if (!ms->kmirrord_wq) {
