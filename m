Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9FA1DB933
	for <dm-devel@lists.linux.dev>; Sun, 23 Mar 2025 06:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742711331; cv=none; b=RsF2yvKDPUfZaw5YY8Jf4UkZhiQAzrvFHhjH8VAej4v2n2oyIEuoDTBjjV0wLJl4z+gAFhUp7OMHfQAR2/pwUq8Wp2blW0TIWq4IjubB9Cl9JeMkfSjP/97BlEg70UB7yCrExZs4zPsdNU9a5sWtuRVnlo0FzppQpYQTCTuyAxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742711331; c=relaxed/simple;
	bh=eNzYKDyg4tx3rs/SKQW6IS88UUw917U8STmq6WUgxRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E6ZXFvTyaZ73jC1L8aQyuJCFX6mHIu7YchVl1iHcZSavAAJ8Bnm5+PzWi6L4vvz+rLC2e0MAFm1Ke7Ii0WJ5ls2I4ASIcnbfIga3IyiLAaK5BMMiTgQwr5UrOCkmL058AopgSUHraoRZt3Z9O+awG+V+bbZWcEsrUjDoUiYSubs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2802967373; Sun, 23 Mar 2025 07:28:38 +0100 (CET)
Date: Sun, 23 Mar 2025 07:28:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, snitzer@kernel.org, mpatocka@redhat.com,
	dm-devel@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] dm-delay: support zoned devices
Message-ID: <20250323062837.GA30617@lst.de>
References: <20250321071816.1674943-1-hch@lst.de> <Z92naQRO2DrpMnXE@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z92naQRO2DrpMnXE@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 21, 2025 at 01:52:41PM -0400, Benjamin Marzinski wrote:
> On Fri, Mar 21, 2025 at 08:18:16AM +0100, Christoph Hellwig wrote:
> > Add support for zoned device by passing through report_zoned to the
> > underlying read device.
> > 
> > This is required to make enable xfstests xfs/311 on zoned devices.
> 
> On suspend, delay_presuspend() stops delaying and it doesn't guarantee
> that new bios coming in will always be submitted after the delayed bios
> it is flushing. That can mess things up for zoned devices. I didn't
> check if that matters for the specific test. Setting
> 
> ti->emulate_zone_append = true;
> 
> would enforce write ordering, at the expense of adding a whole other
> layer of delays to zoned dm-delay devices. Since this isn't really
> useful outside of testing, I think that could be acceptable if necessary
> (it would require us to support table reloads of zoned devices with
> emulated zone append, since tests often want to change the delay).
> However it would probably be better to see if we can just make dm-delay
> preserve write ordering during a suspend.

My use case is all about using zone append, so emulating it would be
a bit counter productive, but I'll give it a spin.  I doubt that this
test is very timing critical.

