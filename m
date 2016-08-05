From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.8-rc1
Date: Fri, 5 Aug 2016 11:52:40 -0400
Message-ID: <20160805155239.GA2362@redhat.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

I'll be on vacation through Sunday 8/14 so I'd prefer to get you these
DM fixes before I go.

The following changes since commit f7b32e4c021fd788f13f6785e17efbc3eb05b351:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux (2016-08-02 12:41:13 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.8-fixes

for you to fetch changes up to 2a034ec197aa574dd159961cc661c9b08cd76425:

  dm raid: fix use of wrong status char during resynchronization (2016-08-04 10:05:30 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- A stable dm-flakey fix to error read IO during the 'down_interval'

- A DM core suspend fix to establish the SUSPENDED flag before dropping
  the SUSPENDING flag

- A blk-mq request-based DM (dm-mq) dm_stop_queue() fix to properly stop
  the blk-mq hw_queues (and cancel pending requeue work); also set/clear
  QUEUE_FLAG_STOPPED when stopping/starting the dm-mq request_queue.

- A DM multipath fix to harden locking of in-core state flags in the
  face of concurrent access while handling path failures under heavy
  IO.

- A few small DM raid fixes to edge cases caught with further testing.

----------------------------------------------------------------
Heinz Mauelshagen (3):
      dm raid: fix processing of max_recovery_rate constructor flag
      dm raid: constructor fails on non-zero incompat_features
      dm raid: fix use of wrong status char during resynchronization

Mike Snitzer (4):
      dm flakey: error READ bios during the down_interval
      dm mpath: add locking to multipath_resume and must_push_back
      dm rq: fix the starting and stopping of blk-mq queues
      dm: set DMF_SUSPENDED* _before_ clearing DMF_NOFLUSH_SUSPENDING

 drivers/md/dm-flakey.c | 23 +++++++++++++++--------
 drivers/md/dm-mpath.c  | 24 ++++++++++++++++++++----
 drivers/md/dm-raid.c   |  4 ++--
 drivers/md/dm-rq.c     | 20 +++++++++++++++++++-
 drivers/md/dm.c        | 14 +++++++-------
 5 files changed, 63 insertions(+), 22 deletions(-)
