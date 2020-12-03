Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4D7C433FE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 17:57:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4AEB6206F9
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 17:57:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AEB6206F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1607018238;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=b2qOL3Tbu4wtmumGnCfCxfDFNLU3wKFxFosqb6mqYxA=;
	b=M/SWd5w1Y4Sx87howLq+UcIZRZpN+bmlTp21HptD05xy5pSCosCOr6vaeIRbxfZL5Yzlil
	5N9Q74qhB50Oj32/ZKC9I2Gkr4zgZwwbuF5cqKz6u2v6HM3LrGELlzVvBPmKwBAfmEoP/N
	ofFOj6sN2H98U+voTTidfN7f3K+cf1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-8Px1OmDwMsqY8kIziBw79w-1; Thu, 03 Dec 2020 12:57:16 -0500
X-MC-Unique: 8Px1OmDwMsqY8kIziBw79w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18B481081B22;
	Thu,  3 Dec 2020 17:57:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B2445D6AC;
	Thu,  3 Dec 2020 17:57:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 38B864BB7B;
	Thu,  3 Dec 2020 17:57:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3Hv7u1008607 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 12:57:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5595660861; Thu,  3 Dec 2020 17:57:07 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7016460854;
	Thu,  3 Dec 2020 17:56:58 +0000 (UTC)
Date: Thu, 3 Dec 2020 12:56:57 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Message-ID: <20201203175657.GA29623@redhat.com>
References: <20201130171805.77712-1-snitzer@redhat.com>
	<20201201160709.31748-1-snitzer@redhat.com>
	<20201203032608.GD540033@T590> <20201203143359.GA29261@redhat.com>
	<20201203162738.GA3404013@dhcp-10-100-145-180.wdc.com>
MIME-Version: 1.0
In-Reply-To: <20201203162738.GA3404013@dhcp-10-100-145-180.wdc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, martin.petersen@oracle.com, jdorminy@redhat.com,
	bjohnsto@redhat.com, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 03 2020 at 11:27am -0500,
Keith Busch <kbusch@kernel.org> wrote:

> On Thu, Dec 03, 2020 at 09:33:59AM -0500, Mike Snitzer wrote:
> > On Wed, Dec 02 2020 at 10:26pm -0500,
> > Ming Lei <ming.lei@redhat.com> wrote:
> > 
> > > I understand it isn't related with correctness, because the underlying
> > > queue can split by its own chunk_sectors limit further. So is the issue
> > > too many further-splitting on queue with chunk_sectors 8? then CPU
> > > utilization is increased? Or other issue?
> > 
> > No, this is all about correctness.
> > 
> > Seems you're confining the definition of the possible stacking so that
> > the top-level device isn't allowed to have its own hard requirements on
> > IO sizes it sends to its internal implementation.  Just because the
> > underlying device can split further doesn't mean that the top-level
> > virtual driver can service larger IO sizes (not if the chunk_sectors
> > stacking throws away the hint the virtual driver provided because it
> > used lcm_not_zero).
> 
> I may be missing something obvious here, but if the lower layers split
> to their desired boundary already, why does this limit need to stack?

The problematic scenario is when the topmost layer, or layers, are the
more constrained.  _That_ is why the top-level's chunk_sectors limit
cannot be relaxed.

For example (in extreme where chunk_sectors is stacked via gcd):
dm VDO target (chunk_sectors=4K)
on dm-thin (ideally chunk_sectors=1280K, reality chunk_sectors=128K)
on 10+2 RAID6 (chunk_sectors=128K, io_opt=1280K)
on raid members (chunk_sectors=0)

Results in the following bottom up blk_stack_limits() stacking:
gcd(128K, 0) = 128K -> but MD just sets chunk_sectors, no stacking is done afaik
gcd(1280K, 128K) = 128K -> this one hurts dm-thin, needless splitting
gcd(4K, 128K) = 4K -> vdo _must_ receive 4K IOs, hurts but "this is the way" ;)

So this is one extreme that shows stacking chunk_sectors is _not_
helpful (if the resulting chunk_sectors were actually used as basis for
splitting).  Better for each layer to just impose its own chunk_sectors
without concern for the layers below.

Think I'd be fine with block core removing the chunk_sectors stacking
from blk_stack_limits()...
(and as you see below, I've been forced to revert to _not_ using stacked
chunk_sectors based splitting in DM)

> Won't it also work if each layer sets their desired chunk_sectors
> without considering their lower layers? The commit that initially
> stacked chunk_sectors doesn't provide any explanation.

Yes, I think it would work.  The current stacking doesn't have the
luxury of knowing which layer a blk_stack_limits() maps too.  BUT within
a layer chunk_sectors really does need to be compatible/symbiotic.  So
it is unfortunately all or nothing as you build up the stack.

And that all-or-nothing stacking of chunk_sectors is why I've now (just
last night, based on further review by jdorminy) had to punt on using
stacked chunk_sectors and revert DM back to doing its own fine-grained
(and varied) splitting on a per DM target basis, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.10-rcX&id=6bb38bcc33bf3093c08bd1b71e4f20c82bb60dd1

Kind of depressing that I went so far down the rabbit hole, of wanting
to lean on block core, that I lost sight of an important "tenet of DM":

+         * Does the target need to split IO even further?
+         * - varied (per target) IO splitting is a tenet of DM; this
+         *   explains why stacked chunk_sectors based splitting via
+         *   blk_max_size_offset() isn't possible here.

And it is because of this that DM is forced to lean on human creation of
an optimal IO stack.. which is prone to human error when a particular
thinp "blocksize" is selected, etc.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

