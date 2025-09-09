Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66A431D388
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 20:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757451554; cv=none; b=MP8YCgiprb43WiqQGi8gI+q85I4/yvm8nZhWX3sL/i/4db2PVvSZWubOSbBGxqa1rqxKQ4eEG8ZCuZIw2UOvKt6EKXclWZ0a5+Bb3Kh9GFVt0kHL6NStm0fm5sYgYlxiCc1WisJCspnEfmnMajJK1zceqdXspO1B4yWmHH6Dd1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757451554; c=relaxed/simple;
	bh=4o/Ny2gYtEkqlev3bjAo55mlY2GymrgPsnWTj3xFpsA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b/5IEoUEjFh6z3P4uT92dBpT/xwUHaPKJXZ07o0abl70NIPcZ2WHadHgY6WDhAjBpCJ1DcUBPUGgGJsw1gOWhQAamYxYZ2vRho/DgYL5T1XpAaAJUlhx88wxyejmC4Ls0GUt7be/HaEUEoc71aQsYEHS5Dm2ZfweE0STWQMUmCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fXwON4k1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fXwON4k1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757451550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zCVNRf4uxpIBkqC/u+KO0qz0W99ZM1kson5SS883F3I=;
	b=fXwON4k1o8pjgJiR1wtsyqTe3Eaqkl9vZKH1JgIQMep3vKL+CxBMMjsv5lAKWcdc12j/cx
	dNgh9FB5Z2U8GUOsT5o/KpfPLTiIYEdyWumOGL3pbGSQpdEfZgZW+gyupPFtqs41/QWusy
	7WzStHAtvngOZVRPJw0ItM9/1fOf1JQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-BjhrY0ZzPGCnH5u81y8_5w-1; Tue, 09 Sep 2025 16:59:09 -0400
X-MC-Unique: BjhrY0ZzPGCnH5u81y8_5w-1
X-Mimecast-MFC-AGG-ID: BjhrY0ZzPGCnH5u81y8_5w_1757451549
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4b31bea5896so67592181cf.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Sep 2025 13:59:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757451549; x=1758056349;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zCVNRf4uxpIBkqC/u+KO0qz0W99ZM1kson5SS883F3I=;
        b=wQNr4iG0fjlH4W3qC3UQlS07GvmTX01PGw3HEdhc3YWfeXQveFFI75vPfywkGd4LCA
         s3MfSzwp3q6fHHLhVieHbyjxbo3MVe3u2H3jdghuLW9UaX9kXSJ2XQahrYNiLZyhpDQ8
         0/R4c9AQEmiysI6cvWG3yGBOQ/RfXwx6uDkVQwc+RyUXgQjDDMdkYI+Tw1VwBB2PxUrp
         22jYBl7MG8L3WQ9CClccxM2FHwtxJX04L/M+t7euUv4/gZHN9Fs2UgDUNeGG/wEC/eEO
         X46PxJQIR5ehW/1BURLOTH+TBMNxY7jFRDVApCeNq0RB78mN9pdCXDd+Md3UPmhx/9fg
         mnjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSe3N4ebG7W5O9kqdLohVxFV2XgGebp4OYohUKTG3+jrvDv0Dw96d6LF2GfpvQW/Qf5LR9gfKtow==@lists.linux.dev
X-Gm-Message-State: AOJu0YwgKZKvClsLpzpYLBjuOhe5RPCLM5SRxajmNbNgN3q36CpDf3sl
	L0crSs4DJSrRqWMz7umcyvk3DuytFlCqr2/5e6OWJ4DAkOQoRheB3hXQtSneFzESu7okT/mIPxL
	HYlfXf1R2On2E0a895f+odrleA+Pvem0pMnj9iQPBdQMC7E3S+HXbCz5F4hzp
