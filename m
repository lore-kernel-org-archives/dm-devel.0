From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/4] dm: simplify request-based DM a bit and an
	RFC-like perf tweak
Date: Tue, 24 Feb 2015 11:44:06 -0500
Message-ID: <1424796250-38553-1-git-send-email-snitzer@redhat.com>
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
Cc: axboe@kernel.dk, shivakrishna.merla@netapp.com, jmoyer@redhat.com
List-Id: dm-devel.ids

These changes were born out of me staring at the DM core code that
deals with request-based DM, in response to this thread:
https://www.redhat.com/archives/dm-devel/2015-February/msg00118.html

I've tested patches 1-3.  Patch 4 is more an RFC patch that fell out
of discussion I had with Jeff Moyer ("phro" below):

<phro> are you sure it isn't just i/o completion that's pulling more requests off the queue?
<phro> at least at the lower layer, that's what happens.  you get an interrupt for i/o completion, and in that contxt you submit any pending i/o
<snitm> in drivers/md/dm.c: dm_end_request -> rq_completed -> blk_run_queue_async
<snitm> so could very well be
<phro> ok, only difference is you kick it off to a work queue
<phro> for immediate dispatch
<snitm> right
<phro> so that makes sense.  as soon as an i/o is completed, a new one is issued
<snitm> could impose a delay on the running of the queue
<phro> right
<snitm> e.g. how dm.c:dm_request_fn does blk_delay_queue(q, HZ / 10);
<snitm> (which is what promotes merging in the ->lld_busy_fn returning true case)
<snitm> that _could_ be enough to slow things down slightly
<phro> it's worth a shot

Mike Snitzer (4):
  dm: remove unnecessary wrapper around blk_lld_busy
  dm: remove request-based DM queue's lld_busy_fn hook
  dm: remove request-based logic from make_request_fn wrapper
  dm: delay running the queue slightly during request completion

 block/blk-core.c              |  5 ++--
 drivers/md/dm-mpath.c         |  2 +-
 drivers/md/dm-table.c         | 14 -----------
 drivers/md/dm.c               | 54 +++++++++++--------------------------------
 drivers/md/dm.h               |  1 -
 include/linux/blkdev.h        |  2 --
 include/linux/device-mapper.h |  5 ----
 7 files changed, 17 insertions(+), 66 deletions(-)

-- 
1.9.3 (Apple Git-50)
