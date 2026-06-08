Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886C8330337
	for <dm-devel@lists.linux.dev>; Mon,  8 Jun 2026 16:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780934625; cv=pass; b=GDg7DuiGasB/hVLjl+J2vnmH66BSQH1wSVEF4aSb+AW1n7wHZWxuPmfAgh0ykmLklnK3S9zccpUowb4nMN7Mh8gXkbuUwPjgfhvBYO+7FDlCfHj3WbHIXhsB+srl1F+HP1Mb5HKmrS6VwuS7GntjGYZOORtVXJPGBnWg7aqN6kk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780934625; c=relaxed/simple;
	bh=Jf1uYxbeS7GsTfa9sqPNAGsTSGeb99bZ6uRQ5kxnqng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tdiKiKNpafML30G+PweHx61vnCZD9SBOZvz7ftufzWyTIos8fDJbVFuhpk5aVN7aBqnV32/zMr4oQUbrVN/Yw455zZoxHHR398UsZNNx3ABBVzYjH1GtDzjfGC2FZZEzaAgbW6J2aQhwAhKlK9Tfpf9gE0qCjww3lTJWU5IDvFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=TOeDsEVY; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="TOeDsEVY"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5aa66893e9fso5135229e87.1
        for <dm-devel@lists.linux.dev>; Mon, 08 Jun 2026 09:03:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780934623; cv=none;
        d=google.com; s=arc-20240605;
        b=ERYyByWY1ojnyPabxlrrn6CMDAbgtNpK7jeG+bsXRujutiIH5dtOE/1tP+vAvCLyAA
         NTk+cg98G2ba8/T6CTRjRxSTg1sqG+0GhSkiWT+wh0kjdNm7Hab+dNBPezSlTL59owmo
         muhldILXwb7SACTrVmr4+kH8l7/tLwcQaUlXVheTGpJdUVnkWidwXzQ/VTyAXXyNuss5
         uGi0xy5Hdu8K7FtJA0+VhT+I/DgNvLuOIY2dYH+6/nI+wTh1r37Kc5dSGAbwT6TqQ32m
         +sumvQCCBO8s4DqaLYf8x3vMyEdhRyU2ZvPQw8evWKrFZCfF/HB6pjbYdg7R6bQIo+wm
         UzeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TSAijtJ5QLf5xvxPFsAbVumQMO4Z1tOReihcL8xpg10=;
        fh=ZVMkY5pec+6XEbaUBKmN9IkzKRLLoXgetXiApNKBWZc=;
        b=PU9xSQWv9yuy9WDLYnkQm+MdRFriNQmIKqs6CVGN9u0AXRU18Ho9wqa/eqJY4xWtRU
         ANUpdDHlwOW/PecwatvCM0LHm2HrUr1s+iOFZUcnpVMZXOMiBmZskEsKP1Kp8L9Nouqr
         yQ81LURuNQZNayTmKPEUZ1o+uIx3dQJxn51ZlAFIbwmNfM88zFAp8XhWU1BDEAbTry15
         lEL0YmI50l89uss9/pXC4wEMgoWGZmYmCfbfHGL+UDL5ytXDbgpDxK+9PG9mXA/mC58J
         YZAwfXQfli/mD4nzI6yA4hXHUNIimNd/vOH7uDACv0LIY8FpFvW9Bh4KraXBKHDwCzQy
         GkUw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780934623; x=1781539423; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TSAijtJ5QLf5xvxPFsAbVumQMO4Z1tOReihcL8xpg10=;
        b=TOeDsEVYG7Z81NcChF9Ww8Dwm4VUTM8a20+K061CG5pzKamfq45hyEsrOKGYKC1/fJ
         /GYBqau1po7qGh/D1tY+TAUZTUaBTAVDYubEdGzOsnwar2kaghVaCaPIWOhBTo946v8W
         mnz1tPmbb6n5Igh286RCKzjml6NQCPYMewyLvZGkq7/412eEbGXG3SnicpDIYd1WMww6
         JZu+c4YX7CIzrwwL0Rfi5YarVvYfX/7gamoX7e5aX5KMKgE1WBYz2J5kQgPPPovgitac
         A73m5+q3krk1W2qsjIGlYHlScWy8wlz039WuEAxQQ/5luOP6MUTCRIWVd1nzXRQEk8Eq
         GUqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780934623; x=1781539423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TSAijtJ5QLf5xvxPFsAbVumQMO4Z1tOReihcL8xpg10=;
        b=W/q0uLJeT+ZauqWOQ89GAZtONt/E0+W8+QO8fa/QKBLRu4qEMba5dcGpV4UfLlTyhi
         kXSwmaDkZnHw6YWdVAOXSqNerIFN/FQqN4sXQEVfjx5WzfXohQM2zu5YVZ4iG95ya68e
         vdA1Aa/J+xEo5W+5iX7P9GEFlZ2+d83KMaX1oj/KPUrqt6A51Heypq5piinQNyWNvrVc
         q8dodG8ACiTrlzUCY33wzsVQncKHkMl5Hz5vWjgQ6QaW1cD90Lzfv76VWoJ8ZpHoQoZf
         +1HXm5wmnGzb9F8xrOwdmyrJ4LhhsInqnANKRddC/qltHG0j9H91tvfyoYPYavyhNCHD
         8YqA==
