Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6FF3BC69E
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 14:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782310172; cv=none; b=CIEEDyg1Yo82iqvl1nCL49HGO4/ST9Ybq8wF8d8kzkjgB3e0TspU0AtE0iCXx18L4h3oE8aSpNZoNzy7aHeN3+w3DgHiaWPtdBw/ISsB3pzOXwmcnZJ1CmLDO5hG7UbeM3o4qysfcA8174cu+vCJ9KL697jVs6CHtJYAN7GszhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782310172; c=relaxed/simple;
	bh=kG1dwMWFtOgSlccobteQdW1Ywo1wd4rSv2JOi/6xkHw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CSCwevrBRghAaPa4Fi5Wang+XZbKUuS0a84ZQPrkvDPlNYLmgSEJ4JI5LA1UfQZa10f6R+aZYEj8gAyCHe5BSuPnIoCl3E0IK8PPeplydo2sosj3wlXv3GWLbeuk4tmFbQd7ktwkzUHDNPW6lhWUQQYxQgTyxYPvAaHZY50g2a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AOuqGmjz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AOuqGmjz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782310170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=adeBgv4+WoF5/d6WW26NU8U4h0fAlJZdxze8uJxO0Qw=;
	b=AOuqGmjz6P1jNibKfQaBZfEJ1ZZ44Y6ohzLewV9JMwpBuUTXPUfl6CDixKguheSVnHyvgx
	yQfxP5RRuZVAA43VUGyq76J0VlojmnEkJ23a2ZoAGqocRJWQiqiRtWCvT7gbLwC5oQSSUI
	W3FPHfKMUOtFTWJXLoP4bgtUYVEGC5U=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-4B-TTyI2MYOkmI4euVlJJw-1; Wed, 24 Jun 2026 10:09:29 -0400
X-MC-Unique: 4B-TTyI2MYOkmI4euVlJJw-1
X-Mimecast-MFC-AGG-ID: 4B-TTyI2MYOkmI4euVlJJw_1782310167
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-396d01a2ef2so4691381fa.2
        for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 07:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782310167; x=1782914967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=adeBgv4+WoF5/d6WW26NU8U4h0fAlJZdxze8uJxO0Qw=;
        b=Mx1gYxgbpjVs5xvd0gc2pRywKBQCCtYw10vOu8lXqr4gkW5CN+EXMePhYLy2OymFA/
         sWMt4Sf02sne6EUP1tZ9Iu0Eb6EMDU9bl6nPgHq5ZhQ6V2bdF0AOrCTB2FFUMm4hMB1j
         0P2VpnSDfIn+z6tsYr8Qa7lm9wASiIw5/xCOayI9vdMtUkXNwoYWpP/kt366DBaFyNRi
         Vf0q+s1nQxjeoJDw+85LkBebpzzXkImVnhwXDppymhcIhLbrx6PCmwaJO80aXzLQhAFz
         e3UBeh+xYIdPdi+yQKpfyWSFz8gTqMg7MMI6f+HhGonHkA0Thf9ZCbByJgg+0uqszjAb
         Mjng==
X-Forwarded-Encrypted: i=1; AHgh+RpI75uYuoqMjKyY4K6JSMcl6Q//+MO8lLx/P9BY81Q/ileK3r+dE9v76aH1P1VSXsWvRmG6UiOHgw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwgFPa2vbX0Z4dthucH+jPVZb/1HUGf4YQKoG/zMeG0+49EtElH
	Ocado8uWeHa71wsmQrTlXVbfgCCRGJYHOp7GR9qlFRRuyLwiLUZMoLqed+pJaeKyfpkA648dGMP
	WVzTN+v4ibdFDYbOEcxzeVAR+gxwRiXoL/S5OWKETAGQEN1313m/+WhW7mq0R3GN2xNK/+jvKJA
	rLrBM/DlcKFnoO7jC4vdMbm7clI7lzyVzijw==
X-Gm-Gg: AfdE7cmwKU4NdiI1IcJhW+Ll0lZrOuShNOf9jsPV8xIcIQE7mEnbRVvbAhowXygq7X+
	cFxNVoHa55A1W16Xmh+wxMlwNDT0+q+kFWWSZTW30CDGBXOh83GfiOfUB8quuxaggP2BtySbyZ/
	+UYscWJ0tAG26CQj+k+WEea5hfL5KUyz5wNGF9J6iKj5H5Fl30OwJ0KTMmkhXesI56WA==
X-Received: by 2002:a05:651c:b28:b0:399:77c3:dae with SMTP id 38308e7fff4ca-39aba2a5012mr9075991fa.17.1782310167362;
        Wed, 24 Jun 2026 07:09:27 -0700 (PDT)
X-Received: by 2002:a05:651c:b28:b0:399:77c3:dae with SMTP id
 38308e7fff4ca-39aba2a5012mr9075861fa.17.1782310166885; Wed, 24 Jun 2026
 07:09:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260617060053.71051-1-ghuicao@163.com> <20260617060053.71051-2-ghuicao@163.com>
In-Reply-To: <20260617060053.71051-2-ghuicao@163.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Wed, 24 Jun 2026 22:09:14 +0800
X-Gm-Features: AVVi8CfmiDfgfmtnh1QpMPxcSHoz17yQOAnjysnZg3BtiCVnmqMATzgOg4nFCdI
Message-ID: <CALjSBEuq3vyMSZMYCoW0jRrOVfEa+rTk+-eX+8hSVBZho6RbYg@mail.gmail.com>
Subject: Re: [PATCH 1/2] dm era: fix NULL pointer dereference in metadata_open()
To: ghuicao@163.com
Cc: Mike Snitzer <snitzer@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Cao Guanghui <caoguanghui@kylinos.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8eov0ybDsl-j5sJMHRyl8d9afvx7G4qACgJK_OwzyBM_1782310167
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2026 at 2:12=E2=80=AFPM <ghuicao@163.com> wrote:
>
> From: Cao Guanghui <caoguanghui@kylinos.cn>
>
> metadata_open() returns NULL when kzalloc_obj() fails, but the
> caller era_ctr() only checks IS_ERR(md).  Since IS_ERR(NULL)
> returns false, the NULL pointer is treated as a valid result
> and later assigned to era->md, leading to a NULL pointer
> dereference when the metadata is accessed.
>
> Fix this by returning ERR_PTR(-ENOMEM) on allocation failure,
> consistent with dm-cache-metadata.c, dm-thin-metadata.c, and
> dm-clone-metadata.c which all use ERR_PTR(-ENOMEM) for the
> same pattern.
>
> Fixes: eec40579d848 ("dm: add era target")
> Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>

Thanks for the patch!

Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>

> ---
>  drivers/md/dm-era-target.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
> index 05285c04ff2c..08ce96e8cf4f 100644
> --- a/drivers/md/dm-era-target.c
> +++ b/drivers/md/dm-era-target.c
> @@ -810,8 +810,10 @@ static struct era_metadata *metadata_open(struct blo=
ck_device *bdev,
>         int r;
>         struct era_metadata *md =3D kzalloc_obj(*md);
>
> -       if (!md)
> -               return NULL;
> +       if (!md) {
> +               DMERR("could not allocate metadata struct");
> +               return ERR_PTR(-ENOMEM);
> +       }
>
>         md->bdev =3D bdev;
>         md->block_size =3D block_size;
> --
> 2.25.1
>
>

