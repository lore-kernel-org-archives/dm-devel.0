From: "goggin, edward" <egoggin@emc.com>
Subject: panic in dm_pg_init_complete+0x10
Date: Tue, 8 Mar 2005 16:23:59 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A804@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
Cc: 'Alasdair G Kergon' <agk@redhat.com>
List-Id: dm-devel.ids

While testing multipath reaction to CLARiion CX300
non-destructive ucode, dm-mpath paniced at
dm_pg_init_complete+0x10.  Using version 0.4.3-pre5
multipath tools and version 2.6.11-rc3-udm2 linux kernel.
The panic is occurring due to corrupted memory in the path
structure for a pg_init i/o completion.  I suspect that the memory
for the path structure (and its encompassing path priority group
and multipath structure) has been freed by the multipath destructor,
subsequently re-allocated for other use, and written upon.

Furthermore, I strongly suspect the panic is related to having
multiple pg_init requests outstanding for the same multipath.
Since pg_init requests are not accounted for in the pending
count of the multipath mapped device structure, it is possible
to have outstanding pg_init requests awaiting i/o completion
when the pending count is zero.  If the multipath table
is destroyed via dm_table_destroy() before the pg_init i/o
completion arrives, dm_pg_init_complete() can reference
corrupted memory.  This can happen either from the swap-in
of a new dm table or the closing of the dm mapped device.
My panic involves the former use case.

Assume that the first of two outstanding pg_init requests for
the same multipath completes with a failure.  Further assume
that both requests use the same path and that this is the last
usable path for the multipath.  When the last path fails it is
possible for multipath(8) invoked from multipathd(8)'s reaction to
the i/o failure event for the first pg_init request to attempt to
reload the multipath table for the multipath in question, possibly
with some of the other paths restored to good health.  The
dm-mpath reaction to the pre-suspension issued by the dm
level i/o suspension will cause the two user i/os associated with
the two pg_init requests to be processed and immediately failed
due to "all-paths-down" in the face of i/o suspension.  The failure
of these user i/os will decrement to zero the pending count for
the multipath mapped_device structure -- even though the second
of the two pg_init i/os is still outstanding.

After dm_suspend() returns to do_resume(), the dm_resume() code
will initiate swapping the old and new multipath tables. The call to
dm_table_put() in __unbind() called from dm_swap_table() called
from dm_resume() will initiate the freeing of the multipath structure's
memory via the multipath_dtr() destructor.

Looks to me like two issues here -- (1) probably should not allow
concurrent pg_init i/os for the same multipath and (2) possibly the
multipath destructor should block waiting for a possible outstanding
pg_init i/o to complete.  I've included a patch to dm-mpath.c which
addresses issues (1) and (2) above.  The multipath structure will now
indicate whenever a pg_init request is outstanding and process_queued_ios()
now will not initiate subsequent pg_init requests if one is outstanding.
Also, multipath_dtr() is changed to block awaiting the arrival of any
outstanding pg_init i/o completion.

Even so, there are a few issues with this --

(1) It is possible that an outstanding pg_init request and a new one
are for initializing different paths of different priority groups.  The
patch
does not account for this possibility.  Should it, possibly by just keeping
track of a count of the number of outstanding pg_init requests?  What
guarantees that these multiple pg_init requests complete in the order
that they were initially dispatched?

(2) Should the mapped device's pending count reflect outstanding i/os
initiated (not cloned) on target devices of that mapped device?  It might
be a bit difficult to push this accounting up to higher level mapped devices
stacked atop the one where the i/o is initiated.
