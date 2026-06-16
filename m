Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9D244CAF9;
	Tue, 16 Jun 2026 15:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625321; cv=none; b=DzEhSJaWwclsR7QaGl5tkvpCwbkBiK+M9RCnrzOIJPeCtXG3amy90FPZ/7CAcLLSvAygwWgoila01oG7a8WUGwlvsO2d5zKdMUaBj52xWaVYvZQXGWtjJqeBUzcJkK1B+BqSQ3TOkF/2eWw6L6KClLkw+Dbxi0gNkXXqZjxO2R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625321; c=relaxed/simple;
	bh=YLbyZnveNFEwkF2a6dnkpPOuXUTyKCGvx8xycPn/Vg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HwTm3kX9NU24n3S0eh4i4M040jJpQ9fDWazNbYjXEvqtGLaFfLDk7/UBOYXKzU2N51J4ppWbT4B9ylfM9z2dl7L9OtUoPsUrvU915nfOOeuHraL6ejc1kDOwkGG9FXX0dzvKAENAxDRwuAGbwkzQHzu0iKzsEI1e/TCwrYNC+ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=kr8TJXvM; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="kr8TJXvM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=yRIX2AOrE2SZskeh2cCmVhiu01x2DMlBcOnVXRxpeJk=; b=kr8TJXvMPeIC5eQm
	zQ5PgMDjeYwCA/t/r0qGSEJuA6XpymgBrms3mahPqBBdz1uAUYz4BpDzzZ22IUldfwNzlK+iDzUpn
	5gWHKoamFLXIjbd8yXZTV2PXnL0UIC4BWXSgNSa621dMZWn82smCxg1fqaX5G44VDz8gIem2D0qLz
	cfqLBoEYGC40ArfXbKDkCM0EuEj5vx4mW/onyjgoVqc6QMUVzTXH2yTq/J5ZfMLKUcUrm10fzZqA7
	3QAzQGEUvNqs1WBgSRFOtFgx9geJu4EGfG928nrFlccAYkl2sfPLTjE6i+sCe5nIsUwGA3e5SWRqU
	10OP+vlT+rs9PeIT6Q==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1wZW8B-000000085w4-3Mry;
	Tue, 16 Jun 2026 15:55:15 +0000
Date: Tue, 16 Jun 2026 15:55:15 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Keith Busch <kbusch@kernel.org>
Cc: zkabelac@redhat.com, Vjaceslavs Klimovs <vklimovs@gmail.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>, trnka@scm.com,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
Message-ID: <ajFx4zh7hgEn0EZS@gallifrey>
References: <ai7rnH20IYeSmY8s@gallifrey>
 <165d3195-c81d-4760-870b-23a9a3b3b72c@leemhuis.info>
 <ai_1LYtofh1fwD-N@gallifrey>
 <CAC_j7i0eDccVWzPeRafM50mZEOFHPz2cwd=RZqqx6TK2EVRFvw@mail.gmail.com>
 <ajCTaUaACV9eNmWo@kbusch-mbp>
 <ajFISH9bvyWjLOM6@gallifrey>
 <ajFK5NXkxd6jU5zu@gallifrey>
 <ajFbglSvcLrFH8Z-@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <ajFbglSvcLrFH8Z-@kbusch-mbp>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.88+deb13-amd64 (x86_64)
X-Uptime: 15:54:33 up 31 days, 19:07,  2 users,  load average: 0.23, 0.11,
 0.02
User-Agent: Mutt/2.2.13 (2024-03-09)

* Keith Busch (kbusch@kernel.org) wrote:
> On Tue, Jun 16, 2026 at 01:08:52PM +0000, Dr. David Alan Gilbert wrote:
> > ( lvcreate  -m 1 -L 1G main /dev/sda2 /dev/sdb2 ) rather than
> > the old mirror with the same patch, then:
> > 
> >   a) I get no log errors with either read or write
> >   b) read still gives EIO
> 
> I've a follow up patch to handle the error properly. You want to see
> EINVAL, not EIO, and that error shouldn't be considered for determining
> the raid health. Something like what f7b24c7b41f23b5 does, but it's a
> little more complicated in this path since it doesn't see the lower
> level error status and just converts everything to EIO.

OK, thanks for your help, and I'll be happy to test that when it's done.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
