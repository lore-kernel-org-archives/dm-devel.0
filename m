Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C894226E718
	for <dm-devel@lists.linux.dev>; Mon,  8 Dec 2025 14:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765205720; cv=none; b=pG1i2d3Obbye21qduIOu3VbtS7GY0Erus/zFVaRkUb/CgzMoFSYmzw55kv+PRLAF3s5PllQvs5VQd7yd4N0VHvmnQzsPU5H+4SxHma/G/C/4kbcl5Ozdozb12jFQtLJuszdtvTybu+saHunih9nErTLnmyOSHN/PA7KbHKsEfcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765205720; c=relaxed/simple;
	bh=Lby3N/LvNXg/lPxPewsGC0B1REkfd04hD1IgyMLVXPI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bWPhodzrsKzve/0VKn/HjgNpHl/K4IHCe1cmkLdWmyRiBCLxMyX+0iSRV/yBDFo7Sk0nlKG8cWAAG9g97wZQ1aNv5grLq5cExnXyIPLEsqdTwidBMzU/yOnWB00DvzKONgz3xPF+Qk+KskChXnQXs/tRvdEljqmAxnlVa5848BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bLVUMZbY; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bLVUMZbY"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4775ae77516so54541505e9.1
        for <dm-devel@lists.linux.dev>; Mon, 08 Dec 2025 06:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765205717; x=1765810517; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EqLKuCGQ9azwOpP/+H90efkRJ5CKbKNQFgiysqtJSKE=;
        b=bLVUMZbYQaJBW81i7Vr7kaL5ResMrDCH12cPqRFA0YppsEL9rtNSyKeSqV8K0Q07ZD
         afqpchJkBKCju4zW1jZ/ZpfNpvodJCXqAGUO/DHouNh096m+PryVbkACqVS7a7jTIg11
         XRgMAlJVKsdIOXcQBaba0o8SQu5nIY+CVY7WzpLxOOF3mWQhXLYEUoQjbtz1EtGrjIje
         i0pn3zmLvp/6MytfzIxNBsHNlhRTDu3U+4hfbTjb6XJaf6kopozAAlqTtQXd58E1ghUb
         ZjkjT2HT+11iyDtZjVM04HU0q+DBzBOe7x8RhY2C6LUmVEVeFenhG0Vas7K1igBKUEri
         AhSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765205717; x=1765810517;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EqLKuCGQ9azwOpP/+H90efkRJ5CKbKNQFgiysqtJSKE=;
        b=ttsXV/YPgfypUNNAECfbBw6xaXgWdSPJ4KanvP7v6m26n+5u63XFpAFiQ1h106dQrW
         /dHYna1DQjKcU8VPU5MymMHbeCnSPRKAH3WDkqa8y2nBPGsToFFBk5M0qNXwIB+2KNsM
         7twD63hSm9odnWLmZ7CUiHeSyJ5vtIk75KjV58Ch+jfLgCjee7/nugTFhRe/IamQXBib
         4LXucJT+EBq4ijxxBXDeXU6K+FWt0kwtYMMI0EkIIR/2yu7Iw4CUddfuDNORDKHUhcna
         xXII3fH3tnX/iibj5YjAQ69yIwvtREFLDFURTktsebEZr2yf0gUI52eZjr720XTzxbmv
         fjKA==
X-Gm-Message-State: AOJu0YyCx97s3vH5eilugvyR60BoLYzDVuCYge2QFtytpAyj1VjgEi4w
	wwd4rAkG1pXySUQjcjjLRoOYnY8ea5dG5b5vrLgzstiBv04rtSVTMaY4sIhiGY5pBYf1didchf6
	yy7f7
X-Gm-Gg: ASbGnctLDz1jyid7IItLPIVTxw/z2tOpam4IiygL20dayiDM84mFigoLmXETL4T3CQg
	PgxQysffyAV9MkL/ddDJXhQdWnBZ1XtJi44WPmzFtFG2rGqRVcCVuL6aBK+DL/7BBI3kmC7wizZ
	BPayqQytesI3D8zWpj6z5eHsphfrF3wkWGwEZcsSrfeJkXjQKMXi53J8wpuLoLpIeK044KvVLmQ
	ybzPKCbA863RsOshgi9bopuQ50Uc8drKimQ+zbwhiaMh1VFYNzKJUNyTXEhmt4qeBS1qyNxaFNl
	fp7gz+zV3YBFZbPvVxrx8MCKr34us+eoD1YsTTO+nrKXBdv1rN9Q02TTX8Q+80j5gfb5Wd60vaZ
	zejUVHbcue+ICgxqpMLzGqDQ7ZZ3KtqKqA4cOEVX76Mn7hR9ZGhtKO7S8K4yBOMIJ/Cd+LZJK/7
	bQJUJHr8hTHotJyMjv1qLkqsdBZ0nGOXMHKUs3rAaUKWYI4XhX/nGuFle6uq5mlb4twHQLpvnxF
	vnbnMHfb70QtYbXZ0Xnlm/MH9CsS9Fqn+Xp7hDPlfYBdB8+RmvNl1rSgw==
X-Google-Smtp-Source: AGHT+IFh/v4+RwcZBefd3ouCJsO7CkZGBhEcBnLhf8EN4K0+fAsUyCuoZySoCYo8GBiiYwsyhPB6CQ==
X-Received: by 2002:a05:600c:8b65:b0:477:af07:dd21 with SMTP id 5b1f17b1804b1-47939e38315mr89069225e9.25.1765205717054;
        Mon, 08 Dec 2025 06:55:17 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479310a6db3sm261171205e9.1.2025.12.08.06.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 06:55:16 -0800 (PST)
