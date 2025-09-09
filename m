Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59AA33437D
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 18:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757444296; cv=none; b=dMJSuW+Em9LOoCA3huU8SpRZas95RKXd3vMkyRkLMZh6vw+3ig7LGlETXz6imfTgAR+hnkCimoNyBgUy+Ti0wR6iKyRn+gVivXylJd33vTU/vf3YTVqJoGXTE8gRLzfZtU+S00Qgs8y8cOY3VZWjvB8ekpt1x61/pcfyBPgvo3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757444296; c=relaxed/simple;
	bh=yAU1xs4OMymWHOKYKdpxggNYhkm00IDst2AdLJtu3nI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QbK17nwRnqJzo0weG/wZrFBfTuk2Mxb7OFpy2lyTb0my1iAz4QF2oTJtKC4bK1o8W25AFa0OqaAOan9WHgdeIcF/Jrn3R0yymaKz0uw+DZEIZhJCj5A9zL4nNVcdZPGYYcwhN58Jg+ar8YExaDOe2R5wz/nN9sESZa78OibTWXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KhaElix8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KhaElix8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757444292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tEeTKl2Am8ceYqmZeJXkbvM2lrOEYBAJICAMqquNxT8=;
	b=KhaElix8GRkh2YfSzfMpvGuw1RdR1u/Vhu3OEhjxJ6GdzFRNtvphkBf2MEnfRd6aH+2yx4
	MY9ZskqJbCBmU2wsy967gfcoSF2jH8aOXQWQ1m1kdK//iczgfg0owdMV1EFEaoZLBiPO2s
	v59bPJgqtSON5Mi7RBXvJ0RSjLKHu8s=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-peOqEuObM2G1xMUeZyQrvg-1; Tue, 09 Sep 2025 14:58:11 -0400
X-MC-Unique: peOqEuObM2G1xMUeZyQrvg-1
X-Mimecast-MFC-AGG-ID: peOqEuObM2G1xMUeZyQrvg_1757444291
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-7224cb09e84so129003196d6.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Sep 2025 11:58:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757444291; x=1758049091;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tEeTKl2Am8ceYqmZeJXkbvM2lrOEYBAJICAMqquNxT8=;
        b=g37g8hInSP77S1oWY3BrFYbDR+abjOIzNFZJdzpoXhIZaA7/Tpi64i00fvZDtOA3Qr
         6KFI9FJ6R9fW5H3D2ZgSRW0ENUD+JkY3/nJMZedRIHBZA5+C3rusmolukmsNYMUT37rp
         tX/pMVAhKZplhdRPHdMs2KgLL2ibItYpoOinqs9jhCurL631Pw2V8PG3KvoeO1463RtX
         4fJOu8rC5zH8lCsbeDnGU1p5bwcmvMR5TQTFni2hZpjz07a6Nz3sXQmkaWmqsSvZcDR8
         u4mQo+qtcG4YcsPZzo1sPpkEbH/jtdHVQZ6HRQvQVa6PHpRYfeKT4wJTMLLR6KTZI9w0
         DZIw==
X-Gm-Message-State: AOJu0YxXagfWNBtniTMnng95oWMIyDHACPWJdcb6bWrhPy/AV91iloJg
	ldU/9AtCcCX0bQeYTUNupMggUaquiI4RLYZqncaavMijVbvmtHb08f+km/6/OOubBL3fVZxLVJa
	lufkBRZHhjLNnT9R4QjKWwgXfFZ/RCX4Hx+kaUSjSdRPE7+f/ZIza42bilJvP
X-Gm-Gg: ASbGncsiKlp7ItPUWMeNklS3yoIHDQGbwHGRuPOIvH2SJ2R4sfEWmfy2OpcfogSCWuH
	JPZegIys00IFSmFzVepC10hVzsTZVnbYHRN1UVSm57cS4wNAl+de3FnCs3slUQf9hdopswrBFVM
	q/MHLxdgD2sBD1gmYe5chd09opAJ7pMPUBk3Z3L6+qnA1ZEOWiRXovHzrs8bjrRPUvLu5itk7Hc
	uA5XNR7CGha9ypfuYZaWH9O1Q/R2a0RhCT+CdjOFvkGZcpkORAXxmg893ZLIzysBtR0AkKBlDU1
	HoIA1DuW6rgHkhUCAVPrjszaYQVOoRw5jMjo8N3SWrMLs13PV+pKLXfy9JCoDZZ4tK+OjZJbYz1
	AqIWCyzSJHdnI
