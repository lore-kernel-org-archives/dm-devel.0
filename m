Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C442C95
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 15:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725463871; cv=none; b=TioMVHm1TFJrZsQ7DUFaEudSrll94uNaRsQ8ykQQwj/i1W7vL7P1nQXq5LnM0Yk3qVGiInlZ2rXwfYbju967ypHe7J+mk6KRRdPGFNaK/HJd7Ynh010g3krbriQ43yOWSy5lZmiQm9hwbj0TtKhzfLQzMJD98TtYF1fWMG3z0gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725463871; c=relaxed/simple;
	bh=phEWQLVZXxJXgr1LSEqbPFZy5+fXqV2ACzE3FjGYnlI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Skwkb+QkALKWtgovigJivonoK5XCbmzLrqYkwgPUOvjpY3gF+sQ+nlaXzLNDTOnn41TV0MUR5MghbO+mqXrexbGVZ/tqRVgRpiWf/ZupWHs0IuyboPClWlloWCsmfwnG2vBRVd9vzf+iIWI2ZLlkGis8yapbjgivGeow/CnMnB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=K02Cux79; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="K02Cux79"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a8696e9bd24so802695766b.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 08:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725463867; x=1726068667; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rdF+ugXR8nzLCHE5MwSjZaHbUhSVDm8o0aDNbweJnqs=;
        b=K02Cux79WW9ZJMTfAxMF4L3SsfqtKpn5tlnQddyg+hqRJMitdnu92FovwzS44ccMTt
         uylfJbjcNMRK9ZyTzH8km7M4ztIKwAkgIor489+XKk9lIgBooYS5bIyllVkpQYwvKZfp
         mNdzbQmULgGhde71TAPCtngwRcOZ98vUW2a/ZcgeomCHNfRXsawRMO4fp5vclfi1Li3V
         IgwcPhKpZeWUXsxkGsAfHw4YJr+ylfCI4kpQPSH/RjbtldSDL7iKwlnfrzdM0KeKomTW
         oCbd01h8YvR6Ji5YvtriE+6lhpDGUS45LP+Xy+FeEJsBRoaJw25O0riHb9wj73as4bBM
         5woQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725463867; x=1726068667;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rdF+ugXR8nzLCHE5MwSjZaHbUhSVDm8o0aDNbweJnqs=;
        b=YurrI9x9oxsWa2qBvYmgGL6Wiw1/1X5rqoDlgU+78Q5s4kD16vIYwzPYfe4FkB4Yg5
         fnlKjpEmTp85p1WNQY37HGtBiFVTR8EDtzTNWUEjEzdGMMGqg1NrsnhmtAksrqpaSCrB
         yHLr+FT31OOVCoTKXsp+xYa2sYJ9HAhoN5FmkUueLZ5L+PrCwKd+IXIa4sQlhxYj60cV
         1ZBE+Ctq7aJl9gNjbd3v7Hd5M/KWm52dMqgcTQE67YcmadpfISTUBiYiLNyO/w1BgLDi
         O5+byWYP1eOCEKcWsVYdQIybWVUjMjbJalKthtbkt8jaL9Xh73qzz7qgyKSTiwEytktL
         x8yg==
X-Gm-Message-State: AOJu0Yxt83HKmFbkufnnfG9BB53fcdrBZZFjyRLvoz4EqFAjiY8TpFjo
	8HiIvbEiD7X7kCHhTdm5isbT1xb5Fwq4M75jkp6XBIZGE8TN13AQ4UyYKYltHJ8=
X-Google-Smtp-Source: AGHT+IEwmn6HNwUDAobF7Uc4e3jnYiZIVwkuMpPhpQt3Yp+c2cul3x0brJ5hfAZdMg+khNDX490jmA==
X-Received: by 2002:a17:907:3f2a:b0:a86:9c71:ec93 with SMTP id a640c23a62f3a-a897f84d69emr1572008566b.24.1725463866898;
        Wed, 04 Sep 2024 08:31:06 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a623e5701sm5064666b.223.2024.09.04.08.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 08:31:06 -0700 (PDT)
Message-ID: <d6bd0886d6c54e819b97e2a664237f8d7eb6177f.camel@suse.com>
Subject: Re: [PATCH 07/15] libmultipath: change path_offline to
 path_sysfs_state
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 17:31:05 +0200
In-Reply-To: <20240828221757.4060548-8-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-8-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> Instead of pp->offline being a binary value, change it to show the
> actual result of looking at the sysfs state, and rename it to
> pp->sysfs_state. Also change the function name from path_offline() to
> path_sysfs_state(). Adapt the tests for pp->offline. This should not
> change how multipath currently works. pp->sysfs_state will be used in
> future patches.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/discovery.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 65 ++++++++++++++++-------------
> --
> =C2=A0libmultipath/discovery.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0libmultipath/libmultipath.version |=C2=A0 3 +-
> =C2=A0libmultipath/print.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +-
> =C2=A06 files changed, 41 insertions(+), 37 deletions(-)
>=20
> diff --git a/libmultipath/libmultipath.version
> b/libmultipath/libmultipath.version
> index 21d48da6..6439d3a7 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -146,7 +146,7 @@ global:
> =C2=A0	path_discovery;
> =C2=A0	path_get_tpgs;
> =C2=A0	pathinfo;
> -	path_offline;
> +	path_sysfs_state;
> =C2=A0	print_all_paths;
> =C2=A0	print_foreign_topology;
> =C2=A0	print_multipath_topology__;
> @@ -160,6 +160,7 @@ global:
> =C2=A0	remove_wwid;
> =C2=A0	replace_wwids;
> =C2=A0	reset_checker_classes;
> +	start_checker;
> =C2=A0	select_all_tg_pt;
> =C2=A0	select_action;
> =C2=A0	select_find_multipaths_timeout;

Nit: This hunk belongs in 06/15.  Otherwise, LGTM.

