Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA103BE169
	for <dm-devel@lists.linux.dev>; Mon, 13 Apr 2026 11:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776078697; cv=none; b=CaxW0lg+CRF6KlGeVQTW0XrbL9pPVoI6hCoI/9wXOQk/RbhTlCcEzHcuS/XeerZTo/0e5zpupO6zWx40wu7Cajbfi6rUT7IOcVo6rdLXUFyHQJzVkgjfjrJsY4gdbHkTUWO5DQtTYauP0tBDJ3/XMgD5O5gtx5+OVM/i8dBqVBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776078697; c=relaxed/simple;
	bh=IciDWw+pPOzZt1pek6gtVjPQvBfXbNETkHcKMNKdodM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mDIeh4LVFxi5ggt+HzyhxWwhT965QaEprp2cI8tlsgnH0+9FnEjGIM81xVVEMfajvzKMNegPiSDYEzb1/yXhA9LYCHX0ECbyIIbwA2U6FJfMUYCAvz0LTZQ21kntgZjBCVmTvnJgg45Cosb1g+6ovwN3V1624QhF+OFmroktb/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eHsAY+aC; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eHsAY+aC"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43d75312379so706334f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 13 Apr 2026 04:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776078694; x=1776683494; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=omEpNF4Dq/HUycdHuzuumEDIzfvEIx14FVBrBumLq/4=;
        b=eHsAY+aCIKiODIvBm5Pzb2kdwEKIvKKpJzxDLSiX6VNl6C6huNczo7JW2/r4sGLlZ4
         QtlNUoddoo4BxK4SuWn5l2DyEFMQHLtVOgQIpEC/4OrmikLQt87DqQil9sC22AectWat
         2caZrk6txbsvlKvUVttEQqi06XxHaF6VmHj6liYek3IeGTLQl22sBkC4I6Bp6BVf2aVK
         W+feFMtHQkTYZIB8XT9psOM7hw66LgUfJPlIXT21ugViKvkFFErkTprbQw+FNZdj707k
         BiBV6WVVHeTWhaIZBKfclIKs9f2g0/oZOomtKb83Xl880ExeqB2xG9W6VK5L1WBV+JeX
         u8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776078694; x=1776683494;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=omEpNF4Dq/HUycdHuzuumEDIzfvEIx14FVBrBumLq/4=;
        b=WwAAhMIkdZBFc9dry4sPL+ctMOhB5z/BawVEO1Dm0DExqjKfhg2wQxtM88IyPTtd4h
         PwbUo17KT8nZUFXdLpNozk1B+JFWGhslpz9FGEqvKMHTJgmPefnSbAmRCGd6Ls+1pH7V
         jaktY23mGvtwMsbY17Y6aDAPFR82AGKr/NijUi2anC9P6cfN3MzdLxZCa6iQ/V/lq3nj
         Vms3/bpBPoeTTlp2anL30z0RHz7pw1VPpZmL0Yl7I6ZX7TlBVufE9L2byG/WBPsBEQnj
         1I9s13iSfpkSjO6fdAdoq9iCYl+DTmcGacuymdjc//wWMOuXk4sRTaU/F1Iytnh/Jour
         2hvw==
X-Gm-Message-State: AOJu0YwT/211seQug57mqnKYs4TqBlipe+bjn775H+kvk/PQjvkaQKjE
	+yP119s+C8HcFPSS7L2wFr982hA9g0WkFnfs4OdLjzHtnqboX6Ay+aI4quey+LumDV7I3Ij7JDN
	UOICsQsY=
