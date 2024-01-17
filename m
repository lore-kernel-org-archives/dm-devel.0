Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9611E259D
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 00:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705536007; cv=none; b=HPm1Otv/SxGFn8gFv7oVNUpHt+3xs0BnkktxhOPou2TlQx0R9IvaElYPgzjb/TcL+ZNlkTX/koQEq62zWIn0XHmAFzaHPuxfd7eYjNZRBFJjdjQfC/FGIcK00UYh8ktOG5woBeNLq1wk1xSCUKoc4nF6wW4dKqvgTqII/tTjyss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705536007; c=relaxed/simple;
	bh=ICFaVXJJ9A1he9hLcACPLMMrvDJSPzIftgCzsWGeTWw=;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding; b=kU+F69EgxBy+/NwOfok98ZwFa2iDqgZOdmDOSk54yVSmcpi9ySkBqH69M9HlTlpTqIo1JaXjbVpaQTQNc1n1cdJ3CLeV6XbxHaTJcqiI9H5Rf9bpTmjswd0R0OJUutZVykJQ0P6Ye3NbPQ/Onftpj4Elg4Uilf3dWArvWoypGYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WgK23xia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WgK23xia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC38C43394
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 00:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705536007;
	bh=ICFaVXJJ9A1he9hLcACPLMMrvDJSPzIftgCzsWGeTWw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WgK23xia1DyS2nG+zlYFA62dotRx5ZjWDGQMhp2kms4ig174ptXPTikHZKM3hLdf6
	 ZPLQZqvZst+kuinKaPX7DTz4PSn7FJ90Kma1qj1842p2JtkCZ+EbNp3WDn6+0v2U89
	 rvughSMLfMnmpx3JDnik7RCeEdRR3kyTJt1ws6Vs79ZH1gLH2KTJkAkZkdTAqjfHYx
	 m74Y6Wvra6Uye29GaBGyZnkFPoU3fBsDtTsmOfeQ/FgeJ3PYB8uS6aW+qXiRpRORqZ
	 SB9O4QXh/tZNnaT2BmK0YW0v+QQpzMPqv6POKmfoX5QvjKjxq6lY9zwp40tgpRhu/T
	 FRnFBdXXXxR4w==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-50e67f70f34so12338028e87.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 16:00:07 -0800 (PST)
X-Gm-Message-State: AOJu0YyNzjq1uHIXtmbi5saZnQUEovyD0yjMZ5TmK6fQQEMqhnNY1djj
	K86MFpfP0dbAR/LRrHQ/Xlj/ROP+BWeH9vc8eYI=
X-Google-Smtp-Source: AGHT+IEN6uSKuaOOd+u3Zm2UegpNfsYM3sXu8V+5eNrWq7szR8UzCYeBQwECRslV+0A2d1f/5yrsvyk0CN92gUeek4M=
X-Received: by 2002:ac2:4824:0:b0:50e:fe09:6597 with SMTP id
 4-20020ac24824000000b0050efe096597mr2101436lft.69.1705536005411; Wed, 17 Jan
 2024 16:00:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com> <51539879-e1ca-fde3-b8b4-8934ddedcbc@redhat.com>
In-Reply-To: <51539879-e1ca-fde3-b8b4-8934ddedcbc@redhat.com>
From: Song Liu <song@kernel.org>
Date: Wed, 17 Jan 2024 15:59:54 -0800
X-Gmail-Original-Message-ID: <CAPhsuW42XBw4nUWzssSMh7i=ULL++yF5twFB8d0digmVLXQ6AA@mail.gmail.com>
Message-ID: <CAPhsuW42XBw4nUWzssSMh7i=ULL++yF5twFB8d0digmVLXQ6AA@mail.gmail.com>
Subject: Re: [PATCH 7/7] md: fix a suspicious RCU usage warning
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Yu Kuai <yukuai3@huawei.com>, David Jeffery <djeffery@redhat.com>, 
	Li Nan <linan122@huawei.com>, dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024 at 10:22=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.c=
om> wrote:
>
> RCU protection was removed in the commit 2d32777d60de ("raid1: remove rcu
> protection to access rdev from conf").
>
> However, the code in fix_read_error does rcu_dereference outside
> rcu_read_lock - this triggers the following warning. The warning is
> triggered by a LVM2 test shell/integrity-caching.sh.
>
> This commit removes rcu_dereference.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> 6.7.0 #2 Not tainted
> -----------------------------
> drivers/md/raid1.c:2265 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> no locks held by mdX_raid1/1859.
>
> stack backtrace:
> CPU: 2 PID: 1859 Comm: mdX_raid1 Not tainted 6.7.0 #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/0=
1/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x60/0x70
>  lockdep_rcu_suspicious+0x153/0x1b0
>  raid1d+0x1732/0x1750 [raid1]
>  ? lock_acquire+0x9f/0x270
>  ? finish_wait+0x3d/0x80
>  ? md_thread+0xf7/0x130 [md_mod]
>  ? lock_release+0xaa/0x230
>  ? md_register_thread+0xd0/0xd0 [md_mod]
>  md_thread+0xa0/0x130 [md_mod]
>  ? housekeeping_test_cpu+0x30/0x30
>  kthread+0xdc/0x110
>  ? kthread_complete_and_exit+0x20/0x20
>  ret_from_fork+0x28/0x40
>  ? kthread_complete_and_exit+0x20/0x20
>  ret_from_fork_asm+0x11/0x20
>  </TASK>
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: ca294b34aaf3 ("md/raid1: support read error check")

This makes sense to me.

Li Nan, please review this fix.

Thanks,
Song

>
> ---
>  drivers/md/raid1.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/md/raid1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/raid1.c
> +++ linux-2.6/drivers/md/raid1.c
> @@ -2262,7 +2262,7 @@ static void fix_read_error(struct r1conf
>         int sectors =3D r1_bio->sectors;
>         int read_disk =3D r1_bio->read_disk;
>         struct mddev *mddev =3D conf->mddev;
> -       struct md_rdev *rdev =3D rcu_dereference(conf->mirrors[read_disk]=
.rdev);
> +       struct md_rdev *rdev =3D conf->mirrors[read_disk].rdev;
>
>         if (exceed_read_errors(mddev, rdev)) {
>                 r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;
>
