From: "goggin, edward" <egoggin@emc.com>
Subject: multipath deadlock
Date: Tue, 8 Mar 2005 17:05:28 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A806@SRMANNING.eng.emc.com>
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

Looks to be deadlock potential between two processes and the lock
ordering of a mapped device inode's __I_LOCK state bit and the
mapped device's r/w semaphore lock.  I think the potential for such
deadlock exists anytime the dm.c code calls bdget_disk() or bdget()
in order to lock the block device inode of the mapped device for which
it already has __exclusive__ write ownership of the r/w semaphore.  This
deadlock potential exists due to the fact that the page writeback code
can call dm_request() to acquire the mapped device's lock for reading
while owning the mapped device's __I_LOCK state bit.

This appears to happen in the call to __unlock_fs() from dm_suspend() and
in the call to __set_size() from __bind() from dm_swap_table() in dm.c.
It is not clear why dm_suspend() acquires the mapped device's lock for
reading while calling __lock_fs() yet acquires the same lock for writing
while calling __unlock_fs().

I've got an actual deadlock between multipath(8) trying to swap in a new
table and a dd(1) performing page writeback.

Multipath owns the multipath mapped device r/w semaphore lock for writing
obtained in dm_swap_table() and is blocked trying to obtain the __I_LOCK
inode state bit for the mapped device in __set_size() called from __bind()
while
trying to set the inode size of the mapped device as part of binding a new
mapping table to the device.

The dd(1) owns the __I_LOCK state bit of the mapped device's inode from
__sync_single_inode() as part of page writeback and is trying to submit
an i/o to the mapped device but is blocked in dm_request() trying to obtain
the lock r/w semaphore of the mapped device for reading.

No 
