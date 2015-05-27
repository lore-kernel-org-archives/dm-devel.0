From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: [PATCH] dm: Fix oops when clone_and_map_rq returns
 !DM_MAPIO_REMAPPED
Date: Wed, 27 May 2015 04:22:07 +0000
Message-ID: <5565466F.3@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: ja-JP
Content-ID: <2F797D0A45041E4BB41FF01BDA491C1E@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When stacking request-based dm on blk_mq device,
request cloning and remapping are done in a single call to
target's clone_and_map_rq(). Only when the return value is
DM_MAPIO_REMAPPED, the clone is valid and owned by dm core.

"IS_ERR(clone)" does not cover all the !DM_MAPIO_REMAPPED cases.
E.g. if underlying devices are not ready or unavailable, the
function may return DM_MAPIO_REQUEUE.

Without this fix, dm core may call setup_clone() for NULL clone
and oops like this:

   BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
   IP: [<ffffffff81227525>] blk_rq_prep_clone+0x7d/0x137
   ...
   CPU: 2 PID: 5793 Comm: kdmwork-253:3 Not tainted 4.0.0-nm #1
   ...
   Call Trace:
    [<ffffffffa01d1c09>] map_tio_request+0xa9/0x258 [dm_mod]
    [<ffffffff81071de9>] kthread_worker_fn+0xfd/0x150
    [<ffffffff81071cec>] ? kthread_parkme+0x24/0x24
    [<ffffffff81071cec>] ? kthread_parkme+0x24/0x24
    [<ffffffff81071fdd>] kthread+0xe6/0xee
    [<ffffffff81093a59>] ? put_lock_stats+0xe/0x20
    [<ffffffff81071ef7>] ? __init_kthread_worker+0x5b/0x5b
    [<ffffffff814c2d98>] ret_from_fork+0x58/0x90
    [<ffffffff81071ef7>] ? __init_kthread_worker+0x5b/0x5b

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

--
This patch is a minimal fix.
map_request() function could be refactored in better shape.

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0bf79a0..1c62ed8 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1972,8 +1972,8 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
 			dm_kill_unmapped_request(rq, r);
 			return r;
 		}
-		if (IS_ERR(clone))
-			return DM_MAPIO_REQUEUE;
+		if (r != DM_MAPIO_REMAPPED)
+			return r;
 		if (setup_clone(clone, rq, tio, GFP_ATOMIC)) {
 			/* -ENOMEM */
 			ti->type->release_clone_rq(clone);
