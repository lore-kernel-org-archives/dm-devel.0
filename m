Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F013D4134
	for <dm-devel@lists.linux.dev>; Wed,  8 Apr 2026 18:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672984; cv=none; b=q67Mt4xEgOuZ8hwrAWtuERSqAky+paHV9+YFgBbOQmYA7kZmv7MLolmGG5HsJIi7Hy+8+IA8C1UXFElMS8/N9pYUse9GVy3mUsrIR+HzVLEK0ovZd7JA24UwktzyANGcIwLh9oX84QW2UTT0xr6el2gZn8zkF1zByWt+7YTd74c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672984; c=relaxed/simple;
	bh=hU6N+FbSavnADMyvz8BENYZPzr/MwaQOvreFwNfZcH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H0VZ1jZq3rq7dD1tdhUEmpCUkRrixfl3vlD3izhc+nESDRx+WiBdfZflFzhnky0jYD8acfqNsk3VjG2S7gD9oCwHZswuKG6en5m/FIHI2SY2fbV/13mX1skiYav8lx5G/B6eHciY7uYPVJ6ySZGmVHZURHcX5Ye8apHuhwTF41s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fUiCoKJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fUiCoKJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A18C19421;
	Wed,  8 Apr 2026 18:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775672984;
	bh=hU6N+FbSavnADMyvz8BENYZPzr/MwaQOvreFwNfZcH0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fUiCoKJZMxwHY6672vTDg6fbmEku9dxfJc2JdxBaBkbQvCJCpVD3YyodJpGuQf8pp
	 B6tfmtkheJXA7grJ8+F3iu/ruSlMuQSImcrYJvw4cdghIeafxXBFiIRFV3lsznEqns
	 oRhC/8TKp9zsaXLnWSZh9gByS41wYZcD6pA/dtWF7RQXVAsynd/hv4uqSucOLc4pN5
	 pWR7bc0nEyruNp5ck3W7Sz53SySEpzNsX9t17f5AHtqCGhoy+MyNV9Rm+AKzecHLZq
	 UtLsUO46b0mBp6Tju7P1sBpnvOdFVAV0vZ1tMY3e0iRn5rJAB1LAYQ/7y7YGCAvVTJ
	 WJP5exrkgTtOQ==
Date: Wed, 8 Apr 2026 12:29:42 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	snitzer@kernel.org, Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCHv4 0/2] dm: finer grained memory alignment
Message-ID: <adaelmLUe1hr0Y31@kbusch-mbp>
References: <20260330170114.764606-1-kbusch@meta.com>
 <96d098d4-b162-89e7-67b3-f194528bd122@redhat.com>
 <88f315ce-b84e-49cd-cf2d-ae64cf255f00@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88f315ce-b84e-49cd-cf2d-ae64cf255f00@redhat.com>

On Wed, Apr 08, 2026 at 06:12:24PM +0200, Mikulas Patocka wrote:
> Hi
> 
> This doesn't pass the cryptsetup testsuite and it's too late to fix it. 
> I'm reverting the patches - fix them and resend them when the upcoming 
> merge window ends.

Thanks for the notice. I've got fix prepared, but I'll wait to send the
next version post 7.1 window. In the meantime, I'll just give it more
internal testing time.
