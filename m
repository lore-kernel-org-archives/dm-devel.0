From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC 2/3] md/raid0: enable REQ_NOWAIT
Date: Mon, 01 Jun 2020 15:37:12 +0300
Message-ID: <159101503243.180989.945052901574296650.stgit@buzz>
References: <159101473169.180989.12175693728191972447.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <159101473169.180989.12175693728191972447.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

Set limits.nowait_requests = 1 before stacking limits.
Raid itself does not delay bio in raid0_make_request().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 drivers/md/raid0.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 322386ff5d22..e34292b05488 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -406,6 +406,9 @@ static int raid0_run(struct mddev *mddev)
 		blk_queue_io_opt(mddev->queue,
 				 (mddev->chunk_sectors << 9) * mddev->raid_disks);
 
+		/* raid0_make_request() does not delay requests */
+		mddev->queue->limits.nowait_requests = 1;
+
 		rdev_for_each(rdev, mddev) {
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
