Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2AE1A3AB7
	for <dm-devel@lists.linux.dev>; Thu,  3 Oct 2024 15:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727970192; cv=none; b=aB6+xL+QCXE/uXpK2NkgyFy9Pw2otv2wqGYV1He8AFhnW9jAnjIkXqKe8h+beZOt63E2LBO6b9V5CfdGCewPt0j/d9q5Bkrr30KiEuT096jUKj7xIJ94KGJoTNImMrfZz4n7TIRhht7dbW2XXB6aKrxasIXysp1BNW/NR6csT9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727970192; c=relaxed/simple;
	bh=3thy6fYLE1XrZlk8CwbAZRJK/EBujv0/7YIVTHt9QmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cQCjRJDifmk/VchSu7UKr+4DTch4adNQBqNF5Tbr923oFgb8XmsSHSccRhXs9ZA1WSRIKDH70ZT3lFpiW6LJdSrXCViCSrZFgPOYBQdZTeJc/2bWKHsBLEgZ+QqVAROSvSalDsFH5xpkGRLWcQrZt+2kBJRDEB/WTEMedRUJKxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iy/j0x64; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iy/j0x64"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727970188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sKwfG7LI5xbJlyd4LReKRmAkPjHtixJufHf0iofjNso=;
	b=iy/j0x64FugYjdRnDgIU1rEtfJXw6xNvLjYeq5VMuG3TkcRynqxv0WjkevCip4w5bTKD8S
	Ve+VUSW19HPTDLXLq3WwCgL4xmDTrTb3FPAqTIR1OoI5gUnfZ+F5jr/F4f9esiXezSLtm8
	4mE9lBDHSyco8hKS1StV8V9S8KWdsPs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573--Z42y9nYONmWUXIFrAPdNA-1; Thu, 03 Oct 2024 11:43:07 -0400
X-MC-Unique: -Z42y9nYONmWUXIFrAPdNA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7a99fdae7bbso198235585a.3
        for <dm-devel@lists.linux.dev>; Thu, 03 Oct 2024 08:43:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727970187; x=1728574987;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sKwfG7LI5xbJlyd4LReKRmAkPjHtixJufHf0iofjNso=;
        b=jmXl8ohfNxOUjdPmuF0+aviwIWWdQf0CbWpHId8QTzwjMhvNmmPc9IBPD+I785LlK0
         Yv1Oycj+RP0pg+bezyPn2oHSa0IgJPkxvFg0RZJUafo0sN+ZiANFwGp0XoDcLN2ywHlk
         9ky5AK3Ifuig61K6R2R5cpALDMVmUURtwb6sqv4rzUFFnLjjmpWSlEEK312BN/BTAjDu
         j7dUAE9rzAfbwiO5xxAHewTkR6boM43njvVV7MTI5z3+FiL2yb9Fan9kINEIYY/t+cbr
         OsraNJrUKbd5gskPhT8WAacXeKLCOquK66mp8AeevOqHzDX+8bJYJbXHquohM4A1TJaS
         utUQ==
X-Gm-Message-State: AOJu0YwMzzMPktjHQdafzmQ7HgY7kopGCoinkUbM5/Ys6+6JzAW6Qi/i
	ooR8xsgL3Y6+sghm1ChuWZ6KXI09gbSLPEvtvqmm7raRi8LNZXU9uIG0a0aT+D2/tfbfNdhxzfv
	sb4/vdZbbsEiI0dJ4CBfkZMBRzKx8Wbt2pjph/anT9bSSA4PNZzxIud7I
X-Received: by 2002:a05:620a:4154:b0:7a9:ccbd:36f5 with SMTP id af79cd13be357-7ae626ac37bmr1024510585a.13.1727970187369;
        Thu, 03 Oct 2024 08:43:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExDXfHv4ql/VsRehAef9jA9CVotUtBYFlZaiom3PTW8LpTFLLM0SHcKrOX7MMcPdTOVQHW7Q==
X-Received: by 2002:a05:620a:4154:b0:7a9:ccbd:36f5 with SMTP id af79cd13be357-7ae626ac37bmr1024508285a.13.1727970187048;
        Thu, 03 Oct 2024 08:43:07 -0700 (PDT)
