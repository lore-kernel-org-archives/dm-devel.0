Received: from icts-p-cavspool-1.kulnet.kuleuven.be (icts-p-cavspool-1.kulnet.kuleuven.be [134.58.240.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882A84119E4
	for <dm-devel@lists.linux.dev>; Tue,  1 Sep 2026 15:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.58.240.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788275131; cv=none; b=o8p17NZAVMl/JJedu4/yR5yyvxlZl5gy1SKtUHr5WLQ87zMbtoJnssrstv75quQ9tb+sgZ8LFAHKPlDdN15qOxCJoHSCSKFWRtGDDo27KLdYVBx5z2iZ5XYkLGCs/MA0UqtDLDzxD3QJalTW+EXvMuj+zmKS0TIkxzVp5Wgc6rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788275131; c=relaxed/simple;
	bh=/c3w8PU8MzfCBx4rHdXQP7pYPzliQVY/cNHV2v0BtiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SGdIJ6HhmyD88tQiDNp2TNcw1LZz9ZBENO0BUEwl9SYGvmBuIC1lsnDhlGeJQYzD52xft+bNm8Y1dUFHEOLqrAYTMuvLdrL0W2Ps/Yh2S7A7twBXujvj53Pgsj8ntEVZuIcl2hgX1H7OStDv2yE4V7AGOThZxUAfJs9BcmUAS5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.kuleuven.be; spf=pass smtp.mailfrom=cs.kuleuven.be; dkim=pass (1024-bit key) header.d=cs.kuleuven.be header.i=@cs.kuleuven.be header.b=JYv5sPNr; arc=none smtp.client-ip=134.58.240.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.kuleuven.be header.i=@cs.kuleuven.be header.b="JYv5sPNr"
Received: from icts-p-cavuit-3.kulnet.kuleuven.be (icts-p-cavuit-3.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:133])
	by icts-p-cavspool-1.kulnet.kuleuven.be (Postfix) with ESMTP id 952F551A2
	for <dm-devel@lists.linux.dev>; Tue,  1 Sep 2026 16:57:09 +0200 (CEST)
X-KULeuven-Envelope-From: jo.vanbulck@cs.kuleuven.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: D99A2200D7.A9BF2
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-ceifnet-smtps-1.kuleuven.be (icts-p-ceifnet-smtps.service.icts.svcd [IPv6:2a02:2c40:0:51:139::25])
	by icts-p-cavuit-3.kulnet.kuleuven.be (Postfix) with ESMTP id D99A2200D7;
	Tue,  1 Sep 2026 16:56:59 +0200 (CEST)
BCmilterd-Mark-Subject: no
BCmilterd-Errors: 
BCmilterd-Report: SA-HVU#DKIM_SIGNED#0.00,SA-HVU#DKIM_VALID_AU#0.00,SA-HVU#DKIM_VALID#0.00,SA-HVU#OURIPS#-35.00
X-CAV-Cluster: smtps
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.kuleuven.be;
	s=cav; t=1788274619;
	bh=ptRC/EYGEt+GZphk5vxeF2pgFgze7JJt6aLBjRPtaX8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JYv5sPNrRgoCf+OmO4pv80Bmzye3ok+9h7iAOoanTC/dkGy8lxw9uz36zYu/bxZP5
	 c2AhNJO9Q5VmH5/C3Hvw1TxpsaEdsaP9dN+akmyHmxRMc0H8w2McyU81Qi9WhU9GHm
	 bl8WPwWzVht97NBnBmkFD8QaSqfjV/FKtDp5WtFo=
Received: from [10.45.52.163] (unknown [10.45.52.163])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by icts-p-ceifnet-smtps-1.kuleuven.be (Postfix) with ESMTPSA id 8BE72D4B94591;
	Tue, 01 Sep 2026 16:56:59 +0200 (CEST)
Message-ID: <e9e1928a-0dbf-40da-b8d9-d19d85d914cb@cs.kuleuven.be>
Date: Tue, 1 Sep 2026 16:56:59 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dm-integrity: fix buffer overflow with keyed discard
To: Ben Cressey <ben@cressey.dev>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, Shukai Ni <shukai.ni@kuleuven.be>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Mike Snitzer <snitzer@redhat.com>,
 "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
References: <20260820-dm-integrity-discard-v1-0-196d3618d09a@cressey.dev>
 <20260820-dm-integrity-discard-v1-1-196d3618d09a@cressey.dev>
Content-Language: en-US
From: jo.vanbulck@cs.kuleuven.be
In-Reply-To: <20260820-dm-integrity-discard-v1-1-196d3618d09a@cressey.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 23:44, Ben Cressey wrote:
> Since commit 68c5c42567bc ("dm-integrity: replace forgeable discard
> filler with a keyed sector marker"), integrity_metadata computes a
> checksum for every discarded block into the "checksums" buffer.
> integrity_sector_checksum always writes the whole digest. So if the tag
> size is smaller than the digest size, the checksum of the last block
> that fits into the buffer is written past the end of it. For example,
> with hmac(sha256) and tag size 16, a 4MiB discard writes 16 bytes past
> the kmalloc'ed page.

Hi,

This initially got stuck in spam somehow. Reviewed this together with 
Shukai. Agreed this is an oversight in the original patch for the 
(unlikely) case where tag_size < digest_size.
> Fix this by subtracting extra_space from the buffer size when computing
> max_blocks, like we do for writes.

The code path is quite convoluted, but looks OK to us (and arguably more 
elegant/efficient than the alternatives, which would allocate 
digest_size local variables or allocate extra_space bytes for every 
page-sized buffer allocation).

> Fixes: 68c5c42567bc ("dm-integrity: replace forgeable discard filler with a keyed sector marker")
> Reviewed-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
> Signed-off-by: Ben Cressey <ben@cressey.dev>
> Assisted-by: Claude:unspecified
> ---
> Found with KASAN on current mainline (after the 7.3 dm merge): brd,
> "0 <n> integrity /dev/ram0 0 16 J 2 internal_hash:hmac(sha256):<key>
> allow_discards_keyed", 8MiB written, then BLKDISCARD of 4MiB:
> 
>    BUG: KASAN: slab-out-of-bounds in __hmac_sha256_final+0x1be/0x1e0
>    Write of size 4 at addr ff11000104b05000 by task kworker/0:0/9
>    Workqueue: dm-integrity-offload integrity_bio_wait
>     integrity_sector_checksum_shash+0x181/0x490
>     integrity_metadata+0x101e/0x18a0
>     dm_integrity_map_continue+0x1eb2/0x34d0
>    The buggy address is located 0 bytes to the right of
>     allocated 4096-byte region
> ---
>   drivers/md/dm-integrity.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index c50feaa98bf9e..73c1db7e55d5c 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -1980,7 +1980,7 @@ static void integrity_metadata(struct work_struct *w)
>   		if (unlikely(dio->op == REQ_OP_DISCARD)) {
>   			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
>   			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
> -			unsigned int max_blocks = max_size / ic->tag_size;
> +			unsigned int max_blocks = (max_size - extra_space) / ic->tag_size;
>   			sector_t sector = dio->range.logical_sector;
>   
>   			if (!ic->discard_keyed)
> 

