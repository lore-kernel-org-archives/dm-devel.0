From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Desynchronizing dm-raid1
Date: Wed, 2 Apr 2008 16:23:41 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0804021444120.22485@porkchop.devel.redhat.com>
References: <Pine.LNX.4.64.0803131238520.23136@porkchop.devel.redhat.com>
	<Pine.LNX.4.64.0803171338130.7598@porkchop.devel.redhat.com>
	<47DEC402.10309@redhat.com>
	<Pine.LNX.4.64.0803171611430.31803@porkchop.devel.redhat.com>
	<20080317215631.GG29322@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181921380.10939@porkchop.devel.redhat.com>
	<20080318233955.GA12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181942140.20490@porkchop.devel.redhat.com>
	<20080319000241.GB12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803182015001.21077@porkchop.devel.redhat.com>
	<20080319011757.GD12007@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080319011757.GD12007@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Unfortunatelly, the bug with desychnronizing raid1 that someone pointed 
out on Monday, is real. The bug happens when you modify the page while its 
being written to raid1 device --- old version can be written to one mirror 
leg, the new versions to the other mirror leg. Raid1 code does not notice 
this, marks the region clean after the writes finish, and the volume stays 
desynchronized.

The possibilities, how data can be modified while they are being written.

1. an application does O_DIRECT IO and modifies the memory underway.

--- this is a problem of the application and we don't have to care about 
it.

2. an application maps file for writing. pdflush or kswapd daemon writes 
the page on background while the application is modifying it.

3. an application writes to a page with write() syscall. This syscall 
can race with pdflush or kswapd as well.

4. a filesystem modifies the buffer while its being written by pdflush or 
kswapd daemons.


The pdflush and kswapd daemons run in background and do periodic writes of 
the modified data. pdflush is triggered regularly and writes data in 
specified interval (about 30 seconds), so that in case of crash, the image 
on disk is not too old. kswapd is triggered when the free memory goes low 
--- it writes file pages and filesystem buffers too.

In cases 2,3,4 the data may be modified while they are being written, 
but the kernel writes them later again. The sequence is something like:
clear dirty bit
submit IO
--- if the data are modified while the IO is in progress, the dirty bit is 
turned on again and the data will be written later and possible data 
corruption is corrected. --- so as long as the system does not crash, 
there can't be desynchronized mirror.

But if the system crashes before the data are written second time, the 
blocks may stay desynchronized.

An example of data corruption on ext2:

We have a dirty bitmap buffer
Pdflush clears the dirty flag and starts writing the buffer
The write is submitted to dm-raid1, it makes two requests and submits them 
to two mirror devices

This operation races with another thread allocating a block on ext2 and 
doing:
ext2_new_blocks
calling read_block_bitmap
 	calling sb_getblk
 	calling bh_uptodate_or_lock --- sees that the buffer is uptodate 
(even if it's under write), so it returns.
calling ext2_try_to_allocate_with_rsv
 	calling ext2_try_to_allocate
 		calling ext2_set_bit_atomic --- this modifies the bitmap
 		*** now suppose that 2nd mirror device already finished
 		its write and don't get updated bit, while 1st mirror
 		device writes the updated bit to disk.
calling mark_buffer_dirty --- this schedules new update of the buffer 
(after several seconds)

Both writes finished, dm-raid1 driver turns off the dirty bit for the 
region.

Before pdflush writes the buffer second time, we get a
***CRASH***

After new boot, dm-raid1 doesn't update the region, because the region's 
bit is off. fsck scans the device. It reads the bitmap from the first 
device, sees that the bit is correctly set and doesn't write the bitmap.

Some times later, the administrator removes the 1st disk, the kernel 
starts reading from 2nd mirror. Ext2 allocates another file, it reads the 
bitmap from the 2nd device, sees the bit is off and allocates another 
block there. Now there is data corruption => two files pointing to the 
same block.


Ideas how to fix it:

1. lock the buffers and unmap the pages while they are being written.
--- upstream developers would likely reject it. No other driver than 
dm-raid1 has problems with this and they wouldn't damp performance because 
of one driver.

2. never turn the region dirty bit off until the filesystem is unmounted.
--- simplest fix. If the computer crashes after a long time, it 
resynchronizes the whole device. md-raid resynchronizes the whole device 
after a crash too.

3. turn off the bit if the block wasn't written in one pdflush period
--- requires an interaction with pdflush, rather complex, I wouldn't 
recommend it.

4. make more region states.
--- If the region is in RH_DIRTY state and all writes drain, the state is 
changed to RH_MAYBE_DIRTY. (we don't know if the region is synchronized or 
not). The disk dirty flag is kept.
--- periodically (once in few minutes, so that it doesn't affect 
performance much), the change all regions in RH_MAYBE_DIRTY state to 
RH_CLEAN_CANDIDATE, then issue sync() on all filesystems. If, after the 
sync(), the region is still in RH_CLEAN_CANDIDATE (i.e. it hasn't been 
written during the sync()), it is moved to RH_CLEAN state and the on-disk 
bit for the region is turned off.

If one of the above scenarios 2,3,4 happened (modifying a buffer while 
it's under the disk write), the the sync() would have written the buffer 
again and kicked the region out of RH_CLEAN_CANDIDATE state. If the sync() 
didn't touch the buffer than we are sure that both on-disk copies are 
synchronized.


Do you have any other ideas on this?

Mikulas
