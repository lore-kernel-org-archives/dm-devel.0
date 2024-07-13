Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA13125B9
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 01:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720835055; cv=none; b=h+G7W30CF3tcLXgc+XxOjUIa0oj3VoTYOB0A1IZz7VWNOt65O72Om/uuOvua4E7bbLaTskzwEuwEa5CDktXkLd702XDcwVzUB1XoMCvcYxq+WNkrxfRgAXKfwoz6vR5QoHa8snNhsOcJPStAmyYbdWxnXmC6QOPRL6aTEbbUdAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720835055; c=relaxed/simple;
	bh=cMS132SjjkcvgUC/IbODbtO5BZHytJaOS+bcJ5C5W0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pj66sYntlSMNP/eVKo/dwceWI/r45t9tV6hZkWsAOzr56UlRUHl+Tnzwk9xmXyYRvbALrQ1UrLQMSDMhP11A1Urkf5xojJ6h2gDOlmZc8XwYO8GOPqmDMPmwFe1Od57yxNKs8jajfmuCs3y5/8aJSJdh+VLzUvK+VzLzARRTwiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dQYFy44A; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dQYFy44A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720835052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0/LhhK/MwVuJD8RiThdnCHgpX/mf8B6TT8D7Me4aER4=;
	b=dQYFy44AtZlmvDFZsZdYqxU3KELumicpaF3XjFuZVa8MIMBG8NFQx9V8uvQbq2M8OrP8uS
	miVq8NCcif1TTmBM/SIxrQh7DeqBPe3l1dIp6li29H6v1VY+4HoTl7R4wy/RaOa5ZtzW6r
	PabL7mOqksdPhHrxLu4IMnswowp/GmE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-ei0zcPELMZCTTfCR8ZVVPw-1; Fri, 12 Jul 2024 21:44:08 -0400
X-MC-Unique: ei0zcPELMZCTTfCR8ZVVPw-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-79f1d37915dso587754185a.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 18:44:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720835048; x=1721439848;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0/LhhK/MwVuJD8RiThdnCHgpX/mf8B6TT8D7Me4aER4=;
        b=ahjFxb6ubbYRfMDXKHmn9dfcgFlvhkGE9POlmqqM94yhK7FMInR368f+lxYxpt9pc9
         00O2sm6DyEZvNbTLWr8FBIreoFqOLJjTvNbA3WsjIinHjtzLmGbilrw2gfXUSc/fkRN3
         vmpLhCSiKNmcTtAMDX4qNVkWh1jyDd4WrQZS/m55Ok7FhBct591oHNepz+jbfRmnlVKk
         YP1RQ0EMi+LzeCmOvMMwCCtFzlqwWO7NrBUBKbY4iwUpZ23ky4PWyEDWX5s75F1ej5Rw
         psKNqoupy4MXyHIcek3aDGAb3QCJ9GdI1HKGOZW/k9wJlanq6bwxYIXWcFKISgnPBUB3
         7cRw==
X-Gm-Message-State: AOJu0Yw4ssupusoL2o6jQwBtFKoE+voy8E/3WHhB9Cn5s16ExJ7/+8ok
	CPm7PWB+uRlzYd/31x0dYyF1H5cXrqrbVKUtEnXYkEK94+kop6/e4XG2WsvUQA5SewS0S9WP7/n
	asY1etVyjMZHPoKCxmVy133PFtKUYsq9mVAZ9dTmrKcs0E+j3XNrhPOZW
X-Received: by 2002:a05:620a:20d7:b0:79f:18f1:b6e6 with SMTP id af79cd13be357-7a1532396c7mr732063485a.10.1720835047809;
        Fri, 12 Jul 2024 18:44:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVZbfN6peH6kN+PL0CZNMjAxwclgghCFzJx1D7VF9wunqpfTLj5X0f0K+y4iKa1Tv/U9MsCQ==
X-Received: by 2002:a05:620a:20d7:b0:79f:18f1:b6e6 with SMTP id af79cd13be357-7a1532396c7mr732062385a.10.1720835047497;
        Fri, 12 Jul 2024 18:44:07 -0700 (PDT)
Received: from [192.168.1.152] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a160c736d3sm8477785a.119.2024.07.12.18.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 18:44:07 -0700 (PDT)
Message-ID: <ac7a0dbe-e00f-cf61-e6fe-bf5875d4a04f@redhat.com>
Date: Fri, 12 Jul 2024 21:44:05 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH -next] dm: vdo: Add missing kernel-doc function comments.
To: Yang Li <yang.lee@linux.alibaba.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Abaci Robot <abaci@linux.alibaba.com>
References: <20240712081204.79723-1-yang.lee@linux.alibaba.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20240712081204.79723-1-yang.lee@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/12/24 04:12, Yang Li wrote:
> Add missing kernel-doc function comments to enhance code readability and
> maintainability in accordance with the kernel coding standards.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9518
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

I appreciate the patch, but some of these descriptions are not correct.
You can fix the patch if you'd like, or I can create a patch my self to 
add these kernel-doc comments.

Matt Sakai

> ---
>   drivers/md/dm-vdo/repair.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
> index ff09e4a14333..8947e6092a91 100644
> --- a/drivers/md/dm-vdo/repair.c
> +++ b/drivers/md/dm-vdo/repair.c
> @@ -319,6 +319,7 @@ static bool __must_check abort_on_error(int result, struct repair_completion *re
>   /**
>    * drain_slab_depot() - Flush out all dirty refcounts blocks now that they have been rebuilt or
>    *                      recovered.
> + * @completion: The completion to convert.

This is the repair completion. There is nothing being converted here.

>    */
>   static void drain_slab_depot(struct vdo_completion *completion)
>   {
> @@ -656,6 +657,7 @@ static void rebuild_reference_counts(struct vdo_completion *completion)
>   
>   /**
>    * increment_recovery_point() - Move the given recovery point forward by one entry.
> + * @point: The location of the next recovery journal entry to apply.

This is the recovery point to increment. It is not the "next" entry, and 
this function doesn't care what the caller will use the recovery point for.

>    */
>   static void increment_recovery_point(struct recovery_point *point)
>   {
> @@ -953,6 +955,7 @@ static void abort_block_map_recovery(struct repair_completion *repair, int resul
>   /**
>    * find_entry_starting_next_page() - Find the first journal entry after a given entry which is not
>    *                                   on the same block map page.
> + * @repair: The repair completion.
>    * @current_entry: The entry to search from.
>    * @needs_sort: Whether sorting is needed to proceed.
>    *
> @@ -1219,6 +1222,7 @@ static bool __must_check is_exact_recovery_journal_block(const struct recovery_j
>   
>   /**
>    * find_recovery_journal_head_and_tail() - Find the tail and head of the journal.
> + * @repair: The repair completion.
>    *
>    * Return: True if there were valid journal blocks.
>    */
> @@ -1447,6 +1451,7 @@ static int validate_heads(struct repair_completion *repair)
>   
>   /**
>    * extract_new_mappings() - Find all valid new mappings to be applied to the block map.
> + * @repair: The repair completion.
>    *
>    * The mappings are extracted from the journal and stored in a sortable array so that all of the
>    * mappings to be applied to a given block map page can be done in a single page fetch.
> @@ -1501,6 +1506,7 @@ static int extract_new_mappings(struct repair_completion *repair)
>   /**
>    * compute_usages() - Compute the lbns in use and block map data blocks counts from the tail of
>    *                    the journal.
> + * @repair: The repair completion.
>    */
>   static noinline int compute_usages(struct repair_completion *repair)
>   {

