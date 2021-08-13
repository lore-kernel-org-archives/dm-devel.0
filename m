Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F82EC4320A
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A552160C3E
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A552160C3E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=corelight.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-LY2ZMDPlNDqMSsUFALcBYA-1; Tue, 17 Aug 2021 03:26:29 -0400
X-MC-Unique: LY2ZMDPlNDqMSsUFALcBYA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D2FF801AEB;
	Tue, 17 Aug 2021 07:26:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7118160871;
	Tue, 17 Aug 2021 07:26:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1F1464A7C9;
	Tue, 17 Aug 2021 07:26:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17DMfLBa022511 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 13 Aug 2021 18:41:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1D3B520C1819; Fri, 13 Aug 2021 22:41:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18E4C20C17B0
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 22:41:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D1C1101A529
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 22:41:18 +0000 (UTC)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
	[209.85.221.45]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-1-PgZ60OOHMiKnOhcv3R6x_w-1; Fri, 13 Aug 2021 18:41:16 -0400
X-MC-Unique: PgZ60OOHMiKnOhcv3R6x_w-1
Received: by mail-wr1-f45.google.com with SMTP id x10so8910315wrt.8
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 15:41:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=reYkrPb9IzyQkLq8C5/o3ZHeHUXILqYSBFW9CW/iaEg=;
	b=EiCopHpQgqisjRy6t+lenKoyj8olPRpLL+aFhUX4hr4c6NFaiWlt/MwjckKlJmDjtM
	lMXT7JzfcZY4Yr/yO1BUTPqUKCPx3QlTbt0nPZ/vALRB8ErUbw3RGgtN25fdfrmkUPIQ
	n1WKCygmR55PzumwYCVSTXxz0NMr4ZGUQao+QhkMijL/7/l891cBBSMvRv8NXTLEmzQR
	w1nOWeg1ma1lqbEgkqS5Stqsdqs8EY+XkqvxgSrzhLCxVp5v5y86XC4WbTJMotXHQH74
	q9ePW1vZM0uLEHfbQkFocpBnVlzsQHPyckoSPJAFIvgepIxGVJp4wJ7NO/6Sz7t4UOxV
	oJSA==
X-Gm-Message-State: AOAM533i7VhLYEfTBohMd+pftrq0ylK9Da9sul8qC5BqNP86HWsW68Pe
	aoqrfooVF3uES9YNS48K2q1SR/Xv8uLVrq9zL2o/1QC4LYrrR3peJrLdGCgJ6ZaCQ6yfxHQjZN9
	QBsHJxTpEsDlyW8Q83QPT4kR2yOPDx8GHNoBSebxa+Qa0lihlD13gd4X/vQiHyIvBG5/ZB5Z4v1
	no
X-Google-Smtp-Source: ABdhPJzdQ1qMd/+aRlJm0dV1lNAJiSUkcBHUbpqV18ATEIgrSACwRjHZNPq+aB23b2WCAjYZbR7QOg==
X-Received: by 2002:adf:a3cb:: with SMTP id m11mr5533190wrb.268.1628894475354; 
	Fri, 13 Aug 2021 15:41:15 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8108:8440:5da4:6c41:9e8b:2e76:271])
	by smtp.gmail.com with ESMTPSA id
	q75sm2863867wme.40.2021.08.13.15.41.14
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 13 Aug 2021 15:41:14 -0700 (PDT)
From: Arne Welzel <arne.welzel@corelight.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Sat, 14 Aug 2021 00:40:38 +0200
Message-Id: <20210813224038.2055684-1-arne.welzel@corelight.com>
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
X-Mailman-Approved-At: Tue, 17 Aug 2021 03:26:00 -0400
Cc: Mikulas Patocka <mpatocka@redhat.com>, DJ Gregor <dj@corelight.com>,
	linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH v2] dm crypt: Avoid percpu_counter spinlock
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On systems with many cores using dm-crypt, heavy spinlock contention in
percpu_counter_compare() can be observed when the page allocation limit
for a given device is reached or close to be reached. This is due
to percpu_counter_compare() taking a spinlock to compute an exact
result on potentially many CPUs at the same time.

