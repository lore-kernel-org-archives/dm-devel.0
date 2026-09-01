Received: from icts-p-cavspool-1.kulnet.kuleuven.be (icts-p-cavspool-1.kulnet.kuleuven.be [134.58.240.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F323D8100
	for <dm-devel@lists.linux.dev>; Tue,  1 Sep 2026 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.58.240.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788275175; cv=none; b=MJI0fy1tTZVA4XyOY1UN+maQSTXirA4nL5JNd5ldpxQQMHGjhT4Xnp/ST9TR0cJwxdRDisGlHc1vJQsOrXTnGY5en5YwVs6SJmiUbHBFVA3W4Drsyope/WyN/03w8a8+IS6fXiA1W8Fua7NIuA5aXCGRTt2+zVy2nfKEM3zPdnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788275175; c=relaxed/simple;
	bh=4EO54w5Ccp/9b+PS7lTkUkfUyBeNuGX91v3qx0P/aAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q/tNkDwltz9nWp9Ez7p0tEAqqpf2jadzIeyuPKtRcmzsu01RGVj0BMhF8T1tB9nrnwK3ZAsdYTWvd/5EGntIAi3V964KdieTOKJFLmGM5CH71XklyxmLi4Ucu2VDsK3arQbXgLqh7U/mwtN5YBdTdNaJOklT+8jb5T0DSrnRpiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.kuleuven.be; spf=pass smtp.mailfrom=cs.kuleuven.be; dkim=pass (1024-bit key) header.d=cs.kuleuven.be header.i=@cs.kuleuven.be header.b=WaVpmpWp; arc=none smtp.client-ip=134.58.240.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.kuleuven.be header.i=@cs.kuleuven.be header.b="WaVpmpWp"
Received: from icts-p-cavuit-1.kulnet.kuleuven.be (icts-p-cavuit-1.kulnet.kuleuven.be [134.58.240.132])
	by icts-p-cavspool-1.kulnet.kuleuven.be (Postfix) with ESMTP id CDBB64692
	for <dm-devel@lists.linux.dev>; Tue,  1 Sep 2026 17:06:11 +0200 (CEST)
X-KULeuven-Envelope-From: jo.vanbulck@cs.kuleuven.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: 7E18920087.A6D35
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-ceifnet-smtps-0.kuleuven.be (icts-p-ceifnet-smtps.service.icts.svcd [IPv6:2a02:2c40:0:51:132::60])
	by icts-p-cavuit-1.kulnet.kuleuven.be (Postfix) with ESMTP id 7E18920087;
	Tue,  1 Sep 2026 17:06:03 +0200 (CEST)
BCmilterd-Mark-Subject: no
BCmilterd-Errors: 
BCmilterd-Report: SA-HVU#DKIM_VALID#0.00,SA-HVU#DKIM_VALID_AU#0.00,SA-HVU#DKIM_SIGNED#0.00,SA-HVU#OURIPS#-35.00
X-CAV-Cluster: smtps
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.kuleuven.be;
	s=cav; t=1788275163;
	bh=g3UEwE7N/GmWO0B/boK718SVBjIa0B3guUqfWjymsGg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WaVpmpWpxdMl0BjpYROvjLYMnQRnJNd7Gh5PjUxa4RaGIqNwOSrmRhqHISByLI94d
	 C6kS2MyMehcXCwYzEOYoTHdZo1bEYC8aZ+rOc0UcWXs6GiNGvslzsfLApLIoNmbdVU
	 E1mHB8zsmvZ1//DYW9jGAPARUYiY54Wim1T29KtU=
Received: from [10.45.52.163] (unknown [10.45.52.163])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by icts-p-ceifnet-smtps-0.kuleuven.be (Postfix) with ESMTPSA id 29866D4BAEB23;
	Tue, 01 Sep 2026 17:06:03 +0200 (CEST)
Message-ID: <35bdf3a1-9e85-45d3-8af8-f324cc455144@cs.kuleuven.be>
Date: Tue, 1 Sep 2026 17:06:02 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SPAM?] [PATCH 2/2] dm-integrity: fix infinite loop on discard
 with large tag size
To: Ben Cressey <ben@cressey.dev>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, Shukai Ni <shukai.ni@kuleuven.be>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org,
 "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
References: <20260820-dm-integrity-discard-v1-0-196d3618d09a@cressey.dev>
 <20260820-dm-integrity-discard-v1-2-196d3618d09a@cressey.dev>
Content-Language: en-US
From: jo.vanbulck@cs.kuleuven.be
In-Reply-To: <20260820-dm-integrity-discard-v1-2-196d3618d09a@cressey.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 23:44, Ben Cressey wrote:
> When integrity_metadata handles a discard, it fills a buffer with
> DISCARD_FILLER and writes it over the tags, max_blocks blocks at a
> time. If the kmalloc fails, the buffer is the on-stack array> checksums_onstack and max_size is set to HASH_MAX_DIGESTSIZE. So if the
> tag size is larger than HASH_MAX_DIGESTSIZE, max_blocks is zero, bi_size
> is never decremented and the loop never terminates.

Seems legit (since currently HASH_MAX_DIGESTSIZE=64 and MAX_TAG_SIZE=255).

> Fix this by using sizeof(checksums_onstack) as max_size. The array has
> MAX_TAG_SIZE bytes since commit b93b6643e9b5 ("dm integrity: fix a
> crash with unusually large tag size"), so max_blocks is at least 1.

maybe say "at least MAX_TAG_SIZE bytes" (?)

> Fixes: 84597a44a9d8 ("dm integrity: add optional discard support")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
> Signed-off-by: Ben Cressey <ben@cressey.dev>
> Assisted-by: Claude:unspecified
> ---
> The natural trigger needs the kmalloc to fail, so this was tested with
> the fallback forced (a test-only hunk that frees the buffer for
> discards): J mode, internal_hash:sha256, tag_size 100, allow_discards,
> BLKDISCARD of 16 MiB. Without the fix the discard never completes and a
> dm-integrity-offload kworker spins in integrity_metadata ->
> dm_integrity_rw_tag (soft lockup with preempt=none); with the fix it
> completes immediately. This goes after 1/2; on its own it would let the
> keyed-discard fallback overflow checksums_onstack for tag sizes below
> the digest size.
> 
> For stable: 1/2 is not stable material and it changes the context line
> right above this hunk, so this patch will not apply verbatim to released
> trees. The backport is the same one-line change; I will send it in
> reply to the failed-to-apply notice.
> ---

The fix looks good, but not sure I follow the AI clutter above.

>   drivers/md/dm-integrity.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 73c1db7e55d5c..48eca96ca6d8c 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -1979,7 +1979,7 @@ static void integrity_metadata(struct work_struct *w)
>   
>   		if (unlikely(dio->op == REQ_OP_DISCARD)) {
>   			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
> -			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
> +			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : sizeof(checksums_onstack);
>   			unsigned int max_blocks = (max_size - extra_space) / ic->tag_size;
>   			sector_t sector = dio->range.logical_sector;
>   
> 

