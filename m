From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.21
Date: Thu, 27 Dec 2018 11:09:44 -0500
Message-ID: <20181227160944.GA12190@redhat.com>
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
Cc: Sweet Tea <sweettea@redhat.com>, wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>, AliOS system security <alios_sys_security@linux.alibaba.com>, Nikos Tsironis <ntsironis@arrikto.com>, Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>, Heinz Mauelshagen <heinzm@redhat.com>, Shenghui Wang <shhuiw@foxmail.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Colin Ian King <colin.king@canonical.com>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The DM tree is based on the block tree for this cycle because a fair
amount of my time was spent working on the percpu inflight IO counters
changes and other block fixes (which impact DM) that are in Jens' block
pull.

The following changes since commit cd19181bf9ad4b7f40f2a4e0355d052109c76529:

  blk-mq: enable IO poll if .nr_queues of type poll > 0 (2018-12-17 21:35:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.21/dm-changes

for you to fetch changes up to c6d6e9b0f6b4201c77f2cea3964dd122697e3543:

  dm: do not allow readahead to limit IO size (2018-12-18 14:23:41 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Eliminate a couple indirect calls from bio-based DM core.

- Fix DM to allow reads that exceed readahead limits by setting io_pages
  in the backing_dev_info.

- A couple code cleanups in request-based DM.

- Fix various DM targets to check for device sector overflow if
  CONFIG_LBDAF is not set.

- Use u64 instead of sector_t to store iv_offset in DM crypt; sector_t
  isn't large enough on 32bit when CONFIG_LBDAF is not set.

- Performance fixes to DM's kcopyd and the snapshot target focused on
  limiting memory use and workqueue stalls.

- Fix typos in the integrity and writecache targets.

- Log which algorithm is used for dm-crypt's encryption and
  dm-integrity's hashing.

- Fix false -EBUSY errors in DM raid target's handling of check/repair
  messages.

- Fix DM flakey target's corrupt_bio_byte feature to reliably corrupt
  the Nth byte in a bio's payload.

----------------------------------------------------------------
AliOS system security (1):
      dm crypt: use u64 instead of sector_t to store iv_offset

Colin Ian King (1):
      dm integrity: fix spelling mistake in workqueue name

Eric Biggers (2):
      dm crypt: log the encryption algorithm implementation
      dm verity: log the hash algorithm implementation

Heinz Mauelshagen (1):
      dm raid: fix false -EBUSY when handling check/repair message

Jaegeuk Kim (1):
      dm: do not allow readahead to limit IO size

Mike Snitzer (3):
      dm rq: remove unused arguments from rq_completed()
      dm: remove indirect calls from __send_changing_extent_only()
      dm rq: cleanup leftover code from recently removed q->mq_ops branching

Mikulas Patocka (1):
      dm: avoid indirect call in __dm_make_request

Milan Broz (1):
      dm: Check for device sector overflow if CONFIG_LBDAF is not set

Nikos Tsironis (2):
      dm snapshot: Fix excessive memory usage and workqueue stalls
      dm kcopyd: Fix bug causing workqueue stalls

Shenghui Wang (2):
      dm writecache: fix typo in error msg for creating writecache_flush_thread
      dm bufio: update comment in dm-bufio.c

Sweet Tea (1):
      dm flakey: Properly corrupt multi-page bios.

wuzhouhui (1):
      dm mpath: only flush workqueue when needed

 drivers/md/dm-bufio.c         | 12 +++++------
 drivers/md/dm-crypt.c         | 17 ++++++++++++----
 drivers/md/dm-delay.c         |  2 +-
 drivers/md/dm-flakey.c        | 35 +++++++++++++++++++++-----------
 drivers/md/dm-integrity.c     |  2 +-
 drivers/md/dm-kcopyd.c        | 19 +++++++++++++-----
 drivers/md/dm-linear.c        |  2 +-
 drivers/md/dm-mpath.c         |  6 ++++--
 drivers/md/dm-raid.c          |  3 +--
 drivers/md/dm-raid1.c         |  3 ++-
 drivers/md/dm-rq.c            | 18 ++++++-----------
 drivers/md/dm-snap.c          | 22 +++++++++++++++++++++
 drivers/md/dm-table.c         |  3 +++
 drivers/md/dm-unstripe.c      |  2 +-
 drivers/md/dm-verity-target.c |  9 +++++++++
 drivers/md/dm-writecache.c    |  2 +-
 drivers/md/dm.c               | 46 ++++++++++++-------------------------------
 17 files changed, 121 insertions(+), 82 deletions(-)
