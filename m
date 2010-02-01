From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] dm_crypt: Issue all previous bios before
	remapping barrier bio
Date: Mon, 1 Feb 2010 20:49:26 +0530
Message-ID: <201002012049.27132.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Before remapping a barrier bio, make sure that there are no un-issued
pending I/O in the workqueue. Otherwise a dm_flush would simply add
a barrier request to the underlying device, without issuing the bio's
queued in the dm_crypt device.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

--

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a936372..be68e70 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1252,6 +1252,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
 
 	if (unlikely(bio_empty_barrier(bio))) {
 		cc = ti->private;
+		flush_workqueue(cc->io_queue);
 		bio->bi_bdev = cc->dev->bdev;
 		return DM_MAPIO_REMAPPED;
 	}
