Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86AF20468D
	for <dm-devel@lists.linux.dev>; Wed,  8 Jan 2025 21:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736372554; cv=none; b=pgZBRp+D0E3xD1h2zjRf53nTceWuGdBROucKBImM9wt4dH8Kz29i6BM8bu7PXMPS549dJjXZjwBBCUGXlFDFqsY0JKR3UIyeCH113co1e3GMY7MTD2PRd40AMRD43CsXm7VAugOS4dMnrvLTvTkeJ8sAI787hcnYT0V/eL7X0XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736372554; c=relaxed/simple;
	bh=2/9QPvvBz7POwME1Hd4uKUCe2hOLul+pMgpdZLIaqTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Caw5mq074H4awEGqKIe7CmWKyaxMdlFXCjMqQxIQEg2o+K4yWnsN39vYGjMYUjnZYSE3AwTDniOu23sHEIJqQNCyL9OuwBoNuJEUF9njjs0rBPilQheyz/JTNM5oONhY8pDOPmR1wX7QhpE4Li/F9L9khjIXc+ocpMUvdY9IYPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSWEj422; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSWEj422"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C579CC4CEDF
	for <dm-devel@lists.linux.dev>; Wed,  8 Jan 2025 21:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736372553;
	bh=2/9QPvvBz7POwME1Hd4uKUCe2hOLul+pMgpdZLIaqTY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BSWEj422DNgDMNb4SL0AGCXko/j/lBs0mr8PKXMI2P6P86mENJO6gfn0d38Gphghx
	 DOc2dkhQuAF2y8XZSQtX/I9r1lx+CooIyBfOc1Ibqhocv4FuYRx7de3hbewEMLcJrN
	 y6dF0YsLPto5t01tF0h6ekChQ0B/UYMXAuQuQbF2hscR3bjDQRnzytADt8FaMpkQlQ
	 E5JHWQbK20C/FJvXVvC+IlJ7bqx2atYhsyjuTXV+cUHKtS62nv54+tyAdF/rTZ93Fh
	 Vn+crjSeDNy5zG2+7mCib1n3rEGjhaHkL1xfoKtqKiYkwntPp7dGVhgTaBq87gpEIk
	 uaWT5NS9WrUUA==
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-844d7f81dd1so8315339f.2
        for <dm-devel@lists.linux.dev>; Wed, 08 Jan 2025 13:42:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVKJa/9WNAknF6/lPA5/fbQcPieGkVXarcc9TC6FhdtrQfAKNh2LwhVYAJoPlqeHZlIaJNUeTfrkg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxCa3PtxPY/gMEkq7DGTkASsOwSaWF8ZS4XRkV5u+oZK3KVZwpU
	kYHFZhALYr5r8LBt7FzJWE/ClmDi0e1QGAhquS2xZhdy6Z5J9tTPUC88xaRTFbBrEeY9Nc/uUdm
	c1fuuHXjT/ubTOgiUW7aK5YWumrY=
X-Google-Smtp-Source: AGHT+IHzn254rHN4N7IYEuQcNqXfmjCvz+XIBQ8WgFxl/pWkI609Ni0dnrzqU2ADAVkTL1ZAlGR2bktqfbksGbyxvS4=
X-Received: by 2002:a05:6e02:3f09:b0:3ce:473d:9cb6 with SMTP id
 e9e14a558f8ab-3ce473d9f96mr8446715ab.4.1736372553135; Wed, 08 Jan 2025
 13:42:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250102112841.1227111-1-yukuai1@huaweicloud.com>
 <Z31jQT4Fwba4HJKW@kernel.org> <13a377d4-f647-436a-806e-c05413cef837@gmail.com>
 <CAPhsuW5F94zauhvMd79VX0=JsFAY6S-0FJTK6Aqsr++UaDfy_g@mail.gmail.com> <Z36kQW-sNdketOGL@kernel.org>
In-Reply-To: <Z36kQW-sNdketOGL@kernel.org>
From: Song Liu <song@kernel.org>
Date: Wed, 8 Jan 2025 13:42:22 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6iNyTMaAVB037nWKEfUqSJAHfU82=yT6qHhZQdbZxTQQ@mail.gmail.com>
X-Gm-Features: AbW1kvYYrpYee-oCevMv80R2mrF9hECHfRZkDTanQb5ORtbnbKjxhsIX2Ofo5XU
Message-ID: <CAPhsuW6iNyTMaAVB037nWKEfUqSJAHfU82=yT6qHhZQdbZxTQQ@mail.gmail.com>
Subject: Re: [PATCH RFC md-6.14] md: reintroduce md-linear
To: Mike Snitzer <snitzer@kernel.org>
Cc: RIc Wheeler <ricwheeler@gmail.com>, Yu Kuai <yukuai1@huaweicloud.com>, yukuai3@huawei.com, 
	thetanix@gmail.com, colyli@suse.de, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	dm-devel@lists.linux.dev, axboe@kernel.dk, linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 8:13=E2=80=AFAM Mike Snitzer <snitzer@kernel.org> wr=
ote:
>
> On Tue, Jan 07, 2025 at 03:09:00PM -0800, Song Liu wrote:
> > On Tue, Jan 7, 2025 at 12:34=E2=80=AFPM RIc Wheeler <ricwheeler@gmail.c=
om> wrote:
[...]
> >
> > It appears to me that the path doesn't apply cleanly on the md-6.14
> > branch:
> >
> > Applying: md: reintroduce md-linear
> > error: patch failed: drivers/md/Makefile:29
> > error: drivers/md/Makefile: patch does not apply
> > Patch failed at 0001 md: reintroduce md-linear
> > hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
> > When you have resolved this problem, run "git am --continue".
> > If you prefer to skip this patch, run "git am --skip" instead.
> > To restore the original branch and stop patching, run "git am --abort".
> >
> > Please rebase and resend the patch.
> >
> > Thanks,
> > Song
>
> Um, sorry but waiting for a resubmission of a revert due to Makefile
> difference is a needless stall.  You'd do well to fixup the Makefile,
> compile test and also review for any intervening MD (or other kernel)
> API changes since the code was removed from the tree.

OK. Fixed Makefile and applied to md-6.14.

Thanks,
Song
