Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794962491;
	b=Zft2E2ijDogixNHZrMlgfWBMGQ0mIeT2W6FuJXbzM8FikNAjaErcmZrMCtQrrXHGsLVH
	 l35rtA4hMlsu8rlBDpXPpWjWsUE+XFGgUMoaonfVABYOMTrnVm3HevT9JAXL2YYt2NIY/
	 Z6Yy4pGN4wXk+ALOdkIn53fEBVe9ZVZ5A0uaiS+rMsqtnR1TIKsu5eZL6PW0v2pKlHIxi
	 d87IaTzYVhRqW84l8no/atcsORCA3eABdcih+lquop9PPiZnvK+7Cvmehz1lBORcJwTFy
	 n57pCIqLm9Ua7aMxfrkEhmGz2Yqcnz9I1FyYFz9fuRp/IIo5k0Xoawj/6ELbNTkxZNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794962491;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=0TDJlZp3lGb/7MvoKRp73Dz+0EXP0Dv0zbBDHmL3xys=;
	b=pbQzOYa2eWSFJtyMA1kShxx+grl3bRr0UmNf4yF5qPsdToCmR35sA309MDGBAu/Au/45
	 iwCp2ZzoMTVebcPj3MpEbHkke0EYJgwebr5RUlFN2CD8kbijKTHyKsTvcT8oRoH+Y7W6T
	 ngIZK9RAKvbDaSNZdvsBpkII7qqJSI+JkQ2W4ELxfPC422Xkop7UhbsRfIAtjOrHagfiB
	 ct/8vBpexy//d9Z4v5FFENyRCox+BT2E4Psua4YWg87wQCt8owdfUDAYBpseF00R9PN36
	 Qu80IUA11ITeP4PiY5jHaUAMcJaALDc/119sv6gCkGOC1vtNKf3890m4aEm/8ySwEBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PpggPkX5;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AF7606A885
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 00:41:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70AF7606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PpggPkX5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794962489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0TDJlZp3lGb/7MvoKRp73Dz+0EXP0Dv0zbBDHmL3xys=;
	b=PpggPkX5EXpsODIA29qXcQDO7+AGLx9MVaCzJbcmL5bufl/B+TQlRpzjqGPKFIWhB5w92F
	1f+42VXJzqQV4/lk/RVEEoPzVJ/ZFIx42K6hX7PTgsrlW4Pwst3Vo/nY6mWp9Bcbk5v6b1
	aZhYL+1iF32Z5J6CKlaMJevZjdJdM50=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-g4E2qqUbPumKgbi4y_ovrQ-1; Tue,
 17 Nov 2026 19:41:26 -0500
X-MC-Unique: g4E2qqUbPumKgbi4y_ovrQ-1
X-Mimecast-MFC-AGG-ID: g4E2qqUbPumKgbi4y_ovrQ_1794962485
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA962195608B;
	Wed, 18 Nov 2026 00:41:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 47D46180054B;
	Wed, 18 Nov 2026 00:41:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AI0fNgg3957189
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 17 Nov 2026 19:41:23 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AI0fMu83957181;
	Tue, 17 Nov 2026 19:41:22 -0500
Date: Tue, 17 Nov 2026 19:41:22 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Yongpeng Yang <yangyongpeng.storage@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: Re: [PATCH 1/4] dm-bufio: make the retain target per client
Message-ID: <avz0MuIaC8k9V9T8@redhat.com>
References: <20261117131918.2745193-2-yangyongpeng.storage@gmail.com>
 <20261117131918.2745193-4-yangyongpeng.storage@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261117131918.2745193-4-yangyongpeng.storage@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mXAMYgmfidnODCFJwhQ_DKMAvLMnZXQlK44LZA1crvc_1794962485
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 17, 2026 at 09:19:17PM +0800, Yongpeng Yang wrote:
> From: Yongpeng Yang <yangyongpeng@xiaomi.com>
> 
> dm_bufio_retain_bytes is a module-wide value shared by every dm-bufio
> user, so raising it to keep one device's metadata cached also makes
> every small, idle device hold on to memory it does not need.
> 
> Give each client its own target, initialized from the module parameter
> at creation.  The parameter keeps its meaning as the default for new
> clients; clients that already exist are not affected.
> 
> Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
> Assisted-by: LLM

Looks good except one minor nitpick.

> ---
>  drivers/md/dm-bufio.c    | 31 ++++++++++++++++++++++++++++++-
>  include/linux/dm-bufio.h |  7 +++++++
>  2 files changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 3b66cf1cb931..75b6e5c027ae 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c

[ ... ]

> @@ -2284,6 +2286,32 @@ void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n)
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_set_minimum_buffers);
>  
> +/*
> + * Set the number of bytes this client tries to keep cached; 0 resets it
> + * to the module default.  Non-zero values are rounded to a block
> + * boundary, at least one block.
> + */
> +void dm_bufio_set_retain_bytes(struct dm_bufio_client *c, unsigned long bytes)
> +{
> +	if (!bytes) {
> +		WRITE_ONCE(c->retain_bytes, READ_ONCE(dm_bufio_retain_bytes));
> +		return;
> +	}
> +
> +	bytes -= bytes % c->block_size;
> +	if (!bytes)
> +		bytes = c->block_size;

Instead of rounding down, except when that would round to 0, why not
always round up, so dm_bufio retains at least as many bytes as
requested?

-Ben

