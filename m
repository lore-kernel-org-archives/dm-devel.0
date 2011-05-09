From: Christian May <christian_may@de.ibm.com>
Subject: Re: 2.6.32.28 - md resync + pvmove - crash
Date: Mon, 9 May 2011 15:16:16 +0200
Message-ID: <OF9FFD6321.A5391DDD-ONC125788B.00484979-C125788B.0048E358@de.ibm.com>
References: <20110507103907.GA2712@nik-comp.lan>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8912704980915222234=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110507103907.GA2712@nik-comp.lan>
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

This is a multipart message in MIME format.
--===============8912704980915222234==
Content-Type: multipart/alternative;
	boundary="=_alternative 0048E07CC125788B_="

This is a multipart message in MIME format.
--=_alternative 0048E07CC125788B_=
Content-Type: text/plain; charset="US-ASCII"

Hi,

I've seen the similar backtraces on my RHEL6.1 Snap 5 test system.  When 
ruring good path I/O I found the following:

INFO: task kswapd0:98 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kswapd0       D eeda7ab8     0    98      2 0x00000000
 f7292ab0 00000046 00000002 eeda7ab8 c9643b54 00000000 00000001 00000010
 ec77c800 ee6aaac0 00001ef7 f30eedfc 00001ef7 c0ae2120 c0ae2120 f7292d58
 c0ae2120 c0addb54 c0ae2120 f7292d58 c9643b54 c05d7a20 0202fcfa f7292ab0
Call Trace:
 [<c05d7a20>] ? blk_unplug_timeout+0x0/0x50
 [<c0463b8e>] ? mod_timer+0xfe/0x1e0
 [<c05d857f>] ? blk_plug_device+0x6f/0xd0
 [<c047dd90>] ? ktime_get_ts+0xd0/0x100
 [<c0822b49>] ? io_schedule+0x59/0xa0
 [<c05dacf1>] ? get_request_wait+0xc1/0x190
 [<c05d28a5>] ? elv_merge+0x185/0x1b0
 [<c0473ec0>] ? autoremove_wake_function+0x0/0x40
 [<c05dae26>] ? __make_request+0x66/0x4a0
 [<f7e4cf48>] ? dm_request+0x108/0x150 [dm_mod]
 [<c05d9c7d>] ? generic_make_request+0x38d/0x5f0
 [<c044615d>] ? activate_task+0x1d/0x30
 [<c043f4ad>] ? enqueue_entity+0x37d/0x400
 [<c05d9f59>] ? submit_bio+0x79/0x120
 [<c0555001>] ? bio_alloc_bioset+0x41/0xc0
 [<c0550709>] ? submit_bh+0xd9/0x120
 [<c055219a>] ? __block_write_full_page+0x20a/0x3d0
 [<c043f4ad>] ? enqueue_entity+0x37d/0x400
 [<c05563c0>] ? blkdev_get_block+0x0/0xd0
 [<c0552c67>] ? block_write_full_page_endio+0xa7/0xe0
 [<c0551b80>] ? end_buffer_async_write+0x0/0x140
 [<c05563c0>] ? blkdev_get_block+0x0/0xd0
 [<c0552caf>] ? block_write_full_page+0xf/0x20
 [<c0551b80>] ? end_buffer_async_write+0x0/0x140
 [<c04f247c>] ? pageout.clone.1+0xfc/0x2b0
 [<c04f28e3>] ? shrink_page_list.clone.0+0x2b3/0x460
 [<c04f2d4d>] ? shrink_inactive_list+0x2bd/0x640
 [<c04f3bcd>] ? shrink_zone+0x30d/0x460
 [<c04f4ae9>] ? kswapd+0x699/0x8d0
 [<c04f4d20>] ? isolate_pages_global+0x0/0x2c0
 [<c0473ec0>] ? autoremove_wake_function+0x0/0x40
 [<c04f4450>] ? kswapd+0x0/0x8d0
 [<c0473c84>] ? kthread+0x74/0x80
 [<c0473c10>] ? kthread+0x0/0x80
 [<c040a03f>] ? kernel_thread_helper+0x7/0x10

