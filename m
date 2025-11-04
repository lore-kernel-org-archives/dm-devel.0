Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C831F32721C
	for <dm-devel@lists.linux.dev>; Tue,  4 Nov 2025 13:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762263388; cv=pass; b=G838q7WDTtoJWo7VS4GNbsyl9G2ehA9i2w3O06o3whfU/4zMZC3crUx5OkgjXoz91i07lW2vy4kX99ohKKrD/gieZo3XLsrx7GKxdKKuP0dPDYDSbJR4Ob4ZFEBfW76JbJvrpgn1HmrtfSCli6oJE2l5FN46mNWEz6ANH9BKSks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762263388; c=relaxed/simple;
	bh=r2kxH4Kz6dmxS7UAfEytjjsJeQuTpTHU5jybPvjiky8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=XJOSjk7K1hBY7seXCTHTXJ+QP/bWnIjKecY956/iRiy6ljPGnKylzCJqxF6AlbfbBH3VzS8mj/eddLTyWIu2A9jEfOfaJorRe2E0dBE7gzdQk2Smxp0YR4EUBrhUpHtxD/ZGkI/HlZGwrdgaDtotk7TWsDR4znKLgFqIZAeZcy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=mJ+VPzkx; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="mJ+VPzkx"
ARC-Seal: i=1; a=rsa-sha256; t=1762263385; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=DFOS+zxjysklQpOlZ/3gsnGHoNyJ50V1piJPCW8kfpQJouJyyUJj4TcVdDtRyGUvsIiLqPGd898JJ33zD4ce47gTKYzLG3atJipehDNg8MltEdmcOhtk5646h3IuKTYjBnaHAYgqIuQ9+Aea0KOJrRNPYTPCDdbI4ukBgjEZgcQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1762263385; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=blMwid/Lzaho1H5pb4L3Gd92k87COVPgHPmJ/Ygi1BI=; 
	b=Dt72kfNTdbI2s9V+sr0miV7bozrW0e9+JNPv+0qk9PqQtX6gznvDbg9EALUjhZ4iaiMdus3tAZGi6Jrt3IFvNQe4gC8UAj4Qz+Mgmr+GowkkbdP7VFiPnlOUdD5NQ76Bw2OmeqT1rr1ynd+4/18wZUfv2lBM2mNMyuFlWMuoVqk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1762263385;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=blMwid/Lzaho1H5pb4L3Gd92k87COVPgHPmJ/Ygi1BI=;
	b=mJ+VPzkxiNx3PEAGb06sNxW8j6N3iWyjcUrY/xmb+BgcvkUAttdenaipYKqm3F7k
	LQ+n5OhmgkD04l4bnBcqZPTwJNlcq9r9B4lPMzMRCtDCswPe36gGHFrZBQE4gT3a/J+
	VmtH4EWknM0mW0Dt9HHt4Q1nUyuJtyUNLYD+Bnas=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1762263383281300.99148794261987; Tue, 4 Nov 2025 05:36:23 -0800 (PST)
Date: Tue, 04 Nov 2025 21:36:23 +0800
From: Li Chen <me@linux.beauty>
To: "Dongsheng Yang" <dongsheng.yang@linux.dev>
Cc: "Zheng Gu" <cengku@gmail.com>, "dm-devel" <dm-devel@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19a4f153cdf.4d1effd9893048.2344913209212358613@linux.beauty>
In-Reply-To: <1248c78a-c471-496b-b7ac-892ac7335a08@linux.dev>
References: <20251030123323.967081-1-me@linux.beauty>
 <20251030123323.967081-4-me@linux.beauty>
 <CADSj-VoQerDc2UUfBOknRMGetSddMEqRKaC3VDniD+xCq0pH1g@mail.gmail.com>
 <19a3f8ae9db.8a18892d3330798.1127794710232272337@linux.beauty> <1248c78a-c471-496b-b7ac-892ac7335a08@linux.dev>
Subject: Re: [PATCH 3/3] dm-pcache: avoid leaking invalid metadata in
 pcache_meta_find_latest()
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Dongsheng,


 ---- On Tue, 04 Nov 2025 14:46:33 +0800  Dongsheng Yang <dongsheng.yang@li=
nux.dev> wrote ---=20
 >=20
 > =E5=9C=A8 11/1/2025 9:10 PM, Li Chen =E5=86=99=E9=81=93:
 > > Hi Zheng,
 > >
 > >   ---- On Fri, 31 Oct 2025 10:01:23 +0800  Zheng Gu <cengku@gmail.com>=
 wrote ---
 > >   >> On Thu, Oct 30, 2025 at 8:36=E2=80=AFPM Li Chen <me@linux.beauty>=
 wrote:From: Li Chen <chenl311@chinatelecom.cn>
 > >   >>
 > >   >> Before this change pcache_meta_find_latest() was copying each
 > >   >> slot directly into meta_ret while scanning. If no valid slot
 > >   >> was found and the function returned NULL, meta_ret still held
 > >   >> whatever was last copied (possibly CRC-bad). Later users
 > >   >> (e.g. cache_segs_init) could mistakenly trust that data.
 > >   >
 > >   > This functions is * __must_check*, users must check the return val=
ue first before touching the meta_ret, so it should not be a problem here.
 > >
 > > Right now, the callers only check the return value with IS_ERR(). If t=
he
 > > function returns NULL instead of an error pointer, a caller like
 > > cache_info_init() will assume that no valid cache_info was found becau=
se all cache_info are
 > > corrupted. Instead, it will try to init a new one, and then return 0 (=
success),
 > > https://github.com/torvalds/linux/blob/master/drivers/md/dm-pcache/cac=
he.c#L61
 > >
 > > Later, cache_tail_init() will access cache->cache_info.flags. But in t=
his
 > > path all cache_info may have already been corrupted, and the CRCs are =
mismatched
 > > (https://github.com/torvalds/linux/blob/ba36dd5ee6fd4643ebbf6ee6eefcec=
f0b07e35c7/drivers/md/dm-pcache/pcache_internal.h#L97),
 > > so flags may contain garbage.
 > >
 > > This commit fixes this issue by allocating a temp buffer with kvmalloc=
, so meta_ret would never
 > > contain corrupted values.
 >=20
 > Hi
 >=20
 >      Thanx for your fix. So the better change should be reseting=20
 > cache_info in cache_info_init_default() firstly by memset() with 0.
 >=20
 > Allocating a temp buffer in pcache_meta_find_latest() is really not a=20
 > good idea.

I considered using memset before sending the patch, but a temporary buffer =
seems more elegant.=20
Since the variable is relatively large, I avoided stack allocation. If you =
prefer memset, should it be implemented=20
within pcache_meta_find_latest or all its callers?

Regards,

Li=E2=80=8B

