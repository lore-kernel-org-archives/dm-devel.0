Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06805C2C9
	for <dm-devel@lists.linux.dev>; Mon,  2 Jun 2025 16:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748881530; cv=none; b=CAkmm1FjtFPIPjAtMDjSOFLAeUvNw3dwlJE2Bko9hCwC/hwICQv8FUTuecvHsYGrQwJC+T0oQLvD5MIfc4BbSfa6GQA5rDFJS7M98sJnM4Ta+Je0p7vtQSfCxiVLCIAxwESzF1VEJc+uj6EvQjafGVrt3NaRZBy87Mp009mqVsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748881530; c=relaxed/simple;
	bh=gmam3Lx1q0AYApuZW9UvcU6Kso5HpwhnIDRJR3Rzn70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=XmxMMmkQuieUo38THn7b4l2daA1SpGZCAOHuJa4/+9ZLptVFXXdSaJQUIowufIC33kvFtK1LLdpGiemxqXcWJjvIQte4Kf2HHTcdR5P1pCu2DyYCGGq8E9DmmpAaNABRyKRd3akc3G1t1mrnFFXWRK+6mEitT2+HWCIxGhQ8ttc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fu1HQMlc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fu1HQMlc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748881527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ikM2dlcFaqgl9CnidJX20kP4WdIWGok1t3q1m1Y/3RA=;
	b=Fu1HQMlccBGbZXMjDNTWXsf7+mse6HaG/G1HpdEYHIaJX6/oLWCupPQcUDTzaQLI6vW6D2
	rzDfXKUvYu8v+tlptQ0tE+Fk0H3Bk5gAFlkOxh0guhQcUoNvb+PgP/JoaLVvsgjN1Cou0x
	WCPdvU4SEHZUw9K2REkJ2Hws5bLj4jw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-84-37jZkUQrNg-w6lMVd7Li9A-1; Mon,
 02 Jun 2025 12:25:26 -0400
X-MC-Unique: 37jZkUQrNg-w6lMVd7Li9A-1
X-Mimecast-MFC-AGG-ID: 37jZkUQrNg-w6lMVd7Li9A_1748881524
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BAE0A19560AA;
	Mon,  2 Jun 2025 16:25:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D53AE1800359;
	Mon,  2 Jun 2025 16:25:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 552GPM3K1613631
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 2 Jun 2025 12:25:22 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 552GPL571613630;
	Mon, 2 Jun 2025 12:25:21 -0400
Date: Mon, 2 Jun 2025 12:25:21 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@lists.linux.dev, hch@lst.de
Subject: Re: [PATCH] dm-table: check BLK_FEAT_ATOMIC_WRITES inside limits_lock
Message-ID: <aD3QccNaBXLQ2xPP@redhat.com>
References: <20250530145032.1491277-1-bmarzins@redhat.com>
 <d9d13fea-e75f-4fa4-86c8-dc7053a553b9@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d9d13fea-e75f-4fa4-86c8-dc7053a553b9@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WmcDf-NvAi7whu8IeFZaG_BttnpCRxXZm2OZYTL4YQ4_1748881524
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2025 at 11:08:46AM +0100, John Garry wrote:
> On 30/05/2025 15:50, Benjamin Marzinski wrote:
> 
> +
> 
> > dm_set_device_limits() should check q->limits.features for
> > BLK_FEAT_ATOMIC_WRITES while holding q->limits_lock, like it does for
> > the rest of the queue limits.
> > 
> > Fixes: b7c18b17a173 ("dm-table: Set BLK_FEAT_ATOMIC_WRITES for target queue limits")
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> In itself, the change seems fine, but I have doubts whether it's preferred
> to even grab the q->limits_lock outside block layer / its helpers.

I'm pretty sure Mikulas added the q->limits_lock around DM's queue
limits accesses as the result of a discussion with some block layer
developers.

> 
> And, apart from this, if the bottom device limits change later, do we
> actually trigger a top device limits evaluation update?

DM will obviously re-evaluate the limits if you reload the table. In
some cases, DM will also disable features if turns out that they aren't
supported when it actually tries to use them. Dumb question: Is there
much chance of a SCSI device's atomic write support changing while it's
in-use?

-Ben
 
> > ---
> >   drivers/md/dm-table.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index 57573e8b5aa9..9f95f77687ef 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -430,13 +430,13 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
> >   		return 0;
> >   	}
> > +	mutex_lock(&q->limits_lock);
> >   	/*
> >   	 * BLK_FEAT_ATOMIC_WRITES is not inherited from the bottom device in
> >   	 * blk_stack_limits(), so do it manually.
> >   	 */
> >   	limits->features |= (q->limits.features & BLK_FEAT_ATOMIC_WRITES);
> > -	mutex_lock(&q->limits_lock);
> >   	if (blk_stack_limits(limits, &q->limits,
> >   			get_start_sect(bdev) + start) < 0)
> >   		DMWARN("%s: adding target device %pg caused an alignment inconsistency: "

