From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.2-rc6
Date: Fri, 7 Aug 2015 12:23:09 -0400
Message-ID: <20150807162309.GA10293@redhat.com>
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
Cc: dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 795e633a2dc6cbbeac68bc7f6006082150d38bb7:

  dm cache: fix device destroy hang due to improper prealloc_used accounting (2015-07-29 14:32:09 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.2-fixes-4

for you to fetch changes up to aa0cd28d057fd4cb686fbdd2475a6a3f609dd581:

  dm btree remove: fix bug in remove_one() (2015-08-07 11:56:43 -0400)

Thanks,
Mike

----------------------------------------------------------------
- Stable fix for a dm_merge_bvec() regression on 32 bit Fedora systems.

- Fix for a 4.2 DM thinp discard regression due to inability to properly
  delete a range of blocks in a data mapping btree.

----------------------------------------------------------------
Joe Thornber (1):
      dm btree remove: fix bug in remove_one()

Mike Snitzer (1):
      dm: fix dm_merge_bvec regression on 32 bit systems

 drivers/md/dm.c                              | 27 ++++++++++-----------------
 drivers/md/persistent-data/dm-btree-remove.c |  1 +
 2 files changed, 11 insertions(+), 17 deletions(-)
