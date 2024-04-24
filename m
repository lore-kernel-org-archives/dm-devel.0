Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AB2158867
	for <dm-devel@lists.linux.dev>; Wed, 24 Apr 2024 16:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713976864; cv=none; b=fRyde1UBe6xf1d9BI1R+qZKXcg+heGXVXS0XGhtYGnF38nBB28D/px9G94RrKYFo4GqLjBWq5sVvkrYlHmuJo6MLkR2DAasJBt0TrVcxuWEStog0+bYWXDl2bdnMFeNAwZZiVMqUc+4Vi1DjwCGK3IPu7yRD7Ny94R48Idiolio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713976864; c=relaxed/simple;
	bh=OkDFm2Ic8zvsmHgmQ46jkKnIiCi6x8Ew3VngU6Ls4fE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qYhWDGAMv4xo0B5qK+47qXZHWYC2x1i+kUjfW2cypvaOwI2q0usSsYyQ3JI6CfNhwUaXZonz7aGZpYGTXas4mzynx9FJTcAfeBhsfEjzb2EqHdVpJQSocFtdHkRQkX8URO0J2j898t3R3Hc/9MOI100f+0BuQ/CP3T4la7YEvi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ToCBvJay; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ToCBvJay"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-34665dd7744so5414210f8f.1
        for <dm-devel@lists.linux.dev>; Wed, 24 Apr 2024 09:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713976860; x=1714581660; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GQHM/80L6vhM7cw/Fvp/X5UhuquOsJNM/l9Z3p65l1Q=;
        b=ToCBvJayNFlfPDeCwtDUB+nowiazcaj0j3m7d4nmF07o/x+UE5/i7n0KQQVkpyaCWp
         gdQ46uI0uM/autLVAoQmGb3m51noz/4T7cjpeYV9t8+8F+tMjkFW8A70FHdgUR31OK0N
         7oMmcMfupMuEQ4RzFX5xD8LSW/oXT1TZtjQRsEJxP1NaILpzPb0QgW02W+BhsVhoW4qh
         wxLmQ5bG+9joekW8U/2EofkhuPrnauKGGzIzEJl9qUlDdrKMRMWwOC5jGSq4NBaSm6hm
         XcSFHrExt7aNFjzFjeWnw8lI82gbvc/GajKIGGoPeabmG/hrjNvqvlgWqUlYn3Vb/31l
         /7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713976860; x=1714581660;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GQHM/80L6vhM7cw/Fvp/X5UhuquOsJNM/l9Z3p65l1Q=;
        b=oAL6GYhxNSMsl63tkJMsJMPhvJekLPtAZGsyOx9GbHJw0PClp+GFV3xUdn0onuKuuA
         PxKNIRHjimKWqUspC/qgS4u69ReHDGxjXplRcpEBZWeTUNK6ylBFdOuChQLgR/EX0EN0
         QjsYcoYGZ7y4eRi7Sd0eJXZRWzXzOktfG4Q7QotyhteQjYbLaDsuA30O3oXerwVBFnaJ
         yDlaA2Wp5PLkQ+/0q5qTSIJaxmZOpPBM9SEVkag4wm6FPqOhU/0cDTB6C3I1trgH2GYR
         ixHk6OOniZ7e3j4JEhd9ZWp6UDFgU+p7k/tBsWE6cAl+LUIjFkM5v2CfOvTCa1wypwy8
         vrMQ==
X-Gm-Message-State: AOJu0YwWzN97cHZALjMUd8PyfsPM8AWLzJaYiI/nvPxw+UvjvHZ92tqq
	j8HuSvG2UeDYlkkJj8el/zDLP7QDy0Dg3zkgEUq4/jWzC9mq9PSFqFNe7zJnxpc=
X-Google-Smtp-Source: AGHT+IED3enY4UhsbRAc5kh2lgjqlhQOe9fMgwMbv+d2kIsBSbS8QiKsOjQJTypAd0iTCqTEk1AtbA==
X-Received: by 2002:adf:f792:0:b0:346:4d41:8d51 with SMTP id q18-20020adff792000000b003464d418d51mr2256217wrp.36.1713976859904;
        Wed, 24 Apr 2024 09:40:59 -0700 (PDT)
Received: from apollon.fritz.box (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c384900b0041b0c3879c3sm2344734wmr.26.2024.04.24.09.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 09:40:59 -0700 (PDT)
Message-ID: <5fd325ecb0f2ee6c843b70aa33fb2b7c9ad07554.camel@suse.com>
Subject: Re: [PATCH 1/3] libmultipath: export partmap_in_use and do_deferred
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 24 Apr 2024 18:40:58 +0200
In-Reply-To: <20240423222536.2096486-2-bmarzins@redhat.com>
References: <20240423222536.2096486-1-bmarzins@redhat.com>
	 <20240423222536.2096486-2-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-04-23 at 18:25 -0400, Benjamin Marzinski wrote:
> A future commit will make use of these functions
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =C2=A0libmultipath/devmapper.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 4 +---
> =C2=A0libmultipath/devmapper.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 3 +++
> =C2=A0libmultipath/libmultipath.version | 1 +
> =C2=A03 files changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 4ce7e82f..24d03e83 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -386,8 +386,6 @@ libmp_dm_task_create(int task)
> =C2=A0	return dm_task_create(task);
> =C2=A0}
> =C2=A0
> -#define do_deferred(x) ((x) =3D=3D DEFERRED_REMOVE_ON || (x) =3D=3D
> DEFERRED_REMOVE_IN_PROGRESS)
> -
> =C2=A0static int
> =C2=A0dm_simplecmd (int task, const char *name, int no_flush, int
> need_sync,
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uint16_t udev_flags, int deferred_r=
emove
> __DR_UNUSED__) {
> @@ -1043,7 +1041,7 @@ has_partmap(const char *name
> __attribute__((unused)),
> =C2=A0	return 1;
> =C2=A0}
> =C2=A0
> -static int
> +int
> =C2=A0partmap_in_use(const char *name, void *data)
> =C2=A0{
> =C2=A0	int part_count, *ret_count =3D (int *)data;
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index a7d66604..2987a1b5 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -57,6 +57,9 @@ enum {
> =C2=A0	DM_FLUSH_BUSY,
> =C2=A0};
> =C2=A0
> +#define do_deferred(x) ((x) =3D=3D DEFERRED_REMOVE_ON || (x) =3D=3D
> DEFERRED_REMOVE_IN_PROGRESS)
> +
> +int partmap_in_use(const char *name, void *data);
> =C2=A0int _dm_flush_map (const char *, int, int, int, int);
> =C2=A0int dm_flush_map_nopaths(const char * mapname, int deferred_remove)=
;
> =C2=A0#define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0, 0, 0)
> diff --git a/libmultipath/libmultipath.version
> b/libmultipath/libmultipath.version
> index 724786d5..e070f296 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -141,6 +141,7 @@ global:
> =C2=A0	need_io_err_check;
> =C2=A0	orphan_path;
> =C2=A0	parse_prkey_flags;
> +	partmap_in_use;
> =C2=A0	pathcount;
> =C2=A0	path_discovery;
> =C2=A0	path_get_tpgs;

