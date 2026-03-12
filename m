Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A17338DD3;
	Thu, 12 Mar 2026 07:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773298930; cv=none; b=CDppdA7Dg33aupJVGqhgg2kB7WDUmZnHl6XO9tN+KP2mv1LnA0s6THcYEnvsQSh7SuoNQZtXcyWG51UTytQwtC0MXahkPRb4eNsiDRh66CmoOXrEsfvxwpdBLimW1cIFzyLbsHCBr7QVmXw2NPODAtSUqbBRfi9guTHWoIRsMaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773298930; c=relaxed/simple;
	bh=AUvdUUZjCLhVzoxLA7juIp90kE/LjOwkdKTmGV0+mlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ImEJsCIsFrEXhOLz1e5zu1AAql0w6HNbgNlF5J+rsVAhviSnOi1iUxx+cA6Yi1kfWw0uF3YhGTBe7duERrVz95Y0kN4GdeYXb55ISDJsN5r92RKXFRSnpssmXm9jEXUbv1aN2Qr8vm5vvY9H0UAjIbLoR34fuCt5PUonrI6MEDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CVppABnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CVppABnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FBDC4CEF7;
	Thu, 12 Mar 2026 07:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773298929;
	bh=AUvdUUZjCLhVzoxLA7juIp90kE/LjOwkdKTmGV0+mlc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CVppABnBzGsOMm1UyjCTMgwaRY9KotTGkhlk+Iy08Mwym5nY4WclCSgJVw3oTvYg1
	 rENmcR4viWxICtPEQmWNnvKCOkaywmwLnPCs5KdCry0F+RR10haNRQTrJ+i8pEfL/Q
	 PpO6nMjXdZL9sEOAm0E7Bgm+9X1Uj5YwRB1dSUS/dx4NZpgGAS4pYBe2Hl6TJ5GlJZ
	 Xshwe4rPb4lBvJSa442dFA/y0dilgOTGb2MJbvjsCCm936OrcXaO98/Ke7ZkuPqSdE
	 aSbpj8QK8FBuZVzY6M9t0bGFmJ+1nfQ1EDn8e6nYcdV1AfUiBmXDtWTCzftxzyqFtB
	 F+Ve60ptD1mpw==
Date: Thu, 12 Mar 2026 00:01:10 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	adrianvovk@gmail.com, dm-devel@lists.linux.dev,
	quic_mdalam@quicinc.com, gmazyland@gmail.com, israelr@nvidia.com,
	mpatocka@redhat.com
Subject: Re: [PATCH v1 2/3] dm-inlinecrypt: add target for inline block
 device encryption
Message-ID: <20260312070110.GD2359@sol>
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
 <20260304121729.1532469-3-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304121729.1532469-3-linlin.zhang@oss.qualcomm.com>

On Wed, Mar 04, 2026 at 04:17:27AM -0800, Linlin Zhang wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a new device-mapper target "dm-inlinecrypt" that is similar to
> dm-crypt but uses the blk-crypto API instead of the regular crypto API.
> This allows it to take advantage of inline encryption hardware such as
> that commonly built into UFS host controllers.
> 
> The table syntax matches dm-crypt's, but for now only a stripped-down
> set of parameters is supported.  For example, for now AES-256-XTS is the
> only supported cipher.
> 
> dm-inlinecrypt is based on Android's dm-default-key with the
> controversial passthrough support removed.  Note that due to the removal
> of passthrough support, use of dm-inlinecrypt in combination with
> fscrypt causes double encryption of file contents (similar to dm-crypt +
> fscrypt), with the fscrypt layer not being able to use the inline
> encryption hardware.  This makes dm-inlinecrypt unusable on systems such
> as Android that use fscrypt and where a more optimized approach is
> needed.  It is however suitable as a replacement for dm-crypt.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>

I don't think it's plausible that this new patch was actually tested.
The version I sent in 2024 was tested at the time
(https://lore.kernel.org/r/20241016232748.134211-3-ebiggers@kernel.org/),
but I see at least two things that would make this new patch not work.

First, the call to blk_crypto_init_key() will always fail, since it's
being passed BLK_CRYPTO_KEY_TYPE_HW_WRAPPED but using a 64-byte raw key.

It needs to be BLK_CRYPTO_KEY_TYPE_RAW.  (BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
support would make sense to add as an extra feature, once the basic raw
key support is working.  Note that when I sent the first version of this
patch, support for wrapped keys was not yet upstream at all.)

Second, since v7.0-rc1, submitters of bios don't automatically get
blk-crypto-fallback support; they need to request it explicitly.  So,
this patch will not work with blk-crypto-fallback anymore.

If you'd like to continue work on this patch, it might be helpful to
check the latest version of dm-default-key.c in "android-mainline"
(https://android.googlesource.com/kernel/common/+/android-mainline/drivers/md/dm-default-key.c)
and resynchronize this patch with it.  It already has the code to
correctly support both key types and blk-crypto-fallback, for example.

Either way, this patch also needs to be re-tested with the latest
upstream kernel, which doesn't seem to have happened unfortunately.

- Eric
