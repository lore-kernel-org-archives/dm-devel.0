Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9C51EB36
	for <dm-devel@lists.linux.dev>; Sun, 18 Aug 2024 17:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724001782; cv=none; b=oTgoFzuq6SZq7YIgHjYxx4OcgEzsAufnn/vQGExoi4urtBMD254M71k+7kMXhU2zuIN0Rrojd+F4rJk0AQ2Wk2PIM92DQF9mTsBR6iQ2kX7EY9ZETpcxuiVdeKr27V+Dz0aQP4RFJBrJh6sDk20nWBsEN0mXxv81yuRgxW9yi14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724001782; c=relaxed/simple;
	bh=PRdiw6GJWM/P370VLjhMZ0dhU6tZKbF78aSZqYEGp5g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yuu49qrD4Zp07BYyPcy4O/royO6vRiRcNJaseZp9iYSLXOW74eUR0W3Po4L3Xp8nM2jvpLnSF6Nz89KNoi+bk+mhtdaOG7LuOofAi7cL65cfpen6OlkF6Dcx9DnohEwBB8Qu/0SB1r8mSPlNvTfrMdYx/rrVq+wFitnfxslF59U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=UXKj/1LR; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="UXKj/1LR"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e0875f1e9edso3558833276.1
        for <dm-devel@lists.linux.dev>; Sun, 18 Aug 2024 10:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1724001779; x=1724606579; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rea1kNp4EkbAOzAU8f/a10Vwm+fxF1V1CIr9tWa1sDQ=;
        b=UXKj/1LRgAjk7uI6sdRAqLcdoaeQAcE/MOSEkNR1diBhoId1oJHH+ylXFrOC778Ln+
         CUoB7MGoV7Td8Poz2Xqsz95o0auAbTumdfTa2EIlqHYcBZLjSE4afSs1XWzTXwXVKOx6
         0RNJqKBhyxXS1Qz38szlNwO10ZeLuCmawzZvkE1sMcKuCEnlmD8GrOhk3r7rjeYbb1Pe
         6wdU1WkHu0kBzWGZDzT6grS0f8T2Nh4ACZUgLpAKC5M6TF93GwOGANiswhrd1N8RZ3kL
         uSv8jO/zd4RyqoEemUXARHC16WM8884uuzZMi3VTnjh8hJTVg1m5WaBtP2oDU/tqpgF8
         IH5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724001779; x=1724606579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rea1kNp4EkbAOzAU8f/a10Vwm+fxF1V1CIr9tWa1sDQ=;
        b=dM7zmukaNezuurBfMT6TajvFaQ/iPG9oQECEMt2vrlYcJZ6j3MJ6dDIfyENUTBAAFE
         0KB2hrdl7pmpzenEz052r2uzAbPDOo9JxFRx06zx1cM/zR8gdfhb6oHTGXjGLJ84xCEL
         51PE99Z9lGVzb4FpkMBAL00a9J78xcfLkh3u32hqa4YPM3S6cFr4cxXaBnPSZCvYkwxv
         c1vN93xmFlrlgIxoFBP8nCs4WGLrI4aBrdoF5+/roIduAJAJe2XaGBipe/zrKhDcwf4e
         ynMsBI1GHE/KElMmNYmulgpFe4/w8/4mmvAl1YuZYk0zyPpF4V7sAKG/ILQUizgmhJsJ
         7pVw==
X-Forwarded-Encrypted: i=1; AJvYcCVi0k62p8FinmXr18A3JUt8smCaUELd7LUAhFRnkk3xmZ5ODV/cu4Gi4C9ETfmp1/PzN98YkJfdYLZoa1VRXsL+0JHNG7rFGKc=
X-Gm-Message-State: AOJu0YwUpGOQH9ZVHkwh1gseHyqKgNil1PP3oJPzv4aqXNL5rgwZPwU+
	gQpB1oglqSg1bh8hh/ej4KqUfoQtL096KP19u10vC4pEydXdpAo1tLTCLw9QnsJ9EYZG2MLqToF
	7JWY5QKDWt30kCkEz4UNJWclYtpLrm/BZdSUT
X-Google-Smtp-Source: AGHT+IFjiqllbtZbfh6H7hOfR01xf4G8PNDyn1RyHhO2ITzkhGOqhIPLS7VFIHAGqVDoJDMdk8WysOY4o+NEDwrxuHA=
X-Received: by 2002:a05:690c:ec5:b0:64b:7500:2e9 with SMTP id
 00721157ae682-6b1b759714bmr105555907b3.9.1724001779618; Sun, 18 Aug 2024
 10:22:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1722665314-21156-1-git-send-email-wufan@linux.microsoft.com>
 <1722665314-21156-13-git-send-email-wufan@linux.microsoft.com>
 <9dc30ca6-486c-4fa9-910d-ed1dc6da0e95@linux.microsoft.com>
 <CAHC9VhQrnu8Sj=XnDvg=wGTBxacvMSW6OJyG3-tpwrsbGat6vA@mail.gmail.com>
 <88695db-efc0-6cc6-13ee-fd7c2abe61c@redhat.com> <ac6e33b8-ec1f-494a-874f-9a16d3316fce@linux.microsoft.com>
In-Reply-To: <ac6e33b8-ec1f-494a-874f-9a16d3316fce@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Sun, 18 Aug 2024 13:22:48 -0400
Message-ID: <CAHC9VhSe0HkzX0gy5Oo+549wG9xqfeHmsveJqdR_xRcYtim+sA@mail.gmail.com>
Subject: Re: [PATCH v20 12/20] dm verity: expose root hash digest and
 signature data to LSMs
To: Fan Wu <wufan@linux.microsoft.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Alasdair Kergon <agk@redhat.com>, linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024 at 3:11=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
> On 8/16/2024 6:35 AM, Mikulas Patocka wrote:

...

> >>>>
> >>>> +#ifdef CONFIG_SECURITY
> >>>> +     u8 *root_digest_sig;    /* signature of the root digest */
> >>>> +#endif /* CONFIG_SECURITY */
> >>>>        unsigned int salt_size;
> >>>>        sector_t data_start;    /* data offset in 512-byte sectors */
> >>>>        sector_t hash_start;    /* hash start in blocks */
> >>>> @@ -58,6 +61,9 @@ struct dm_verity {
> >>>>        bool hash_failed:1;     /* set if hash of any block failed */
> >>>>        bool use_bh_wq:1;       /* try to verify in BH wq before norm=
al work-queue */
> >>>>        unsigned int digest_size;       /* digest size for the curren=
t hash algorithm */
> >>>> +#ifdef CONFIG_SECURITY
> >>>> +     unsigned int sig_size;  /* root digest signature size */
> >>>> +#endif /* CONFIG_SECURITY */
> >>>>        unsigned int hash_reqsize; /* the size of temporary space for=
 crypto */
> >>>>        enum verity_mode mode;  /* mode for handling verification err=
ors */
> >>>>        unsigned int corrupted_errs;/* Number of errors for corrupted=
 blocks */
> >
> > Just nit-picking: I would move "unsigned int sig_size" up, after "u8
> > *root_digest_sig" entry.
> >
> > Mikulas
>
> Sure, I can make these two fields together.

Fan, do you want me to move the @sig_size field when merging or are
you planning to submit another revision?  I'm happy to do it during
the merge, but I don't want to bother if you are going to post another
patchset.

--=20
paul-moore.com
