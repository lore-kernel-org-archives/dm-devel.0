Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A37130E49
	for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 17:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706203907; cv=none; b=DPNfXdBo9r6+DfQmi/ieIwOQN7SgK0iWe9CDcAmD1X4RO65HF95yMn15S1PXRnfy+vSAEwp/zET17F3t4ZipsOcIlnPDQG0j8c3Uq+se9xmLp0g9j036V1crLA7sjgCxTsV2srFm7xKzHHYddTwl97STN0TesrKyp4NSP/XXGuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706203907; c=relaxed/simple;
	bh=tMAcQyO1BGp1/15wfQzAXO3/QDfH+atePYwWBrZCDfg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D9FVTH/U5Dz4x5nX1BXVvu4Wr5iIAKJe5BDHVFyb2NnO7QJvyx1CGctJHInpAS+pgeiCHfV2mIU28EmsNiXtjAka06dR1pv64auBvB7PtyqCDQ7EhhwZBdSCcEa3dcdVK3xa4PBGNqpaoQ0jD8E5y58vSL2ZP3x6lPZla640lOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FHpqpprP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FHpqpprP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1340CC43399
	for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 17:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706203907;
	bh=tMAcQyO1BGp1/15wfQzAXO3/QDfH+atePYwWBrZCDfg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FHpqpprP/t4q1Aaw37geiIOmIghYfQtEa3JT5mltcfjvHzZNCW/P4omLaMs3mjKD7
	 JW5HAuq82UbnP5lfg0Ax5qJKSGlru9NhY66MOnMiwfBOeNOERiChRY5Z1KTBBpKCBU
	 HfmXX9fvErR15s/IF7wLnXsXQSTPFefndGa64P0pm+4TPzEQnXDYoHePRp/ZBXrKWv
	 0l7RInYiaC7hLt/O9yVKNchcoUGDLE/rjpV0VjdHyXmVvm7K2K2/F0llHsY1sNoslj
	 5BUV+ujtZ+WjkeMgez1eLWywtQZ53Ow3qzDgQmLIn8sVXgHVurS5eKa3fll0o8UYzC
	 99tDcn7HiXhVw==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2cf35e5c2ddso9761541fa.2
        for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 09:31:46 -0800 (PST)
X-Gm-Message-State: AOJu0YyuXTws1XWbaYiNIcT0ARt9M5fMxNcEJhbnJA/iSX9UWcJc3fKy
	iSItm+b2URpSpH8jfaRdsRVB/T2aQPxXvbUVEHYHGkgOqKmevdU1KOhwDQU7z4OV/G6LiXiUsDL
	s41vTL5DFwIoojUVQtcUuQGTzoJs=
X-Google-Smtp-Source: AGHT+IEKn9K9OzxKhNn7Uc1YnRRg55Lz1xwrGjSlsXJPNHs0tBDNnNaENtXG2Srm60hExusD+lRjeh3xjeAEcw6VIg0=
X-Received: by 2002:a05:6512:e83:b0:510:17b3:9f3a with SMTP id
 bi3-20020a0565120e8300b0051017b39f3amr85559lfb.127.1706203905260; Thu, 25 Jan
 2024 09:31:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
 <51539879-e1ca-fde3-b8b4-8934ddedcbc@redhat.com> <322e1306-6507-9707-7985-f460e2536cf0@huaweicloud.com>
In-Reply-To: <322e1306-6507-9707-7985-f460e2536cf0@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 25 Jan 2024 09:31:33 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5ahQy9=JciyHLRWBFkXPErZr8cAh+ajnA3gb3ui0zDrg@mail.gmail.com>
Message-ID: <CAPhsuW5ahQy9=JciyHLRWBFkXPErZr8cAh+ajnA3gb3ui0zDrg@mail.gmail.com>
Subject: Re: [PATCH 7/7] md: fix a suspicious RCU usage warning
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, David Jeffery <djeffery@redhat.com>, 
	Li Nan <linan122@huawei.com>, dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024 at 5:56=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
[...]
> >   </TASK>
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Fixes: ca294b34aaf3 ("md/raid1: support read error check")
>
> LGTM
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>

Applied patch 7 to md-6.8 branch.

Thanks,
Song