X-Forwarded-Encrypted: i=1; AFNElJ9bWl22uCzYA6uAj6SyHuShUsknZxlgimvv6Odzm3zK7XeZX3slhVV2EGfBxxOscTagBCx9HCMdSQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwuNj14J7A0iwZbVygrlqDjmkCQuTyomxPTBiHYveqAcZWXEjkc
	XOdj7qhYzY9Go28VstGLuQPUjTYCX8OjW1Tc9MyebCDv8ZAwBQ+1laUx3EG/qQ/Cwc9KjKmbIhX
	79cToQerHR1l3mMozSx7kisEUfRz2XqPJxOc5x5rq4w==
X-Gm-Gg: Acq92OEwabEmW613hAcEtr+5m/6no3eWTgrVf1Zz0I0r4t2la2Nz3xBj2hSM1Zkryaa
	sDcUcYcgBwJBzTjN+lppyPke7qCLRffgdyYGvcYY7axIbQj55R3DGhmeLPo8W2lGQMgmOkNwhAt
	XAcSpBuDh9Fm/XyQqW9eOCBOsUjibIaY7GqXDuldRxCAix/0tRb9WAS5qmV8kb7wSzE9bfNudQN
	7QZhej00lpY/Xlo05AGiWmtzdNcQVbuxdbUGEWwXjkNcsgP5k0RT3tv6qVFrgBjkxSKowzx4dAq
	e56oSwXrnqaK24ZHxq+hY8hXlTY=
X-Received: by 2002:a05:6512:3092:b0:5aa:5ce4:8e4d with SMTP id
 2adb3069b0e04-5aa87bc88e9mr5590502e87.29.1780934622623; Mon, 08 Jun 2026
 09:03:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260603175151.25026-1-sam.moelius@trailofbits.com> <f6c41bca-c80f-368e-f0bf-e6b57c4af9d0@redhat.com>
In-Reply-To: <f6c41bca-c80f-368e-f0bf-e6b57c4af9d0@redhat.com>
From: Samuel Moelius <sam.moelius@trailofbits.com>
Date: Mon, 8 Jun 2026 12:03:31 -0400
X-Gm-Features: AVVi8CeFGlI4Dda80AXif2fn3M2NMWwS7reClAzO0klrGb2WlQHjbc7yRlxUHHU
Message-ID: <CAE+C+Da2DypH+ZOOw9Dha35gumZgz=hSe=m4AF1boUyFJcQEjQ@mail.gmail.com>
Subject: Re: [PATCH] dm ebs: drop dirty bufio state when discarding blocks
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 8, 2026 at 10:16=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
>
>
> On Wed, 3 Jun 2026, Samuel Moelius wrote:
>
> > dm-ebs can discard a block while a dirty dm-bufio buffer for the
> > same block is still cached.  If that buffer is later written back,
> > stale data can be written over the discarded state.
> >
> > That resurrects data that userspace explicitly discarded and breaks
> > the expected discard semantics of the target.
> >
> > Invalidate or clean the matching bufio state when processing discards
> > so that old dirty buffers cannot be written back after the discard.
> >
> > Assisted-by: Codex:gpt-5.5-cyber-preview
> > Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> > ---
> >  drivers/md/dm-ebs-target.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
> > index 1e52bde48b91..9fece535a0b3 100644
> > --- a/drivers/md/dm-ebs-target.c
> > +++ b/drivers/md/dm-ebs-target.c
> > @@ -212,8 +212,12 @@ static void __ebs_process_bios(struct work_struct =
*ws)
> >                       write =3D true;
> >                       r =3D __ebs_rw_bio(ec, REQ_OP_WRITE, bio);
> >               } else if (bio_op(bio) =3D=3D REQ_OP_DISCARD) {
> > -                     __ebs_forget_bio(ec, bio);
> > -                     r =3D __ebs_discard_bio(ec, bio);
> > +                     if (write)
> > +                             r =3D dm_bufio_write_dirty_buffers(ec->bu=
fio);
> > +                     if (!r) {
> > +                             __ebs_forget_bio(ec, bio);
> > +                             r =3D __ebs_discard_bio(ec, bio);
> > +                     }
> >               }
> >
> >               if (r < 0)
>
> Hi
>
> There's a bug in the patch - when the "write" variable is false, "r" is
> equal to -EIO, thus __ebs_forget_bio and __ebs_discard_bio is skipped at
> all.
>
> If dm_bufio_write_dirty_buffers returns non-zero, the error is erroneousl=
y
> reported on the discard bio (that is innocent) and not on the write bios
> that triggered the error.

v2 forthcoming.