The system was still accessible and I/O continued. I've noticed kjournald 
messages too. Will keep an eye on that..

Best regards,

Christian

 



From:   Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To:     linux-kernel@vger.kernel.org
Cc:     nikola.ciprich@linuxbox.cz, linux-raid@vger.kernel.org, 
dm-devel@redhat.com, stable@kernel.org
Date:   07.05.2011 12:41
Subject:        [dm-devel] 2.6.32.28 - md resync + pvmove - crash
Sent by:        dm-devel-bounces@redhat.com



Hi,
first, I'm sorry for crossposting and also CCing stable@, if that's not 
OK, please let me knows.
Anyways, we've experienced hang of system running 2.6.32.28.
After upgrading to 2.6.32 and replacing failed disk, md resync has 
started. Then when the technician started pvmove, dome deadlock must have 
occured, because all disk requests started to hang and the whole system 
had to be rebooted...

here's the backtrace:

[ 1229.645028] alg: No test for stdrng (krng)
[ 1229.668172] alg: No test for authenc(hmac(sha1),cbc(des3_ede)) 
(authenc(hmac(sha1-generic),cbc(des3_ede-generic)))
[ 1531.585167] md: bind<sda2>
[ 1531.927846] raid1: raid set md2 active with 1 out of 2 mirrors
[ 1531.934613] md2: detected capacity change from 0 to 2000133029888
[ 1549.850444] md1: bitmap file is out of date (0 < 439231) -- forcing 
full recovery
[ 1549.858719] md1: bitmap file is out of date, doing full recovery
[ 1550.068105] md1: bitmap initialized from disk: read 11/11 pages, set 
357576 bits
[ 1550.076054] created bitmap (175 pages) for device md1
[ 1561.449841]  md2: unknown partition table
[ 1561.501645] md2: bitmap file is out of date (0 < 4) -- forcing full 
recovery
[ 1561.509999] md2: bitmap file is out of date, doing full recovery
[ 1562.158515] md2: bitmap initialized from disk: read 15/15 pages, set 
476869 bits
[ 1562.167764] created bitmap (233 pages) for device md2
[ 2400.956019] INFO: task kjournald:1038 blocked for more than 120 
seconds.
[ 2400.963280] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[ 2400.971356] kjournald     D ffff8800016ac400     0  1038      2 
0x00000000
[ 2400.978621]  ffff88003cc33c60 0000000000000046 ffff88003cc33bd0 
ffffffff8119ba6f
[ 2400.986513]  0000000000013780 ffff88003f9746b0 ffff88003f9745f0 
ffff88003ea2c5f0
[ 2400.994426]  ffff88003f9749a0 ffff88003cc33fd8 ffff88003d65b000 
ffff880035600a00
[ 2401.002415] Call Trace:
[ 2401.005024]  [<ffffffff8119ba6f>] ? blk_unplug+0x2f/0xa0
[ 2401.010530]  [<ffffffff81076bb4>] ? ktime_get_ts+0xa4/0xd0
[ 2401.016182]  [<ffffffff8133773e>] io_schedule+0x6e/0xc0
[ 2401.021643]  [<ffffffff81136afe>] sync_buffer+0x3e/0x50
[ 2401.027029]  [<ffffffff81337c75>] __wait_on_bit+0x55/0x80
[ 2401.032638]  [<ffffffff81136ac0>] ? sync_buffer+0x0/0x50
[ 2401.038177]  [<ffffffff81136ac0>] ? sync_buffer+0x0/0x50
[ 2401.043659]  [<ffffffff81337d18>] out_of_line_wait_on_bit+0x78/0x90
[ 2401.050129]  [<ffffffff8106e070>] ? wake_bit_function+0x0/0x30
[ 2401.056143]  [<ffffffff81136a36>] __wait_on_buffer+0x26/0x30
[ 2401.062077]  [<ffffffffa002a097>] 
journal_commit_transaction+0x657/0x13c0 [jbd]
[ 2401.069693]  [<ffffffff8105e104>] ? try_to_del_timer_sync+0x44/0x110
[ 2401.076212]  [<ffffffff81339ddd>] ? _spin_unlock_irqrestore+0x1d/0x50
[ 2401.082831]  [<ffffffffa002e893>] kjournald+0xe3/0x260 [jbd]
[ 2401.088708]  [<ffffffff8106e030>] ? autoremove_wake_function+0x0/0x40
[ 2401.095369]  [<ffffffffa002e7b0>] ? kjournald+0x0/0x260 [jbd]
[ 2401.101337]  [<ffffffff8106deee>] kthread+0x8e/0xa0
[ 2401.106354]  [<ffffffff8100c30a>] child_rip+0xa/0x20
[ 2401.111477]  [<ffffffff8106de60>] ? kthread+0x0/0xa0
[ 2401.116598]  [<ffffffff8100c300>] ? child_rip+0x0/0x20
[ 2401.121893] INFO: task flush-253:2:3168 blocked for more than 120 
seconds.
[ 2401.128983] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[ 2401.137114] flush-253:2   D 0000000000000002     0  3168      2 
0x00000000
[ 2401.144318]  ffff88002c245a40 0000000000000046 ffff880035601600 
ffff88002f621840
[ 2401.152248]  0000000000013780 ffff88003ceb9810 ffff88003ceb9750 
ffff88003ea2c5f0
[ 2401.160169]  ffff88003ceb9b00 ffff88002c245fd8 ffff88002c245a00 
ffff880035601600
[ 2401.168048] Call Trace:
[ 2401.170608]  [<ffffffff81076bb4>] ? ktime_get_ts+0xa4/0xd0
[ 2401.176303]  [<ffffffff8133773e>] io_schedule+0x6e/0xc0
[ 2401.181723]  [<ffffffff810ccb56>] sync_page+0x36/0x50
[ 2401.186970]  [<ffffffff81337b3e>] __wait_on_bit_lock+0x4e/0xa0
[ 2401.192991]  [<ffffffff810ccb20>] ? sync_page+0x0/0x50
[ 2401.198287]  [<ffffffff810ccb05>] __lock_page+0x65/0x70
[ 2401.203687]  [<ffffffff8106e070>] ? wake_bit_function+0x0/0x30
[ 2401.209687]  [<ffffffff810d4366>] write_cache_pages+0x3d6/0x490
[ 2401.215802]  [<ffffffff810d3da0>] ? __writepage+0x0/0x40
[ 2401.221291]  [<ffffffff810d4442>] generic_writepages+0x22/0x30
[ 2401.227327]  [<ffffffff810d4476>] do_writepages+0x26/0x30
[ 2401.232965]  [<ffffffff8112fa24>] writeback_single_inode+0xa4/0x290
[ 2401.239412]  [<ffffffff811304e2>] writeback_inodes_wb+0x2d2/0x420
[ 2401.245715]  [<ffffffff81130756>] wb_writeback+0x126/0x1e0
[ 2401.251360]  [<ffffffff81130a84>] wb_do_writeback+0x1a4/0x1c0
[ 2401.257287]  [<ffffffff81130ad5>] bdi_writeback_task+0x35/0xd0
[ 2401.263317]  [<ffffffff810e5cf0>] ? bdi_start_fn+0x0/0xf0
[ 2401.268886]  [<ffffffff810e5d71>] bdi_start_fn+0x81/0xf0
[ 2401.274370]  [<ffffffff810e5cf0>] ? bdi_start_fn+0x0/0xf0
[ 2401.279947]  [<ffffffff8106deee>] kthread+0x8e/0xa0
[ 2401.285000]  [<ffffffff8100c30a>] child_rip+0xa/0x20
[ 2401.290120]  [<ffffffff8106de60>] ? kthread+0x0/0xa0
[ 2401.295247]  [<ffffffff8100c300>] ? child_rip+0x0/0x20
[ 2401.300586] INFO: task reiserfs/0:3204 blocked for more than 120 
seconds.
[ 2401.307590] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[ 2401.315682] reiserfs/0    D ffff880016fdad48     0  3204      2 
0x00000000
[ 2401.322884]  ffff88002f1b1d10 0000000000000046 ffff88000180dda0 
ffff88000180dec0
[ 2401.330754]  0000000000013780 ffff88003ea180c0 ffff88003ea18000 
ffff88002f43aea0
[ 2401.338683]  ffff88003ea183b0 ffff88002f1b1fd8 ffff88002f1b1cd0 
ffffffff81048960
[ 2401.346684] Call Trace:
[ 2401.349252]  [<ffffffff81048960>] ? update_curr+0xb0/0x170
[ 2401.354983]  [<ffffffff813384f7>] __mutex_lock_slowpath+0x107/0x310
[ 2401.361480]  [<ffffffff81338727>] mutex_lock+0x27/0x50
[ 2401.366791]  [<ffffffffa0358b27>] flush_commit_list+0x137/0x6d0

