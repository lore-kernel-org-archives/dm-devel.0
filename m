Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171D43FF1A2
	for <dm-devel@lists.linux.dev>; Wed, 10 Jun 2026 11:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781092321; cv=none; b=kghw46zad8GOOKQKZB9xleoxCrA/y3mLv4zqw81PAh6Iil4XpwzwJiXCjM2vMj4Su3ghrB7Zy2BDnPrQoRAiZFg+v5+oiZbXv5SwJinktjiKjC0RkqDrJ1Wm6aRNwEEnB+GnQHdf4PQ7xITgB6hphl5Y1EcpeizRMfOWsDvZeWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781092321; c=relaxed/simple;
	bh=heVMP6JmUtjecIUYrry+yuyaJ2CD4k4vpWDaRlmAt5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=aqT3TNFJkh4ZjLV8xmKXsqjEZwXs9wigpxfIKRz0M5U/KpIzPf7X/hdvxixeo/dce0CKMjFfH0w9WeXcCLPFHBF+sx4nC3WdsgHopmwk/rrastM/jEmjG7V+i3yNkOUiUiu7jyaG4TBqPk3TQq8asgmiGrjraw4l9Csb4sn2a7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TPdi6fmD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TPdi6fmD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781092317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TqrqS42VtrksIK5677PleKbegQ6oWSw41lfab5R0bTQ=;
	b=TPdi6fmDgUdwHFIMFnt3mtMGrcCfyMB+OOaiSN/vIrHFtdD2XDwyT8tCjI9ab+LoomcvAK
	UC8EffJTP7DPlNeZLCWFVHE9C4wQo3joDrCPkVF7zLlQk5mW5dLwVcVUPp8cfvJIjx3vbX
	2bKx4Fz20VWQwSJQWF1WIj3x5bkxVM4=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-410gMvWDO-irGfVi-Ayoiw-1; Wed, 10 Jun 2026 07:51:56 -0400
X-MC-Unique: 410gMvWDO-irGfVi-Ayoiw-1
X-Mimecast-MFC-AGG-ID: 410gMvWDO-irGfVi-Ayoiw_1781092315
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5aa68e1b53dso5899798e87.3
        for <dm-devel@lists.linux.dev>; Wed, 10 Jun 2026 04:51:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781092315; x=1781697115;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TqrqS42VtrksIK5677PleKbegQ6oWSw41lfab5R0bTQ=;
        b=edz1c/w+R441bsVeeOvNMG/3M0FKHZcp0nE5yXiXEUvRyX/WO9HqI5fz6bOVHIOHJH
         F6tM99tL4MJFfh/33FQMWHKeZiMugRJE7wJt8E1MLArLufEwc8OOPOybJ3VDBwRMx6g0
         uPcRM4YHRlsgS0Rg49O3NovQDZDFNHk2iyAjUv/5+hnKq6bp8gdzruQsFfU8UBCxa3UD
         Pwj49KEPbFe3pEAjAaFBQ5rsBtGG+UO8lpRcn650aDE7hnFhu3rRQ951F/FFY6o8xBlm
         pO7inFWfBeHuH2cmOPa07nK1uscpEJXFJZYXgvG24jGWTBAjpW/exhxVSzPxH6i8CIPk
         sxjg==
X-Forwarded-Encrypted: i=1; AFNElJ/W61RQei5kEH1wRCwNO2AKCXQpyafMXPCsq2tS5owKXr+9qNU5vGGDFpZXJKEFgBEicS6DeTmAKg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyzhZBMuy8N2KJ5OUBSEaYD0hVT5Zz6smy6kCOjbYkM86GlA5Qc
	pSJMNMcqONtYCXYV3g43DfbKRyplow/mtnNvSEtKfeIBMImo8uDTSg4Hu8DUxFznU3Ku3rSfbER
	GsaFR1A+BefFZDp6BcAWW3OxSulVQRCFig0sUoIyBKq+6OeyHOkzmbMmXKyS1+V+G9sw/YtwsmS
	/jFxa/oYE4HvN6bfccClR5Tv7qD11QBFABylcskXrmlQ==
