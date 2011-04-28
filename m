From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm snapshot: ignore discards issued to the
 snapshot-origin target
Date: Wed, 27 Apr 2011 20:19:13 -0400
Message-ID: <20110428001912.GA14659@redhat.com>
References: <20110412234706.GA11244@redhat.com>
	<20cf301cbef67d323104a0c2ff52@google.com>
	<20110413224025.GA18589@redhat.com>
	<20110413234854.GA19793@redhat.com>
	<20110426173213.GA19604@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110426173213.GA19604@redhat.com>
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
Cc: DarkNovaNick@gmail.com, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: dm-devel.ids

Discards pose a problem for the snapshot-origin target because they are
treated as writes.  Treating a discard as a write would trigger a
copyout to the snapshot.  Such copyout can prove too costly in the face
of otherwise benign scenarios (e.g. create a snapshot and then mkfs.ext4
the origin -- mkfs.ext4 discards the entire volume by default, which
would copyout the entire origin volume to the snapshot).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index a2d3309..639af12 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2076,6 +2076,7 @@ static int origin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ti->private = dev;
 	ti->num_flush_requests = 1;
+	ti->num_discard_requests = 1;
 
 	return 0;
 }
@@ -2095,6 +2096,12 @@ static int origin_map(struct dm_target *ti, struct bio *bio,
 	if (bio->bi_rw & REQ_FLUSH)
 		return DM_MAPIO_REMAPPED;
 
+	if (bio->bi_rw & REQ_DISCARD) {
+		/* ignore discard requests */
+		bio_endio(bio, 0);
+		return DM_MAPIO_SUBMITTED;
+	}
+
 	/* Only tell snapshots if this is a write */
 	return (bio_rw(bio) == WRITE) ? do_origin(dev, bio) : DM_MAPIO_REMAPPED;
 }
@@ -2153,7 +2160,7 @@ static int origin_iterate_devices(struct dm_target *ti,
 
 static struct target_type origin_target = {
 	.name    = "snapshot-origin",
-	.version = {1, 7, 1},
+	.version = {1, 8, 0},
 	.module  = THIS_MODULE,
 	.ctr     = origin_ctr,
 	.dtr     = origin_dtr,
