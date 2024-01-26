Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44E517E
	for <dm-devel@lists.linux.dev>; Fri, 26 Jan 2024 00:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706228072; cv=none; b=K1WDjI0PRc21Q7bC/dkp/Sk0j6G/avHtk8Z7y7uamKRaokQxHPNbrufETAasmM0AeuyvKPGpHJOuWbbYh+Nr/qyGomMmjJWbCKdu146KB2cFbcDPRS0E7Kov1I9XyTbF15lQf9LAnK6CJ8lLMPZUQNLAD3JKG1qBHasuXiHc2q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706228072; c=relaxed/simple;
	bh=Qm9TZuL9HTa2j4FLC1XOdPmC6N+VcY2tavBjeFAxuxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FAePitCgCYiuojcahOp7SzU/2sR6QvIhwW6HB1PxkPJuchmNRnqanmksOla2QnS6Yaqga/LdfMHpTZ69BF7xLVWd9L6HhlnTCqwSdU9x8ch0wllA67CP23x+T+VtdCud3PRJ4JFuLdQuxiN3nQnEKD+xqjdvNHT/w7lIRDFSX2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCEcaTNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCEcaTNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B574C433A6
	for <dm-devel@lists.linux.dev>; Fri, 26 Jan 2024 00:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706228072;
	bh=Qm9TZuL9HTa2j4FLC1XOdPmC6N+VcY2tavBjeFAxuxM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eCEcaTNXiNSoEbAtz/bVrD+OPWQMdE8uaZ2TlIpTbOwFiQpLtLJLR54n5zKLQNlUi
	 SIO9KpHd1ukJQQKlt+k56I1yu8RFvzvLhLQ8JfiCRxLOv7sP4w6FgkeUwBG9COMoXb
	 0RMbAw5yObcGhcoIat1xX4W84AqswkumhvPb5u7/PVx9rPXGdh3qPAOY1ZCcTIR604
	 B6Loc6VuXEd6+RbyUcuMgUh750oxVHnRVlwMLQAQMEt0/WbiKmryDoeKcZhJdBcbT4
	 vbgfZXYm99Hj3ihk6XIiAHgE4aklieGb6fIjJGzU2OWRztUy0C2BJyi8nYSlY1IT59
	 9Cye0cSAZI40A==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-51020e061b5so1024447e87.1
        for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 16:14:32 -0800 (PST)
X-Gm-Message-State: AOJu0YzWpJBDIOmokIJ7v/3NWcggDmM6x9kwIu4xEzi3TXh0NuOuISfO
	hQlldGTq4zbZ2//keu/V3NdWfWBND8GVYjNQ86aUYVdTbkE7UWBZ+K5V/uzJzpInqHNV5yGCU6Z
	+1MkVUBqWK9jvIgH7PHfi+dbd9ZA=
X-Google-Smtp-Source: AGHT+IED9CJWsDJSk49BPkNStrwuc6tSM4rMBKOHwZqetFqvJrPjTD8O/vlKnTlptPI5eCGjFtZBcMGLEwtLw1lUEyY=
X-Received: by 2002:a05:6512:3b2c:b0:50e:36ad:5f6e with SMTP id
 f44-20020a0565123b2c00b0050e36ad5f6emr344390lfv.20.1706228070641; Thu, 25 Jan
 2024 16:14:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240124091421.1261579-1-yukuai3@huawei.com> <20240124091421.1261579-6-yukuai3@huawei.com>
 <CALTww291wiYYMWuqUdDf1t7cKkHFs9gGQSRw+iPhUCsNv-Y6yg@mail.gmail.com>
In-Reply-To: <CALTww291wiYYMWuqUdDf1t7cKkHFs9gGQSRw+iPhUCsNv-Y6yg@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Thu, 25 Jan 2024 16:14:18 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4kauNB8jAsXYjRohCBMDvY15y0CzzWYqzGvNsqAJ59jQ@mail.gmail.com>
Message-ID: <CAPhsuW4kauNB8jAsXYjRohCBMDvY15y0CzzWYqzGvNsqAJ59jQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] md: export helpers to stop sync_thread
To: Xiao Ni <xni@redhat.com>
Cc: Yu Kuai <yukuai3@huawei.com>, agk@redhat.com, snitzer@kernel.org, 
	mpatocka@redhat.com, dm-devel@lists.linux.dev, jbrassow@f14.redhat.com, 
	neilb@suse.de, heinzm@redhat.com, shli@fb.com, akpm@osdl.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Xiao,

On Thu, Jan 25, 2024 at 5:33=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
>
> Hi all
>
> I build the kernel 6.7.0-rc8 with this patch set. The lvm2 regression
> test result:

I believe the patchset is built on top of upstream (6.8-rc1). There are
quite some md and dm changes between 6.7-rc8 and 6.8-rc1. Could
you please rerun the test on top of 6.8-rc1? Once we identify the right
set of fixes, we will see which ones to back port to older kernels.

Thanks,
Song

> ###       failed: [ndev-vanilla] shell/integrity.sh
> ###       failed: [ndev-vanilla] shell/lvchange-partial-raid10.sh
> ###       failed: [ndev-vanilla] shell/lvchange-raid-transient-failures.s=
h
> ###       failed: [ndev-vanilla] shell/lvchange-raid10.sh
> ###       failed: [ndev-vanilla] shell/lvchange-rebuild-raid.sh
> ###       failed: [ndev-vanilla] shell/lvconvert-cache-abort.sh
> ###       failed: [ndev-vanilla] shell/lvconvert-raid-regionsize.sh
> ###       failed: [ndev-vanilla]
> shell/lvconvert-raid-reshape-linear_to_raid6-single-type.sh
> ###       failed: [ndev-vanilla] shell/lvconvert-raid-reshape.sh
> ###       failed: [ndev-vanilla] shell/lvconvert-raid-takeover-alloc-fail=
ure.sh
> ###       failed: [ndev-vanilla] shell/lvconvert-raid-takeover-thin.sh
> ###       failed: [ndev-vanilla] shell/lvconvert-raid-takeover.sh
> ###       failed: [ndev-vanilla] shell/lvconvert-raid0-striped.sh
> ###       failed: [ndev-vanilla] shell/lvconvert-raid0_to_raid10.sh
> ###       failed: [ndev-vanilla] shell/lvconvert-raid10.sh
> ###       failed: [ndev-vanilla] shell/lvconvert-raid5_to_raid10.sh
> ###       failed: [ndev-vanilla] shell/lvconvert-repair-raid.sh
> ###       failed: [ndev-vanilla] shell/lvconvert-striped-raid0.sh
> ###       failed: [ndev-vanilla] shell/lvcreate-large-raid10.sh
> ###       failed: [ndev-vanilla] shell/lvcreate-raid-nosync.sh
> ###       failed: [ndev-vanilla] shell/lvcreate-raid10.sh
> ###       failed: [ndev-vanilla] shell/lvdisplay-raid.sh
> ###       failed: [ndev-vanilla] shell/lvextend-thin-raid.sh
> ###       failed: [ndev-vanilla] shell/lvresize-fs-crypt.sh
> ###       failed: [ndev-vanilla] shell/lvresize-raid.sh
> ###       failed: [ndev-vanilla] shell/lvresize-raid10.sh
> ###       failed: [ndev-vanilla] shell/pvck-dump.sh
> ###       failed: [ndev-vanilla] shell/pvmove-raid-segtypes.sh
> ###       failed: [ndev-vanilla] shell/select-report.sh
