Return-Path: <SRS0=qllc=KC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F231BC43460
	for <dm-devel@archiver.kernel.org>; Fri,  7 May 2021 10:40:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 24B546145D
	for <dm-devel@archiver.kernel.org>; Fri,  7 May 2021 10:40:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24B546145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=tls.msk.ru
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-ZOhlAJR2P9agCGDaILf4wg-1; Fri, 07 May 2021 06:40:15 -0400
X-MC-Unique: ZOhlAJR2P9agCGDaILf4wg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 895011800D50;
	Fri,  7 May 2021 10:40:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B5F119D9F;
	Fri,  7 May 2021 10:40:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A63255534E;
	Fri,  7 May 2021 10:40:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 147AdwEu002541 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 7 May 2021 06:40:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8B21C16EA67; Fri,  7 May 2021 10:39:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 869E316EA69
	for <dm-devel@redhat.com>; Fri,  7 May 2021 10:39:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57E5480D0E0
	for <dm-devel@redhat.com>; Fri,  7 May 2021 10:39:56 +0000 (UTC)
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-90-3Ywi5KX2OIWTgJGx8cllKg-1; 
	Fri, 07 May 2021 06:39:53 -0400
X-MC-Unique: 3Ywi5KX2OIWTgJGx8cllKg-1
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
	by isrv.corpit.ru (Postfix) with ESMTP id 0EE1040010
	for <dm-devel@redhat.com>; Fri,  7 May 2021 13:31:35 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
	by tsrv.corpit.ru (Postfix) with ESMTP id 6185470
	for <dm-devel@redhat.com>; Fri,  7 May 2021 13:31:35 +0300 (MSK)
To: dm-devel@redhat.com
From: Michael Tokarev <mjt@tls.msk.ru>
Message-ID: <7104c94c-7408-0d58-ddd9-384102e820bc@msgid.tls.msk.ru>
Date: Fri, 7 May 2021 13:31:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.9.0
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Subject: [dm-devel] can we fix some dm snapshot crashes please? :)
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi!

I asked this 1.5 years ago, but go no replies.

The thing is that we have a few bugs in kernel in snapshot-related area
for years, maybe for decades, and the bugs are still there and it is still
trivial to crash the kernel is you're not very-very-very careful.

This might be due to user error ofcourse, but this still is definitely
NOT a valid reason for the crashes.

For example, here it goes for snapshot-origin dm target. Just create
a snapshot-origin and do some activity on it, it is a 2-line reproducer:

  # first create a test device: it can be anything
  # here we use a 100-MB loop device
  truncate --size=100M base
  losetup /dev/loop0 base
  # now create the snapshot-origin on it
  sz=$(blockdev --getsize /dev/loop0)
  dmsetup create base --table "0 $sz snapshot-origin /dev/loop0"
  # and now the crash
  mkfs.ext4 /dev/mapper/base

This crashes instantly. Different kernels crashed a bit differently,
I tried even some 3.x kernels. But the result is the same - crash.

Here's an example from 5.10 kernel:

