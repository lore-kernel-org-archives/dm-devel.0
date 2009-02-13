From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: 2.6.28.2 & dm-snapshot or kcopyd Oops
Date: Fri, 13 Feb 2009 01:41:47 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902130138400.26381@hs20-bc2-1.build.redhat.com>
References: <200901231836184950432@163.com>,
	<Pine.LNX.4.64.0901231514590.9877@hs20-bc2-1.build.redhat.com>,
	<200901301800149019891@163.com>,
	<Pine.LNX.4.64.0901301533390.5744@hs20-bc2-1.build.redhat.com>,
	<200901311416111648168@163.com>,
	<Pine.LNX.4.64.0902031505180.28433@hs20-bc2-1.build.redhat.com>,
	<200902051113011850587@163.com>,
	<Pine.LNX.4.64.0902051749150.5515@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902052218040.5380@hs20-bc2-1.build.redhat.com>,
	<200902061924107769776@163.com>,
	<Pine.LNX.4.64.0902061815440.11986@hs20-bc2-1.build.redhat.com>,
	<200902072041046488539@163.com>,
	<Pine.LNX.4.64.0902090311340.28754@hs20-bc2-1.build.redhat.com>,
	<200902101305353713189@163.com>,
	<Pine.LNX.4.64.0902101832050.386@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902110552550.20020@hs20-bc2-1.build.redhat.com>
	<200902121131140773281@163.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200902121131140773281@163.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jacky Kim <jcy_2008@163.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi

Few more questions:
- do you write to the snapshots?
- do you create/delete snapshots while the crash happens?
- do all the snapshots have the same chunk size?
- how many snapshots do you have?

Mikulas

> Hi
> 
> With the two patches of yesterday, the latest debug infomation is as follow:
> 
> [  197.073630] ------------[ cut here ]------------
> [  197.073633] kernel BUG at drivers/md/dm-snap.c:405!
> [  197.073635] invalid opcode: 0000 [#1] SMP 
> [  197.073637] last sysfs file: /sys/devices/virtual/block/dm-6/dev
> [  197.073639] Modules linked in: iscsi_trgt arcmsr bonding e1000
> [  197.073642] 
> [  197.073645] Pid: 4268, comm: kcopyd Not tainted (2.6.28.2-dm #8) S5000PSL
> [  197.073647] EIP: 0060:[<c03c5da8>] EFLAGS: 00010246 CPU: 2
> [  197.073653] EIP is at free_pending_exception+0x88/0x90
> [  197.073654] EAX: c05a0ce8 EBX: f55449f0 ECX: 00000282 EDX: ef3056d0
> [  197.073656] ESI: f6c65bc0 EDI: 00000000 EBP: ef2a34e0 ESP: ef3d5ecc
> [  197.073657]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [  197.073659] Process kcopyd (pid: 4268, ti=ef3d4000 task=f6d77bc0 task.ti=ef3d4000)
> [  197.073660] Stack:
> [  197.073661]  f55449f0 00000000 c03c6918 f75fbf70 ef2843c8 f75fbec0 00000000 ef2409c0
> [  197.073665]  00000001 00000001 ef2a34e0 c03c82ca c03c6a20 002689a4 00000000 000030d8
> [  197.073668]  00000000 f75fbf2c ef2a34e0 f75fbec0 eeded3c0 c03c69e2 ef2a34e0 eeded418
> [  197.073672] Call Trace:
> [  197.073674]  [<c03c6918>] pending_complete+0x2d8/0x360
> [  197.073677]  [<c03c82ca>] persistent_commit+0x34a/0x380
> [  197.073679]  [<c03c6a20>] commit_callback+0x0/0x40
> [  197.073681]  [<c03c69e2>] copy_callback+0x42/0x80
> [  197.073683]  [<c03c69a0>] copy_callback+0x0/0x80
> [  197.073686]  [<c03c1858>] run_complete_job+0x108/0x140
> [  197.073688]  [<c03c119c>] process_jobs+0x4c/0xe0
> [  197.073690]  [<c03c1750>] run_complete_job+0x0/0x140
> [  197.073692]  [<c03c1230>] do_work+0x0/0x50
> [  197.073694]  [<c03c124e>] do_work+0x1e/0x50
> [  197.073696]  [<c012ef32>] run_workqueue+0x72/0x100
> [  197.073700]  [<c0132570>] prepare_to_wait+0x20/0x60
> [  197.073703]  [<c012f840>] worker_thread+0x0/0xb0
> [  197.073705]  [<c012f8b9>] worker_thread+0x79/0xb0
> [  197.073707]  [<c01323d0>] autoremove_wake_function+0x0/0x50
> [  197.073710]  [<c012f840>] worker_thread+0x0/0xb0
> [  197.073712]  [<c01320d2>] kthread+0x42/0x70
> [  197.073713]  [<c0132090>] kthread+0x0/0x70
> [  197.073715]  [<c0103eff>] kernel_thread_helper+0x7/0x18
> [  197.073718] Code: 04 89 42 04 89 10 c7 41 04 00 02 20 00 c7 43 40 00 01 10 00 fe 05 94 41 65 c0 8b 56 48 89 d8 e8 3f 30 d8 ff f0 ff 4e 4c 5b 5e c3 <0f> 0b eb fe 8d 74 26 00 55 89 c5 57 56 53 83 ec 0c 8b 75 30 8b 
> [  197.073737] EIP: [<c03c5da8>] free_pending_exception+0x88/0x90 SS:ESP 0068:ef3d5ecc
> [  197.073754] ---[ end trace beb1c34d6186bec5 ]---
> 
> Jacky Kim
> .
