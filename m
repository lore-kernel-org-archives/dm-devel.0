From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Kernel oops with dm-cache
Date: Sun, 8 Dec 2013 11:59:30 +0100
Message-ID: <20131208105930.GA3763@sesse.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi,

I woke up to my machine being crashed during the night; it complained about
the CPU being hung, but looking a bit closer in the CPU backtraces, it seems
that one of them had oopsed. I only have parts of this (it's salvaged from
the serial console), but hopefully it will help someone track it down:

[80844.094803] NMI backtrace for cpu 10
[80844.098596] CPU: 10 PID: 0 Comm: swapper/10 Tainted: G      D      3.13.0-rc3 #1
[80844.106397] Hardware name: Supermicro X8DTL/X8DTL, BIOS 2.1a       12/30/2011
[80844.113744] task: ffff880623cec470 ti: ffff880623cf8000 task.ti: ffff880623cf8000
[80844.121639] RIP: 0010:[<ffffffff811eb256>]  [<ffffffff811eb256>] intel_idle+0xa9/0xcd
[80844.129913] RSP: 0018:ffff880623cf9df8  EFLAGS: 00000046
[80844.135439] RAX: 0000000000000010 RBX: 0000000000000004 RCX: 0000000000000001
[80844.142785] RDX: 0000000000000000 RSI: ffff880623cf9fd8 RDI: ffffffff817644f8
[80844.150131] RBP: ffff880623cf9e28 R08: 0000000000000008 R09: 00000000000003df
[80844.157471] R10: 0000000000001255 R11: 0000000000001255 R12: 0000000000000003
[80844.164819] R13: 0000000000000010 R14: 0000000000000002 R15: 000000000000000a
[80844.172165] FS:  0000000000000000(0000) GS:ffff880627340000(0000) knlGS:0000000000000000
[80844.180663] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[80844.186619] CR2: 00007fac73f82000 CR3: 00000000015d3000 CR4: 00000000000007e0
[80844.193964] Stack:
[80844.196184]  ffff880623cf9e28 0000000a8108293e ffff880627358d00 ffffffff81605890
[80844.204079]  0000497bd7b9735d ffffffff81605770 ffff880623cf9e88 ffffffff812c3664
[80844.211971]  0000000000000003 ffffffff81605770 0000000000000000 00000000000e5afa
[80844.219874] Call Trace:
[80844.222531]  [<ffffffff812c3664>] cpuidle_enter_state+0x3a/0xac
[80844.228656]  [<ffffffff812c37d1>] cpuidle_idle_call+0xfb/0x1a0
[80844.234702]  [<ffffffff8100916e>] arch_cpu_idle+0x9/0x18
[80844.24020x64/0x66
[80844.474220]  [<ffffffff8106b247>] ? put_prev_task_fair+0x7f/0x2a8
[80844.480524]  [<ffffffff81069ebb>] ? update_curr+0x81/0x130
[80844.486219]  [<ffffffff811bf5cb>] ? number.isra.1+0x128/0x238
[80844.492181]  [<ffffffff813acaa7>] do_page_fault+0x9/0xb
[80844.497618]  [<ffffffff813a9ee2>] page_fault+0x22/0x30
[80844.502963]  [<ffffffff81059eb8>] ? kthread_data+0xc/0x11
[80844.508576]  [<ffffffff810554bd>] ? wq_worker_sleeping+0xe/0x85
[80844.514703]  [<ffffffff813a61bd>] __schedule+0x154/0x8eb
[80844.520231]  [<ffffffff811a505b>] ? put_io_context+0x5c/0x82
[80844.526104]  [<ffffffff810fc245>] ? kmem_cache_free+0xe9/0x127
[80844.532150]  [<ffffffff811a505b>] ? put_io_context+0x5c/0x82
[80844.538019]  [<ffffffff811a512e>] ? put_io_context_active+0x99/0xa2
[80844.544494]  [<ffffffff813a69f4>] schedule+0x6a/0x6c
[80844.549668]  [<ffffffff81041fcb>] do_exit+0x869/0x8c5
[80844.554938]  [<ffffffff813aa859>] oops_end+0x7c/0x81
[80844.560114]  [<ffffffff81004a32>] die+0x55/0x5f
[80844.564856]  [<ffffffff813aa42d>] do_general_protection+0x91/0x139
[80844.571244]  [<ffffffff813a9e82>] general_protection+0x22/0x30
[80844.577294]  [<ffffffffa02d87d4>] ? metadata_ll_load_ie+0x10/0x21 [dm_persistent_data]
[80844.585615]  [<ffffffffa02d8ed4>] ? sm_ll_lookup_bitmap+0x2e/0x7d [dm_persistent_data]
[80844.593953]  [<ffffffff813a859b>] ? mutex_unlock+0x9/0xb
[80844.599479]  [<ffffffffa02cd0f7>] ? dm_bufio_unlock+0x9/0xb [dm_bufio]
[80844.606225]  [<ffffffffa02d9c18>] sm_metadata_count_is_more_than[80845.321353]  ffff880623d09e28 0000000e8108293e ffff8806273d8d00 ffffffff816058e8
[80845.329238]  0000497c8ed44ca6 ffffffff81605770 ffff880623d09e88 ffffffff812c3664
[80845.337132]  0000000000000004 ffffffff81605770 0000000000000000 00000000000e838a
[80845.345033] Call Trace:
[80845.347692]  [<ffffffff812c3664>] cpuidle_enter_state+0x3a/0xac
[80845.353816]  [<ffffffff812c37d1>] cpuidle_idle_call+0xfb/0x1a0
[80845.359863]  [<ffffffff8100916e>] arch_cpu_idle+0x9/0x18
[80845.365385]  [<ffffffff8107982f>] cpu_startup_entry+0x117/0x1c8
[80845.371517]  [<ffffffff8107971e>] ? cpu_startup_entry+0x6/0x1c8
[80845.377647]  [<ffffffff81023597>] start_secondary+0x1b2/0x1b7
[80845.383608] Code: 86 38 e0 ff ff a8 08 75 22 48 8d 41 10 31 d2 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <85> 1d ac a8 41 00 75 0e 48 8d 75 dc bf 05 00 00 00 e8 b9 c6 e9

/* Steinar */
-- 
Homepage: http://www.sesse.net/
