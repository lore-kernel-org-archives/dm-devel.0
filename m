Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823EB347BD9
	for <dm-devel@lists.linux.dev>; Mon, 13 Jul 2026 02:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910482; cv=none; b=bsQXlLQXhjQlyNiTLWv7OAzBSnxR6tHWX8swpRMZCUDN6+/IOuDiZLK0wwnxHbaw+xrxy7dFot9T+JVQULsipMOZbP+ysvDbD6Ef6rnGOD0X6AD1P2m5CiA4UwZZqP+y/wRN/Hggdn3bU/UMlMjihXToHFQ0/I8/nXJKPfeTdZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910482; c=relaxed/simple;
	bh=2Fgx1jHAi3FtBJ/keCHwrHIb/S6are9wCLWQi94bhrA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kU4KCNByGAmQWsDDBTzcIwANwS7Zz2RwNUs0wIpEWPPuJd/njNQV8rCMc86h9GGPpgFCZ1VstNBQlL/UPI4UFY/BkJXc44rWRwTOb9fyzEZdc9kyHeaJeMex6YCFLfACeVrOhR2m1pSA2hEvMgRhlGUu5J/MTXJK1hdpursP4uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U1f28dS2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U1f28dS2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783910472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Fgx1jHAi3FtBJ/keCHwrHIb/S6are9wCLWQi94bhrA=;
	b=U1f28dS23mWTyWOTpOazE49K4Kw0lZkIjG9+3tkJvCQ21bIAk5RA5rPPFoLWnC4tpsCQ7C
	pGOwGHDtVk3ScAnVIh+jSTBriAy85OFg7xOCFztjSZGJoYdtD6v9ZKU0hxGdLUWpu/bOMb
	nAgnMIttUdLrqV5VvRn24RHAjHW1Alo=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-fFg1TMjPM46nOdekzThLFg-1; Sun, 12 Jul 2026 22:41:07 -0400
X-MC-Unique: fFg1TMjPM46nOdekzThLFg-1
X-Mimecast-MFC-AGG-ID: fFg1TMjPM46nOdekzThLFg_1783910460
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-39c7291b47eso13082181fa.2
        for <dm-devel@lists.linux.dev>; Sun, 12 Jul 2026 19:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783910460; x=1784515260;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Fgx1jHAi3FtBJ/keCHwrHIb/S6are9wCLWQi94bhrA=;
        b=DMUO6JHNCFw/I3Ab+6ewRP3FhwISeeY8kEOeltk0bAdjXHxwahAQFpoqbHg3HdCjcH
         rTIrEEBkhwq8hwt4aGIhnME8dZAka7kUn9Z6ECcGuL5TfvcgS3VrHV99ZjknIrA+6dRJ
         CYlWAWulRwtlbND+8J++H0fpuBTdOhUgV6+Z4lEYFy1+siDgCbNkJQxd8j8ETKpiy1LQ
         iwFgGed4BAdBwtnY6tXsC10wWORqHTLKWp+CgJfMWOoyL6yOto4VJ5RcZV8lWGzk/7Ru
         jx6lBacCtB7+7TgX8tRPMGETI5UDUtzNFVBfBbLjNGjqyCkIhRvg5soW/Jpl7neAqKKf
         Byzw==
X-Forwarded-Encrypted: i=1; AHgh+RrOFjXdvuZuOaqiKujPu/0PxFR8fXxyHEBE8aCIVzYNO1CfiAxhGGvySpaf+jnlHZcdbtziTMaPLg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwuE3yybxSSe8Br2ZtQFfMNKOegYIrOJafymNQU37uDpRy+Hs5t
	Z3AfnM2Pzh5OwlHCVLqRvFptkSUwzbrtu37/yRx1ivtNvgpaji5tQ4prBt2p8ZLHdOd/CjKiVV0
	Q3/GARM0cXwfaBOIIrO4Muc+m5GWZWsqcRUXQOdmqQ31xJh/BQNaq1hpYLzFCVAkg9f2VBTDVcL
	hTnNHaeZuPpYbB7BYq0cpAJnnMI4bFRU8dKw==
X-Gm-Gg: AfdE7cnFBNrQleqkke4n/5L74KgLe7WXwIYe5z+Y7A+4PbnT5Bi4EknMYAy/4SK1Z+H
	LEltwU+zWKQG3ZfNDXnmHS/wfd3asCA0xSr5b/AvbXp+7d/4aFcaeL68Oenmu1NIa5CQaPJ/bzg
	m0W6SVVuYTgNrBaT2y24SCtQLgbcDihrLFqL56YMOTaYZnEGHTBsJG3+TtVsSjjQEs5I0I
X-Received: by 2002:a2e:a994:0:b0:39c:650c:454e with SMTP id 38308e7fff4ca-39caa80368dmr14624331fa.13.1783910460072;
        Sun, 12 Jul 2026 19:41:00 -0700 (PDT)
X-Received: by 2002:a2e:a994:0:b0:39c:650c:454e with SMTP id
 38308e7fff4ca-39caa80368dmr14624231fa.13.1783910459659; Sun, 12 Jul 2026
 19:40:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260711100526.835027-1-zhanggenjian@126.com>
In-Reply-To: <20260711100526.835027-1-zhanggenjian@126.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Mon, 13 Jul 2026 10:40:48 +0800
X-Gm-Features: AUfX_myKQscoRgzy7I2Vob2d7KwV0Fds51HFiX8Pq6SaoDbD2MktDL4s-wqHRJs
Message-ID: <CALjSBEtD00yuLaBJXtJjFG7L0nCLRaGDUVGoN7VZ4wkVRD0CDQ@mail.gmail.com>
Subject: Re: [PATCH] dm thin metadata: fix superblock refcount leak on
 snapshot shadow failure
To: Genjian <zhanggenjian@126.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	bmarzins@redhat.com, ejt@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Genjian Zhang <zhanggenjian@kylinos.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Mp2ddUh41RRQXS-P0PabVlXiQ8DWuVljxkrvkbwnApI_1783910460
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 11, 2026 at 6:16=E2=80=AFPM Genjian <zhanggenjian@126.com> wrot=
e:
>
> From: Genjian Zhang <zhanggenjian@kylinos.cn>
>
> __reserve_metadata_snap() increments THIN_SUPERBLOCK_LOCATION in the
> metadata space map before shadowing it. When dm_tm_shadow_block()
> fails, a reference is leaked in the metadata space map.
>
> Fix by adding the missing dm_sm_dec_block().
>
> Fixes: cc8394d86f04 ("dm thin: provide userspace access to pool metadata"=
)
> Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
> ---

The fix looks reasonable as a best-effort cleanup for the immediate
refcount leak.

