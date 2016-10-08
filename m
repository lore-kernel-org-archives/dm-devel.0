From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.9
Date: Fri, 7 Oct 2016 20:17:15 -0400
Message-ID: <20161008001715.GA57910@redhat.com>
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
Cc: Rabin Vincent <rabinv@axis.com>, Peter Zijlstra <peterz@infradead.org>, Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com, Minfei Huang <mnghuan@gmail.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

These DM changes for 4.9 build ontop of Jens' 'for-4.9/block' branch due
to dependency on the new blk_mq_delay_kick_requeue_list().

The following changes since commit 2849450ad39d2e699fda2d5c6f41e05d87fd7004:

  blk-mq: introduce blk_mq_delay_kick_requeue_list() (2016-09-14 11:48:34 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.9-changes

for you to fetch changes up to 8ff232c1a819c2e98d85974a3bff0b7b8e2970ed:

  dm mpath: always return reservation conflict without failing over (2016-09-29 10:57:07 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
. various fixes and cleanups for request-based DM core

. add support for delaying the requeue of requests; used by DM multipath
  when all paths have failed and 'queue_if_no_path' is enabled

. DM cache improvements to speedup the loading metadata and the writing
  of the hint array

. fix potential for a dm-crypt crash on device teardown

. remove dm_bufio_cond_resched() and just using cond_resched()

. change DM multipath to return a reservation conflict error
  immediately; rather than failing the path and retrying (potentially
  indefinitely)

----------------------------------------------------------------
Bart Van Assche (7):
      dm: mark request_queue dead before destroying the DM device
      dm rq: factor out dm_mq_stop_queue()
      dm rq: simplify dm_old_stop_queue()
      dm: add two lockdep_assert_held() statements
      dm: rename task state function arguments
      dm: use signal_pending_state() in dm_wait_for_completion()
      dm: convert wait loops to use autoremove_wake_function()

Hannes Reinecke (1):
      dm mpath: always return reservation conflict without failing over

Joe Thornber (6):
      dm array: add dm_array_new()
      dm cache: speed up writing of the hint array
      dm cache policy smq: distribute entries to random levels when switching to smq
      dm btree: introduce cursor api
      dm array: introduce cursor api
      dm cache metadata: switch to using the new cursor api for loading metadata

Mike Snitzer (7):
      dm rq: take request_queue lock while clearing QUEUE_FLAG_STOPPED
      dm mpath: check if path's request_queue is dying in activate_path()
      dm rq: add DM_MAPIO_DELAY_REQUEUE to delay requeue of blk-mq requests
      dm rq: reduce arguments passed to map_request() and dm_requeue_original_request()
      dm rq: introduce dm_mq_kick_requeue_list()
      dm mpath: use dm_mq_kick_requeue_list()
      dm mpath: delay the requeue of blk-mq requests while all paths down

Minfei Huang (1):
      dm: return correct error code in dm_resume()'s retry loop

Peter Zijlstra (1):
      dm bufio: remove dm_bufio_cond_resched()

Rabin Vincent (1):
      dm crypt: fix crash on exit

 drivers/md/dm-bufio.c                 |  31 ++---
 drivers/md/dm-cache-metadata.c        | 183 +++++++++++++++------------
 drivers/md/dm-cache-policy-cleaner.c  |   2 +-
 drivers/md/dm-cache-policy-internal.h |   6 +-
 drivers/md/dm-cache-policy-smq.c      |  45 ++-----
 drivers/md/dm-cache-policy.h          |  10 +-
 drivers/md/dm-crypt.c                 |  24 ++--
 drivers/md/dm-mpath.c                 |  59 ++++-----
 drivers/md/dm-rq.c                    | 104 ++++++++++------
 drivers/md/dm-rq.h                    |   2 +
 drivers/md/dm.c                       |  37 +++---
 drivers/md/persistent-data/dm-array.c | 228 +++++++++++++++++++++++++++++-----
 drivers/md/persistent-data/dm-array.h |  52 ++++++++
 drivers/md/persistent-data/dm-btree.c | 162 ++++++++++++++++++++++++
 drivers/md/persistent-data/dm-btree.h |  35 ++++++
 include/linux/device-mapper.h         |   1 +
 16 files changed, 716 insertions(+), 265 deletions(-)