I can't 100% separate out some hardware problem, but this system has been 
running 2.6.27.x rock solid for years till then..
Can somebody see something interesting in those backtraces?
If I can provide further information, I'll be glad to assist...
BR
nik


-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
[attachment "attui1b8.dat" deleted by Christian May/Germany/IBM] --
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

--=_alternative 0048E07CC125788B_=
Content-Type: text/html; charset="US-ASCII"

<font size=2 face="sans-serif">Hi,</font>
<br>
<br><font size=2 face="sans-serif">I've seen the similar backtraces on
my RHEL6.1 Snap 5 test system. &nbsp;When ruring good path I/O I found
the following:</font>
<br>
<br><tt><font size=2>INFO: task kswapd0:98 blocked for more than 120 seconds.<br>
&quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disables
this message.<br>
kswapd0 &nbsp; &nbsp; &nbsp; D eeda7ab8 &nbsp; &nbsp; 0 &nbsp; &nbsp;98
&nbsp; &nbsp; &nbsp;2 0x00000000<br>
 f7292ab0 00000046 00000002 eeda7ab8 c9643b54 00000000 00000001 00000010<br>
 ec77c800 ee6aaac0 00001ef7 f30eedfc 00001ef7 c0ae2120 c0ae2120 f7292d58<br>
 c0ae2120 c0addb54 c0ae2120 f7292d58 c9643b54 c05d7a20 0202fcfa f7292ab0<br>
