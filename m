Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5322B1F2380
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 17:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737393706; cv=none; b=AJVAXxZCjHe11oDdYrKbYAUMRztkUtaumy8RuJZuhaPnzMCzN3NztK99VmWwB8u6hFhF7fvmgf+LPI+0bvDqxzJx12FrAM1I2apCchTGSNUOdoP+lTB1iSiR/UkIZcP7ShBAhTwYc8cPd9S7WcrHL/CERljTF8vVjct3x2pQLRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737393706; c=relaxed/simple;
	bh=XBszVvBOIF+9uHPexwNKsHLE7SGVCYrgbc9wwbOSMXI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kXG/PgPqxQMTtjb3iX21izKfnJAQP4eiytw9W37h7aIpdbkqRIaGvWPckkZXgeVYRBaVuOp7IHocjE7Qa7BuJzaeDHdIBqlG2447MRgycxYZK3OTcp2k4Z1dWOHGPA7GvfHy+pisc9HGYswIZB4ASKIQeR/7l3E7Xp3PrxsXYCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=exw+QNd9; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="exw+QNd9"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2ee9a780de4so5960568a91.3
        for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 09:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1737393703; x=1737998503; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7juRAO5chmvvm4H2sah2Lvcs3nr+XEf+HYnJJzhzQiE=;
        b=exw+QNd9/EiCkZjwhnMpOIE74cfzZiOC5aPekXO9B8RMv3Rf/uR4nTyOEfEhlyzxdC
         i+wf9qoi+Kl75vMSfPYpg0uzLJuplvdh5HG1Firt7o0XvzbbrZ8N4i1qU1NuMMZvpa2I
         AIWnYGbd2+Ac2P6V2s/Z4JsDxTfdRaYMkP/Pua/8pj1cMKNQDlP4l5iV7w5kq36eAdbS
         Me+5KZam0EKKkTJej6AeW/winASO7Lj7UN0QgVQkCNnJi+kXTVUlUyilpTWHgnJ6fEZ7
         WgqbeNOIFvXPvc3PRxvYVbcUMPp2f7fkpCpg2/94MF9pWvfs54flg444I/j0vMeHRGr+
         GlCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737393703; x=1737998503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7juRAO5chmvvm4H2sah2Lvcs3nr+XEf+HYnJJzhzQiE=;
        b=Mab3CmIRXjuDy2CbaSVL779zKwhKsW6EtX9i4En257S0HafM+KijRns//i9GUribbc
         xYwSfO/WgkwTK+XlglV8JEUfjtTvRBZyJ0pPjjtEUUm4/MR8GE00IP3wLYfeTyGZ3vJx
         3Ip5Qn0PX/vyC8qUk20rsEOZp2VzHiSN/XwhtnpueEPiBtDn9wxt/dK1XGLbnj+dUAjB
         psPG4mvmxNPsPU7PKS4r6KeDqwxPNiKd/a3K37jN3lu25niKCw1o38IoNf4/oio1h2I9
         IRZwXX7HlncGSP44VvnLE3klHlrpYTZ/He83vACCjjmVUoOaC0R9AWdjdVr/WR97em3m
         bFow==
X-Forwarded-Encrypted: i=1; AJvYcCUO+aOMdcTKYv5UZv360qpV30UAPYC622lwYiEJNpck/p1yoYWVi7dXNbTUe+ZvBPtncEFotbRNLQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyS7g4qWsciRlOt4BtD+uZdwB2ClPP5V5mvBH2YIBnTM3i6/qYR
	5Jdxz4vZ5oU3GvB9H2fSNhxDzN6IyAZo7lDFZZeCHpSSXyj+Zyhjy+1NbPtRA8+Twih16j41AfI
	xeSYPS8dg1vhKg1yb/gKVvxOVGuxASLkT2p/Oig==
X-Gm-Gg: ASbGnct1TU+K3/YSYRTW6BzK4oNe6AGl9OC06LN6Qht3Z2N7VWsM7RTm4g79/wUxKU/
	n6+Tak7jIZbBQH1SfYH6Odz3gCdx/HAWUVPCainXu5PjTCQLyOsV91zwXD4dcrxeic1QH
X-Google-Smtp-Source: AGHT+IFqU9lcvkEmYEV5eXzbAiK5Sx0YMKws1A1OG3WKLU0er5zsMlfH3RABrCnFKBygyPXrRpyROmcHKTsUQiEE+1E=
X-Received: by 2002:a17:90a:c2c7:b0:2ef:2d9f:8e55 with SMTP id
 98e67ed59e1d1-2f782ca1fffmr22208380a91.17.1737393703442; Mon, 20 Jan 2025
 09:21:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250120082951.1423804-1-houtao@huaweicloud.com> <20250120082951.1423804-2-houtao@huaweicloud.com>
In-Reply-To: <20250120082951.1423804-2-houtao@huaweicloud.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Mon, 20 Jan 2025 17:21:32 +0000
X-Gm-Features: AbW1kvZJvXZ4TOOPfOa-hITRAFg5qVevRcVwBQk4bUQdDgISLVDmAhkhjTPBcgo
Message-ID: <CALrw=nGZfDkMrmPTt4byirpaPD9oGbx8OJS1JNk79h1h=wwHRA@mail.gmail.com>
Subject: Re: [PATCH 1/6] dm-crypt: set atomic as false when calling
 crypt_convert() in kworker
To: Hou Tao <houtao@huaweicloud.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, houtao1@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 20, 2025 at 8:18=E2=80=AFAM Hou Tao <houtao@huaweicloud.com> wr=
ote:
>
> From: Hou Tao <houtao1@huawei.com>
>
> Both kcryptd_crypt_write_continue() and kcryptd_crypt_read_continue()
> are running in the kworker context, it is OK to call cond_resched(),

yes, indeed

> Therefore, set atomic as false when invoking crypt_convert() under
> kworker context.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Maybe add Fixes: 8abec36d1274 ("dm crypt: do not wait for backlogged
crypto request completion in softirq")?

Reviewed-by: Ignat Korchagin <ignat@cloudflare.com>

> ---
>  drivers/md/dm-crypt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 1ae2c71bb383b..424c8fc3f0ada 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2098,7 +2098,7 @@ static void kcryptd_crypt_write_continue(struct wor=
k_struct *work)
>         wait_for_completion(&ctx->restart);
>         reinit_completion(&ctx->restart);
>
> -       r =3D crypt_convert(cc, &io->ctx, true, false);
> +       r =3D crypt_convert(cc, &io->ctx, false, false);
>         if (r)
>                 io->error =3D r;
>         crypt_finished =3D atomic_dec_and_test(&ctx->cc_pending);
> @@ -2203,7 +2203,7 @@ static void kcryptd_crypt_read_continue(struct work=
_struct *work)
>         wait_for_completion(&io->ctx.restart);
>         reinit_completion(&io->ctx.restart);
>
> -       r =3D crypt_convert(cc, &io->ctx, true, false);
> +       r =3D crypt_convert(cc, &io->ctx, false, false);
>         if (r)
>                 io->error =3D r;
>
> --
> 2.29.2
>
