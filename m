From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.2-rc1
Date: Fri, 26 Jun 2015 11:20:04 -0400
Message-ID: <20150626152004.GA62003@redhat.com>
References: <20150625143716.GA13739@kernel.dk>
 <20150626061510.GA15036@xzibit.linux.bs1.fc.nec.co.jp>
 <CA+55aFzke6FF6j+1_cDZbCtM4YEF+1vy==JD72LxbKWzxBkWJA@mail.gmail.com>
 <20150626080533.GA16471@xzibit.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150626080533.GA16471@xzibit.linux.bs1.fc.nec.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@fb.com>
List-Id: dm-devel.ids

On Fri, Jun 26 2015 at  4:05P -0400,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> On 06/26/15 15:41, Linus Torvalds wrote:
> > On Jun 25, 2015 23:17, "Junichi Nomura" <j-nomura@ce.jp.nec.com <mailto:j-nomura@ce.jp.nec.com>> wrote:
> >> On 06/25/15 23:37, Jens Axboe wrote:
> >> >       block, dm: don't copy bios for request clones
> >>
> >> this change should not be pushed to mainline yet.
> > 
> > Hmm. I merged all of Jens' pull requests today, so it's now in my tree. What do?
> 
> Then I think following 3 commits should be reverted.
> 
> 2d76fff dm: cleanup methods that requeue requests
> cbc4e3c dm: do not allocate any mempools for blk-mq request-based DM
> 5f1b670 block, dm: don't copy bios for request clones
> 
> Reverting 5f1b670 involves conflicts in drvers/md/dm.c for
> these 2 hunks due to diff contexts difference.
> It's ok to revert those changes ignoring the contexts.

That is more than I'd care to put on Linus at this point.  I've prepared
a DM pull request that fixes things up.  Apologies for not pressing this
request-based DM partial completion issue further, it was an oversight
on my part.  We'll have to get it fixed up properly and revisit for a
future release.

Linus,

The following changes since commit e262f34741522e0d821642e5449c6eeb512723fc:

  dm stats: add support for request-based DM devices (2015-06-17 12:40:41 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.2-fixes

for you to fetch changes up to b5451e456840af027b794afc2c7c84c2a17f569b:

  dm cache policy smq: fix "default" version to be 1.4.0 (2015-06-26 10:14:28 -0400)

----------------------------------------------------------------
- Revert block and DM core changes that removed request-based DM's
  ability to handle partial request completions -- otherwise with the
  current SCSI LLDs these changes could lead to silent data corruption.

- Fix two DM version bumps that were missing from the initial 4.2 DM
  pull request (enabled userspace lvm2 to know certain changes have been
  made).

----------------------------------------------------------------
Mike Snitzer (4):
      Revert "dm: do not allocate any mempools for blk-mq request-based DM"
      Revert "block, dm: don't copy bios for request clones"
      dm: bump the ioctl version to 4.32.0
      dm cache policy smq: fix "default" version to be 1.4.0

 block/blk-core.c                 |  94 +++++++++++++++--
 drivers/md/dm-cache-policy-smq.c |   2 +-
 drivers/md/dm-table.c            |  29 ++----
 drivers/md/dm.c                  | 220 +++++++++++++++++++++++++++------------
 drivers/md/dm.h                  |   5 +-
 include/linux/blk_types.h        |   2 -
 include/linux/blkdev.h           |   6 +-
 include/uapi/linux/dm-ioctl.h    |   4 +-
 8 files changed, 256 insertions(+), 106 deletions(-)
