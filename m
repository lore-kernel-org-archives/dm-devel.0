From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.14
Date: Thu, 14 Sep 2017 10:28:30 -0400
Message-ID: <20170914142830.GA5291@redhat.com>
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
Cc: Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@google.com>, Josef Bacik <jbacik@fb.com>, Ming Lei <ming.lei@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, Bhumika Goyal <bhumirks@gmail.com>, Hyunchul Lee <cheol.lee@lge.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 1c23484c355ec360ca2f37914f8a4802c6baeead:

  dm mpath: do not lock up a CPU with requeuing activity (2017-08-28 09:58:27 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.14/dm-changes

for you to fetch changes up to c3ca015fab6df124c933b91902f3f2a3473f9da5:

  dax: remove the pmem_dax_ops->flush abstraction (2017-09-11 11:00:55 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Some request-based DM core and DM multipath fixes and cleanups

- Constify a few variables in DM core and DM integrity

- Add bufio optimization and checksum failure accounting to DM integrity

- Fix DM integrity to avoid checking integrity of failed reads

- Fix DM integrity to use init_completion

- A couple DM log-writes target fixes

- Simplify DAX flushing by eliminating the unnecessary flush abstraction
  that was stood up for DM's use.

----------------------------------------------------------------
Arnd Bergmann (1):
      dm integrity: use init_completion instead of COMPLETION_INITIALIZER_ONSTACK

Bart Van Assche (3):
      dm mpath: avoid that building with W=1 causes gcc 7 to complain about fall-through
      dm mpath: complain about unsupported __multipath_map_bio() return values
      dm rq: make dm-sq requeuing behavior consistent with dm-mq behavior

Bhumika Goyal (1):
      dm integrity: make blk_integrity_profile structure const

Eric Biggers (2):
      dm: constify argument arrays
      dm ioctl: constify ioctl lookup table

Hyunchul Lee (1):
      dm integrity: do not check integrity for failed read operations

Josef Bacik (2):
      dm log writes: don't use all the cpu while waiting to log blocks
      dm log writes: fix >512b sectorsize support

Mikulas Patocka (3):
      dm integrity: optimize writing dm-bufio buffers that are partially changed
      dm integrity: count and display checksum failures
      dax: remove the pmem_dax_ops->flush abstraction

Ming Lei (1):
      dm rq: do not update rq partially in each ending bio

 drivers/dax/super.c           | 21 ++++++----
 drivers/md/dm-bufio.c         | 95 ++++++++++++++++++++++++++++++-------------
 drivers/md/dm-bufio.h         |  9 ++++
 drivers/md/dm-cache-target.c  |  4 +-
 drivers/md/dm-crypt.c         |  2 +-
 drivers/md/dm-flakey.c        |  4 +-
 drivers/md/dm-integrity.c     | 42 +++++++++++--------
 drivers/md/dm-ioctl.c         |  2 +-
 drivers/md/dm-linear.c        | 15 -------
 drivers/md/dm-log-writes.c    | 44 ++++++++++++++------
 drivers/md/dm-mpath.c         | 15 ++++---
 drivers/md/dm-rq.c            | 27 ++++++------
 drivers/md/dm-rq.h            |  1 +
 drivers/md/dm-stripe.c        | 20 ---------
 drivers/md/dm-switch.c        |  2 +-
 drivers/md/dm-table.c         |  7 ++--
 drivers/md/dm-thin.c          |  2 +-
 drivers/md/dm-verity-target.c |  2 +-
 drivers/md/dm.c               | 19 ---------
 drivers/nvdimm/pmem.c         |  7 ----
 fs/dax.c                      |  4 +-
 include/linux/dax.h           |  5 +--
 include/linux/device-mapper.h |  7 +---
 23 files changed, 189 insertions(+), 167 deletions(-)
