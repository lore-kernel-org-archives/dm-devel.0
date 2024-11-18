Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAC019259B
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 11:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731928866; cv=none; b=cKynh8ECmT3K713fgG+k0OtluZtzV4PEnWwOTluD0q9iguClWY6uo834m2HmAkLM6K1M/Qm5vFwCcIQLHo+Vi2B0LLB9cLEzBgpvWxp18AxoaAMRVuIgScH1oS1wpeg7vYO9U56dFov6au+ZBhE98E8Y3r4lUpCCcIC5YyhICS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731928866; c=relaxed/simple;
	bh=gVzdma2oE9e4uKkwHQ5DGbp5lMz8Ys8yJONByP1NRH4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PttYMOCbOM6QkxePfhf0Vop9I9XD+gWo/8VxAJSZSLQmu/h8EnM6hYzQNrB7ScwNAsYeMYCf3cjGvHH/ZpHTupyetcvv14/Sqv2MzlE29gVWhAC3UP4G9cxPhONAAqmTsbD1K1KuaMfLl50l6h0VLhsgyYyCBt1M6BtBQDTi3rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eiX1uZHt; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eiX1uZHt"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539e63c8678so1877143e87.0
        for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 03:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731928863; x=1732533663; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u9flgTmPhsBOfY5XZ7Ygsx1p23rcJz5gNeOBVFNP+/M=;
        b=eiX1uZHtHZ+fclaevaRTNoiiqqqipQR/f54VNvCjlfIrUhLGETzHv0mTDulm8KI2/q
         4+NvaFs1JfeVXn/cxPs0nU04Qfra1QI+usHst/Vg4N1t50CUl37b5SqWtpiq6Z/Qf3ac
         owvYvOgFav5oHFGCLTr7kO6JS4aylKgwsaI/aUALhSXBhQ2hTe6v3X70QorpbAzWX9AD
         Gwx4ddZZ4xXorOJR5pEETX4Qjo99ua1UhBQwaq7uK9dhAWExW1NpbaHKNgdMPOIWOl85
         oQzxrRGS+AR8XjuSBtrtEYUTMuBYVF7tSo0Ei3WcuaEqVgKjLwzlDHvR7KhzF4B9O4UT
         0xlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731928863; x=1732533663;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u9flgTmPhsBOfY5XZ7Ygsx1p23rcJz5gNeOBVFNP+/M=;
        b=g1bc7O8lC5TSPBaIXLxHiCJOlxot51ij+A8tIU0fbjZujzXHYvLFr+O4GKrT3JIBmu
         g4OwAsWIj/XFbYeiVC1lIdDCFDwTk191ajGUT3XjUIA+omBQ94PqdkXt5V9lmzMUVaRK
         AKCu6eDNd/5A7c5U8xOnBTWzvNt4V/m/pNaWQYEr3m+u3FwD/rJpkQQPvYR8215jfTaU
         Eg/P3ElSd/k3kCOU7YReSr3BeKY0qP0Uk5pKVSTuzFYV5Uydz00P3RfS71OmCLU49mfM
         c6JudzFxJqxgko39vZenOVh2t+uUZnkjR1S89lZN8dHgQUsOblmILfYQyXwXK5HaXG/8
         uPuA==
X-Gm-Message-State: AOJu0YzGdtYd96N3p05GgK8xZlWNKeuOx052A5gj3NmmZ3pvcxxgVUa/
	FKk0m57Vm5/9xo27qnhMPyxh/tUW/qND5zpA6Yu7F2EZt8rFOwkr/Xwe7aKa6Ss=
X-Google-Smtp-Source: AGHT+IFd9VEEiy48uEkWBsf/g/kZB4sQpjGsFZ77Ix4hksOhOR7KJn/+1BUCJv14WYKCqV+N8NJUzw==
X-Received: by 2002:a05:6512:2242:b0:52c:9468:c991 with SMTP id 2adb3069b0e04-53dab29bb1cmr4580006e87.14.1731928862589;
        Mon, 18 Nov 2024 03:21:02 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382488f784esm2383624f8f.14.2024.11.18.03.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 03:21:02 -0800 (PST)
Message-ID: <74d9cd1eb2dc39dfa5e365791ba000b480c73a09.camel@suse.com>
Subject: Re: [PATCH 3/6] libmultipath: fix removing device after failed
 creation
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 18 Nov 2024 12:21:01 +0100
In-Reply-To: <20241115232256.627933-4-bmarzins@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
	 <20241115232256.627933-4-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-11-15 at 18:22 -0500, Benjamin Marzinski wrote:
> dm_flush_nap_nosync() only removes a device if it has a multipath
> table.
> On failed removes, there is no table, so this function does nothing.
> Instead, if libmp_mapinfo() returns DMP_EMPTY, then there is an empty
> map,
> and it is removed using dm_device_remove().
>=20
> Also, since there are no longer any callers of dm_flush_map_nosync(),
> remove it.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/devmapper.c | 7 +++++--
> =C2=A0libmultipath/devmapper.h | 1 -
> =C2=A02 files changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index b718dccf..842e7c80 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -557,9 +557,12 @@ int dm_addmap_create (struct multipath *mpp,
> char * params)
> =C2=A0		 * Failing the second part leaves an empty map.
> Clean it up.
> =C2=A0		 */
> =C2=A0		err =3D errno;
> -		if (dm_map_present(mpp->alias)) {
> +		if (libmp_mapinfo(DM_MAP_BY_NAME |
> MAPINFO_MPATH_ONLY |
> +				=C2=A0 MAPINFO_CHECK_UUID,
> +				(mapid_t) { .str =3D mpp->alias },
> +				(mapinfo_t) { .uuid =3D NULL }) =3D=3D
> DMP_EMPTY) {
> =C2=A0			condlog(3, "%s: failed to load map (a path
> might be in use)", mpp->alias);

This error message seems wrong for emtpy tables.

Martin


