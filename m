Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E550871B50
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 18:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713205095; cv=none; b=VARbzK8AsYS+b9fddd7aUJqAPbpDORv7GFlFTd75pEQImhFAMhOatPaeqjB9t4limkFPIDX41p3lkHKuZPgkHYvPVfQ2FVdyjeAuQfFfZH6ND69w0P2qoe7MJ7h1yey8AOJOgVNiFzh4VXzRwJPP0Tmy/t7qBlQVrO/dvfO7hJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713205095; c=relaxed/simple;
	bh=Vl6RvOLPe2nGkfazTaZuOYjnyAo276Yd+r5R+5pkOxc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZcmcpEWqbGQRf26ZaraQeDFetEwRVZ8mgCroFaD0UABI3hGMlY6dlXsotL5bHiyEibbFTXAyGj2GxUqnP+ELNIU3HddDFV94sWxCaVS58x53+IsbTOSEaG6XfdDPp8OWgpdM1oo7rJ5H1loOSJY6VsGVOVlucHCpaHsPuh9zrig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=feacCTVQ; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="feacCTVQ"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-56e6affdd21so973296a12.3
        for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 11:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713205090; x=1713809890; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vl6RvOLPe2nGkfazTaZuOYjnyAo276Yd+r5R+5pkOxc=;
        b=feacCTVQcqBYhffLBG8FWs4dBFymj7yIXYRaOkfWKIVBeIpo2Q3r/ocU4tc3szItmH
         pWnB3nuNfWgHdN8aW466gcUeNfv00Gm+0oF+RdAFOdxpdMjNXij6PJGJ3vTC4NHj7CE+
         2Rhrrbt4Yq/h3wPsDMzD4fII+x8lv2x/hLYXnirI1JKgaDlSTFRVgeeLAGpQ9pbVe4BZ
         v11wVIF9IUMcooqAaggwm9AudwcNCbDLsLaPoegOCkBnW/+UQjb3FE+eG+Xx1ZbdeVYx
         2TCkbnfKobdVTBPyMgIOHdizNuZBd9nDyhLHydpXnm3tlye/BUmrr7md5kfyemT2t/5C
         bDig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713205090; x=1713809890;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vl6RvOLPe2nGkfazTaZuOYjnyAo276Yd+r5R+5pkOxc=;
        b=NCGCQ1YhVoFCJGOvK5LPFeFx58LoQWdRET9RQD8dnAoavpUnyTJcfgGoYBwCettQ5c
         uD8w3/DwdxsljjDahMx5Lh0ySDgMIepzHWLDwi5e3hiQAnAnFVpn1s7K2eUEQX5VdGE8
         ieRO3EQu31p+jfeo5OwU8wU40HmzDSGXmJ68wTOukeqkqtR50grIy+qGQZWobRAqSAig
         rwEk5UFgKEeTDVwWQREajW8BmJ0rct6Hi8DjptMZeLwjyWJV8ag5AWRL+IZjoxSAPFxy
         S9WYTWE/HB6Rcusgm814xXZNkwDrwnkXHOMYnARiiQMeG09G5Y0Nz5K/ZDXMsl17AQrK
         CsOg==
X-Gm-Message-State: AOJu0YwFiElE2nYh8IFQk7YQS73ngIiHEiZHC3gUyhfDLJm+CL36kEIB
	9Z9i8D0W4SGSKk0KIpK3vBW0iKV+P6uZB0Lzkse0oX1mHtQeUftGTdEVp9+o8a+8ZjG2NDLJxff
	a
X-Google-Smtp-Source: AGHT+IHiH2ndpK6SkN2PdBojy40s97F5avmzky3gVf3moVAhVLUwy5TW9tZ9JJ2uoFx/MH3kYZWEcw==
X-Received: by 2002:a50:d516:0:b0:568:d7fe:a768 with SMTP id u22-20020a50d516000000b00568d7fea768mr9412007edi.25.1713205090068;
        Mon, 15 Apr 2024 11:18:10 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with ESMTPSA id j25-20020aa7c359000000b0056ff4faa0b9sm4454253edr.6.2024.04.15.11.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 11:18:09 -0700 (PDT)
Message-ID: <7959de14debd4e414e40de89a6267f587de14bb9.camel@suse.com>
Subject: Re: [PATCH] multipathd: Set CPUWeight to 1000
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Apr 2024 20:18:08 +0200
In-Reply-To: <20240415180646.1903335-1-bmarzins@redhat.com>
References: <20240415180646.1903335-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-04-15 at 14:06 -0400, Benjamin Marzinski wrote:
> If multipathd doesn't become a real time process, it was scheduled as
> a
> normal process, without any priority increase. Bump up the CPUWeight
> so
> that even as a normal process, it will still run with increased
> priority.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0multipathd/multipathd.service.in | 1 +
> =C2=A01 file changed, 1 insertion(+)

Reviewed-by: Martin Wilck <mwilck@suse.com>

But let's also decrease the default value for LimitRTPRIO.

Martin


>=20
> diff --git a/multipathd/multipathd.service.in
> b/multipathd/multipathd.service.in
> index 18bb367e..1b3fccd2 100644
> --- a/multipathd/multipathd.service.in
> +++ b/multipathd/multipathd.service.in
> @@ -20,6 +20,7 @@ ExecStart=3D/sbin/multipathd -d -s
> =C2=A0ExecReload=3D/sbin/multipathd reconfigure
> =C2=A0TasksMax=3Dinfinity
> =C2=A0LimitRTPRIO=3Dinfinity
> +CPUWeight=3D1000
> =C2=A0
> =C2=A0[Install]
> =C2=A0WantedBy=3Dsysinit.target

