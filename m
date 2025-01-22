Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2D61607AC
	for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 20:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737576749; cv=none; b=DSpj5n7ig3tZ3MLfdaSO08dznQJBIACW48Hf+QWWliZLMNr+iGHt+8sJSf516I8fvbzt7d0FUILZxGTZrjjmYK7ujnZb4Y77otZAmOoLT6ziWdBgYNJAwwDVtDntvOzeWS/Y7YA7y1Zo+Fzw0TTrhfHdkbAKmtj+GrPXFe9mzgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737576749; c=relaxed/simple;
	bh=W7q4G3b9tyl4INBAjnb4r2PnZcnvth9+CPAxg39Yc4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S3D8YsoVoGOF4Rrra+GP9qd+i8NIYvoYPAm7y5R8Qvh+gYqW7pWMSaS0hlHukjGtF6kuFcnicOwW7Jc9tAPXTDCQVKV1b3AFPSx5vCHg5HSzy1LkPqMbuV9jrePtGYoIDggdFxAcISdDbp2JyAXBbScF5zLMJkzlV3BEmBIwUAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zu01AJep; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zu01AJep"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e573136107bso237517276.3
        for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 12:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737576747; x=1738181547; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GHIjxD6Xiq1Xyan7l7RD2L3kUXxPViITS/jCxGCx1m4=;
        b=Zu01AJepzCtNhpgVVv6IW20EyZd8J0X5QpOGYpJhijTfeSM/a896vAol8Tva9BCGZJ
         HDEKPxe6WHNiNejnyXGrPzihqUhie2kg/T/g90MH5qwW7DzuuarwM36LgH5v6zbrAFpb
         TRQ54ZKP5lxB5MSmtFRe0hZTOGtK/QaUB/ekQz2K6WJT4LOxt2JBA3aQm7XWljJ5NxjD
         nJejDv/uvy8kUTwVP9cfIxnIPOrZcHEOV8X07R3VB9Y1RHsoMkfwczy9bmmYiR8Mto7b
         Rs/w2XOqfM3o6feygIiGlJDR2fQDfozoAe/xAgp0E21wEPFpVq+vVnMO05HfIRZZjG3u
         7+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737576747; x=1738181547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GHIjxD6Xiq1Xyan7l7RD2L3kUXxPViITS/jCxGCx1m4=;
        b=B8uncKm+a304yKRg4jMLGWcWlyCxJXCcMSFA7aBeE8r4N3PdJEmNd54mBM/59C8zrv
         UyakLcX7WlPwF9AFOERU44pQ2OAlWSpkieFldd9dk5+h56UTYZM6qYv1EU8/m1ZREKTB
         GTrpife/bglPOBP5jYjMDV/GBRW+p1rCmXUnpUTaSEjt4c50eIvImKwdM74W+AfSdabB
         5lfa64G4xX2Euvsdmg4R5n5TCbvaa0QAavaOocDhiRKZ6I1UXI6TvpJVGF+lwvz4svYG
         J/qo2wygiXnpl1ev+TD6RImE3BdkeJSELs7gdWCZyS2900XBd6nfYfZuZiE3/h1Y/bXn
         UKmA==
X-Gm-Message-State: AOJu0YzCCxngOZaRu8zTmzfd8BtDVaRFOtp9T2LbEKSvBlY3D498ahZU
	JazioQ/JkxUThKN04IBpwaPt/kBUVbMkAfYeOlcPbgrwABMLfe2lAZqpnO7d6jWx2TcAiKq4UQN
	iPYmxt93j0QTU1PXAaKepdwKkJfk=
X-Gm-Gg: ASbGncubr+81unFl1PX0bTQOVMfI8ZGrak3IgSoYNis3i543isu7HXVDx0d+SvR9xhD
	/4e+cKQNJaGxm3GeSyNAef4tvIf4WK/IdTKzCqkBl5ISaEhzRLuU5
