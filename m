Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF6D3DAAA8
	for <dm-devel@lists.linux.dev>; Thu,  3 Sep 2026 19:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788462403; cv=none; b=na+z56y+LnqRXyISZFah9NnWTR/Pxpm2cCdU8aBcWh/0a2UFzjSyjML7LqWIJP6R2x0Ldkqshs2Sk/FXO6fGS4rAiMkHVvdusrY/RGexQVFH+UklzbHTbdWnrI+lgkUpBLVJzgJVaK3uw7aqQD/QlvDsWZmXX4DD3UkwqcROypI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788462403; c=relaxed/simple;
	bh=fY7oQw8c3LKHlU69NMdT27cOAg14tbfxLSzOFE9RJ1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GIsOXkgd9NMGf5P3QeDAnzjHdLHTnhDGaiDA4xkr5FcZdrUTbnwPVZVaOHXNUTsoVFazbIRSf7fcrQF2SV628uwTtAdqTgYhru2o13MCr3yOKGqX+kB+RxVGZjFJWZfJSPjiemLzmjjq3Qe1w0o5WHFFV5XgtxdxPm++py+E7oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h5Fjh5/P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h5Fjh5/P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788462394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JyoPKwWPVR6am9+jaZNykBIgFNjq3alkuLbTD4euEoU=;
	b=h5Fjh5/PB/ToGTrGM8eh+JKx+HfuG3jyzsuIPT+Bzl24qJDM2BCDq3DppXEInTbbLXS/II
	Jg+/JgEzBA/05c4i2PNCzibeYnaDdueGkBsfUl5Ts5QblQvmGo9vA5Hx7juv2kjHceitau
	Dalb3iz+hIhbp0EBW5s1G49Hcrqv7ok=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-9e_hvACkOSSV5wNd5-IKNA-1; Thu, 03 Sep 2026 15:06:29 -0400
X-MC-Unique: 9e_hvACkOSSV5wNd5-IKNA-1
X-Mimecast-MFC-AGG-ID: 9e_hvACkOSSV5wNd5-IKNA_1788462389
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e820609d9so28224285a.2
        for <dm-devel@lists.linux.dev>; Thu, 03 Sep 2026 12:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788462389; x=1789067189;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JyoPKwWPVR6am9+jaZNykBIgFNjq3alkuLbTD4euEoU=;
        b=afpom0wBqgw15Gimxkm8RG/aFPlkU7u830hja9QfCE7JJrmTus/aXETPKepUtnzfwO
         Bq04ff6vtipeUqJVmf7L0Ywlzpqsl+d66uOsL+pyzq9MqfK9rFLnc0ROqhdM/PSHewun
         oaxsLi4nhtJOFFz5vDhQkbAluOu59KkVq05ria1I8zFpFqeX96iMehHHCfJJT75QyK2d
         72auFOTHW46wnhwDs4JubiDjRlajrQLBA0RXF27DZKd9xpzy8qMaDKvNEVSsoycqRtk8
         YIBEhT5N/Vciks8P3znNwq6TL43p6AsH6sZXo9cJiiu4gOnnLrRCZU7bcdpLcEUpDRmb
         8glw==
X-Forwarded-Encrypted: i=1; AKwUvBzV/yoJlb/ggSo0jnBP02rIsK5UgGMfaTGaJwKxyD4kWCxPPGJc+IWeyz4m8J5NZ0BaibrV9E/sRA==@lists.linux.dev
X-Gm-Message-State: AFuF++mMXpikK6BilADD4R86dfAA1OOH2H7aivqGrkWTQpdLbwHYtML0
	vzxQ0P73wpNwxijnLnPeQhnIOKHPN59W408lnx+fEji9DypIqmXQjIbQlLh6b8iTkIyUJ992qLs
	mkegM+zf9fHga9E8HD8DxqqZg3a05b4ONnZNIGZVc0Stj0ZnbIVGgPVrAXwuC
X-Gm-Gg: AYBFou3X5ux90heE1Qt5bmPWAbtyuO/s+tkK0Ba8cTi5knRtafq6I7Wj1mIIGkGurow
	nb5hLFJFHXV2q+I8enMWaW79PUZkBrdLASFUxtWSwx/YhEXCjzzW05OmUWP463UVVnIyqmlp+w+
	WsiLgCvqovarbwSZMJ1PwnTZmdp5VJTO8HTeSQjHgKefh+a7SN712Wkk5AsQsHhxJo7eum6fdvF
	01inrDjFa7Yxi+Iz6n4wRpbzyIsX4tj/McBVlYKhrQ5v/6ngCnEBIjkBCA/RorJ6JRMhYR6AERy
	CmhTl4/psLkefRZFmlFjfuHaMTIIbDto4eI8RIj4IOWeIksrLNfehgeS5mkGLuTCNdBICyelnq2
	ZFclOXHC7ipo71jglvpZXzrEIKEf2PWxozK5S87g0HCD7bp1R
X-Received: by 2002:a05:620a:394b:b0:939:1459:efb2 with SMTP id af79cd13be357-939804008ffmr68370085a.24.1788462388852;
        Thu, 03 Sep 2026 12:06:28 -0700 (PDT)
X-Received: by 2002:a05:620a:394b:b0:939:1459:efb2 with SMTP id af79cd13be357-939804008ffmr68360185a.24.1788462388230;
        Thu, 03 Sep 2026 12:06:28 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:b400:d348:ae32:97a6:8a0d? ([2600:4040:530f:b400:d348:ae32:97a6:8a0d])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406496e5sm1340806d6.11.2026.09.03.12.06.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 12:06:27 -0700 (PDT)
Message-ID: <1d2cd544-97a6-4ddd-8758-048bbd104eb5@redhat.com>
Date: Thu, 3 Sep 2026 15:06:27 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] dm vdo: Fix spelling mistake "postive" ->
 "positive"
To: Colin Ian King <colin.i.king@gmail.com>, dm-devel@lists.linux.dev
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260903152325.16304-1-colin.i.king@gmail.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20260903152325.16304-1-colin.i.king@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: l2EMlxZSJyoO0sn_8DVgnaBIwqOMRPz4AzvDFwIJzlc_1788462389
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I had to look at this for quite a while to figure out what was going on.
We made the same spelling error twice in the same function and somehow 
only noticed the first one previously? Anyway,

Reviewed-by: Matthew Sakai <msakai@redhat.com>

On 9/3/26 11:23 AM, Colin Ian King wrote:
> There is another spelling mistake in a vdo_log_error message that
> I somehow overlooked last time. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>   drivers/md/dm-vdo/dm-vdo-target.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
> index 1d8375cc3c3e..043549b1fc2e 100644
> --- a/drivers/md/dm-vdo/dm-vdo-target.c
> +++ b/drivers/md/dm-vdo/dm-vdo-target.c
> @@ -443,7 +443,7 @@ static int __must_check parse_slab_size(const char *slab_str, block_count_t *sla
>   
>   	result = kstrtoull(slab_str, 10, &value);
>   	if (result) {
> -		vdo_log_error("optional parameter error: invalid slab size, must be a postive integer");
> +		vdo_log_error("optional parameter error: invalid slab size, must be a positive integer");
>   		return -EINVAL;
>   	}
>   

