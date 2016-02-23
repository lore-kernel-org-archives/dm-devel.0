From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fix for 4.5-rc6
Date: Tue, 23 Feb 2016 15:30:00 -0500
Message-ID: <20160223203000.GA24231@redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 81f70ba233d5f660e1ea5fe23260ee323af5d53a:

  Linux 4.5-rc5 (2016-02-20 13:39:35 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.5-fix

for you to fetch changes up to 4328daa2e79ed904a42ce00a9f38b9c36b44b21a:

  dm: fix dm_rq_target_io leak on faults with .request_fn DM w/ blk-mq paths (2016-02-21 20:27:50 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
Fix a 112 byte leak for each IO request that is requeued while DM
multipath is handling faults due to path failures.  This leak does not
happen if blk-mq DM multipath is used.  It only occurs if .request_fn DM
multipath is stacked ontop of blk-mq paths (e.g. scsi-mq devices).

----------------------------------------------------------------
Mike Snitzer (1):
      dm: fix dm_rq_target_io leak on faults with .request_fn DM w/ blk-mq paths

 drivers/md/dm.c | 2 ++
 1 file changed, 2 insertions(+)
