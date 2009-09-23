From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2] DM Snapshot: dont insert before existing
	chunk
Date: Wed, 23 Sep 2009 10:25:08 -0500
Message-ID: <200909231525.n8NFP87C029957@hydrogen.msp.redhat.com>
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
To: dm-devel@redhat.com
Cc: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Patch name: dm-snapshot-dont-insert-before-existing-chunk.patch

Don't insert into hash before an existing chunk.

Most inserts are after an existing extent anyway so this code is used
very rarely.

The snapshot merge code always pulls the chunk from the end of the
range.  Without introducing unnecessary complexity, snapshot merge can't
pull the exception from the middle of a range --- i.e. if you have range
1-10 and you merge chunk 5, you'd have to split the range into two.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -478,16 +478,6 @@ static void insert_completed_exception(s
 			return;
 		}
 
-		/* Insert before an existing chunk? */
-		if (new_e->old_chunk == (e->old_chunk - 1) &&
-		    new_e->new_chunk == (dm_chunk_number(e->new_chunk) - 1)) {
-			dm_consecutive_chunk_count_inc(e);
-			e->old_chunk--;
-			e->new_chunk--;
-			free_exception(new_e);
-			return;
-		}
-
 		if (new_e->old_chunk > e->old_chunk)
 			break;
 	}
