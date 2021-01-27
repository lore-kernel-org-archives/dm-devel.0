Return-Path: <SRS0=jLbn=G6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F03C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 17:19:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 578C764DA5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 17:19:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 578C764DA5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1611767997;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IMfZofwr0KQSoiUQGybgoIZ46tzcc2QYSOUkuEPNe84=;
	b=W/JPIoiVvb0fQwrXaWh0ttzbz27CG0wYUpeapAfz/Yh8nkxhZYPQP9vtK57g+xE2DMF3FG
	734mfz7kpSsjUeOSUWsuXL9Kof5nAHjqcLeWHUQMLswEuAsL/sbvmAH+QeGCoPrfZx5TYh
	pzD1RE75C4lHclnTR6QEt4ynMoleCsA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-iTb58Id_N6OrQeAIrpVKyg-1; Wed, 27 Jan 2021 12:19:54 -0500
X-MC-Unique: iTb58Id_N6OrQeAIrpVKyg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81DEF1005D44;
	Wed, 27 Jan 2021 17:19:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E833C5D744;
	Wed, 27 Jan 2021 17:19:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B578180954D;
	Wed, 27 Jan 2021 17:19:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10RHJjTt015994 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Jan 2021 12:19:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D0ED810023AB; Wed, 27 Jan 2021 17:19:45 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD19D10246E0;
	Wed, 27 Jan 2021 17:19:42 +0000 (UTC)
Date: Wed, 27 Jan 2021 12:19:42 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Message-ID: <20210127171941.GA11530@redhat.com>
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2 0/6] dm: support IO polling for bio-based
	dm device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 25 2021 at  7:13am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> Since currently we have no simple but efficient way to implement the
> bio-based IO polling in the split-bio tracking style, this patch set
> turns to the original implementation mechanism that iterates and
> polls all underlying hw queues in polling mode. One optimization is
> introduced to mitigate the race of one hw queue among multiple polling
> instances.
> 
> I'm still open to the split bio tracking mechanism, if there's
> reasonable way to implement it.
> 
> 
> [Performance Test]
> The performance is tested by fio (engine=io_uring) 4k randread on
> dm-linear device. The dm-linear device is built upon nvme devices,
> and every nvme device has one polling hw queue (nvme.poll_queues=1).
> 
> Test Case		    | IOPS in IRQ mode | IOPS in polling mode | Diff
> 			    | (hipri=0)	       | (hipri=1)	      |
> --------------------------- | ---------------- | -------------------- | ----
> 3 target nvme, num_jobs = 1 | 198k 	       | 276k		      | ~40%
> 3 target nvme, num_jobs = 3 | 608k 	       | 705k		      | ~16%
> 6 target nvme, num_jobs = 6 | 1197k 	       | 1347k		      | ~13%
> 3 target nvme, num_jobs = 6 | 1285k 	       | 1293k		      | ~0%
> 
> As the number of polling instances (num_jobs) increases, the
> performance improvement decreases, though it's still positive
> compared to the IRQ mode.

I think there is serious room for improvement for DM's implementation;
but the block changes for this are all we'd need for DM in the longrun
anyway (famous last words). So on a block interface level I'm OK with
block patches 1-3.

I don't see why patch 5 is needed (said the same in reply to it; but I
just saw your reason below..).

Anyway, I can pick up DM patches 4 and 6 via linux-dm.git if Jens picks
up patches 1-3. Jens, what do you think?

> [Optimization]
> To mitigate the race when iterating all the underlying hw queues, one
> flag is maintained on a per-hw-queue basis. This flag is used to
> indicate whether this polling hw queue currently being polled on or
> not. Every polling hw queue is exclusive to one polling instance, i.e.,
> the polling instance will skip this polling hw queue if this hw queue
> currently is being polled by another polling instance, and start
> polling on the next hw queue.
> 
> This per-hw-queue flag map is currently maintained in dm layer. In
> the table load phase, a table describing all underlying polling hw
> queues is built and stored in 'struct dm_table'. It is safe when
> reloading the mapping table.
> 
> 
> changes since v1:
> - patch 1,2,4 is the same as v1 and have already been reviewed
> - patch 3 is refactored a bit on the basis of suggestions from
> Mike Snitzer.
> - patch 5 is newly added and introduces one new queue flag
> representing if the queue is capable of IO polling. This mainly
> simplifies the logic in queue_poll_store().

Ah OK, don't see why we want to eat a queue flag for that though!

> - patch 6 implements the core mechanism supporting IO polling.
> The sanity check checking if the dm device supports IO polling is
> also folded into this patch, and the queue flag will be cleared if
> it doesn't support, in case of table reloading.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

