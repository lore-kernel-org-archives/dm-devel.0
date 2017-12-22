From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: regression 4.15-rc: kernel oops in dm-multipath
Date: Fri, 22 Dec 2017 10:53:21 +0100
Message-ID: <7dc463af-554f-1778-7e24-757de143d6b7@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

Since 4.15-rc1 I get the following during boot relatively often (but not 100% reproducable)


Seems to be 2 oopses...


"[    5.851954] device-mapper: multipath service-time: version 0.3.0 loaded
"[    5.902244] Unable to handle kernel pointer dereference in virtual kernel address space
"[    5.902272] Failing address: 000003ff82196000 TEID: 000003ff82196803
"[    5.902275] Fault in home space mode while using kernel ASCE.
"[    5.902283] AS:000000000135c007 R3:00000002105e0007 S:0000000000000020 
"[    5.902390] Oops: 0010 ilc:3 [#1] SMP 
"[    5.902437] Modules linked in: dm_service_time mlx4_ib mlx4_en ptp ib_core pp
"s_core ghash_s390 prng aes_s390 des_s390 des_generic sha512_s390 sha256_s390 sha
"1_s390 sha_common mlx4_core eadm_sch dm_multipath dm_mod zcrypt_cex4 zcrypt rng_
"core
"[    5.902818] Unable to handle kernel pointer dereference in virtual kernel address space
"[    5.902829] Failing address: 000003ff8218e000 TEID: 000003ff8218e803
"[    5.902840] Fault in home space mode while using 
"[    5.902867]  vhost_net sch_fq_codel tun
"[    5.902899] kernel 
"[    5.902917]  vhost tap ip_tables
"[    5.902940] ASCE.
"[    5.902955] AS:000000000135c007 R3:00000002105e0007 
"[    5.902972]  x_tables autofs4
"[    5.902987] S:0000000000000020 
"[    5.903012] CPU: 0 PID: 742 Comm: systemd-udevd Not tainted 4.15.0-rc3+ #11
"[    5.903024] Hardware name: IBM 2964 NC9 704 (LPAR)
"[    5.903035] Krnl PSW : 0000000047407382 00000000702c2011 (multipath_busy+0x9a
"/0x128 [dm_multipath])
"[    5.903085]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:3 PM:0 RI: 0 EA:3
"[    5.903112] Krnl GPRS: 0000000000000001 000003ff82195a72 0000000000000000 ffffffff00000000
"[    5.903133]            000003ff800cff9c 0000000000000000 0000000000000800 00000001fa508730
"[    5.903154]            00000001f1f48000 000003e000000000 00000001f808c030 00000001e76afb00
"[    5.903173]            00000001f1f48000 00000001f89efc58 00000001f89efa08 00000001f89ef9c8
"[    5.903191] Krnl Code: 000003ff800f4e30: e310b0200004        lg      %r1,32(%r11)
"[    5.903191]            000003ff800f4e36: e31010000004        lg      %r1,0(%r1)
"[    5.903191]           #000003ff800f4e3c: e31011100004        lg      %r1,272(%r1)
"[    5.903191]           >000003ff800f4e42: e32016980004        lg      %r2,1688(%r1)
"[    5.903191]            000003ff800f4e48: c0e5fffff972        brasl   %r14,3ff800f412c
"[    5.903191]            000003ff800f4e4e: ec28000d007e        cij     %r2,0,8,3ff800f4e68
"[    5.903191]            000003ff800f4e54: a7180001            lhi     %r1,1
"[    5.903191]            000003ff800f4e58: e3b0b0000004        lg      %r11,0(%r11)
"[    5.903308] Call Trace:
"[    5.903319] ([<00000001f89ef9c0>] 0x1f89ef9c0)
"[    5.903342]  [<000003ff800cff3e>] dm_old_request_fn+0x56/0x1d0 [dm_mod] 
"[    5.903367]  [<0000000000734f66>] __blk_run_queue+0x86/0x108 
"[    5.903385]  [<0000000000736132>] queue_unplugged+0x8a/0x200 
"[    5.903404]  [<000000000073ca0c>] blk_flush_plug_list+0x284/0x2f0 
"[    5.903417]  [<000000000073d234>] blk_finish_plug+0x3c/0x60 
"[    5.903426]  [<0000000000313dd8>] __do_page_cache_readahead+0x2e8/0x3d0 
"[    5.903441]  [<0000000000314512>] force_page_cache_readahead+0xb2/0x150 
"[    5.903454]  [<00000000002ff1f0>] generic_file_read_iter+0x6b0/0xa28 
"[    5.903477]  [<00000000003b7e98>] __vfs_read+0x100/0x178 
"[    5.903490]  [<00000000003b7f9a>] vfs_read+0x8a/0x148 
"[    5.903506]  [<00000000003b864e>] SyS_read+0x66/0xd8 
"[    5.903520]  [<0000000000ae9144>] system_call+0x290/0x2b0 
"[    5.903523] INFO: lockdep is turned off.
"[    5.903527] Last Breaking-Event-Address:
"[    5.903541]  [<000003ff800f4e18>] multipath_busy+0x70/0x128 [dm_multipath]
"[    5.903552]  
"[    5.903562] Oops: 0010 ilc:3 [#2] 
"[    5.903566] Kernel panic - not syncing: Fatal exception: panic_on_oops



The faulting code seems to be

        list_for_each_entry(pgpath, &pg->pgpaths, list) {
     854:       e3 b0 b0 00 00 04       lg      %r11,0(%r11)
     85a:       ec ba 00 21 80 64       cgrje   %r11,%r10,89c <multipath_busy+0xbc>
                if (pgpath->is_active) {
     860:       91 80 b0 f8             tm      248(%r11),128
     864:       a7 84 ff f8             je      854 <multipath_busy+0x74>
        struct request_queue *q = bdev_get_queue(pgpath->path.dev->bdev);
     868:       e3 10 b0 20 00 04       lg      %r1,32(%r11)

bool blk_poll(struct request_queue *q, blk_qc_t cookie);

static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
{
        return bdev->bd_disk->queue;    /* this is never NULL */
     86e:       e3 10 10 00 00 04       lg      %r1,0(%r1)
     874:       e3 10 11 10 00 04       lg      %r1,272(%r1) 
        return blk_lld_busy(q);
     87a:       e3 20 16 98 00 04       lg      %r2,1688(%r1)
     880:       c0 e5 00 00 00 00       brasl   %r14,880 <multipath_busy+0xa0>




any quick ideas?
