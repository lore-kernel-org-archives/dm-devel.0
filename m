Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EC522324
	for <dm-devel@lists.linux.dev>; Wed, 29 May 2024 02:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716948030; cv=none; b=TFSktPcZtGfvq9U+F4cTUpLhWab+XNX4zuP4zq9E9nYLCZOc6C8uLtDdcnMNugTqM0etYQqpQhtFDPu2Bi6NIXVeo6IaoCcl4nUq/IyGJlsIn5oEwMImgurFDgLMoCXm1hHeUu2OaAbIxReRqPOYlca+WRdjwgH29xwQ1PprUsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716948030; c=relaxed/simple;
	bh=1q1tCShYiNmiz3QmxyaKlUD5m6tjnboeasn8VoDi/6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWC84Dc62vu2Ll2Sf3DDzjn2ItbiCNSAx2/uveMhugbXI0W6Sq3wOMAEM3oDVliX9OHMpnL9UMTQgWfzmlc+FbA72OufbjhufSLUJ4MCHc34US+HH2xAnSN2i42BoTNRrhAmLBzn+XGdsTj/KU/EBbrd2+GwXHilbw4RcRm/2ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d0SjqMna; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d0SjqMna"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716948026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7IJ2FBrWGqchGLvqswCTBuy+BPhnPSfu4z6uyGfELVY=;
	b=d0SjqMna73qxI6W/wIEyy8VO6+248neSJHHGwWZwOb9Hp/tS+WROxQy92uYpORFTe5dPSR
	FxAcWoZwPhu0VE2LAmO4uYEjqsFXaZMmigDRvF3F8b9yr8l+BnLQ2j9JikWiH5REPAXg5s
	Hg9RGpnhE2g2HKcdLFVB1+fn2kpba5Q=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-w42JSqVWN5u_wn7YYXGf6Q-1; Tue, 28 May 2024 22:00:24 -0400
X-MC-Unique: w42JSqVWN5u_wn7YYXGf6Q-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6ad7b2f6933so14366186d6.0
        for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 19:00:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716948024; x=1717552824;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7IJ2FBrWGqchGLvqswCTBuy+BPhnPSfu4z6uyGfELVY=;
        b=S71bv61G4kdviCrP6CGlTWtMpJgckrXlH2jsc79Knsqz6HZuFalpzX9yeAXaYDYuQB
         iXh3jdaG9ibf1aPQRsAKm4BMAMwYWXmN314Ap1uus/Xsa/q49lHzQuWD06w27wLQLoaa
         HXMeHuj0q1Ht1zQeP9dgLAo7wLoQdfCicFh2/o4fC1qfwO7PaPh2YpRiibOBp8k6I/1W
         t/ONAQ6R5ungpjXxvNhl/WWesdoswWFDZVoUIfPn8oacJaH+LiNbSc8Efj95j2pRus2O
         sfAIvPUin1AZSonOlF1V6GNLswjjQQpZ2HGHWYSYTrisLtSYXwkH0Jdw/dAKVPmumekO
         Mbpg==
X-Gm-Message-State: AOJu0Yy2nt8OaNpcy257v5v7mbYihdcYKb5pXp7fmYjnr1Y0Q/5C0dM8
	Mf5YhZd2mP0i24XLKSu9KhUiELhzHB8d22PHaIwshZMR/eNSb53zIKF31u/i6AvAeUvWi7RLbaA
	AG+P47BLw+IWi2aAG0matwOXo9xAgsjkucuTMaSLugMPqpZ6QHrXCoZ2lbzVpQxBe4Cg=
X-Received: by 2002:a05:6214:5988:b0:6ab:1b6b:c8ba with SMTP id 6a1803df08f44-6abc7a9f3famr154298236d6.1.1716948024233;
        Tue, 28 May 2024 19:00:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIqWMtUS4LMCQMI46PFt7oF6eIakE+BnJJ45NfXiWEsWFHSAaiN+W3QyLy0HZkGaVGZVH0tw==
X-Received: by 2002:a05:6214:5988:b0:6ab:1b6b:c8ba with SMTP id 6a1803df08f44-6abc7a9f3famr154297036d6.1.1716948022387;
        Tue, 28 May 2024 19:00:22 -0700 (PDT)
Received: from [192.168.1.175] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ac162ef448sm49771756d6.97.2024.05.28.19.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 19:00:21 -0700 (PDT)
Message-ID: <a1ceff08-164f-d0b4-36b6-41a7798b82be@redhat.com>
Date: Tue, 28 May 2024 22:00:21 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] dm vdo indexer: Use swap() instead of open coding it
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Abaci Robot <abaci@linux.alibaba.com>, Mike Snitzer <snitzer@kernel.org>
References: <20240524074109.13433-1-jiapeng.chong@linux.alibaba.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20240524074109.13433-1-jiapeng.chong@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/24/24 03:41, Jiapeng Chong wrote:
> Swap is a function interface that provides exchange function. To avoid
> code duplication, we can use swap function.
> 
> ./drivers/md/dm-vdo/indexer/index.c:207:43-44: WARNING opportunity for swap().
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9173
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Matthew Sakai <msakai@redhat.com>

Mike, can you make sure this gets applied with the rest of the pending 
dm patches?

> ---
>   drivers/md/dm-vdo/indexer/index.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-vdo/indexer/index.c b/drivers/md/dm-vdo/indexer/index.c
> index 1ba767144426..df4934846244 100644
> --- a/drivers/md/dm-vdo/indexer/index.c
> +++ b/drivers/md/dm-vdo/indexer/index.c
> @@ -197,15 +197,12 @@ static int finish_previous_chapter(struct uds_index *index, u64 current_chapter_
>   static int swap_open_chapter(struct index_zone *zone)
>   {
>   	int result;
> -	struct open_chapter_zone *temporary_chapter;
>   
>   	result = finish_previous_chapter(zone->index, zone->newest_virtual_chapter);
>   	if (result != UDS_SUCCESS)
>   		return result;
>   
> -	temporary_chapter = zone->open_chapter;
> -	zone->open_chapter = zone->writing_chapter;
> -	zone->writing_chapter = temporary_chapter;
> +	swap(zone->open_chapter, zone->writing_chapter);
>   	return UDS_SUCCESS;
>   }
>   

