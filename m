From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] 2.6.28-rc2 device-mapper fixes
Date: Thu, 30 Oct 2008 13:47:29 +0000
Message-ID: <20081030134729.GQ5098@agk.fab.redhat.com>
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
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Heinz Mauelshagen <mauelshagen@redhat.com>, Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull the following device-mapper fixes from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git
  
Ilpo Jarvinen (1):
      dm raid1: fix do_failures

Mikulas Patocka (2):
      dm snapshot: fix register_snapshot deadlock
      dm snapshot: wait for chunks in destructor

 drivers/md/dm-raid1.c |    3 ++-
 drivers/md/dm-snap.c  |   32 ++++++++++++++++++++++++--------
 drivers/md/dm-snap.h  |    2 ++
 3 files changed, 28 insertions(+), 9 deletions(-)

Thanks,
Alasdair
-- 
agk@redhat.com