[   89.661594] ------------[ cut here ]------------
[   89.663789] kernel BUG at block/bio.c:1473!
[   89.665624] invalid opcode: 0000 [#1] SMP PTI
[   89.669108] CPU: 0 PID: 264 Comm: mkfs.ext4 Not tainted 5.10.0-6-amd64 #1 Debian 5.10.28-1
[   89.672551] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[   89.675987] RIP: 0010:bio_split+0x74/0x80
[   89.677744] Code: 89 c7 e8 ff 5e 03 00 41 8b 74 24 28 48 89 ef e8 e2 f5 ff ff f6 45 15 01 74 08 66 41 81 4c 24 14 00 01 4c 89 e0 5b 5d 41 5c c3 
<0f> 0b 0f 0b 0f 0b 45 31 e4 eb ed 90 0f 1f 44 00 00 39 77 28 76 05
[   89.686181] RSP: 0018:ffffb248c026bb30 EFLAGS: 00010246
[   89.688347] RAX: 0000000000000008 RBX: 0000000000000000 RCX: ffff8bd5025f7d80
[   89.691201] RDX: 0000000000000c00 RSI: 0000000000000000 RDI: ffff8bd502031780
[   89.694089] RBP: 0000000000000000 R08: 00000019a1b717a8 R09: 0000000000000000
[   89.696975] R10: ffff8bd5341fc600 R11: ffff8bd5341fc658 R12: ffff8bd5024a0558
[   89.699935] R13: ffff8bd5024a0000 R14: ffff8bd502031780 R15: ffff8bd502383c80
[   89.704128] FS:  00007f0a33236780(0000) GS:ffff8bd53ea00000(0000) knlGS:0000000000000000
[   89.707641] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   89.710162] CR2: 00007f0a31db2000 CR3: 0000000002ab4000 CR4: 00000000000006f0
[   89.713071] Call Trace:
[   89.714247]  dm_submit_bio+0x35d/0x440 [dm_mod]
[   89.716230]  submit_bio_noacct+0xf8/0x420
[   89.719430]  ? bio_add_page+0x62/0x90
[   89.721073]  submit_bh_wbc+0x16a/0x190
[   89.722702]  __block_write_full_page+0x1fa/0x460
[   89.724767]  ? bdev_evict_inode+0xc0/0xc0
[   89.726523]  ? block_invalidatepage+0x150/0x150
[   89.728446]  __writepage+0x17/0x60
[   89.730010]  write_cache_pages+0x186/0x3d0
[   89.731789]  ? __wb_calc_thresh+0x120/0x120
[   89.734842]  generic_writepages+0x4c/0x80
[   89.736830]  do_writepages+0x34/0xc0
[   89.738390]  ? __fsnotify_parent+0xe7/0x2d0
[   89.740196]  __filemap_fdatawrite_range+0xc5/0x100
[   89.742245]  file_write_and_wait_range+0x61/0xb0
[   89.744219]  blkdev_fsync+0x17/0x40
[   89.745777]  __x64_sys_fsync+0x34/0x60
[   89.747446]  do_syscall_64+0x33/0x80
[   89.749341]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   89.753171] RIP: 0033:0x7f0a320b37a0
[   89.754777] Code: 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 83 3d 69 cf 2b 00 00 75 10 b8 4a 00 00 00 0f 05 
<48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 4e 3d 01 00 48 89 04 24
[   89.762134] RSP: 002b:00007ffdb7a55158 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
[   89.765245] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0a320b37a0
[   89.770073] RDX: 0000000000000400 RSI: 000055797fd3e620 RDI: 0000000000000003
[   89.773025] RBP: 000055797fd3e510 R08: 0000000004800800 R09: 00007f0a32e08c40
[   89.775864] R10: 0000000004800800 R11: 0000000000000246 R12: 00007ffdb7a551c0
[   89.778680] R13: 00007ffdb7a551c8 R14: 000055797fd3e2e0 R15: 0000000000000000
[   89.781984] Modules linked in: dm_snapshot dm_bufio dm_mod loop hid_generic usbhid hid uhci_hcd ehci_hcd virtio_net net_failover ppdev failover 
joydev usbcore parport_pc psmouse evdev pcspkr serio_raw parport ata_generic floppy i2c_piix4 virtio_pci sg usb_common ata_piix virtio_ring virtio 
button qemu_fw_cfg ip_tables x_tables autofs4 crc32c_generic ext4 crc16 mbcache jbd2 sd_mod t10_pi crc_t10dif crct10dif_common ahci libahci libata 
scsi_mod
[   89.799301] ---[ end trace 1aa4a3cf509dc9b7 ]---

(block/bio.c:1473 is this:
struct bio *bio_split(struct bio *bio, int sectors,
                       gfp_t gfp, struct bio_set *bs)
{
         struct bio *split;

         BUG_ON(sectors <= 0);                   <==== here
         BUG_ON(sectors >= bio_sectors(bio));
)

I don't know what the problem with this is, but the kernel should
definitely not crash this easy, taking down whole system with it...

The same happens when at least one snapshot target is also associated
with this loop device, or when snapshot-origin is created on another
dm target instead of a loop device directly.

Can we finally, after so many years, fix at least the most grave
issues here, please? :)

Thanks!

/mjt

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

