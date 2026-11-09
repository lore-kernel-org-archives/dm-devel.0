Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794204655;
	b=AmSLsKgtUe9WNJJHMxYWwiohB7SXh/2tH5taWo82tgJLe0ShmYRKum/zQw8/YK41sGoy
	 X9+L06EWNoPPp5FnuPPvLl/Tz0+9yInSu6/q1FzjSLD54vIb8TA1VCZJu1anWDotbIvz4
	 XX/BOGv6tMxp3IuSpAqRjo4wsTQ3l4FP2561gw2Su4engkM9JbgE+rFsuQgrKP6r6fagb
	 jcJkGDL9fiZZLcP1bfRNtsSmfCh07mPHUmMcRVr3BuFYVfRCsE5PINx2TrbSEiFqU6TYp
	 VcZWGvLGJq9KSb1xmuggLDFirFB/WM+l6UQ4/xdYm6Voy8KDAt3xXGk1LKEIorGmJBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794204655;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=qgra3gkqhHOHEG3xUTJQ6+CkPnU6cD/+HbaneR7Blpo=;
	b=nVfVkt86+OSgcIJYXRM8wDoAYKSBuLQbvVMizEiLK4F/mRdAl019kEImOF+pYaI93+GD
	 XdFlAuuktixXPh9oLed/g1l/7lPFqCyvQqZWaXLXa78EF7ikFkDw2Up6rRxXalFLsYUb0
	 lY260oEHmuBuv1c0MePnDFZV3yKsA561qi6FmLunJcST1PDpo45KaEYjpQVq0jXiwH1A1
	 eiHoRVWhl2uFceA30FborhZ6BgxPindWhRcqiH/zGo8BQ+oX81Kjp1vDf7XyB597f7g66
	 AKUFC4V+6fkjSQ7pXcTb4KvkSSRGs6q+oXoW8UOwARXVa9O7qgZH2eA/u+LyYIqLjrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Q8lh35c/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6798A606A31C;
	Mon,  9 Nov 2026 06:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q8lh35c/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFF71F0089F;
	Mon,  9 Nov 2026 06:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794204655;
	bh=qgra3gkqhHOHEG3xUTJQ6+CkPnU6cD/+HbaneR7Blpo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q8lh35c/rz/bSUsGuOpFEPXymlLM1QZW8EDg5uxuTUdlOqFbf7ayxAUpoKMfMVx08
	 1Vejrx8GVkmQ8jCVfoSx1sz4Czi+lNFo4nDsbezroZ0oIPe0noPujVQLH+CZbq2dHR
	 x1LPqzo9Zt8qc/9TRA0I/Fd4JQQmwKBrp2ngT4FI9yeLYOi+aci0mrpdM40wvHeM1N
	 FuKSKR8oRQW0tuQnq+CLHHYy2KsZGRqEMmJXR+mZf/lUnxBockyl8ilBKRRMjKAKON
	 5hKed9R2e/931HMAipSpMkGsWLWSd4KTFgmZArV3+F5BZoV0/Nel8E4qB/oa5Dke61
	 gY419N4bLqBag==
Message-ID: <961e5e97-0692-4642-a0cb-aafdcf7150d4@kernel.org>
Date: Mon, 9 Nov 2026 15:10:51 +0900
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: avoid double-dropping the zone reset submission
 reference
To: Yaohan Li <shunsheng1218@gmail.com>, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, bmarzins@redhat.com
Cc: johannes.thumshirn@wdc.com, mkp@kernel.org, axboe@kernel.dk,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <179378374219.68809.15920762511563622507@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <179378374219.68809.15920762511563622507@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/26 18:15, Yaohan Li wrote:
> On an error in __send_zone_reset_all(), the submission reference
> held by the dm_io can be decremented there and again by the caller's
> error path. If another clone is still outstanding, the second drop
> can release the dm_io before that clone completes.
> 
> Only drop the submission reference in __send_zone_reset_all() on
> success. On failure, leave the reference for the caller's existing
> error handling to release once.
> 
> The error path was reproduced under KASAN with an injected GFP_NOIO
> allocation failure while another zone-reset clone remained in
> flight. With the change, the same failure was reported normally,
> without the observed use-after-free, and ordinary zone resets
> continued to work.
> 
> Fixes: 81e7706345f06 ("dm: handle REQ_OP_ZONE_RESET_ALL")
> Assisted-by: ZCode:GLM-4

Drop this please.

> Signed-off-by: Yaohan Li <shunsheng1218@gmail.com>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
