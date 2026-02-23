Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27FABBA21
	for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 05:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771825736; cv=none; b=UeTHYfgx+sHtiqnucvnwCG1BwddedI97uuwjlqtsaCv9zk+ZHtbrOmoaYhT/6109Xm+mvcBUXS9cgiQpgoPFSe2FGeCWLglVlv6D2B21zsNdGi1/K+QLniH+snLeLpt997Vv/FtkTLsVQcSn3RUVQf/wk61SXy1C/XB59IcvMtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771825736; c=relaxed/simple;
	bh=84ypK5t+74z74qwNkl3ewGPbeC0obOn7lhF8AlMS7h8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sg7eDxr7LgndS33AnH8rik4Axxi9JN6w50ArOQ1kf8aqEYsKtNdItijQJwleCjwmnafmraAONO0NMKY7BabfFXstj4k2n5qSitWnMFDROiu9pj5C2iHa5d3CQP7hd21bBn/jsI7VkaeXXJzkfes0E6DrH8a2RkkRdYAruEfOnVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91A33339;
	Sun, 22 Feb 2026 21:48:46 -0800 (PST)
Received: from [10.163.170.234] (unknown [10.163.170.234])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D1F73F7BD;
	Sun, 22 Feb 2026 21:48:49 -0800 (PST)
Message-ID: <f486ff76-7c98-4b93-985b-69cced5ba00c@arm.com>
Date: Mon, 23 Feb 2026 11:18:46 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
To: SeongJae Park <sj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Vishal Moola <vishal.moola@gmail.com>,
 Christoph Hellwig <hch@infradead.org>,
 "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
 Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
 dm-devel@lists.linux.dev
References: <20260221011952.59323-1-sj@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260221011952.59323-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 21/02/26 6:49 AM, SeongJae Park wrote:
> On Thu, 12 Feb 2026 17:33:30 +0100 (CET) Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
>> The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
>> flags") breaks the device mapper VDO target. The VDO target calls vmalloc
>> with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
>> flags.
>>
>> There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
>> let's add this flag to GFP_VMALLOC_SUPPORTED.
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
>> Fixes: 07003531e03c ("mm/vmalloc: warn on invalid vmalloc gfp flags")
>> Cc: stable@vger.kernel.org	# v6.19
> 
> Acked-by: SeongJae Park <sj@kernel.org>
> 
>>
>> ---
>>  mm/vmalloc.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> Index: linux-2.6/mm/vmalloc.c
>> ===================================================================
>> --- linux-2.6.orig/mm/vmalloc.c
>> +++ linux-2.6/mm/vmalloc.c
>> @@ -3928,6 +3928,7 @@ fail:
>>   */
>>  #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
>>  				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
>> +				__GFP_RETRY_MAYFAIL |\
>>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
>>  				GFP_USER | __GFP_NOLOCKDEP)
> 
> By the way, I think this list might better to be alphabetically sorted in

Agreed.

> future.  Obviously just a trivial and random thought that never required for
> this patch.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
