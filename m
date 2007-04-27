From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Strange problem with Device Mapper
Date: Thu, 26 Apr 2007 21:04:55 -0700
Message-ID: <20070426210455.05400edf.akpm@linux-foundation.org>
References: <006001c78826$13f50cf0$4b00a8c0@donald>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <006001c78826$13f50cf0$4b00a8c0@donald>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: rol@as2917.net
Cc: dm-devel@redhat.com, 'LKML' <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, 26 Apr 2007 19:12:27 +0200 "Paul Rolland" <rol@as2917.net> wrote:

> Hello,
> 
> I've a machine that has been installed with Intel Soft Raid on top
> of 2 SATA disks.
> I'm trying to have this work as a RAID-1 array. 
> Bios configuration has been done, using 128K chunk, and the kernel
> (2.6.20.7) sees perfectly /dev/mapper/isw_xxxxxxxx_RAID1
> 
> But, I'm facing two problems :
> 1 - If i try to create partitions on this device, it does fail (the 
>     values are not interpreted correctly)
> 
> 2 - To avoid 1), I stop the RAID array (dmraid -an), then I do create
>     exactly the same partition set on /dev/sda, and /dev/sdb, and
>     then I reactivate RAID (dmraid -ay).
>     This allows me to see all the /dev/mapper/isw_xxxxxxx_RAID1p1, p2, ...
>     But, running fsck -t ext2 /dev/mapper/isw_xxxxxxx_RAID1p1
>     ends in a lock when the partition is larger than 10Go (well, it is
>     Ok on the 10Go one, and it locks on the 100Go).
>     Not a real hardlock, I still can switch to a new VC, but it's not
>     more possible to start a new command or to stop fsck.
> 
> Should I do everything on the physical disks before activating RAID ?
> Is it a normal behavior ?
> 
> BTW, I also noticed that such a device doesn't support BLKRRPART ioctl...
> So it is possible that what I'm doing is wrong...
> 
> Any idea ?
> 

cc added.
