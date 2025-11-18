Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B152DA740
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 18:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763489167; cv=none; b=iLoXV3ZiDkQjxrT0ME+eMehCI3PLeeqbkZGzhS+m1cJNb8vBltQkTyI433bd1YUtbFf2n8pO7xcAcbLS5JhfXF5H7oTjNzeD0EfcxVRcywB0quNH4VZYokG/W/hOl0/sT7919OdnMeMhGPMfSeUo3qBcEvYDaU763IGX4lR5Aqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763489167; c=relaxed/simple;
	bh=8N6J17d7H470YIIh6eDqaL2RdiDO8UPb9gKIoUVpvco=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=tmPbovIJR0Xd1nWEVCZDx83o7A48ia0nhbdreafBjTLvfiY4djZu0q4Al6LIveLkFyKCXETGrFxk52fNG17AoE42Fms30q7I0SB0IZ0d+6i3Y+09WJmbuozaEA6WlUetaFZapRxaM0SbIAiXhlfaFRCDKgzY62FUjUSeYTdFwUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WJPuTmcV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WJPuTmcV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763489163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FoDTgmSGf3Eb8A5qG0tKIRWEcokVCtQv154v3oPpskI=;
	b=WJPuTmcVHEz7fjAOZ24pjLW/8vnIHwuclM5IBTiS6FGSQo9kkDbxTPN42JDHsHdifoEOtD
	VlfiO9rMgtLPIcJ1rdLj/6EXdIXbRikw3FxDkk2iC4/1fO35J7rM251AiWhOHU5cykuh+R
	YKm8AxCfZMVpsqYZSHtW6Vcby/fiwmw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-244-mCY_IH3yNaeGGkNIXtnH7A-1; Tue,
 18 Nov 2025 13:06:01 -0500
X-MC-Unique: mCY_IH3yNaeGGkNIXtnH7A-1
X-Mimecast-MFC-AGG-ID: mCY_IH3yNaeGGkNIXtnH7A_1763489160
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2364F19560B4;
	Tue, 18 Nov 2025 18:06:00 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54433180047F;
	Tue, 18 Nov 2025 18:05:57 +0000 (UTC)
Date: Tue, 18 Nov 2025 19:05:52 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: Li Chen <me@linux.beauty>, Linux Device Mapper <dm-devel@lists.linux.dev>, 
    Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
    Zheng Gu <cengku@gmail.com>
Subject: Re: [PATCH v2 0/3] dm-pcache: built-in support and metadata
 hardening
In-Reply-To: <520bf329-8e3b-4b27-9bd5-82092d501174@linux.dev>
Message-ID: <881e9a2a-0a9e-dda4-1b2f-e208d942898a@redhat.com>
References: <20251111121337.1063443-1-me@linux.beauty> <520bf329-8e3b-4b27-9bd5-82092d501174@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-1207307992-1763489159=:1055457"
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-1207307992-1763489159=:1055457
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Thu, 13 Nov 2025, Dongsheng Yang wrote:

> Hi Mikulas,
> 
>     Please consider taking these three patches.
> 
> Thanx
> 
> Dongsheng

OK, thanks. I accepted the patches and I staged them for the kernel 6.18.

Mikulas


> 在 11/11/2025 8:13 PM, Li Chen 写道:
> > From: Li Chen <chenl311@chinatelecom.cn>
> > 
> > This three-patch series tidies dm-pcache’s build glue and tightens the
> > metadata scan.
> > 
> > Patch 1 allow dm-pcache to be linked into vmlinux and avoids clashing with
> > the sunrpc
> > cache_flush() by using obj-$(CONFIG_DM_PCACHE) and renaming the helper
> > across the tree.
> > 
> > Patch 2 drops a redundant recomputation of the metadata slot pointer while
> > walking headers.
> > 
> > Patch 3 Ensure dm-pcache initializes cache_info from a zeroed state so
> > metadata CRC
> > failures can’t leak stale flags into the new-cache path.
> > 
> > Thanks for your review.
> > 
> > Li Chen (3):
> >    dm-pcache: allow built-in build and rename flush helper
> >    dm-pcache: reuse meta_addr in pcache_meta_find_latest
> >    dm-pcache: zero cache_info before default init
> > 
> >   drivers/md/dm-pcache/Makefile          | 2 +-
> >   drivers/md/dm-pcache/cache.c           | 4 ++--
> >   drivers/md/dm-pcache/cache.h           | 2 +-
> >   drivers/md/dm-pcache/cache_req.c       | 6 +++---
> >   drivers/md/dm-pcache/pcache_internal.h | 2 +-
> >   5 files changed, 8 insertions(+), 8 deletions(-)
> > 
> 
---1463811712-1207307992-1763489159=:1055457--

