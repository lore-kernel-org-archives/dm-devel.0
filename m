From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 6/7] dm-mpath: Avoid code duplication in
	__multipath_map()
Date: Tue, 15 Nov 2016 15:34:52 -0800
Message-ID: <4e810e44-8fd9-014e-d40d-12e895867096@sandisk.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Move common code out of if (clone) { ... } else { ... }.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-mpath.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5c73818..7559537 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -574,8 +574,6 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 		 * Used by: .request_fn stacked on .request_fn path(s).
 		 */
 		clone->q = bdev_get_queue(bdev);
-		clone->rq_disk = bdev->bd_disk;
-		clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 	} else {
 		/*
 		 * blk-mq request-based interface; used by both:
@@ -591,9 +589,9 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 		}
 		*__clone = clone;
 		clone->bio = clone->biotail = NULL;
-		clone->rq_disk = bdev->bd_disk;
-		clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 	}
+	clone->rq_disk = bdev->bd_disk;
+	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 
 	if (pgpath->pg->ps.type->start_io)
 		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
-- 
2.10.1
