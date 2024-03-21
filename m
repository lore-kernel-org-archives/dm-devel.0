Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10987F4FA
	for <dm-devel@lists.linux.dev>; Thu, 21 Mar 2024 03:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710993126; cv=none; b=m2YxGRoI7hQGTyESVMqtUBP5cZwM7Rn3lFAH/nHlwvOQG91PkdST23IGGIi0ki/abPM0DIqCi8Zdexi98z0/wrCzld8/kd/TYu0dsANukdlWFr8BLCBRE831mj71MQJAvhnB1BuhTOYTPnzwl0LqwD8aCBU9N3I2rthClDS8dGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710993126; c=relaxed/simple;
	bh=C4m7BhlDCtvaFNAZij87qDNkiehqb3Q36aL3wTgibxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jzv60BmQ/wCXXc3eMg4gcELozm4HyZf2yX5kC1Rw791FUclmS0qCLRKiPHRg93kq+meubeOEhJgXVj6q+/FU87p8FWz3UPx32E2lip0iXFPxkViyLMqlWkkThNJr1oFYsd761AOXuqyPXfBTfch4hOrLwJ2FisD0K8xjV5JlP0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X9oNc3Fq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X9oNc3Fq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1D0C433C7;
	Thu, 21 Mar 2024 03:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710993125;
	bh=C4m7BhlDCtvaFNAZij87qDNkiehqb3Q36aL3wTgibxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X9oNc3Fqw8FnKa4ZDUKAkGEn/ZadyHM6JmwyC33BA96NNpYvczxbQUFidL9NpD3IZ
	 wiiT4x+wXflj83cecR2ztf9S4uSwXpEtWMj/4tTUVflrg+9FjRFwW28aPVlyc6THiC
	 HK3lav6r1GYr2WpD3tkFOdsqxHUd4r0pdCjwZ55SSJpF8S4eHs3fBvzf04H1URWs9E
	 hnQFDBw34Wzd4pLR1EDyRq8QoVSNzf65aucO+gL48qe3CUCYd2NepZ+PMAuag5y/Mm
	 SQm0DV2Xquq6lUQdyMx1iHdWEBQ+MPn4lZzb5dtWovUnPeC8kJTEoaOFJQCq6uLltF
	 ai/slFNjxuA8A==
Date: Wed, 20 Mar 2024 20:52:03 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev, Ken Raeburn <raeburn@redhat.com>
Subject: Re: [PATCH] dm vdo: use kernel byteswapping routines instead of GCC
 ones
Message-ID: <20240321035203.GA2387@sol.localdomain>
References: <fe10f7bf2332c868deb88bb59967fa1880b1b34f.1710970229.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe10f7bf2332c868deb88bb59967fa1880b1b34f.1710970229.git.msakai@redhat.com>

On Wed, Mar 20, 2024 at 05:44:05PM -0400, Matthew Sakai wrote:
>  static __always_inline u64 getblock64(const u64 *p, int i)
>  {
> -#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> -	return p[i];
> -#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> -	return __builtin_bswap64(p[i]);
> -#else
> -#error "can't figure out byte order"
> -#endif
> +	return le64_to_cpup(&p[i]);
>  }
>  
>  static __always_inline void putblock64(u64 *p, int i, u64 value)
>  {
> -#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> -	p[i] = value;
> -#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> -	p[i] = __builtin_bswap64(value);
> -#else
> -#error "can't figure out byte order"
> -#endif
> +	p[i] = cpu_to_le64(value);
>  }

This is very broken.  What you're actually looking for is get_unaligned_le64()
and put_unaligned_le64().  And they should be folded directly into the caller.

- Eric
