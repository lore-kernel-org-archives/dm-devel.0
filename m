Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9D81420A0
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 18:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708712281; cv=none; b=ZNt0T9he05Mm4iwBb4IKvTHY29SyOiggO6PjgCR9QWxvBoDJLf4qouogHAlCy70DznWxfA6WTdMBHlaCdWJR0f5w+0SG/MIsab2vJbWdyNocfb5gn5/dAH7oJzF76dufKzpN3iLAO4CjDwSWahL62WxBKG58sQJlLQHARhHfuZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708712281; c=relaxed/simple;
	bh=s1J3yxJJmHAT7tpjiN+ReLmhK0Jn7qywHUyIzFNWgKM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IIYPMABi3HRawe0JzbWRrFfjX6Yt0I+yPiJRYXje8x00oVv2Ejh02QIIjXDTvKxVv1epDT8qs/HeZzLiblNp+10IaUnpS/D4xHu1BS/3ArSrj8fm88mzYupaT2DW17O4T34zrn+/z4bJLseb9GhSXDZUQalOXgG0Q8sotyCkIx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IjHPW6F+; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IjHPW6F+"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-563b7b3e3ecso1450669a12.0
        for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 10:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1708712277; x=1709317077; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SMw6mgHykaNOkD9F2veVqYVpqjqdsgVrDzeEVTrgN9E=;
        b=IjHPW6F+cWA3P22fPaoJAwGc5TgxBrtIohuD0f/xljAF+P2QS/3a1mBQu6T+5KQGPR
         SIaNJvtCklagcFIjPsIYSHQbxlp9/gAyIYJdH4L0Q/eyP2HQAtwsiVYuuoZBmvnfnZBj
         vQBr6nU//aSw3oTQPCjYRG1u48jmW3gHHikOc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708712277; x=1709317077;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SMw6mgHykaNOkD9F2veVqYVpqjqdsgVrDzeEVTrgN9E=;
        b=REAQbOviVJGXhYb29HGKOizQLpN+AJz9l/nY0kahKU8u3HSguJ9COOz/PRa9/tLErF
         KRG2Cy1wy3R8Cg3SAV4oG+Sy2ggPdCUBxzPLN204TJvlzQitmwvnh59Q8JRrMywnjrg7
         wCzT0Z/RdNaZ9m/abyaUdrHQLKKCkbKiLxk3rWn3R2SFH0p+9sGdcLslUbUMHZknL9tM
         QvNhBRynxkQRI+o+I//0VbdgROCA2XVPa3t9DjuNva+kBkvur/ra4rPAu4Uy7XQYDITh
         SoXwzfZLn4VOCRk+OoQ8Xqrhstc0AnKypYTdhQn1MnB4ShnDw0G87a3cj85bmJgmauXY
         grcA==
X-Forwarded-Encrypted: i=1; AJvYcCVwvZDeyGrCmT4wotWThhSNiuhIBef8rMQzYcBmRIBsxcMfkhBMXdvSKn6KADiOhl+wu9Ht9VWh92rI15a16ppz5IQvuwhFQF4=
X-Gm-Message-State: AOJu0YycNDsp7/O8U1uBh6azpyFOfIoGdeXNOkwlROlFqGqK0RFcSMv7
	cFpXHK8TUWB0OjlKmhNBZUqlYPzBvvs4RAmgBaRCisnMZ/P1FlnX+2PDdyLC0ZFgLYh/8Jki7w3
	BfYI=
X-Google-Smtp-Source: AGHT+IGJZdq5jhYNP7PN1syawWmDxl22VhXnvaq+8LpwVNnP3Mbn2NylysHIkJJcl4OK0ZCHNW2fTw==
X-Received: by 2002:a17:906:918:b0:a3e:e84a:ccfb with SMTP id i24-20020a170906091800b00a3ee84accfbmr379335ejd.9.1708712276863;
        Fri, 23 Feb 2024 10:17:56 -0800 (PST)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id rf23-20020a1709076a1700b00a3fc12516aasm855367ejc.217.2024.02.23.10.17.55
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Feb 2024 10:17:55 -0800 (PST)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a26ed1e05c7so172412166b.2
        for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 10:17:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVOHTKFvIFnZP316T7MDZj5C8bSt0giYpi4eGPLyzqthZGiv8ETuIwjFmou45Mz11MbE7LApy8fy+fYdbEw/bsabsBi45n35eA=
X-Received: by 2002:a17:906:40ca:b0:a3f:2259:da62 with SMTP id
 a10-20020a17090640ca00b00a3f2259da62mr384294ejk.52.1708712274991; Fri, 23 Feb
 2024 10:17:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZdjTMZRwZ_9GjCmc@redhat.com> <CAHk-=whmiQC_F1s1bWmOhM8csz_zxL32B=sPGgaz1kiTK_T2iA@mail.gmail.com>
 <20240223174629.GB5743@lst.de>
In-Reply-To: <20240223174629.GB5743@lst.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Feb 2024 10:17:38 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjU-9SAYOWWJbAsEW3fwSXggB=KGWFjYCtmu1yAURM-iw@mail.gmail.com>
Message-ID: <CAHk-=wjU-9SAYOWWJbAsEW3fwSXggB=KGWFjYCtmu1yAURM-iw@mail.gmail.com>
Subject: Re: [git pull] device mapper fixes for 6.8-rc6
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, 
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	Alasdair G Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Mikulas Patocka <mpatocka@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 23 Feb 2024 at 09:46, Christoph Hellwig <hch@lst.de> wrote:
>
> I'll let Ming speak, but I think the idea was to remove the padding
> at the end of the structure when embedded into the bio.

It's not horribly obvious if the beginning is aligned there either.

> Does __aligned also work on struct members?  If so we could add a
> __aligned(8) to bi_sector an get exactly what we want..

Hmm. I'm not sure that works. I think sizeof may always end up being
aligned to alignof (because otherwise arrays cannot work)

And looking at

    struct bio_integrity_payload {

there's odd padding both before _and_ after the struct bvec_iter due
to having three 16-bit fields in between.

So right now I think that packing ends up actually horrid. I don't see
any *reason* for that odd setup, but right now it might have actually
end up being 2-byte aligned with a two-byte padding hole at the end.

             Linus
