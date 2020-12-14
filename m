Return-Path: <SRS0=VSmt=FT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475CDC4361B
	for <dm-devel@archiver.kernel.org>; Tue, 15 Dec 2020 10:00:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 400C12220F
	for <dm-devel@archiver.kernel.org>; Tue, 15 Dec 2020 10:00:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 400C12220F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-Pd1hmp92PuOWix3WQucZcQ-1; Tue, 15 Dec 2020 04:59:58 -0500
X-MC-Unique: Pd1hmp92PuOWix3WQucZcQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A85810766C2;
	Tue, 15 Dec 2020 09:59:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E39071C94;
	Tue, 15 Dec 2020 09:59:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 02FA64A7C6;
	Tue, 15 Dec 2020 09:59:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BEIY1CD014423 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Dec 2020 13:34:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 391732026D47; Mon, 14 Dec 2020 18:34:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 345892026D46
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 18:33:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 527E8858280
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 18:33:57 +0000 (UTC)
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-226-pe7TU46iN_qbEeRr8jmd8Q-1; Mon, 14 Dec 2020 13:33:55 -0500
X-MC-Unique: pe7TU46iN_qbEeRr8jmd8Q-1
Received: from MUA by vps-vb.mhejs.net with esmtps
	(TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128) (Exim 4.93.0.4)
	(envelope-from <mail@maciej.szmigiero.name>)
	id 1kosK4-0000TN-Ti; Mon, 14 Dec 2020 19:11:48 +0100
To: Ignat Korchagin <ignat@cloudflare.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <16ffadab-42ba-f9c7-8203-87fda3dc9b44@maciej.szmigiero.name>
Date: Mon, 14 Dec 2020 19:11:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.5.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 15 Dec 2020 04:59:49 -0500
Cc: Damien.LeMoal@wdc.com, herbert@gondor.apana.org.au, snitzer@redhat.com,
	kernel-team@cloudflare.com, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org, nobuto.murata@canonical.com,
	ebiggers@kernel.org, Chris Mason <clm@fb.com>,
	dm-devel@redhat.com, mpatocka@redhat.com,
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>, agk@redhat.com
Subject: [dm-devel] dm-crypt with no_read_workqueue and no_write_workqueue +
 btrfs scrub = BUG()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi,

I hit a reproducible BUG() when scrubbing a btrfs fs on top of
a dm-crypt device with no_read_workqueue and no_write_workqueue
flags enabled.

Steps to reproduce:
1) cryptsetup create -c aes -d /dev/urandom test /dev/vdb1
2) dmsetup table test --showkeys | sed 's/$/ 2 no_read_workqueue no_write_workqueue/' | dmsetup reload test
3) dmsetup suspend test && dmsetup resume test
4) mkfs.btrfs /dev/mapper/test
5) mkdir /tmp/test; mount -t btrfs /dev/mapper/test /tmp/test/
6) dd if=/dev/zero of=/tmp/test/test bs=1M count=900; sync
7) btrfs scrub start /tmp/test

The result is:
[ 2965.025717][    C0] BUG: sleeping function called from invalid context at mm/mempool.c:381
[ 2965.025721][    C0] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2848, name: kworker/u4:0
[ 2965.025726][    C0] CPU: 0 PID: 2848 Comm: kworker/u4:0 Tainted: G                T 5.10.0-rc3+ #278
[ 2965.025727][    C0] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[ 2965.025735][    C0] Workqueue: btrfs-scrub btrfs_work_helper
[ 2965.025738][    C0] Call Trace:
[ 2965.025759][    C0]  <IRQ>
[ 2965.025766][    C0]  dump_stack+0x57/0x6a
[ 2965.025771][    C0]  ___might_sleep.cold+0x8a/0x97
[ 2965.025776][    C0]  mempool_alloc+0xcb/0x1b0
[ 2965.025781][    C0]  ? crypto_skcipher_decrypt+0x5c/0x80
[ 2965.025786][    C0]  crypt_convert+0xdf0/0xfa0
[ 2965.025793][    C0]  ? update_load_avg+0x92/0x650
[ 2965.025798][    C0]  kcryptd_crypt_read_convert+0xc5/0x100
[ 2965.025802][    C0]  tasklet_action_common.constprop.0+0xfa/0x120
[ 2965.025807][    C0]  __do_softirq+0xc4/0x2a8
[ 2965.025811][    C0]  asm_call_irq_on_stack+0x12/0x20
[ 2965.025814][    C0]  </IRQ>
[ 2965.025818][    C0]  do_softirq_own_stack+0x36/0x40
[ 2965.025821][    C0]  irq_exit_rcu+0x8d/0xc0
[ 2965.025825][    C0]  sysvec_call_function_single+0x36/0x80
[ 2965.025829][    C0]  asm_sysvec_call_function_single+0x12/0x20
[ 2965.025833][    C0] RIP: 0010:crc_18+0xa/0x1e
[ 2965.025837][    C0] Code: ff ff f2 4c 0f 38 f1 81 68 ff ff ff f2 4c 0f 38 f1 8a 68 ff ff ff f2 4d 0f 38 f1 93 68 ff ff ff f2 4c 0f 38 f1 81 70 ff ff ff <f2> 4c 0f 38 f1 8a 70 ff ff ff f2 4d 0f 38 f1 93 70 ff ff ff f2 4c
[ 2965.025839][    C0] RSP: 0018:ffffa2d04023bbf0 EFLAGS: 00000246
[ 2965.025842][    C0] RAX: 0000000000000080 RBX: 0000000000001000 RCX: ffff96e1851ef400
[ 2965.025844][    C0] RDX: ffff96e1851ef800 RSI: 0000000000001000 RDI: 0000000000000000
[ 2965.025845][    C0] RBP: ffff96e1851ef000 R08: 000000000ae37425 R09: 0000000000000000
[ 2965.025847][    C0] R10: 0000000000000000 R11: ffff96e1851efc00 R12: 0000000000001000
[ 2965.025848][    C0] R13: ffff96e18e9a6a80 R14: fffff68440000000 R15: ffff96e184d73c00
[ 2965.025854][    C0]  ? crc32c_pcl_intel_digest+0xa0/0xc0
[ 2965.025857][    C0]  ? scrub_checksum_data+0x126/0x180
[ 2965.025861][    C0]  ? update_load_avg+0x92/0x650
[ 2965.025863][    C0]  ? cpuacct_charge+0x35/0x80
[ 2965.025867][    C0]  ? check_preempt_wakeup+0xef/0x260
[ 2965.025872][    C0]  ? radix_tree_gang_lookup+0xa1/0xd0
[ 2965.025875][    C0]  ? __wake_up_common_lock+0x8a/0xc0
[ 2965.025878][    C0]  ? scrub_block_put+0x5c/0xa0
[ 2965.025880][    C0]  ? scrub_bio_end_io_worker+0x52/0x220
[ 2965.025884][    C0]  ? kfree+0x3ec/0x450
[ 2965.025887][    C0]  ? scrub_bio_end_io_worker+0xd7/0x220
[ 2965.025890][    C0]  ? btrfs_work_helper+0xdb/0x350
[ 2965.025893][    C0]  ? __schedule+0x275/0x8c0
[ 2965.025897][    C0]  ? process_one_work+0x1d6/0x3b0
[ 2965.025901][    C0]  ? worker_thread+0x53/0x400
[ 2965.025904][    C0]  ? rescuer_thread+0x440/0x440
[ 2965.025907][    C0]  ? kthread+0x13f/0x160
[ 2965.025910][    C0]  ? __kthread_bind_mask+0xa0/0xa0
[ 2965.025913][    C0]  ? ret_from_fork+0x22/0x30

