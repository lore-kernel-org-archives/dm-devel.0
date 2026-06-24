Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFC217A300
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 14:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782310017; cv=none; b=G31F0daDwsalRvi0G5RDdHPTu6I+YqFAO7SISfoS+GEF3FB/AEAz8+McB4Fm/Vi9ve61d46VivxywCVBtPrwuCYRHj+PWtkyCOP+dNuICNxCtnxDBk7aVIjloQ2MCSTWGMkbKBj6vZMb1QrXhjQFjw9BPtufRG4MhO+EEB20hzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782310017; c=relaxed/simple;
	bh=oNAIeOBb7gG9qSvXEn0TRZhnt6dqnuduHZ8eGEOf7ZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iOVHVHoLTVWskztJkPyMsmzSQjUYyMcqLZ4bkzBv1aPINcs9aLkgGkpTXAA4+Wl0kqbxynAamsIBD93FZoLR8zTql4Zr7W2Hll4mB0VX4k3VmEwmQwo8ql+qXVw35LOLdxxhIMadE9wdO2isZBB04YC2CE5WcqO5BU4YivEaRcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Aw6KH7rG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Aw6KH7rG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782310014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JqRZKlgCtrETR5TdNHB9dZz982J54GZb1q1Pea/fL5k=;
	b=Aw6KH7rGuB4ZQW+ULzsjPKxNOZIK2wXczeTuSisIIDAT9ODjSRMEg0dK/BRXEfq0ImmvF/
	9+GEnd4gKKCMUugDHGZFLSZmyE6AT6UJTph7IdS8d9lxrtB7XEhiFEO7dXo8eQ057H526z
	jEqct6kZedtx+nVdDJML7vMTnCHB3GM=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-1T-SvYjDPEChx3bjH2f2-Q-1; Wed, 24 Jun 2026 10:06:53 -0400
X-MC-Unique: 1T-SvYjDPEChx3bjH2f2-Q-1
X-Mimecast-MFC-AGG-ID: 1T-SvYjDPEChx3bjH2f2-Q_1782310012
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-396a99b2de0so4019931fa.1
        for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 07:06:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782310012; x=1782914812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JqRZKlgCtrETR5TdNHB9dZz982J54GZb1q1Pea/fL5k=;
        b=ZRtTw67jU+t1DV/QQJJ+8pbN1lYSRoR83QxoREQZP/JYgQj/qZ8mdk2Yaoc0QNMaUL
         mB2jwR5QruIRyvcjW5YOlIr0/ieIptkwcEPgUjMM4E8AV56L9lCeHGnS1n3gmuqhxxf/
         /mgqsN7QppuZWNzxSHpWbOI1ZcKYl5CyEVqul/A/k15rCLMcaZtJLsltxfLIwgjE4MgO
         /ResQmcowpDYN/ztAj34qezhMiwaDH0pAEjNIBG5ijCF1V5N1folxaZV5kZDKcohZTHx
         DTgYOEPwESja3utNeht/SuNyJv7pvKCZ0LmMtStdBcslt6do/O2jJGjPrEUntXeYW0nG
         GpJw==
X-Forwarded-Encrypted: i=1; AHgh+Rp8LBoGkQV9kZlcDJVvnfPMlFzcvrC2zTdHr8VSFIV/71Xcy/usfeY6s0VzrV+K0A82PYO63k0RbQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwuHwsru24A2ejFo+s45362uI8jvqLWjWVRuprJXQNqD6oSkRpv
	5brrUn60rw+KqTXCBMSwdlvD0wks9erkoElXYPIx/QGBzCjs3vNPKGjXbRF/YX3usYl3SLPSltE
	Ak4WgF9qflPA5PCFWiTblJN54Rz82xKeA7vJTeytXs9ut2ycp7lEcLzZJMxE7GuilaXI5SK401J
	RzqiH/1rDPnAg99nHBykMp/DndVEJzu9QVpw==
