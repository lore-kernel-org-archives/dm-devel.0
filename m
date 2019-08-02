From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.3-rc3
Date: Fri, 2 Aug 2019 11:18:25 -0400
Message-ID: <20190802151824.GA86075@lobo>
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
Cc: linux-block@vger.kernel.org, Pankaj Gupta <pagupta@redhat.com>, dm-devel@redhat.com, Dan Williams <dan.j.williams@intel.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 609488bc979f99f805f34e9a32c1e3b71179d10b:

  Linux 5.3-rc2 (2019-07-28 12:47:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.3/dm-fixes-1

for you to fetch changes up to 9c50a98f55f4b123227eebb25009524d20bc4c2a:

  dm table: fix various whitespace issues with recent DAX code (2019-07-30 18:59:24 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
Fix NULL pointer and various whitespace issues with DM's recent DAX code
changes from commit in 5.3 merge.

----------------------------------------------------------------
Mike Snitzer (1):
      dm table: fix various whitespace issues with recent DAX code

Pankaj Gupta (1):
      dm table: fix dax_dev NULL dereference in device_synchronous()

 drivers/md/dm-table.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)
