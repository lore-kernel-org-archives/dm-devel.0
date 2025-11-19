Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1064681724;
	Wed, 19 Nov 2025 03:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763522255; cv=none; b=W/5bMTxOivJTN3UpQp7HITSbO5h9iZkBkPQprIifwgjlr4jKGjZSDLyUJjOvHyuiZ6L/VjA44AkUd+XreTvfwhYZ2VqxB4NLxJxiT0LfYLgFHo1QZWNuZ0wM6xmmUHOpoV/uDFjKWxPHCVWqVVgWp1MIMVa1H/rI+t+aq5GTlH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763522255; c=relaxed/simple;
	bh=qD+zY2/p2VXfdIcfnXOgbnLLd+AJ+owWIkNz2l2Vp4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SMpflWrfDFOhh5U0Wc2+juHGQR4EqGDJGDWvgt/hqHLlxA0/Twtl7RJdkJadzLRqyzRA5jFtxEcJ+aSinyItQ0lC+X7krLXdwEDp5RzKTg1+epIpf61tHAfVzEW6a7Gg8CXJSnDC7j4l+Pyn6K37vX1Febg0CQJ9T6K7cFce1eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V+1XPoic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V+1XPoic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448A7C2BC87;
	Wed, 19 Nov 2025 03:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763522253;
	bh=qD+zY2/p2VXfdIcfnXOgbnLLd+AJ+owWIkNz2l2Vp4g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V+1XPoicQx8wbgHbCIEhZ8ozoccvnBQL5dfxNfSr4B07+3tuDL5Tst9V66//I5TwN
	 GXDAvApkzg3wylShJv9Acy4KIcOJXo3RIP7aXLzSyq57AIPrHguesEkGTI01S0imoR
	 zfpQIZs9p8WzeeZkSNI4gU8CDWq4CxUSNCYZJYgPCy7v5LOzHcV7wgCqY0yXehS964
	 Q70TbfFvyrwfHWzd8xRTEIKLF56yk3C7CPP2v42uMV2eree3nQVw9wNWyzlP7JpR1V
	 U3cLlPlh3wRsnkKl3vEIIsAUT6ortXkSG8xr1NF9yxjkuuOPKVugISv9FZvubSNLRl
	 nVKNStllXZTrQ==
Message-ID: <624d4ad1-3d30-433d-80c3-ecc3cc6cca46@kernel.org>
Date: Wed, 19 Nov 2025 12:17:30 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] block: add a REQ_ZWPLUG_UNORDERED flag
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev
References: <20251118070321.2367097-1-hch@lst.de>
 <20251118070321.2367097-3-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251118070321.2367097-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/25 16:03, Christoph Hellwig wrote:
> This instructs the zone write plugging code to queue up any bio not
> at the write pointer, and includes an implicit guarantee that the caller
> will fill any sector gaps.  I.e., this can be used by file systems and
> stacking block drivers, but not for untrusted user block device writes.
> 
> Because all writes through the write plug cancel all outstanding writes
> for the plug there is no risk that queue up writes for higher sectors are
> stuck in the zone write plug even on error.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
