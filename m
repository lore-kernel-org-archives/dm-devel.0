Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7961240862E;
	Mon, 15 Jun 2026 17:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781543986; cv=none; b=HVInHiN1PymjWid2k83/eGUTe5kOZwLofRCbTZMevE49yNKF4yzZcGtWyTtnugNEYM273S/0Z1RsHXIsiFmQDIdKfdg+VAsSzOBtgz6WIRYUUzcv2uRbzoCs+Y+fz+7mLBCAVrSTILnv4uRHMi/0jC1pHXwUnehBRlHBgsrqExI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781543986; c=relaxed/simple;
	bh=dvSvu8/1Auv7jdvftDYHlNnsb1ahDhL7Ix2STpwI7HM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oWiFVSxQs+afIyKSjEulSf2smEyXGjdu3rLfXC1QmjV0kkZaBAHrF2SIOo+L1P9lSssHXP7sC9OGEVNE1aXbgcMucdlMSK2R/PwYjm8Qht44w7kYODXvSwhIZXubOvvQmklD0SPmmeka4h6aspTdA2UPgDRK7Jq3ZotxfEaA2RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZ+nTyq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZ+nTyq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DB31F000E9;
	Mon, 15 Jun 2026 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781543985;
	bh=Z2tm1zt7+qHSVpBQ0c2Mr4ZDKN4B7CbGgRJQebOQNrA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eZ+nTyq7qyJBgXaeajz4Mvk74zaupY1RScU6Dzi8XmWyJ5emgQyka+qQ6ThTgv/U2
	 bkEi/lwLk+wSZZeyvi6YjoO23tbBPOH9BDlSFitPUVApoMr0dCavKnK3ZXQdf/3eZD
	 5vf+XSuMh2LQk2FLVll+FquoRhqUiUcOOsZFBm5LbGFkapCGHcwYoTSbqienkCpx0D
	 00t9jVuJZ2iDGfQmIOFSXLM9VlJRMkL2sWFJvZDg79kyJpjHUjrUGdfPKUmEpTJbdG
	 dFh0uLDgHWctr6y9Khn0ugZ1SeCbp/kYPsgTMuDWhlP2qakM/LSo0MsSaPMY6qr9SJ
	 mdNNzXFbxzNxA==
Date: Mon, 15 Jun 2026 11:19:43 -0600
From: Keith Busch <kbusch@kernel.org>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
Message-ID: <ajA0L-u-r4nhbpfl@kbusch-mbp>
References: <ai7rnH20IYeSmY8s@gallifrey>
 <ajAYN_mmjzYBAimV@kbusch-mbp>
 <ajAb0m9cNraQn2Pw@kbusch-mbp>
 <ajAqUwo3eTm1c2_J@gallifrey>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajAqUwo3eTm1c2_J@gallifrey>

On Mon, Jun 15, 2026 at 04:37:39PM +0000, Dr. David Alan Gilbert wrote:
> Hi Keith,
>   Thanks for the patch, alas it doesn't seem to be helping here;
>  the first warn is still the same
> and it still hangs the test process hard and eventually BUGs at
> 
> void blk_mq_end_request(struct request *rq, blk_status_t error)
> {
>         if (blk_update_request(rq, error, blk_rq_bytes(rq)))
>                 BUG();

Oh, that was not expected.

What is the dma alignment requirement of your backing devices? You can
find the attribute for sda at /sys/block/sda/queue/dma_alignment. I'm
expecting 511, but just want to double check.
