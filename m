Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A3314270
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 21:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705612240; cv=none; b=RXU6UsxjExTitU8CkHC5itcdT7XQkHyb2lrCrVj4eCiLcMcF4pVh3k5XwmXMbgvNJRY50ZUWZzpaPolwa0F28aoHYFKBwulT9v0tCBeU/NmlpjmYDJXReEomlYld5F4sSXd1YcSD2OH3/K70Os40NnDzFElevH83ZQuQKEHqtic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705612240; c=relaxed/simple;
	bh=E36lb9971gspdwHvqSU1/PsIOqT0FM9IV+e+X0oDMWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UrUTzHa60ouXsz8T2ptovyJP7WfgyXDowfIE+VOUKfdFh6akBwo1SyaWTfG1mk4/mp6GJEy5s8rDnO6lWCu0lfDjQB97UZDnhs+IGn3CkfSMmDJ62t5i1d8NGESbTamvsI7/C8GTeSpzBFoQXDC6IZpBl4dg1fvBPD5lhS0pK+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5v1G8oN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5v1G8oN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52C0C433C7
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 21:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705612239;
	bh=E36lb9971gspdwHvqSU1/PsIOqT0FM9IV+e+X0oDMWM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=i5v1G8oNmaA5WEwACNLCQTk8rygkE5SCUeM5hQNsuWpjX9O0oqIX93l5K7Cr8R2I+
	 dAtaMSLPaRrf/Z9UeRBkdoE9gLwSpiVnEFE6Szky5jCWCU72rhhJdobKBtElvImYnu
	 v8mCUVTxuE/7vGSJBz5MXvdArpQAhg4t6g4DFqIp3cCXIyGUb0AKsir3shRcuNqUID
	 dp/+wBU5cKyQwIuh3KGVi41Fp5tSm+3IMaYNrPXHOFwgIGhtHI9873gKRhzVhuH/fx
	 ICB3Dn+sSI5T1NOxhZQtsSwjkXdR3gMjS7yDsd3LPe/yIZlFZkPmVVRYDYWdyNVnZj
	 Fpg1TEmAaBnuQ==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-50e7f58c5fbso40439e87.1
        for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 13:10:39 -0800 (PST)
X-Gm-Message-State: AOJu0YxdAuX30OyX3Rd26n/w7n0knrNMk2Fx64yQMQPzivbek1HeEeNg
	UPdtfszkt45aG2onQ7Vmt1IcUBpxPpX66/SQXXDSvpflxPtRmwTgZfd9iyPx+PErcg8/8tfLKhL
	7LGa0zjMZg+aOcy7amqnd3nR1b7w=
X-Google-Smtp-Source: AGHT+IFu2+ALYFAH2oZVTnMUCSYFs9LjmzHM81+AXJfESBRuaPMfDftzsau+nfNTcYukQe+XMXqBmRduns0x3HG4u1U=
X-Received: by 2002:a19:5f0f:0:b0:50e:7cbf:7d82 with SMTP id
 t15-20020a195f0f000000b0050e7cbf7d82mr123238lfb.128.1705612238158; Thu, 18
 Jan 2024 13:10:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
 <9801e40-8ac7-e225-6a71-309dcf9dc9aa@redhat.com> <CAPhsuW483DSEvgoT0c-Mo1gdpVKRRLkTxu+kuxYG6k-zew+FFA@mail.gmail.com>
 <82e9b11f-e28-683-782d-aa5b8c62ff1a@redhat.com>
In-Reply-To: <82e9b11f-e28-683-782d-aa5b8c62ff1a@redhat.com>
From: Song Liu <song@kernel.org>
Date: Thu, 18 Jan 2024 13:10:26 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4YLVLhv2ii0UjiQOmiqR3mk6u8r94-SVZjMs6LVp+WaQ@mail.gmail.com>
Message-ID: <CAPhsuW4YLVLhv2ii0UjiQOmiqR3mk6u8r94-SVZjMs6LVp+WaQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] md: test for MD_RECOVERY_DONE in stop_sync_thread
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Yu Kuai <yukuai3@huawei.com>, David Jeffery <djeffery@redhat.com>, 
	Li Nan <linan122@huawei.com>, dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 18, 2024 at 5:24=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
>
>
> On Wed, 17 Jan 2024, Song Liu wrote:
>
> > On Wed, Jan 17, 2024 at 10:19=E2=80=AFAM Mikulas Patocka <mpatocka@redh=
at.com> wrote:
> > >
> > > stop_sync_thread sets MD_RECOVERY_INTR and then waits for
> > > MD_RECOVERY_RUNNING to be cleared. However, md_do_sync will not clear
> > > MD_RECOVERY_RUNNING when exiting, it will set MD_RECOVERY_DONE instea=
d.
> > >
> > > So, we must wait for MD_RECOVERY_DONE to be set as well.
> > >
> > > This patch fixes a deadlock in the LVM2 test shell/integrity-caching.=
sh.
> >
> > I am not able to reproduce the issue on 6.7 kernel with
> > shell/integrity-caching.sh.
> > I got:
> >
> > VERBOSE=3D0 ./lib/runner \
> >         --testdir . --outdir results \
> >         --flavours ndev-vanilla --only shell/integrity-caching.sh --ski=
p @
> > running 1 tests
> > ###       passed: [ndev-vanilla] shell/integrity-caching.sh  4:24.225
> >
> > ### 1 tests: 1 passed, 0 skipped, 0 timed out, 0 warned, 0 failed   in =
 4:24.453
> > make[1]: Leaving directory '/root/lvm2/test'
> >
> > Do you see the issue every time with shell/integrity-caching.sh?
>
> Hmm, that's strange - I get a hang with this stacktrace sometimes
> instantly, sometimes in 30 seconds. I test it on the current kernel from
> Linus' git - 052d534373b7ed33712a63d5e17b2b6cdbce84fd.

It works for me. I guess there is some difference in the config/system?

VERBOSE=3D0 ./lib/runner \
        --testdir . --outdir results \
        --flavours ndev-vanilla --only shell/integrity-caching.sh --skip @
running 1 tests
###       passed: [ndev-vanilla] shell/integrity-caching.sh  4:18.360

### 1 tests: 1 passed, 0 skipped, 0 timed out, 0 warned, 0 failed   in  4:1=
8.749
make[1]: Leaving directory '/root/lvm2/test'

[root@ ~]# uname -r
6.7.0-09928-g052d534373b7