Switch to non-exact comparison of allocated and allowed pages by using
the value returned by percpu_counter_read_positive() to avoid taking
the percpu_counter spinlock.

This may over/under estimate the actual number of allocated pages by at
most (batch-1) * num_online_cpus().

Currently, batch is bounded by 32. The system on which this issue was
first observed has 256 CPUs and 512GB of RAM. With a 4k page size, this
change may over/under estimate by 31MB. With ~10G (2%) allowed dm-crypt
allocations, this seems an acceptable error. Certainly preferred over
running into the spinlock contention.

This behavior was reproduced on an EC2 c5.24xlarge instance with 96 CPUs
and 192GB RAM as follows, but can be provoked on systems with less CPUs
as well.

 * Disable swap
 * Tune vm settings to promote regular writeback
     $ echo 50 > /proc/sys/vm/dirty_expire_centisecs
     $ echo 25 > /proc/sys/vm/dirty_writeback_centisecs
     $ echo $((128 * 1024 * 1024)) > /proc/sys/vm/dirty_background_bytes

 * Create 8 dmcrypt devices based on files on a tmpfs
 * Create and mount an ext4 filesystem on each crypt devices
 * Run stress-ng --hdd 8 within one of above filesystems

Total %system usage collected from sysstat goes to ~35%. Write throughput
on the underlying loop device is ~2GB/s. perf profiling an individual
kworker kcryptd thread shows the following profile, indicating spinlock
contention in percpu_counter_compare():

    99.98%     0.00%  kworker/u193:46  [kernel.kallsyms]  [k] ret_from_fork
      |
      --ret_from_fork
        kthread
        worker_thread
        |
         --99.92%--process_one_work
            |
            |--80.52%--kcryptd_crypt
            |    |
            |    |--62.58%--mempool_alloc
            |    |  |
            |    |   --62.24%--crypt_page_alloc
            |    |     |
            |    |      --61.51%--__percpu_counter_compare
            |    |        |
            |    |         --61.34%--__percpu_counter_sum
            |    |           |
            |    |           |--58.68%--_raw_spin_lock_irqsave
            |    |           |  |
            |    |           |   --58.30%--native_queued_spin_lock_slowpath
            |    |           |
            |    |            --0.69%--cpumask_next
            |    |                |
            |    |                 --0.51%--_find_next_bit
            |    |
            |    |--10.61%--crypt_convert
            |    |          |
            |    |          |--6.05%--xts_crypt
            ...

After applying this patch and running the same test, %system usage is
lowered to ~7% and write throughput on the loop device increases
to ~2.7GB/s. perf report shows mempool_alloc() as ~8% rather than ~62%
in the profile and not hitting the percpu_counter() spinlock anymore.

    |--8.15%--mempool_alloc
    |    |
    |    |--3.93%--crypt_page_alloc
    |    |    |
    |    |     --3.75%--__alloc_pages
    |    |         |
    |    |          --3.62%--get_page_from_freelist
    |    |              |
    |    |               --3.22%--rmqueue_bulk
    |    |                   |
    |    |                    --2.59%--_raw_spin_lock
    |    |                      |
    |    |                       --2.57%--native_queued_spin_lock_slowpath
    |    |
    |     --3.05%--_raw_spin_lock_irqsave
    |               |
    |                --2.49%--native_queued_spin_lock_slowpath

Suggested-by: DJ Gregor <dj@corelight.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Arne Welzel <arne.welzel@corelight.com>
---

v2: Change condition from > to >=, update patch description

 drivers/md/dm-crypt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 50f4cbd600d5..8c0c3d1f54bb 100644
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
+	if (unlikely(percpu_counter_read_positive(&cc->n_allocated_pages) >= dm_crypt_pages_per_client) &&
 	    likely(gfp_mask & __GFP_NORETRY))
 		return NULL;
 
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

