From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: pvmove error hanging LVM layer?
Date: Wed, 26 Sep 2012 18:57:01 +0200
Message-ID: <CAG2kNCwOrp-2RdLfX+eLodX2D92LkPaCWBpa9Mt5S5q6x4zxfA@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,
my system is RH EL 5.8 with kernel 2.6.18-308.8.2.el5.
device-mapper-1.02.67-2.el5
device-mapper-multipath-0.4.7-48.el5_8.1

I'm doing some tests for online moving of several multipath LUNs from
a storage array to another one, to understand pros&cons with other
possibilities.
I'm encountering a strange hang I think could be a bug itself, apart
from the approach itself that can be considered risky.
But know my question is only related to pvmove command itself in a
scenario where LVM activation filters are enabled.
I don't know if in my problem some components form rhcs take place or
if it would happen independently.
But in logs I don't see anything from cluster daemons so I presume
they are not related.

Scenario
- storage arrays SA1 and SA2
- VolGroup00 on internal disk
- PV1 is multipath device on SA1
- PV2 is multipath device on SA2
- VG_ORACS_APPL volume group composed by PV1 and PV2 and all occupied
PEs are on PV1
- VG_ORACS_APPL has LV_ORACS_APPL logical volume and file system
mounted on it (all on PV1)
- I want to pvmove from PV1 to PV2
- LVM is configured with activation filters enabled
  volume_list = [ "VolGroup00", "@iclnacs1" ]

I want to temporarily bypass activation filter adding my VG, but I
mistype (I miss the final L in vg name)

  volume_list = [ "VolGroup00", "@iclnacs1", "VG_ORACS_APP" ]

I try the pvmove command
time pvmove -i 30 /dev/mapper/mpacsappl /dev/mapper/mpnacsappl

and due to my error I get this

  Not activating VG_ORACS_APPL/pvmove0 since it does not pass activation filter.
  Temporary pvmove mirror activation failed.
  Unable to deactivate open VG_ORACS_APPL-pvmove0 (253:20)
  Unable to deactivate open VG_ORACS_APPL-LV_ORACS_APPL (253:9)
  libdevmapper exiting with 1 device(s) still suspended.

and the command exits
But now as a side effect, all LVM operations hang; also the ones
related to other Volume Groups.
I cannot run successfully neither a "sync" command or "shutdown -h" command.
I reproduced two times with different VGs
for example commands such as
vgs
strace -p of a command related to LVM hangs
all hangs

relevant lines in messages when this occurring are "only" related to
blocked processes:

