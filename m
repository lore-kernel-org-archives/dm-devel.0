From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper fixes for 2.6.30-rc2
Date: Thu, 9 Apr 2009 02:14:24 +0100
Message-ID: <20090409011424.GP5098@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following device-mapper fixes for 2.6.30-rc2:

1) Fix a kcopyd race.
2) Support bio integrity.
3) Support barrier bios such that dm will no longer issue -EOPNOTSUPP in
response to an unsupported barrier but will instead emulate the barrier
internally.  This finally gets us the long-overdue replacement for the
issue_flush_fn that was removed oh-I-can't-remember-when...
(Split into 7 bisectable patches for readability.)

Alasdair G Kergon (3):
      dm: rearrange dm_wq_work
      dm: split DMF_BLOCK_IO flag into two
      dm: simplify dm_request loop

Martin K. Petersen (1):
      dm: add integrity support

Mikulas Patocka (6):
      dm: remove limited barrier support
      dm: rework queueing and suspension
      dm: remove dm_request loop
      dm: implement basic barrier support
      dm kcopyd: prepare for callback race fix
      dm kcopyd: fix callback race

 drivers/md/dm-ioctl.c         |   21 +++++
 drivers/md/dm-kcopyd.c        |   23 +++--
 drivers/md/dm-linear.c        |    1 -
 drivers/md/dm-table.c         |   59 ++++++++----
 drivers/md/dm.c               |  199 +++++++++++++++++++++++++++++------------
 drivers/md/dm.h               |    1 -
 include/linux/device-mapper.h |    1 -
 7 files changed, 218 insertions(+), 87 deletions(-)
 
Alasdair
-- 
agk@redhat.com
