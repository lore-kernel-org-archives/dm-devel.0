Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BC8170A11
	for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 22:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727218192; cv=none; b=SVgsX0wjKmnSRx0nyXiZX2P7kzSN2dxUjNMM5KvV69dMkOF18WIOCNDgsaFFnsGTrJCoz39is9engiTpUlT/yJ98Vwz3M6yPQwu7GLdp1Qskwb4ZvBo4ZjxcP9LLUlLgRmos5j2DCaDH8UCMawAf7kxR+SKP+rdhKOhb8mLpyww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727218192; c=relaxed/simple;
	bh=yNCcmxqtK3q2HTg7iudl3ZGlGAfcxe/cg88oSH2jMj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xf23baDjoyjaywMMhXYBW2CFi96g+X/liC4Kkhkee6bVGzSz649jWxhOo+ZtZHEClNnMcL2flzendRHMJ/CzsF32zvCxQR2C+RfYyKvuM0vRJBcZHOGIVtj6lSQwOuXW4TC935TrYl6bD/y516WLXLhPhbLiTc7XkBIYqGkmHyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C4n0eDCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C4n0eDCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A48C4CED0;
	Tue, 24 Sep 2024 22:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727218191;
	bh=yNCcmxqtK3q2HTg7iudl3ZGlGAfcxe/cg88oSH2jMj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C4n0eDCGbrZn2TwZdBRtbOJirepgD3xy0ZEND/IE/k3VvTKpWPofpGLEbEIxoFGq2
	 ES4v40Mlh5vHVY1/xf/3rSufCJRV19X2K5CF07PQH50JYv1XTcppVJtYR+GwL2O4cz
	 Pf4dTGFTIFchbJnFh6ityeWuHD/kohyPTVjJ8SK+3YoFQ8cqovdxf83cJ9aHHugikN
	 5VeN47+jxhciIgI2U2cmjtD2bVbkgITi2VoaVOlvoAMgVEJ3oaQxrjO8P+Jm++0FGj
	 4Mheu6r5f1cuPFsgrVfu07HQ+Xh9paOLXRJpNR6QytOR4dyihCmtUidrysPEhmgYTR
	 UKTIEMTpRIdpA==
Date: Tue, 24 Sep 2024 15:49:50 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Maxim Suhanov <dfirblog@gmail.com>, Alasdair G Kergon <agk@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Mike Snitzer <snitzer@kernel.org>, security@kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
Message-ID: <20240924224950.GD1585@sol.localdomain>
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com>

On Tue, Sep 24, 2024 at 03:18:29PM +0200, Mikulas Patocka wrote:
> Maxim Suhanov reported that dm-verity doesn't crash if an I/O error 
> happens. In theory, this could be used to subvert security, because an 
> attacker can create sectors that return error with the Write Uncorrectable 
> command. Some programs may misbehave if they have to deal with EIO.
> 
> This commit fixes dm-verity, so that if "panic_on_corruption" or
> "restart_on_corruption" was specified and an I/O error happens, the
> machine will panic or restart.

How does this interact with FEC, which can correct for I/O errors on the
underlying media by reconstructing the data?

> @@ -596,6 +596,19 @@ static void verity_finish_io(struct dm_v
>  	if (!static_branch_unlikely(&use_bh_wq_enabled) || !io->in_bh)
>  		verity_fec_finish_io(io);
>  
> +	if (unlikely(status != BLK_STS_OK) && unlikely(!(bio->bi_opf & REQ_RAHEAD))) {
> +		if (v->mode == DM_VERITY_MODE_RESTART ||
> +		    v->mode == DM_VERITY_MODE_PANIC)
> +			DMERR_LIMIT("%s has error: %s", v->data_dev->name,
> +					blk_status_to_str(status));
> +
> +		if (v->mode == DM_VERITY_MODE_RESTART)
> +			emergency_restart();
> +
> +		if (v->mode == DM_VERITY_MODE_PANIC)
> +			panic("dm-verity device has I/O error");

The blk_status_t code that is checked above is usually the one that
verity_verify_io() produced, not the original one.  This could be an error from
a cause other than an I/O error on the underlying media, like data corruption
detected by dm-verity, or an error from the crypto API.

Maybe what you are trying to do is really "panic if an I/O error would be
returned to the layer above", not "panic if an I/O error occurred on the
underlying media"?  If so, this needs to be clearly explained.

- Eric
