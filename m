From: Nikolay Borisov <kernel@kyup.com>
Subject: Question about suspending a device
Date: Thu, 28 May 2015 16:06:12 +0300
Message-ID: <556712C4.3010704@kyup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: mm@1h.com
List-Id: dm-devel.ids

Hello,

I'm currently working on a dm target which supports the ability to
resize its internal data structures. In order to do that what I do is
the following sequence of operations. In my message handler I have the
following operations sequence:

dm_internal_suspend_noflush(dm_table_get_md(ti->table))

drain_workqueue(my_work_queue)

//doo necessary work to resize the internal
//metadata


dm_internals_resume(dm_table_get_md(ti->table))


My question is whether I'm invoking the correct dm functions to suspend
my device so that while I'm doing my resize no bios are being accepted.
Currently what I'm observing is that my code locks inside
dm_internal_suspend_flush. Here is a backtrace of my dmsetup command:

PID: 6232   TASK: ffff8808165b9300  CPU: 5   COMMAND: "dmsetup"
 #0 [ffff880858a97940] __schedule+0x3fd at ffffffff815e0f1d
 #1 [ffff880858a979a0] schedule+0x3e at ffffffff815e15ae
 #2 [ffff880858a979c0] schedule_timeout+0x195 at ffffffff815e6485
 #3 [ffff880858a97a80] wait_for_completion+0xa9 at ffffffff815e28a9
 #4 [ffff880858a97ae0] __synchronize_srcu+0x11d at ffffffff810b2d7d
 #5 [ffff880858a97b80] synchronize_srcu+0x1d at ffffffff810b2e1d
 #6 [ffff880858a97b90] __dm_suspend+0x62 at ffffffff814accd2
 #7 [ffff880858a97bd0] dm_internal_suspend_noflush+0x8c at ffffffff814acedc
 #8 [ffff880858a97c00] dm_dedup_extend+0xb2 at ffffffffa02db192 [dm_dedup]
 #9 [ffff880858a97c60] dm_dedup_message_fn+0xf7 at ffffffffa02db357
[dm_dedup]
#10 [ffff880858a97ca0] target_message+0x28d at ffffffff814b4acd
#11 [ffff880858a97d10] ctl_ioctl+0x1dc at ffffffff814b68fc
#12 [ffff880858a97ed0] dm_ctl_ioctl+0x13 at ffffffff814b6a23
#13 [ffff880858a97ee0] do_vfs_ioctl+0x85 at ffffffff811c2785
#14 [ffff880858a97f30] sys_ioctl+0xa1 at ffffffff811c2ad1
#15 [ffff880858a97f80] system_call_fastpath+0x12 at ffffffff815e7e89
    RIP: 00007ff94d7ce8c7  RSP: 00007fffd5e5fed8  RFLAGS: 00010206
    RAX: ffffffffffffffda  RBX: ffffffff815e7e89  RCX: 0000000000000000
    RDX: 00007ff94fad7120  RSI: 00000000c138fd0e  RDI: 0000000000000003
    RBP: 00007ff94dabe374   R8: 00007ff94dabed90   R9: 00007fffd5e5fb50
    R10: 00007ff94dabe374  R11: 0000000000000246  R12: 00007ff94fad71d0
    R13: 00007ff94fad7150  R14: 00007ff94fad7120  R15: 00007ff94dabe374
    ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b

Inside __dm_suspend the only srcu is this:
synchronize_srcu(&md->io_barrier); But I have no idea where the
io_barrier is being used from. I have also enabled lockdep in case I'm
doing any lock violations but this is not the case.


Regards,
Nikolay