X-Received: by 2002:ad4:5fc5:0:b0:707:6cf8:5963 with SMTP id 6a1803df08f44-72bbf3fb0b1mr167451186d6.9.1757444290719;
        Tue, 09 Sep 2025 11:58:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhF+OsEgNK7/8p/dRDiQRMr/orPC3+MXuUsFgulrWFnDz5gzikw27aQ/Tlem1vSIuP46h3SA==
X-Received: by 2002:ad4:5fc5:0:b0:707:6cf8:5963 with SMTP id 6a1803df08f44-72bbf3fb0b1mr167450966d6.9.1757444290315;
        Tue, 09 Sep 2025 11:58:10 -0700 (PDT)
Received: from ?IPV6:2600:4040:5308:eb00:a77e:fec5:d269:f23e? ([2600:4040:5308:eb00:a77e:fec5:d269:f23e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-720ada83b25sm146538706d6.27.2025.09.09.11.58.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 11:58:09 -0700 (PDT)
Message-ID: <340645fa-5c6b-4b28-bd56-63088d4705da@redhat.com>
Date: Tue, 9 Sep 2025 14:58:09 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] dm-vdo: Refactor VDO_ASSERT usage in
 start_restoring_volume functions
To: Ivan Abramov <i.abramov@mt-integration.ru>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
References: <20250908222410.223574-1-i.abramov@mt-integration.ru>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20250908222410.223574-1-i.abramov@mt-integration.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GegfEs4Y5ke3PrTIpINssik4wAz7XSBRk0tIbkItslA_1757444291
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/8/25 6:24 PM, Ivan Abramov wrote:
> There's an incorrect VDO_ASSERT macro usage in
> start_restoring volume_index() and start_restoring_volume_sub_index(),
> since assert's return value is not used anywhere.
> 
> Thus, use VDO_ASSERT_LOG_ONLY macro in such cases.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
> ---
>   drivers/md/dm-vdo/indexer/volume-index.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/dm-vdo/indexer/volume-index.c b/drivers/md/dm-vdo/indexer/volume-index.c
> index 12f954a0c532..99608f14400a 100644
> --- a/drivers/md/dm-vdo/indexer/volume-index.c
> +++ b/drivers/md/dm-vdo/indexer/volume-index.c
> @@ -832,11 +832,9 @@ static int start_restoring_volume_sub_index(struct volume_sub_index *sub_index,
>   		decode_u32_le(buffer, &offset, &header.first_list);
>   		decode_u32_le(buffer, &offset, &header.list_count);
>   
> -		result = VDO_ASSERT(offset == sizeof(buffer),
> +		VDO_ASSERT_LOG_ONLY(offset == sizeof(buffer),
>   				    "%zu bytes decoded of %zu expected", offset,
>   				    sizeof(buffer));
> -		if (result != VDO_SUCCESS)
> -			result = UDS_CORRUPT_DATA;

This is not a correct fix so we should not take this.

This assertion (and the one below) should only fail if the stored 
metadata has been corrupted, but in that case we definitely need to 
return the error and fail the load.

You are correct that we don't seem to use this result, but the correct 
fix is to return UDS_CORRUPT_DATA when this assertion fails.

Matt


>   		if (memcmp(header.magic, MAGIC_START_5, MAGIC_SIZE) != 0) {
>   			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
> @@ -924,11 +922,9 @@ static int start_restoring_volume_index(struct volume_index *volume_index,
>   		offset += MAGIC_SIZE;
>   		decode_u32_le(buffer, &offset, &header.sparse_sample_rate);
>   
> -		result = VDO_ASSERT(offset == sizeof(buffer),
> +		VDO_ASSERT_LOG_ONLY(offset == sizeof(buffer),
>   				    "%zu bytes decoded of %zu expected", offset,
>   				    sizeof(buffer));
> -		if (result != VDO_SUCCESS)
> -			result = UDS_CORRUPT_DATA;
>   
>   		if (memcmp(header.magic, MAGIC_START_6, MAGIC_SIZE) != 0)
>   			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,

