From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.0-rc6
Date: Thu, 7 Feb 2019 11:58:40 -0500
Message-ID: <20190207165840.GA62096@redhat.com>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

Both of these fixes address issues in changes merged for 5.0-rc4.

The following changes since commit 8834f5600cf3c8db365e18a3d5cac2c2780c81e5:

  Linux 5.0-rc5 (2019-02-03 13:48:04 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.0/dm-fixes-2

for you to fetch changes up to fa8db4948f5224dae33a0e783e7dec682e145f88:

  dm: don't use bio_trim() afterall (2019-02-06 17:24:37 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM core's missing memory barrier before waitqueue_active() calls.

- Fix DM core's clone_bio() to work when cloning a subset of a bio with
  an integrity payload; bio_integrity_trim() wasn't getting called due
  to bio_trim()'s early return.

----------------------------------------------------------------
Mike Snitzer (1):
      dm: don't use bio_trim() afterall

Mikulas Patocka (1):
      dm: add memory barrier before waitqueue_active

 drivers/md/dm-rq.c | 2 +-
 drivers/md/dm.c    | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)
