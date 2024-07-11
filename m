Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8618916DC21
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 11:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720696124; cv=none; b=XbTAtQFQgH4ns72p6Z69p6GkN5kiHqHRkiRM0unVzl+KUFjtEgNEbBI4b/s6Jzt6notNcZVx75mzcbhYbMZwx1nhycelJSEwKKqVATXP0bIeW6tY/z51dsxh/rZWeq0WxPas7shXmCqMqhcrWisI2iRv51yvIwTeokLrRJKBAJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720696124; c=relaxed/simple;
	bh=PWdpUR+l5APJtv5v/R/Idq6v+fMRbsK93y/olC7PXZY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=htb7LSOhxdhCxUkwgXR4urD8SSrgKdDMwgRjZ6KtMAiqK3TwKvlC/GD4eAu8x9dBQkA1FBeZUXWkBZRNFieWwLnpv0ISdp/hVi71wBrrmy00XLUG3wzlTZwNJ9NJk0NtqyXrw/dO8CTnFGmAP4Q9mFPsReG8NboJRBk+Jo2k5xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Pc7Klpcd; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Pc7Klpcd"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a6fd513f18bso99903166b.3
        for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 04:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720696121; x=1721300921; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XkeHykWPrOp+2VbkTOQe8+eYQFCcw69Tnc0YXh1Zt5s=;
        b=Pc7Klpcd4A7oMb1Z3hOzy3ZVmiMDq+TrauTViWpCa35XD1DN9HKKfVZ4XiIG6VR1x2
         DfmpBslMxSWjqqC8eqc4qc38PMpoAWCBR17g28khCa6oJlcLNj1LWSvRwGndeMbFjEYC
         R11jNnK9fwfRiwhhSlMxK00OIy+gzXCt78mfvOzsKbvAQGa9GXM8dQ87H4qrgsMEcRIu
         Ca64LjnXKZsBu98DwGFsUag9Ifwn8VsT1fLv64VXls2Oknb2BUIUep4ZN38kdUnmxVeD
         PUIxSYUr0MDEbm4F+52j4cuyh5ovwolQc91s+sS561XeWoys9PX4VzKAtA0mFzfpoJO7
         ad+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720696121; x=1721300921;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XkeHykWPrOp+2VbkTOQe8+eYQFCcw69Tnc0YXh1Zt5s=;
        b=f3dsh4qS1izKWUKOAVCu3RQ2ZFDaTlCbw/5YwYDzs/2VOPjQYuXPlyQRKbfnn+mMCU
         v2rVgXmmy/EQLVQ2BxPcskvvvprbs7cDTU6bdNgSp1mp4TjpNCwKf+ac2M1THwRR7Fj6
         IbFqvHPXR0dRqDUJW4lcLTiroWHF3R7TLzQW9vYesOOd2m0ZSc9CzHb7jzOO/WJ8LHJo
         bE9HtAvs+fmrkZA6eMcDm6cloAOb6++QjU9CiMgKq2Hbed17LxovF4VC35R+RVf7qYqI
         zqcAFBqq5boFAZcWkz425gn/6XWO1PAc6DZadACzrELx5aKr11eLxk8dI0OF+ed64Hti
         eXAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjsJ4j/zcq5mWpotO9Qn0DeLsCtYGsv6Ng/wB5rHp4uODQ2J0fxVuApVmCjWtLdItNVxg30XM8rNQqXgSH/19QJK3xAeg6jOI=
X-Gm-Message-State: AOJu0YzHYfMkqrnLtqVb5WUc68ezPRbF191SlQEkTYy2A6vbU/Fzv6eH
	RayvI7VMXGCEEpmMBAnR5IIjpEIwIu+cQmTORrYrya6PqzOdxPrfEn7xUkZqcoI=
X-Google-Smtp-Source: AGHT+IG+1+Xu0wFCWKKWd233KlIByMxqwDmJccYkmQkncFeVFEKr72Al2cLrwuaQJ9T2990+Tmv0iQ==
X-Received: by 2002:a17:907:94d2:b0:a68:bae4:d66f with SMTP id a640c23a62f3a-a780b6b2fd4mr589324466b.30.1720696120652;
        Thu, 11 Jul 2024 04:08:40 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a6bc7b4sm249006066b.43.2024.07.11.04.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 04:08:40 -0700 (PDT)
Message-ID: <8348b96fc7ae7ddce4886efebcecbd7416a40d98.camel@suse.com>
Subject: Re: [PATCH 21/44] libmultipath: is_mpath_part(): improve parsing
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Thu, 11 Jul 2024 13:08:39 +0200
In-Reply-To: <Zo8RMOqoXP-b3dWz@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
	 <20240709213935.177028-22-mwilck@suse.com> <Zo8RMOqoXP-b3dWz@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-07-10 at 18:54 -0400, Benjamin Marzinski wrote:
> On Tue, Jul 09, 2024 at 11:39:12PM +0200, Martin Wilck wrote:
> > Use sscanf to make the parsing of the UUID more robust.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmultipath/devmapper.c | 17 +++++++----------
> > =C2=A01 file changed, 7 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 56157af..d62a7dd 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -846,23 +846,20 @@ int dm_get_uuid(const char *name, char *uuid,
> > int uuid_len)
> > =C2=A0
> > =C2=A0static int is_mpath_part(const char *part_name, const char
> > *map_name)
> > =C2=A0{
> > -	char *p;
> > -	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN];
> > +	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN], c;
> > +	int np, nc;
> > =C2=A0
> > =C2=A0	if (dm_get_dm_uuid(part_name, part_uuid) !=3D DMP_OK)
> > =C2=A0		return 0;
> > =C2=A0
> > +	if (2 !=3D sscanf(part_uuid, "part%d-%n" UUID_PREFIX "%c",
> > &np, &nc, &c)
>=20
> we should probably use "part%u-%n" so we can't match a "-" before the
> number.

That doesn't work, %u accepts negative numbers, too
(https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf)
That's why I use int and check whether the result is positive.

Martin

