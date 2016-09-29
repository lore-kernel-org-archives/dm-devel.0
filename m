From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 04/10] dm snapshot: Rename a jump label in pending_complete()
Date: Thu, 29 Sep 2016 11:12:15 +0200
Message-ID: <091f083a-7858-787d-d862-496b7524ced1@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 29 Sep 2016 08:18:51 +0200

Adjust jump labels according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-snap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 82b7604..a6b797f 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1460,7 +1460,7 @@ static void pending_complete(void *context, int success)
 		down_write(&s->lock);
 		__invalidate_snapshot(s, -EIO);
 		error = 1;
-		goto out;
+		goto remove_exception;
 	}
 
 	e = alloc_completed_exception(GFP_NOIO);
@@ -1468,7 +1468,7 @@ static void pending_complete(void *context, int success)
 		down_write(&s->lock);
 		__invalidate_snapshot(s, -ENOMEM);
 		error = 1;
-		goto out;
+		goto remove_exception;
 	}
 	*e = pe->e;
 
@@ -1476,7 +1476,7 @@ static void pending_complete(void *context, int success)
 	if (!s->valid) {
 		free_completed_exception(e);
 		error = 1;
-		goto out;
+		goto remove_exception;
 	}
 
 	/* Check for conflicting reads */
@@ -1487,8 +1487,7 @@ static void pending_complete(void *context, int success)
 	 * in-flight exception from the list.
 	 */
 	dm_insert_exception(&s->complete, e);
-
-out:
+remove_exception:
 	dm_remove_exception(&pe->e);
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
 	origin_bios = bio_list_get(&pe->origin_bios);
-- 
2.10.0
