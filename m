Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E4233CE95
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 20:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766175270; cv=none; b=mNxzcX7Fk09pN7Jzj4f0vV6f0VhkjGG1g5z5EQfg5nNG4jIFtVvihFopD6PXWLn3SgGbU//PxxT/2eabLeFvhfYsR1neLgFzyb2qVrJ4nRpTXh9GSW0ZytHVDyJ5s3Cy/nu9bfXpHhYvtiB8S7d/Zv/L1Umf49aF7Btb/YYYtVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766175270; c=relaxed/simple;
	bh=dIxfwhhJL0i/I8nr6bMpMUsa10C0sVgxYpQj4hnaMz8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gHejTrDSDRVh40UANm8XUdB8PTtss81EdaJFcI67ABN49IiBzIMgoQ05oVwAf0LZnavziJc62P/mq5W6d3h/b3uX8Fbn9nA0IpHiEUEndkw2Zr4WVrNUSk5xB7n1//6E/wNHdws1C/uFQqS+4qqFwD0cf1o1gKcrJT+UPrnl9yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QJA6nmsE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QJA6nmsE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766175268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NBfdYfCkq8K5J6dzHLuqBSpEl8OulRkj0yogBVBa9eY=;
	b=QJA6nmsEhsWsFwuQQJcef/QG9feBK3+h/op/fRCkh1lEIx+sMi7d+U8/Ii3xAmhHmFxw3/
	vcJWjy4w+g2O/u+n23CQgESC4LOoe6k1Vm3T09Pg0lXtZCq4tTi6CMkI8xGhTBQ4ISPJZI
	oYmcSuc1nhybbzfg0UUoQQ9lhBVmYyE=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-n0S6Q8crN-q71e14fzxBgA-1; Fri, 19 Dec 2025 15:14:25 -0500
X-MC-Unique: n0S6Q8crN-q71e14fzxBgA-1
X-Mimecast-MFC-AGG-ID: n0S6Q8crN-q71e14fzxBgA_1766175264
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-78e70a60973so24386277b3.3
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 12:14:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766175264; x=1766780064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NBfdYfCkq8K5J6dzHLuqBSpEl8OulRkj0yogBVBa9eY=;
        b=SCbu+U6DdQKLVXCbD8zYPzkYCFxOlR5dfzr63TfrqZGgv5GpYk6pH3LTX4sxVoPChg
         8qoZm/Wov2RBpb3Brc7dK71Hnh9ZxBxPEfKSAL7Ellbv1xlq7VVeQdPOTW22a5N9l4xE
         7iONXrxtOLTlk7XBsBVi4h+0iXk8sXevITnhh94iAQSheOJLK2ln9rpKFgi61pre5cFl
         iWrvD6942TCHIFxioHgmN3SuG9zs4je+VhFOMnMy4f5Tse4JP33RzA5l6GhtWxvts0Bp
         ms+4nklLduKzVsutrPL1JP6jEjMNCggw0sg5ioR3hQKOnFqCy70wLCE5BU9OpF1Q+c6f
         lMjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNd8j4gCJ4F65I6Fxq5rVnAWZiooN3YdyVD0o8QOSAU5YzSqNu4zD58alyEEdUl3IbvlWCj8g+Cg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1v7312CIGz3c6mpMwbEwr9paq8iLpKiBBR9jW5WGZVZdKHR71
	zeMT0WPd2HiZ+V6plci9l2cTqujbdFfIWumKT9VJ94s3MLf1+LnxANik8GwKiuDfwp1aQZO0eGy
	8tMulI7mONzzF2rmAF82d2/bkrXhWh33P64DZG1LkrGIC2AxKeavAEjrO+v0x+EYhujZGTG+R2m
	Tlofa0REnhKpE0uJlkFdc6xFdaZI5kqNi2ZOc=
X-Gm-Gg: AY/fxX6C0WZ6aIHncHU02z9b3/3hAHBEzRqAypB7BkKh8Af/L6XwdYKkzKaefRYHNGp
	ton3bNnm46bpQ8RcAovunXLLYcdW0h9GIwiBs42Kfq1xX25J5mOW9xmdBlxMwwC4/robb8Mze/S
	Y0YPZc4WYgUgJX34wTYJefsPUj+qTP6dxbJw17F896MxQc5yVOFnyFI1tHwN15aG5f