Additionally, here is a similar BUG() backtrace I've hit on
another system, while scrubbing a btrfs fs on dm-crypt devs
with these flags enabled, the BUG() hit here was actually
scheduling while atomic:
  <IRQ>
  dump_stack+0x57/0x6a
  __schedule_bug.cold+0x47/0x53
  __schedule+0x643/0x7d0
  schedule+0x62/0xd0
  schedule_timeout+0x135/0x180
  ? cryptd_enqueue_request+0x5e/0xd0
  wait_for_completion+0x84/0xe0
  crypt_convert.constprop.0+0x7a7/0xf60
  ? crypt_endio+0x2d/0x90
  ? kmem_cache_free+0x416/0x470
  ? ktime_get+0x4a/0xc0
  kcryptd_crypt_read_convert+0xbe/0x100
  blk_update_request+0x229/0x3d0
  scsi_end_request+0x40/0x200
  scsi_io_completion+0x8e/0x5b0
  blk_done_softirq+0x87/0xb0
  __do_softirq+0xd3/0x2ed
  asm_call_irq_on_stack+0x12/0x20
  </IRQ>
  do_softirq_own_stack+0x36/0x40
  irq_exit_rcu+0x8d/0xc0
  common_interrupt+0x87/0x160
  asm_common_interrupt+0x1e/0x40
RIP: 0010:_aesni_dec4+0x2f/0x190
Code: fa 66 0f ef c2 66 0f ef e2 66 0f ef ea 66 0f ef f2 49 83 c2 30 41 83 f9 18 72 70 4d 8d 52 20 74 36 49 83 c2 20 41 0f 28 52 a0 <66> 0f 38 de c2 66 0f 38 de e2 66 0f 3
  ? _aesni_dec1+0xb0/0xb0
  ? _aesni_dec1+0xb0/0xb0
  ? aesni_xts_crypt8+0xe0/0x240
  ? __glue_xts_req_128bit+0x8f/0xc0
  ? glue_xts_req_128bit+0xc1/0x400
  ? aesni_set_key+0x1e0/0x1e0
  ? ttwu_queue_wakelist+0xb9/0xe0
  ? kcryptd_async_done+0xa6/0x210
  ? kcryptd_async_done+0xa6/0x210
  ? kfree+0x401/0x460
  ? kcryptd_async_done+0xa6/0x210
  ? crypto_skcipher_decrypt+0x4b/0x80
  ? cryptd_skcipher_decrypt+0xa6/0x130
  ? update_load_avg+0x7e/0x660
  ? set_next_entity+0xcd/0x240
  ? __switch_to_asm+0x3f/0x60
  ? finish_task_switch+0x87/0x280
  ? __schedule+0x263/0x7d0
  ? preempt_schedule+0x32/0x50
  ? preempt_schedule_thunk+0x16/0x18
  ? cryptd_queue_worker+0x8b/0xe0
  ? process_one_work+0x1d4/0x3d0
  ? worker_thread+0x50/0x3f0
  ? rescuer_thread+0x420/0x420
  ? kthread+0x134/0x160
  ? __kthread_bind_mask+0xa0/0xa0
  ? ret_from_fork+0x22/0x30

It looks like to me that the dm-crypt code in kcryptd_queue_crypt()
checks for a hard IRQ context via in_irq() before deciding whether to
offload processing to a tasklet or proceed directly, but it probably
should check for any interrupt context via in_interrupt() or similar
and then proceed with using a workqueue, as the ordinary code flow
does.

CC'ing btrfs folks in case it is actually a btrfs-specific issue.

Thanks,
Maciej

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

