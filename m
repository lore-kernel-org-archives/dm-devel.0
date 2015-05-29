From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.1-rc6
Date: Fri, 29 May 2015 15:06:46 -0400
Message-ID: <20150529190645.GA29347@redhat.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit ba155e2d21f6bf05de86a78dbe5bfd8757604a65:

  Linux 4.1-rc5 (2015-05-24 18:22:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.1-fixes-3

for you to fetch changes up to 1c220c69ce0dcc0f234a9f263ad9c0864f971852:

  dm: fix casting bug in dm_merge_bvec() (2015-05-29 13:41:16 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
Quite a few fixes for DM's blk-mq support thanks to extra DM multipath
testing from Junichi Nomura and Bart Van Assche.

Also fix a casting bug in dm_merge_bvec() that could cause only a single
page to be added to a bio (Joe identified this while testing dm-cache
writeback).

----------------------------------------------------------------
Joe Thornber (1):
      dm: fix casting bug in dm_merge_bvec()

Junichi Nomura (3):
      dm: run queue on re-queue
      dm: fix NULL pointer when clone_and_map_rq returns !DM_MAPIO_REMAPPED
      dm: fix reload failure of 0 path multipath mapping on blk-mq devices

Mike Snitzer (3):
      dm mpath: fix leak of dm_mpath_io structure in blk-mq .queue_rq error path
      dm: requeue from blk-mq dm_mq_queue_rq() using BLK_MQ_RQ_QUEUE_BUSY
      dm: fix false warning in free_rq_clone() for unmapped requests

 drivers/md/dm-mpath.c |  4 +++-
 drivers/md/dm-table.c | 16 +++++++++-------
 drivers/md/dm.c       | 40 ++++++++++++++++++++++++----------------
 3 files changed, 36 insertions(+), 24 deletions(-)
