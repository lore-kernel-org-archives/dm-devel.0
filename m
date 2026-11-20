Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795158319;
	b=KyIRzK/BJQ9o+o29V+3H8NpcrjefrgOsJOjj85NqxziCcAsgzjG4cmDM15UCxLarRgPp
	 DXHjhSoqUSCBDpWrpYMQpT5xlZy7QpEgg8OOkH9ez96/GQebw9AEEBwfDckFWGe1hRQcG
	 3PRRYJb7+PMvLYNESHGBFYgSP6vD5nQHJyQ07G++MG6UZ+aMnsi9PsU5mwpayD4x5tK8h
	 8keDD1lnSpLcZpjfX/p0l7p30Xm2pBdM+SbFb/Bk0/heccz+rMx+slf1VWnOziGFhSekf
	 whm14O6WdTj2g9Lk3zO0mFkUHXukQTS5ftbOCkkMfNJdKBw85phg8C5SZPcshDcb5Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795158319;
	h=DMARC-Filter:DKIM-Signature:Content-Type:In-Reply-To:Reply-To:
	 Message-Id:User-Agent:Cc:Subject:Date:X-Lms-Return-Path:
	 X-Original-From:From:Mime-Version:Received:Content-Transfer-Encoding:
	 References:To;
	bh=5zP5q72DWvQvijg0sSGdzorkS5oZvfpTf7vMW3JaQss=;
	b=QM4urebrlYI765QGUtm7zbxtotJQsyBr/lABKd3goSYlb3huYg/YD7W9Hlu+ZrzsqAsX
	 0Xix/HrNGTjuFJnPKmWkES4+1UCWLcyLrGcJ8jt5g35JkX25kO0F44LDkdtDzUyDmMB/m
	 wINjTG6j/Iz25Sz5RceRbgmXKlVmJt87v8JPRJfkwYCM00xDuXYYRP/rty9T8sypbLlBO
	 eL4JFvCJv3OgKhjFTQyM8BeJYsBzzyHUtI3yYpCIGoiGpzpuu/IiSjPKYp9Fe23NsLzzR
	 K5A3BmrpKTqtmbRDnMorKstEmmmau27ENXzQVx5VU/5mfOUR8+mPlM3Evqgq1yqnkgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=K7lMONVX;
	arc=none smtp.remote-ip=209.127.231.18
Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC0A606A326
	for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 07:05:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AC0A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=K7lMONVX
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795158306;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=5zP5q72DWvQvijg0sSGdzorkS5oZvfpTf7vMW3JaQss=;
 b=K7lMONVXRVEx2z/BY5Z6rpq2onJizjNYKRmRC37lIt53LKsSPTjSe22ZV0/oO4nZso+SuV
 mrbEniQk03HA6FImHV4eye+a79Sy/8bez6dvNPsYv/GuJQETkdPo9sisJRr2VWWyUuj9o1
 pOZGjsfFbdROBn5EugedFzH6M7xIuX7YJ2E+oofzd2UkQr73rLnY4IjgcrFmh0Fs9pCWWT
 oQXaFXKEOHxd1kBk0zmgeU7ulSmtQSLlx80Ct8UszUMOUef7FIhSpl3w4IzMB/WWEXwKQg
 hLbWewJlnVXR0qABh1lAI5YWLQ90E0p8Ac8JulQ1f96RG+iADbgW9kstuuwTCQ==
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20261110054456.625-1-nenkov2004@gmail.com>
Reply-To: yukuai@fygo.io
Message-Id: <4d13edef-f454-437b-8910-3a905697303e@fygo.io>
User-Agent: Mozilla Thunderbird
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"NeilBrown" <neil@brown.name>, <dm-devel@lists.linux.dev>, 
	<linux-kernel@vger.kernel.org>, "Alasdair Kergon" <agk@redhat.com>, 
	"Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, 
	<syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com>
Subject: Re: [PATCH] md/raid10: preserve recovery flags on reshape abort
Date: Fri, 20 Nov 2026 15:05:00 +0800
X-Lms-Return-Path: <lba+26afff122+f1895d+lists.linux.dev+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.159]) by smtp.larksuite.com with ESMTPS; Fri, 20 Nov 2026 07:05:05 +0000
Content-Transfer-Encoding: quoted-printable
References: <6aec6738.059f5055.2712e4.0005.GAE@google.com> <20261110054456.625-1-nenkov2004@gmail.com>
To: "Hristos Nenkov" <nenkov2004@gmail.com>, "Song Liu" <song@kernel.org>, 
	<linux-raid@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/11/10 13:44, Hristos Nenkov =E5=86=99=E9=81=93:
> raid10_start_reshape() can fail while resizing a bitmap before it
> changes any recovery bits on its success path. Its abort path nevertheles=
s
> clears the entire mddev->recovery bitmap.
>
> dm-raid keeps MD_RECOVERY_FROZEN set across suspend and resume. If RAID10
> reshape setup fails, raid_preresume() logs the failure and continues with
> resume. Clearing the bitmap removes MD_RECOVERY_FROZEN and makes
> raid_resume() hit its invariant warning.
>
> Do not clear mddev->recovery from the RAID10 abort path. The error paths
> reach abort before raid10_start_reshape() modifies the recovery bits, so
> there is no personality-owned recovery state to roll back there.
>
> Fixes: bb63a7019df9 ("md/raid10: resize bitmap when required during resha=
pe.")
> Reported-by: syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D8b22a0459202f76b4096
> Signed-off-by: Hristos Nenkov <nenkov2004@gmail.com>
> ---
>   drivers/md/raid10.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 066c43154..1fd3f5f4f 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4490,7 +4490,6 @@ static int raid10_start_reshape(struct mddev *mddev=
)
>   	return 0;
>  =20
>   abort:
> -	mddev->recovery =3D 0;

This is not quite related to this patch, but take a look at rs_start_reshap=
e(),
MD_RECOVERY_WAIT is set before calling pers->start_reshape(), and it's neve=
r
cleared from error path.

This should probably be fixed first, and then it's safe to remove the above=
 line.

>   	spin_lock_irq(&conf->device_lock);
>   	conf->geo =3D conf->prev;
>   	mddev->raid_disks =3D conf->geo.raid_disks;
>
> base-commit: b3dfbde62cf1981c4638939c159dfd087b7a72e9

--=20
Thanks,
Kuai