X-Gm-Gg: AeBDietgcKQXHPRxmDHUkXOwR/gcQ73rtqyDbzFlQ81gQo2QysS+aEiX2BgToWP2VyP
	wmabU8ngNCJwA8RHju9vpMQwFj7w8TWsZVWOGSM3Jbw7CI548K67drVPjGlBYJSFlZ+ARhGUCqv
	Tu9QS6IwY82FAdUmk5evkaIIELgX5uX7OT668t6gWXJqFxoVkpy+BB6rN7wq93RsQYPSRkyNdOH
	P0dlsdaFCpBRlNW0r7/T7pa2sgifsabbxc9h21ZeLzzjcxPGKJY2GtX35OlWsgPF3BPIxh2wQYz
	CpxrGKQiOvV3VuOZy5vA3hi23IHic1Orcy4emVSEQ0VmSPqr5WmEKnp22FtPwCLdsah3JRn8R9Q
	bWzRJmlGdS/uaQWboX/2804k8HifqvK3DLh/c+p+voq0CJhriO9PgO+cQAOFaolMgk58Q+QwdZo
	3anBKgmABcvH9Gk329WebQD9uWvO1WH+oDl9iFU513J9CpsanxcIrR7Lb/1RoCfznam+BXnZXdK
	lyPa4PUabCuCgSF/TvilP7UWa8V9lZ9CZqV1AyUjHlpSO9Cnq1ZBzc/iJFoafxqRyQa4Q==
X-Received: by 2002:a5d:5d03:0:b0:437:7719:ca82 with SMTP id ffacd0b85a97d-43d6491fef7mr17689246f8f.3.1776078694089;
        Mon, 13 Apr 2026 04:11:34 -0700 (PDT)
Received: from ?IPv6:2003:de:374a:600:5c73:df0a:ad60:5173? (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63e5c981sm33472009f8f.33.2026.04.13.04.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 04:11:33 -0700 (PDT)
Message-ID: <6fe5f3fc3894f2227a4ebda322256580fb4711c8.camel@suse.com>
Subject: Re: [PATCH] libmultipath: Handle SCSI-2 style vpd page 0x83
 descriptors
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 13 Apr 2026 13:11:33 +0200
In-Reply-To: <20260327034136.1157685-1-bmarzins@redhat.com>
References: <20260327034136.1157685-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2026-03-26 at 23:41 -0400, Benjamin Marzinski wrote:
> Some older SCSI devices return a SCSI-2 style vpd page 0x83, instead
> of
> a SPC-2/3 format one. The SCSI-2 page 83 format returns an IEEE WWN
> in
> binary encoded hexi-decimal in the 16 bytes following the initial
> 4-byte page 83 reply header.
>=20
> Check the 7th byte of the vpd page 83 buffer to determine whether
> this
> is a SCSI-2 or SPC-2/3 confomant one. Byte 7 is the 3rd byte of first
> Identification descriptor in a SPC-2/3 confromant vpd page 83. This
> is a
> reserved field, and is guaranteed to be 0. If it is not zero, then it
> is
> likely the 3rd byte of a SCSI-2 Identifier (The first 3 bytes of the
> ID
> are the Organizationally Unique Identifier). Both the sg_inq and
> scsi_id
> commands handle vpd page 83 this way. To make sure that the WWID
> which
> multipath reads directly from the device matches, it should handle
> this
> format as well.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/discovery.c | 13 +++++++++
> =C2=A0tests/vpd.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 | 58
> ++++++++++++++++++++++++++++++++++++++++
> =C2=A02 files changed, 71 insertions(+)
>=20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 0efb8213..057ff45f 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1208,6 +1208,18 @@ parse_vpd_pg83(const unsigned char *in, size_t
> in_len,
> =C2=A0	if (out_len <=3D 1)
> =C2=A0		return 0;
> =C2=A0
> +	/*
> +	 * Not a valid SPC-2/3 vpd page 83. Assume it's a SCSI-2
> style
> +	 * descriptor.
> +	 */
> +	if (in[6] !=3D 0) {

Make sure that if in_len is > 6 (or actually, large enough to hold the
SCSI-2 ID)?

> +		len =3D 0;
> +		vpd_type =3D 0x3;
> +		vpd_len =3D in_len - 4;
> +		vpd =3D in + 4;
> +		goto decode;
> +	}
> +

Regards,
Martin
