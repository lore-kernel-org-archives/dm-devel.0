From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.19 final
Date: Wed, 10 Oct 2018 12:46:44 -0400
Message-ID: <20181010164643.GA10173@redhat.com>
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
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>, Alasdair G Kergon <agk@redhat.com>, Shenghui Wang <shhuiw@foxmail.com>
List-Id: dm-devel.ids

Hi Greg,

The following changes since commit 0238df646e6224016a45505d2c111a24669ebe21:

  Linux 4.19-rc7 (2018-10-07 17:26:02 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.19/dm-fixes-3

for you to fetch changes up to beb9caac211c1be1bc118bb62d5cf09c4107e6a5:

  dm linear: eliminate linear_end_io call if CONFIG_DM_ZONED disabled (2018-10-10 12:11:09 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix a DM cache module init error path bug that doesn't properly
  cleanup a KMEM_CACHE if target registration fails.

- Two stable@ fixes for DM zoned target; 4.20 will have changes that
  eliminate this code entirely but <= 4.19 needs these changes.

----------------------------------------------------------------
Damien Le Moal (1):
      dm: fix report zone remapping to account for partition offset

Mike Snitzer (1):
      dm linear: eliminate linear_end_io call if CONFIG_DM_ZONED disabled

Shenghui Wang (1):
      dm cache: destroy migration_cache if cache target registration failed

 drivers/md/dm-cache-target.c |  5 ++---
 drivers/md/dm-linear.c       |  8 +++++++-
 drivers/md/dm.c              | 27 ++++++++++++++++++++-------
 3 files changed, 29 insertions(+), 11 deletions(-)
