Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A6FBE68
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 03:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708660752; cv=none; b=KSmfA6cFoohV2iU8Llwee3yleqI7swe03rvU+7uz4LsCKTTjzXcTUpNuB9ZzK8G5i1IlW6h0DZDJv9YMh2NcvtxJwc8Y+tLKdPM9kcgjeMIw/dQj4rcBtZVWpHn212kufEX8gIe9jY3Mk1b566BhxmGMy63jYG2e3ESVnPu47bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708660752; c=relaxed/simple;
	bh=T52v1gFXjr/SCM0pxlczTZKrrkehUvxbGkho5cYQZJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o5daqKEPRvNFQE3WyIILO6dg/eLz3cqiCEDEqXCu1lgFxzlnn2Nloj9HQ28Qbg9vMy9Jxf8fE6LZhVCSyeIxxzQlyDHXebIt9tXh4BXZcdI4Dy+VX2elbAgdm1tSBJoivdNv/uRcu8wF6OKFGZXEOKG0DXfUvDWGzQ8diH8HM6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dAvwBL2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dAvwBL2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BBEC43390
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 03:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708660751;
	bh=T52v1gFXjr/SCM0pxlczTZKrrkehUvxbGkho5cYQZJo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dAvwBL2fAW5adtmJAOHU5S7MYLi94l0xoULsFr/pbakXoLVtKmqbIQn9dzyWIvkwF
	 PlTLaCutuIPZNPRhWfDUjmJp0L+qi8RO9Ayah/+9u0gFPQeiKcjNVTTUq63JOvGQAF
	 8ql/O5ybpxFFOCKz3cYn4F1etLen3qaegNgcBl4gAZ1lNL9vaoO+TYIL38Ydg/I1Hr
	 SYb1BPwBtLUGm+m4JNc5Fxmd1zpbKDX6F03cY5SpOG6Px8bBTXvNHMCMoJ2V8qq0N7
	 d1rNQeeobU6n91xnHaOFjkCd3WG9UP2CpnE9iXKH9qRzEWRW9HVGC+zguBSNSnfev3
	 d5LZnML0fKfGA==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-512e01b3da3so619181e87.3
        for <dm-devel@lists.linux.dev>; Thu, 22 Feb 2024 19:59:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW9lDoCmuJT572fGnkxh3jmuBjcpRLVaCiMaJ5gytXcCZhZMnqjAGmYJWDiRpLnQbgZhN6UcVLZ5K45YUd5kLqwyhIoYpmv92o=
X-Gm-Message-State: AOJu0Yy3yRZEFz6J4HYrPqXdTqFxKwGCY0Guj6CilyjQYMh9SEyvv3uC
	b+Iz7eQm88ff7mvwo+LWWrA3Oc1/MEXoknKH7F4KY8ctVbiuxcjptv+3DxDvrbYPbwYRbYZVRn+
	kZXpbEem4lRPTAJ0Fqi4pFITSacI=
X-Google-Smtp-Source: AGHT+IGRuAPK9HnaSMSrWjdUGHyYJBCv+IQzakjQt1aSRqRTRIqpjdgK95yw+Z0JTVUZkSJ/1qYCQHExYGaaXWSsqhs=
X-Received: by 2002:ac2:4d03:0:b0:512:d251:afcd with SMTP id
 r3-20020ac24d03000000b00512d251afcdmr574582lfi.27.1708660749856; Thu, 22 Feb
 2024 19:59:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240220153059.11233-1-xni@redhat.com> <20240220153059.11233-3-xni@redhat.com>
 <4370dfd7-61ac-51e4-6ff5-1eb18ac4c1f1@huaweicloud.com>
In-Reply-To: <4370dfd7-61ac-51e4-6ff5-1eb18ac4c1f1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 22 Feb 2024 19:58:58 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6ALag3ONMMk29MGohjh32xGG+BsZgc0Q6QWno7rSfXvQ@mail.gmail.com>
Message-ID: <CAPhsuW6ALag3ONMMk29MGohjh32xGG+BsZgc0Q6QWno7rSfXvQ@mail.gmail.com>
Subject: Re: [PATCH RFC 2/4] md: Set MD_RECOVERY_FROZEN before stop sync thread
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Xiao Ni <xni@redhat.com>, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, neilb@suse.de, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 7:12=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/02/20 23:30, Xiao Ni =E5=86=99=E9=81=93:
> > After patch commit f52f5c71f3d4b ("md: fix stopping sync thread"), dmra=
id
> > stops sync thread asynchronously. The calling process is:
> > dev_remove->dm_destroy->__dm_destroy->raid_postsuspend->raid_dtr
> >
> > raid_postsuspend does two jobs. First, it stops sync thread. Then it
> > suspend array. Now it can stop sync thread successfully. But it doesn't
> > set MD_RECOVERY_FROZEN. It's introduced by patch f52f5c71f3d4b. So afte=
r
> > raid_postsuspend, the sync thread starts again. raid_dtr can't stop the
> > sync thread because the array is already suspended.
> >
> > This can be reproduced easily by those commands:
> > while [ 1 ]; do
> > vgcreate test_vg /dev/loop0 /dev/loop1
> > lvcreate --type raid1 -L 400M -m 1 -n test_lv test_vg
> > lvchange -an test_vg
> > vgremove test_vg -ff
> > done
> >
> > Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
> > Signed-off-by: Xiao Ni <xni@redhat.com>
>
> I agree with this change, but this patch is part of my patch in the
> other thread:
>
> dm-raid: really frozen sync_thread during suspend
>
> I still think that fix found problems completely is better, however,
> we'll let Song to make decision.

I think we still need more time (and maybe more iterations) for the
other thread, so we can ship this change sooner. We should add
SoB Kuai here.

Thanks,
Song
