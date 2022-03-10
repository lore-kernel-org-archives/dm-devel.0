Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C70FC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Mar 2022 04:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646884861;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4xid27q5dFDVnbJEf3YNI4LTP6qdQtVGx2KmkDKZlq4=;
	b=B8UWGHlfKQI37kPnitcuNOaFRRgcKl4cTuZ/2LC5M91h3msUGAJonZlSgEeVrqOZze69pv
	jPHXo/sV5CZ/PSvRzoWDS7rgi6YqYENSjc5HmOM4n0a6tbdDqswSJU9LVuAIxuAX+tpQzb
	8tSxxur0Vqvol8GtdLbmANRO45adVfs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-8o2Y4g0MP4ePK1J6X-c6-A-1; Wed, 09 Mar 2022 23:00:58 -0500
X-MC-Unique: 8o2Y4g0MP4ePK1J6X-c6-A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE960101AA48;
	Thu, 10 Mar 2022 04:00:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 789EB7D1D7F;
	Thu, 10 Mar 2022 04:00:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2E9A21953574;
	Thu, 10 Mar 2022 04:00:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0D6331953541
 for <dm-devel@listman.corp.redhat.com>; Thu, 10 Mar 2022 04:00:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 78D9B2D1FB; Thu, 10 Mar 2022 04:00:52 +0000 (UTC)
Received: from T590 (ovpn-8-27.pek2.redhat.com [10.72.8.27])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 115A74CEFE;
 Thu, 10 Mar 2022 04:00:05 +0000 (UTC)
Date: Thu, 10 Mar 2022 12:00:01 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <Yil3wXO83U3zj5vj@T590>
References: <20220307185303.71201-1-snitzer@redhat.com>
 <20220307185303.71201-3-snitzer@redhat.com>
 <eac88ad5-3274-389b-9d18-9b6aa16fcb98@kernel.dk>
 <Yif/Or0s1rV87a5R@T590>
 <d4657e24-4cc7-7372-bafe-d6c9c8005c6b@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <d4657e24-4cc7-7372-bafe-d6c9c8005c6b@kernel.dk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Subject: Re: [dm-devel] [PATCH v6 2/2] dm: support bio polling
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
 Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 09, 2022 at 09:11:26AM -0700, Jens Axboe wrote:
> On 3/8/22 6:13 PM, Ming Lei wrote:
> > On Tue, Mar 08, 2022 at 06:02:50PM -0700, Jens Axboe wrote:
> >> On 3/7/22 11:53 AM, Mike Snitzer wrote:
> >>> From: Ming Lei <ming.lei@redhat.com>
> >>>
> >>> Support bio(REQ_POLLED) polling in the following approach:
> >>>
> >>> 1) only support io polling on normal READ/WRITE, and other abnormal IOs
> >>> still fallback to IRQ mode, so the target io is exactly inside the dm
> >>> io.
> >>>
> >>> 2) hold one refcnt on io->io_count after submitting this dm bio with
> >>> REQ_POLLED
> >>>
> >>> 3) support dm native bio splitting, any dm io instance associated with
> >>> current bio will be added into one list which head is bio->bi_private
> >>> which will be recovered before ending this bio
> >>>
> >>> 4) implement .poll_bio() callback, call bio_poll() on the single target
> >>> bio inside the dm io which is retrieved via bio->bi_bio_drv_data; call
> >>> dm_io_dec_pending() after the target io is done in .poll_bio()
> >>>
> >>> 5) enable QUEUE_FLAG_POLL if all underlying queues enable QUEUE_FLAG_POLL,
> >>> which is based on Jeffle's previous patch.
> >>
> >> It's not the prettiest thing in the world with the overlay on bi_private,
> >> but at least it's nicely documented now.
> >>
> >> I would encourage you to actually test this on fast storage, should make
> >> a nice difference. I can run this on a gen2 optane, it's 10x the IOPS
> >> of what it was tested on and should help better highlight where it
> >> makes a difference.
> >>
> >> If either of you would like that, then send me a fool proof recipe for
> >> what should be setup so I have a poll capable dm device.
> > 
> > Follows steps for setup dm stripe over two nvmes, then run io_uring on
> > the dm stripe dev.
> 
> Thanks! Much easier when I don't have to figure it out... Setup:

Jens, thanks for running the test!

