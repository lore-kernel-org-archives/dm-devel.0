Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D79FD528
	for <dm-devel@lists.linux.dev>; Mon, 23 Sep 2024 09:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727084486; cv=none; b=RG4v+/CGg8t7AMR8SUfbYvi8USH9KHmoQSUDU9lfbhq55jCpxnFeVd77fZE3TC53pH9aprtbYLJeEZBJEcpadUtQIj6rCFfENwUYHDGafJmTUX0D55ynNb10FGmzmp4E/0YfDfDtjERxSImvamneF2wwq6J94V5Z0n1IcLrXzYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727084486; c=relaxed/simple;
	bh=BrAPmjItXRv7X5ThPou8prkegS0mJXmWRnJB7lWJDVg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WCJGveR4LwpeBWRpA6VMcVlkvU4PmhRGb7njsuRWaOP4HyW6CGe57cjvZLXsV76BnURywqtUs7/oLUY1FlE6FAX4dXuayn2AGFNbU1SJAtkuXjQ8lX8lT/APXsTsDJdLZzZUb4gabBxqHf+Hx7bkV/9EbQ/fC4vZqVYC8eMHzqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZEoQqelZ; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZEoQqelZ"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e1d06c728b8so3740385276.0
        for <dm-devel@lists.linux.dev>; Mon, 23 Sep 2024 02:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727084484; x=1727689284; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F91xt0V7YuKpig7zsWEYy6f7MzxzaBrNwG9NU/F/mWI=;
        b=ZEoQqelZo+vQIix1cTGu3f/evgA/dKkcNcRi/xrWyR4WIs+I6wGWBMus4rfqOvlDi0
         a0SQmeD8VdALCmWxnp/SCAnlSDQ0ETg3GzX3pZVVqzIbiPb5s2BIe75caC/4YQMrffUw
         TtISU/dUL8qcd8Z37H6Q1yM4+vt4wKi/OGOOlyNfP2SpUizkBLpGXVnRDzvIdcd7GR8t
         CoOl0uadtjYyEHHEW/M1ofU9xKJaZ4Tu7npnACpt57dxE8eaGXu3r04DAL/TCDRJIiJM
         Q1Jkqk4n5izRYK9alo8KeD52k+R+ifPi2Xn9vTxswKS/8zrbwvHhYqDKRc1D++yifIi8
         8f9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727084484; x=1727689284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F91xt0V7YuKpig7zsWEYy6f7MzxzaBrNwG9NU/F/mWI=;
        b=meCJkIhbaB81qxllKCoolEPujcC/rWj73YZsabtZK79/XfWZTF1+fgBrN6iy728RxY
         8Oznokc3b45Y8WpG45Cj/onjDEWFWkiAiwc/rMbb6pwJJX4i5BbDtDIe11gJq4l45oV4
         Yo9m/8ptmkYSkN9boBKNwCpZRCkXUkI47FcyZ+pCxu9QFWCv+6H8JTvFxeL69xPqfPx8
         dh9lEnCIYTenCZ9/q21zrBZq0vYByFw1JWdToK5eeOwmWPayeE38l4z4bgt+hWzWwqca
         rRkak8Z5ONjDocyq+na5hle0SLl2wUiwyZp8ynTv+LKDAPBixwbFTmxaHqE7+L+CZLdQ
         dxbw==
X-Forwarded-Encrypted: i=1; AJvYcCX9U2uSo6Oa62qVDCCnLk3GdVc9T9AJBNrDCVn0b6AlzgQpZQqNvf99UdxAK3nPP6NSaBnKVpwJvg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxvwiw3dnUsKgtTTD99VTFaXH41dcwurOCQyBw7XOeYJzSLcLn2
	FL/bDPu43teTP7ZAslDd8A68s9zS/dJdISbxFigvmZzmcJtWcH5ysvhgBOyujd0/KIgwxcj7085
	fIFy7mPbY+Ls1/u8lMBFedoeV73s=
X-Google-Smtp-Source: AGHT+IFPbftLMsCem8+UtgNObpHXwT/6AY6KYSkVrEr1xmU8L2UE/AJxRqVhih56VJeyeUL3mWA2xo2bUWbpqLvxQSU=
X-Received: by 2002:a05:6902:1b90:b0:e22:4edc:25bf with SMTP id
 3f1490d57ef6-e2250cc001cmr8069977276.47.1727084484048; Mon, 23 Sep 2024
 02:41:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240922164702.49615-1-kdipendra88@gmail.com>
In-Reply-To: <20240922164702.49615-1-kdipendra88@gmail.com>
From: Ming-Hung Tsai <mingnus@gmail.com>
Date: Mon, 23 Sep 2024 17:40:48 +0800
Message-ID: <CAAYit8TfBD40aRchLiOWsvqwpAR0x6nW9zObza4vLVzg93N+eA@mail.gmail.com>
Subject: Re: [PATCH] Return error code for failure input for sscanf in parse_cblock_range()
To: Dipendra Khadka <kdipendra88@gmail.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2024 at 12:47=E2=80=AFAM Dipendra Khadka <kdipendra88@gmail=
.com> wrote:
>
> Smatch reported following:
> '''
> drivers/md/dm-cache-target.c:3204 parse_cblock_range() warn: sscanf doesn=
't return error codes
> drivers/md/dm-cache-target.c:3217 parse_cblock_range() warn: sscanf doesn=
't return error codes
> '''
>
> Since, the only negative value that is returned by sscanf is -1.
> Returning -ENVAL when sscanf returns -1.
>
> Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
> ---
>  drivers/md/dm-cache-target.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 17f0fab1e254..c35d65e310d6 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -3200,8 +3200,8 @@ static int parse_cblock_range(struct cache *cache, =
const char *str,
>          * Try and parse form (ii) first.
>          */
>         r =3D sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
> -       if (r < 0)
> -               return r;
> +       if (r =3D=3D -1)
> +               return -EINVAL;
>
>         if (r =3D=3D 2) {
>                 result->begin =3D to_cblock(b);
> @@ -3213,8 +3213,8 @@ static int parse_cblock_range(struct cache *cache, =
const char *str,
>          * That didn't work, try form (i).
>          */
>         r =3D sscanf(str, "%llu%c", &b, &dummy);
> -       if (r < 0)
> -               return r;
> +       if (r =3D=3D -1)
> +               return -EINVAL;
>
>         if (r =3D=3D 1) {
>                 result->begin =3D to_cblock(b);


Could you please clarify how to reproduce unexpected results? From
what I observe, the kernel's sscanf doesn't return -1 on an empty
input. Even if a negative value other than -EINVAL is returned, it is
handled by the callers.

Hank

> --
> 2.43.0
>
>
