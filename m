From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: Error writing to linear mapped device...
Date: Mon, 23 May 2005 15:47:08 -0500
Message-ID: <878e1639582aba3203fc7bdbf18367bf@redhat.com>
References: <5959EA4638D8734599AB75EAAFBB6FEF03B35717@mtv01ex04.mindtree.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5959EA4638D8734599AB75EAAFBB6FEF03B35717@mtv01ex04.mindtree.com>
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

I don't have a solid explanation, but I would liken it to having 
multiple processes writing to the same file at the same time - 
corruption ensues.  I don't think there is any level at which the two 
mounts could coordinate - they have separate block devices, separate 
caches, etc.  Even if you sync, who flushes first?  This would explain 
your mixed results.

I don't think you can prevent the two simultaneous mounts.  However, 
you should avoid doing this.

  brassow

On May 23, 2005, at 12:21 AM, Manu Tayal wrote:

> Hi All,
> I tried the following steps:
> 1) Set up a loopback device
> 	# dd if=/dev/zero of=/tmp/store1 bs=1024 seek=2047 count=1
> 	# losetup /dev/loop1 /tmp/store1
> 	# mke2fs /dev/loop1
> 	# mount /dev/loop1 /mnt/loopdev
>
> 2) Create a linearly mapped device for the loopback device
> 	# echo 0 $(blockdev --getsize /dev/loop1) linear /dev/loop1 0 |
> dmsetup create new
> 	# mount /dev/mapper/new /mnt/new
>
> Both the devices created and mounted now refer to the same physical 
> device.
>
> 3) Write to both the devices separately:
>       # touch /mnt/loopdev/a.txt
>       # touch /mnt/new/b.txt
>
> OBSERVATION:
> ===========
> 1) The file created in /mnt/loopdev is not visible under /mnt/new and
> vice-versa. Thought, it might be due to the buffers maintained by 
> devices.
> "sync" did not help in flushing.
> 2) On unmounting the devices and mounting it again gives unpredictable
> results:
> 	a. Sometimes, a.txt is visible at both the places, with b.txt missing
> at both places.
> 	b. Sometimes, b.txt is visible at both the places, with a.txt missing
> at both places.
> 	c. Sometimes, I get "Input/output" error in one of the mount points.
>
> Questions:
> =========
> 1) Can somebody explain the behavior?
> 2) Once a linear mapping is created for /dev/loop1 as /dev/mapper/new, 
> how
> can I prevent the user from using /dev/loop1 and always use 
> /dev/mapper/new
> for all the reads and writes?
> 3) What happens to all the open connections to files being used for
> /dev/loop1 after I have mapped it to /dev/mapper/new?
>
>
> Thanks and Regards,
> Manu.
>
> <disclaimer.txt>--
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
