From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.2-rc5
Date: Wed, 29 Jul 2015 20:05:18 -0400
Message-ID: <20150730000517.GA7489@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Colin Ian King <colin.king@canonical.com>, dm-devel@redhat.com, Baruch Siach <baruch@tkos.co.il>, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit cbfe8fa6cd672011c755c3cd85c9ffd4e2d10a6f:

  Linux 4.2-rc4 (2015-07-26 12:26:21 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.2-fixes-3

for you to fetch changes up to 795e633a2dc6cbbeac68bc7f6006082150d38bb7:

  dm cache: fix device destroy hang due to improper prealloc_used accounting (2015-07-29 14:32:09 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM thinp to consistently return -ENOSPC when out of data space

- Fix a logic bug in the DM cache smq policy's creation error path

- Revert a DM cache 4.2-rc3 change that reduced writeback efficiency

- Fix a hang on DM cache device destruction due to improper
  prealloc_used accounting introduced in 4.2-rc3

- Update URL for dm-crypt wiki page

----------------------------------------------------------------
Baruch Siach (1):
      dm crypt: update wiki page URL

Colin Ian King (1):
      dm cache policy smq: fix alloc_bitset check that always evaluates as false

Mike Snitzer (3):
      dm thin: return -ENOSPC when erroring retry list due to out of data space
      Revert "dm cache: do not wake_worker() in free_migration()"
      dm cache: fix device destroy hang due to improper prealloc_used accounting

 drivers/md/Kconfig               |  2 +-
 drivers/md/dm-cache-policy-smq.c |  2 +-
 drivers/md/dm-cache-target.c     |  7 ++++---
 drivers/md/dm-thin.c             | 11 ++++++++---
 4 files changed, 14 insertions(+), 8 deletions(-)