Message-ID: <b081fd2ef6176f0e1d9c34bcd1d2e0ebf237946e.camel@suse.com>
Subject: Re: [PATCH 4/4] libmpathpersist: fix code for skipping multipathd
 path registration
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 08 Dec 2025 15:55:16 +0100
In-Reply-To: <20251202030213.1432964-5-bmarzins@redhat.com>
References: <20251202030213.1432964-1-bmarzins@redhat.com>
	 <20251202030213.1432964-5-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-12-01 at 22:02 -0500, Benjamin Marzinski wrote:
> When libmpathpersist notifies multipathd that a key has been
> registered,
> cli_setprstatus() calls pr_register_active_paths() with a flag to let
> it
> know that the paths are likely already registered, and it can skip
> re-registering them, as long as the number of active paths matches
> the
> number of registered keys. This shortcut can fail, causing multipathd
> to
> not register needed paths, if either a path becomes usable and
> another
> becomes unusable while libmpathpersist is running or if there already
> were registered keys for I_T Nexus's that don't correspond to path
> devices.
>=20
> To make this shortcut work in cases like that, this commit adds a new
> multipathd command "setprstatus map <map> pathlist <pathlist>", where
> <pathlist> is a quoted, comma separated list of scsi path devices.
> libmpathpersist will send out the list of paths it registered the key
> on. pr_register_active_paths() will skip calling
> mpath_pr_event_handle()
> for paths on that list.
>=20
> In order to deal with the possiblity of a preempt occuring while
> libmpathpersist was running, the code still needs to check that it
> has
> the expected number of keys.
>=20
> Fixes: f7d6cd17 ("multipathd: Fix race while registering PR key")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmpathpersist/mpath_persist_int.c |=C2=A0 6 +--
> =C2=A0libmpathpersist/mpath_updatepr.c=C2=A0=C2=A0=C2=A0 | 48 +++++++++++=
++++++------
> =C2=A0libmpathpersist/mpathpr.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +-
> =C2=A0multipathd/callbacks.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0multipathd/cli.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0multipathd/cli.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +
> =C2=A0multipathd/cli_handlers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 39 ++++++++++++++++--
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 61 +++++++++=
++++++++++--------
> --
> =C2=A0multipathd/main.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 +-
> =C2=A0multipathd/multipathd.8.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0 6 +++
> =C2=A010 files changed, 132 insertions(+), 39 deletions(-)
>=20
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index a7650639..2cd5c952 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -630,28 +630,49 @@ flush_map_nopaths(struct multipath *mpp, struct
> vectors *vecs) {
> =C2=A0	return true;
> =C2=A0}
> =C2=A0
> -void pr_register_active_paths(struct multipath *mpp, bool
> check_nr_active)
> +/*
> + * If reg_paths in non-NULL, it is a vector of paths that
> libmpathpersist
> + * registered. If the number of registered keys is smaller than the
> number
> + * of registered paths, then likely a preempt that occurred while
> + * libmpathpersist was registering the key. As long as there are
> still some
> + * registered keys, treat the preempt as happening first, and make
> sure to
> + * register keys on all the paths. If the number of registered keys
> is at
> + * least as large as the number of registered paths, then no preempt
> happened,
> + * and multipathd does not need to re-register the paths that
> libmpathpersist
> + * handled
> + */
> +void pr_register_active_paths(struct multipath *mpp,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct vector_s *reg_paths)
> =C2=A0{
> -	unsigned int i, j, nr_keys =3D 0;
> -	unsigned int nr_active =3D 0;
> +	unsigned int i, j, k, nr_keys =3D 0;
> +	unsigned int wanted_nr =3D VECTOR_SIZE(reg_paths);
> =C2=A0	struct path *pp;
> =C2=A0	struct pathgroup *pgp;
> -
> -	if (check_nr_active) {
> -		nr_active =3D count_active_paths(mpp);
> -		if (!nr_active)
> -			return;
> -	}
> +	char *pathname;
> =C2=A0
> =C2=A0	vector_foreach_slot (mpp->pg, pgp, i) {
> =C2=A0		vector_foreach_slot (pgp->paths, pp, j) {
> =C2=A0			if (mpp->prflag =3D=3D PR_UNSET)
> =C2=A0				return;
> -			if (pp->state =3D=3D PATH_UP || pp->state =3D=3D
> PATH_GHOST) {
> -				nr_keys =3D mpath_pr_event_handle(pp,
> nr_keys, nr_active);
> -				if (check_nr_active && nr_keys =3D=3D
> nr_active)
> -					return;
> +			if (pp->state !=3D PATH_UP && pp->state !=3D
> PATH_GHOST)
> +				continue;
> +			if (wanted_nr && nr_keys) {
> +				vector_foreach_slot(reg_paths,
> pathname, k) {
> +					if (strcmp(pp->dev,
> pathname) =3D=3D 0 ||
> +					=C2=A0=C2=A0=C2=A0 strcmp(pp->dev_t,
> pathname) =3D=3D 0) {
> +						goto skip;
> +					}
> +				}
> +			}
> +			nr_keys =3D mpath_pr_event_handle(pp, nr_keys,
> wanted_nr);
> +			if (nr_keys && nr_keys < wanted_nr) {
> +				/*
> +				 * Incorrect number of registered
> keys. Need
> +				 * to register all devices
> +				 */
> +				wanted_nr =3D 0;
> =C2=A0			}
> +skip:

This fails on Debian Sid with this error messsage:

main.c:677:3: error: label at end of compound statement is a C23
extension [-Werror,-Wc23-extensions]
  677 |                 }
      |           =20


[1] https://github.com/openSUSE/multipath-tools/actions/runs/20031717354/jo=
b/57442300023

Martin

