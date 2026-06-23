Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D81C19992C;
	Tue, 23 Jun 2026 15:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782227152; cv=none; b=Rmd3/IZL8lE3f7Qexcew3tM0k+0CBFNMPPhf026BKIXV8bHotP/L3enUIzsqNVrlb8lqCtAX97zmJ0tH1sPuvBjVDBd1wHnVbFi74Dy3SISQe0g27MrD92zCjl+zQ6ESErxeBOUQ79RDgmKkViTSouljNb2F/uydsLUnivx2o3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782227152; c=relaxed/simple;
	bh=VQuT+qaaGG+gmpfflkoTVONZ0RJrU/ANKt33NLVpMqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8j6dGYzTdUKVNg/lsl+dhw5ztnq4vEJymhFuz8W7rx01pErLGvkt9lUqH79K5o34K8iX85GSz/XgAtw9GVoaaH89RHCm3BkOmRX7Fdj5HZpxe/0M8PKqwD3sERLrgvJJreCmy2EpI2KbfVCaeFQmrmcEXRbwCU450bIKBeMCPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1PnsGiC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1PnsGiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2D51F000E9;
	Tue, 23 Jun 2026 15:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782227151;
	bh=dmzV5CEtjPPx+gb5g9qrUntLOQbsNqzVXHPb5Ly3i7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T1PnsGiCbNejDCfF7tb3R8tUM31DgMmvPDkvJXNVo8hxnAkzQM7eNHE6H7mzb6fvQ
	 4Gr5JGZwmVDHl4LcKqcqasJQZHGOWN4mCW8OEqGa45geMntiDxUSUFuuDXf9DNWvL5
	 eHkaIOa1/LaFU+8qaTYtQSuPyOWDaicGCB5OYQzA/P3KhVerTLqjFjTNcjjlNQ1Q1V
	 Yy4/vlpiRzkiomAtVFEsCbMJoB7TmAvnftVDHsEYGpjGJS0cKZD5Tvpar9kjR2OqUd
	 NJ3y9KzkPhtV/eltil/V/IlERABlQ3dxpvAPUizNE0qPElWFVcH954yGbSVy2vDOsy
	 3YZy8k43qcIBw==
Date: Tue, 23 Jun 2026 09:05:49 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev,
	axboe@kernel.dk, brauner@kernel.org, djwong@kernel.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCHv2 1/6] block: introduce bio_endio_errno helper
Message-ID: <ajqgzcEQm6BthFvx@kbusch-mbp>
References: <20260622174241.2299563-1-kbusch@meta.com>
 <20260622174241.2299563-2-kbusch@meta.com>
 <20260623145431.GA13628@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623145431.GA13628@lst.de>

On Tue, Jun 23, 2026 at 04:54:31PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 22, 2026 at 10:42:36AM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > No functional change; purely introducing a convenience function.
> 
> I've been deeply into untangling the 1:1 BLK_STS_ mapping to errnos,
> as propagating them up that way often causes more issues then it
> solves.  So we can avoid it, I'd rather not add more helpers to
> facility that (even if the helpers are just the messenger and not
> the cause of the problem).

Sure, that's fine. I'm not sure what you have in mind for untangling the
errno:blk_status_t mappings, but I can certainly have the new users this
series introduces open code it like the existing users if that's
alright.
