From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.13 final
Date: Thu, 31 Aug 2017 16:52:08 -0400
Message-ID: <20170831205207.GA12284@redhat.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

I've been away for a few weeks recovering from injury so that is why
these 4.13 fixes are so late.

The following changes since commit cc4a41fe5541a73019a864883297bd5043aa6d98:

  Linux 4.13-rc7 (2017-08-27 17:20:40 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.13/dm-fixes-2

for you to fetch changes up to 1c23484c355ec360ca2f37914f8a4802c6baeead:

  dm mpath: do not lock up a CPU with requeuing activity (2017-08-28 09:58:27 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- A couple fixes for bugs introduced as part of the blk_status_t block
  layer changes during the 4.13 merge window

- A printk throttling fix to use discrete rate limiting state for each
  DM log level

- A stable@ fix for DM multipath that delays request requeueing to avoid
  CPU lockup if/when the request queue is "dying"

----------------------------------------------------------------
Bart Van Assche (4):
      dm: fix the second dec_pending() argument in __split_and_process_bio()
      dm mpath: retry BLK_STS_RESOURCE errors
      dm: fix printk() rate limiting code
      dm mpath: do not lock up a CPU with requeuing activity

 drivers/md/dm-mpath.c         |  2 --
 drivers/md/dm.c               | 12 +-----------
 include/linux/device-mapper.h | 41 ++++++++++++-----------------------------
 3 files changed, 13 insertions(+), 42 deletions(-)
