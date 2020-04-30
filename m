From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.7-rc4
Date: Thu, 30 Apr 2020 18:07:36 -0400
Message-ID: <20200430220735.GA30584@redhat.com>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Sunwook Eom <speed.eom@samsung.com>, Gabriel Krisman Bertazi <krisman@collabora.com>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 8267d8fb4819afa76b2a54dca48efdda6f0b1910:

  dm integrity: fix logic bug in integrity tag testing (2020-04-03 13:07:41 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.7/dm-fixes-2

for you to fetch changes up to 5686dee34dbfe0238c0274e0454fa0174ac0a57a:

  dm multipath: use updated MPATHF_QUEUE_IO on mapping for bio-based mpath (2020-04-28 19:51:46 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Document DM integrity allow_discard feature that was added during
  5.7 merge window.

- Fix potential for DM writecache data corruption during DM table
  reloads.

- Fix DM verity's FEC support's hash block number calculation in
  verity_fec_decode().

- Fix bio-based DM multipath crash due to use of stale copy of
  MPATHF_QUEUE_IO flag state in __map_bio().

----------------------------------------------------------------
Gabriel Krisman Bertazi (1):
      dm multipath: use updated MPATHF_QUEUE_IO on mapping for bio-based mpath

Mikulas Patocka (1):
      dm writecache: fix data corruption when reloading the target

Milan Broz (1):
      dm integrity: document allow_discard option

Sunwook Eom (1):
      dm verity fec: fix hash block number in verity_fec_decode

 .../admin-guide/device-mapper/dm-integrity.rst     | 15 ++++---
 drivers/md/dm-mpath.c                              |  6 ++-
 drivers/md/dm-verity-fec.c                         |  2 +-
 drivers/md/dm-writecache.c                         | 52 +++++++++++++++-------
 4 files changed, 51 insertions(+), 24 deletions(-)
