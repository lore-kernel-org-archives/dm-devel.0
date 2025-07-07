Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40197E9
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 13:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751895061; cv=none; b=pcVL86d/l8nYbZWOW2BUeUOCwvkEMAUW+J49LnxGTZ3pRgemoY7cAo350X36+dBUr0JLIawSS9fVXySC0qZWDYoW7Bee9mdd4k96X7CohjhyCD9JjvpyZdwb5zSY3Oykrw4OLG1RGKMr7cGxb3ndiSrHbG7bapRhpaswt2voxuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751895061; c=relaxed/simple;
	bh=xBjE/UBMddtMjC6s1UlAwo90Iwc9hfoweuDB2jXNeY8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=BSiOWwSECHGwApWCvZCKN0lzjrUH1IuzvAQV09FjR0aU1tpfek3aU8F5o89wbl0qKLifZpS/AKTZFFHc6GI77+Y3AyU5xG/JtrRUVQRD5zaOpYbNfN5MBK6WqPNHzI6sOqhmzlg9t+QL17FCOYseBQ++BOOWKMjw1IzkPT9OPF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KR2OxNi6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KR2OxNi6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751895058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hMnpmS0EvbUJoQqEOMauX1CsW81Rtd60WmomIhdc/0M=;
	b=KR2OxNi6kwfiMJLhBKmBFjfyACMNz+3U3o5U90rVBaA+/aVbkrqlzdlbzkNxoi1cEKi5YY
	GmPJHCGpMcWMHjo2CcY9FHYst3IwKnuHhihodrDKTlTZHthAqJowsYXxORfC64mk5CDjt3
	lUle5LTYa0m1nhKiTUlqUi26kX6dmzo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-RydbDWoQP4-8dj5CHHii3w-1; Mon,
 07 Jul 2025 09:30:55 -0400
X-MC-Unique: RydbDWoQP4-8dj5CHHii3w-1
X-Mimecast-MFC-AGG-ID: RydbDWoQP4-8dj5CHHii3w_1751895054
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F96F1955EC3;
	Mon,  7 Jul 2025 13:30:54 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA3D019560AF;
	Mon,  7 Jul 2025 13:30:52 +0000 (UTC)
Date: Mon, 7 Jul 2025 15:30:45 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    John Garry <john.g.garry@oracle.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-stripe: fix a possible integer overflow
In-Reply-To: <862bc5bb-13fb-41bb-85c9-84411ad9dda3@linux.dev>
Message-ID: <1216b028-f216-1bb8-6b0e-dcf2b4411494@redhat.com>
References: <0f1d0d2d-8840-a256-d628-39e074f021c1@redhat.com> <862bc5bb-13fb-41bb-85c9-84411ad9dda3@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: g3_czfXq5XdjTUnOXOiEs5IQf6vkjACm2f4xgn3Sw3E_1751895054
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-965631769-1751895054=:458491"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-965631769-1751895054=:458491
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Mon, 7 Jul 2025, Dongsheng Yang wrote:

> 
> 在 7/7/2025 6:39 PM, Mikulas Patocka 写道:
> > There's a possible integer overflow in stripe_io_hints if we have too
> > large chunk size. Test if the overflow happened, and if it did, don't set
> > limits->io_min and limits->io_opt;
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org
> > 
> > ---
> >   drivers/md/dm-stripe.c |   10 +++++++---
> >   1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6/drivers/md/dm-stripe.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-stripe.c	2025-07-06 15:02:23.000000000
> > +0200
> > +++ linux-2.6/drivers/md/dm-stripe.c	2025-07-07 12:32:49.000000000 +0200
> > @@ -456,10 +456,14 @@ static void stripe_io_hints(struct dm_ta
> >   			    struct queue_limits *limits)
> >   {
> >   	struct stripe_c *sc = ti->private;
> > -	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
> > +	unsigned int io_min = sc->chunk_size << SECTOR_SHIFT;
> > +	unsigned int io_opt = io_min * sc->stripes;
> >   -	limits->io_min = chunk_size;
> > -	limits->io_opt = chunk_size * sc->stripes;
> > +	if (io_min >> SECTOR_SHIFT == sc->chunk_size &&
> > +	    io_opt / sc->stripes == io_min) {
> > +		limits->io_min = io_min;
> > +		limits->io_opt = io_opt;
> > +	}
> 
> 
> Hi Mikulas,
> 
>     What about using check_xxx_overflow() ? something like:
> 
> 
>     if (check_shl_overflow(sc->chunk_size, SECTOR_SHIFT, &io_min))
>         return;
> 
> 
>     if (check_mul_overflow(io_min, sc->stripes, &io_opt))
>         return;
> 
>     limits->io_min = io_min;
>     limits->io_opt = io_opt;
> 
> >   }
> >     static struct target_type stripe_target = {
> > 
> > 

Yes, that's a good idea.

I changed the patch to use these macros.

Mikulas
---1463811712-965631769-1751895054=:458491--

