From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper fixes for 2.6.31-rc5
Date: Thu, 23 Jul 2009 22:23:10 +0100
Message-ID: <20090723212310.GA31998@agk-dp.fab.redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, Christian =?iso-8859-1?Q?Borntr=E4ger?= <borntraeger@de.ibm.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following device-mapper fixes for 2.6.31-rc5:

Mike Snitzer (2):
      dm: remove queue next_ordered workaround for barriers
      dm table: pass correct dev area size to device_area_is_valid

Mikulas Patocka (1):
      dm raid1: wake kmirrord when requeueing delayed bios after remote recovery

 drivers/md/dm-crypt.c         |    2 +-
 drivers/md/dm-delay.c         |    4 ++--
 drivers/md/dm-linear.c        |    2 +-
 drivers/md/dm-mpath.c         |    2 +-
 drivers/md/dm-raid1.c         |    3 ++-
 drivers/md/dm-stripe.c        |    7 ++++---
 drivers/md/dm-table.c         |   15 +++++----------
 drivers/md/dm.c               |   10 ----------
 drivers/md/dm.h               |    1 -
 include/linux/device-mapper.h |    4 ++--
 10 files changed, 18 insertions(+), 32 deletions(-)

Alasdair
-- 
agk@redhat.com
