From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.1-rc3
Date: Fri, 8 May 2015 16:08:04 -0400
Message-ID: <20150508200803.GA32437@redhat.com>
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
Cc: dm-devel@redhat.com, Rabin Vincent <rabin.vincent@axis.com>, Chen Yu <yu.c.chen@intel.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit aa6df8dd28c01d9a3d2cfcfe9dd0a4a334d1cd81:

  dm: fix free_rq_clone() NULL pointer when requeueing unmapped request (2015-04-30 10:25:21 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.1-fixes-2

for you to fetch changes up to cb31ef485dd4c6a205d1064b42027f82076d00c8:

  init: fix regression by supporting devices with major:minor:offset format (2015-05-05 12:31:37 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
Two additional fixes for changes introduced via DM during the 4.1 merge
window: The first reverts a dm-crypt change that wasn't correct.  The
second fixes a device format regression that impacted userspace.

----------------------------------------------------------------
Chen Yu (1):
      init: fix regression by supporting devices with major:minor:offset format

Rabin Vincent (1):
      Revert "dm crypt: fix deadlock when async crypto algorithm returns -EBUSY"

 drivers/md/dm-crypt.c | 12 ++++++------
 init/do_mounts.c      |  5 +++--
 2 files changed, 9 insertions(+), 8 deletions(-)
