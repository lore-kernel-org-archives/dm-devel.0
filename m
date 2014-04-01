From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [PATCH 8/9] dm crypt: offload writes to thread
Date: Tue, 01 Apr 2014 18:27:08 +0200
Message-ID: <533AE8DC.5080004@redhat.com>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
	<1396037476-26595-9-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1396037476-26595-9-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On 03/28/2014 09:11 PM, Mike Snitzer wrote:
> From: Mikulas Patocka <mpatocka@redhat.com>
>
> Submitting write bios directly in the encryption thread caused serious
> performance degradation.  On a multiprocessor machine, encryption requests
> finish in a different order than they were submitted.  Consequently, write
> requests would be submitted in a different order and it could cause severe
> performance degradation.
 > (...)

Hi,

originally I planed to post result of performance testing but 
unfortunately I crashed the test machine several times with <in_subject> 
patch applied and onward:

The test set up looks following:

the base is kernel-3.14-rc8 with applied "[PATCH 2/9] block: use kmalloc 
alignment for bio slab"

On top of base I compiled various dm-crypt modules:

<no_patch>		= raw 3.14-rc8 dm-crypt module
<no_percpu>		= "[PATCH 1/9]"
<per_bio_data>		= <no_percpu> + "[PATCH 3/9]"
<unbound>		= <per_bio_data> + "[PATCH 4/9]"
<dont_allocate_wfix>	= <unbound> + "[PATCH 5/9]" + "[PATCH 6/9]"
<remove_io_pool>	= <dont_allocate_wfix> + "[PATCH 7/9]"
<offload>		= <remove_io_pool> + "[PATCH 8/9]"
<sort>			= <offload> + "[PATCH 9/9]"

All the modules above went through tests that are available here 
(originally write by Milan Broz, I have made only few modifications):

http://okozina.fedorapeople.org/dmcrypt-tests.tar.xz

All tests passed on single device tests with "test_disk" script

Testing md raid5 backing device ("test_md" script) fails in test 
2/dmcrypt-all-verify.sh. The failure occurs after it pushes data through 
dm-crypt device using "null" cipher:

dmsetup create crypt --table "0 </dev/md0 bsize> crypt 
cipher_null-ecb-null - 0 /dev/md0 0"

steps to reproduce is to load module with <offload> or <sort> dm-crypt 
modules:

create md raid5 over 3 devices:

1) mdadm -C -l 5 -n 3 -c 64 --assume-clean /dev/md0 /dev/sd[xyz]
2) run 2/dmcrypt-all-verify.sh

if CONFIG_DEBUG_VM is enabled, it ended with:

XFS (dm-3): Mounting Filesystem
[ 1278.005956] XFS (dm-3): Ending clean mount
[ 1346.330472] device-mapper: crypt: bio_add_page failed for page 10: 
the underlying device has stricter limits t
[ 1475.049400] page:ffffea0004272600 count:0 mapcount:0 mapping: 
   (null) index:0x2
