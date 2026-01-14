Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820EE2C159A;
	Wed, 14 Jan 2026 15:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768405743; cv=none; b=Edii/vzmX5f9r0sPgdRah5jQ7A+pODSxT1Jhh6wtjPbD7muUcHmyjB/UT24Arg7IIVXWkaSDCNRF5ELC1fKsbQBAHCcYXckQ4oBzLow9zyHSIxAIHm7B8rwavh7t+VFXsvAWYLnnl5LJdgGFlQJdMsmTwpMyuoyLvXV4jX6+Rx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768405743; c=relaxed/simple;
	bh=nM6vXRLNqLc9qXIhspTMxZ2jS7EM7byGNp2kME+4GuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EPIF0RsjiL8C4AbpTbJZ8Mu/TAHLPq/kPu0Q/Tc8QIgDSlFZiTR9jkialP87qvBmRmzmC98sQ4pfKqP4UvOzCRXulAACQWDEqjzg6eWZHIwMANVe9vECjNqECZGFaN6aBgPGoKMNxZundXhQN9NnICRLCvBOOwY+Fp+sNdl1ZtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4qb18EZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4qb18EZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E48C4CEF7;
	Wed, 14 Jan 2026 15:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768405743;
	bh=nM6vXRLNqLc9qXIhspTMxZ2jS7EM7byGNp2kME+4GuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S4qb18EZu7YhUCjP8LOd8reK3+ZM0F42JMXG2iB1BSXAgFOWEozpZsImhjiRnZl6O
	 jWWoHZkuaqguxQ4PXJLx3hpbNbgFVQokv4pj1WICoCWDOflt/B17yg/gUghGiYQP2s
	 f87p1CnplD/bX12DfHbpYcAa6ftm5Vzk4nsA3Xap9W7O1OnR7yVxYS+4PSgXN26PyE
	 S8xDo3QB9Cn7S9MnLbcpc+oF9FybBHtK3h3udDINrnENb2AHB/xWirg9p8IvjPZyh3
	 Gw+brXCAI7ym1n/Rha0gdejGn9f+NJosspWqRF+Cvocn3gjsyeh2ntNpmrBn+FDVyi
	 ha0talj7mrOHg==
Date: Wed, 14 Jan 2026 08:49:00 -0700
From: Keith Busch <kbusch@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
	ebiggers@kernel.org
Subject: Re: [PATCHv2 0/2] dm-crypt: support relaxed memory alignment
Message-ID: <aWe67DKDibDbhAWQ@kbusch-mbp>
References: <20260114154113.3207790-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114154113.3207790-1-kbusch@meta.com>

Sorry, please disregard this. I meant to resend v3, not v2.
