From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: a deadlock bug in the kernel-side device mapper code
Date: Fri, 06 Nov 2009 09:24:23 +0900
Message-ID: <4AF36CB7.5030809@ct.jp.nec.com>
References: <4AF2D176.4010000@actcom.co.il>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AF2D176.4010000@actcom.co.il>
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

Hi,

On 11/05/2009 10:21 PM +0900, guy keren wrote:
> 
> Hi,
> 
> we encountered a deadlock inside the kernel part of the device-mapper
> code. it was found in a CentOS 5.3 system's kernel - but from looking at
> the code of kernel 2.6.31 - the same bug is still in there.
> 
> below is the stack trace of the self-deadlocking code. this is one of
> the threads of multipathd, that attempts to remove a dm device using a
> ioctl to the dm driver:
> 
> crash> bt 22619
> PID: 22619  TASK: ffff8106521247e0  CPU: 3   COMMAND: "multipathd"
>  #0 [ffff8106298dfb48] schedule at ffffffff80063035
>  #1 [ffff8106298dfc20] __down_read at ffffffff8006475d
>  #2 [ffff8106298dfc60] dm_copy_name_and_uuid at ffffffff8824f740
>  #3 [ffff8106298dfc90] dm_send_uevents at ffffffff88252685
>  #4 [ffff8106298dfcd0] event_callback at ffffffff8824c678
>  #5 [ffff8106298dfd00] dm_table_event at ffffffff8824dd01
>  #6 [ffff8106298dfd10] __hash_remove at ffffffff882507ad
>  #7 [ffff8106298dfd30] dev_remove at ffffffff88250865
>  #8 [ffff8106298dfd60] ctl_ioctl at ffffffff88250d80
>  #9 [ffff8106298dfee0] do_ioctl at ffffffff800418c4
> #10 [ffff8106298dff00] vfs_ioctl at ffffffff8002fab9
> #11 [ffff8106298dff40] sys_ioctl at ffffffff8004bdaf
> #12 [ffff8106298dff80] tracesys at ffffffff8005d28d (via system_call)
>     RIP: 00000039deecbb47  RSP: 0000000041e35bb8  RFLAGS: 00000246
>     RAX: ffffffffffffffda  RBX: ffffffff8005d28d  RCX: ffffffffffffffff
>     RDX: 000000001b9a7ac0  RSI: 00000000c138fd04  RDI: 0000000000000007
>     RBP: 0000000000000000   R8: 00000039df211e45   R9: 000000001b9a7af0
>     R10: 00000039df211d59  R11: 0000000000000246  R12: 00000039df211e23
>     R13: 0000000000000000  R14: 00000039df211d59  R15: 0000000000000000
>     ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b
> 
> (note: the crash was taken using kdump).
> 
> the problem appears to be that the function dm_remove in file
> drivers/md/dm-ioctl.c is locking the _hash_lock rw semaphore for write
> (down_write(&_hash_lock);), and then later in the call chain, the
> function dm_copy_name_and_uuid (in the same source file) attempts to
> lock the same semaphore for read. since the semaphore is not recursive -
> there is a deadlock. naturally, when this happens, any command trying to
> access those data structures (dmsetup, multipath, etc) block as well.

Right, it's a known problem, and it has not been fixed yet.


> note: we've encountered this deadlock twice in the past week - no idea
> if we saw it in the past or not.

This one has been there since the commit below:
---------------------------------------------------------------------
    commit 7a8c3d3b92883798e4ead21dd48c16db0ec0ff6f
    Author: Mike Anderson <andmike@linux.vnet.ibm.com>
    Date:   Fri Oct 19 22:48:01 2007 +0100

        dm: uevent generate events

        This patch adds support for the dm_path_event dm_send_event
        functions which create and send udev events.
---------------------------------------------------------------------

See below for details:
    http://marc.info/?l=dm-devel&m=125412382315993&w=2

Thanks,
Kiyoshi Ueda
