From: =?UTF-8?B?Qm/FoXRqYW4gxaBrdWZjYSBAIFRlb24uc2k=?= <bostjan@teon.si>
Subject: Bug in dm_any_congested?
Date: Tue, 10 Nov 2015 14:14:54 +0100
Message-ID: <CAEp_DRAcgXsjEPttRnVoDYo97ZeeQ6heiBZhGMkppOUxTnOxjA@mail.gmail.com>
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
List-Id: dm-devel.ids

Hi all,

(I am not sure if this is the right address for this bug, but dm_* is
the first function listed in trace)

this happened when I tried dd-ing LV, which resides on RAID10 sw
storage, to network via netcat. The actual user-visible manifestation
was segfault of dd that was used for reading.

On first request the error reported was "unable to handle kernel NULL
pointer dereference...", but on subsequent tries this changed to
"general protection fault", see below.

HW is a bit dated, but had no problems with it up to now, and SW raid
is used here. Kernel was 4.2.4.

Is this the right mlist for such bug?

Tnx,
b.

2015-11-10T02:03:26+00:00 ring kernel: [1251477.590992] BUG: unable to
handle kernel NULL pointer dereference at 00000000000004f0
2015-11-10T02:03:26+00:00 ring kernel: [1251477.591361] IP:
[<ffffffff818637c6>] dm_any_congested+0x26/0x50
2015-11-10T02:03:26+00:00 ring kernel: [1251477.591565] PGD 1afdc6067
PUD 5106e8067 PMD 0
2015-11-10T02:03:26+00:00 ring kernel: [1251477.591827] Oops: 0000 [#1] SMP
2015-11-10T02:03:26+00:00 ring kernel: [1251477.592057] CPU: 2 PID:
4277 Comm: dd Tainted: G        W       4.2.4 #1
2015-11-10T02:03:26+00:00 ring kernel: [1251477.592226] Hardware name:
HP ProLiant DL360 G5, BIOS P58 04/26/2010
2015-11-10T02:03:26+00:00 ring kernel: [1251477.592392] task:
ffff88080b41a400 ti: ffff8800caae8000 task.ti: ffff8800caae8000
2015-11-10T02:03:26+00:00 ring kernel: [1251477.592682] RIP:
0010:[<ffffffff818637c6>]  [<ffffffff818637c6>]
dm_any_congested+0x26/0x50
2015-11-10T02:03:26+00:00 ring kernel: [1251477.593007] RSP:
0018:ffff8800caaebcf0  EFLAGS: 00010206
2015-11-10T02:03:26+00:00 ring kernel: [1251477.593175] RAX:
0000000000000002 RBX: ffff88080ac30770 RCX: 6b7369440f000000
2015-11-10T02:03:26+00:00 ring kernel: [1251477.593465] RDX:
0000000000000000 RSI: 0000000000000002 RDI: ffff880805a34800
2015-11-10T02:03:26+00:00 ring kernel: [1251477.593753] RBP:
ffff8800caaebd28 R08: 0000000000000100 R09: 0000000000000100
2015-11-10T02:03:26+00:00 ring kernel: [1251477.594041] R10:
0000000000000200 R11: ffff8800caaebcf0 R12: 0000000000000000
2015-11-10T02:03:26+00:00 ring kernel: [1251477.594331] R13:
ffff88001b7b0d00 R14: ffffea00138c6340 R15: ffff8800caaebe80
2015-11-10T02:03:26+00:00 ring kernel: [1251477.594621] FS:
00007f1f99c91740(0000) GS:ffff88082fa80000(0000)
knlGS:0000000000000000
2015-11-10T02:03:26+00:00 ring kernel: [1251477.594911] CS:  0010 DS:
0000 ES: 0000 CR0: 000000008005003b
2015-11-10T02:03:26+00:00 ring kernel: [1251477.595076] CR2:
00000000000004f0 CR3: 00000002254cb000 CR4: 00000000000026e0
2015-11-10T02:03:26+00:00 ring kernel: [1251477.595365] Stack:
2015-11-10T02:03:26+00:00 ring kernel: [1251477.595524]
ffffffff81200798 ffff8800caaebd18 ffffffff8116a18e 0000000000000000
2015-11-10T02:03:26+00:00 ring kernel: [1251477.595943]
ffff88001b7b0da0 ffff88080ac308d8 ffff88001b7b0d00 ffff8800caaebd68
2015-11-10T02:03:26+00:00 ring kernel: [1251477.596362]
ffffffff8117629e 0000000000000292 0000000000000100 0000000000000100
2015-11-10T02:03:26+00:00 ring kernel: [1251477.596784] Call Trace:
2015-11-10T02:03:26+00:00 ring kernel: [1251477.596947]
[<ffffffff81200798>] ? inode_congested+0x58/0x120
2015-11-10T02:03:26+00:00 ring kernel: [1251477.597115]
[<ffffffff8116a18e>] ? find_get_entry+0x1e/0x80
2015-11-10T02:03:26+00:00 ring kernel: [1251477.597282]
[<ffffffff8117629e>] page_cache_async_readahead+0x4e/0x70
2015-11-10T02:03:26+00:00 ring kernel: [1251477.597450]
[<ffffffff8116b211>] generic_file_read_iter+0x391/0x5b0
2015-11-10T02:03:26+00:00 ring kernel: [1251477.597617]
[<ffffffff8120c677>] blkdev_read_iter+0x37/0x40
2015-11-10T02:03:26+00:00 ring kernel: [1251477.597784]
[<ffffffff811d7757>] __vfs_read+0xa7/0xd0
2015-11-10T02:03:26+00:00 ring kernel: [1251477.597949]
[<ffffffff811d7802>] vfs_read+0x82/0x130
2015-11-10T02:03:26+00:00 ring kernel: [1251477.598114]
[<ffffffff811d7c76>] SyS_read+0x46/0xb0
2015-11-10T02:03:26+00:00 ring kernel: [1251477.598280]
[<ffffffff81a7556e>] entry_SYSCALL_64_fastpath+0x12/0x71
2015-11-10T02:03:26+00:00 ring kernel: [1251477.598446] Code: 80 00 00
00 00 66 66 66 66 90 48 8b 97 28 01 00 00 89 f0 83 e2 01 75 38 48 8b
8f e8 00 00 00 48 85 c9 74 1c 48 8b 97 30 01 00 00 <48> 8b b2 f0 04 00
00 f7 c6 00 08 00 00 74 07 23 82 d0 01 00 00
2015-11-10T02:03:26+00:00 ring kernel: [1251477.600930] RIP
[<ffffffff818637c6>] dm_any_congested+0x26/0x50
2015-11-10T02:03:26+00:00 ring kernel: [1251477.600930]  RSP <ffff8800caaebcf0>
2015-11-10T02:03:26+00:00 ring kernel: [1251477.600930] CR2: 00000000000004f0
2015-11-10T02:03:26+00:00 ring kernel: [1251477.601561] ---[ end trace
17914a53c55dd503 ]---



Second and subsequent:
2015-11-10T02:04:46+00:00 ring kernel: [1251557.440486] general
protection fault: 0000 [#2] SMP
2015-11-10T02:04:46+00:00 ring kernel: [1251557.440732] CPU: 7 PID:
4806 Comm: dd Tainted: G      D W       4.2.4 #1
2015-11-10T02:04:46+00:00 ring kernel: [1251557.440904] Hardware name:
HP ProLiant DL360 G5, BIOS P58 04/26/2010
2015-11-10T02:04:46+00:00 ring kernel: [1251557.441071] task:
ffff88019b6c9800 ti: ffff88062c96c000 task.ti: ffff88062c96c000
2015-11-10T02:04:46+00:00 ring kernel: [1251557.441369] RIP:
0010:[<ffffffff818637c6>]  [<ffffffff818637c6>]
dm_any_congested+0x26/0x50
2015-11-10T02:04:46+00:00 ring kernel: [1251557.441699] RSP:
0018:ffff88062c96fcf0  EFLAGS: 00010206
2015-11-10T02:04:46+00:00 ring kernel: [1251557.441863] RAX:
0000000000000002 RBX: ffff88080ac30770 RCX: 6566667542207972
2015-11-10T02:04:46+00:00 ring kernel: [1251557.442152] RDX:
1b0a1bbb00007972 RSI: 0000000000000002 RDI: ffff880805a34800
2015-11-10T02:04:46+00:00 ring kernel: [1251557.442445] RBP:
ffff88062c96fd28 R08: 0000000000000100 R09: 0000000000000100
2015-11-10T02:04:46+00:00 ring kernel: [1251557.442733] R10:
0000000000000200 R11: ffff88062c96fcf0 R12: 0000000000000000
2015-11-10T02:04:46+00:00 ring kernel: [1251557.443021] R13:
ffff88080587ec00 R14: ffffea001699af40 R15: ffff88062c96fe80
2015-11-10T02:04:46+00:00 ring kernel: [1251557.443310] FS:
00007f0dc3de2740(0000) GS:ffff88082fbc0000(0000)
knlGS:0000000000000000
2015-11-10T02:04:46+00:00 ring kernel: [1251557.443603] CS:  0010 DS:
0000 ES: 0000 CR0: 000000008005003b
2015-11-10T02:04:46+00:00 ring kernel: [1251557.443768] CR2:
00000000b768a0a0 CR3: 00000000cab12000 CR4: 00000000000026e0
2015-11-10T02:04:46+00:00 ring kernel: [1251557.447111] Stack:
2015-11-10T02:04:46+00:00 ring kernel: [1251557.447269]
ffffffff81200798 ffff88062c96fd18 ffffffff8116a18e 0000000000000000
2015-11-10T02:04:46+00:00 ring kernel: [1251557.447688]
ffff88080587eca0 ffff88080ac308d8 ffff88080587ec00 ffff88062c96fd68
2015-11-10T02:04:46+00:00 ring kernel: [1251557.448109]
ffffffff8117629e 0000000000000001 0000000000000100 0000000000000100
2015-11-10T02:04:46+00:00 ring kernel: [1251557.448528] Call Trace:
2015-11-10T02:04:46+00:00 ring kernel: [1251557.448691]
[<ffffffff81200798>] ? inode_congested+0x58/0x120
2015-11-10T02:04:46+00:00 ring kernel: [1251557.448859]
[<ffffffff8116a18e>] ? find_get_entry+0x1e/0x80
2015-11-10T02:04:46+00:00 ring kernel: [1251557.449028]
[<ffffffff8117629e>] page_cache_async_readahead+0x4e/0x70
2015-11-10T02:04:46+00:00 ring kernel: [1251557.449195]
[<ffffffff8116b211>] generic_file_read_iter+0x391/0x5b0
2015-11-10T02:04:46+00:00 ring kernel: [1251557.449362]
[<ffffffff8120c677>] blkdev_read_iter+0x37/0x40
2015-11-10T02:04:46+00:00 ring kernel: [1251557.449530]
[<ffffffff811d7757>] __vfs_read+0xa7/0xd0
2015-11-10T02:04:46+00:00 ring kernel: [1251557.449695]
[<ffffffff811d7802>] vfs_read+0x82/0x130
2015-11-10T02:04:46+00:00 ring kernel: [1251557.449859]
[<ffffffff811d7c76>] SyS_read+0x46/0xb0
2015-11-10T02:04:46+00:00 ring kernel: [1251557.450030]
[<ffffffff81a7556e>] entry_SYSCALL_64_fastpath+0x12/0x71
2015-11-10T02:04:46+00:00 ring kernel: [1251557.450197] Code: 80 00 00
00 00 66 66 66 66 90 48 8b 97 28 01 00 00 89 f0 83 e2 01 75 38 48 8b
8f e8 00 00 00 48 85 c9 74 1c 48 8b 97 30 01 00 00 <48> 8b b2 f0 04 00
00 f7 c6 00 08 00 00 74 07 23 82 d0 01 00 00
2015-11-10T02:04:46+00:00 ring kernel: [1251557.450465] RIP
[<ffffffff818637c6>] dm_any_congested+0x26/0x50
2015-11-10T02:04:46+00:00 ring kernel: [1251557.450465]  RSP <ffff88062c96fcf0>
2015-11-10T02:04:46+00:00 ring kernel: [1251557.453232] ---[ end trace
17914a53c55dd504 ]---
