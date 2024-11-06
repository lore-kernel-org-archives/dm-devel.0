Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55831201021
	for <dm-devel@lists.linux.dev>; Wed,  6 Nov 2024 16:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730909857; cv=none; b=BthQPkg+3Two0zES+cqHvK3/79QE+8cyxduN2PSreB1lomAvX9fPYFfsUfZXvWDzhms/GCSRUQGt6sA1Mg5ZHasbkcVERWYCfG23Uf7G5VY166IQZbeEpJaGsCwHCJ2aVW5Cw3S6qgP2CBJRFRZljGg7htHIJG9FAT87Mm6vjH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730909857; c=relaxed/simple;
	bh=sO7H8EExAD/mpX2Wrvv+j+ocCQb36UqnmHD01s1vwKc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oTUXyU+jxYtJewR8SqpEEyHzCNZVRdBZJwFmSISKtWxvnihcoibChQJaqNi7VXbFzrtC9UBRucgDLaRohsazfltgcbPJ1vsx7t0Nc9Tbpe87PIxaA4V6Mk+5iHBR8jq2nJsQKR3n2wwo8P091fwi5HAOSI1GfViL1bEgvi297KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C+UYk0sv; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C+UYk0sv"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5cacb76e924so9321150a12.0
        for <dm-devel@lists.linux.dev>; Wed, 06 Nov 2024 08:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730909853; x=1731514653; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mBHD5fZLcT1eGteyvlhrcnLDFjmxT7pFY2rf8pC76H8=;
        b=C+UYk0svEVNyO7sUfUZzDod+j7G9cxykGtdfH4v3PHe7LcVxJz6jmsInEg2hSIiHG0
         ibWnMklB0c/rfQo6LQFsbigfma8DVOnVolw8aROUoif4VJz5uJ6hA/uKzOTPsUELrf5y
         Ag+/dFqiEAoUsE32PhS2fyLThxUzjkWh3Kc1uDYfy74eRWnDRd2UQHgWKS+9w5sMkSB+
         EtF1n/P5D6qgLYgDWBeEVIEyLIcQWkswlWW3FaQ6QLwUDGcxbY3UopWMDzMfF5BqEneC
         wbeAM5PkHgGTLYgvISX+QUrNUGH4PLKBYLjwzHJGWZxy5kM4Mewp002pShmEWxVZ0d52
         B2fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730909853; x=1731514653;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mBHD5fZLcT1eGteyvlhrcnLDFjmxT7pFY2rf8pC76H8=;
        b=htdKtxN7XpxXO54/u7hgJ7JdG1krjvVPMUMiBwHr9kaGl6+sjxV1X5rj8tuthp9Vus
         fnmtikHwN9/uqM8WTCvagy0oP4uEYH1yyKct4v1RpnefKR/oMZv2q8QaDJRSswWti8z6
         viH7YykIdHnIz1LVjLqZB79qIcPaaslKmGNlN1lf8aFescAuu9sDm404gA0akVt5p7pW
         AR9bbX6cD+cIxEVzhBUp6iziIJLmAu0rCLNh0kGlxkrBSwdHuZnEseJzCPHC1FBKXDFb
         49WxywKlLKHz+itAV+EGWzPrR8XWpwZJ6Xk7PA2QJiUAXU3Qbi3mWHf3fnt2sZC1APMA
         3Gcw==
X-Gm-Message-State: AOJu0YwlsfVFASLPKOukW5RzJogjxIC7X24RBNjFP7WmzeXt0vHbXQ+0
	tCIWQlJC6NEeb2EKk2DB+9AJty03y32TPJDRgwn+liMQiZEDk9N09XwSxSwJl8Q=
X-Google-Smtp-Source: AGHT+IFp5OrZivgKMDU/lu4FoK0J/eW+/Xw+tWi8CtIgitu6zQmDi4S1Jok5EFtJd+I5vLwdBG21Ow==
X-Received: by 2002:a05:6402:35c4:b0:5ce:de11:dc09 with SMTP id 4fb4d7f45d1cf-5cede11dc1emr6508054a12.10.1730909853223;
        Wed, 06 Nov 2024 08:17:33 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cee6b11314sm2928358a12.88.2024.11.06.08.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 08:17:32 -0800 (PST)
Message-ID: <08ddd03d48938378f6281f14f52dfd8b942f9476.camel@suse.com>
Subject: Re: [PATCH 6/8] libmultipath: signal multipath UUID device with no
 table
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 06 Nov 2024 17:17:30 +0100
In-Reply-To: <20241031183301.391416-7-bmarzins@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
	 <20241031183301.391416-7-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-10-31 at 14:32 -0400, Benjamin Marzinski wrote:
> if libmp_mapinfo() is run on a device that has a multipath prefixed
> DM
> UUID but no table (either active or inactive), it will now return
> with a
> new exit code, DMP_BAD_DEV, to signal that this is an invalid
> multipath
> device. Currently all code paths treat this identically to
> DMP_NOT_FOUND.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/devmapper.c | 18 ++++++++++++++++++
> =C2=A0libmultipath/devmapper.h |=C2=A0 5 ++++-
> =C2=A02 files changed, 22 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 13d8c1e5..6e11d5b5 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -726,6 +726,22 @@ static int libmp_mapinfo__(int flags, mapid_t
> id, mapinfo_t info, const char *ma
> =C2=A0	}
> =C2=A0
> =C2=A0	if (info.target || info.status || info.size || flags &
> MAPINFO_TGT_TYPE__) {
> +		if (!dmi.live_table) {
> +			/*
> +			 * If this is device has a multipath uuid
> but no
> +			 * table, flag it, so multipath can clean it
> up
> +			 */
> +			if (flags & MAPINFO_CHECK_UUID &&
> +			=C2=A0=C2=A0=C2=A0 !dmi.inactive_table) {
> +				condlog(2, "%s: multipath map %s has
> no table",
> +					fname__, map_id);
> +				return DMP_BAD_DEV;


What about the case when there's an inactive_table? AFAIU that means
that a resume operation after a table (re)load failed or was
interrupted, or that the program that (re)loaded the table (multipathd,
probably) died before it could resume the table.

In this case we'd fall through the the "map has no targets" case, but
shouldn't we also treat it as DMP_BAD_DEV?

Martin

