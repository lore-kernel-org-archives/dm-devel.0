From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fix for 4.16-rc2
Date: Fri, 16 Feb 2018 11:03:32 -0500
Message-ID: <20180216160331.GA8182@redhat.com>
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
Cc: dm-devel@redhat.com, NeilBrown <neilb@suse.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 7928b2cbe55b2a410a0f5c1f154610059c57b1b2:

  Linux 4.16-rc1 (2018-02-11 15:04:29 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.16/dm-chained-bios-fix

for you to fetch changes up to 8dd601fa8317243be887458c49f6c29c2f3d719f:

  dm: correctly handle chained bios in dec_pending() (2018-02-16 10:46:35 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Fix for DM core to properly propagate errors (avoids overriding
  non-zero error with 0).  This is particularly important given DM
  core's increased use of chained bios.

----------------------------------------------------------------
NeilBrown (1):
      dm: correctly handle chained bios in dec_pending()

 drivers/md/dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
