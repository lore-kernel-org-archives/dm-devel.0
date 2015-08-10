From: NeilBrown <neilb@suse.com>
Subject: dm-snap deadlock in pending_complete()
Date: Mon, 10 Aug 2015 13:55:51 +1000
Message-ID: <20150810135551.64d7dbac@noble>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids


Hi Mikulas,
 I have a customer hitting the deadlock you described over a year ago
 in:

Subject: [dm-devel] [PATCH] block: flush queued bios when the process
         blocks

I notice that patch never went upstream.

Has anything else been done to fix this deadlock?

My thought was that something like the below would be sufficient.  Do
you see any problem with that?  It avoids the deadlock by dropping the
lock while sleeping.

Thanks
NeilBrown

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 7c82d3ccce87..d29bcd02f9cf 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1454,6 +1454,7 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 	}
 	*e = pe->e;
 
+retry:
 	down_write(&s->lock);
 	if (!s->valid) {
 		free_completed_exception(e);
@@ -1462,7 +1463,11 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 	}
 
 	/* Check for conflicting reads */
-	__check_for_conflicting_io(s, pe->e.old_chunk);
+	if (__chunk_size_tracked(s, pe->e.old_chunk)) {
+		up_write(&s->lock);
+		msleep(1);
+		goto retry;
+	}
 
 	/*
 	 * Add a proper exception, and remove the