Received: from [192.168.1.165] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae6b29e1eesm60775485a.27.2024.10.03.08.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2024 08:43:06 -0700 (PDT)
Message-ID: <030fa38b-5dd4-4a8c-acac-a4821a11dfbd@redhat.com>
Date: Thu, 3 Oct 2024 11:43:06 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] dm vdo: Remove unused functions
To: linux@treblig.org, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241003011554.266654-1-linux@treblig.org>
 <20241003011554.266654-9-linux@treblig.org>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20241003011554.266654-9-linux@treblig.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/2/24 9:15 PM, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> get_data_vio_pool_active_discards()
> get_data_vio_pool_discard_limit()
> get_data_vio_pool_maximum_discards()
> set_data_vio_pool_discard_limit()
> 
> are all unused since commit
> a9da0fb6d8c6 ("dm vdo: remove all sysfs interfaces")
> 
> Remove them.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Reviewed-by: Matthew Sakai <msakai@redhat.com>

> ---
>   drivers/md/dm-vdo/data-vio.c | 29 -----------------------------
>   drivers/md/dm-vdo/data-vio.h |  5 -----
>   2 files changed, 34 deletions(-)
> 
> diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
> index 0d502f6a86ad..2b489e37538e 100644
> --- a/drivers/md/dm-vdo/data-vio.c
> +++ b/drivers/md/dm-vdo/data-vio.c
> @@ -1074,35 +1074,6 @@ void dump_data_vio_pool(struct data_vio_pool *pool, bool dump_vios)
>   	spin_unlock(&pool->lock);
>   }
>   
> -data_vio_count_t get_data_vio_pool_active_discards(struct data_vio_pool *pool)
> -{
> -	return READ_ONCE(pool->discard_limiter.busy);
> -}
> -
> -data_vio_count_t get_data_vio_pool_discard_limit(struct data_vio_pool *pool)
> -{
> -	return READ_ONCE(pool->discard_limiter.limit);
> -}
> -
> -data_vio_count_t get_data_vio_pool_maximum_discards(struct data_vio_pool *pool)
> -{
> -	return READ_ONCE(pool->discard_limiter.max_busy);
> -}
> -
> -int set_data_vio_pool_discard_limit(struct data_vio_pool *pool, data_vio_count_t limit)
> -{
> -	if (get_data_vio_pool_request_limit(pool) < limit) {
> -		// The discard limit may not be higher than the data_vio limit.
> -		return -EINVAL;
> -	}
> -
> -	spin_lock(&pool->lock);
> -	pool->discard_limiter.limit = limit;
> -	spin_unlock(&pool->lock);
> -
> -	return VDO_SUCCESS;
> -}
> -
>   data_vio_count_t get_data_vio_pool_active_requests(struct data_vio_pool *pool)
>   {
>   	return READ_ONCE(pool->limiter.busy);
> diff --git a/drivers/md/dm-vdo/data-vio.h b/drivers/md/dm-vdo/data-vio.h
> index 25926b6cd98b..067b983bb291 100644
> --- a/drivers/md/dm-vdo/data-vio.h
> +++ b/drivers/md/dm-vdo/data-vio.h
> @@ -336,11 +336,6 @@ void drain_data_vio_pool(struct data_vio_pool *pool, struct vdo_completion *comp
>   void resume_data_vio_pool(struct data_vio_pool *pool, struct vdo_completion *completion);
>   
>   void dump_data_vio_pool(struct data_vio_pool *pool, bool dump_vios);
> -data_vio_count_t get_data_vio_pool_active_discards(struct data_vio_pool *pool);
> -data_vio_count_t get_data_vio_pool_discard_limit(struct data_vio_pool *pool);
> -data_vio_count_t get_data_vio_pool_maximum_discards(struct data_vio_pool *pool);
> -int __must_check set_data_vio_pool_discard_limit(struct data_vio_pool *pool,
> -						 data_vio_count_t limit);
>   data_vio_count_t get_data_vio_pool_active_requests(struct data_vio_pool *pool);
>   data_vio_count_t get_data_vio_pool_request_limit(struct data_vio_pool *pool);
>   data_vio_count_t get_data_vio_pool_maximum_requests(struct data_vio_pool *pool);

