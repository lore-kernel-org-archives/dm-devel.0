Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4645E2877DA
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 10:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756462172; cv=none; b=Ot3ybcqv3gxM9khn7uTVBH+l7NcY3HjigFXltFxXOglNJYyjxtr2lqlXcX5QEszAzb4kWmK9nNV0rL/MMD0BtW8kqJyE4z9Lg+Kdy/UGea9TgpHBMnFKIYsXLBwqieqqOVNSMdE7GqwfBKB64oKRzmR8Iq8RVYCPrio3xKE+JCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756462172; c=relaxed/simple;
	bh=uDyCK8SksMKh7pDnLhsTnZFuiOvP2raSsxM09c3H+hs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jd41Co7syhLLyJ7C0aLjHBvCnr7XdQ7MheY47VGG7ajPt5DfPmh4+ksjlo+ykzi9lZBA7A5gK0+8TK26GCjX1Jy13P8aMH0Pn41ohWnG8bBPlDF+zIE2bipQPtaKf5qHQY7JAHwZJ/feWpGJUsUWiwKJV65O4d2Xq4MyfWMSRrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VG1w4kAG; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VG1w4kAG"
Message-ID: <c6ac00dd-8356-4402-b68c-79660c751a4e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756462166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2NWWus5uJkW9dCxAZdtgZJDSUg3EZ2UUoRHBU9B/1sk=;
	b=VG1w4kAGS/Pw2Ir8ywtTjKr4SgoED0OVErFXCc6KF17TBEsoSR1jxjRY+sgUErXq+Z5a6H
	Pf21z5mEu2YEUAP4kYNmK9b3WRWzRd6hLD+AKmRlJfK+vMF4dhbUWV+ipnZLbvgUeWGjEI
	CYEEdxaHiYpH7b0wkwzEFkhvDsYzyDo=
Date: Fri, 29 Aug 2025 18:09:14 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [bug report] dm-pcache: add persistent cache target in
 device-mapper
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: dm-devel@lists.linux.dev
References: <aLE9JjiTzKmeKzsN@stanley.mountain>
 <824ba1cc-be92-47ae-9b81-a7e94f600010@linux.dev>
 <aLFvdA9clSu_i-DC@stanley.mountain>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <aLFvdA9clSu_i-DC@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 8/29/2025 5:14 PM, Dan Carpenter 写道:
> On Fri, Aug 29, 2025 at 02:03:36PM +0800, Dongsheng Yang wrote:
>> 在 8/29/2025 1:39 PM, Dan Carpenter 写道:
>>> Hello Dongsheng Yang,
>>>
>>> Commit 1d57628ff95b ("dm-pcache: add persistent cache target in
>>> device-mapper") from Aug 12, 2025 (linux-next), leads to the
>>> following Smatch static checker warning:
>>>
>>> 	drivers/md/dm-pcache/cache_segment.c:263 cache_seg_gen_increase()
>>> 	warn: sleeping in atomic context
>>
>> Hi Dan,
>>
>>      Thanx for your report, I will send out the patch after my testing
>> finished.
>>
>> BTW, can you share the Smatch checking command or script? I want to add
>>
>> Smatch check in my testing suit if possible, I did not found this kind of
>> problem with simple:
>>
>> make CHECK="smatch -p=kernel" C=1 M=drivers/md/dm-pcache
>>
> It requires several rebuilds of the cross function database...  Everytime
> you rebuild then it does:
>
> First build: cache_data_alloc() disables preemption calls cache_seg_put()
> Second build: cache_seg_put() calls cache_seg_invalidate()
> Third build: cache_seg_invalidate() calls cache_seg_gen_increase()
>
> Rebuilding the databse takes hours and hours.
>
> ~/path/to/smatch/smatch_scripts/build_kernel_data.sh


Thanx for  your share, I will give it a try, it seems really found issue 
I did not hit in my testing.

>
> regards,
> dan carpenter
>