[ 1475.057475] page flags: 0x2fffff80000000()
[ 1475.061619] ------------[ cut here ]------------
[ 1475.062313] kernel BUG at include/linux/mm.h:307!
[ 1475.062313] invalid opcode: 0000 [#1] SMP
[ 1475.062313] Modules linked in: crypto_null dm_crypt(F) raid456 
async_raid6_recov async_memcpy async_pq raid6_]
[ 1475.062313] CPU: 2 PID: 24851 Comm: dmsetup Tainted: GF 
3.14.0-rc8 #3
[ 1475.062313] Hardware name: Dell Computer Corporation PowerEdge 
2800/0C8306, BIOS A07 04/25/2008
[ 1475.062313] task: ffff8801197cea80 ti: ffff8801189a6000 task.ti: 
ffff8801189a6000
[ 1475.062313] RIP: 0010:[<ffffffff81167748>]  [<ffffffff81167748>] 
__free_pages+0x68/0x70
[ 1475.062313] RSP: 0018:ffff8801189a7c08  EFLAGS: 00010246
[ 1475.062313] RAX: 0000000000000000 RBX: ffffea0004272600 RCX: 
0000000000000000
[ 1475.062313] RDX: 0000000000000000 RSI: ffff88011fc8e6c8 RDI: 
000000000109c980
[ 1475.062313] RBP: ffff8801189a7c18 R08: 0000000000000086 R09: 
0000000000000425
[ 1475.062313] R10: 0000000000000424 R11: 0000000000000003 R12: 
ffff880118afcc70
[ 1475.062313] R13: ffff880118afcc68 R14: ffff8800d712b400 R15: 
0000000000000000
[ 1475.062313] FS:  00007f73b2f9f880(0000) GS:ffff88011fc80000(0000) 
knlGS:0000000000000000
[ 1475.062313] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1475.062313] CR2: 00007f238669b008 CR3: 0000000119288000 CR4: 
00000000000007e0
[ 1475.062313] Stack:
[ 1475.062313]  ffff880118afcc60 ffff880118afcc70 ffff8801189a7c28 
ffffffff811617ae
[ 1475.062313]  ffff8801189a7c50 ffffffff81161815 ffff8800d7129a00 
ffffc90010753040
[ 1475.062313]  ffff8800d712b400 ffff8801189a7c70 ffffffffa054101d 
0000000000000000
[ 1475.062313] Call Trace:
[ 1475.062313]  [<ffffffff811617ae>] mempool_free_pages+0xe/0x10
[ 1475.062313]  [<ffffffff81161815>] mempool_destroy+0x35/0x60
[ 1475.062313]  [<ffffffffa054101d>] crypt_dtr+0x7d/0xe0 [dm_crypt]
[ 1475.062313]  [<ffffffffa0004c38>] dm_table_destroy+0x68/0xf0 [dm_mod]
[ 1475.062313]  [<ffffffffa00020d4>] __dm_destroy+0xf4/0x260 [dm_mod]
[ 1475.062313]  [<ffffffffa0002fa3>] dm_destroy+0x13/0x20 [dm_mod]
[ 1475.062313]  [<ffffffffa0008a3e>] dev_remove+0x11e/0x180 [dm_mod]
[ 1475.062313]  [<ffffffffa0008920>] ? dev_suspend+0x250/0x250 [dm_mod]
[ 1475.062313]  [<ffffffffa0009115>] ctl_ioctl+0x255/0x500 [dm_mod]
[ 1475.062313]  [<ffffffffa00093d3>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
[ 1475.062313]  [<ffffffff811e9ac0>] do_vfs_ioctl+0x2e0/0x4a0
[ 1475.062313]  [<ffffffff8127fe96>] ? file_has_perm+0xa6/0xb0
[ 1475.062313]  [<ffffffff811e9d01>] SyS_ioctl+0x81/0xa0
[ 1475.062313]  [<ffffffff81639369>] system_call_fastpath+0x16/0x1b
[ 1475.062313] Code: de 44 89 e6 48 89 df e8 f7 f2 ff ff 5b 41 5c 5d c3 
66 90 48 89 df 31 f6 e8 c6 fd ff ff 5b 4
[ 1475.062313] RIP  [<ffffffff81167748>] __free_pages+0x68/0x70
[ 1475.062313]  RSP <ffff8801189a7c08>
[ 1475.377375] ---[ end trace 9960ec06a734b827 ]---
[ 1475.382019] Kernel panic - not syncing: Fatal exception
[ 1475.383013] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation 
range: 0xffffffff80000000-0xffffffff9fffff)
[ 1475.383013] drm_kms_helper: panic occurred, switching back to text 
console
[ 1475.404333] ------------[ cut here ]------------
[ 1475.405330] WARNING: CPU: 2 PID: 24851 at arch/x86/kernel/smp.c:124 
native_smp_send_reschedule+0x5d/0x60()
[ 1475.405330] Modules linked in: crypto_null dm_crypt(F) raid456 
async_raid6_recov async_memcpy async_pq raid6_]
[ 1475.405330] CPU: 2 PID: 24851 Comm: dmsetup Tainted: GF     D 
3.14.0-rc8 #3
[ 1475.405330] Hardware name: Dell Computer Corporation PowerEdge 
2800/0C8306, BIOS A07 04/25/2008
[ 1475.405330]  0000000000000000 0000000021407093 ffff88011fc83d90 
ffffffff816281f1
[ 1475.405330]  0000000000000000 ffff88011fc83dc8 ffffffff8106fc7d 
0000000000000000
[ 1475.405330]  ffff88011fc146c0 0000000000000002 0000000000000002 
000000000000e5c8
[ 1475.405330] Call Trace:
[ 1475.405330]  <IRQ>  [<ffffffff816281f1>] dump_stack+0x45/0x56
[ 1475.405330]  [<ffffffff8106fc7d>] warn_slowpath_common+0x7d/0xa0
[ 1475.405330]  [<ffffffff8106fdaa>] warn_slowpath_null+0x1a/0x20
[ 1475.405330]  [<ffffffff81047add>] native_smp_send_reschedule+0x5d/0x60
[ 1475.405330]  [<ffffffff810b4634>] trigger_load_balance+0x144/0x1b0
[ 1475.405330]  [<ffffffff810a519f>] scheduler_tick+0x9f/0xe0
[ 1475.405330]  [<ffffffff8107ef00>] update_process_times+0x60/0x70
[ 1475.405330]  [<ffffffff810e2375>] tick_sched_handle.isra.17+0x25/0x60
[ 1475.405330]  [<ffffffff810e23f1>] tick_sched_timer+0x41/0x60
[ 1475.405330]  [<ffffffff810984f7>] __run_hrtimer+0x77/0x1d0
[ 1475.405330]  [<ffffffff810e23b0>] ? tick_sched_handle.isra.17+0x60/0x60
[ 1475.405330]  [<ffffffff81098d37>] hrtimer_interrupt+0xf7/0x240
[ 1475.405330]  [<ffffffff8104ab07>] local_apic_timer_interrupt+0x37/0x60
[ 1475.405330]  [<ffffffff8163b66f>] smp_apic_timer_interrupt+0x3f/0x60
[ 1475.405330]  [<ffffffff81639fdd>] apic_timer_interrupt+0x6d/0x80
[ 1475.405330]  <EOI>  [<ffffffff81621b45>] ? panic+0x1a6/0x1e7
[ 1475.405330]  [<ffffffff8163120b>] oops_end+0x12b/0x150
[ 1475.405330]  [<ffffffff810192fb>] die+0x4b/0x70
[ 1475.405330]  [<ffffffff816308e0>] do_trap+0x60/0x170
[ 1475.405330]  [<ffffffff810161c4>] do_invalid_op+0xb4/0x130
[ 1475.405330]  [<ffffffff81167748>] ? __free_pages+0x68/0x70
[ 1475.405330]  [<ffffffff810cabdd>] ? vprintk_emit+0x1bd/0x510
[ 1475.405330]  [<ffffffff8163aa9e>] invalid_op+0x1e/0x30
[ 1475.405330]  [<ffffffff81167748>] ? __free_pages+0x68/0x70
[ 1475.405330]  [<ffffffff81167748>] ? __free_pages+0x68/0x70
[ 1475.405330]  [<ffffffff811617ae>] mempool_free_pages+0xe/0x10
[ 1475.405330]  [<ffffffff81161815>] mempool_destroy+0x35/0x60
[ 1475.405330]  [<ffffffffa054101d>] crypt_dtr+0x7d/0xe0 [dm_crypt]
[ 1475.405330]  [<ffffffffa0004c38>] dm_table_destroy+0x68/0xf0 [dm_mod]
[ 1475.405330]  [<ffffffffa00020d4>] __dm_destroy+0xf4/0x260 [dm_mod]
[ 1475.405330]  [<ffffffffa0002fa3>] dm_destroy+0x13/0x20 [dm_mod]
[ 1475.405330]  [<ffffffffa0008a3e>] dev_remove+0x11e/0x180 [dm_mod]
[ 1475.405330]  [<ffffffffa0008920>] ? dev_suspend+0x250/0x250 [dm_mod]
[ 1475.405330]  [<ffffffffa0009115>] ctl_ioctl+0x255/0x500 [dm_mod]
[ 1475.405330]  [<ffffffffa00093d3>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
[ 1475.405330]  [<ffffffff811e9ac0>] do_vfs_ioctl+0x2e0/0x4a0
[ 1475.405330]  [<ffffffff8127fe96>] ? file_has_perm+0xa6/0xb0
[ 1475.405330]  [<ffffffff811e9d01>] SyS_ioctl+0x81/0xa0
[ 1475.405330]  [<ffffffff81639369>] system_call_fastpath+0x16/0x1b
[ 1475.405330] ---[ end trace 9960ec06a734b828 ]---
