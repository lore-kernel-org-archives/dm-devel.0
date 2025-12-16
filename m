Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517FF33B967
	for <dm-devel@lists.linux.dev>; Tue, 16 Dec 2025 11:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884023; cv=none; b=QurWnDeRJnMZGQOgQfOTjXj4iVIB1tU9w5tYIV8HoflEy3IPqks5WFpymAGukVHcAod9JpWVG+C1yAzWP+q+jxpdh9+v24NrXzQFQz3IhbCzQ/6beJoikLJQcw4WohTgGwZiDbmkD236zr4tTkMqJuPH8qDfVx7Y0ITtITpp1RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884023; c=relaxed/simple;
	bh=Ir34V/AA4/Kn53Xt2wU7m430i1aPoGLugyeX+Sg5NA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pVIsSMeHKAc4HPjl9SFXsHo4QImpDbkS+8R7WaCVRyjFayIeMIrZX9pW3ZrYAAWn/SrQLp0KPkyGSEzp5ChGfg6Rr4y5CjF/TO8LuYMi5bhb9RGu7bMrvsvVfqXeJJECzZ2JmWnGwSxJiT8ewPGDeo8Cj/pfSZ1QI6MYhZw1tfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y/SUlIF3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y/SUlIF3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765884020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TWRZ0JhI9nv9UkoCkjiIAGd+WxbLXiOF8HjIaXhWnLA=;
	b=Y/SUlIF3xZtgfWnV+nd8PsBUXGzc1qvXwum9v4WxfmIlMV6UZyruB3Jcsx7u5ywHzRQfdl
	QL7sSlkJyF8GXpTYdTUhNLESg48fX5j9qmbUOAOd7UOHEn4waj4tWICfTonDme9RlYjPQN
	wEucxWW393E3DnzU4KBzthBrIJ1SPms=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-Yeu2rKgcOwGnng90cLdAVQ-1; Tue, 16 Dec 2025 06:20:19 -0500
X-MC-Unique: Yeu2rKgcOwGnng90cLdAVQ-1
X-Mimecast-MFC-AGG-ID: Yeu2rKgcOwGnng90cLdAVQ_1765884018
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-64471fcf4efso6319824d50.2
        for <dm-devel@lists.linux.dev>; Tue, 16 Dec 2025 03:20:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765884018; x=1766488818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TWRZ0JhI9nv9UkoCkjiIAGd+WxbLXiOF8HjIaXhWnLA=;
        b=ZQZDBfHlUeiw18eObB6rq1cr+dGWhkuulprgEnDkNDXgt/+NAu+ni534GZQc/83lpT
         rq6q31egwU1IHM1i0D4MGll9rOP/v5lHB8wQMXkHQuM/6gpQtZPOXgosu/QULlYKbvYK
         OtbsWA9prSMHrCPB2pB5QoMsp9eWf8UgFpv5Cm+sAH7+6slRKXl+Hv38PHq2VMqbZ2HU
         mfvXn79C9EnyWjqvVnc+nOzTTA0HkWf9+WI+5GAWMOkzMUhbiBOOWjxKFY8u81/IKM2i
         5ZxZ+OfohCHA3JW5EMNLAGCE2pst9OjU8BMK5NblwRk8oTu2Lq9rCAfxJHar04yblMy2
         RLyg==
X-Forwarded-Encrypted: i=1; AJvYcCUTCMe8CjTpUO9bcFeKTm0O7T45TY4sn3Ovj8rNBaE5ZCRF1OFtDs8oQmMsJzBXXBjMflp7Ayj0kQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxqMs8f38G0vVJTeov+ESCLvKYicuJSw03ZYMZGDJDKj7wad3oB
	zUgazMgDmBNMloQEWKVCC4viZ4Ow5ZkvEUZpmL7zVynySbkXkoRmU3I7CkRH9QSfVt07mg/vCqC
	9c4w525WDwt9C5EZL3UCNFG61bDV0zahphryhEvpJhF2VWsOm01zckoCe5O3tUzT1JLkETTddfp
	2xjbslDW5M9JlWYwCnSF6PXukcXkYeqrxS3OI=
X-Gm-Gg: AY/fxX4j+1kFaYgzoImucjAo0rCbgS0B6PDQgdYOE0owB8Z3Ggzost/U8I9zTyNV5fA
	kFQvVrO3fqlrJYhd4EPEqXeWtIOFevFDA4s6cdOj/MVuO3oXeSFr1ZfGM5XYYrR+rQOu8EUSRFY
	vlaKIUIPnDFbBAUpuoYdfP4LUqBBqHAkAWN+nUGpdUnXNoJHtOS+xGx1nxJQGcUDIR
X-Received: by 2002:a05:690e:118a:b0:641:f5bc:695c with SMTP id 956f58d0204a3-64555661ec4mr12407311d50.72.1765884018382;
        Tue, 16 Dec 2025 03:20:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHE1hRYagai5ZNpwc4wQBEIkmKE4t8Gn5ugUaYPF0w5F6afO5UP4qTUeJlKU6zAyLz8ccdYL4yR/SJoQvAZlXU=
X-Received: by 2002:a05:690e:118a:b0:641:f5bc:695c with SMTP id
 956f58d0204a3-64555661ec4mr12407292d50.72.1765884018076; Tue, 16 Dec 2025
 03:20:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251208121020.1780402-1-agruenba@redhat.com> <20251208121020.1780402-7-agruenba@redhat.com>
 <aUERRp7S1A5YXCm4@infradead.org> <CAHc6FU6QCfqTM9zCREdp3o0UzFX99q2QqXgOiNkN8OtnhWYZVQ@mail.gmail.com>
 <aUE3_ubz172iThdl@infradead.org>
In-Reply-To: <aUE3_ubz172iThdl@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 16 Dec 2025 12:20:07 +0100
X-Gm-Features: AQt7F2q5uYepYK7esYO29pN2NRPzWpk3ITk8uPFpAWNLoGj4HZrc4JFHmQEXPKs
Message-ID: <CAHc6FU4OeAYgvXGE+QZrAJPqERLS3v7q64uSoVtxJjG0AdZvCA@mail.gmail.com>
Subject: Re: [RFC 06/12] bio: don't check target->bi_status on error
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EEuXd5EcmFpVcpcsf6r-5z2Z_CmwXTy1gt1YgPCeBAE_1765884018
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 11:44=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
> On Tue, Dec 16, 2025 at 09:41:49AM +0100, Andreas Gruenbacher wrote:
> > On Tue, Dec 16, 2025 at 8:59=E2=80=AFAM Christoph Hellwig <hch@infradea=
d.org> wrote:
> > > On Mon, Dec 08, 2025 at 12:10:13PM +0000, Andreas Gruenbacher wrote:
> > > > In a few places, target->bi_status is set to source->bi_status only=
 if
> > > > source->bi_status is not 0 and target->bi_status is (still) 0.  Her=
e,
> > > > checking the value of target->bi_status before setting it is an
> > > > unnecessary micro optimization because we are already on an error p=
ath.
> > >
> > > What is source and target here?  I have a hard time trying to follow
> > > what this is trying to do.
> >
> > Not sure, what would you suggest instead?
>
> I still don't understand what you're saying here at all, or what this is
> trying to fix or optimize.

When we have this construct in the code and we know that status is not 0:

  if (!bio->bi_status)
    bio->bi_status =3D status;

we can just do this instead:

  bio>bi_status =3D status;

Andreas

