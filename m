From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v5 03/13] dm exception store: snapshot-merge
	usage accounting
Date: Mon, 7 Dec 2009 16:10:53 -0500
Message-ID: <20091207211053.GE16769@redhat.com>
References: <1259893434-10792-1-git-send-email-snitzer@redhat.com>
	<1259893434-10792-4-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1259893434-10792-4-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

From: Mike Snitzer <snitzer@redhat.com>
Subject: dm exception store: snapshot-merge usage accounting

Adjust the persistent exception store's next_free to the last chunk that
was processed in persistent_commit_merge().  prepare_merge() may change
ps->current_area but not before commit_merge() processes 'nr_merged'
chunks from it.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
---
NOTE: this is a replacement for the following patch:
http://patchwork.kernel.org/patch/64746/
---
 drivers/md/dm-snap-persistent.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -753,10 +753,14 @@ static int persistent_commit_merge(struc
 	ps->current_committed -= nr_merged;
 
 	/*
-	 * Note that we make no attempt to keep ps->next_free up-to-date
-	 * as exceptions may have been allocated out-of-order.
-	 * Once a snapshot has become merging, nothing further uses it.
+	 * Update ps->next_free so persistent_usage() is accurate
+	 * - must account for the first two metadata chunks
+	 * - prepare_merge() may change ps->current_area but not before
+	 *   commit_merge() processes 'nr_merged' from the current_area
 	 */
+	ps->next_free =
+		(area_location(ps, ps->current_area) - 1 +
+		 ps->current_committed + 2);
 
 	return 0;
 }
