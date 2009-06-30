From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper important fixes for 2.6.31-rc2
Date: Tue, 30 Jun 2009 15:28:32 +0100
Message-ID: <20090630142832.GI5744@agk-dp.fab.redhat.com>
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
Cc: martin.petersen@oracle.com, Mike Snitzer <snitzer@redhat.com>, Yi Yang <yi.y.yang@intel.com>, Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following important device-mapper fixes for 2.6.31-rc2:

Mike Snitzer (1):
      dm table: fix blk_stack_limits arg to use bytes not sectors

Milan Broz (1):
      dm exception store: really fix type lookup

 drivers/md/dm-exception-store.c |    9 ++++++---
 drivers/md/dm-table.c           |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)
 
Alasdair
-- 
agk@redhat.com
