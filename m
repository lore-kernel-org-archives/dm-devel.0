From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 10 of 17]
	dm-exception-stores-populate-cache-on-commit.patch
Date: Fri, 20 Feb 2009 17:24:20 -0600
Message-ID: <1235172260.24593.39.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
List-Id: dm-devel.ids

The 'resume' exception store function is now in place to
load the exception store type's caches on startup.  However,
we still need to continue to populate the caches as
new exceptions are committed.  This patch takes care of
that.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -655,6 +655,15 @@ static void persistent_commit_exception(
 	write_exception(ps, ps->current_committed++, &de);
 
 	/*
+	 * We are safe to add the exception to our cache before we
+	 * issue the callbacks.  If we fail to allocate the memory
+	 * to put it in the cache though, the callbacks will have to
+	 * report the failure.
+	 */
+	if (add_exception(store, de.old_chunk, de.new_chunk))
+		ps->valid = 0;
+
+	/*
 	 * Add the callback to the back of the array.  This code
 	 * is the only place where the callback array is
 	 * manipulated, and we know that it will never be called
Index: linux-2.6/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-transient.c
+++ linux-2.6/drivers/md/dm-snap-transient.c
@@ -77,7 +77,20 @@ static void transient_commit_exception(s
 				       void (*callback) (void *, int success),
 				       void *callback_context)
 {
-	/* Just succeed */
+	struct transient_c *tc = store->context;
+	struct dm_exception *new;
+
+	new = dm_alloc_exception(tc->table);
+	if (!new) {
+		callback(callback_context, 0);
+		return;
+	}
+
+	new->old_chunk = e->old_chunk;
+	new->new_chunk = e->new_chunk;
+
+	dm_insert_exception(tc->table, new);
+
 	callback(callback_context, 1);
 }
 
