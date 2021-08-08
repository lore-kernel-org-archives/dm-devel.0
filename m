Return-Path: <SRS0=ry1C=NA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947B8C4338F
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:54:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2A7C960EE9
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:54:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2A7C960EE9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=corelight.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-PjwavlfFMIGst4JKQSI0Uw-1; Mon, 09 Aug 2021 02:54:02 -0400
X-MC-Unique: PjwavlfFMIGst4JKQSI0Uw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB74C180FCBC;
	Mon,  9 Aug 2021 06:53:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C3F5B604CC;
	Mon,  9 Aug 2021 06:53:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9C01D4A707;
	Mon,  9 Aug 2021 06:53:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 178DhFkv030865 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 8 Aug 2021 09:43:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 62791568EA; Sun,  8 Aug 2021 13:43:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D856568E8
	for <dm-devel@redhat.com>; Sun,  8 Aug 2021 13:43:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE58D800883
	for <dm-devel@redhat.com>; Sun,  8 Aug 2021 13:43:12 +0000 (UTC)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
	[209.85.221.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-552-WpZtjz4MNjiKR0G1Eczcww-1; Sun, 08 Aug 2021 09:43:10 -0400
X-MC-Unique: WpZtjz4MNjiKR0G1Eczcww-1
Received: by mail-wr1-f46.google.com with SMTP id c9so17674374wri.8
	for <dm-devel@redhat.com>; Sun, 08 Aug 2021 06:43:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=Cmem1dLMJ0CRtSIpGPuywVWqVDPZcLOwVJWKWNAdjOM=;
	b=kojcWtbinhchuKLWVHXWrUgxEOSO3+OF2LWcl8eP+Lm4rIuVdtJLy9N9Gmz/994nop
	kukhbpdmpyBYkzx91FIKIHnMlIYEegD3v5E+wGyo563T4232SwYP6tjiq5b3YzGfn73t
	B7w3zrwT7fnB6YqfYTCaR5z71Jl3wUtbpsYExkvkkUPXrug5S70m3MAWZXeSzysFiY4D
	iFdYphrefr47kATIx24fQDTOQlDVqbu6N3gVeEO8o7gzeW0HuzL6cITNdQOgRIkbkk4d
	O4sbsaTd8Kbzy2d0W74ViWFxAuDu16h699JKST0OiDRcnOg7nS669yl3klJbrEs78L+F
	YXHA==
X-Gm-Message-State: AOAM533+Iz6lHGKB54oIJ3gRWX6K+Ye+0IcbXVvGoKKPG+Mc1Y0FUFow
	ABv0T+fdqH2LBl8hZlbvSmMfWXZDpO7M5p+3/xh84IqaiZm2nAeV+xQV1R7KqQGGCMsH4xSTuv2
	huMhy4nC4c6GGFHIGuFNZWjrBhbVvjdy1SlSP2tIRShwpcruqN/X4G6hgm2HE4Xp15OKY/Sewyw
	JA
X-Google-Smtp-Source: ABdhPJx46iXM132tPldyO1vewOickk5yIPhPYk/Y4BNlseNSOLyW4daAQMs3sK8WPbHoKK9nVeLfEA==
X-Received: by 2002:adf:d1e3:: with SMTP id g3mr20220584wrd.104.1628430189387; 
	Sun, 08 Aug 2021 06:43:09 -0700 (PDT)
Received: from tinkyx280.. (ip-109-42-112-123.web.vodafone.de.
	[109.42.112.123]) by smtp.gmail.com with ESMTPSA id
	w18sm17347608wrg.68.2021.08.08.06.43.08
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sun, 08 Aug 2021 06:43:09 -0700 (PDT)
From: Arne Welzel <arne.welzel@corelight.com>
To: dm-devel@redhat.com, dm-crypt@saout.de
Date: Sun,  8 Aug 2021 15:42:05 +0200
Message-Id: <20210808134205.1981531-1-arne.welzel@corelight.com>
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
X-Mailman-Approved-At: Mon, 09 Aug 2021 02:53:04 -0400
Cc: Arne Welzel <arne.welzel@corelight.com>, DJ Gregor <dj@corelight.com>,
	mpatocka@redhat.com, agk@redhat.com, snitzer@redhat.com
Subject: [dm-devel] [PATCH] dm crypt: Avoid percpu_counter spinlock
	contention in crypt_page_alloc()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On many core systems using dm-crypt, heavy spinlock contention in
percpu_counter_compare() can be observed when the dmcrypt page allocation
limit for a given device is reached or close to be reached. This is due
to percpu_counter_compare() taking a spinlock to compute an exact
result on potentially many CPUs at the same time.

Switch to non-exact comparison of allocated and allowed pages by using
the value returned by percpu_counter_read_positive().

This may over/under estimate the actual number of allocated pages by at
most (batch-1) * num_online_cpus() (assuming my understanding of the
percpu_counter logic is proper).

Currently, batch is bounded by 32. The system on which this issue was
first observed has 256 CPUs and 512G of RAM. With a 4k page size, this
change may over/under estimate by 31MB. With ~10G (2%) allowed for dmcrypt
allocations, this seems an acceptable error. Certainly preferred over
running into the spinlock contention.

This behavior was separately/artificially reproduced on an EC2 c5.24xlarge
instance system with 96 CPUs and 192GB RAM as follows, but can be
provokes on systems with less available CPUs.

 * Disable swap
 * Tune vm settings to promote regular writeback
     $ echo 50 > /proc/sys/vm/dirty_expire_centisecs
     $ echo 25 > /proc/sys/vm/dirty_writeback_centisecs
     $ echo $((128 * 1024 * 1024)) > /proc/sys/vm/dirty_background_bytes

 * Create 8 dmcrypt devices based on files on a tmpfs
 * Create and mount an ext4 filesystem on each crypt devices
 * Run stress-ng --hdd 8 within one of above filesystems

Total %system usage shown via sysstat goes to ~35%, write througput on the
underlying loop device is ~2GB/s. perf profiling an individual kworker
kcryptd thread shows the following in the profile, indicating it hits
heavy spinlock contention in percpu_counter_compare():

    99.98%     0.00%  kworker/u193:46  [kernel.kallsyms]  [k] ret_from_fork
            |
            ---ret_from_fork
               kthread
               worker_thread
               |
                --99.92%--process_one_work
                          |
                          |--80.52%--kcryptd_crypt
                          |          |
                          |          |--62.58%--mempool_alloc
                          |          |          |
                          |          |           --62.24%--crypt_page_alloc
                          |          |                     |
                          |          |                      --61.51%--__percpu_counter_compare
                          |          |                                |
                          |          |                                 --61.34%--__percpu_counter_sum
                          |          |                                           |
                          |          |                                           |--58.68%--_raw_spin_lock_irqsave
                          |          |                                           |          |
                          |          |                                           |           --58.30%--native_queued_spin_lock_slowpath
                          |          |                                           |
                          |          |                                            --0.69%--cpumask_next
                          |          |                                                      |
                          |          |                                                       --0.51%--_find_next_bit
                          |          |
                          |          |--10.61%--crypt_convert
                          |          |          |
                          |          |          |--6.05%--xts_crypt
                          ...

After apply this change, %system usage is lowered to ~7% and
write throughput on the loopback interface increases to 2.7GB/s.
The profile shows mempool_alloc() as ~8% rather than ~62% in the
profile and not hitting the percpu_counter() spinlock anymore.

    |--8.15%--mempool_alloc
    |          |
    |          |--3.93%--crypt_page_alloc
    |          |          |
    |          |           --3.75%--__alloc_pages
    |          |                     |
    |          |                      --3.62%--get_page_from_freelist
    |          |                                |
    |          |                                 --3.22%--rmqueue_bulk
    |          |                                           |
    |          |                                            --2.59%--_raw_spin_lock
    |                                                      |
    |          |                                                       --2.57%--native_queued_spin_lock_slowpath
    |          |
    |           --3.05%--_raw_spin_lock_irqsave
    |                     |
    |                      --2.49%--native_queued_spin_lock_slowpath

Suggested-by: DJ Gregor <dj@corelight.com>
Signed-off-by: Arne Welzel <arne.welzel@corelight.com>
---
 drivers/md/dm-crypt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 50f4cbd600d5..2ae481610f12 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2661,7 +2661,12 @@ static void *crypt_page_alloc(gfp_t gfp_mask, void *pool_data)
 	struct crypt_config *cc = pool_data;
 	struct page *page;
 
-	if (unlikely(percpu_counter_compare(&cc->n_allocated_pages, dm_crypt_pages_per_client) >= 0) &&
+	/*
+	 * Note, percpu_counter_read_positive() may over (and under) estimate
+	 * the current usage by at most (batch - 1) * num_online_cpus() pages,
+	 * but avoids potential spinlock contention of an exact result.
+	 */
+	if (unlikely(percpu_counter_read_positive(&cc->n_allocated_pages) > dm_crypt_pages_per_client) &&
 	    likely(gfp_mask & __GFP_NORETRY))
 		return NULL;
 
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

