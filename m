From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH 09/11] dm: snapshot: abstract memory release
Date: Wed, 22 Nov 2006 19:04:48 +0000
Message-ID: <20061122190448.GZ6993@agk.surrey.redhat.com>
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
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Milan Broz <mbroz@redhat.com>

Move the code that releases memory used by a snapshot into a separate function.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com

Index: linux-2.6.19-rc6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.19-rc6.orig/drivers/md/dm-snap.c	2006-11-22 17:26:58.000000000 +0000
+++ linux-2.6.19-rc6/drivers/md/dm-snap.c	2006-11-22 17:27:01.000000000 +0000
@@ -564,6 +564,17 @@ static int snapshot_ctr(struct dm_target
 	return r;
 }
 
+static void __free_exceptions(struct dm_snapshot *s)
+{
+	kcopyd_client_destroy(s->kcopyd_client);
+	s->kcopyd_client = NULL;
+
+	exit_exception_table(&s->pending, pending_cache);
+	exit_exception_table(&s->complete, exception_cache);
+
+	s->store.destroy(&s->store);
+}
+
 static void snapshot_dtr(struct dm_target *ti)
 {
 	struct dm_snapshot *s = (struct dm_snapshot *) ti->private;
@@ -574,13 +585,7 @@ static void snapshot_dtr(struct dm_targe
 	/* After this returns there can be no new kcopyd jobs. */
 	unregister_snapshot(s);
 
-	kcopyd_client_destroy(s->kcopyd_client);
-
-	exit_exception_table(&s->pending, pending_cache);
-	exit_exception_table(&s->complete, exception_cache);
-
-	/* Deallocate memory used */
-	s->store.destroy(&s->store);
+	__free_exceptions(s);
 
 	dm_put_device(ti, s->origin);
 	dm_put_device(ti, s->cow);
