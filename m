Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117222080C0
	for <dm-devel@lists.linux.dev>; Sat,  1 Nov 2025 13:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762002668; cv=pass; b=Yx1L7GCXjTJYLVsMXYXpD1mLHL3EYXWrd+Lzo/StZ0BG1XNY8G8O0mggvjnaeN0r/FS39ccHuSBv2ePO7pEP+2U9cF2rKL/48fl8PKNs4gBKJB3a/cN5LxXnFIeZnrp3gCDA57B9ioh48+vo8t+4gyH3fO2tiFupSRRy9wb8zsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762002668; c=relaxed/simple;
	bh=0taRMor14N8gkPrOTnbjnXxGx8ZXOvRA4oL3AHJE1RQ=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=hFaaTxcUGlRBLL/fz0T/uwILDxwFh4QvT+oQqed5Rknvn8SRabJ+sl2FkXy/zt7jbsfnBr8qIGeueffzdmPksXYG3zsffY5bA5Iri8oCcZFOIipuGdO6UCYN4cPwUq8lfdzxS4NLvNcTDag014//L4XRkiNXavdgCp3epKgep5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=b5rnxHrU; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="b5rnxHrU"
ARC-Seal: i=1; a=rsa-sha256; t=1762002662; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=UtHNSr1Fg9s8aac54dFgJC6UkSJZtVFgoo3lZMzdUSp6ELAnaa7/OzSEBHidOfh/ZGXDr/pt6rZr/Yv2tbKlRjynCe3ZU8+jUc6831g4q7ivuLIE24XfpNgh76eFXTxMHxmqc+PmE/Qia8PRehlv49scO7uVCXnJVweTJ5O3nIo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1762002662; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=FQkuvTbMrWNB614TnSFI9TReTgW3UOssKpYpKVzLOk0=; 
	b=j8d16OD1g74dhDpxpcqu80wYkIdGNTd9mQVFG0WermIyjtFbcOkyWSnxhJNT25KfEDaWSpG2AfHntkjfVMUlLuJtqkaDHuQDJEbyfKLQXjaj3RKS31MN08jE7Dffo7HXjmfxYMBC3TJ9mPwRuZop2LIRGvtBrqnxuO/bEuqR+ZQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1762002662;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=FQkuvTbMrWNB614TnSFI9TReTgW3UOssKpYpKVzLOk0=;
	b=b5rnxHrUVfk6jEq6hzevc/mm/DZmNpA+2Q3c8mIPOZXVvTd2Hq6ZX37dz9r1BhLB
	yA1V/MfmCKWwgmHVLHgbJ92njIe9PxhcRewQ6k2ADhTbOTymz8li2qvuWjrAeAAINfe
	maEKA7tp25GCn/rmfuAb/7Y1gnaGcA1otFBkAAt8=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1762002659821563.1430926747331; Sat, 1 Nov 2025 06:10:59 -0700 (PDT)
Date: Sat, 01 Nov 2025 21:10:59 +0800
From: Li Chen <me@linux.beauty>
To: "Zheng Gu" <cengku@gmail.com>
Cc: "dm-devel" <dm-devel@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"Dongsheng Yang" <dongsheng.yang@linux.dev>
Message-ID: <19a3f8ae9db.8a18892d3330798.1127794710232272337@linux.beauty>
In-Reply-To: <CADSj-VoQerDc2UUfBOknRMGetSddMEqRKaC3VDniD+xCq0pH1g@mail.gmail.com>
References: <20251030123323.967081-1-me@linux.beauty> <20251030123323.967081-4-me@linux.beauty> <CADSj-VoQerDc2UUfBOknRMGetSddMEqRKaC3VDniD+xCq0pH1g@mail.gmail.com>
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

Hi Zheng,

 ---- On Fri, 31 Oct 2025 10:01:23 +0800  Zheng Gu <cengku@gmail.com> wrote=
 ---=20
 >> On Thu, Oct 30, 2025 at 8:36=E2=80=AFPM Li Chen <me@linux.beauty> wrote=
:From: Li Chen <chenl311@chinatelecom.cn>
 >>=20
 >> Before this change pcache_meta_find_latest() was copying each
 >> slot directly into meta_ret while scanning. If no valid slot
 >> was found and the function returned NULL, meta_ret still held
 >> whatever was last copied (possibly CRC-bad). Later users
 >> (e.g. cache_segs_init) could mistakenly trust that data.
 >=20
 > This functions is * __must_check*, users must check the return value fir=
st before touching the meta_ret, so it should not be a problem here.

Right now, the callers only check the return value with IS_ERR(). If the
function returns NULL instead of an error pointer, a caller like
cache_info_init() will assume that no valid cache_info was found because al=
l cache_info are
corrupted. Instead, it will try to init a new one, and then return 0 (succe=
ss),=20
https://github.com/torvalds/linux/blob/master/drivers/md/dm-pcache/cache.c#=
L61

Later, cache_tail_init() will access cache->cache_info.flags. But in this
path all cache_info may have already been corrupted, and the CRCs are misma=
tched
(https://github.com/torvalds/linux/blob/ba36dd5ee6fd4643ebbf6ee6eefcecf0b07=
e35c7/drivers/md/dm-pcache/pcache_internal.h#L97),
so flags may contain garbage.

This commit fixes this issue by allocating a temp buffer with kvmalloc, so =
meta_ret would never
contain corrupted values.

Regards,

Li=E2=80=8B

