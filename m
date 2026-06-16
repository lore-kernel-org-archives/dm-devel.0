Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D133314C3;
	Tue, 16 Jun 2026 14:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781619589; cv=none; b=EPIA4ewcBgQd+Q1ffvcPL44tCZii9ww+8+MMxQt2zGqipdMSXwKdaK+gLlyre4HxLvdZddSNRGPsi7mhe0MvXtEdi84F0qhzH20k9s885rfVv2IZr1O8Ah8TEwxHDScl1NQ9Ta56PQflNmLvmtYSwMazEijADWXWwgIYL31PRzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781619589; c=relaxed/simple;
	bh=gS3vka/h+7Rh9dfsayzDWPRVFUNOQ8QqcSRFbGAXhLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kA612eigrH3s5L8ytmgV0a5HcUj6ipwXJCllCyVGcpBb5O12ZiTvzOgksBgEL+t+vPUYWIIICmjaRDETOAUpiZoRLcdEmInqDJNl6RC7JfNbzLZZvxjaG+/nQLVqJFtyS4LDv9dQLO+DB4DaePIhfDmQUYkFp6buysdr4TO40Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gf58Pvxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gf58Pvxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4271F000E9;
	Tue, 16 Jun 2026 14:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781619588;
	bh=Jvdm53hImTQZkhDZASRZH4W+Gs4s6DyQuut1fvAE+Mw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gf58PvxgCcO0IpfgLSXyEFzkVVBjLP/HslhwqoMXNbt43iCRgV7xXzGjp7BtWtGAo
	 oqzvli2v8DfAkimA/v8axQTHvvGssZQXzlL2wU3z+ajx2DFoFoqOIHR6wPF2/NcFei
	 ka0unH4Z4g16az0aSEhaZGc2Dy2k2l1SMnE/XkZtuhk1o10hUft/6AFbZb+j/J5FDu
	 cul35JUtWMvhCXt8xFHX8upFPobAu4YGpJEf9/LriuSGoPVi/PEJxqQ/U70F8jeHpb
	 pJcQFhMuF9qa8XYoAWEE3EHPnxzZm68+S2OTbp7Szi51Ck0S3fQfbKbNLrGn8BTaqs
	 pJ02cUEg5FI3A==
Date: Tue, 16 Jun 2026 08:19:46 -0600
From: Keith Busch <kbusch@kernel.org>
To: "Dr. David Alan Gilbert" <dave@treblig.org>
Cc: zkabelac@redhat.com, Vjaceslavs Klimovs <vklimovs@gmail.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>, trnka@scm.com,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
Message-ID: <ajFbglSvcLrFH8Z-@kbusch-mbp>
References: <ai7rnH20IYeSmY8s@gallifrey>
 <165d3195-c81d-4760-870b-23a9a3b3b72c@leemhuis.info>
 <ai_1LYtofh1fwD-N@gallifrey>
 <CAC_j7i0eDccVWzPeRafM50mZEOFHPz2cwd=RZqqx6TK2EVRFvw@mail.gmail.com>
 <ajCTaUaACV9eNmWo@kbusch-mbp>
 <ajFISH9bvyWjLOM6@gallifrey>
 <ajFK5NXkxd6jU5zu@gallifrey>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajFK5NXkxd6jU5zu@gallifrey>

On Tue, Jun 16, 2026 at 01:08:52PM +0000, Dr. David Alan Gilbert wrote:
> ( lvcreate  -m 1 -L 1G main /dev/sda2 /dev/sdb2 ) rather than
> the old mirror with the same patch, then:
> 
>   a) I get no log errors with either read or write
>   b) read still gives EIO

I've a follow up patch to handle the error properly. You want to see
EINVAL, not EIO, and that error shouldn't be considered for determining
the raid health. Something like what f7b24c7b41f23b5 does, but it's a
little more complicated in this path since it doesn't see the lower
level error status and just converts everything to EIO.
