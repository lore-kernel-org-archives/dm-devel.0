Return-Path: <SRS0=kuEZ=GQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A62C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 19:17:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 108B0217BA
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 19:17:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 108B0217BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-YWydTXiaMiaPlIPjM_Jn8Q-1; Wed, 13 Jan 2021 14:17:54 -0500
X-MC-Unique: YWydTXiaMiaPlIPjM_Jn8Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B80C6BBEE2;
	Wed, 13 Jan 2021 19:17:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7696760C7D;
	Wed, 13 Jan 2021 19:17:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D85A44A7C6;
	Wed, 13 Jan 2021 19:17:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10DJHklp017185 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Jan 2021 14:17:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E6EDA101B865; Wed, 13 Jan 2021 19:17:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E2C4F101B73B
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 19:17:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F19E800296
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 19:17:42 +0000 (UTC)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
	[209.85.221.48]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-475-eHSB3g8ANM-WNIGMYasYXg-1; Wed, 13 Jan 2021 14:17:39 -0500
X-MC-Unique: eHSB3g8ANM-WNIGMYasYXg-1
Received: by mail-wr1-f48.google.com with SMTP id w5so3302194wrm.11
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 11:17:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=BT6sc0LO7SzeOpKivqGcn1BjVwvAbMsr3JIitlBMX5Y=;
	b=WSLN/Bo7HacZ5duml7NfZ9xsWsQg2xqf0A88lpagGGqAT+iKxPzVZ6sBC+TyTZrUbq
	pXBS18ZgDfILIHlI3Pd+nOMWStNJ2dALEDvz5vKoJPwdXCf8TOZA81IoimvbxqCeC8Rv
	p9I9Fr7K0Pb79dd3VJjnUBqQRiAzqJ4Hv37BPfOHDGk27ZtKpfQLi0H15wCVPI1v4fO/
	aFMQ5o4r/qfBwaVfs8NpTcDzgoHsK8Jg0Ijf6xvZ0+8ifE5KTEEzWb1coJAUiZ1pj0uw
	Pi6De/j9QsHxko/zExsIo4BwDeLdvL36jeSMoGEDVAbCWRJ83Z5KEpWzGCfsrenVKRC8
	8A4g==
X-Gm-Message-State: AOAM5319GFp+8xfBUcon2RD+eOCQTt4WejGm6czrSuOGflfimcGs1TNB
	taIjhi+fYSHRI8sLTDvvXReL3Q==
X-Google-Smtp-Source: ABdhPJzsLL4mdNTwqMFjJceUqcEp0acXy3/jj4mBN6qWL9f7kvjPvrAVV9xgxTfuHL833oldgRzabA==
X-Received: by 2002:a5d:40ce:: with SMTP id b14mr4040202wrq.350.1610565457971; 
	Wed, 13 Jan 2021 11:17:37 -0800 (PST)
Received: from dev.cfops.net (29.177.200.146.dyn.plus.net. [146.200.177.29])
	by smtp.gmail.com with ESMTPSA id w8sm4804681wrl.91.2021.01.13.11.17.36
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 13 Jan 2021 11:17:37 -0800 (PST)
From: Ignat Korchagin <ignat@cloudflare.com>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org
Date: Wed, 13 Jan 2021 19:17:17 +0000
Message-Id: <20210113191717.1439-1-ignat@cloudflare.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: kernel-team@cloudflare.com, stable@vger.kernel.org,
	Ignat Korchagin <ignat@cloudflare.com>
Subject: [dm-devel] [PATCH] dm crypt: defer the decryption to a tasklet,
	when being called with interrupts disabled
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On some specific hardware on early boot we occasionally get

