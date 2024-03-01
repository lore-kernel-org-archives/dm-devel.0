Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9AB54273
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 22:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709332098; cv=none; b=JY73tO7tFevCLpmXuqzjIv58uuy5fKLJ/jaWBGm2AZxsXlK9YbHoE4HkqUy/EVoyxXACSwc1GNm5BbfPlF4QmWQMQ3KtPgqwHcbz0zrEMgE7ZDOz7YnKT9qBGFgigZfc8z7oPYoRmRD9AmTHhcozmPooGT98XDJ1glF0zU0u5a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709332098; c=relaxed/simple;
	bh=LTNQ8bBXVVn44KSD7jnmWex4tETOHydeEvSX1XwWOFA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jWJQaADR69nTGXz2Bsg2tu9BOPIip6Uw19AmmppEiyHCKwucXZNshr0zSaABIYkA9Fg0W4zzImzAPD/D2wT+H7iayf6OvSGBM7tS4/5yddCpKpqzi9F4TM4YjaNtJIVMb+d95lRIgN3ZOXGA9UT3+ZSsRKvaMY4TqtgRLwVn41w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIdOno/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIdOno/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81384C433C7
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 22:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709332097;
	bh=LTNQ8bBXVVn44KSD7jnmWex4tETOHydeEvSX1XwWOFA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MIdOno/5syUTsn3RW9NpNXA+gVfL+/4NgeVfiE+1ZDENJcusLpKG/TfoxCk73dCZB
	 MGCe/o8zH+ekE8ooQI3J0PeBDMZvD54FUoVIXIuEOIX2zugcJEZIJaAM1nMgEm91Jo
	 GbC3OCtEt8dA1pM22eICqt6XaK86v/9rsfdYy7ODwvtw/NHzlhD3tb8oz/barelg/o
	 klx4BF3IGyCr6JR4CcUmwqFQHS6RllZVoQk7TZtgnXUlPOX/HDjjjMeGecsOMHJslV
	 pKxs2MI68xvHw+at+Y0zK6/6cdG1Jy4Tn+znFaamjaXxvoDUiXCDu+n0G74McAMd/A
	 GKzb9mJiBnaRw==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5133b5c0911so89959e87.0
        for <dm-devel@lists.linux.dev>; Fri, 01 Mar 2024 14:28:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX/oMo7emwPE+A7tKx7qqqKNbiRoiLsZuhaS4wRcOcvUYWMkOUNZBF32aVuzSbAYzJetSWdL2GHdEvx8YLeZP9cZNBl+i869Sw=
X-Gm-Message-State: AOJu0Yx8dGE2DEeOl1XZzKaLlcaXE11iD4pV7qQhtBMaxMNwFdf/9fp9
	g1tx0IWKIvnQfEc9IrQJ/s/xiqUWlw8vHD+/7auVCFfUK+kpl+hAsLNB6nl6/2RlySlgJ+XEcyR
	9MSvGouqxWaPza092wVSphuPpJPE=
X-Google-Smtp-Source: AGHT+IFRZogsDVsrgxjCseMwMbjKKu0I9OC6QXd4aY+eeDC6WiwXWQmzxd5nOf9c74Ozjdd2Wf63ZDiiaUK+ZI1oCJA=
X-Received: by 2002:a05:6512:78e:b0:513:28c9:a653 with SMTP id
 x14-20020a056512078e00b0051328c9a653mr1818924lfr.31.1709332095681; Fri, 01
 Mar 2024 14:28:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240301152128.13465-1-xni@redhat.com>
In-Reply-To: <20240301152128.13465-1-xni@redhat.com>
From: Song Liu <song@kernel.org>
Date: Fri, 1 Mar 2024 14:28:03 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6ywzQ9oXUHt=2MN6kngWCvtGxOPffnzV=OHDs_01RGLg@mail.gmail.com>
Message-ID: <CAPhsuW6ywzQ9oXUHt=2MN6kngWCvtGxOPffnzV=OHDs_01RGLg@mail.gmail.com>
Subject: Re: [PATCH V2 0/4] Fix dmraid regression bugs
To: Xiao Ni <xni@redhat.com>
Cc: yukuai1@huaweicloud.com, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 7:21=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
>
> Hi all
>
> This patch set tries to fix dmraid regression problems we face
> recently. This patch is based on song's md-6.8 branch.
>
> This patch set has four patches. The first two patches revert two patches=
.
> The third one and the fourth one resolve deadlock problems.
>
> I have run lvm2 regression test 5 times. There are 4 failed cases:
> shell/dmsetup-integrity-keys.sh
> shell/lvresize-fs-crypt.sh
> shell/pvck-dump.sh
> shell/select-report.sh
>
> And lvconvert-raid-reshape.sh can fail sometimes. But it fails in 6.6
> kernel too. So it can return back to the same state with 6.6 kernel.
>
> V2:
> It doesn't revert commit 82ec0ae59d02
> ("md: Make sure md_do_sync() will set MD_RECOVERY_DONE")
> It doesn't clear MD_RECOVERY_WAIT before stopping dmraid
> Re-write patch01 comment

Unfortunately, I am still seeing the same deadlock in the reboot tests
with two arrays. OTOH, Yu Kuai's version doesn't have this issue.
I think we will ship that patch set.

Thanks for your kind work on this issue.
Song
