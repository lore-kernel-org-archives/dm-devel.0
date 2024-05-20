Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE84A26AC1;
	Mon, 20 May 2024 20:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716235963; cv=none; b=N4+iCLYPgHCxzWYPy9jEXw7u1cNEAQBt3Jz4OTSmdmnZ+v4/kWglfD3xJW+cWENUH/O2bfeCLGsf9fQw5o1lhMR0Yd0fylOuVs5eEwhaPuFPWI2g8ZAqd6WcBfV5+SMouiWcBkzRRtfjUp7FpfcHwiYdsYknHOOcvdOdxZV628w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716235963; c=relaxed/simple;
	bh=j6UZ3hL6JZ0QfhbLrz2gBFof0KSATisW8jSnUWUDDvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WcFU0Aulvt8wu7ABrDEsdBDb+0y2Jw0LBtk8/FcK8S/OL1pvfNJV6LPY19XPzBU1g3IyIWWDLqJjnAOKJktFMwNQ8HUwnZdwOwhDUablSHeIMrV0XSWNCjM2lWF+j2ATpk4oe4dW2Ndo3VzZYwIkMp9+Y5g+YAMnD5ko9eYe3lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F41A268AFE; Mon, 20 May 2024 22:12:37 +0200 (CEST)
Date: Mon, 20 May 2024 22:12:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
	dm-devel@lists.linux.dev, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, regressions@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: dm: use queue_limits_set
Message-ID: <20240520201237.GA6235@lst.de>
References: <20240518022646.GA450709@mit.edu> <ZkmIpCRaZE0237OH@kernel.org> <ZkmRKPfPeX3c138f@kernel.org> <20240520150653.GA32461@lst.de> <ZktuojMrQWH9MQJO@kernel.org> <20240520154425.GB1104@lst.de> <ZktyTYKySaauFcQT@kernel.org> <ZkuFuqo3dNw8bOA2@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkuFuqo3dNw8bOA2@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 20, 2024 at 01:17:46PM -0400, Mike Snitzer wrote:
> Doubt there was anything in fstests setting max discard user limit
> (max_user_discard_sectors) in Ted's case. blk_set_stacking_limits()
> sets max_user_discard_sectors to UINT_MAX, so given the use of
> min(lim->max_hw_discard_sectors, lim->max_user_discard_sectors) I
> suspect blk_stack_limits() stacks up max_discard_sectors to match the
> underlying storage's max_hw_discard_sectors.
> 
> And max_hw_discard_sectors exceeds BIO_PRISON_MAX_RANGE, resulting in
> dm_cell_key_has_valid_range() triggering on:
> WARN_ON_ONCE(key->block_end - key->block_begin > BIO_PRISON_MAX_RANGE)

Oh, that makes more sense.

I think you just want to set the max_hw_discard_sectors limit before
stacking in the lower device limits so that they can only lower it.

(and in the long run we should just stop stacking the limits except
for request based dm which really needs it)

