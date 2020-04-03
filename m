From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.7
Date: Fri, 3 Apr 2020 11:42:13 -0400
Message-ID: <20200403154213.GA18386@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 81d5553d1288c2ec0390f02f84d71ca0f0f9f137:

  dm clone metadata: Fix return type of dm_clone_nr_of_hydrated_regions() (2020-03-27 14:42:51 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.7/dm-fixes

for you to fetch changes up to 120c9257f5f19e5d1e87efcbb5531b7cd81b7d74:

  Revert "dm: always call blk_queue_split() in dm_process_bio()" (2020-04-03 11:32:19 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Fix excessive bio splitting that caused performance regressions.

- Fix DM integrity warning on ppc64le due to missing cast.

----------------------------------------------------------------
Mike Snitzer (2):
      dm integrity: fix ppc64le warning
      Revert "dm: always call blk_queue_split() in dm_process_bio()"

 drivers/md/dm-integrity.c | 2 +-
 drivers/md/dm.c           | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)