Call Trace:<br>
 [&lt;c05d7a20&gt;] ? blk_unplug_timeout+0x0/0x50<br>
 [&lt;c0463b8e&gt;] ? mod_timer+0xfe/0x1e0<br>
 [&lt;c05d857f&gt;] ? blk_plug_device+0x6f/0xd0<br>
 [&lt;c047dd90&gt;] ? ktime_get_ts+0xd0/0x100<br>
 [&lt;c0822b49&gt;] ? io_schedule+0x59/0xa0<br>
 [&lt;c05dacf1&gt;] ? get_request_wait+0xc1/0x190<br>
 [&lt;c05d28a5&gt;] ? elv_merge+0x185/0x1b0<br>
 [&lt;c0473ec0&gt;] ? autoremove_wake_function+0x0/0x40<br>
 [&lt;c05dae26&gt;] ? __make_request+0x66/0x4a0<br>
 [&lt;f7e4cf48&gt;] ? dm_request+0x108/0x150 [dm_mod]<br>
 [&lt;c05d9c7d&gt;] ? generic_make_request+0x38d/0x5f0<br>
 [&lt;c044615d&gt;] ? activate_task+0x1d/0x30<br>
 [&lt;c043f4ad&gt;] ? enqueue_entity+0x37d/0x400<br>
 [&lt;c05d9f59&gt;] ? submit_bio+0x79/0x120<br>
 [&lt;c0555001&gt;] ? bio_alloc_bioset+0x41/0xc0<br>
 [&lt;c0550709&gt;] ? submit_bh+0xd9/0x120<br>
 [&lt;c055219a&gt;] ? __block_write_full_page+0x20a/0x3d0<br>
 [&lt;c043f4ad&gt;] ? enqueue_entity+0x37d/0x400<br>
 [&lt;c05563c0&gt;] ? blkdev_get_block+0x0/0xd0<br>
 [&lt;c0552c67&gt;] ? block_write_full_page_endio+0xa7/0xe0<br>
 [&lt;c0551b80&gt;] ? end_buffer_async_write+0x0/0x140<br>
 [&lt;c05563c0&gt;] ? blkdev_get_block+0x0/0xd0<br>
 [&lt;c0552caf&gt;] ? block_write_full_page+0xf/0x20<br>
 [&lt;c0551b80&gt;] ? end_buffer_async_write+0x0/0x140<br>
 [&lt;c04f247c&gt;] ? pageout.clone.1+0xfc/0x2b0<br>
 [&lt;c04f28e3&gt;] ? shrink_page_list.clone.0+0x2b3/0x460<br>
 [&lt;c04f2d4d&gt;] ? shrink_inactive_list+0x2bd/0x640<br>
 [&lt;c04f3bcd&gt;] ? shrink_zone+0x30d/0x460<br>
 [&lt;c04f4ae9&gt;] ? kswapd+0x699/0x8d0<br>
 [&lt;c04f4d20&gt;] ? isolate_pages_global+0x0/0x2c0<br>
 [&lt;c0473ec0&gt;] ? autoremove_wake_function+0x0/0x40<br>
 [&lt;c04f4450&gt;] ? kswapd+0x0/0x8d0<br>
 [&lt;c0473c84&gt;] ? kthread+0x74/0x80<br>
 [&lt;c0473c10&gt;] ? kthread+0x0/0x80<br>
 [&lt;c040a03f&gt;] ? kernel_thread_helper+0x7/0x10</font></tt>
