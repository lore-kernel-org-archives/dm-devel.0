Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F74D2DE6FA
	for <dm-devel@lists.linux.dev>; Mon,  8 Dec 2025 21:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765228620; cv=none; b=R5wJN5foexbiZtu7PY0UGZyKngUrGsVZ6Kw1o5DUa0mdoXnkAQYNFzPH51H0eLsrXNWZcBj+7aitRbc5gxSP/0CJoYE3HZulaUxHpRSS4nMPvGWnPc8+zS1HsH7RUBbqMTRg7aWeUXZ3k4E4jIPbKuVA04W+IfWfMtg2IV/K7B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765228620; c=relaxed/simple;
	bh=5qGC2F3TSPuLPR1QccjvC8Wi8HoL2P4T2S8jzm5W6eg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B8TPrwu8W1eisdkqEMD6j8LdHGCqtk/tzt7yTnP6NRrKEuUMwi+f+xMZL0QEkczA4xnAEa1LNZJogsgjR0A24LGo2FUGcp2DJmk+Ke6UXEEdgdhTvjFVKHoZiqTedR9xGQ0GKlHt4egCXft73H3V7/Y9j2/eoil3QGG/xTGl32Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fQrGvnIw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fQrGvnIw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765228617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3cjLyi8J1W1mVcyJajqeGZwTWZZ/xf0eZlzYpjjz4as=;
	b=fQrGvnIwKxNknra5UAMXMpl5TbKtWArd3DCnkwBLb2siR4Jsh9bL2KPDW5izeAvqqSNcKD
	d3TUqPvUYuWiTr5NYNcbvbM2ZsSli3k6Bn1TtIUbU///DsybCzZS377vXyII+Wu2wR11J5
	YMWcl3y2j6vHXYnUzRWbGzWSpHeb/jM=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-jELSk94iMCqVLWzqHrt8kQ-1; Mon, 08 Dec 2025 16:16:56 -0500
X-MC-Unique: jELSk94iMCqVLWzqHrt8kQ-1
X-Mimecast-MFC-AGG-ID: jELSk94iMCqVLWzqHrt8kQ_1765228616
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-78a9936470fso63933127b3.0
        for <dm-devel@lists.linux.dev>; Mon, 08 Dec 2025 13:16:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765228616; x=1765833416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3cjLyi8J1W1mVcyJajqeGZwTWZZ/xf0eZlzYpjjz4as=;
        b=RCi5T0JVoLbrg99A5+8Jwkiiyzalgi+Vpv5hUMTLqV6AhUfvdIUds5FQl6xfpUbQNz
         TiLSeSd0gxBEwMlRxgKejDB5Lq50y9ABC71kwOqV0HsHdUZN/T09QaYnXLSc/4B90WzT
         lzltE9et8CzCdw2fmT8z8khPgCc8toe5OsDq/ZZsIxov44IO91I7UUN3LOKWMNh7kCwI
         gUKVSIl9XTfJf5awEGP+toEdRHyCD/EUjifSzpw74s4NBEZ34XtJu0AKvlIT8Qq6uBUv
         8ZY0x7dvFF+GKE4rJ74Ma30vpEJX+s+4r68hAusSaArm6j0AJrE6CzFKKqRm3W+6IA6C
         FNUQ==
X-Forwarded-Encrypted: i=1; AJvYcCV83AJR1CO9v/kk/3ZE5uHp0x50I9EhU/smM/q2wREJj2mssuJ6AvV8qxN8ze7ISq2QV9CUi32GYw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwHYWsS6wvDexh3IPbqvGcHaYPEKfHXTLvLxrv0GsHot2uqjj3g
	d0xkb1jedMidT4Yc4p+D2smV9BbB6+3OJsTcq5HPU41QKgra/Wi07Rg7lJs1bFYqgeap2TojzVz
	KeYmYtMmG+xCaI83dvcYitXDjlLlJ2cbV4eLaXGEg6u+d6H+Ly0WNv58CZQ3VoOBesd21bIqgwe
	TADfnERCOobo9fwldN3WtUiu10RLfwX4GMT7Q=
X-Gm-Gg: ASbGncv4fM9YpOX2afvJhdZIsz52Frn7j3NV2d3iL/gWuI0SR8T+n17qhc5dKaLrlDm
	jW497BQjO3bo/XFYghyEXmiMyFp7DWuKcSBjdVt6Y0vux0YgSzW+Uke2UHSuqrh8yRC+F53oKmz
	SAvx8KdY8MjfJX1Szp6W+peOZYr/2W/SmSawsKqS2KCBVeFDQtf7wGMveX/4WyDn/B
X-Received: by 2002:a05:690c:4a02:b0:786:61f3:e4e with SMTP id 00721157ae682-78c33c74655mr90034697b3.54.1765228616030;
        Mon, 08 Dec 2025 13:16:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFiCY42NqIRZgl6uVDR8LkykQzXJsYzMaVLpZgyirQa+mlv/Jyf+1nBV5OG4dbWD1DDVxjeGc24WpTFqReJ20Q=
X-Received: by 2002:a05:690c:4a02:b0:786:61f3:e4e with SMTP id
 00721157ae682-78c33c74655mr90034377b3.54.1765228615599; Mon, 08 Dec 2025
 13:16:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251208121020.1780402-1-agruenba@redhat.com> <20251208193724.GB4859@twin.jikos.cz>
In-Reply-To: <20251208193724.GB4859@twin.jikos.cz>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 8 Dec 2025 22:16:44 +0100
X-Gm-Features: AQt7F2pWqhuOxBDn48p5d1W8IkDa9mkk1UO6HtSX6_QdJl4e-fg9m6lrjlZDn5M
Message-ID: <CAHc6FU6vax1eNB-xrYLuZX5s-RLRhtctG7=3NO+h_GPj5o=W-Q@mail.gmail.com>
Subject: Re: [RFC 00/12] bio cleanups
To: dsterba@suse.cz
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Satya Tangirala <satyat@google.com>, linux-block@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: izmuLzX2xvsGW7jabNfWTIO0DkiI7EPU0N7dBIYAjSY_1765228616
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 8, 2025 at 8:43=E2=80=AFPM David Sterba <dsterba@suse.cz> wrote=
:
> On Mon, Dec 08, 2025 at 12:10:07PM +0000, Andreas Gruenbacher wrote:
> > With these changes, only a few direct assignments to bio->bi_status
> > remain, in BTRFS and in MD, and SOME OF THOSE MAY BE UNSAFE.  Could the
> > maintainers of those subsystems please have a look?
>
> The btrfs bits look good to me, we expect the same semantics, ie. not
> overwrite existing error with 0. If there are racing writes to the
> status like in btrfs_bio_end_io() we use cmpxchg() so we don't overwrite
> it.

Really? I'm not talking about the status field in struct btrfs_bio but
about the bi_status field in struct bio. The first mention of
bi_status I can find in the btrfs code is right at the beginning of
btrfs_bio_end_io():

  bbio->bio.bi_status =3D status;

If status is ever BLK_STS_OK (0) here and bbio->bio is a chained bio,
things are already not great.

I believe we should eliminate all direct assignments to bi_status and
use bio_set_status() instead. I'm not familiar enough with the btrfs
code to make that replacement for you, though.

A cursory look at struct btrfs_bio suggests that those objects cannot
be chained like plain old bios (bio_chain()). This means that
cmpxchg() may actually work for catching the first error that occurs.
For chained regular bios, cmpxchg() won't catch the first error, at
least not if the length of the chain is greater than two.

Thanks,
Andreas

