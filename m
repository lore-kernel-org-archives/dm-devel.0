Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED1563B8
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 00:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716512282; cv=none; b=NXuJrb+ANcGKO5mtTn3u+YnKP9dEPApjWULHNkrBd3kVLWsMP7Hl9lIe4XBvuplR2gjLBUiZqCz1Mt7VNru2DcQwpl+wsJVUXXoM2cLHPoui04AUODzzAvUhc2x3xh59SN8F64GcFcFlD2AaKgeqqikNR6gP53s3dU3whvr1c94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716512282; c=relaxed/simple;
	bh=B09WagMSQYqu2y6WcNLAL8j1PdOhiUvl64ijy52FX74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jZDeUIE3lwKXxe1qhcL9EKAoprcBaiGuL8ovYVqgF+rsbFXCHLjwEbo1PgHJmW4qs5PEEiiZ0GvLVDVOUK+Aqv8D4ukdl+JEl9j0L/WdiIqgqIhol+2z8QhUjL5035T/f7aKZcEIfW5lt53OFVtNrrktxDSsy6X12lhV2QsLsks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JMTAfOCL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JMTAfOCL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716512279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3nW6ItyXHWrOBbIXTrs/WnWz6xyA/F9n+0mCPhSlCMk=;
	b=JMTAfOCLkbQR9AdCdAYUE8u5A2W0mjf5SWvAcmoPo1zNmWO1sJRe0NL3AcT4PzVtt9gfj8
	HMvdoV5pVTMnTlPa05k6WmjY8xez5i58JU2YBHk9ojDngBBlKFaKLiFqCdjg+J7LhFDN5N
	Qd5h+u2H+EfpfP1TAGolEvnOlkfTNnA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-CeUUOdB-M3KaESUlo2_GQg-1; Thu, 23 May 2024 20:57:55 -0400
X-MC-Unique: CeUUOdB-M3KaESUlo2_GQg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6ab83a8eec0so6779856d6.0
        for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 17:57:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716512275; x=1717117075;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3nW6ItyXHWrOBbIXTrs/WnWz6xyA/F9n+0mCPhSlCMk=;
        b=tPnyTCxdVvxugZjfxpFO9sWch3oo1Ap/14hJ50Mb3fK6to9Qjm0JG1Iwwd94dXwZsl
         N/wRbO0hPw+mMCchQJjVqeSDnqY2r/t4n1kKC460vqKWD71rR5aDG/PC5uNEYhs/7h0G
         yhl4xofaG/k6awP5stnijPoHI2gAP7sXXNptAt01tE2NsCe6Rsj7h18OUTUrGE9+Z7j5
         ydUGEMRc7ofo741NTez6tvx484y9e5DsQ7RNmLoLshSh/h4iz6rup8hXfxyiIngu6ykR
         o2Ck52k5dOnYF6hitiGHn7N2o3ve0SyLsgkvJbHhUV9cUoNZbhvukPFoI7PdpDXAKgPm
         F5xg==
X-Gm-Message-State: AOJu0YzOJo6v0zNFxnMd8qXzHBp3sqHJl64mGR442s8bscILAmiqJ/HX
	zgic37An8e2XwAu+PGW6rZlYbB6leSjU5QDdQcsd333bHr5zJwy4qQNsxXd62DAPnSMUDYvrCUi
	8+CGnxE0sbf/N27aP9neOFXZc9sqYUWoq52YUqdT70razhoPsasTPaFcw
X-Received: by 2002:a05:6214:5d11:b0:6ab:891c:54e9 with SMTP id 6a1803df08f44-6abcd0fadaamr6119326d6.35.1716512275099;
        Thu, 23 May 2024 17:57:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHr9OA8GjcLWPDgYxGn3TRIwyBJob8LLed2gjUw9dHtXvVxRa+eApiMcnlNbmzT0L542FUa/A==
X-Received: by 2002:a05:6214:5d11:b0:6ab:891c:54e9 with SMTP id 6a1803df08f44-6abcd0fadaamr6119246d6.35.1716512274609;
        Thu, 23 May 2024 17:57:54 -0700 (PDT)
Received: from [192.168.1.175] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ac16308ecasm2009026d6.121.2024.05.23.17.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 17:57:54 -0700 (PDT)
Message-ID: <5c063045-4bce-14e4-9930-77cc0ed2edad@redhat.com>
Date: Thu, 23 May 2024 20:57:53 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] dm vdo: remove unused struct 'uds_attribute'
To: linux@treblig.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240523210716.309324-1-linux@treblig.org>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20240523210716.309324-1-linux@treblig.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 17:07, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> 'uds_attribute' is unused since
> commit a9da0fb6d8c6 ("dm vdo: remove all sysfs interfaces").
> 
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Yes, this was clearly an oversight on our part. Feel free to add:
Reviewed-by: Matthew Sakai <msakai@redhat.com>

> ---
>   drivers/md/dm-vdo/dedupe.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
> index 117266e1b3ae..39ac68614419 100644
> --- a/drivers/md/dm-vdo/dedupe.c
> +++ b/drivers/md/dm-vdo/dedupe.c
> @@ -148,11 +148,6 @@
>   #include "vdo.h"
>   #include "wait-queue.h"
>   
> -struct uds_attribute {
> -	struct attribute attr;
> -	const char *(*show_string)(struct hash_zones *hash_zones);
> -};
> -
>   #define DEDUPE_QUERY_TIMER_IDLE 0
>   #define DEDUPE_QUERY_TIMER_RUNNING 1
>   #define DEDUPE_QUERY_TIMER_FIRED 2