X-Gm-Gg: Acq92OHLbZDScPU/Jrx++24NQpONW1/MzgSkMb3AY2wtb+FpUCMZ0wzeCGLmp8pYL/A
	8/+/GA5gSjwtWiOXGpJi0bXt+zGoChlzfPI4nSaj+4hBaiGRg0bXnzSBdYwW5YKG5+7nm3PQmgB
	X9+ea5oCFzYIUuu1fbq60HpPnUEjgHwk//U2FNd0mF/AiTRrVM/7pfxpDWixBpMbi/xSNdv5Zk3
	tdwQPLeQGF4YoI=
X-Received: by 2002:a05:6512:a95:b0:5ad:a04:e624 with SMTP id 2adb3069b0e04-5ad0a04e776mr1950185e87.40.1781092314702;
        Wed, 10 Jun 2026 04:51:54 -0700 (PDT)
X-Received: by 2002:a05:6512:a95:b0:5ad:a04:e624 with SMTP id
 2adb3069b0e04-5ad0a04e776mr1950169e87.40.1781092314213; Wed, 10 Jun 2026
 04:51:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260609001636.1235504.7288d2831f6d.dm-cache-invalidate-cblock-truncation@trailofbits.com>
In-Reply-To: <20260609001636.1235504.7288d2831f6d.dm-cache-invalidate-cblock-truncation@trailofbits.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Wed, 10 Jun 2026 19:51:41 +0800
X-Gm-Features: AVVi8Cc9Yt-6n2IMboC8SjA9u5e9B8Ah3xEoiLQoe6fwk485MDSHERs4oQAE3Es
Message-ID: <CALjSBEvCkx9xPTOeYOGQs-hdTsMw1vOQ3bX95n9r-ep8tA4BgQ@mail.gmail.com>
Subject: Re: [PATCH] dm cache: reject oversized invalidate_cblocks values
To: Samuel Moelius <sam.moelius@trailofbits.com>, dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IBZYydN5PHccolgWWlfTfssn5yu3Vi6ZU8zUwajBQ7A_1781092315
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 9, 2026 at 8:26=E2=80=AFAM Samuel Moelius
<sam.moelius@trailofbits.com> wrote:
>
> invalidate_cblocks parses the cache block number into an unsigned long
> long, but then stores it in a narrower cblock_t.  Values that do not fit
> in the target type are silently truncated before the cache block is
> invalidated.
>
> That can make a request for one cache block invalidate a different
> block.  It also makes the userspace-visible control file accept input
> that cannot be represented by the mapping it is about to update.
>
> Reject cache block numbers that do not round-trip through cblock_t
> before using them.
>
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> ---
>  drivers/md/dm-cache-target.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 097315a9bf0f..5f1a019a9a8d 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -3330,6 +3330,9 @@ static int parse_cblock_range(struct cache *cache, =
const char *str,
>         r =3D sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
>
>         if (r =3D=3D 2) {
> +               if (b > U32_MAX || e > U32_MAX)
> +                       return -EINVAL;
> +
>                 result->begin =3D to_cblock(b);
>                 result->end =3D to_cblock(e);
>                 return 0;
> @@ -3341,8 +3344,11 @@ static int parse_cblock_range(struct cache *cache,=
 const char *str,
>         r =3D sscanf(str, "%llu%c", &b, &dummy);
>
>         if (r =3D=3D 1) {
> +               if (b > U32_MAX || b =3D=3D U32_MAX)
> +                       return -EINVAL;
> +
>                 result->begin =3D to_cblock(b);
> -               result->end =3D to_cblock(from_cblock(result->begin) + 1u=
);
> +               result->end =3D to_cblock(b + 1);
>                 return 0;
>         }
>
> --
> 2.43.0
>
>

This patch is a half-measure. sscanf() silently wraps on overflow, so
values beyond U64_MAX still get wrapped to a u64 value, bypass the
range check, and invalidate a different block than specified.

Also, in the single-value path, the b =3D=3D U32_MAX check is redundant.
With the original end calculation, end wraps to 0 via uint32_t
overflow, and validate_cblock_range() already rejects it since begin
>=3D end. Neither the extra check nor the new end calculation is needed
here.

To properly fix truncation, a rework using kstrtoull() is needed.

