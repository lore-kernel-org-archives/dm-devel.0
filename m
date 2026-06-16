Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B0D44CF40;
	Tue, 16 Jun 2026 16:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625932; cv=none; b=ISkwgXhx32+Q7/pKwjj84rcsY0ILL8EF77OyQ5R2yLKuShILNP6frMfZNIlnctkN2Tb2plwRBdZbJcfzF7xC9m2SKak1qgjnydlhlKaiIcJHSDdof24CcCE4ZBdAY8UL5f05VshSJTrzyqY3KLH92ggC7y5ruDxIN3UBmqMuFcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625932; c=relaxed/simple;
	bh=j4e1UJbbBdkvDRPx1SxYYPWcJU7qi9rMTxzzTH55B4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k4k+ZpLSdOG5gBvd1NixBuCgl/hVw2sEoMV8NhkEU5LNC74NkqoWSOK5EMOtalaooeDt4T/hzwARI1NcMqhM7sJk8dONmChplmCd2WdTyX31YvEXFZ4wjEUx8gAcfy6zre0QIy3+wrySGjjGx+XQ28cKepeieZr/T/8qo1NpSvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bdNxomF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bdNxomF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23F11F00A3D;
	Tue, 16 Jun 2026 16:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781625931;
	bh=W2Do2yEMsC7S8MrZXXMzMyoWOiK/Gw8M730UD/r4reo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bdNxomF6joc/VkuAt8ABnnXI6dyqlsq2yGqMhE2krwzfRytqZ0TOZ6zIAfm6c65jB
	 lUmih/mUu0w5Pa0TYPHVNmO9VtMjy+nCypKGXCeazf+HTRFIAkgtrSCkvgCnxmlfT9
	 0bbnQX0AqofKPilOtPOexjuSucSQbXpxOTtbHrjn3KeI9REmWVFS+ingK65/gBPxGJ
	 ocE1ZPAumfUPwpve2Kz9QaeJrGsyMbVC/K/+ZOnf5trO85ygeXQyxoDkFAb/tnclq6
	 eApsNS2hP4app1beexo7H2S8EM4GDkysHJ2I3B0H6O8mgdjGNPlQH/t2zcLZU4oBIY
	 npe2nvVYbEhxA==
Date: Tue, 16 Jun 2026 10:05:29 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Vjaceslavs Klimovs <vklimovs@gmail.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Thorsten Leemhuis <regressions@leemhuis.info>, trnka@scm.com,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
Message-ID: <ajF0Sc8AveHoiVBs@kbusch-mbp>
References: <ai7rnH20IYeSmY8s@gallifrey>
 <165d3195-c81d-4760-870b-23a9a3b3b72c@leemhuis.info>
 <ai_1LYtofh1fwD-N@gallifrey>
 <CAC_j7i0eDccVWzPeRafM50mZEOFHPz2cwd=RZqqx6TK2EVRFvw@mail.gmail.com>
 <27311df3-2c46-08be-825a-157ea906bdb2@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27311df3-2c46-08be-825a-157ea906bdb2@redhat.com>

On Tue, Jun 16, 2026 at 05:55:13PM +0200, Mikulas Patocka wrote:
> I thought that reverting 5ff3f74e145a and re-introducing the alignment 
> check in block/fops.c:blkdev_dio_invalid would fix it - but it wouldn't.
> 
> The same problem existed even before 5ff3f74e145a, with the pvmove 
> command.

Also before 5ff3f74e145a, you could still have devices that are
perfectly fine with dword aligned dma, so sub-sector vectors  would have
passed the checks and gone through to dm-raid, which would have
miscounted the remaining.
 
> So, I think that the proper way to fix this is to teach dm-mirror/dm-io to 
> deal with unaligned bio vectors and handle them properly.

The block layer already handles it, so I think just dispatch it and
check the bi_status is all the stacking drivers need to do.
