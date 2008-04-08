From: Helge Hafting <helge.hafting@aitel.hist.no>
Subject: Re: Data corruption on software RAID
Date: Tue, 08 Apr 2008 12:22:54 +0200
Message-ID: <47FB477E.40502@aitel.hist.no>
References: <Pine.LNX.4.64.0804080033430.13352@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804080033430.13352@artax.karlin.mff.cuni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, agk@redhat.com, mingo@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

Mikulas Patocka wrote:
> Hi
>
> During source code review, I found an unprobable but possible data 
> corruption on RAID-1 and on DM-RAID-1. (I'm not sure about RAID-4,5,6).
>
> The RAID code was enhanced with bitmaps in 2.6.13.
>
> The bitmap tracks regions on the device that may be possibly out-of-sync. 
> The purpose of the bitmap is to avoid resynchronizing the whole array in 
> the case of crash. DM-raid uses similar bitmap too.
>
> The write sequnce is usually:
> 1. turn on bit in the bitmap (if it hasn't been on before).
> 2. update the data.
> 3. when writes to all devices finish, turn the bit may be turned off.
>
> The developers assume that when all writes to the region finish, the 
> region is in-sync.
>
> This assumption is wrong.
>
> Kernel writes data while they may be modified in many places. For example, 
> the pdflush daemon writes periodically pages and buffers without locking 
> them. Similarly, pages may be written while they are mapped for write to 
> the processes.
>
> Normally, there is no problem with modify-while-write. The write sequence 
> is something like:
> * turn off Dirty bit
> * write the buffer or page
> --- and if the buffer or page is modified while it's being written, the 
> Dirty bit is turned on again and the correct data are written later.
>
> But with RAID (since 2.6.13), it can produce corruption because when the 
> buffer is modified while being written, different versions of data can be 
> written to devices in the RAID array. For example:
>
> 1. pdflush turns off a dirty bit on Ext2 bitmap buffer and starts writing 
> the buffer to RAID-1
> 2. the kernel allocates some blocks in that Ext2 bitmap. One of RAID-1 
> devices writes new data, the other one gets old data.
> 3. The kernel turns on the buffer dirty bit, so this buffer is scheduled 
> for next write.
> 4. RAID-1 subsystem sees that both writes finished, it thinks that this 
> region is in-sync, turns off its dirty bit in its region bitmap and writes 
> the bitmap to disk.
>   
Would this help:
RAID-1 sees that both writes finished. It checks the dirty bits on all
relevant buffers/pages. If none got re-dirtied, then it is ok to
turn off the dirty bit in the region bitmap and write that. Otherwise, 
it is not!

Or is such a check too time-consuming?

Helge Hafting
