From: Damir Dezeljin <programing@mbss.org>
Subject: Re: Snapshot hang problem
Date: Thu, 23 Jun 2005 16:04:55 +0100 (GMT-1)
Message-ID: <Pine.LNX.4.44.0506231600490.5464-100000@Server.mbss.org>
References: <Pine.LNX.4.44.0506201408390.4911-100000@Server.mbss.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.44.0506201408390.4911-100000@Server.mbss.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-Devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi.

I have more details about the snapshot hang. Below you can find a kernel
stack track.

It seams that the two processes are in an dead-lock situation. The
affected processes are:
- dd (look for '[82038.781639] dd');
- lvcreate (look for '[82038.783758] lvcreate').

I guess following sitiation occoured because of an inconsistant locking
between various kernel parts.

Any idea / fix ;) / ... will be appreciated ;)


The stack trace:
----
[82038.778744] mingetty      S C1708040  2816  1112      1          1113
1110 (NOTLB)
[82038.778808] f777ae94 00000082 f7a11560 c1708040 00000000 00000000
00001c26 001d4536
[82038.778858]        00000000 f7a11698 f7a11560 c1708040 98737eda
00000005 f777a000 00000000
[82038.778926]        f777af20 986b184a 00000005 00000000 fffffff9
00000001 00000000 f63b8f60
[82038.778995] Call Trace:
[82038.779022]  [<c02e3015>] schedule_timeout+0x95/0xe0
[82038.779051]  [<c0203afd>] read_chan+0x36d/0x6d0
[82038.779080]  [<c01fe1e4>] tty_read+0x94/0xe0
[82038.779109]  [<c0162e61>] vfs_read+0xc1/0x150
[82038.779136]  [<c0163187>] sys_read+0x47/0x70
[82038.779165]  [<c0102dcf>] sysenter_past_esp+0x54/0x75
[82038.779194] mingetty      S C1708040  2840  1113      1          1934
1112 (NOTLB)
[82038.779263] f7134e94 00000086 00000000 c1708040 c17089e0 00000000
0000b728 001fe826
[82038.779312]        00000000 f7e74158 f7e74020 c1708040 98c95abb
00000005 f7134000 00000000
[82038.779380]        f7134f20 98c6728e 00000005 00000000 fffffff9
00000001 00000000 f72cc4c0
[82038.779447] Call Trace:
[82038.779475]  [<c02e3015>] schedule_timeout+0x95/0xe0
[82038.779507]  [<c0203afd>] read_chan+0x36d/0x6d0
[82038.779536]  [<c01fe1e4>] tty_read+0x94/0xe0
[82038.779563]  [<c0162e61>] vfs_read+0xc1/0x150
[82038.779590]  [<c0163187>] sys_read+0x47/0x70
[82038.779616]  [<c0102dcf>] sysenter_past_esp+0x54/0x75
[82038.779643] kjournald     S C1708040  2676  1934      1          2055
1113 (L-TLB)
[82038.779707] f3fc4f80 00000046 00000000 c1708040 c17089e0 f733c080
00000373 000db43d
[82038.779755]        00000000 f7b60158 f7b60020 c1708040 d93a215b
00004a91 f3fc4000 f7aabc64
[82038.779822]        00000003 d92d7d74 00004a91 f3fc4f80 c0133e1d
00000282 0000069a f7aabc00
[82038.779889] Call Trace:
[82038.779917]  [<c01b960e>] kjournald+0x22e/0x240
[82038.779947]  [<c0100f99>] kernel_thread_helper+0x5/0xc
[82038.779975] bash          S C17104F4  2356  1975   1105  2058
(NOTLB)
[82038.780037] f21d1f34 00000082 f7b80020 c17104f4 00004a9b 00000001
000051e1 0343e401
[82038.780089]        00000000 f707d158 f707d020 c1710040 87f4172b
00004a9b f21d1000 87f3e131
[82038.780153]        00004a9b 87ecc245 00004a9b f707d020 00000004
f21d1f34 f707d0dc 00000000
[82038.780216] Call Trace:
[82038.780243]  [<c0121820>] do_wait+0x280/0x3d0
[82038.780270]  [<c0121a2e>] sys_wait4+0x3e/0x40
[82038.780298]  [<c0121a55>] sys_waitpid+0x25/0x27
[82038.780328]  [<c0102dcf>] sysenter_past_esp+0x54/0x75
[82038.780355] bash          S C170807C  2620  2008   1107  2060
(NOTLB)
[82038.780419] f0075f34 00000086 f74e8020 c170807c 00004a9c 00000001
00005be7 033bc7fa
[82038.780470]        00000000 f7778698 f7778560 c1708040 650122b6
00004a9c f0075000 6500e5c2
[82038.780543]        00004a9c 64f960f9 00004a9c f7778560 00000004
f0075f34 f777861c 00000000
[82038.780611] Call Trace:
[82038.780639]  [<c0121820>] do_wait+0x280/0x3d0
[82038.780668]  [<c0121a2e>] sys_wait4+0x3e/0x40
[82038.780696]  [<c0121a55>] sys_waitpid+0x25/0x27
[82038.780724]  [<c0102dcf>] sysenter_past_esp+0x54/0x75
[82038.780753] kjournald     D C1708040  2640  2055      1
1934 (L-TLB)
[82038.780817] f5a8ce9c 00000046 00000000 c1708040 c17089e0 f71d33bc
0000038a 00214f36
[82038.780870]        00000000 f76ce698 f76ce560 c1708040 b1df3d50
00004a9c f5a8c000 f5a8ce84
[82038.780937]        c027a036 b1df106c 00004a9c f5a8ce98 c027c595
f76b1b00 c1708040 00000000
[82038.781003] Call Trace:
[82038.781032]  [<c02e2f08>] io_schedule+0x28/0x40
[82038.781060]  [<c01641c1>] sync_buffer+0x41/0x50
[82038.781090]  [<c02e3136>] __wait_on_bit+0x46/0x70
[82038.781119]  [<c02e31cf>] out_of_line_wait_on_bit+0x6f/0x80
[82038.781148]  [<c01b63f9>] journal_commit_transaction+0x4e9/0x1110
[82038.781179]  [<c01b94d0>] kjournald+0xf0/0x240
[82038.781207]  [<c0100f99>] kernel_thread_helper+0x5/0xc
[82038.781235] bash          S C1710040  2512  2058   1975  2059
(NOTLB)
[82038.781303] f4195f34 00000082 00000001 c1710040 c17109e0 00000001
000026d5 0036985d
[82038.781356]        00000000 f7b80158 f7b80020 c1710040 882baec3
00004a9b f4195000 00000000
[82038.781422]        f4195f24 8829bf8f 00004a9b f7b80020 00000004
f4195f34 f7b800dc f7e74560
[82038.781494] Call Trace:
[82038.781522]  [<c0121820>] do_wait+0x280/0x3d0
[82038.781553]  [<c0121a2e>] sys_wait4+0x3e/0x40
[82038.781582]  [<c0121a55>] sys_waitpid+0x25/0x27
[82038.781611]  [<c0102dcf>] sysenter_past_esp+0x54/0x75
[82038.781639] dd            D C1708040  2840  2059   2058
(NOTLB)
[82038.781705] f3ecfd68 00000086 00000000 c1708040 c17089e0 f3ecff50
000260db 00136672
[82038.781756]        00000000 f7e74698 f7e74560 c1708040 883b24cf
00004a9b f3ecf000 f3ecfd6c
[82038.781823]        00000006 8838cd8e 00004a9b f3ecfd68 c0133e1d
00000282 f7aabe00 c1703f20
[82038.781891] Call Trace:
[82038.781920]  [<c01b3f62>] do_get_write_access+0x372/0x5c0
[82038.781949]  [<c01b41de>] journal_get_write_access+0x2e/0x50
[82038.781980]  [<c01a992b>] ext3_orphan_add+0xeb/0x250
[82038.782009]  [<c01a6046>] ext3_setattr+0x1c6/0x240
[82038.782036]  [<c017ffb6>] notify_change+0x246/0x2d5
[82038.782065]  [<c0160f8c>] do_truncate+0x5c/0x80
[82038.783232]  [<c01736d5>] may_open+0x1a5/0x220
[82038.783260]  [<c01737eb>] open_namei+0x9b/0x6e0
[82038.783288]  [<c016200a>] filp_open+0x3a/0x60
[82038.783314]  [<c0162436>] sys_open+0x46/0x80
[82038.783342]  [<c0102dcf>] sysenter_past_esp+0x54/0x75
[82038.783372] bash          S C1708040  2372  2060   2008  2079
(NOTLB)
[82038.783438] f4671f34 00000082 00000000 c1708040 c17089e0 00000001
000041c6 00f36a74
[82038.783492]        00000000 f74e8158 f74e8020 c1708040 78f829f2
00004a9c f4671000 00000000
[82038.783555]        f4671f24 78e9a7fc 00004a9c f74e8020 00000004
f4671f34 f74e80dc f70c1560
[82038.783619] Call Trace:
[82038.783646]  [<c0121820>] do_wait+0x280/0x3d0
[82038.783676]  [<c0121a2e>] sys_wait4+0x3e/0x40
[82038.783704]  [<c0121a55>] sys_waitpid+0x25/0x27
[82038.783731]  [<c0102dcf>] sysenter_past_esp+0x54/0x75
[82038.783758] lvcreate      D C1708040  2480  2079   2060
(NOTLB)
[82038.783822] efebce40 00000082 00000000 c1708040 c17089e0 00000000
00052162 0f5d4ed1
[82038.783872]        00000000 f70c1698 f70c1560 c1708040 a1232701
00004a9c efebc000 efebce4c
[82038.783936]        f70fb894 a1166816 00004a9c 00000000 00000286
0000013b f70fb854 f70fb85c
[82038.784001] Call Trace:
[82038.784029]  [<c02e1cf5>] __down+0xd5/0x100
[82038.784058]  [<c02e1e42>] __down_failed+0xa/0x10
[82038.784087]  [<c0168128>] .text.lock.buffer+0x2e/0xa6
[82038.784118]  [<c027aa35>] __lock_fs+0x55/0xd0
[82038.784151]  [<c027ab9c>] dm_suspend+0x9c/0x240
[82038.784179]  [<c027e399>] do_suspend+0xf9/0x1a0
[82038.784209]  [<c027f98c>] ctl_ioctl+0xfc/0x150
[82038.784238]  [<c0176edb>] do_ioctl+0x8b/0xa0
[82038.784265]  [<c01770b0>] vfs_ioctl+0x60/0x210
[82038.784293]  [<c01772da>] sys_ioctl+0x7a/0x90
[82038.784322]  [<c0102dcf>] sysenter_past_esp+0x54/0x75
----

Regards,
Dezo
