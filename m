From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.4-rc5
Date: Fri, 11 Dec 2015 10:20:14 -0500
Message-ID: <20151211152014.GA2751@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-Message-ID: <20151211202903.GA27921@redhat.com>
Resent-To: dm-devel@redhat.com
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

The following changes since commit 31ade3b83e1821da5fbb2f11b5b3d4ab2ec39db8:

  Linux 4.4-rc3 (2015-11-29 18:58:26 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.4-fixes-2

for you to fetch changes up to ed8b45a3679eb49069b094c0711b30833f27c734:

  dm btree: fix bufio buffer leaks in dm_btree_del() error path (2015-12-10 10:30:18 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
Five stable fixes:

- Two DM btree bufio buffer leak fixes that resolve reported BUG_ONs
  during DM thinp metadata close's dm_bufio_client_destroy().

- A DM thinp range discard fix to handle discarding a partially mapped
  range.

- A DM thinp metadata snapshot fix to make sure the btree roots saved in
  the metadata snapshot are the most current.

- A DM space map metadata refcounting fix that improves both DM thinp
  and DM cache metadata.

----------------------------------------------------------------
Joe Thornber (4):
      dm thin metadata: fix bug in dm_thin_remove_range()
      dm thin metadata: fix bug when taking a metadata snapshot
      dm space map metadata: fix ref counting bug when bootstrapping a new space map
      dm btree: fix bufio buffer leaks in dm_btree_del() error path

Mike Snitzer (1):
      dm btree: fix leak of bufio-backed block in btree_split_sibling error path

 drivers/md/dm-thin-metadata.c                      |  34 ++++++-
 drivers/md/persistent-data/dm-btree.c              | 101 ++++++++++++++++++++-
 drivers/md/persistent-data/dm-btree.h              |  14 ++-
 drivers/md/persistent-data/dm-space-map-metadata.c |  32 +++++--
 4 files changed, 161 insertions(+), 20 deletions(-)
