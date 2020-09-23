From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.9 final
Date: Wed, 23 Sep 2020 13:30:24 -0400
Message-ID: <20200923173024.GA97173@lobo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Sender: Mike Snitzer <snitzer@gmail.com>
Content-Disposition: inline
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit beaeb4f39bc31d5a5eb6d05465a86af4fe147732:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2020-09-21 08:53:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.9/dm-fixes-2

for you to fetch changes up to 4c07ae0ad493b7b2d3dd3e53870e594f136ce8a5:

  dm crypt: document encrypted keyring key option (2020-09-22 13:25:58 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- DM core fix for incorrect double bio splitting. Keep "fixing" this
  because past attempts didn't fully appreciate the liability relative
  to recursive bio splitting. This fix limits DM's bio splitting to a
  single method and does _not_ use blk_queue_split() for normal IO.

- DM crypt Documentation updates for features added during 5.9 merge.

----------------------------------------------------------------
Mike Snitzer (2):
      dm: fix bio splitting and its bio completion order for regular IO
      dm: fix comment in dm_process_bio()

Milan Broz (2):
      dm crypt: document new no_workqueue flags
      dm crypt: document encrypted keyring key option

 .../admin-guide/device-mapper/dm-crypt.rst         | 10 +++++++-
 drivers/md/dm.c                                    | 27 ++++------------------
 2 files changed, 14 insertions(+), 23 deletions(-)
