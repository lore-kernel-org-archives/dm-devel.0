From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.18
Date: Mon, 4 Jun 2018 11:32:55 -0400
Message-ID: <20180604153254.GA4793@redhat.com>
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
Cc: peterz@infradead.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

I've based on linux-block because the new dm-writecache target that is
in this pull needed to be updated to use the new bioset_init/mempool_init
interfaces.

The following changes since commit 04c4950d5b373ba712d928592e05e73510785bca:

  block: fixup bioset_integrity_create() call (2018-05-30 18:51:21 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.18/dm-changes

for you to fetch changes up to 1be8d9c3da01a08d1d92064abb91e4610115db11:

  dm: add writecache target (2018-05-31 08:11:42 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Export 2 swait symbols for use by the new DM writecache target.

- Add DM writecache target that offers writeback caching to persistent
  memory or SSD.

- Small DM core change to give context in error message for why a DM
  table type transition wasn't allowed.

----------------------------------------------------------------
Mike Snitzer (1):
      dm: report which conflicting type caused error during table_load()

Mikulas Patocka (2):
      swait: export symbols __prepare_to_swait and __finish_swait
      dm: add writecache target

 Documentation/device-mapper/writecache.txt |   68 +
 drivers/md/Kconfig                         |   11 +
 drivers/md/Makefile                        |    1 +
 drivers/md/dm-ioctl.c                      |    3 +-
 drivers/md/dm-writecache.c                 | 2285 ++++++++++++++++++++++++++++
 kernel/sched/swait.c                       |    2 +
 6 files changed, 2369 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/device-mapper/writecache.txt
 create mode 100644 drivers/md/dm-writecache.c
