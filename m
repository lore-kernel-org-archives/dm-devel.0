Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBF7C4361B
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 16:48:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 220F8229C9
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 16:48:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 220F8229C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1607100507;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kjKn7WSaJ4Ob+9c585q90QIE+Q0Ymr0sdLlF7oPzpRo=;
	b=DFAK45ca8dGPHvoUn/kq8f5x8Tzfe1qLHLq3OD/7usC5qu7wzwttsOqCQpS812kqtVnqBi
	RYO0W34Dh6yxURImcEYPMH7825MXCNrZyZ+1W1bvWsexirblVQDBznPRYX50dvUnIqxHwn
	DHGtqE0HYCcqEumv5PL2PD9lqUpSG3w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-Zq53_YZ3MnaHR_to_gdVTQ-1; Fri, 04 Dec 2020 11:48:25 -0500
X-MC-Unique: Zq53_YZ3MnaHR_to_gdVTQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1DFD1E7C2;
	Fri,  4 Dec 2020 16:48:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 803CC5C22B;
	Fri,  4 Dec 2020 16:48:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0FE72180954D;
	Fri,  4 Dec 2020 16:48:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B4GmIi6010417 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Dec 2020 11:48:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B56355D9E4; Fri,  4 Dec 2020 16:48:18 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 45E125D9DC;
	Fri,  4 Dec 2020 16:47:59 +0000 (UTC)
Date: Fri, 4 Dec 2020 11:47:59 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20201204164759.GA2761@redhat.com>
References: <20201130171805.77712-1-snitzer@redhat.com>
	<20201201160709.31748-1-snitzer@redhat.com>
	<20201203032608.GD540033@T590> <20201203143359.GA29261@redhat.com>
	<20201204011243.GB661914@T590> <20201204020343.GA32150@redhat.com>
	<20201204035924.GD661914@T590>
MIME-Version: 1.0
In-Reply-To: <20201204035924.GD661914@T590>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, martin.petersen@oracle.com, jdorminy@redhat.com,
	bjohnsto@redhat.com, linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2] block: use gcd() to fix chunk_sectors
	limit stacking
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 03 2020 at 10:59pm -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> On Thu, Dec 03, 2020 at 09:03:43PM -0500, Mike Snitzer wrote:
> > On Thu, Dec 03 2020 at  8:12pm -0500,
> > Ming Lei <ming.lei@redhat.com> wrote:
> > 
> > > On Thu, Dec 03, 2020 at 09:33:59AM -0500, Mike Snitzer wrote:
> > > > On Wed, Dec 02 2020 at 10:26pm -0500,
> > > > Ming Lei <ming.lei@redhat.com> wrote:
> > > > 
> > > > > On Tue, Dec 01, 2020 at 11:07:09AM -0500, Mike Snitzer wrote:
> > > > > > commit 22ada802ede8 ("block: use lcm_not_zero() when stacking
> > > > > > chunk_sectors") broke chunk_sectors limit stacking. chunk_sectors must
> > > > > > reflect the most limited of all devices in the IO stack.
> > > > > > 
> > > > > > Otherwise malformed IO may result. E.g.: prior to this fix,
> > > > > > ->chunk_sectors = lcm_not_zero(8, 128) would result in
> > > > > > blk_max_size_offset() splitting IO at 128 sectors rather than the
> > > > > > required more restrictive 8 sectors.
> > > > > 
> > > > > What is the user-visible result of splitting IO at 128 sectors?
> > > > 
> > > > The VDO dm target fails because it requires IO it receives to be split
> > > > as it advertised (8 sectors).
> > > 
> > > OK, looks VDO's chunk_sector limit is one hard constraint, even though it
> > > is one DM device, so I guess you are talking about DM over VDO?
> > > 
> > > Another reason should be that VDO doesn't use blk_queue_split(), otherwise it
> > > won't be a trouble, right?
> > > 
> > > Frankly speaking, if the stacking driver/device has its own hard queue limit
> > > like normal hardware drive, the driver should be responsible for the splitting.
> > 
> > DM core does the splitting for VDO (just like any other DM target).
> > In 5.9 I updated DM to use chunk_sectors, use blk_stack_limits()
> > stacking of it, and also use blk_max_size_offset().
> > 
> > But all that block core code has shown itself to be too rigid for DM.  I
> > tried to force the issue by stacking DM targets' ti->max_io_len with
> > chunk_sectors.  But really I'd need to be able to pass in the per-target
> > max_io_len to blk_max_size_offset() to salvage using it.
> > 
> > Stacking chunk_sectors seems ill-conceived.  One size-fits-all splitting
> > is too rigid.
> 
> DM/VDO knows exactly it is one hard chunk_sectors limit, and DM shouldn't play
> the stacking trick on VDO's chunk_sectors limit, should it?

Feel like I already answered this in detail but... correct, DM cannot
and should not use stacked chunk_sectors as basis for splitting.

Up until 5.9, where I changed DM core to set and then use chunk_sectors
for splitting via blk_max_size_offset(), DM only used its own per-target
ti->max_io_len in drivers/md/dm.c:max_io_len().

But I reverted back to DM's pre-5.9 splitting in this stable@ fix that
I'll be sending to Linus today for 5.10-rcX:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.10-rcX&id=6bb38bcc33bf3093c08bd1b71e4f20c82bb60dd1

DM is now back to pre-5.9 behavior where it doesn't even consider
chunk_sectors for splitting (NOTE: dm-zoned sets ti->max_io_len though
so it is effectively achieves the same boundary splits via max_io_len).

With that baseline established, what I'm now saying is: if DM, the most
common limits stacking consumer, cannot benefit from stacked
chunk_sectors then what stacked device does benefit?  Could be block
core's stacked chunk_sectors based splitting is good enough for others,
just not yet seeing how.  Feels like it predates blk_queue_split() and
the stacking of chunk_sectors could/should be removed now.

All said, I'm fine with leaving stacked chunk_sectors for others to care
about... think I've raised enough awareness on this topic now ;)

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

