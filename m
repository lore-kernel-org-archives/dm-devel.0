From: "goggin, edward" <egoggin@emc.com>
Subject: Panic in multipath's trigger_event function
Date: Tue, 22 Feb 2005 17:56:25 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A7C3@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_000_01C51931.BC2ABB85"
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

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C51931.BC2ABB85
Content-Type: text/plain

Trigger_event() has paniced maybe 3 or 4 times now, with one
simple dd process running while serially rebooting both
(active and passive) service processors of a two service
processor EMC CLARiion as part of a non-destructive
upgrade (NDU) of ucode.

I think the problem is that when the old table/map for a multipath
mapped device is swapped for a new one by dm_swap_table(), it
is possible that the trigger_event work_struct field of the multipath
structure for the old map is actively queued to a cpu work queue
when table_destroy() sets about to de-allocate the memory for the
old table, the dm_target, and calls the multipath destructor
multipath_dtr() to de-allocate the multipath structure memory.  If
any of these things happen before the work queue entry is serviced,
trigger_event() will refer to stale dm_table, dm_target, or multipath
structure memory.  This problem does not happen with the 
process_queued_ios() event callback because these entries are
flushed and waited for by dm_suspend() before dm_resume() calls
dm_swap_table().

In this case, the panic occurs when trigger_event() de-references
the ti struct dm_target field of the old multipath structure because
the dm_target structure memory for the multipath target was
de-allocated via vfree() and the reference to the ti field of the
multipath structure is to unmapped kernel memory.

Several solutions come to mind, namely (1) using reference counts
for the multipath structure and (2) flushing the default work queue
in the multipath destructor.  I've included a patch for the latter in this
email.

 <<dm-mpath c.patch>> 


------_=_NextPart_000_01C51931.BC2ABB85
Content-Type: application/octet-stream;
	name="dm-mpath c.patch"
Content-Disposition: attachment;
	filename="dm-mpath c.patch"

*** dm-mpath.c.orig	2005-02-22 10:11:47.000000000 -0500
--- dm-mpath.c	2005-02-22 12:03:15.900426560 -0500
***************
*** 747,752 ****
--- 747,754 ----
  static void multipath_dtr(struct dm_target *ti)
  {
  	struct multipath *m = (struct multipath *) ti->private;
+ 
+ 	flush_scheduled_work();
  	free_multipath(m);
  }
  

------_=_NextPart_000_01C51931.BC2ABB85
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_000_01C51931.BC2ABB85--
