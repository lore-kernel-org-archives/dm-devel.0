From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.11-rc1
Date: Thu, 2 Mar 2017 10:39:17 -0500
Message-ID: <20170302153916.GA35026@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit d67a5f4b5947aba4bfe9a80a2b86079c215ca755:

  dm: flush queued bios when process blocks to avoid deadlock (2017-02-17 00:54:10 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-4.11-fixes

for you to fetch changes up to 2664f3c94abc7181171b7c05b2aaa76ea7d9d613:

  dm raid: bump the target version (2017-02-28 16:47:52 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- A dm-raid stable@ fix for possible corruption when triggering a raid
  reshape via lvm2; and an additional small patch ontop to bump version
  of the dm-raid target outside of the stable@ fix

- A dm-raid fix for a 'dm-4.11-changes' regression introduced by a
  commit that was meant to only cleanup confusing branching.

----------------------------------------------------------------
Heinz Mauelshagen (1):
      dm raid: fix data corruption on reshape request

Mike Snitzer (2):
      dm raid: fix raid "check" regression due to improper cleanup in raid_message()
      dm raid: bump the target version

 drivers/md/dm-raid.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)
