From: akpm@osdl.org
Subject: + dm-multipath-fix-rr_add_path-order.patch added to -mm
	tree
Date: Tue, 07 Nov 2006 12:29:17 -0800
Message-ID: <200611072029.kA7KTH3b015223@shell0.pdx.osdl.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mm-commits@vger.kernel.org
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


The patch titled
     dm: multipath: fix rr_add_path order
has been added to the -mm tree.  Its filename is
     dm-multipath-fix-rr_add_path-order.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm: multipath: fix rr_add_path order
From: Jonathan E Brassow <jbrassow@redhat.com>

When adding paths to the round-robin path selector, their order gets inverted,
which is not desirable.

Fix by replacing list_add() with list_add_tail().

Signed-off-by: Jonathan E Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: <dm-devel@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-round-robin.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/dm-round-robin.c~dm-multipath-fix-rr_add_path-order drivers/md/dm-round-robin.c
--- a/drivers/md/dm-round-robin.c~dm-multipath-fix-rr_add_path-order
+++ a/drivers/md/dm-round-robin.c
@@ -136,7 +136,7 @@ static int rr_add_path(struct path_selec
 
 	path->pscontext = pi;
 
-	list_add(&pi->list, &s->valid_paths);
+	list_add_tail(&pi->list, &s->valid_paths);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jbrassow@redhat.com are

dm-multipath-fix-rr_add_path-order.patch
dm-raid1-fix-waiting-for-io-on-suspend.patch
dm-raid1-fix-waiting-for-io-on-suspend-fix.patch
