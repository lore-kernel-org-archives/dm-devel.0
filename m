From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] a few additional device mapper fixes for 3.19
	final
Date: Sat, 24 Jan 2015 21:35:45 -0500
Message-ID: <20150125023545.GA12497@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 5164bece1673cdf04782f8ed3fba70743700f5da:

  dm: fix missed error code if .end_io isn't implemented by target_type (2014-12-17 12:31:13 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.19-fixes-2

for you to fetch changes up to 96b26c8c64c7a30488b8b404f7a63346df4c3bff:

  dm: fix handling of multiple internal suspends (2015-01-24 14:50:08 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
2 stable fixes for dm-cache and 1 3.19 DM core fix:

- Fix potential for dm-cache metadata corruption via stale metadata
  buffers being used when switching an inactive cache table to active;
  this could occur due to each table having it's own bufio client rather
  than sharing the client between tables.

- Fix dm-cache target to properly account for discard IO while
  suspending otherwise IO quiescing could complete prematurely.

- Fix DM core's handling of multiple internal suspends by maintaining an
  'internal_suspend_count' and only resuming the device when this count
  drops to zero.

----------------------------------------------------------------
Joe Thornber (2):
      dm cache: share cache-metadata object across inactive and active DM tables
      dm cache: fix problematic dual use of a single migration count variable

Mikulas Patocka (1):
      dm: fix handling of multiple internal suspends

 drivers/md/dm-cache-metadata.c | 101 ++++++++++++++++++++++++++++++++++++++---
 drivers/md/dm-cache-target.c   |  89 ++++++++++++++++++++----------------
 drivers/md/dm.c                |   9 +++-
 3 files changed, 152 insertions(+), 47 deletions(-)