X-Gm-Gg: ASbGncsTBSQzlMaV87rXPaahhKpimkDbdCU8oUgQl7TaTzuzHeaRO87y3KodpqcWBoi
	F/TYVpCALcZelAGTnodzpzPp4jTVr3UpaNOiy3hHgCA+8BuGYRR+XCJIK7ImdSw8bJz6VeTuCcr
	q0dLfSIzSV3UkuKVTXw4WxdmFPrFjOxnfJRj6Z3ysaJJX/FEnJfYqXVej4gUhaGxox5MaZ6nW/+
	9slWlFj8ICEzK20Mhuk09NyofcN1n4uIdt2gcf61uI2NpP5N1xmJGulRyP1t3aNniSPR8GRc8nM
	tj4hZEUVDptlX4yHJ8N1fVmyI7qDSsL+I9tyi/Xs4lOWBL0UFQawK1MCu7TLuSdq4knc6pvTc4b
	kiIHAynQHobeD
X-Received: by 2002:ac8:5751:0:b0:4b5:e9e6:81e0 with SMTP id d75a77b69052e-4b5f8398d48mr127178991cf.32.1757451548702;
        Tue, 09 Sep 2025 13:59:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPACoNuxszWjE5a1pmJtASC07htXfqx4RgsHf3EkVuPUYYKnszU5cwn2VxrRnrMUnmj8A+gQ==
X-Received: by 2002:ac8:5751:0:b0:4b5:e9e6:81e0 with SMTP id d75a77b69052e-4b5f8398d48mr127178791cf.32.1757451548234;
        Tue, 09 Sep 2025 13:59:08 -0700 (PDT)
Received: from ?IPV6:2600:4040:5308:eb00:a77e:fec5:d269:f23e? ([2600:4040:5308:eb00:a77e:fec5:d269:f23e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-72f9ad0acedsm91331836d6.14.2025.09.09.13.59.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 13:59:07 -0700 (PDT)
Message-ID: <39ac9482-75a7-4124-9caa-5d0550c677fa@redhat.com>
Date: Tue, 9 Sep 2025 16:59:07 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] Return error on corrupted metadata in
 start_restoring_volume functions
To: Ivan Abramov <i.abramov@mt-integration.ru>
Cc: Mike Snitzer <snitzer@kernel.org>,
 "J. corwin Coburn" <corwin@hurlbutnet.net>, dm-devel@lists.linux.dev,
 Thomas Jaskiewicz <tom@jaskiewicz.us>, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
References: <20250909202242.355086-1-i.abramov@mt-integration.ru>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20250909202242.355086-1-i.abramov@mt-integration.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 80W-SLQ7adj98mTnZvcXhuhiyvSKytYycNeRdDKpoSw_1757451549
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/9/25 4:22 PM, Ivan Abramov wrote:
> The return values of VDO_ASSERT calls that validate metadata are not acted
> upon.
> 
> Return UDS_CORRUPT_DATA in case of an error.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: a4eb7e255517 ("dm vdo: implement the volume index")
> Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>

(cc'ing dm-devel this time)
Reviewed-by: Matthew Sakai <msakai@redhat.com>

> ---
> v2: Change approach as per Matthew Sakai's <msakai@redhat.com> suggestion.
> Change subject and description accordingly. Also add Fixes tag.
> 
>   drivers/md/dm-vdo/indexer/volume-index.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-vdo/indexer/volume-index.c b/drivers/md/dm-vdo/indexer/volume-index.c
> index 12f954a0c532..afb062e1f1fb 100644
> --- a/drivers/md/dm-vdo/indexer/volume-index.c
> +++ b/drivers/md/dm-vdo/indexer/volume-index.c
> @@ -836,7 +836,7 @@ static int start_restoring_volume_sub_index(struct volume_sub_index *sub_index,
>   				    "%zu bytes decoded of %zu expected", offset,
>   				    sizeof(buffer));
>   		if (result != VDO_SUCCESS)
> -			result = UDS_CORRUPT_DATA;
> +			return UDS_CORRUPT_DATA;
>   
>   		if (memcmp(header.magic, MAGIC_START_5, MAGIC_SIZE) != 0) {
>   			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
> @@ -928,7 +928,7 @@ static int start_restoring_volume_index(struct volume_index *volume_index,
>   				    "%zu bytes decoded of %zu expected", offset,
>   				    sizeof(buffer));
>   		if (result != VDO_SUCCESS)
> -			result = UDS_CORRUPT_DATA;
> +			return UDS_CORRUPT_DATA;
>   
>   		if (memcmp(header.magic, MAGIC_START_6, MAGIC_SIZE) != 0)
>   			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,