<br>
<br><font size=2 face="sans-serif">The system was still accessible and
I/O continued. I've noticed kjournald messages too. Will keep an eye on
that..<br>
<br>
Best regards,</font>
<br>
<br><font size=2 face="sans-serif">Christian</font>
<br>
<p><font size=3>&nbsp;</font>
<br>
<br>
<br>
<br><font size=1 color=#5f5f5f face="sans-serif">From: &nbsp; &nbsp; &nbsp;
&nbsp;</font><font size=1 face="sans-serif">Nikola Ciprich &lt;nikola.ciprich@linuxbox.cz&gt;</font>
<br><font size=1 color=#5f5f5f face="sans-serif">To: &nbsp; &nbsp; &nbsp;
&nbsp;</font><font size=1 face="sans-serif">linux-kernel@vger.kernel.org</font>
<br><font size=1 color=#5f5f5f face="sans-serif">Cc: &nbsp; &nbsp; &nbsp;
&nbsp;</font><font size=1 face="sans-serif">nikola.ciprich@linuxbox.cz,
linux-raid@vger.kernel.org, dm-devel@redhat.com, stable@kernel.org</font>
<br><font size=1 color=#5f5f5f face="sans-serif">Date: &nbsp; &nbsp; &nbsp;
&nbsp;</font><font size=1 face="sans-serif">07.05.2011 12:41</font>
<br><font size=1 color=#5f5f5f face="sans-serif">Subject: &nbsp; &nbsp;
&nbsp; &nbsp;</font><font size=1 face="sans-serif">[dm-devel] 2.6.32.28
- md resync + pvmove - crash</font>
<br><font size=1 color=#5f5f5f face="sans-serif">Sent by: &nbsp; &nbsp;
&nbsp; &nbsp;</font><font size=1 face="sans-serif">dm-devel-bounces@redhat.com</font>
<br>
<hr noshade>
<br>
<br>
<br><tt><font size=2>Hi,<br>
first, I'm sorry for crossposting and also CCing stable@, if that's not
OK, please let me knows.<br>
Anyways, we've experienced hang of system running 2.6.32.28.<br>
After upgrading to 2.6.32 and replacing failed disk, md resync has started.
Then when the technician started pvmove, dome deadlock must have occured,
because all disk requests started to hang and the whole system had to be
rebooted...<br>
<br>
here's the backtrace:<br>
<br>
[ 1229.645028] alg: No test for stdrng (krng)<br>
[ 1229.668172] alg: No test for authenc(hmac(sha1),cbc(des3_ede)) (authenc(hmac(sha1-generic),cbc(des3_ede-generic)))<br>
[ 1531.585167] md: bind&lt;sda2&gt;<br>
[ 1531.927846] raid1: raid set md2 active with 1 out of 2 mirrors<br>
[ 1531.934613] md2: detected capacity change from 0 to 2000133029888<br>
[ 1549.850444] md1: bitmap file is out of date (0 &lt; 439231) -- forcing
full recovery<br>
[ 1549.858719] md1: bitmap file is out of date, doing full recovery<br>
[ 1550.068105] md1: bitmap initialized from disk: read 11/11 pages, set
357576 bits<br>
[ 1550.076054] created bitmap (175 pages) for device md1<br>
[ 1561.449841] &nbsp;md2: unknown partition table<br>
[ 1561.501645] md2: bitmap file is out of date (0 &lt; 4) -- forcing full
recovery<br>
[ 1561.509999] md2: bitmap file is out of date, doing full recovery<br>
[ 1562.158515] md2: bitmap initialized from disk: read 15/15 pages, set
476869 bits<br>
[ 1562.167764] created bitmap (233 pages) for device md2<br>
[ 2400.956019] INFO: task kjournald:1038 blocked for more than 120 seconds.<br>
[ 2400.963280] &quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot;
disables this message.<br>
[ 2400.971356] kjournald &nbsp; &nbsp; D ffff8800016ac400 &nbsp; &nbsp;
0 &nbsp;1038 &nbsp; &nbsp; &nbsp;2 0x00000000<br>
[ 2400.978621] &nbsp;ffff88003cc33c60 0000000000000046 ffff88003cc33bd0
ffffffff8119ba6f<br>
[ 2400.986513] &nbsp;0000000000013780 ffff88003f9746b0 ffff88003f9745f0
ffff88003ea2c5f0<br>
[ 2400.994426] &nbsp;ffff88003f9749a0 ffff88003cc33fd8 ffff88003d65b000
ffff880035600a00<br>
[ 2401.002415] Call Trace:<br>
[ 2401.005024] &nbsp;[&lt;ffffffff8119ba6f&gt;] ? blk_unplug+0x2f/0xa0<br>
[ 2401.010530] &nbsp;[&lt;ffffffff81076bb4&gt;] ? ktime_get_ts+0xa4/0xd0<br>
[ 2401.016182] &nbsp;[&lt;ffffffff8133773e&gt;] io_schedule+0x6e/0xc0<br>
[ 2401.021643] &nbsp;[&lt;ffffffff81136afe&gt;] sync_buffer+0x3e/0x50<br>
[ 2401.027029] &nbsp;[&lt;ffffffff81337c75&gt;] __wait_on_bit+0x55/0x80<br>
[ 2401.032638] &nbsp;[&lt;ffffffff81136ac0&gt;] ? sync_buffer+0x0/0x50<br>
[ 2401.038177] &nbsp;[&lt;ffffffff81136ac0&gt;] ? sync_buffer+0x0/0x50<br>
[ 2401.043659] &nbsp;[&lt;ffffffff81337d18&gt;] out_of_line_wait_on_bit+0x78/0x90<br>
[ 2401.050129] &nbsp;[&lt;ffffffff8106e070&gt;] ? wake_bit_function+0x0/0x30<br>
[ 2401.056143] &nbsp;[&lt;ffffffff81136a36&gt;] __wait_on_buffer+0x26/0x30<br>
[ 2401.062077] &nbsp;[&lt;ffffffffa002a097&gt;] journal_commit_transaction+0x657/0x13c0
[jbd]<br>
[ 2401.069693] &nbsp;[&lt;ffffffff8105e104&gt;] ? try_to_del_timer_sync+0x44/0x110<br>
[ 2401.076212] &nbsp;[&lt;ffffffff81339ddd&gt;] ? _spin_unlock_irqrestore+0x1d/0x50<br>
[ 2401.082831] &nbsp;[&lt;ffffffffa002e893&gt;] kjournald+0xe3/0x260 [jbd]<br>
[ 2401.088708] &nbsp;[&lt;ffffffff8106e030&gt;] ? autoremove_wake_function+0x0/0x40<br>
[ 2401.095369] &nbsp;[&lt;ffffffffa002e7b0&gt;] ? kjournald+0x0/0x260 [jbd]<br>
[ 2401.101337] &nbsp;[&lt;ffffffff8106deee&gt;] kthread+0x8e/0xa0<br>
[ 2401.106354] &nbsp;[&lt;ffffffff8100c30a&gt;] child_rip+0xa/0x20<br>
[ 2401.111477] &nbsp;[&lt;ffffffff8106de60&gt;] ? kthread+0x0/0xa0<br>
[ 2401.116598] &nbsp;[&lt;ffffffff8100c300&gt;] ? child_rip+0x0/0x20<br>
[ 2401.121893] INFO: task flush-253:2:3168 blocked for more than 120 seconds.<br>
[ 2401.128983] &quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot;
disables this message.<br>
[ 2401.137114] flush-253:2 &nbsp; D 0000000000000002 &nbsp; &nbsp; 0 &nbsp;3168
&nbsp; &nbsp; &nbsp;2 0x00000000<br>
[ 2401.144318] &nbsp;ffff88002c245a40 0000000000000046 ffff880035601600
ffff88002f621840<br>
[ 2401.152248] &nbsp;0000000000013780 ffff88003ceb9810 ffff88003ceb9750
ffff88003ea2c5f0<br>
[ 2401.160169] &nbsp;ffff88003ceb9b00 ffff88002c245fd8 ffff88002c245a00
ffff880035601600<br>
[ 2401.168048] Call Trace:<br>
[ 2401.170608] &nbsp;[&lt;ffffffff81076bb4&gt;] ? ktime_get_ts+0xa4/0xd0<br>
[ 2401.176303] &nbsp;[&lt;ffffffff8133773e&gt;] io_schedule+0x6e/0xc0<br>
[ 2401.181723] &nbsp;[&lt;ffffffff810ccb56&gt;] sync_page+0x36/0x50<br>
[ 2401.186970] &nbsp;[&lt;ffffffff81337b3e&gt;] __wait_on_bit_lock+0x4e/0xa0<br>
[ 2401.192991] &nbsp;[&lt;ffffffff810ccb20&gt;] ? sync_page+0x0/0x50<br>
[ 2401.198287] &nbsp;[&lt;ffffffff810ccb05&gt;] __lock_page+0x65/0x70<br>
[ 2401.203687] &nbsp;[&lt;ffffffff8106e070&gt;] ? wake_bit_function+0x0/0x30<br>
[ 2401.209687] &nbsp;[&lt;ffffffff810d4366&gt;] write_cache_pages+0x3d6/0x490<br>
[ 2401.215802] &nbsp;[&lt;ffffffff810d3da0&gt;] ? __writepage+0x0/0x40<br>
[ 2401.221291] &nbsp;[&lt;ffffffff810d4442&gt;] generic_writepages+0x22/0x30<br>
[ 2401.227327] &nbsp;[&lt;ffffffff810d4476&gt;] do_writepages+0x26/0x30<br>
[ 2401.232965] &nbsp;[&lt;ffffffff8112fa24&gt;] writeback_single_inode+0xa4/0x290<br>
[ 2401.239412] &nbsp;[&lt;ffffffff811304e2&gt;] writeback_inodes_wb+0x2d2/0x420<br>
[ 2401.245715] &nbsp;[&lt;ffffffff81130756&gt;] wb_writeback+0x126/0x1e0<br>
[ 2401.251360] &nbsp;[&lt;ffffffff81130a84&gt;] wb_do_writeback+0x1a4/0x1c0<br>
[ 2401.257287] &nbsp;[&lt;ffffffff81130ad5&gt;] bdi_writeback_task+0x35/0xd0<br>
[ 2401.263317] &nbsp;[&lt;ffffffff810e5cf0&gt;] ? bdi_start_fn+0x0/0xf0<br>
[ 2401.268886] &nbsp;[&lt;ffffffff810e5d71&gt;] bdi_start_fn+0x81/0xf0<br>
[ 2401.274370] &nbsp;[&lt;ffffffff810e5cf0&gt;] ? bdi_start_fn+0x0/0xf0<br>
[ 2401.279947] &nbsp;[&lt;ffffffff8106deee&gt;] kthread+0x8e/0xa0<br>
[ 2401.285000] &nbsp;[&lt;ffffffff8100c30a&gt;] child_rip+0xa/0x20<br>
[ 2401.290120] &nbsp;[&lt;ffffffff8106de60&gt;] ? kthread+0x0/0xa0<br>
[ 2401.295247] &nbsp;[&lt;ffffffff8100c300&gt;] ? child_rip+0x0/0x20<br>
[ 2401.300586] INFO: task reiserfs/0:3204 blocked for more than 120 seconds.<br>
[ 2401.307590] &quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot;
disables this message.<br>
[ 2401.315682] reiserfs/0 &nbsp; &nbsp;D ffff880016fdad48 &nbsp; &nbsp;
0 &nbsp;3204 &nbsp; &nbsp; &nbsp;2 0x00000000<br>
[ 2401.322884] &nbsp;ffff88002f1b1d10 0000000000000046 ffff88000180dda0
ffff88000180dec0<br>
[ 2401.330754] &nbsp;0000000000013780 ffff88003ea180c0 ffff88003ea18000
ffff88002f43aea0<br>
[ 2401.338683] &nbsp;ffff88003ea183b0 ffff88002f1b1fd8 ffff88002f1b1cd0
ffffffff81048960<br>
[ 2401.346684] Call Trace:<br>
[ 2401.349252] &nbsp;[&lt;ffffffff81048960&gt;] ? update_curr+0xb0/0x170<br>
[ 2401.354983] &nbsp;[&lt;ffffffff813384f7&gt;] __mutex_lock_slowpath+0x107/0x310<br>
[ 2401.361480] &nbsp;[&lt;ffffffff81338727&gt;] mutex_lock+0x27/0x50<br>
[ 2401.366791] &nbsp;[&lt;ffffffffa0358b27&gt;] flush_commit_list+0x137/0x6d0<br>
<br>
I can't 100% separate out some hardware problem, but this system has been
running 2.6.27.x rock solid for years till then..<br>
Can somebody see something interesting in those backtraces?<br>
If I can provide further information, I'll be glad to assist...<br>
BR<br>
nik<br>
<br>
<br>
-- <br>
-------------------------------------<br>
Ing. Nikola CIPRICH<br>
LinuxBox.cz, s.r.o.<br>
28. rijna 168, 709 01 Ostrava<br>
<br>
tel.: &nbsp; +420 596 603 142<br>
fax: &nbsp; &nbsp;+420 596 621 273<br>
mobil: &nbsp;+420 777 093 799<br>
<br>
</font></tt><a href=www.linuxbox.cz><tt><font size=2>www.linuxbox.cz</font></tt></a><tt><font size=2><br>
<br>
mobil servis: +420 737 238 656<br>
email servis: servis@linuxbox.cz<br>
-------------------------------------<br>
[attachment &quot;attui1b8.dat&quot; deleted by Christian May/Germany/IBM]
--<br>
dm-devel mailing list<br>
dm-devel@redhat.com<br>
</font></tt><a href="https://www.redhat.com/mailman/listinfo/dm-devel"><tt><font size=2>https://www.redhat.com/mailman/listinfo/dm-devel</font></tt></a>
<br>
--=_alternative 0048E07CC125788B_=--


--===============8912704980915222234==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8912704980915222234==--
