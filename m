From: akpm@osdl.org
Subject: [patch 08/24] dm: multipath: fix rr_add_path order
Date: Wed, 08 Nov 2006 17:44:43 -0800
Message-ID: <200611090144.kA91ihn1000701@shell0.pdx.osdl.net>
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
To: torvalds@osdl.org
Cc: akpm@osdl.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

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
 1 file changed, 1 insertion(+), 1 deletion(-)

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
