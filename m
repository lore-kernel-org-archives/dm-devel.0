Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6234D193409;
	Thu, 17 Oct 2024 19:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729194257; cv=none; b=Gw3igwhiJ3PH2b7tU8n2dUhsr6iVOANIUIswy2KhWJBKt+MXVh5Mg279S60YFiufycjZkC0ntZ1i2dEVqrhWBztYe4dSb7uB1ia3gm7KZyAmOFZvg+XHwOZqBeAovB0mXFvBTHVZHwdB7mJtSOUvHCv6ttDOoy/IGIY2P1nJGBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729194257; c=relaxed/simple;
	bh=3XFUiq+FrQjOla6ffWyuWjodsUa4VVjrvMC6hXatxzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLbOjgL2FGNs6qXQgJZZzRt2kdLCQvOcN8NVFSa71vWV55afmBicv6wpaBraj8mjwbGWL60W2LDQx25KCVFPqvu0HZp5mQtM7++fBmvODPAiC8Qev/gy7k4AqQ2MEZrVDr1pY8yUnH2o4Divgcv4o9zD10/XfWvWZx7dv/3ngZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kA0ZtQvA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kA0ZtQvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAFCC4CECD;
	Thu, 17 Oct 2024 19:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729194256;
	bh=3XFUiq+FrQjOla6ffWyuWjodsUa4VVjrvMC6hXatxzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kA0ZtQvA4neszzT+VvxYFyQcMq4hk/0l38j9tekH24z2z7K8aCVbiFdzh2INgtrKE
	 p7PXSjecvEb4oGol5st8u8ZaHCP46RXL7ezJ1pBXXL5A2W0cseEQDfdb+70yGeGluU
	 WkftJZefoYRutWkUQpInrewm8HW5ZPt8DJqR+e8T0wYQD972SwccPlcz4TAJngAiNC
	 t5Cy0yFrZEVuVDxF8EApP9fERtpIWOvafVTpFv1u97V8QNNwgl04zYpnc5n8Dgfk4E
	 sdDHYPmZ5K3ng1XHNTnFEu/rlcJYbpqNXAOYbM5u6JWxpOPkZHRJBft0O+tU11SDLE
	 BrOL7y57A5hyg==
Date: Thu, 17 Oct 2024 12:44:15 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>,
	Milan Broz <gmazyland@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC PATCH v2 2/2] dm-inlinecrypt: add target for inline block
 device encryption
Message-ID: <20241017194415.GA11717@sol.localdomain>
References: <20241016232748.134211-1-ebiggers@kernel.org>
 <20241016232748.134211-3-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016232748.134211-3-ebiggers@kernel.org>

On Wed, Oct 16, 2024 at 04:27:48PM -0700, Eric Biggers wrote:
> Add a new device-mapper target "dm-inlinecrypt" that is similar to
> dm-crypt but uses the blk-crypto API instead of the regular crypto API.
> This allows it to take advantage of inline encryption hardware such as
> that commonly built into UFS host controllers.

A slight difference in behavior vs. dm-crypt that I just became aware of:
dm-crypt allows XTS keys whose first half equals the second half, i.e.
cipher key == tweak key.  dm-inlinecrypt typically will not allow this.  Inline
encryption hardware typically rejects such keys, and blk-crypto-fallback rejects
them too because it uses CRYPTO_TFM_REQ_FORBID_WEAK_KEYS.

IMO, rejecting these weak keys is desirable, and the fact that dm-inlinecrypt
fixes this issue with dm-crypt will just need to be documented.

- Eric
