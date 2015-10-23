From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.3 final
Date: Fri, 23 Oct 2015 14:16:40 -0400
Message-ID: <20151023181640.GA90969@redhat.com>
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

The following changes since commit ba30670f4d5292c4e7f7980bbd5071f7c4794cdd:

  dm thin: fix missing pool reference count decrement in pool_ctr error path (2015-10-13 12:20:55 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.3-fixes-4

for you to fetch changes up to 3201ac452e84a8a368197d648c9b7011e061804a:

  dm cache: the CLEAN_SHUTDOWN flag was not being set (2015-10-23 14:02:56 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
Three stable fixes (two in btree code used by DM thinp and one to
properly store flags in DM cache metadata's superblock).

----------------------------------------------------------------
Joe Thornber (2):
      dm btree remove: fix a bug when rebalancing nodes after removal
      dm cache: the CLEAN_SHUTDOWN flag was not being set

Mike Snitzer (1):
      dm btree: fix leak of bufio-backed block in btree_split_beneath error path

 drivers/md/dm-cache-metadata.c               |  2 +-
 drivers/md/persistent-data/dm-btree-remove.c | 17 +++++++++++------
 drivers/md/persistent-data/dm-btree.c        |  2 +-
 3 files changed, 13 insertions(+), 8 deletions(-)
