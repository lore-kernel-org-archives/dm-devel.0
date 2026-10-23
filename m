Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788478;
	b=BgR2yPV4tHkM5G7f0z3oFEhpsZfx0ci0eoXWc6wCniLvEf0jO89chrphIcY2s0TyTPc/
	 ARCYPadmVRE/CzH92VPQZjziAO894QEtoViNlyl8zUaP1Q/yxNgpXFzBuWHoe+BB+muHb
	 0ev1i8zyBD/IWLXiNZqnxO7tjKrZXDDP1e6lquhJTTlz8WQ1+gDT5cU/qRCkTvvjGZuar
	 /Rfa+fsRjqZeu3JymdmIOYk4OYbRnPeBz2bsfmk8eQhdGXCxTY7RVNgPmLSHxSdz2VdA1
	 n2Diut5Tm4vAO9R48xnzu/Bsi+pOMYpS9tppsYw8F4l7NECjCf372SIdgt3vhmswrZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788478;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:X-Scanned-By:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type;
	bh=YSoGrYUaFyCWj7wBdWf9AjngRpXmCJKRgjD53W4q88w=;
	b=SmJnOkg3wuRu1B3NGCe+Y3xbtERfqnNl/JS6xl5XfkCtc1WEEmEFyKtQnt7Da/EQAPeE
	 BE+TN+HxTK9LLrrIPHa/E/nTqAcIvLbEWkm3Wd2nnRvwZaY2S7n5zSid5ZtEOJIvXGOtn
	 QzHO+WyGNjfrrKoHhHOtSHjvWE1BIrg8BtckPEgeY5NgoJ20buIio3l8N9utjWymK64YV
	 YZMlBiFYkJ+9051ib1+1M9Clr9SL6W32XMrXak92zwqhjhH5cfE4VxoRQiseiZyYYA81b
	 3/XZmWI0rgyl1JxhtjwRiSwu8VfPYJh9+UGnyWcTOoh41LPPz0rtNdUTVbXc2H0PyOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Kd4O4Hg9;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE43606A31B
	for <dm-devel@lists.linux.dev>; Fri, 23 Oct 2026 20:47:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7EE43606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Kd4O4Hg9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792788476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YSoGrYUaFyCWj7wBdWf9AjngRpXmCJKRgjD53W4q88w=;
	b=Kd4O4Hg9e+tjoq345QfJQXTBIkIXcxSBt+sWJCm2VIkve7z95XPobVpbnj88FeaHBBaX/p
	n9KYb1KET1s9DEcDMDOzzenbJ/tLAAWVi4h7MwO4hwmiyHrfmF/fFQ+VUs9KlbjR4Tceqo
	4/pitB/LexoUqEgUPGLgi4rVwEkknvA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-nZPZJXNvPPq_LgyfTlxxGg-1; Fri,
 23 Oct 2026 16:47:53 -0400
X-MC-Unique: nZPZJXNvPPq_LgyfTlxxGg-1
X-Mimecast-MFC-AGG-ID: nZPZJXNvPPq_LgyfTlxxGg_1792788472
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7AEE81802559;
	Fri, 23 Oct 2026 20:47:51 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17C671800480;
	Fri, 23 Oct 2026 20:47:48 +0000 (UTC)
Date: Fri, 23 Oct 2026 22:47:46 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
cc: sashiko-bot@kernel.org, Keith Busch <kbusch@meta.com>, axboe@kernel.dk, 
    dm-devel@lists.linux.dev, bmarzins@redhat.com, 
    Keith Busch <kbusch@kernel.org>
Subject: Re: block: let a stacking device inherit its members' DMA
 alignment
In-Reply-To: <atuAGpRkY5cPLKfT@kernel.org>
Message-ID: <97e320c5-99bc-9428-d2f0-2761f5c18727@redhat.com>
References: <20260709161519.1559723-1-kbusch@meta.com> <20260709161519.1559723-2-kbusch@meta.com> <atpBVtPqGDWZ2AFo@kernel.org> <sashiko-outbox-181857@kernel.org> <atuAGpRkY5cPLKfT@kernel.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GbUp8UczKlJ7NlYns9dkgdKx0nbWSbhnCU6Qwy56Lp8_1792788472
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 23 Oct 2026, Mike Snitzer wrote:

