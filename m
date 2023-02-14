Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1899C636CC
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 09:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676453643;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=410nEqr0fsFOYPMUJU3xGTGQPDSrRu43cVADwmxLOSE=;
	b=FcpK7AGQiLz3hHDG2GjdjLsrTqvb3BHO/15wFDThdEXV/Je5PrmdTEcVow/YNJopDaFsGS
	WmFUglrBolgxTb5vy4b789f8uXr/dL8h6A1Ewt19hef4iLYw23yFUf+yTPZQxleQbPGZXt
	yztJMsKYU8MzLAlGHWBuDusytRC+NIg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-gw_eNNN_NtO1cu0z92rtrg-1; Wed, 15 Feb 2023 04:33:46 -0500
X-MC-Unique: gw_eNNN_NtO1cu0z92rtrg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B38D857A9F;
	Wed, 15 Feb 2023 09:33:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 01BCC140EBF4;
	Wed, 15 Feb 2023 09:33:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 09C7F1946586;
	Wed, 15 Feb 2023 09:33:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 254851946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Feb 2023 19:02:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DA0CD40C10FA; Tue, 14 Feb 2023 19:02:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D228D40C1423
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 19:02:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B682B858F0E
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 19:02:38 +0000 (UTC)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com
 [209.85.166.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-452-3hocj9XyMh-x1KOt-tAtvQ-1; Tue, 14 Feb 2023 14:02:36 -0500
X-MC-Unique: 3hocj9XyMh-x1KOt-tAtvQ-1
Received: by mail-il1-f170.google.com with SMTP id f10so6651917ilc.7;
 Tue, 14 Feb 2023 11:02:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=GNEAe1B6QgPjY6KaGYE9TiQHnNZykCg1bt+o/OnSHKg=;
 b=jCbanmENsaL+Qywp7UiUmPpaLE026MKQLvs2949VQBufJ3NChD2T+NdLj63AEav6V+
 wMwdp0D14ReBrdppu27C3G9owiTLrQGe3iFXb1SbSZxjitOx7X8w+bxfd1KJtT+Wxzas
 281LWMTHEvo0ekS2ODpTCE6+awmG97H1eldtJ6ANF62rVQch05+kD/rW0Gdy8jqChhhT
 zjEw43+skRamHcNoRRhjR53ZkH3hy5az704gBZNH3Vb3xtc8zKq06YrmOgbG/RrXoPFb
 C/nLT+mF8aSDW5FR5ZMiSuIfNPyDUAnqeqifY/5FjuSSyq8AQ5NGToX12M1b+0bjVgO5
 7Dgw==
X-Gm-Message-State: AO0yUKUtTNTJermWQYEhO0ZxuTTkhBMCU+NTa0QnfJqjMXJ5oG+GkczT
 dbf7avfDSXV0xfs3aZTqj20=
X-Google-Smtp-Source: AK7set/zW0EPl9LzsbivR8TPrW170enXOL+jrEbHAwLfuAFAOh0JpMeGXUm427Nk8n+1LDAQTKlEnw==
X-Received: by 2002:a05:6e02:1d19:b0:315:2992:8049 with SMTP id
 i25-20020a056e021d1900b0031529928049mr3487297ila.27.1676401355789; 
 Tue, 14 Feb 2023 11:02:35 -0800 (PST)
Received: from localhost.localdomain (c-67-174-241-145.hsd1.ca.comcast.net.
 [67.174.241.145]) by smtp.gmail.com with ESMTPSA id
 r11-20020a056e0219cb00b0030c27c9eea4sm3608770ill.33.2023.02.14.11.02.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Feb 2023 11:02:35 -0800 (PST)
From: Yang Shi <shy828301@gmail.com>
To: mgorman@techsingularity.net, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, akpm@linux-foundation.org
Date: Tue, 14 Feb 2023 11:02:16 -0800
Message-Id: <20230214190221.1156876-1-shy828301@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Wed, 15 Feb 2023 09:33:38 +0000
Subject: [dm-devel] [v2 PATCH 0/5] Introduce mempool pages bulk allocator
 and use it in dm-crypt
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-block@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Changelog:
RFC -> v2:
  * Added callback variant for page bulk allocator and mempool bulk allocator
    per Mel Gorman.
  * Used the callback version in dm-crypt driver.
  * Some code cleanup and refactor to reduce duplicate code.

rfc: https://lore.kernel.org/linux-mm/20221005180341.1738796-1-shy828301@gmail.com/


We have full disk encryption enabled, profiling shows page allocations may
incur a noticeable overhead when writing.  The dm-crypt creates an "out"
bio for writing.  And fill the "out" bio with the same amount of pages
as "in" bio.  But the driver allocates one page at a time in a loop.  For
1M bio it means the driver has to call page allocator 256 times.  It seems
not that efficient.

Since v5.13 we have page bulk allocator supported, so dm-crypt could use
it to do page allocations more efficiently.

I could just call the page bulk allocator in dm-crypt driver before the
mempool allocator, but it seems ad-hoc and the quick search shows some
others do the similar thing, for example, f2fs compress, block bounce,
g2fs, ufs, etc.  So it seems more neat to implement a general bulk allocation
API for mempool.

Currently the bulk allocator just supported list and array to consume the
pages.  But neither is the best fit to dm-crypt ussecase.  So introduce
a new bulk allocator API, callback, per the suggestion from Mel Gorman.
It consumes the pages by calling a callback with a parameter.

So introduce the mempool page bulk allocator.
The below APIs are introduced:
    - mempool_init_pages_bulk()
    - mempool_create_pages_bulk()
    They initialize the mempool for page bulk allocator.  The pool is filled
    by alloc_page() in a loop.
    
    - mempool_alloc_pages_bulk_cb()
    - mempool_alloc_pages_bulk_array()
    They do bulk allocation from mempool.  The list version is not implemented
    since there is no user for list version bulk allocator so far and it may
    be gong soon.

    They do the below conceptually:
      1. Call bulk page allocator
      2. If the allocation is fulfilled then return otherwise try to
         allocate the remaining pages from the mempool
      3. If it is fulfilled then return otherwise retry from #1 with sleepable
         gfp
      4. If it is still failed, sleep for a while to wait for the mempool is
         refilled, then retry from #1
    The populated pages will stay on array until the callers consume them or
    free them, or will be consumed by the callback.
    Since mempool allocator is guaranteed to success in the sleepable context,
    so the two APIs return true for success or false for fail.  It is the
    caller's responsibility to handle failure case (partial allocation), just
    like the page bulk allocator.
    
The mempool typically is an object agnostic allocator, but bulk allocation
is only supported by pages, so the mempool bulk allocator is for page
allocation only as well.

With the mempool bulk allocator the IOPS of dm-crypt with 1M I/O would get
improved by approxiamately 6%.  The test is done on a machine with 80 CPU and
128GB memory with an encrypted ram device (the impact from storage hardware
could be minimized so that we could benchmark the dm-crypt layer more
accurately).

Before the patch:
Jobs: 1 (f=1): [w(1)][100.0%][w=1301MiB/s][w=1301 IOPS][eta 00m:00s]
crypt: (groupid=0, jobs=1): err= 0: pid=48512: Wed Feb  1 18:11:30 2023
  write: IOPS=1300, BW=1301MiB/s (1364MB/s)(76.2GiB/60001msec); 0 zone resets
    slat (usec): min=724, max=867, avg=765.71, stdev=19.27
    clat (usec): min=4, max=196297, avg=195688.86, stdev=6450.50
     lat (usec): min=801, max=197064, avg=196454.90, stdev=6450.35
    clat percentiles (msec):
     |  1.00th=[  197],  5.00th=[  197], 10.00th=[  197], 20.00th=[  197],
     | 30.00th=[  197], 40.00th=[  197], 50.00th=[  197], 60.00th=[  197],
     | 70.00th=[  197], 80.00th=[  197], 90.00th=[  197], 95.00th=[  197],
     | 99.00th=[  197], 99.50th=[  197], 99.90th=[  197], 99.95th=[  197],
     | 99.99th=[  197]
   bw (  MiB/s): min=  800, max= 1308, per=99.69%, avg=1296.94, stdev=46.02, samples=119
   iops        : min=  800, max= 1308, avg=1296.94, stdev=46.02, samples=119
  lat (usec)   : 10=0.01%, 1000=0.01%
  lat (msec)   : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.02%, 50=0.05%
  lat (msec)   : 100=0.08%, 250=99.83%
  cpu          : usr=3.88%, sys=96.02%, ctx=69, majf=1, minf=9
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued rwts: total=0,78060,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=256

Run status group 0 (all jobs):
  WRITE: bw=1301MiB/s (1364MB/s), 1301MiB/s-1301MiB/s (1364MB/s-1364MB/s), io=76.2GiB (81.9GB), run=60001-60001msec

After the patch:
Jobs: 1 (f=1): [w(1)][100.0%][w=1401MiB/s][w=1401 IOPS][eta 00m:00s]
crypt: (groupid=0, jobs=1): err= 0: pid=2171: Wed Feb  1 21:08:16 2023
  write: IOPS=1401, BW=1402MiB/s (1470MB/s)(82.1GiB/60001msec); 0 zone resets
    slat (usec): min=685, max=815, avg=710.77, stdev=13.24
    clat (usec): min=4, max=182206, avg=181658.31, stdev=5810.58
     lat (usec): min=709, max=182913, avg=182369.36, stdev=5810.67
    clat percentiles (msec):
     |  1.00th=[  182],  5.00th=[  182], 10.00th=[  182], 20.00th=[  182],
     | 30.00th=[  182], 40.00th=[  182], 50.00th=[  182], 60.00th=[  182],
     | 70.00th=[  182], 80.00th=[  182], 90.00th=[  182], 95.00th=[  182],
     | 99.00th=[  182], 99.50th=[  182], 99.90th=[  182], 99.95th=[  182],
     | 99.99th=[  182]
   bw (  MiB/s): min=  900, max= 1408, per=99.71%, avg=1397.60, stdev=46.04, samples=119
   iops        : min=  900, max= 1408, avg=1397.60, stdev=46.04, samples=119
  lat (usec)   : 10=0.01%, 750=0.01%
  lat (msec)   : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.02%, 50=0.05%
  lat (msec)   : 100=0.08%, 250=99.83%
  cpu          : usr=3.66%, sys=96.23%, ctx=76, majf=1, minf=9
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued rwts: total=0,84098,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=256

Run status group 0 (all jobs):
  WRITE: bw=1402MiB/s (1470MB/s), 1402MiB/s-1402MiB/s (1470MB/s-1470MB/s), io=82.1GiB (88.2GB), run=60001-60001msec

And the benchmark with 4K size I/O doesn't show measurable regression.


Yang Shi (5):
      mm: page_alloc: add API for bulk allocator with callback
      mm: mempool: extract the common initialization and alloc code
      mm: mempool: introduce page bulk allocator
      md: dm-crypt: move crypt_free_buffer_pages ahead
      md: dm-crypt: use mempool page bulk allocator

 drivers/md/dm-crypt.c   |  95 ++++++++++++++++++++++++++++++---------------------
 include/linux/gfp.h     |  21 +++++++++---
 include/linux/mempool.h |  21 ++++++++++++
 mm/mempolicy.c          |  12 ++++---
 mm/mempool.c            | 248 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------
 mm/page_alloc.c         |  21 ++++++++----
 6 files changed, 323 insertions(+), 95 deletions(-)


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

