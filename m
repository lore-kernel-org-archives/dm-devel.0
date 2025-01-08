Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AFA17E900;
	Wed,  8 Jan 2025 16:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736352835; cv=none; b=cHZRg27ece8G4eVAFnz+DQub91nU/rz769MY/dMlXzBeKEtFQKkwXItHXjMh2K3pX57nLUQXO2u4lzKZniMv9fLwFWyuTr8Pa9Ak+iunkUz1oWRjNYumJ4dt8c8itp+nqOcEdc2kfSDCa75zZ8OmB4Z7xpEJMlM4OI8tuIHs8Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736352835; c=relaxed/simple;
	bh=tgQXwbQNCWDvMOpzVJxKStfpnMBkUIZICYWlSl3GgsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G0ICS/YfJvnnlr3DdwgdqP7pbLKMjn0EGf3//FiD9kHIOotBDKv0yLqKrGxdVzQbwLjrMxq/1L7kDhuJTdUX8gfhb6kE1XvW6/tTPi4iGLXVH6VFdfSnrI49IzeMY+An2GL4Fflj29iVpF/XS5poc4orCgaVKou2z5p9is0CZQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RsUtbT9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RsUtbT9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CABEC4CED3;
	Wed,  8 Jan 2025 16:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736352834;
	bh=tgQXwbQNCWDvMOpzVJxKStfpnMBkUIZICYWlSl3GgsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RsUtbT9Lju55GMfOPtac7Xh97HnJoAH/eUQwCjlz73ILzTJCkI5vyIHdwLPfuDTmd
	 KapwkxRoP+dCvdMaLmN2/jnA3NvOUc1lqXGNR653xQTmo8G18sw7qoeCJqLRJG5qT8
	 lVuTeRoEnskWKMS0K7QdgSvJs6b46vVo9WhbRAFisavnmyiGv+PK97KrEHPHs9J76O
	 1XvhswWMApAhBskrVnIrL6LJafv7tSwz6c7BHZJRtRxWa824oM4EtNBgL3hz6WK21t
	 lIXI6rETaiVVq1bp+GxT+TBV9rboUOJ/N5mSRgf1IR2U25tFyMTRRjuSpVuvy52thz
	 73PDaEoqMewnA==
Date: Wed, 8 Jan 2025 11:13:53 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Song Liu <song@kernel.org>
Cc: RIc Wheeler <ricwheeler@gmail.com>, Yu Kuai <yukuai1@huaweicloud.com>,
	yukuai3@huawei.com, thetanix@gmail.com, colyli@suse.de,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, dm-devel@lists.linux.dev,
	axboe@kernel.dk, linux-block@vger.kernel.org
Subject: Re: [PATCH RFC md-6.14] md: reintroduce md-linear
Message-ID: <Z36kQW-sNdketOGL@kernel.org>
References: <20250102112841.1227111-1-yukuai1@huaweicloud.com>
 <Z31jQT4Fwba4HJKW@kernel.org>
 <13a377d4-f647-436a-806e-c05413cef837@gmail.com>
 <CAPhsuW5F94zauhvMd79VX0=JsFAY6S-0FJTK6Aqsr++UaDfy_g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW5F94zauhvMd79VX0=JsFAY6S-0FJTK6Aqsr++UaDfy_g@mail.gmail.com>

On Tue, Jan 07, 2025 at 03:09:00PM -0800, Song Liu wrote:
> On Tue, Jan 7, 2025 at 12:34 PM RIc Wheeler <ricwheeler@gmail.com> wrote:
> >
> >
> > On 1/7/25 12:24 PM, Mike Snitzer wrote:
> > > On Thu, Jan 02, 2025 at 07:28:41PM +0800, Yu Kuai wrote:
> > >> From: Yu Kuai <yukuai3@huawei.com>
> > >>
> > >> THe md-linear is removed by commit 849d18e27be9 ("md: Remove deprecated
> > >> CONFIG_MD_LINEAR") because it has been marked as deprecated for a long
> > >> time.
> > >>
> > >> However, md-linear is used widely for underlying disks with different size,
> > >> sadly we didn't know this until now, and it's true useful to create
> > >> partitions and assemble multiple raid and then append one to the other.
> > >>
> > >> People have to use dm-linear in this case now, however, they will prefer
> > >> to minimize the number of involved modules.
> > >>
> > >> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> > > I agree with reinstating md-linear.  If/when we do remove md-linear
> > > (again) we first need a seamless upgrade/conversion option (e.g. mdadm
> > > updated to use dm-linear in the backend instead of md-linear).
> >
> >
> > Agree with the need for an upgrade/conversion path.
> >
> > >
> > > This patch's header should probably also have this Fixes tag (unclear
> > > if linux-stable would pick it up but it really is a regression given
> > > there was no upgrade path offered to md-linear users):
> > >
> > > Fixes: 849d18e27be9 md: Remove deprecated CONFIG_MD_LINEAR
> > >
> > > Acked-by: Mike Snitzer <snitzer@kernel.org>
> 
> Thanks all for feedback on this move. I agree that reinstating
> md-linear is the right move for now.
> 
> Yu Kuai,
> 
> It appears to me that the path doesn't apply cleanly on the md-6.14
> branch:
> 
> Applying: md: reintroduce md-linear
> error: patch failed: drivers/md/Makefile:29
> error: drivers/md/Makefile: patch does not apply
> Patch failed at 0001 md: reintroduce md-linear
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
> 
> Please rebase and resend the patch.
> 
> Thanks,
> Song

Um, sorry but waiting for a resubmission of a revert due to Makefile
difference is a needless stall.  You'd do well to fixup the Makefile,
compile test and also review for any intervening MD (or other kernel)
API changes since the code was removed from the tree.

Mike
