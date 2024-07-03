Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D507F136678;
	Wed,  3 Jul 2024 20:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720038378; cv=none; b=lXOaGEJRQw0HpGhYJYNqDVRCH3mB/bWM/ES3H48H18hpCLv7iuFKD06TX0eNHIVVAnLmI1xvLG9Se5a/og1hCO5/Gidyy/2GqRcueP+qw1sTQC0boXxEv1tjz4+Uok5quSdKFAyMs5pSjRFHNcLbv5MVYALKSeIStuMBilH39nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720038378; c=relaxed/simple;
	bh=JPNWhWBGhtUw8oLzvHGGrMBJp4twzBdCg+00WnZ+rfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IXwqE1TihERJmt5qnUGEGPCEQQxhB2xjweXYci7FTNanBukQGvwRaWI7/tx7u5m3dZshdIlIhg8zxFSqJ3/msJE3rU/XqvE0WTPDg52AwYDFfkgFXKwidgZo1t1DGEM7uDWYiBBzuhVMQoSafczQ1RH51PK1uxYcQZ+HJqQHr9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q+NGQcxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+NGQcxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0721C4AF07;
	Wed,  3 Jul 2024 20:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720038377;
	bh=JPNWhWBGhtUw8oLzvHGGrMBJp4twzBdCg+00WnZ+rfc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q+NGQcxJ8Q46KLIpJyzeEE4KlzQnCEB/riKbwSyteWxab3F6MFNVVdLV37Rbb8TX0
	 vTOF9FEGU304Oslx4DAFcpsz7AEmL/yJe9YUFblujWjIr+gKFyoiYwoS5Tcusnhvin
	 jmvWohd0eABuyyjcY44xZ2415xsTz4rXBYuLC/PibVFTPksFlUWCoBfPgsv0al7tAs
	 tuNhWzU/5IpkadmLPQRUVSlbiPRc6oUxfrOUsm1kvq2tZyF8w+5pMZJAD49nCdsKLd
	 nd7mNTqebcTSoVD1jLGipDTrjBV8/nsslSvtSm9BmHIdL8C2ToJB1AHD5TO1jUCIwV
	 2CoEX1nDlwvbw==
Date: Wed, 3 Jul 2024 13:26:17 -0700
From: Kees Cook <kees@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH] dm-verity: fix dm_is_verity_target() when dm-verity is
 builtin
Message-ID: <202407031326.8DD8F504@keescook>
References: <20240703200813.64802-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703200813.64802-1-ebiggers@kernel.org>

On Wed, Jul 03, 2024 at 01:08:13PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When CONFIG_DM_VERITY=y, dm_is_verity_target() returned true for any
> builtin dm target, not just dm-verity.  Fix this by checking for
> verity_target instead of THIS_MODULE (which is NULL for builtin code).
> 
> Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
> Cc: stable@vger.kernel.org
> Cc: Matthias Kaehlcke <mka@chromium.org>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Ah! Nice catch.

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
