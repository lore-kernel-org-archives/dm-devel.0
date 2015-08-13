From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.2-rc7
Date: Thu, 13 Aug 2015 16:21:10 -0400
Message-ID: <20150813202110.GA65520@redhat.com>
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
Cc: dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Yi Zhang <yizhan@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit f7644cbfcdf03528f0f450f3940c4985b2291f49:

  Linux 4.2-rc6 (2015-08-09 15:54:30 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.2-fixes-5

for you to fetch changes up to 34dd051741572859bc1fef525c5ddbc127158b52:

  dm cache policy smq: move 'dm-cache-default' module alias to SMQ (2015-08-12 11:27:29 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- two stable fixes for corruption seen in a snapshot of thinp metadata;
  metadata snapshots aren't widely used but help provide a consistent
  view of the metadata associated with an active thin-pool.

- a dm-cache fix for the 4.2 "default" policy switch from "mq" to "smq"

----------------------------------------------------------------
Joe Thornber (2):
      dm thin metadata: delete btrees when releasing metadata snapshot
      dm btree: add ref counting ops for the leaves of top level btrees

Yi Zhang (1):
      dm cache policy smq: move 'dm-cache-default' module alias to SMQ

 drivers/md/dm-cache-policy-mq.c                |  2 --
 drivers/md/dm-cache-policy-smq.c               |  2 ++
 drivers/md/dm-thin-metadata.c                  |  4 +--
 drivers/md/persistent-data/dm-btree-internal.h |  6 +++++
 drivers/md/persistent-data/dm-btree-remove.c   | 16 +++++------
 drivers/md/persistent-data/dm-btree-spine.c    | 37 ++++++++++++++++++++++++++
 drivers/md/persistent-data/dm-btree.c          |  7 +----
 7 files changed, 54 insertions(+), 20 deletions(-)
