From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: 4.5-rc1 multipath regression
Date: Fri, 29 Jan 2016 10:42:01 -0800
Message-ID: <56ABB279.5020609@sandisk.com>
References: <56AAA6AE.1060802@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56AAA6AE.1060802@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 01/28/2016 03:39 PM, Bart Van Assche wrote:
> There is a regression in the 4.5-rc1 kernel with regard to multipath
> setup. On my SRP I usually use for these tests after a few minutes a
> kernel crash occurs and the console freezes. A screenshot has been attached.

(replying to my own e-mail)

Before that crash was triggered, the following appeared in the system log, a
message I had not yet seen during tests with previous kernel versions:

INFO: task multipathd:3889 blocked for more than 120 seconds.
     Tainted: G            E   4.5.0-rc1+ #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
multipathd      D ffff88045266b828     0  3889      1 0x00000000
ffff88045266b828 ffffffff81a0f500 ffff8804254d9f80 ffffffff82145850
ffffffff810a518d ffffffff82132890 ffff8804254dabc8 ffff8804254d9f80
0000000000000002 ffff880400000001 0000000000000002 ffff880400000000
Call Trace:
[<ffffffff8152ea42>] schedule+0x42/0xb0
[<ffffffff81532c9f>] schedule_timeout+0x17f/0x1d0
[<ffffffff8152fae5>] wait_for_completion+0xe5/0x120
[<ffffffff81070736>] flush_workqueue+0x256/0x6e0
[<ffffffffa0352804>] flush_multipath_work+0x34/0x80 [dm_multipath]
[<ffffffffa035287f>] multipath_postsuspend+0x2f/0x50 [dm_multipath]
[<ffffffffa000580b>] suspend_targets+0x3b/0x90 [dm_mod]
[<ffffffffa00058b3>] dm_table_postsuspend_targets+0x13/0x20 [dm_mod]
[<ffffffffa00042f4>] dm_suspend+0xf4/0x130 [dm_mod]
[<ffffffffa0009d5f>] do_resume+0x15f/0x1d0 [dm_mod]
[<ffffffffa0009e5a>] dev_suspend+0x8a/0xc0 [dm_mod]
[<ffffffffa000ad3c>] ctl_ioctl+0x18c/0x280 [dm_mod]
[<ffffffffa000ae3e>] dm_ctl_ioctl+0xe/0x20 [dm_mod]
[<ffffffff81196903>] vfs_ioctl+0x13/0x30
[<ffffffff811972e2>] do_vfs_ioctl+0x82/0x420
[<ffffffff811976ce>] SyS_ioctl+0x4e/0x80
[<ffffffff81534197>] entry_SYSCALL_64_fastpath+0x12/0x6f
2 locks held by multipathd/3889:
#0:  (&md->suspend_lock/1){+.+...}, at: [<ffffffffa0004232>] dm_suspend+0x32/0x130 [dm_mod]
#1:  (&m->work_mutex){+.+.+.}, at: [<ffffffffa0352877>] multipath_postsuspend+0x27/0x50 [dm_multipath]
