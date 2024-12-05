Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7450192589
	for <dm-devel@lists.linux.dev>; Thu,  5 Dec 2024 10:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733395417; cv=none; b=BBtJ6JHJ2x2rFnQz+2y1Gl1yyBv3f8RZQUE59CtPnI6hzxBRkdXBl5pWpntc2CUem59qKm55nvedUzQSr/HLCikOAdLKOiwmqWb4uABQNcEy3ujTDzUiFHHbzNtdJw+JRNMGkVbdkz/xcGcizFSB+En1szRaocJ2qm0uWxBm0JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733395417; c=relaxed/simple;
	bh=lFqaJk46mR6SyrUoJkZTKEuhyBCTPaTre/xBG7RGfQQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hBnozrZ85TlSsGDIvNuoatyO52d4dwBIf8+gtcmh+w/tGC5m6I7XTpMXahYwSFXWKX7dbHu+H5y1vCe9w9EfmrhqFgJSJ3hsKTChXfWZ80zAIg1gfIxwiXf6OWEKoEjYU9zE3fxaWbjKxqgcKCcUps71ujzeIbHeai5CJdQ2+Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PBhSHIMn; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PBhSHIMn"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-434a9f2da82so4900815e9.2
        for <dm-devel@lists.linux.dev>; Thu, 05 Dec 2024 02:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733395413; x=1734000213; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gbmzT4aOB+5bRUhGd1OK77k+GcLfVRPTGQFx/CJwVIY=;
        b=PBhSHIMnCLxgdiNC8Pmg9hRauT0Hr1ts+afuxBJViH8UT8QJlVPULTSq0ZJV65dJ1j
         THHOtPzG+wlYxecEkvJkJxQkRMSgzVnFeWIKUfLpgnvctScYrArBypX61uK0hJhs3ynO
         XkqD9yAgPQDQP1v6OHb5WCuQmUAijoN/kvdQRFtgx3hnvWPsWxhBY7n5pIkjCT8xBgAb
         bUEoIh5asl8a99QwVQV2XUTDTTMEK8CuS5PeKXLTU2gjhWdkNm3HCXvoKaGWfHZdUs+g
         TCODfqrL5Gm58Nk9H9IMCNBkxSdNXGSjhw+dT2UnaFNQBa4mALVZtXZfqArgjoNiRl1a
         i9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733395413; x=1734000213;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gbmzT4aOB+5bRUhGd1OK77k+GcLfVRPTGQFx/CJwVIY=;
        b=Oknxl8V6mmyL+gyl79tSM321X6N57V2p69x+6veEpizrRxsuJeUXZaVaxQix8NGtCq
         xJEeuFZKiL33v4f2A1JRIy9t72mLs1ZGD2vaCwgG7pds0cuhW7e3L4arDp1c3H8Olpss
         Tqi8n43Aax9C6R4pTmpp/6Kzqd8p1K2iMY49RI9To/qAg+lw4jQliMnRInrB8xrwYV5N
         SgoNE21VUqggh/u+i8EJGQAslejiopDsYjkbbeCuDXcPWvfxjgOuj/saS21+zxUhjxZv
         1D8y4kKEjw4o8hP8i621+w+AH4EVmYcTFzYIkvLTzpIY2C9r4b5kTBVV86g3DhJuJyXG
         0fdA==
X-Gm-Message-State: AOJu0YxJAhb2pegUYwtYEezsCdSWEtimWK20VtjZJ8VEVq5T4SEm2MEv
	zRt2VXCyYAXb4Gja/3qwxDh1Yt2F5lofWXt70xe3QERX90lVgkfRsTFcY/cGsh0=
X-Gm-Gg: ASbGncvaYgUUrr0Mad/55qq3ErG4Li0LxZzs5VvyaDrnGtIgF8Dq3LYb1tP+g/Ue6nb
	c1+HAA6mj1XuWFBUw9Qh7xoPf/HddSxWoW9LP8bzHscwrNgKotOQTZmiSYDC4FnElZTECVpk9rq
	6iem+4TYzLrdxL5pN6rYoHgxeoZnOPJdIl/7BXBxqwMr3R2S+oyYQu/Ly6ya0y4cLfpBnUp9V6z
	4gWlbOcEZrg91y2ORibANlfPQrbMhx/OTcnCHcvdSMH5pt4j1dohHcl4TLDYHXItgxbe4jt8t5d
	ZCj8Mc9/YBtTkeqi4WsBIZ+6Hyt1hZCnteImHHNY2ZsHeAARNyYlk9YWLziV32Ufe8OcaKcQw3t
	rqyiEcQ==
X-Google-Smtp-Source: AGHT+IESkoQMAojLYr2kxoOZ6swlj1jePe50WgrQNNzqCUfdNvAAZC6TNznHurUMHhYAXtT0c+LPQQ==
X-Received: by 2002:a05:600c:5121:b0:434:a169:6ff8 with SMTP id 5b1f17b1804b1-434d09b149bmr94426195e9.3.1733395412919;
        Thu, 05 Dec 2024 02:43:32 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434d52cad51sm55870525e9.36.2024.12.05.02.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 02:43:32 -0800 (PST)
Message-ID: <be8de1c8e017d28d5652467eda47081540e46026.camel@suse.com>
Subject: Re: [PATCH 1/3] libmultipath: Don't skip set_path_max_sectors_kb()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 05 Dec 2024 11:43:31 +0100
In-Reply-To: <20241205035638.1218953-2-bmarzins@redhat.com>
References: <20241205035638.1218953-1-bmarzins@redhat.com>
	 <20241205035638.1218953-2-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-12-04 at 22:56 -0500, Benjamin Marzinski wrote:
> If a multipath device already has need_reload set when a path is
> adopted, it won't call set_path_max_sectors_kb() because of
> short-circuit evaluation. This isn't what's intended.
>=20
> Fixes: e5e20c7b ("libmultipath: set max_sectors_kb in adopt_paths()")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/structs_vec.c | 3 +--
> =C2=A01 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index d22056ca..60051092 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -335,8 +335,7 @@ int adopt_paths(vector pathvec, struct multipath
> *mpp,
> =C2=A0				 */
> =C2=A0				if (!current_mpp ||
> =C2=A0				=C2=A0=C2=A0=C2=A0
> !mp_find_path_by_devt(current_mpp, pp->dev_t))
> -					mpp->need_reload =3D mpp-
> >need_reload ||
> -
> 						set_path_max_sectors_kb(pp, mpp->max_sectors_kb);
> +					mpp->need_reload =3D
> set_path_max_sectors_kb(pp, mpp->max_sectors_kb) || mpp->need_reload;
> =C2=A0			}
> =C2=A0
> =C2=A0			pp->mpp =3D mpp;

Reviewed-by: Martin Wilck <mwilck@suse.com>

