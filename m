From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.0-rc4
Date: Thu, 24 Jan 2019 14:38:29 -0500
Message-ID: <20190124193829.GA22312@redhat.com>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit bfeffd155283772bbe78c6a05dec7c0128ee500c:

  Linux 5.0-rc1 (2019-01-06 17:08:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.0/dm-fixes

for you to fetch changes up to 075c18c3e124a1511ebc10a89f1858c8a77dcb01:

  dm: add missing trace_block_split() to __split_and_process_bio() (2019-01-22 13:41:48 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM crypt's parsing of extended IV arguments.

- Fix DM thinp's discard passdown to properly account for extra
  reference that is taken to guard against reallocating a block before a
  discard has been issued.

- Fix bio-based DM's redundant IO accounting that was occurring for bios
  that must be split due to the nature of the DM target (e.g. dm-stripe,
  dm-thinp, etc).

----------------------------------------------------------------
Joe Thornber (1):
      dm thin: fix passdown_double_checking_shared_status()

Mike Snitzer (4):
      dm: fix clone_bio() to trigger blk_recount_segments()
      dm: fix redundant IO accounting for bios that need splitting
      dm: fix dm_wq_work() to only use __split_and_process_bio() if appropriate
      dm: add missing trace_block_split() to __split_and_process_bio()

Milan Broz (1):
      dm crypt: fix parsing of extended IV arguments

 drivers/md/dm-crypt.c         | 25 +++++++++++++++++--------
 drivers/md/dm-thin-metadata.c |  4 ++--
 drivers/md/dm-thin-metadata.h |  2 +-
 drivers/md/dm-thin.c          | 10 +++++-----
 drivers/md/dm.c               | 43 +++++++++++++++++++++++++++++++------------
 5 files changed, 56 insertions(+), 28 deletions(-)
