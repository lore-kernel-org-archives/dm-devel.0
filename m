From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.3-rc6
Date: Fri, 16 Oct 2015 15:47:28 -0400
Message-ID: <20151016194728.GA34634@redhat.com>
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
Cc: dm-devel@redhat.com, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 25cb62b76430a91cc6195f902e61c2cb84ade622:

  Linux 4.3-rc5 (2015-10-11 11:09:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.3-fixes-3

for you to fetch changes up to ba30670f4d5292c4e7f7980bbd5071f7c4794cdd:

  dm thin: fix missing pool reference count decrement in pool_ctr error path (2015-10-13 12:20:55 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
Two DM target error path cleanup fixes (one for stable in DM thinp and
one for a v4.3-rc5 thinko in DM snapshot).

----------------------------------------------------------------
Mike Snitzer (1):
      dm thin: fix missing pool reference count decrement in pool_ctr error path

Sudip Mukherjee (1):
      dm snapshot persistent: fix missing cleanup in persistent_ctr error path

 drivers/md/dm-snap-persistent.c | 15 ++++++++++++---
 drivers/md/dm-thin.c            |  2 +-
 2 files changed, 13 insertions(+), 4 deletions(-)
