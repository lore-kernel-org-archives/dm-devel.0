Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6E5CA40
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 15:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721143887; cv=none; b=BsFpKJKbysJvfTAIepKCsFQ1shO4OXQ86Bhr0/EoQlcfraa5XC2RMlnJbN/zv1AFEwOX5+mqfxs7o1ASqcSiZ93YQ1lF8zCWfy4e6rf2GqjIpHt4rhL1w6XwpoktgtVqh5faXBavMU2G//UjsIDTS3+0PX2vkaS7CvwMYGvrXHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721143887; c=relaxed/simple;
	bh=x1jz0zYTy48DpZRGm3/4H4c1kJBHnwiDX6sBd8Ug1Xc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kVVTk56hQ4J+d3iCi+Ka+IHeEd9n9ydXpglSRJ4FO7e/ixiSl/LmrAoYzF4caY6aIJPz3NVt0kg6sVk/emdd9q4mj0MPOJtuhH3WgrBvhHkV8RbU/elUhsUoRtN8wxNomWnG8NkoXZFicP4KOBVvxbFtuDEQ4b9GkaC8AdnHsF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Iehkvqwi; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Iehkvqwi"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a77c349bb81so586163466b.3
        for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 08:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721143883; x=1721748683; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x1jz0zYTy48DpZRGm3/4H4c1kJBHnwiDX6sBd8Ug1Xc=;
        b=IehkvqwiwMqVn6LiviTBferrhGCSgV4RI+wGrSuIN12+Gqgu8DskVsOiiswIGBqRDW
         HDcdZw7AE0fIcKa4sXbx68RRNV7P1HYxJmvRESRB5+j6zbzpog6WF55Y4WrjJAQAIQUz
         GCWy0W3L2Cn0fVCYc3ZvYyAURs6HfDYbtYo3LBF6acGPbsAe/JH8Kt/HjC/Nuuc9diIB
         cbugfIEpRfM8Sec51uG8S0zGjNG7i29Hl00ML8KM4bwi3piGX46QG+Spe8Xz/UxxDT5h
         gD7aKF+QT/7/N2/SVrbxJg+yYxAOf86msqhJ3BBP6QH5lmeu6CGeYxAI5GAuxDnzmu+A
         6j+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721143883; x=1721748683;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x1jz0zYTy48DpZRGm3/4H4c1kJBHnwiDX6sBd8Ug1Xc=;
        b=Fps2wrikRIumeNPic5S2jZXAKyTKmTP6czy7OIFipF+AKM4YcUvre14qyjRr3holhb
         zFGOndsDU2xeWJZUTxPgq2LRbyge3r+VQ3EY0QsM+k/1Kya0pZKaxhvX3WESZQVIgQKH
         sjBH3fCHUSpURFvJGoXAJRMTfCOJ7zkZYPN8e6W13kfWptTXnWtW+q9yn1zjN+BT1z6f
         SkHmfrLkoi6KrNe3OLz69bjFcGt3KmPRdkiYUgK1D3gsirDXu06z2LzXkuR3vg21CXmq
         v71VFjmKgjl+jh648WaFX2KNwsbr7mrwcGAPAQXRMnLEAwLj9NJFVoK8sneOnm/mHpHD
         xU6A==
X-Forwarded-Encrypted: i=1; AJvYcCVfXq5/y6bni5oHTFh+BjapCo/RV945lNH9jKTuxj1o79fhHv+jDDK+wet23QVPqTZEVwvhKJ17vMmJiBHP5+9oGMU9PxXNvIc=
X-Gm-Message-State: AOJu0Yw2/fWLetsdKCrgXFx3xPiBZIvZksMFIwBdraO9qGFwPMzI5g5D
	I0S/SVnQVuoCtETVt2ZOkt6MazC+57G4e6mD0PJwJVDToxvGQDlM8lOmRSdsyv0=
X-Google-Smtp-Source: AGHT+IHD3CJdJLnAC/M+cJhaPSKABonCq36i0NbqQTKVyX/tQNBXfYURhN9znzHSPOEImi43hHczdA==
X-Received: by 2002:a17:906:6d46:b0:a77:cd4f:e4ee with SMTP id a640c23a62f3a-a79eaa844fcmr151706966b.69.1721143882416;
        Tue, 16 Jul 2024 08:31:22 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc7f1dbesm329801666b.115.2024.07.16.08.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jul 2024 08:31:22 -0700 (PDT)
Message-ID: <e4d026c96c634401e5796f892082fab8d0af8a7a.camel@suse.com>
Subject: Re: [PATCH 09/22] multipathd: set pp->tick = max_checkint in
 handle_uninitialized_path
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Tue, 16 Jul 2024 17:31:21 +0200
In-Reply-To: <ZpaJHme9GN2YrswA@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-10-bmarzins@redhat.com>
	 <eab659b313c56abfb6f6bb8780bebdf656cd2994.camel@suse.com>
	 <ZpaJHme9GN2YrswA@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-07-16 at 10:52 -0400, Benjamin Marzinski wrote:
> On Mon, Jul 15, 2024 at 06:00:33PM +0200, Martin Wilck wrote:
> > On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> > > When handle_uninitialized_path() checks a path, it will either:
> > > 1. trigger a new uevent to initalize the path, in which case it
> > > won't
> > > =C2=A0=C2=A0 check the path again until that uevent is processed and
> > > updates
> > > =C2=A0=C2=A0 pp->tick
> > > 2. blacklist the path, in which case the path gets removed
> > > 3. intialize the path correctly, in which case it sets pp->tick =3D
> > > 1
> > > 4. fail to initialize the path, in which case it was supposed to
> > > set
> > > =C2=A0=C2=A0 pp->tick to max_checkint, but instead it set pp->checkin=
t to
> > > =C2=A0=C2=A0 max_checkint, which never worked correctly.
> > >=20
> > > By setting pp->tick to max_checkint at the start,
> > > handle_uninitialized_path() will continue to work as it
> > > previously
> > > did,
> > > except in case 4, where in now works correctly. There's no point
> > > in
> > > messing with pp->checkint for paths that haven't been initialized
> > > yet.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
> >=20
> > Q: I suppose it makes sense to backport this to earlier releases?
>=20
> It's not a horrible bug. Previously, we set pp->tick to checkint
> early
> in the function. This just means that these problematic paths will
> be checked every checkint instead of every max_checkint.
>=20
> Also, do you mean distros backporting this change? I'm not sure how
> much value there is in maintaining upstream stable branches.

Yes, I was referring to distro backporting. I don't want to start
stable branches upstream, although we've had several cases where I
thought it might be worth it.

Martin

