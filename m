From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.20
Date: Wed, 12 Dec 2018 12:56:48 -0500
Message-ID: <20181212175648.GA25049@redhat.com>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 2595646791c319cadfdbf271563aac97d0843dc7:

  Linux 4.20-rc5 (2018-12-02 15:07:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.20/dm-fixes

for you to fetch changes up to 2af6c0703d75fc3ff2e6de19b4b3adab96acc12d:

  dm thin: bump target version (2018-12-12 09:39:54 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM cache metadata to verify that a cache has block before trying
  to continue with operation that requires them.

- Fix bio-based DM core's dm_make_request() to properly impose device
  limits on individual bios by making use of blk_queue_split().

- Fix long-standing race with how DM thinp notified userspace of
  thin-pool mode state changes before they were actually made.

- Fix the zoned target's bio completion handling; this is a fairly
  invassive fix at this stage but it is localized to the zoned target.
  Any zoned target users will benefit from this fix.

----------------------------------------------------------------
Damien Le Moal (1):
      dm zoned: Fix target BIO completion handling

Mike Snitzer (4):
      dm cache metadata: verify cache has blocks in blocks_are_clean_separate_dirty()
      dm: call blk_queue_split() to impose device limits on bios
      dm thin: send event about thin-pool state change _after_ making it
      dm thin: bump target version

 drivers/md/dm-cache-metadata.c |   4 ++
 drivers/md/dm-thin.c           |  72 ++++++++++++------------
 drivers/md/dm-zoned-target.c   | 122 +++++++++++++----------------------------
 drivers/md/dm.c                |   2 +
 4 files changed, 81 insertions(+), 119 deletions(-)
