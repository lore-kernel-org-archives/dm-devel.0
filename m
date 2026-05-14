Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD42428490;
	Thu, 14 May 2026 15:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778773483; cv=none; b=tIkTnAvcSOxJXoSzFX1ecbh/8m6fVqE2IesiREAdM0GOywCNm9qHRPZe5mTrzavQq1lByBg0VmKOpxaZ15fErqTFH266Kxr5X5ilVP4DsTEncajuEkCA0TffDJl/NmRCALZNe9VsfSj17UhpKLqwfVuLQoX5LwF2c/JMTClgNNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778773483; c=relaxed/simple;
	bh=Bc4bbDSurzdETO7JbeWIf+UDRuWXOlXwp2V8u2ZqA0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iZTbXK7nIlj+JWze2D3cD1+WMGszm9TH2H1VBzG090gsFpJt8ccR+3BIcuMEkZXbNoOcfnPhvHf+UkZazJPqxuoZC7nnSbAxHVzk1kWEF4S8N/rJbpA0nVBKpnsgD82w5x9BSViGZ2Kur6DXlz5p3+50u4hjOepqe4vJNqBUUl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RLyVu0n1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RLyVu0n1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BDCC2BCC6;
	Thu, 14 May 2026 15:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778773483;
	bh=Bc4bbDSurzdETO7JbeWIf+UDRuWXOlXwp2V8u2ZqA0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RLyVu0n1+IckNZ8jxfcPbDr8DEpxvewBSK7bHWDV4ptITN2bCow2navXizRuXlJG2
	 JWaQsMLL+Nei65WY2kGEU6+uVVneZSxIlTdM3XGkvflW7OzlodFakqjOOQozy7ywPW
	 kV2ncq9jKbaUJwgw9u1Ekzputs3I+Mq7FsjlBADkc86isdtr7dugyK191hB0M84HJi
	 TkAZFzSD+DSYKo733TJWyMOULbHsWzZ1tJcAfsbtLGRwtbDSyNVbM9o4ho7fc5K6jd
	 O+4fWwTCNqYFQSqXJP2tDA3OrMsOIZA698xdY/B2OzP1JHZGdY7/QiJ22+fOH6R/ba
	 6U9FF+RxlVw+g==
Date: Thu, 14 May 2026 08:43:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Subject: Re: [PATCH v1 1/1] dm-inlinecrypt: initialize blk-crypto key as
 HW-wrapped key
Message-ID: <20260514154318.GA2266@sol>
References: <20260512095203.3688708-1-linlin.zhang@oss.qualcomm.com>
 <20260512095203.3688708-2-linlin.zhang@oss.qualcomm.com>
 <20260512185335.GA3085076@google.com>
 <20260513172204.GB2128@quark>
 <b0104f67-0886-4c40-89ef-bc8bb8a91689@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0104f67-0886-4c40-89ef-bc8bb8a91689@oss.qualcomm.com>

On Thu, May 14, 2026 at 05:48:44PM +0800, Linlin Zhang wrote:
> Previously BLK_CRYPTO_KEY_TYPE_HW_WRAPPED was set for blk-crypto-profile entity
> by default, a raw key won't never passed down to ICE driver, so I replaced raw
> key type with wrapped key type directly.
> 
> Now I see it already changed to query the supported type from ice. There isn't
> above concern. I'll update a new patch with both wrappedkey and raw key support
> and adding "wrappedkey" optional argument.
> 
> replace "raw_key" with "key_bytes" as well.

In the upstream kernel, BLK_CRYPTO_KEY_TYPE_HW_WRAPPED was added in
v6.15 and has never been the default.  Also currently only ufs-qcom and
msm-sdhci support it.  ufs-exynos, ufs-mediatek, mtk-sd, ufs-sprd,
ufshcd-pci currently support raw keys only.

It should be supported, just as an opt-in thing.

- Eric