[ 1193.920255][    T0] BUG: sleeping function called from invalid context at mm/mempool.c:381
[ 1193.936616][    T0] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 0, name: swapper/69
[ 1193.953233][    T0] no locks held by swapper/69/0.
[ 1193.965871][    T0] irq event stamp: 575062
[ 1193.977724][    T0] hardirqs last  enabled at (575061): [<ffffffffab73f662>] tick_nohz_idle_exit+0xe2/0x3e0
[ 1194.002762][    T0] hardirqs last disabled at (575062): [<ffffffffab74e8af>] flush_smp_call_function_from_idle+0x4f/0x80
[ 1194.029035][    T0] softirqs last  enabled at (575050): [<ffffffffad600fd2>] asm_call_irq_on_stack+0x12/0x20
[ 1194.054227][    T0] softirqs last disabled at (575043): [<ffffffffad600fd2>] asm_call_irq_on_stack+0x12/0x20
[ 1194.079389][    T0] CPU: 69 PID: 0 Comm: swapper/69 Not tainted 5.10.6-cloudflare-kasan-2021.1.4-dev #1
[ 1194.104103][    T0] Hardware name: NULL R162-Z12-CD/MZ12-HD4-CD, BIOS R10 06/04/2020
[ 1194.119591][    T0] Call Trace:
[ 1194.130233][    T0]  dump_stack+0x9a/0xcc
[ 1194.141617][    T0]  ___might_sleep.cold+0x180/0x1b0
[ 1194.153825][    T0]  mempool_alloc+0x16b/0x300
[ 1194.165313][    T0]  ? remove_element+0x160/0x160
[ 1194.176961][    T0]  ? blk_mq_end_request+0x4b/0x490
[ 1194.188778][    T0]  crypt_convert+0x27f6/0x45f0 [dm_crypt]
[ 1194.201024][    T0]  ? rcu_read_lock_sched_held+0x3f/0x70
[ 1194.212906][    T0]  ? module_assert_mutex_or_preempt+0x3e/0x70
[ 1194.225318][    T0]  ? __module_address.part.0+0x1b/0x3a0
[ 1194.237212][    T0]  ? is_kernel_percpu_address+0x5b/0x190
[ 1194.249238][    T0]  ? crypt_iv_tcw_ctr+0x4a0/0x4a0 [dm_crypt]
[ 1194.261593][    T0]  ? is_module_address+0x25/0x40
[ 1194.272905][    T0]  ? static_obj+0x8a/0xc0
[ 1194.283582][    T0]  ? lockdep_init_map_waits+0x26a/0x700
[ 1194.295570][    T0]  ? __raw_spin_lock_init+0x39/0x110
[ 1194.307330][    T0]  kcryptd_crypt_read_convert+0x31c/0x560 [dm_crypt]
[ 1194.320496][    T0]  ? kcryptd_queue_crypt+0x1be/0x380 [dm_crypt]
[ 1194.333203][    T0]  blk_update_request+0x6d7/0x1500
[ 1194.344841][    T0]  ? blk_mq_trigger_softirq+0x190/0x190
[ 1194.356831][    T0]  blk_mq_end_request+0x4b/0x490
[ 1194.367994][    T0]  ? blk_mq_trigger_softirq+0x190/0x190
[ 1194.379693][    T0]  flush_smp_call_function_queue+0x24b/0x560
[ 1194.391847][    T0]  flush_smp_call_function_from_idle+0x59/0x80
[ 1194.403969][    T0]  do_idle+0x287/0x450
[ 1194.413891][    T0]  ? arch_cpu_idle_exit+0x40/0x40
[ 1194.424716][    T0]  ? lockdep_hardirqs_on_prepare+0x286/0x3f0
[ 1194.436399][    T0]  ? _raw_spin_unlock_irqrestore+0x39/0x40
[ 1194.447759][    T0]  cpu_startup_entry+0x19/0x20
[ 1194.458038][    T0]  secondary_startup_64_no_verify+0xb0/0xbb

IO completion can be queued to a different CPU by the block subsystem as a "call
single function/data". The CPU may run these routines from the idle task, but it
does so with interrupts disabled.

It is not a good idea to do decryption with irqs disabled even in an idle task
context, so just defer it to a tasklet as with requests from hard irqs.

Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Cc: <stable@vger.kernel.org> # v5.9+
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 drivers/md/dm-crypt.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 53791138d78b..c56b01bfdb60 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2091,8 +2091,11 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 
 	if ((bio_data_dir(io->base_bio) == READ && test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags)) ||
 	    (bio_data_dir(io->base_bio) == WRITE && test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))) {
-		if (in_irq()) {
-			/* Crypto API's "skcipher_walk_first() refuses to work in hard IRQ context */
+		/* in_irq(): Crypto API's "skcipher_walk_first() refuses to work in hard IRQ context.
+		 * irqs_disabled(): the kernel may run some IO completion from the idle thread, but
+		   it is being executed with irqs disabled.
+		 */
+		if (in_irq() || irqs_disabled()) {
 			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
 			tasklet_schedule(&io->tasklet);
 			return;
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

