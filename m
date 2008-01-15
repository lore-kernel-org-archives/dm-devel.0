From: Douglas McClendon <dmc.fedora@filteredperception.org>
Subject: Re: possible snapshot corruption after system crash with
	bad	timing
Date: Mon, 14 Jan 2008 20:29:58 -0600
Message-ID: <478C1AA6.2000500@filteredperception.org>
References: <20080105224105.GA1122@debian-etc-mailname>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080105224105.GA1122@debian-etc-mailname>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Lars Ellenberg wrote:
> hi there,
> 
> I suspect that when using persistent snapshots,
> there is the (off?) chance for the snapshot to be corrupted
> after a system crash.

I hope someone can answer this, as I use persistent snapshots heavily 
for LiveUSB persistence (rootfs on a persistent snapshot (on usbflash))

Currently things seem to be working fairly well for me, wheras about 6 
months ago I would see corruption if I intentionally crashed the system 
to see how it would respond.

Still, this post worries me.  I hope someone else answers it.

-dmc


> 
> scenario described below.
> 
> Am I missing somthing?
> 
> Cheers,
> 	Lars
> 
> from current dm-exception-store.c:
> 
> static void persistent_commit(struct exception_store *store,
> 			      struct dm_snap_exception *e,
> 			      void (*callback) (void *, int success),
> 			      void *callback_context)
> {
> 	int r;
> 	unsigned int i;
> 	struct pstore *ps = get_info(store);
> 	struct disk_exception de;
> 	struct commit_callback *cb;
> 
> 	de.old_chunk = e->old_chunk;
> 	de.new_chunk = e->new_chunk;
> 	write_exception(ps, ps->current_committed++, &de);
> 
> 	/*
> 	 * Add the callback to the back of the array.  This code
> 	 * is the only place where the callback array is
> 	 * manipulated, and we know that it will never be called
> 	 * multiple times concurrently.
> 	 */
> 	cb = ps->callbacks + ps->callback_count++;
> 	cb->callback = callback;
> 	cb->context = callback_context;
> 
> 	/*
> 	 * If there are no more exceptions in flight, or we have
> 	 * filled this metadata area we commit the exceptions to
> 	 * disk.
> 	 */
> 	if (atomic_dec_and_test(&ps->pending_count) ||
> 	    (ps->current_committed == ps->exceptions_per_area)) {
> 		r = area_io(ps, ps->current_area, WRITE);
> 		if (r)
> 			ps->valid = 0;
> 
> 
> 
> ==== POSSIBLE CURRUPTION RIGHT HERE ======== 
> 
> assume we crash right after we completely filled the current area,
> but before we had a chance to zero out the next area.
> 
> further assume there has been old data garbage in the
> area mapped for this exception store.
> 
> after reboot, the snapshot will be reassembled,
> but may not find the necessary zeros to terminate the 
> read_exceptions loop in insert_exceptions,
> thus may dm_add_exception bogus mappings,
> aka data corruption.
> 
> ===========================================
> 
> 
> 		/*
> 		 * Have we completely filled the current area ?
> 		 */
> 		if (ps->current_committed == ps->exceptions_per_area) {
> 			ps->current_committed = 0;
> 			r = zero_area(ps, ps->current_area + 1);
> 			if (r)
> 				ps->valid = 0;
> 		}
> 
> 		for (i = 0; i < ps->callback_count; i++) {
> 			cb = ps->callbacks + i;
> 			cb->callback(cb->context, r == 0 ? 1 : 0);
> 		}
> 
> 		ps->callback_count = 0;
> 	}
> }
> 