X-Received: by 2002:a05:690e:d45:b0:644:60d9:7511 with SMTP id 956f58d0204a3-6466a924b7cmr2939904d50.97.1766175264010;
        Fri, 19 Dec 2025 12:14:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHrNtpAXBkLfsv4ZPV7ytMwDCknVLCZ37g47oODzFz+yaO52Pr39pYpvX6RkjSMSLTqKC4vn7AIoer0DNh5XIs=
X-Received: by 2002:a05:690e:d45:b0:644:60d9:7511 with SMTP id
 956f58d0204a3-6466a924b7cmr2939880d50.97.1766175263490; Fri, 19 Dec 2025
 12:14:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251208121020.1780402-1-agruenba@redhat.com> <20251208121020.1780402-7-agruenba@redhat.com>
 <aUERRp7S1A5YXCm4@infradead.org> <CAHc6FU6QCfqTM9zCREdp3o0UzFX99q2QqXgOiNkN8OtnhWYZVQ@mail.gmail.com>
 <aUE3_ubz172iThdl@infradead.org> <CAHc6FU4OeAYgvXGE+QZrAJPqERLS3v7q64uSoVtxJjG0AdZvCA@mail.gmail.com>
 <aUO_u7x-4oIfKMei@infradead.org>
In-Reply-To: <aUO_u7x-4oIfKMei@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 19 Dec 2025 21:14:12 +0100
X-Gm-Features: AQt7F2qA1mcyWoa8p0XYXVuSER3YOFH3464n9K2F3F4P3zepWO8fQIC-uKVJeus
Message-ID: <CAHc6FU7H7gFFRw5FCc58ki85Pbedfs8NegjWQbpN7otzfsJNpg@mail.gmail.com>
Subject: Re: [RFC 06/12] bio: don't check target->bi_status on error
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eRmOV0f4OTftC7GTTD9JLO7ea2RgCezpGSabwqUp2CE_1766175264
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 10:08=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
> On Tue, Dec 16, 2025 at 12:20:07PM +0100, Andreas Gruenbacher wrote:
> > > I still don't understand what you're saying here at all, or what this=
 is
> > > trying to fix or optimize.
> >
> > When we have this construct in the code and we know that status is not =
0:
> >
> >   if (!bio->bi_status)
> >     bio->bi_status =3D status;
> >
> > we can just do this instead:
> >
> >   bio>bi_status =3D status;
>
> But this now overrides the previous status instead of preserving the
> first error?

This is exactly my point: we already don't preserve the first error,
it only looks like we do. Here are the possible cases:

(1) A single bio A: there are no competing completions. A->bi_status
is set before calling bio_endio(), and it can be set to any value
including BLK_STS_OK (0) with a simple assignment.

(2) An A -> B chain: there are two competing completions, and
B->bi_status is the resulting status of the bio chain. Both
completions will immediately update B->bi_status. When B->bi_status is
updated, it must not be set to BLK_STS_OK (0) or else a previous
non-zero status code could be wiped out. But for such a non-zero
status code, a construct like 'if (B->status !=3D BLK_STS_OK) B->status
=3D status' is no better than a simple 'B->status =3D status' because the
if is not atomic. But we only care about preserving an error code, not
the first error code that occurred, so that's fine.

(3) An A -> B -> C chain: There are three competing completions, and
C->bi_status is the resulting status of the bio chain. Not all
completions will immediately update C->bi_status, but if at least one
of the completions fails, we know that we will always end up with a
non-zero error code in C->bi_status eventually.

And again, switching to cmpxchg() would not always preserve the first
error, either: for example, in case (3), if the bios complete in the
order A, C, B and they all fail, C->bi_status would end up with the
error code of C instead of A even though A completed before C.

This could be fixed by chaining all consecutive bios to bio A (the
first one) and reversing the pointer direction so that all cmpxchg()
operations will target A->bi_status. But again, I don't think
preserving the first error is actually needed. And it certainly isn't
being done today.

Thanks,
Andreas

