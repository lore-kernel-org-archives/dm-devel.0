From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull v2] device mapper fixes for 5.7
Date: Fri, 3 Apr 2020 13:15:43 -0400
Message-ID: <20200403171543.GA92499@lobo>
References: <20200403154213.GA18386@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200403154213.GA18386@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

I updated the tag after my initial pull request to include one more
fix from Mikulas.

The following changes since commit 81d5553d1288c2ec0390f02f84d71ca0f0f9f137:

  dm clone metadata: Fix return type of dm_clone_nr_of_hydrated_regions() (2020-03-27 14:42:51 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.7/dm-fixes

for you to fetch changes up to 8267d8fb4819afa76b2a54dca48efdda6f0b1910:

  dm integrity: fix logic bug in integrity tag testing (2020-04-03 13:07:41 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Fix excessive bio splitting that caused performance regressions.

- Fix logic bug in DM integrity discard support's integrity tag
  testing.

- Fix DM integrity warning on ppc64le due to missing cast.

----------------------------------------------------------------
Mike Snitzer (2):
      dm integrity: fix ppc64le warning
      Revert "dm: always call blk_queue_split() in dm_process_bio()"

Mikulas Patocka (1):
      dm integrity: fix logic bug in integrity tag testing

 drivers/md/dm-integrity.c | 4 ++--
 drivers/md/dm.c           | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)
