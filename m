Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A57158867
	for <dm-devel@lists.linux.dev>; Wed, 24 Apr 2024 16:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713976841; cv=none; b=WVKajRYk1SrVpJjXeSpW0SP3R8g0xrT8Xzuvyx0VOCYgg8fsI15MwGiZGD56xX7VEld3UQk5YX0mYkJaQlB9Ka96ReKP96ot5vnIJQIk7nw9YqI9J6rVo9LxhIs1ktlIwZg+tbFZnt650RnELxHLl7nMcwF4PSnbtxfFqpP1mjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713976841; c=relaxed/simple;
	bh=7qHrrrDcz/224MjfT7zSQObEFhqmmcPfuQtXNb4QaYA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bmNiTybjeYtPs5psKkxgOXSFB32wP2KW4pi+z2FDWZZmNyMDMKiWbmWBOx4jPWqDpoToMn2/0nt5oGRn9jJk1c0+BAFplCbYZcj2UmDpU+VWJ8l/tLqFb+hka3JRnv/xk/gqsC5qUI9VV9UjMCT6PrFUwKb5tF0Bo8bus5sFFDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EqWI0P0z; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EqWI0P0z"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-34a3e0b31e6so5223255f8f.1
        for <dm-devel@lists.linux.dev>; Wed, 24 Apr 2024 09:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713976838; x=1714581638; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u8Y/0FMQhy0eDKXLDXgelOhaHr5sQTtAxo9xeXcf8L0=;
        b=EqWI0P0zUdZda2Ohjhi1XPSkxGLeS9DTOAxXzzVFFqlyNyum4M1L3an8zCCkAhx+y2
         oan8HOL253alO9U1rFGa/b893OVxk0oNVmNLRGbGPFfms6Tao640uhb/KUQyv+wbInU9
         VcW9NbqiPSSC0Pod2xH58ArvmQhDizaNtT6Wa4M8IVV4J0nDBuZc724eLi1A9K0wQTnn
         wo7eO1prwtnjge9XEmrve5XpF6tL31R3Ljlg1Lk/RTbtrmfS2NMuvCBKOLPODdaAOPT5
         ECK3LEbMDgOyxm9+SAx/vFDC792arrhxiCJxtnVLHhZCv6BwTYrqKHXMpBx320Akewdm
         QjYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713976838; x=1714581638;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u8Y/0FMQhy0eDKXLDXgelOhaHr5sQTtAxo9xeXcf8L0=;
        b=RwP6lS8dLORkPDJyw0MBPH6mzjj9FinGIKWZd6EdABAZ94Rm0TW95S2ftukWg8c1Xg
         WgRIXDJgKVqO57w8RAVhueJTvxMXdnMNZ1Wdpdl8AjQIk+D3qjUrQbjqDGR6k5vweGjF
         hztuQQL0IG4pCGGswzvsSDE47TGuYEshX7zGumNr0QM2qF0vD9Q/60wITeMN/CQO4twe
         fvT2joQGNspJmpV6jJK7CF4YObbgMpHyqMPqsp/bzhsyajhww+kHKCHf/mBDgu3x5Hdq
         vKHpmSqaHXGzr66hIRLdWlZmuOINKhPTNXYCyGaGAdFtp/y42k2W4vLOtHnplYvQEKLR
         SgvA==
X-Gm-Message-State: AOJu0Yxnj3pDFnqRT5UFCguOgHf6y5+qmq4wQ91KPF3c8O+mFc4HfVmA
	oVBTX82HVv4rTV43gOqVAB8QOQBpQEB1ZLO8O6ZVLMpfg3+9Lx4+H8ykTw73ihk=
