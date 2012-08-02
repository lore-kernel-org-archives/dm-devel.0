From: Karandeep Chahal <kchahal@ddn.com>
Subject: multipath bug
Date: Thu, 2 Aug 2012 10:42:25 -0400
Message-ID: <501A91D1.3060801@ddn.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
List-Id: dm-devel.ids

Hello,

I have been fighting with a RHEL 6.2 fail over problem I have hit during 
rolling upgrades, and I was wondering if anyone else has seen this. On 
losing IO paths the initiator locks up (ssh locks up etc), I see the 
following in syslog:

Aug  1 15:10:15 ashe kernel: INFO: task simpled:15450 blocked for more 
than 120 seconds.
Aug  1 15:10:15 ashe kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  1 15:10:15 ashe kernel: simpled       D 0000000000000007     0 
15450  15424 0x00000080
Aug  1 15:10:15 ashe kernel: ffff880405589a98 0000000000000082 
0000000000000000 ffffffffa00041fc
Aug  1 15:10:15 ashe kernel: ffff880406696378 ffff880409fb4400 
0000000000000001 000000000000000c
Aug  1 15:10:15 ashe kernel: ffff880405f93058 ffff880405589fd8 
000000000000fb88 ffff880405f93058
Aug  1 15:10:15 ashe kernel: Call Trace:
Aug  1 15:10:15 ashe kernel: [<ffffffffa00041fc>] ? 
dm_table_unplug_all+0x5c/0x100 [dm_mod]
Aug  1 15:10:15 ashe kernel: [<ffffffff814fe0f3>] io_schedule+0x73/0xc0
Aug  1 15:10:15 ashe kernel: [<ffffffff811b676e>] 
__blockdev_direct_IO_newtrunc+0x6fe/0xb90
Aug  1 15:10:15 ashe kernel: [<ffffffff811b6c5e>] 
__blockdev_direct_IO+0x5e/0xd0
Aug  1 15:10:15 ashe kernel: [<ffffffff811b3510>] ? 
blkdev_get_blocks+0x0/0xc0
Aug  1 15:10:15 ashe kernel: [<ffffffff811b4377>] blkdev_direct_IO+0x57/0x60
Aug  1 15:10:15 ashe kernel: [<ffffffff811b3510>] ? 
blkdev_get_blocks+0x0/0xc0
Aug  1 15:10:15 ashe kernel: [<ffffffff81114e62>] 
generic_file_direct_write+0xc2/0x190
Aug  1 15:10:15 ashe kernel: [<ffffffff81116675>] 
__generic_file_aio_write+0x345/0x480
Aug  1 15:10:15 ashe kernel: [<ffffffff811b4e00>] ? blkdev_open+0x0/0xc0
Aug  1 15:10:15 ashe kernel: [<ffffffff811b3b0c>] blkdev_aio_write+0x3c/0xa0
Aug  1 15:10:15 ashe kernel: [<ffffffff8117ae9a>] do_sync_write+0xfa/0x140
Aug  1 15:10:15 ashe kernel: [<ffffffff8118c2f0>] ? do_filp_open+0x780/0xd60
Aug  1 15:10:15 ashe kernel: [<ffffffff810920d0>] ? 
autoremove_wake_function+0x0/0x40
Aug  1 15:10:15 ashe kernel: [<ffffffff81213266>] ? 
security_file_permission+0x16/0x20
Aug  1 15:10:15 ashe kernel: [<ffffffff8117b198>] vfs_write+0xb8/0x1a0
Aug  1 15:10:15 ashe kernel: [<ffffffff810d6b12>] ? 
audit_syscall_entry+0x272/0x2a0
Aug  1 15:10:15 ashe kernel: [<ffffffff8117bbb1>] sys_write+0x51/0x90
Aug  1 15:10:15 ashe kernel: [<ffffffff8100b0f2>] 
system_call_fastpath+0x16/0x1b
Aug  1 15:12:02 ashe init: tty (/dev/tty1) main process (2774) killed by 
TERM signal
Aug  1 15:12:03 ashe avahi-daemon[2291]: Got SIGTERM, quitting.

I have updated the following packages to the latest available from 
RedHat but the problem still presists:

device-mapper-1.02.74-10.el6.x86_64
device-mapper-multipath-0.4.9-56.el6_3.1.x86_64
kernel-2.6.32-279.2.1.el6.x86_64
lvm2-2.02.95-10.el6.x86_64

Does anyone have any suggestions/workarounds? I am looking at the source 
myself but I am not familiar with dm.

Please advise.
Karan
