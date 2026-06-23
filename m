Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3463325EF87;
	Tue, 23 Jun 2026 15:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782226803; cv=none; b=GryxsnQrz/xn+ssaR7Wwt7nz294wJkIqtm6+J1VxTXcKHM9QalnanzbOi8IlWsa7NHwTKNZRQhFeSFWnVntutPpCQ5WBegIOsbyftC3IqVHIH0mBnIuoxdG8jgk2eihrTYIUEhjRdvu7QNwRjainXACKtv9XRYsn4GSBmAzP+gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782226803; c=relaxed/simple;
	bh=tBBzyKaVctKF8iGgVRyzyBS0c0PsS2GGrX/eVP1vNSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YO2lCsqhX1PdF4RJB9c44Efm3y2T+DrwgkVlMg6WyRcdVOX3j5cMEuQOt5Ib4fDgXhT5Hwpd3a7MWuT1pS1f4ZFYNVzG8w+N2UIKxs/Cpsy5t7kJCaccXHsyFi/kdYlQkM3euze/xIbBlLtCE7OmMHtnwbvZqXfdaOmqlEkMjts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8T1RY+R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8T1RY+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3612C1F000E9;
	Tue, 23 Jun 2026 15:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782226801;
	bh=CjCHQQ/502Sxsp3Y69VsJyfIUEA9FmJwMKK6z2ZV/BU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U8T1RY+RN+EARxpp8U7lAzzDG05msjzNFw18xKOhEps5b08BpRgun+o+6c0a3VuL9
	 PI5ED/Hh/CmZeg5OWAHS7I9ROAMOu1a3cbJhMEFKF7wcY70cqEHRDjLX/8j5CWb6kX
	 zvhLfBgkkX7ivayVuZfOA+n/utP8q09aiRrNUTwLzdV1zhPU2rHOgnkSUkQ5j4Uk81
	 rMPGxlFE6Ecu2YG4XgpqY6IXSj4tWddVw6uf4mskulGu8sL2grUCr8yUhpMKVNpt1c
	 LdHWcN+oCMcYJ/R3RZE7So626zZ/yJAk8uRBMvVKrEzopOGbDWsokKShIcr1W1ljL2
	 1EiL5CMsucc0Q==
Date: Tue, 23 Jun 2026 08:59:59 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev,
	axboe@kernel.dk, brauner@kernel.org, djwong@kernel.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCHv2 2/6] block: report the actual status
Message-ID: <ajqfb2qfBE7GbU1H@kbusch-mbp>
References: <20260622174241.2299563-1-kbusch@meta.com>
 <20260622174241.2299563-3-kbusch@meta.com>
 <20260623145511.GB13628@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623145511.GB13628@lst.de>

On Tue, Jun 23, 2026 at 04:55:11PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 22, 2026 at 10:42:37AM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Rather than assume EIO, set the actual reported status for user space
> > informational purposes.
> 
> Where "informational purposes" primarily mean not dropping the EINVAL
> for incorrect alignment, right?  

It could be any possible error, but for the practical purposes of this
series, yes, EINVAL is the status I need forwarded. But EFAULT was also
always a real possibility that wouldn't have been reported.