X-Google-Smtp-Source: AGHT+IEzJyaNb/Y3WEkCSextTcxOg47aPn9WCuIPxE+KLpOH9WqkiooDTy0V/QDlgeHzw29oS0QHog==
X-Received: by 2002:a5d:6dc7:0:b0:34a:5663:40e with SMTP id d7-20020a5d6dc7000000b0034a5663040emr2561211wrz.9.1713976837913;
        Wed, 24 Apr 2024 09:40:37 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with ESMTPSA id f3-20020adfe903000000b003445bb2362esm17482000wrm.65.2024.04.24.09.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 09:40:37 -0700 (PDT)
Message-ID: <00855491fbf55a026919fad059218bcab7ffd14d.camel@suse.com>
Subject: Re: [PATCH 3/3] libmultipath: simplify dm_flush_map_nopaths
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 24 Apr 2024 18:40:36 +0200
In-Reply-To: <20240423222536.2096486-4-bmarzins@redhat.com>
References: <20240423222536.2096486-1-bmarzins@redhat.com>
	 <20240423222536.2096486-4-bmarzins@redhat.com>
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
> Now that flush_map_nopaths(), its only caller, needs to deal with
> whether or not a remove is deferred, dm_flush_map_nopaths()
> doesn't need to worry if LIBDM_API_DEFERRED is defined. It can just
> trust that the caller took care of making sure deferred_remove is
> correct.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/devmapper.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 19 -------------------
> =C2=A0libmultipath/devmapper.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 3 ++-
> =C2=A0libmultipath/libmultipath.version |=C2=A0 3 +--
> =C2=A03 files changed, 3 insertions(+), 22 deletions(-)
>=20
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 24d03e83..dc8c4d17 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -1140,25 +1140,6 @@ int _dm_flush_map (const char * mapname, int
> need_sync, int deferred_remove,
> =C2=A0	return DM_FLUSH_FAIL;
> =C2=A0}
> =C2=A0
> -#ifdef LIBDM_API_DEFERRED
> -
> -int
> -dm_flush_map_nopaths(const char * mapname, int deferred_remove)
> -{
> -	return _dm_flush_map(mapname, 1, deferred_remove, 0, 0);
> -}
> -
> -#else
> -
> -int
> -dm_flush_map_nopaths(const char * mapname,
> -		=C2=A0=C2=A0=C2=A0=C2=A0 int deferred_remove __attribute__((unused)))
> -{
> -	return _dm_flush_map(mapname, 1, 0, 0, 0);
> -}
> -
> -#endif
> -
> =C2=A0int dm_flush_maps (int retries)
> =C2=A0{
> =C2=A0	int r =3D DM_FLUSH_FAIL;
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index 2987a1b5..8599ee98 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -61,7 +61,8 @@ enum {
> =C2=A0
> =C2=A0int partmap_in_use(const char *name, void *data);
> =C2=A0int _dm_flush_map (const char *, int, int, int, int);
> -int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
> +#define dm_flush_map_nopaths(mapname, deferred) \
> +	_dm_flush_map(mapname, 1, deferred, 0, 0)

Perhaps we can do away with dm_flush_map_nopaths entirely.


> =C2=A0#define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0, 0, 0)
> =C2=A0#define dm_flush_map_nosync(mapname) _dm_flush_map(mapname, 0, 0, 0=
,
> 0)
> =C2=A0#define dm_suspend_and_flush_map(mapname, retries) \
> diff --git a/libmultipath/libmultipath.version
> b/libmultipath/libmultipath.version
> index e070f296..806676bf 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
> =C2=A0	put_multipath_config;
> =C2=A0};
> =C2=A0
> -LIBMULTIPATH_23.0.0 {
> +LIBMULTIPATH_24.0.0 {
> =C2=A0global:
> =C2=A0	/* symbols referenced by multipath and multipathd */
> =C2=A0	add_foreign;
> @@ -74,7 +74,6 @@ global:
> =C2=A0	dm_enablegroup;
> =C2=A0	dm_fail_path;
> =C2=A0	_dm_flush_map;
> -	dm_flush_map_nopaths;
> =C2=A0	dm_flush_maps;
> =C2=A0	dm_geteventnr;
> =C2=A0	dm_get_info;

