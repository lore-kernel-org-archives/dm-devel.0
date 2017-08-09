From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 3/7] dm-mpath: Do not lock up a CPU with requeuing activity
Date: Wed, 9 Aug 2017 11:32:12 -0700
Message-ID: <20170809183216.526-4-bart.vanassche@wdc.com>
References: <20170809183216.526-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170809183216.526-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@wdc.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
List-Id: dm-devel.ids

When using the block layer in single queue mode, get_request()
returns ERR_PTR(-EAGAIN) if the queue is dying and the REQ_NOWAIT
flag has been passed to get_request(). Avoid that the kernel
reports soft lockup complaints in this case due to continuous
requeuing activity.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: <stable@vger.kernel.org>
---
 drivers/md/dm-mpath.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 0e8ab5bb3575..0baa461eccaa 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -504,7 +504,6 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 		if (queue_dying) {
 			atomic_inc(&m->pg_init_in_progress);
 			activate_or_offline_path(pgpath);
-			return DM_MAPIO_REQUEUE;
 		}
 		return DM_MAPIO_DELAY_REQUEUE;
 	}
-- 
2.13.3