X-Gm-Gg: AfdE7cl9n4DNyUtz7Aih3uafNmk05kUeWDDd21x8hsaTpE7m/wzzguo/I5E3O6YcWgj
	On7aRvly+68boHJOvTzD4FFmyBudCN7aHs9uyPFprCPvsnPdWyaeEC9qy5+c7t+uBM/Tjjg5Hay
	/jCw0Hg61uY3gScwc1cSmrniLnvIW/H/+gJCpkwDtSNk3aBMWz2iXoTBnyqnuS9frXZg==
X-Received: by 2002:a05:651c:210d:b0:393:9ee6:1b7b with SMTP id 38308e7fff4ca-39aba206009mr9046171fa.22.1782310010147;
        Wed, 24 Jun 2026 07:06:50 -0700 (PDT)
X-Received: by 2002:a05:651c:210d:b0:393:9ee6:1b7b with SMTP id
 38308e7fff4ca-39aba206009mr9045831fa.22.1782310008965; Wed, 24 Jun 2026
 07:06:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260617060053.71051-1-ghuicao@163.com> <20260617060053.71051-3-ghuicao@163.com>
In-Reply-To: <20260617060053.71051-3-ghuicao@163.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Wed, 24 Jun 2026 22:06:36 +0800
X-Gm-Features: AVVi8CeavXRPhfjcIOyAgpK9FP7lkKBmEOC4ZmyRw0rZprC4eFzNE0n46zBYUbE
Message-ID: <CALjSBEtBfn8M+uZd24qYdjq-094xTcV11q1bPkKxEvASoy=djQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] dm era: fix error code propagation in era_ctr()
To: ghuicao@163.com
Cc: Mike Snitzer <snitzer@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Cao Guanghui <caoguanghui@kylinos.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rlgUcusG_vn1LfiMu6iWzGkOnXLNko0-wlY64koCR3c_1782310012
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2026 at 2:12=E2=80=AFPM <ghuicao@163.com> wrote:
>
> From: Cao Guanghui <caoguanghui@kylinos.cn>
>
> era_ctr() replaces the actual error codes returned by dm_get_device()
> and dm_set_target_max_io_len() with hardcoded -EINVAL, discarding
> the real reason for the failure (e.g. -ENODEV, -ENOMEM).  This makes
> it harder for users to diagnose problems and is inconsistent with
> other dm targets (dm-thin, dm-verity, dm-flakey, dm-ebs) which
> propagate the original error.
>
> Fix all three sites to return 'r' instead of -EINVAL.
>
> Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>

Thanks!

Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>

> ---
>  drivers/md/dm-era-target.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
> index 08ce96e8cf4f..4eb1c4f90e1b 100644
> --- a/drivers/md/dm-era-target.c
> +++ b/drivers/md/dm-era-target.c
> @@ -1488,7 +1488,7 @@ static int era_ctr(struct dm_target *ti, unsigned i=
nt argc, char **argv)
>         if (r) {
>                 ti->error =3D "Error opening metadata device";
>                 era_destroy(era);
> -               return -EINVAL;
> +               return r;
>         }
>
>         r =3D dm_get_device(ti, argv[1], BLK_OPEN_READ | BLK_OPEN_WRITE,
> @@ -1496,7 +1496,7 @@ static int era_ctr(struct dm_target *ti, unsigned i=
nt argc, char **argv)
>         if (r) {
>                 ti->error =3D "Error opening data device";
>                 era_destroy(era);
> -               return -EINVAL;
> +               return r;
>         }
>
>         r =3D sscanf(argv[2], "%u%c", &era->sectors_per_block, &dummy);
> @@ -1510,7 +1510,7 @@ static int era_ctr(struct dm_target *ti, unsigned i=
nt argc, char **argv)
>         if (r) {
>                 ti->error =3D "could not set max io len";
>                 era_destroy(era);
> -               return -EINVAL;
> +               return r;
>         }
>
>         if (!valid_block_size(era->sectors_per_block)) {
> --
> 2.25.1
>
>