X-Google-Smtp-Source: AGHT+IHtGPgL1aXLwprTXI2Y0ht6nkpPfo8btk5oNI8VKlTbDodXf4tWoMdM4H1pXBkCZzsXGZCDl2047uQJzA57ccI=
X-Received: by 2002:a05:690c:380f:b0:6f7:409c:f645 with SMTP id
 00721157ae682-6f7409cfce8mr28229237b3.4.1737576746801; Wed, 22 Jan 2025
 12:12:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAAiJnjoGn4Jn6O-SWAaAzwNk4DhEiCFUA0Q0X2RLdrHH7NR5qg@mail.gmail.com>
 <2f847044-fef9-4cfd-95c6-038c07468e0d@redhat.com> <CAAiJnjpdDU9rVLag0mFTy1iYb+aPFVq+QaBMjEn4cq1fp4YbbA@mail.gmail.com>
 <996fa43a-4255-48ba-9eeb-eea518d9c407@redhat.com>
In-Reply-To: <996fa43a-4255-48ba-9eeb-eea518d9c407@redhat.com>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Wed, 22 Jan 2025 22:12:16 +0200
X-Gm-Features: AbW1kvZhHMl2ctBBxUnCjC_3P4PZhfKOW1xMXw9hIrx5yZ6AcR4nlDrvRfLiWJ8
Message-ID: <CAAiJnjoWFTcgMLUdN37uH-NKfd31YzBjcDi+PW4Opw3M9z4OZQ@mail.gmail.com>
Subject: Re: Adding zstd to VDO
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm not a Linux developer.  I have no patches.

But I'm a Linux admin, who very actively uses VDO for storage
solutions.  Zstd would be very useful in cases where more compression
ratio is required.

So this is just feedback from fields.

Glad to know that this is on the roadmap.

Thank you Matt

=D1=81=D1=80, 22 =D1=8F=D0=BD=D0=B2. 2025=E2=80=AF=D0=B3. =D0=B2 20:56, Mat=
thew Sakai <msakai@redhat.com>:
>
>
>
> On 1/22/25 4:35 AM, Anton Gavriliuk wrote:
> > For storage server solutions space saving is very useful, both
> > compression and deduplication are important.  Deduplication is just a
> > part of the story.
> >
> > What if the compression algorithm (lz4 or zstd) could be selected per
> > device basis with default lz4 ?
> >
> > It also may not be a bad idea to add compression levels from --fast to =
--best.
> >
> > Combining above, users could select different algorithms (lz4, zstd),
> > different compression ratios and speed for each device.
> >
> > For instance - there are 2 volumes, one with hot data and lz4, another
> > with cold data with zstd, but both volumes with deduplication.
> >
> >> Switching algorithms after data has been written to the volume could m=
ake older compressed data unreadable, so we don't want to allow that.
> >
> > Yes, there must be a warning, that after selecting the algorithm there
> > is no turning back.
> >
> > An example - nearly a year ago, HPE's software defined storage
> > solution - "Alletra MP" compression algorithm was switched to lz4 ->
> > zstd.
> >
> > If still keeps a single compression algorithm, zstd almost always
> > looks better lz4 (probably except decompress speed)
>
> We cannot remove support for lz4. There are existing users that rely on i=
t.
>
> I have no objection to adding more options, though. It's on our roadmap
> already, so perhaps we'll look into it. If you wanted to put together
> patches for adding this, we'd certainly take a look at them.
>
> Matt
>
> > Anton
> >
> > =D1=81=D1=80, 22 =D1=8F=D0=BD=D0=B2. 2025=E2=80=AF=D0=B3. =D0=B2 04:59,=
 Matthew Sakai <msakai@redhat.com>:
> >>
> >> It's a reasonable idea. We've discussed it before but it hasn't been
> >> particularly high priority. Since VDO is mainly focused on
> >> deduplication, it's not clear how much it would help to use a differen=
t
> >> compression algorithm, but it shouldn't hurt anything, either.
> >>
> >> To make this work we'd want to add a new create-time option to specify
> >> the compression algorithm to use. Switching algorithms after data has
> >> been written to the volume could make older compressed data unreadable=
,
> >> so we don't want to allow that.
> >>
> >> Matt
> >>
> >> On 1/18/25 12:53 PM, Anton Gavriliuk wrote:
> >>> What if zstd can be added to VDO as a compression algorithm along wit=
h lz4 ?
> >>>
> >>> It could provide more flexibility for users - faster compression or
> >>> better compression ratio.
> >>>
> >>> Anton
> >>>
> >>
> >
>
