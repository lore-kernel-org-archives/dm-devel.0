From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 25/26] dm raid1: switch rh_in_sync to
	blocking in do_reads
Date: Tue, 8 May 2007 20:49:17 +0100
Message-ID: <20070508194917.GF24114@agk.fab.redhat.com>
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

From: Jonathan Brassow <jbrassow@redhat.com>

The call to rh_in_sync() in do_reads() should be allowed to block.  It
is in the mirror worker thread which already permits blocking
operations.  This will be needed to support clustered mirroring which
will perform network operations.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-raid1.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-raid1.c	2007-05-01 19:20:17.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-raid1.c	2007-05-01 19:20:19.000000000 +0100
@@ -741,7 +741,7 @@ static void do_reads(struct mirror_set *
 		/*
 		 * We can only read balance if the region is in sync.
 		 */
-		if (rh_in_sync(&ms->rh, region, 0))
+		if (rh_in_sync(&ms->rh, region, 1))
 			m = choose_mirror(ms, bio->bi_sector);
 		else
 			m = ms->default_mirror;
