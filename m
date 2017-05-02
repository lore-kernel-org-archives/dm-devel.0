From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper post-merge changes for 4.12
Date: Tue, 2 May 2017 15:05:21 -0400
Message-ID: <20170502190520.GA79914@redhat.com>
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
Cc: dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

Here are some changes from Christoph that needed to be rebased ontop of
changes that were already merged into the 'tags/for-4.12/dm-changes'.
In addition, these changes depend on the 'for-4.12/block' changes that
you've already merged.  So once you've pulled 'tags/for-4.12/dm-changes'
please then consider pulling these changes.

The following changes since commit 7e25a7606147bfe29a7421ff2cb332b07d3cee3a:

  Merge branch 'dm-4.12' into dm-4.12-post-merge (2017-05-01 18:18:04 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.12/dm-post-merge-changes

for you to fetch changes up to 412445acb6cad4cef026daae37c4765fb9942c60:

  dm: introduce a new DM_MAPIO_KILL return value (2017-05-01 18:19:03 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Cleanups to request-based DM and DM multipath from Christoph that
  prepare for his block core error code type checking improvements.

----------------------------------------------------------------
Christoph Hellwig (3):
      dm mpath: merge do_end_io into multipath_end_io
      dm rq: change ->rq_end_io calling conventions
      dm: introduce a new DM_MAPIO_KILL return value

 drivers/md/dm-mpath.c         | 54 +++++++++++++++++--------------------------
 drivers/md/dm-rq.c            | 29 ++++++++++++-----------
 drivers/md/dm-target.c        |  2 +-
 include/linux/device-mapper.h |  2 ++
 4 files changed, 39 insertions(+), 48 deletions(-)
