From: "goggin, edward" <egoggin@emc.com>
Subject: "queue if no paths" infinite recursion when there are no
	paths
Date: Wed, 23 Feb 2005 16:20:15 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A7CE@SRMANNING.eng.emc.com>
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
List-Id: dm-devel.ids

It appears that there is no stopping condition for retrying i/os failed
via bio_endio() in dispatch_queued_ios().  The bio_endio() initiated
callback to multipath_end_io() ends up __always__ requeuing the
failed bio in do_end_io().

The pre-requisites seem to be (1) a storage system class configured
with the "queue_if_no_path" feature, (2) an "all-paths-to-LU-down" use
case causing the i/o to be queued on the LU multipath queue to begin
with, and (3) a dm suspend issued on the mapped device which will
Invoke dispatch_queued_ios() to clear out this queue.

I haven't had time to work up a patch but it seems like setting a flag
in the mpath_io structure the first time an i/o has been queued due to
a "no paths" condition would be a sufficient stopping condition from
allowing the i/o to be queued again in this manner.

While failing these i/os in this manner is not all that desirable in the
first place, it is at least a better solution than recursing ad infinitum.
