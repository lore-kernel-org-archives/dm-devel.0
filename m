From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.16 final
Date: Fri, 30 Mar 2018 00:07:49 -0400
Message-ID: <20180330040749.GA6551@redhat.com>
References: <20180329211856.GA8119@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180329211856.GA8119@redhat.com>
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
Cc: Paul Mackerras <paulus@ozlabs.org>, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Linus,

I've updated the tag to include an additional fix for a 4.16-rc
regression (my -rc fixes clearly need better regression testing!).

The following changes since commit 8c5c147339d2e201108169327b1f99aa6d57d2cd:

  dm mpath: fix passing integrity data (2018-03-14 15:39:33 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.16/dm-fixes-4

for you to fetch changes up to da5dadb4f11660ca67580cd4a7420161266d6254:

  dm: fix dropped return code from dm_get_bdev_for_ioctl (2018-03-29 23:31:32 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Fix a DM multipath regression introduced in a v4.16-rc6 commit:
  restore support for loading, and attaching, scsi_dh modules during
  multipath table load.  Otherwise some users may find themselves unable
  to boot, as was reported today:
  https://marc.info/?l=linux-scsi&m=152231276114962&w=2

- Fix a DM core ioctl permission check regression introduced in a
  v4.16-rc5 commit.

----------------------------------------------------------------
Mike Snitzer (2):
      dm mpath: fix support for loading scsi_dh modules during table load
      dm: fix dropped return code from dm_get_bdev_for_ioctl

 drivers/md/dm-mpath.c | 2 +-
 drivers/md/dm.c       | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)
