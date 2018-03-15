From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.16-rc6
Date: Thu, 15 Mar 2018 11:16:15 -0400
Message-ID: <20180315151614.GA14261@redhat.com>
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
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 0c8efd610b58cb23cefdfa12015799079aef94ae:

  Linux 4.16-rc5 (2018-03-11 17:25:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.16/dm-fixes-3

for you to fetch changes up to 8c5c147339d2e201108169327b1f99aa6d57d2cd:

  dm mpath: fix passing integrity data (2018-03-14 15:39:33 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- A stable DM multipath fix to restore ability to pass integrity data

- 2 DM multipath fixes for a fix that was merged into 4.15-rc5

----------------------------------------------------------------
Mike Snitzer (2):
      dm mpath: fix uninitialized 'pg_init_wait' waitqueue_head NULL pointer
      dm mpath: eliminate need to use scsi_device_from_queue

Steffen Maier (1):
      dm mpath: fix passing integrity data

 drivers/md/dm-mpath.c | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)
