From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm flakey: check corrupt_bio_byte was
 configured before calling corrupt_bio_data
Date: Wed, 29 Feb 2012 21:02:29 -0500
Message-ID: <20120301020229.GA477@redhat.com>
References: <1330562282-32508-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1330562282-32508-1-git-send-email-snitzer@redhat.com>
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
Cc: stable@vger.kernel.org
List-Id: dm-devel.ids

The following BUG is easily hit on the first read that is submitted
while the device is "down" (and corrupt_bio_byte wasn't configured).
Example DM table that will hit this BUG: 0 2097152 flakey 8:0 2048 0 30

This issue was introduced with this commit:
a399879 v3.1-rc1 dm flakey: add corrupt_bio_byte feature

BUG: unable to handle kernel paging request at ffff8801cfce3fff
IP: [<ffffffffa008c233>] corrupt_bio_data+0x6e/0xae [dm_flakey]
PGD 1606063 PUD 0
Oops: 0002 [#1] SMP
...
Call Trace:
 <IRQ>
 [<ffffffffa008c2b5>] flakey_end_io+0x42/0x48 [dm_flakey]
 [<ffffffffa00dca98>] clone_endio+0x54/0xb6 [dm_mod]
 [<ffffffff81130587>] bio_endio+0x2d/0x2f
 [<ffffffff811c819a>] req_bio_endio+0x96/0x9f
 [<ffffffff811c94b9>] blk_update_request+0x1dc/0x3a9
 [<ffffffff812f5ee2>] ? rcu_read_unlock+0x21/0x23
 [<ffffffff811c96a6>] blk_update_bidi_request+0x20/0x6e
 [<ffffffff811c9713>] blk_end_bidi_request+0x1f/0x5d
 [<ffffffff811c978d>] blk_end_request+0x10/0x12
 [<ffffffff8128f450>] scsi_io_completion+0x1e5/0x4b1
 [<ffffffff812882a9>] scsi_finish_command+0xec/0xf5
 [<ffffffff8128f830>] scsi_softirq_done+0xff/0x108
 [<ffffffff811ce284>] blk_done_softirq+0x84/0x98
 [<ffffffff81048d19>] __do_softirq+0xe3/0x1d5
 [<ffffffff8138f83f>] ? _raw_spin_lock+0x62/0x69
 [<ffffffff810997cf>] ? handle_irq_event+0x4c/0x61
 [<ffffffff8139833c>] call_softirq+0x1c/0x30
 [<ffffffff81003b37>] do_softirq+0x4b/0xa3
 [<ffffffff81048a39>] irq_exit+0x53/0xca
 [<ffffffff81398acd>] do_IRQ+0x9d/0xb4
 [<ffffffff81390333>] common_interrupt+0x73/0x73
...

But luckily the flakey target is only used for testing.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org # 3.1+
---
 drivers/md/dm-flakey.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index f84c080..4cfc7f5 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -323,7 +323,7 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 	 * Corrupt successful READs while in down state.
 	 * If flags were specified, only corrupt those that match.
 	 */
-	if (!error && bio_submitted_while_down &&
+	if (fc->corrupt_bio_byte && !error && bio_submitted_while_down &&
 	    (bio_data_dir(bio) == READ) && (fc->corrupt_bio_rw == READ) &&
 	    all_corrupt_bio_flags_match(bio, fc))
 		corrupt_bio_data(bio, fc);
-- 
1.7.1
