From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fix for 4.16 final
Date: Thu, 29 Mar 2018 17:18:56 -0400
Message-ID: <20180329211856.GA8119@redhat.com>
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
Cc: Paul Mackerras <paulus@ozlabs.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 8c5c147339d2e201108169327b1f99aa6d57d2cd:

  dm mpath: fix passing integrity data (2018-03-14 15:39:33 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.16/dm-fixes-4

for you to fetch changes up to e457edf0b21c873be827b7c2f6b8e1545485c415:

  dm mpath: fix support for loading scsi_dh modules during table load (2018-03-29 17:00:44 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Fix a DM multipath regression introduced in a v4.16-rc6 commit:
  restore support for loading, and attaching, scsi_dh modules during
  multipath table load.  Otherwise some users may find themselves unable
  to boot, as was reported today:
  https://marc.info/?l=linux-scsi&m=152231276114962&w=2

----------------------------------------------------------------
Mike Snitzer (1):
      dm mpath: fix support for loading scsi_dh modules during table load

 drivers/md/dm-mpath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
