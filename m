From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] additional device mapper changes for 3.20
Date: Fri, 20 Feb 2015 10:48:26 -0500
Message-ID: <20150220154825.GA21338@redhat.com>
References: <20140612141337.GB27768@redhat.com>
 <20150216210142.GA22223@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150216210142.GA22223@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Ondrej Kozina <okozina@redhat.com>, Milan Broz <mbroz@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 802ea9d8645d33d24b7b4cd4537c14f3e698bde0:

  Merge tag 'dm-3.20-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm (2015-02-12 16:36:31 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.20-changes-2

for you to fetch changes up to 22aa66a3ee5b61e0f4a0bfeabcaa567861109ec3:

  dm snapshot: fix a possible invalid memory access on unload (2015-02-18 09:41:54 -0500)

----------------------------------------------------------------
- Significant dm-crypt CPU scalability performance improvements thanks
  to changes that enable effective use of an unbound workqueue across
  all available CPUs.  A large battery of tests were performed to
  validate these changes, summary of results is available here:
  https://www.redhat.com/archives/dm-devel/2015-February/msg00106.html

- A few additional stable fixes (to DM core, dm-snapshot and dm-mirror)
  and a small fix to the dm-space-map-disk.

----------------------------------------------------------------
Darrick J. Wong (1):
      dm io: reject unsupported DISCARD requests with EOPNOTSUPP

Mike Snitzer (1):
      dm space map disk: fix sm_disk_count_is_more_than_one()

Mikulas Patocka (10):
      dm mirror: do not degrade the mirror on discard error
      dm crypt: use unbound workqueue for request processing
      dm crypt: don't allocate pages for a partial request
      dm crypt: avoid deadlock in mempools
      dm crypt: remove unused io_pool and _crypt_io_pool
      dm crypt: offload writes to thread
      dm crypt: add 'submit_from_crypt_cpus' option
      dm crypt: sort writes
      dm: fix a race condition in dm_get_md
      dm snapshot: fix a possible invalid memory access on unload

 Documentation/device-mapper/dm-crypt.txt       |  15 +-
 drivers/md/dm-crypt.c                          | 392 ++++++++++++++-----------
 drivers/md/dm-io.c                             |   6 +
 drivers/md/dm-raid1.c                          |   9 +
 drivers/md/dm-snap.c                           |   4 +-
 drivers/md/dm.c                                |  27 +-
 drivers/md/persistent-data/dm-space-map-disk.c |   4 +-
 7 files changed, 269 insertions(+), 188 deletions(-)