> On Thu, Oct 22, 2026 at 05:25:02PM +0000, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> > - [Critical] block: blk_set_stacking_limits() corrupts data in dm-ebs and dm-writecache
> > --
> > 
> > commit da5c2e4cde4a12a4f8b254dc27480cf9078b36d2
> > Author: Mike Snitzer <snitzer@kernel.org>
> > 
> > block: let a stacking device inherit its members' DMA alignment
> > 
> > This commit removes the default sector-size dma_alignment initialization in
> > blk_set_stacking_limits() so that stacking devices inherit the strictest
> > dma_alignment of their underlying member devices. When no member devices are
> > stacked, blk_validate_limits() still applies the default sector alignment.
> > 
> > > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > > index e469baa1f08b7..36fcbecdf793b 100644
> > > --- a/block/blk-settings.c
> > > +++ b/block/blk-settings.c
> > > @@ -41,7 +41,14 @@ void blk_set_stacking_limits(struct queue_limits *lim)
> > >  	lim->physical_block_size = SECTOR_SIZE;
> > >  	lim->io_min = SECTOR_SIZE;
> > >  	lim->discard_granularity = SECTOR_SIZE;
> > > -	lim->dma_alignment = SECTOR_SIZE - 1;
> > > +	/*
> > > +	 * No dma_alignment of its own: blk_stack_limits() keeps the strictest
> > > +	 * of the devices stacked under it, and blk_validate_limits() gives the
> > > +	 * sector-size default to a device left with none.  A driver that looks
> > > +	 * at the data and needs it laid out by logical block says so in its
> > > +	 * own limits, as dm-crypt, dm-integrity, dm-verity and dm-log-writes
> > > +	 * do.
> > > +	 */
> > 
> > [Severity: Critical]
> > Could leaving lim->dma_alignment at 0 in blk_set_stacking_limits() cause data
> > corruption regressions in targets like dm-ebs and dm-writecache that inspect
> > bio data but do not set limits->dma_alignment in their io_hints callbacks?
> > 
> > When stacked over a device with sub-sector dma_alignment (such as an nvme
> > device with dma_alignment = 3), direct I/O using a 4-byte-aligned user buffer
> > that crosses a page boundary or uses sub-sector iovecs can produce bio_vec
> > segments whose lengths are not multiples of 512 bytes (for example,
> > bv_len = 4092 followed by bv_len = 4).
> 
> The code comment in the patch calls out the fact that
> blk_validate_limits() will backfill dma_alignment if none is set (by
> usual limits stacking or explicitly by DM targets).
> 
> But sure, there is potential for dragons if stacked block devices
> like DM implicitly relied on block-core's coarse-grained default
> dma_alignment.
> 
> Mikulas, would you be open to auditing the DM targets relative to
> dma_alignment stacking after you're done with reviewing Keith's
> related dm-crypt patchset?

Yes, I think that this is the only way forward - and this audit should be 
done before accepting the dm-crypt patches.

DM cannot rely on stacking limits, because the DM stack may be 
reconfigured anytime - so there is a race condition that a dm-device may 
advertise dma alignment 3, someone may construct a bio that uses 4-byte 
aligned vectors, the stack may be reconfigured with a completely different 
target and the bio may be sent to this different target and cause trouble.

So, we need to be prepared to handle any alignment at device mapper entry. 

I think we should add a new flag "accepts_unaligned_bio_vector" to struct 
dm_target. If the flag is not present, then the dm-core would check the 
alignment and reject bios with BLK_STS_INVAL in the dm core.

Then, we can gradually enable the flag for more and more targets as they 
are checked.

Mikulas

> Sorry for the extra work... but its worthwhile for DM to be more
> precise with how it stacks dma_alignment
> 
> Thanks,
> Mike

