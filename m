Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDF022A7F9
	for <dm-devel@lists.linux.dev>; Wed,  3 Dec 2025 23:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764805137; cv=none; b=DF3VC8k0jWPbevLmai4DXMtFAOqvj0bg710wBGChWToHOa29i4wiXMe1YrNsfi9HJEJ3Ydu9mtU+Dd7fbT892lgYgbzG8JTC9rMF05UuDLIz/rIlregOnMnRybTf8GIuQK0X7YrB8axMTcB46LFTIeGniwx0HP5m53p4EqyvGIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764805137; c=relaxed/simple;
	bh=h2G0jDCCqTcj18LxdkD6lfRw+vljM+sUTuQCA7ji0g0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=r1do0uaPvWVk4QmAfPsUaHlkoooGNhZTVxd5zcVF9cAqP1DbdG6Y5NMO1KDynlT/lh7EsxonkUAEemM+jOxQmqQoJAr97yf2iBhDuFf/3MgEkYscN2qVJXwBzUncxU+DmknfMjCvkXVzbUhtTEuGqILqFb/s4u4RTE3xs5mUqR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nbjnJsrM; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nbjnJsrM"
Message-ID: <5dd45085-1135-4897-91b1-986b72a99376@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764805132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lEdSVyG8rViy5s5Gc+SzWwLvVqtRy02go6DClroG9XA=;
	b=nbjnJsrMcN6vF/mknqMoTggQRKIPqhOaPIVxo2o1orv686PEBPGJhk6tActd8zD65IiOVd
	WptuJRvGsZISw0zbqSgGPBIUEzaSihmN6y6aDULrh40nWXcA18mkSrAl6MbEqGlMq/UE3x
	9aOKWWeRrw2bEyvZjOrTUoFsSU9RHyU=
Date: Thu, 4 Dec 2025 07:38:46 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] dm pcache: fix cache info indexing
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: Li Chen <me@linux.beauty>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Zheng Gu <cengku@gmail.com>
References: <20251202121158.111092-1-me@linux.beauty>
 <20251202121158.111092-2-me@linux.beauty>
 <3222d76f-3710-4238-b90e-cd1deb0d0912@linux.dev>
In-Reply-To: <3222d76f-3710-4238-b90e-cd1deb0d0912@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 12/3/2025 1:56 PM, Dongsheng Yang 写道:
>
> 在 12/2/2025 8:11 PM, Li Chen 写道:
>> From: Li Chen <chenl311@chinatelecom.cn>

>>
>
>> +        int index = ((char *)cache_info_addr - (char 
>> *)cache->cache_info_addr) /
>> +                PCACHE_CACHE_INFO_SIZE;
>> +
>> +        cache->info_index = (index + 1) % PCACHE_META_INDEX_MAX;
>
>
> Don't advance info_index at init stage, cache->info_index means the 
> current index, not the next index.
>
> It will be advanced in cache_info_write() after write cache_info into 
> next slot.


My bad, ->info_index means next slot, so advance it is correct.

>
> In addition, cache->info_index initialization should be after the 
> data_crc checking.
>
> Thanx
>
>> +
>>           if (opts->data_crc !=
>>                   (cache->cache_info.flags & 
>> PCACHE_CACHE_FLAGS_DATA_CRC)) {
>>               pcache_dev_err(pcache, "invalid option for data_crc: 
>> %s, expected: %s",
>
