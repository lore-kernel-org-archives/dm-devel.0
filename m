Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6856F1E492C
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 23:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736291353; cv=none; b=tFNo2xWbGjaNLHydK9fmVI3vi3S3MkDTReZ8laSQLQ3ZCBiQ5smH89TrXhrVcJWTKnrvu+Fk2cF+YnGA9YLloj2KUChx6Tfi1+rFLb80y3CU9lTAYNyYlNtuEU2by2W7dnvwYvVfdvN2TF+HewkxEKYozXOF1zdmWT+IA01gprE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736291353; c=relaxed/simple;
	bh=w1XXgL3jt5Aty8Ttw2N2wfWJmLJOID7g/8HTbnQrFBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S3aNXFZiVm27xa014Soor3GWP2l4RpRGqvpA6mgD9/y5hBKmYdXZiotvn97K/Ls8MJIYzLjs8s4R7TM9BHhGRM8f4QtxndMtZMX158Mi8aUxlyjZv8OaxampMNEDVaPhAGeH7rpuOedmr/bHYoADH0SJMErvkxiFgP6aDCvYkaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=It++wkGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="It++wkGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD25C4CEE3
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 23:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736291352;
	bh=w1XXgL3jt5Aty8Ttw2N2wfWJmLJOID7g/8HTbnQrFBc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=It++wkGWKq6RCQKaDRYWgQ25W8nTUCjZ0H3DBq6KHE13F0ZwtVtlNdSnm9AsZ7R4G
	 qiy+J6fqhKx7FDBmijn6kufrRpMuuDlWnGL0s/DW41v0VdqAhmInEfdMq2v8v/+2Ol
	 7Cm+QgJZGuXvneIB+i46CeUCMdh8i8ZWAFa68tfVo0uwz3HG1k95DQK8hqLN9lNvTP
	 4ZpbOb6Yoz7raXyG/UFrPNC2RJ9WhcFp9eVq0ep2CQY+f1ebvZ5A3wQgj1GAtz/36H
	 eVx6e9pmnTU3MWaetuzvnkHDuz3qq6+NTQ35DnZAPrjV03yqju4ytVhgT56d+xC6YP
	 pERLI1hOvf+rg==
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-844d7f81dd1so692163239f.2
        for <dm-devel@lists.linux.dev>; Tue, 07 Jan 2025 15:09:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUCopOzoOjJpUOnhQtVaHcfyzN3TQCNjLbgWKR26iumkVqdQ94ueFP9r+DoMwAmaTfByj3z5IMSWA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwW57tPgGkMXVD8iDU9xojrViBjPywIEgM4KCQ1aFDeNfLetk8H
	0+KBA0AEnn+Lp0N4pg0wuD82T1JlsM0Lx7N3TMPOLdSi5OEzL6I5qoqxJwGmQQbQ+r3WbYSt+Tj
	QXuziBvNvIMto+zMh52I4u4lC3N4=
X-Google-Smtp-Source: AGHT+IHZbes+RVqxODIqD+R4BFoIkf/Jxq+1478KFPSCKdYBPyv4uwxMwi4pid1uHZW/PkxtfgQFc7y+EgBpRECjmHw=
X-Received: by 2002:a05:6e02:1948:b0:3a7:e4c7:ad18 with SMTP id
 e9e14a558f8ab-3ce3aa540d2mr6595195ab.18.1736291352136; Tue, 07 Jan 2025
 15:09:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250102112841.1227111-1-yukuai1@huaweicloud.com>
 <Z31jQT4Fwba4HJKW@kernel.org> <13a377d4-f647-436a-806e-c05413cef837@gmail.com>
In-Reply-To: <13a377d4-f647-436a-806e-c05413cef837@gmail.com>
From: Song Liu <song@kernel.org>
Date: Tue, 7 Jan 2025 15:09:00 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5F94zauhvMd79VX0=JsFAY6S-0FJTK6Aqsr++UaDfy_g@mail.gmail.com>
X-Gm-Features: AbW1kvYIxAFR2oI5w83WjUcDw6unFqRGpFgs2qL48Zjx_Zo-0LNdEHjtzfJs47w
Message-ID: <CAPhsuW5F94zauhvMd79VX0=JsFAY6S-0FJTK6Aqsr++UaDfy_g@mail.gmail.com>
Subject: Re: [PATCH RFC md-6.14] md: reintroduce md-linear
To: RIc Wheeler <ricwheeler@gmail.com>
Cc: Mike Snitzer <snitzer@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>, yukuai3@huawei.com, 
	thetanix@gmail.com, colyli@suse.de, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	dm-devel@lists.linux.dev, axboe@kernel.dk, linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 7, 2025 at 12:34=E2=80=AFPM RIc Wheeler <ricwheeler@gmail.com> =
wrote:
>
>
> On 1/7/25 12:24 PM, Mike Snitzer wrote:
> > On Thu, Jan 02, 2025 at 07:28:41PM +0800, Yu Kuai wrote:
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> THe md-linear is removed by commit 849d18e27be9 ("md: Remove deprecate=
d
> >> CONFIG_MD_LINEAR") because it has been marked as deprecated for a long
> >> time.
> >>
> >> However, md-linear is used widely for underlying disks with different =
size,
> >> sadly we didn't know this until now, and it's true useful to create
> >> partitions and assemble multiple raid and then append one to the other=
.
> >>
> >> People have to use dm-linear in this case now, however, they will pref=
er
> >> to minimize the number of involved modules.
> >>
> >> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> > I agree with reinstating md-linear.  If/when we do remove md-linear
> > (again) we first need a seamless upgrade/conversion option (e.g. mdadm
> > updated to use dm-linear in the backend instead of md-linear).
>
>
> Agree with the need for an upgrade/conversion path.
>
> >
> > This patch's header should probably also have this Fixes tag (unclear
> > if linux-stable would pick it up but it really is a regression given
> > there was no upgrade path offered to md-linear users):
> >
> > Fixes: 849d18e27be9 md: Remove deprecated CONFIG_MD_LINEAR
> >
> > Acked-by: Mike Snitzer <snitzer@kernel.org>

Thanks all for feedback on this move. I agree that reinstating
md-linear is the right move for now.

Yu Kuai,

It appears to me that the path doesn't apply cleanly on the md-6.14
branch:

Applying: md: reintroduce md-linear
error: patch failed: drivers/md/Makefile:29
error: drivers/md/Makefile: patch does not apply
Patch failed at 0001 md: reintroduce md-linear
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Please rebase and resend the patch.

Thanks,
Song
