Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330D021C9E7
	for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 14:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755268843; cv=none; b=u6eluWSF0TUnM8oNEFnxe3md4d3B7ABmiyi5/3IL0ZSvwE9mh5u+YvAH8CidO5y3LETfBBSa98tAaLNjI3ZvvgG+vKT8ONgx0DcdLma5RhJ3Iv9fI62Fngvi9PUjhh2qyBgbpkx3ZWGoN0hTXXjp7oS2++RLMvLVnn9hPz6J7pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755268843; c=relaxed/simple;
	bh=H0w07icjouMfEjqzwt8DCYzE4bzi/RRjLFWYMYXHtLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A3Dqj8Y7sROismopHzTfZRdSmjOmayW9k2XNyHUpM0hBFSoSSRfuPNt6qZR/WpvdBcYzSpMS8WZpSgzolUPLxBkQvi9q79LCxppas/sTTbi7DJSPXRU4Ki0F0BEY8/BllPhFdZqzDzYxP2mLCgndB6YhslNF9Lz1e/LLld4a85I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IPQ3kU7z; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IPQ3kU7z"
Message-ID: <d679d105-b667-45f0-befe-3fdade7f5f3e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755268837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Ojo9UFQQZHGXWjag86sfNgeSYh2wYH9/lcPsOlHTYw=;
	b=IPQ3kU7zy3RB9b58YfWFqv+09AyiVu84uKW9Z9FPV7btie/t5I6cUzWjr8fqunZ32dXhok
	gjoYfTOOub969UgUYjIkirtUkvAkn0KsT3IMEcHPASYIwE3BewvfqjY7jIJzNpPl7CHoUE
	TDKnI7wgXocEMmXE1sX7Ql/SMmcbkHM=
Date: Fri, 15 Aug 2025 22:40:27 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] dm-pcache: fix uninitialized variable issue
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 cengku@gmail.com, kernel test robot <lkp@intel.com>
References: <20250815133052.8138-1-dongsheng.yang@linux.dev>
 <9b4290c2-57c8-a2c3-f617-46b2e6c2c6af@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <9b4290c2-57c8-a2c3-f617-46b2e6c2c6af@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 8/15/2025 10:31 PM, Mikulas Patocka 写道:
>
> On Fri, 15 Aug 2025, Dongsheng Yang wrote:
>
>> The 'ret' varialbe may be returned without initialized in some branch,
>> this patch make sure it is initialized correctly with 0.
> Hi
>
> I've already fixed it (and I folded the fix into the existing commit).


Okey, thanx


Dongsheng

>
> Mikulas
>
>> Fixes: 6fb8fbbaf147 ("dm-pcache: add persistent cache target in device-mapper")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202508151712.qMqD87iI-lkp@intel.com/
>> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
>> ---
>>   drivers/md/dm-pcache/cache_dev.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/dm-pcache/cache_dev.c b/drivers/md/dm-pcache/cache_dev.c
>> index 722d7e952262..a7dafe8d35f7 100644
>> --- a/drivers/md/dm-pcache/cache_dev.c
>> +++ b/drivers/md/dm-pcache/cache_dev.c
>> @@ -21,7 +21,7 @@ static int build_vmap(struct dax_device *dax_dev, long total_pages, void **vaddr
>>   	struct page **pages;
>>   	long i = 0, chunk;
>>   	unsigned long pfn;
>> -	int ret;
>> +	int ret = 0;
>>   
>>   	pages = vmalloc_array(total_pages, sizeof(struct page *));
>>   	if (!pages)
>> -- 
>> 2.43.0
>>
