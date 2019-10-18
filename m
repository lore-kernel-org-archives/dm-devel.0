From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.4-rc4
Date: Fri, 18 Oct 2019 12:08:33 -0400
Message-ID: <20191018160833.GA5763@redhat.com>
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
Cc: Nikos Tsironis <ntsironis@arrikto.com>, YueHaibing <yuehaibing@huawei.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit da0c9ea146cbe92b832f1b0f694840ea8eb33cce:

  Linux 5.4-rc2 (2019-10-06 14:27:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.4/dm-fixes

for you to fetch changes up to 13bd677a472d534bf100bab2713efc3f9e3f5978:

  dm cache: fix bugs when a GFP_NOWAIT allocation fails (2019-10-17 11:13:50 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM snapshot deadlock that can occur due to COW throttling
  preventing locks from being released.

- Fix DM cache's GFP_NOWAIT allocation failure error paths by switching
  to GFP_NOIO.

- Make __hash_find() static in the DM clone target.

----------------------------------------------------------------
Mikulas Patocka (3):
      dm snapshot: introduce account_start_copy() and account_end_copy()
      dm snapshot: rework COW throttling to fix deadlock
      dm cache: fix bugs when a GFP_NOWAIT allocation fails

YueHaibing (1):
      dm clone: Make __hash_find static

 drivers/md/dm-cache-target.c | 28 +------------
 drivers/md/dm-clone-target.c |  4 +-
 drivers/md/dm-snap.c         | 94 ++++++++++++++++++++++++++++++++++++--------
 3 files changed, 81 insertions(+), 45 deletions(-)
