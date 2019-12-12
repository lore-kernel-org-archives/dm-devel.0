From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.5-rc2
Date: Thu, 12 Dec 2019 09:58:57 -0500
Message-ID: <20191212145857.GA27301@redhat.com>
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
Content-Disposition: inline
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Diego Calleja <diegocg@gmail.com>, Nikos Tsironis <ntsironis@arrikto.com>, Eric Biggers <ebiggers@google.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Hou Tao <houtao1@huawei.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit f612b2132db529feac4f965f28a1b9258ea7c22b:

  Revert "dm crypt: use WQ_HIGHPRI for the IO and crypt workqueues" (2019-11-20 17:27:39 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.5/dm-fixes

for you to fetch changes up to 7fc979f8204fb763e203d3e716c17d352eb96b35:

  docs: dm-integrity: remove reference to ARC4 (2019-12-10 10:02:43 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Fix DM multipath by restoring full path selector functionality for
  bio-based configurations that don't haave a SCSI device handler.

- Fix dm-btree removal to ensure non-root btree nodes have at least
  (max_entries / 3) entries.  This resolves userspace thin_check
  utility's report of "too few entries in btree_node".

- Fix both the DM thin-provisioning and dm-clone targets to properly
  flush the data device prior to metadata commit.  This resolves the
  potential for inconsistency across a power loss event when the data
  device has a volatile writeback cache.

- Small documentation fixes to dm-clone and dm-integrity.

----------------------------------------------------------------
Diego Calleja (1):
      dm: add dm-clone to the documentation index

Eric Biggers (1):
      docs: dm-integrity: remove reference to ARC4

Hou Tao (1):
      dm btree: increase rebalance threshold in __rebalance2()

Mike Snitzer (1):
      dm mpath: remove harmful bio-based optimization

Nikos Tsironis (5):
      dm clone metadata: Track exact changes per transaction
      dm clone metadata: Use a two phase commit
      dm clone: Flush destination device before committing metadata
      dm thin metadata: Add support for a pre-commit callback
      dm thin: Flush data device before committing metadata

 .../admin-guide/device-mapper/dm-integrity.rst     |   2 +-
 Documentation/admin-guide/device-mapper/index.rst  |   1 +
 drivers/md/dm-clone-metadata.c                     | 136 +++++++++++++++------
 drivers/md/dm-clone-metadata.h                     |  17 +++
 drivers/md/dm-clone-target.c                       |  53 ++++++--
 drivers/md/dm-mpath.c                              |  37 +-----
 drivers/md/dm-thin-metadata.c                      |  29 +++++
 drivers/md/dm-thin-metadata.h                      |   7 ++
 drivers/md/dm-thin.c                               |  42 ++++++-
 drivers/md/persistent-data/dm-btree-remove.c       |   8 +-
 10 files changed, 248 insertions(+), 84 deletions(-)