Sep 26 17:36:41 noracs1 kernel: INFO: task kjournald:11281 blocked for
more than 120 seconds.
Sep 26 17:36:41 noracs1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 26 17:36:41 noracs1 kernel: kjournald     D ffffffff801566aa     0
11281    875         14739 11249 (L-TLB)
Sep 26 17:36:41 noracs1 kernel:  ffff811820addcf0 0000000000000046
ffff810c3d1537e0 ffff810ac66a61c0
Sep 26 17:36:41 noracs1 kernel:  000002ab85cb09de 000000000000000a
ffff810c3d1537e0 ffff810c3fe450c0
Sep 26 17:36:41 noracs1 kernel:  000002ae07c599d4 0000000000001b19
ffff810c3d1539c8 0000000e3f5bcab8
Sep 26 17:36:41 noracs1 kernel: Call Trace:
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff8006ecd9>] do_gettimeofday+0x40/0x90
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff8001558e>] sync_buffer+0x0/0x3f
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff800637de>] io_schedule+0x3f/0x67
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff800155c9>] sync_buffer+0x3b/0x3f
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff80063a0a>] __wait_on_bit+0x40/0x6e
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff8001558e>] sync_buffer+0x0/0x3f
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff80063aa4>]
out_of_line_wait_on_bit+0x6c/0x78
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff800a34d5>] wake_bit_function+0x0/0x23
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff88033a47>]
:jbd:journal_commit_transaction+0x559/0x10c2
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff8003d7be>] lock_timer_base+0x1b/0x3c
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff8004ad59>]
try_to_del_timer_sync+0x7f/0x88
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff880376a3>] :jbd:kjournald+0xc1/0x213
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff800a34a7>]
autoremove_wake_function+0x0/0x2e
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff880375e2>] :jbd:kjournald+0x0/0x213
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff800a328f>]
keventd_create_kthread+0x0/0xc4
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff80032632>] kthread+0xfe/0x132
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff8005dfb1>] child_rip+0xa/0x11
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff800a328f>]
keventd_create_kthread+0x0/0xc4
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff80032534>] kthread+0x0/0x132
Sep 26 17:36:41 noracs1 kernel:  [<ffffffff8005dfa7>] child_rip+0x0/0x11
Sep 26 17:36:41 noracs1 kernel:
Sep 26 17:38:41 noracs1 kernel: INFO: task kjournald:11281 blocked for
more than 120 seconds.
Sep 26 17:38:41 noracs1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 26 17:38:41 noracs1 kernel: kjournald     D ffffffff801566aa     0
11281    875         14739 11249 (L-TLB)
Sep 26 17:38:41 noracs1 kernel:  ffff811820addcf0 0000000000000046
ffff810c3d1537e0 ffff810ac66a61c0
Sep 26 17:38:41 noracs1 kernel:  000002ab85cb09de 000000000000000a
ffff810c3d1537e0 ffff810c3fe450c0
Sep 26 17:38:41 noracs1 kernel:  000002ae07c599d4 0000000000001b19
ffff810c3d1539c8 0000000e3f5bcab8
Sep 26 17:38:41 noracs1 kernel: Call Trace:
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff8006ecd9>] do_gettimeofday+0x40/0x90
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff8001558e>] sync_buffer+0x0/0x3f
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff800637de>] io_schedule+0x3f/0x67
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff800155c9>] sync_buffer+0x3b/0x3f
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff80063a0a>] __wait_on_bit+0x40/0x6e
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff8001558e>] sync_buffer+0x0/0x3f
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff80063aa4>]
out_of_line_wait_on_bit+0x6c/0x78
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff800a34d5>] wake_bit_function+0x0/0x23
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff88033a47>]
:jbd:journal_commit_transaction+0x559/0x10c2
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff8003d7be>] lock_timer_base+0x1b/0x3c
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff8004ad59>]
try_to_del_timer_sync+0x7f/0x88
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff880376a3>] :jbd:kjournald+0xc1/0x213
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff800a34a7>]
autoremove_wake_function+0x0/0x2e
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff880375e2>] :jbd:kjournald+0x0/0x213
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff800a328f>]
keventd_create_kthread+0x0/0xc4
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff80032632>] kthread+0xfe/0x132
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff8005dfb1>] child_rip+0xa/0x11
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff800a328f>]
keventd_create_kthread+0x0/0xc4
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff80032534>] kthread+0x0/0x132
Sep 26 17:38:41 noracs1 kernel:  [<ffffffff8005dfa7>] child_rip+0x0/0x11
Sep 26 17:38:41 noracs1 kernel:
Sep 26 17:38:41 noracs1 kernel: INFO: task exp:15654 blocked for more
than 120 seconds.
Sep 26 17:38:41 noracs1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 26 17:38:41 noracs1 kernel: exp           D ffffffff801566aa     0
15654  15259 15657               (NOTLB)
Sep 26 17:38:41 noracs1 kernel:  ffff8117ee20d6b8 0000000000000082
ffff81183dabe6b0 000000000cc7e000
Sep 26 17:38:41 noracs1 kernel:  ffff810acae16ac8 0000000000000007
ffff8118221217e0 ffff810c3fcec100
...

Note that if I don't mistype the activation filter, the pvmove command
works as expected and completes correctly.
Any suggestion? I can further debug if considered useful.

Could it help in any way to open a case with Red Hat in your opinion?

Thanks in advance,
Gianluca
