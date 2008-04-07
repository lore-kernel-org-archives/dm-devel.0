From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Data corruption on software RAID
Date: Tue, 8 Apr 2008 01:43:18 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0804080033430.13352@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758850AbYDGXng@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, agk@redhat.com, mingo@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

Hi

During source code review, I found an unprobable but possible data 
corruption on RAID-1 and on DM-RAID-1. (I'm not sure about RAID-4,5,6).

The RAID code was enhanced with bitmaps in 2.6.13.

The bitmap tracks regions on the device that may be possibly out-of-sync. 
The purpose of the bitmap is to avoid resynchronizing the whole array in 
the case of crash. DM-raid uses similar bitmap too.

The write sequnce is usually:
1. turn on bit in the bitmap (if it hasn't been on before).
2. update the data.
3. when writes to all devices finish, turn the bit may be turned off.

The developers assume that when all writes to the region finish, the 
region is in-sync.

This assumption is wrong.

Kernel writes data while they may be modified in many places. For example, 
the pdflush daemon writes periodically pages and buffers without locking 
them. Similarly, pages may be written while they are mapped for write to 
the processes.

Normally, there is no problem with modify-while-write. The write sequence 
is something like:
* turn off Dirty bit
* write the buffer or page
--- and if the buffer or page is modified while it's being written, the 
Dirty bit is turned on again and the correct data are written later.

But with RAID (since 2.6.13), it can produce corruption because when the 
buffer is modified while being written, different versions of data can be 
written to devices in the RAID array. For example:

1. pdflush turns off a dirty bit on Ext2 bitmap buffer and starts writing 
the buffer to RAID-1
2. the kernel allocates some blocks in that Ext2 bitmap. One of RAID-1 
devices writes new data, the other one gets old data.
3. The kernel turns on the buffer dirty bit, so this buffer is scheduled 
for next write.
4. RAID-1 subsystem sees that both writes finished, it thinks that this 
region is in-sync, turns off its dirty bit in its region bitmap and writes 
the bitmap to disk.
5. before pdflush writes the Ext2 bitmap buffer again, the system CRASHES

6. after new boot, RAID-1 sees the bit for this region off, so it doesn't 
resynchronize it.
7. during fsck, RAID-1 reads the Ext2 bitmap from the device where the bit 
is on. fsck sees that the bitmap is correct and doesn't touch it.
8. some times later kernel reads the Ext2 bitmap from the other device. It 
sees the bit off, allocates some data there and creates cross-linked 
files.

The same corruption may happen with some jorunaled filesystems (probably 
not Ext3) or applications that do their own crash recovery (databases, 
etc.). The key point is that an application expects that after a crash it 
reads old data or new data, but it doesn't expect that subsequent reads to 
the same place may alternatively return old or new data --- which may 
happen on RAID-1.


Possibilities how to fix it:

1. lock the buffers and pages while they are being written --- this would 
cause performance degradation (the most severe degradation would be in 
case when one process does repeatedly sync() and other unrelated 
process repeatedly writes to some file).

Lock the buffers and pages only for RAID --- would create many special 
cases and possible bugs.

2. never turn the region dirty bit off until the filesystem is unmounted. 
--- this is the simplest fix. If the computer crashes after a long 
time, it resynchronizes the whole device. But there won't cause 
application-visible or filesystem-visible data corruption.

3. turn off the region bit if the region wasn't written in one pdflush 
period --- requires an interaction with pdflush, rather complex. The 
problem here is that pdflush makes its best effort to write data in 
dirty_writeback_centisecs interval, but it is not guaranteed to do it.

4. make more region states: Region has in-memory states CLEAN, DIRTY, 
MAYBE_DIRTY, CLEAN_CANDIDATE.

When you start writing to the region, it is always moved to DIRTY state 
(and on-disk bit is turned on).

When you finish all writes to the region, move it to MAYBE_DIRTY state, 
but leave bit on disk on. We now don't know if the region is dirty or no.

Run a helper thread that does periodically:
Change MAYBE_DIRTY regions to CLEAN_CANDIDATE
Issue sync()
Change CLEAN_CANDIDATE regions to CLEAN state and clear their on-disk bit.

The rationale is that if the above write-while-modify scenario happens, 
the page is always dirty. Thus, sync() will write the page, kick the 
region back from CLEAN_CANDIDATE to MAYBE_DIRTY state and we won't mark 
the region as clean on disk.


I'd like to know you ideas on this, before we start coding a solution.

Mikulas