> 
> CPU: 12900K
> Drives: 2x P5800X gen2 optane (~5M IOPS each at 512b)
> 
> Baseline kernel:
> 
> sudo taskset -c 10 t/io_uring -d128 -b512 -s31 -c16 -p1 -F1 -B1 -n1 -R1 -X1 /dev/dm-0
> Added file /dev/dm-0 (submitter 0)
> polled=1, fixedbufs=1/0, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> submitter=0, tid=1004
> IOPS=2794K, BW=1364MiB/s, IOS/call=31/30, inflight=(124)
> IOPS=2793K, BW=1363MiB/s, IOS/call=31/31, inflight=(62)
> IOPS=2789K, BW=1362MiB/s, IOS/call=31/30, inflight=(124)
> IOPS=2779K, BW=1357MiB/s, IOS/call=31/31, inflight=(124)
> IOPS=2780K, BW=1357MiB/s, IOS/call=31/31, inflight=(62)
> IOPS=2779K, BW=1357MiB/s, IOS/call=31/31, inflight=(62)
> ^CExiting on signal
> Maximum IOPS=2794K
> 
> generating about 500K ints/sec,

~5.6 IOs completed in each int averagely, looks irq coalesce is working.

> and using 4k blocks:
> 
> sudo taskset -c 10 t/io_uring -d128 -b4096 -s31 -c16 -p1 -F1 -B1 -n1 -R1 -X1 /dev/dm-0
> Added file /dev/dm-0 (submitter 0)
> polled=1, fixedbufs=1/0, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> submitter=0, tid=967
> IOPS=1683K, BW=6575MiB/s, IOS/call=24/24, inflight=(93)
> IOPS=1685K, BW=6584MiB/s, IOS/call=24/24, inflight=(124)
> IOPS=1686K, BW=6588MiB/s, IOS/call=24/24, inflight=(124)
> IOPS=1684K, BW=6581MiB/s, IOS/call=24/24, inflight=(93)
> IOPS=1686K, BW=6589MiB/s, IOS/call=24/24, inflight=(124)
> IOPS=1687K, BW=6593MiB/s, IOS/call=24/24, inflight=(128)
> IOPS=1687K, BW=6590MiB/s, IOS/call=24/24, inflight=(93)
> ^CExiting on signal
> Maximum IOPS=1687K
> 
> which ends up being bw limited for me, because the devices aren't linked
> gen4. That's about 1.4M ints/sec.

Looks one interrupt just completes one IO with 4k bs, no irq coalesce
any more. The interrupts may not run in CPU 10 I guess.

> 
> With the patched kernel, same test:
> 
> sudo taskset -c 10 t/io_uring -d128 -b512 -s31 -c16 -p1 -F1 -B1 -n1 -R1 -X1 /dev/dm-0
> Added file /dev/dm-0 (submitter 0)
> polled=1, fixedbufs=1/0, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> submitter=0, tid=989
> IOPS=4151K, BW=2026MiB/s, IOS/call=16/15, inflight=(128)
> IOPS=4159K, BW=2031MiB/s, IOS/call=15/15, inflight=(128)
> IOPS=4193K, BW=2047MiB/s, IOS/call=15/15, inflight=(128)
> IOPS=4191K, BW=2046MiB/s, IOS/call=15/15, inflight=(128)
> IOPS=4202K, BW=2052MiB/s, IOS/call=15/15, inflight=(128)
> ^CExiting on signal
> Maximum IOPS=4202K
> 
> with basically zero interrupts, and 4k:
> 
> sudo taskset -c 10 t/io_uring -d128 -b4096 -s31 -c16 -p1 -F1 -B1 -n1 -R1 -X1 /dev/dm-0
> Added file /dev/dm-0 (submitter 0)
> polled=1, fixedbufs=1/0, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> submitter=0, tid=1015
> IOPS=1706K, BW=6666MiB/s, IOS/call=15/15, inflight=(128)
> IOPS=1704K, BW=6658MiB/s, IOS/call=15/15, inflight=(128)
> IOPS=1704K, BW=6658MiB/s, IOS/call=15/15, inflight=(128)
> IOPS=1704K, BW=6658MiB/s, IOS/call=15/15, inflight=(128)
> IOPS=1704K, BW=6658MiB/s, IOS/call=15/15, inflight=(128)
> ^CExiting on signal
> Maximum IOPS=1706K

Looks improvement on 4k is small, is it caused by pcie bw limit?
What is the IOPS when running the same t/io_uring on single optane
directly?



Thanks, 
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

