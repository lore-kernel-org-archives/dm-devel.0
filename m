Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976333D1CDB
	for <dm-devel@lists.linux.dev>; Thu,  5 Mar 2026 18:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772735861; cv=none; b=mj3+ehooYBsu+oALYmSxbI7Z07YFQ2nrw0wKtMpHuSIfVB860ZEvWwHxslzToMcv5yNIjVplY5Jvvv+xitPoeIj1ETul/G48kPswMEv2CdotvdDfwrluP1QosfCJ5vxskVdBSi1Rf+NTBvmpHn0KxZb60kloSKmNqbSVOq9V/vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772735861; c=relaxed/simple;
	bh=R6dH8XgJiObtxOpcsUX3tskHijiwulWb20uGf7t+NqY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WP0W42bRapmkZUJLATHdyAWciXQm/CdclHC9LM6RoWr441Db3QD86XrIAry8YZs2iN66ZFbbwHH5KrEXknu8QU5EVI5TI5Cv+Tp7itl7ehoQYznfCopcgAud7FIcYTY4IkX0WsTSUDiHsHywHZadi5Plt0+3L8jyIQw4+7Ughkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GMSvzMaw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GMSvzMaw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772735859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R6dH8XgJiObtxOpcsUX3tskHijiwulWb20uGf7t+NqY=;
	b=GMSvzMawyK+f5DnL6FSGjgCNefvwZroZ0qrfMOOLKMI2sg0Ig/xOie+TP4mLL41GABAdCR
	VUNjfZBvncRkNVM+OQ0xk+g26CqSDtQnm/jgIUItcrp/g+4dZHxxy7o8U7KuzljAnWeoNy
	k25ysmExwfRBSAtcnRTksL9kAzVMUTs=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-0EyFVOOvPHmZG1AU5BtWjg-1; Thu, 05 Mar 2026 13:37:38 -0500
X-MC-Unique: 0EyFVOOvPHmZG1AU5BtWjg-1
X-Mimecast-MFC-AGG-ID: 0EyFVOOvPHmZG1AU5BtWjg_1772735858
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7987dc43f36so147351087b3.0
        for <dm-devel@lists.linux.dev>; Thu, 05 Mar 2026 10:37:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772735858; x=1773340658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R6dH8XgJiObtxOpcsUX3tskHijiwulWb20uGf7t+NqY=;
        b=xQXS01yxrQvYh3vgePejfcctQ5TcYIHZ/DOdEbxwH+rRqua2jvjIWlKVUGScSAX9Oh
         gWuSbhVL1xdTIKVefnrVY7uJPlfL3jLzGG17u3k0F6j6WYYZClCkceHoD1Pw19RY3M9Z
         MNlH/EtmLnCGpkXxm3U35w+mvaJHUxV2KvV5XSPIM6vHNI6Sk/TfuAncLH0lXo/m4H6z
         4NmdPuOvvqm7BD8UzhRzA1mWYEQLBNmnhn22XIT7iJjeq4zXaa4227vxsEwSWNiZ/jYr
         A2wPT/ElolLGwXEt0odiwYEq9I8As+p/r36tXwgMo3QOVAABOxBJ4r6YxT4wQcx01Mpj
         v1zQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeKPVTY7LFTPBVbIfFAHb+5s1UrynEjO+cu7ilr6fOu/MzO4vZ9qlowjxJPP1hOefey4qklJjjDw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwtWtiUQgx5aDf0hNB/TTW+3yIwHjnJgy85QESM2gma4mIB/Gd3
	qT1NSwGi10qb/G3jQNuOU7x/GHQUcrjvAAFI0eGTpET6uRwvFivhKmWu15zBztQ6BZ0mqDcWQc7
	6+IKQlRV9pV5QOgos1UbVjtqSHtvBqkSs7ba8vNu//NqUPqKPY8m9GiG0ON4YVS1fTG/T2wSf5n
	o1iAMGqcpxTHskD0rquyKNV9pHUxJNX1R2uJM=
X-Gm-Gg: ATEYQzxsviaoDFzMhvNtkPFoSVzgpOyh82dZIOLb072NZNKNL4E3gYPLJG3+2BdSnv/
	iiYY8WhoLibX8zJflC5wBItHJkoC+Noy9mtrckWczu/S08k33F4yoEW1zUYABYzPZ1tYaNOdso+
	zUzFv0+e/E4DZvl9em/tP3mfQVRQcdPgd/kw7CBbRBoXBUAuQ+qjUkZHDd+LMoEk15uL9SZdSGS
	gcFrRR14wnr/48zsuQMIBUhHeKqpWXHNAWtDbw8ujM5WFLhcbl5fV/aZv997052jQ==
X-Received: by 2002:a05:690c:c513:b0:798:647f:239 with SMTP id 00721157ae682-798c6c01a87mr55056837b3.21.1772735858039;
        Thu, 05 Mar 2026 10:37:38 -0800 (PST)
X-Received: by 2002:a05:690c:c513:b0:798:647f:239 with SMTP id
 00721157ae682-798c6c01a87mr55056657b3.21.1772735857680; Thu, 05 Mar 2026
 10:37:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260304190424.291743-1-agruenba@redhat.com> <20260304190424.291743-5-agruenba@redhat.com>
 <aamP2qNKEmiyXQQH@infradead.org>
In-Reply-To: <aamP2qNKEmiyXQQH@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 5 Mar 2026 19:37:26 +0100
X-Gm-Features: AaiRm500QkwsYOPyC8DDeTtG7W1JPyGlNX5bDWdmiHocLDeSRR23AHcZAF5cQWI
Message-ID: <CAHc6FU5sEivMqj38xrAXuTxZ0d19LJjxbvoWtsPqm6NYigAEhA@mail.gmail.com>
Subject: Re: [PATCH 4/4] bio: use bio_io_error more often
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, 
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NZzsuGOov4WGnbdlEOhWgf7JV7w8McCNoRNoDt34v_U_1772735858
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 5, 2026 at 3:14=E2=80=AFPM Christoph Hellwig <hch@infradead.org=
> wrote:
> On Wed, Mar 04, 2026 at 08:04:09PM +0100, Andreas Gruenbacher wrote:
> > Instead of setting bio->bi_status to BLK_STS_IOERR and calling
> > bio_endio(bio), use the shorthand bio_io_error(bio).
>
> I'm a little torn how good these helpers actually are, as
> hard coding one specific type of error seems to create weird
> code and lead to bugs like the xfs one you fixed yesterday.
>
> Maybe we just need a bio_endio_status() that allows passing the
> status?

I'm not particularly attached to bio_io_error(bio); it's been around
forever but it can be confusing. Any thoughts on replacing it with a
new bio_endio_status(bio, BLK_STS_IOERR) helper instead of keeping two
mechanisms for doing the same thing?

> Also you really need to send one patch per subsystem.

I'm really trying to avoid that for simple, obviously correct,
mechanical changes that can be recreated from scratch any time.

Thanks,
Andreas

