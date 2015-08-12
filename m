From: NeilBrown <neilb@suse.com>
Subject: Re: dm-snap deadlock in pending_complete()
Date: Wed, 12 Aug 2015 11:46:31 +1000
Message-ID: <20150812114631.15268065@noble>
References: <20150810135551.64d7dbac@noble>
	<alpine.LRH.2.02.1508110509420.2623@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1508110509420.2623@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 11 Aug 2015 05:14:33 -0400 (EDT) Mikulas Patocka
<mpatocka@redhat.com> wrote:

> Hi
> 
> On Mon, 10 Aug 2015, NeilBrown wrote:
> 
> > 
> > Hi Mikulas,
> >  I have a customer hitting the deadlock you described over a year ago
> >  in:
> > 
> > Subject: [dm-devel] [PATCH] block: flush queued bios when the process
> >          blocks
> 
> Ask block layer maintainers to accept that patch.

Unfortunately I don't really like the patch ... or the bioset rescue
workqueues that it is based on.   Sorry.

So I might keep looking for a more localised approach....

> 
> > I notice that patch never went upstream.
> > 
> > Has anything else been done to fix this deadlock?
> > 
> > My thought was that something like the below would be sufficient.  Do
> > you see any problem with that?  It avoids the deadlock by dropping the
> > lock while sleeping.
> 
> The patch below introduces a bug - if the user is continuously reading the 
> same chunk (for example, by issuing multiple direct i/o requests to the 
> same chunk), the function pending_complete never finishes.
> 
> We need to hold the lock while waiting to make sure that no new read 
> requests are submitted.

Ahh - thanks for the explanation.  That makes sense.
Presumably you need to wait for old reads that you don't have a read
returning old data after a write has confirmed the new data is written?
Is there some other reason?

As soon as the new "proper" exception is installed, no new reads will
use the old address, so it should be safe to wait without holding the
lock.

So what about this?

Thanks for your time,
NeilBrown



diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 7c82d3ccce87..c7a7ed2cfd6d 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1461,14 +1461,22 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 		goto out;
 	}
 
-	/* Check for conflicting reads */
-	__check_for_conflicting_io(s, pe->e.old_chunk);
+	/* Add proper exception.  Now all reads will be
+	 * redirected, so no new reads can be started on
+	 * 'old_chunk'.
+	 */
+	dm_insert_exception(&s->complete, e);
+
+	/* Drain conflicting reads */
+	if (__chunk_is_tracked(s, pe->e.old_chunk)) {
+		up_write(&s->lock);
+		__check_for_conflicting_io(s, pe->e.old_chunk);
+		down_write(&s->lock);
+	}
 
 	/*
-	 * Add a proper exception, and remove the
-	 * in-flight exception from the list.
+	 * And now we can remove the temporary exception.
 	 */
-	dm_insert_exception(&s->complete, e);
 
 out:
 	dm_remove_exception(&pe->e);
