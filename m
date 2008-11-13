From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] 2.6.28-rc5 device-mapper fixes
Date: Thu, 13 Nov 2008 23:49:33 +0000
Message-ID: <20081113234933.GW5098@agk.fab.redhat.com>
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
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Heinz Mauelshagen <mauelshagen@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull the following device-mapper fixes from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git

Chandra Seetharaman (3):
      dm mpath: avoid attempting to activate null path
      dm mpath: warn if args ignored
      dm: avoid destroying table in dm_any_congested

Heinz Mauelshagen (1):
      dm stripe: fix init failure

Mikulas Patocka (2):
      dm raid1: flush workqueue before destruction
      dm: move pending queue wake_up end_io_acct

 drivers/md/dm-mpath.c  |    8 ++++++--
 drivers/md/dm-raid1.c  |    1 +
 drivers/md/dm-stripe.c |    4 +++-
 drivers/md/dm.c        |   34 +++++++++++++++++++++-------------
 4 files changed, 31 insertions(+), 16 deletions(-)

Thanks,
Alasdair
-- 
agk@redhat.com
