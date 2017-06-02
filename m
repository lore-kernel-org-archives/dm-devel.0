From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.12-rc4
Date: Fri, 2 Jun 2017 13:16:41 -0400
Message-ID: <20170602171640.GA59854@redhat.com>
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
Cc: Junaid Shahid <junaids@google.com>, Jan Kara <jack@suse.cz>, Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 08332893e37af6ae779367e78e444f8f9571511d:

  Linux 4.12-rc2 (2017-05-21 19:30:23 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.12/dm-fixes-3

for you to fetch changes up to ff0361b34ac63ef80c785c32d62e0e9d89a2cf89:

  dm: make flush bios explicitly sync (2017-05-31 10:50:23 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- a DM verity fix for a mode when no salt is used

- a fix to DM to account for the possibility that PREFLUSH or FUA are
  used without the SYNC flag if the underlying storage doesn't have a
  volatile write-cache

- a DM ioctl memory allocation flag fix to use __GFP_HIGH to allow
  emergency forward progress (by using memory reserves as last resort)

- a small DM integrity cleanup to use kvmalloc() instead of duplicating
  the same

----------------------------------------------------------------
Gilad Ben-Yossef (1):
      dm verity: fix no salt use case

Jan Kara (1):
      dm: make flush bios explicitly sync

Junaid Shahid (1):
      dm ioctl: restore __GFP_HIGH in copy_params()

Mikulas Patocka (1):
      dm integrity: use kvmalloc() instead of dm_integrity_kvmalloc()

 drivers/md/dm-bufio.c           |  2 +-
 drivers/md/dm-integrity.c       | 30 ++++++++----------------------
 drivers/md/dm-ioctl.c           |  5 +++--
 drivers/md/dm-raid1.c           |  2 +-
 drivers/md/dm-snap-persistent.c |  3 ++-
 drivers/md/dm-verity-target.c   |  4 ++--
 drivers/md/dm.c                 |  2 +-
 7 files changed, 18 insertions(+), 30 deletions(-)
