From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.1-rc2
Date: Thu, 30 Apr 2015 10:49:40 -0400
Message-ID: <20150430144940.GA13189@redhat.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit b787f68c36d49bb1d9236f403813641efa74a031:

  Linux 4.1-rc1 (2015-04-26 17:59:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.1-fixes

for you to fetch changes up to aa6df8dd28c01d9a3d2cfcfe9dd0a4a334d1cd81:

  dm: fix free_rq_clone() NULL pointer when requeueing unmapped request (2015-04-30 10:25:21 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
Fix 2 bugs in the request-based DM blk-mq support that was added during
the 4.1 merge.

----------------------------------------------------------------
Christoph Hellwig (1):
      dm: only initialize the request_queue once

Mike Snitzer (1):
      dm: fix free_rq_clone() NULL pointer when requeueing unmapped request

 drivers/md/dm-ioctl.c | 17 +++++++++--------
 drivers/md/dm.c       | 19 ++++++++++++-------
 2 files changed, 21 insertions(+), 15 deletions(-)
