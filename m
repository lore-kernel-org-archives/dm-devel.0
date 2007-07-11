From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.23 PATCH 06/18] dm raid1: fix status
Date: Wed, 11 Jul 2007 21:58:29 +0100
Message-ID: <20070711205829.GX24114@agk.fab.redhat.com>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Milan Broz <mbroz@redhat.com>

Fix mirror status line broken in dm-log-report-fault-status.patch:
  - space missing between two words
  - placeholder ("0") required for compatibility with a subsequent patch
  - incorrect offset parameter

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-raid1.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/md/dm-raid1.c
===================================================================
--- linux.orig/drivers/md/dm-raid1.c	2007-07-11 21:37:40.000000000 +0100
+++ linux/drivers/md/dm-raid1.c	2007-07-11 21:37:42.000000000 +0100
@@ -1288,12 +1288,12 @@ static int mirror_status(struct dm_targe
 		for (m = 0; m < ms->nr_mirrors; m++)
 			DMEMIT("%s ", ms->mirror[m].dev->name);
 
-		DMEMIT("%llu/%llu",
+		DMEMIT("%llu/%llu 0 ",
 			(unsigned long long)ms->rh.log->type->
 				get_sync_count(ms->rh.log),
 			(unsigned long long)ms->nr_regions);
 
-		sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
+		sz += ms->rh.log->type->status(ms->rh.log, type, result+sz, maxlen-sz);
 
 		break;
 
