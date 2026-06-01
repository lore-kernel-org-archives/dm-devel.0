Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BDD2FDC27
	for <dm-devel@lists.linux.dev>; Mon,  1 Jun 2026 16:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780332336; cv=none; b=UaWcagfHcN6SkFpgR+Kik/jHgC9UOAJ/zaeAVHymx1V0663GMFk1RkatttGL0eurxymZsCxoDsO8n71uhb82EZbeXchWxPlCiwp24bLUPIKZ/WHIVG4tnYSmENoEDceP+03nM8e0NY+x1BU3CTWkXiGRiIukV2KQtce2F1nQIrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780332336; c=relaxed/simple;
	bh=4CnM3P+mHGUVjCte0XIRllTHqumDU20ul47lPd3fVk8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=KqbeWi+pMBcic+6pJgtLp+uh6kkbDvMVapUihZGguCiLrzF8paWuQOIb0jPx+yMW0OOdDAIBheQmRrOyQpQ2MM9z7fldm2mphcZzJ+pwrWK8W7/d1+DvbSF39fG5Ncc6cIb1XBuowGn3SewrAy08u/hgMh57c0zDP3JAHCShGUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HxxdR0cl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HxxdR0cl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780332334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g2wdrc6i9LTQqqSQ331yUvDWqECANJoj8A5suUsO0V0=;
	b=HxxdR0clnVlnTRG3rfGpbH3q8IkFlItduPnAWyIgjMw8C88vmkh2V3ILSg+ehYsbgno6hX
	/B3c4G8FKw8eilVrvRTkEK+awl2fwOZUW4oSwjujPs8EGuVZh2hvcCsLzWQKHn4LEtfdK+
	v56GH6UPKIKLkio/gAZBIgf5SM/B7lU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-Il7x4OeTPBumbYWOrsOLWw-1; Mon,
 01 Jun 2026 12:45:31 -0400
X-MC-Unique: Il7x4OeTPBumbYWOrsOLWw-1
X-Mimecast-MFC-AGG-ID: Il7x4OeTPBumbYWOrsOLWw_1780332330
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E115E1956080;
	Mon,  1 Jun 2026 16:45:29 +0000 (UTC)
Received: from [10.44.49.105] (unknown [10.44.49.105])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C234F1800352;
	Mon,  1 Jun 2026 16:45:27 +0000 (UTC)
Date: Mon, 1 Jun 2026 18:45:21 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Fengnan <changfengnan@bytedance.com>
cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org, 
    agk@redhat.com, snitzer@kernel.org, bmarzins@redhat.com, 
    dm-devel@lists.linux.dev
Subject: Re: [PATCH RESEND] dm: limit target bio polling to one shot
In-Reply-To: <c37f0749-1ae9-48ca-b402-38a552767b12@bytedance.com>
Message-ID: <eec40ac4-3d39-8d8f-b32f-9f2eaa826531@redhat.com>
References: <20260513091349.2194-1-changfengnan@bytedance.com> <c37f0749-1ae9-48ca-b402-38a552767b12@bytedance.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: ecEK9ZXAiiPG_lu9nyZ_H_JFeateKkIZuonX5Xix-iY_1780332330
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-651475170-1780332329=:1690835"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-651475170-1780332329=:1690835
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Thu, 28 May 2026, Fengnan wrote:

> ping..

Hi

I already staged this patch in the linux-dm repository.

Mikulas

> 在 2026/5/13 17:13, Fengnan Chang 写道:
> > dm_poll_bio() is the ->poll_bio() callback for a stacked dm device.
> > The caller only knows about the dm queue, so it may decide to do a
> > spinning poll if it thinks a single queue is being polled. Passing those
> > flags unchanged to the mapped clone lets blk_mq_poll() spin on a target
> > queue from inside dm_poll_bio().
> >
> > With io_uring IOPOLL on a dm-stripe target this can keep a task in
> >
> >    dm_poll_bio() -> bio_poll() -> blk_mq_poll()
> >
> > long enough to trigger an RCU CPU stall, before io_uring gets back to
> > io_iopoll_check() and its need_resched() check.
> >
> > Keep dm's ->poll_bio() bounded by forcing one-shot polling for target
> > bios. The caller can invoke dm_poll_bio() again if it wants to keep
> > polling, and it also gets a chance to reap completions or reschedule
> > between passes.
> >
> > Fixes: f22ecf9c14c1 ("blk-mq: delete task running check in blk_hctx_poll()")
> > Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> > ---
> >   drivers/md/dm.c | 13 +++++++++++--
> >   1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index e178fe19973ea..8f44fbbcf3da2 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -2098,8 +2098,17 @@ static bool dm_poll_dm_io(struct dm_io *io, struct io_comp_batch *iob,
> >   	WARN_ON_ONCE(!dm_tio_is_normal(&io->tio));
> >   
> >   	/* don't poll if the mapped io is done */
> > -	if (atomic_read(&io->io_count) > 1)
> > -		bio_poll(&io->tio.clone, iob, flags);
> > +	if (atomic_read(&io->io_count) > 1) {
> > +		/*
> > +		 * DM hides the target queues from the upper poller, which may
> > +		 * decide it is safe to spin on a single stacked queue.  Do not
> > +		 * pass that spinning policy down to a target queue: one slow
> > +		 * clone could keep the task inside dm_poll_bio() for a long
> > +		 * time.  Poll target bios once and let the caller decide
> > +		 * whether to keep polling, reap completions or reschedule.
> > +		 */
> > +		bio_poll(&io->tio.clone, iob, flags | BLK_POLL_ONESHOT);
> > +	}
> >   
> >   	/* bio_poll holds the last reference */
> >   	return atomic_read(&io->io_count) == 1;
> 

---1463811712-651475170-1780332329=:1690835--

