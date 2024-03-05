Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D80310949
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 18:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709664575; cv=none; b=hFdcpMp1Zfq4Rl42uAYV1vCaOnMVMT6tGTlWx+D1Ndg7yklxdqM2c9oiMoqq1AN5IuIvDtIrZNUET8jOCWrJUlnJdx/7F6yZS8yrTqQsStwpQVFO+n3CyYHWCYasHE0bVoNaX1CPK4xUjYSofLrgOXyFj7JBq7T+ryNnQ3zqMmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709664575; c=relaxed/simple;
	bh=9ZXsvXl03jX8+nsNYMsaZghvFdfjQyw/Nn0jFokr3o0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R9JHSsi5VIlSpYxfAgNYH3W3ma5h5bUyNAz8kTNSKmECJZT/TFZDyj+/ZfNAjZaVIeLhIaPSQam9GIAm2JwUMvZL5lE8Z1bFq/+EM3FQPiqPECmTO5kqFC2hsqWgQ02eQhn801xVeGUMOipFmyo4sAMfAsJUTchp/0vgnEbG8lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EGnKoNOj; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EGnKoNOj"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1db9cb6dcb5so18278675ad.1
        for <dm-devel@lists.linux.dev>; Tue, 05 Mar 2024 10:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709664572; x=1710269372; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3Hh1cI2D+bztmTwoI1bEL9bscTkagbx5n8aNpz07UC4=;
        b=EGnKoNOjgMigQr16eKU6MUatJixFWHqaTorIu1RDTbbxqDSkgvt+PSHbC0PcDTUIAC
         OkB3hKGO6ogvWjoga8RIWAFGnMejbc01kYRz3pkCy8qIJNMUuuHvErA2gGEGFoL59hCV
         kZyELiGWnbeeqfOeysjs8shW6REhQ6BaMTk0KBxdO5dZ0SZRjl2HbzIKQj0MCcsXqD/+
         cYJwPCxpf4hmvO0kjyI+/5v1GwxSCCF6sF8efVPOkYNoEWo6SdySoWDNO0xxcN9BSwc/
         hpZgOaa4uX3VwFDnw1gc/f2uFmvqHubyAP7Z8Qohc3xEC+8EheYma3nOiy6wn7GFVmta
         gtxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709664572; x=1710269372;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Hh1cI2D+bztmTwoI1bEL9bscTkagbx5n8aNpz07UC4=;
        b=Pq4TlpwdjHlkVdGdUNTVSUx3Em7nlav/wTHUW8bQZBDpB+rVpke/HPlGcG5RDUy9ad
         t+i9efHznOh1Jc6OpyDT3R8xMyN+BvCVsxecEgzHCqNqrifRw/2DjaJzwwGHJWzUX6EA
         yJxRqPfQ8ZOcRMVK6FON0Pxr5LB23DOutueug+sacvZbNKuMU2QL+4GZsS3tWr02Gw3x
         +jSpaPDrAW73/J7RGDn+QdOP5xwcUm4EQp/dkUTyEPOHZR+wuax+74X6qK2gEwKoprts
         AajgU3AzbSXypz/tW0Hc428GJnCW9I8yHshbWg9ZWKhtBDXxqNyGvu1vRGmywodwiUvT
         agTA==
X-Forwarded-Encrypted: i=1; AJvYcCU19inx072zoOrwqFEpOUU13US1AufIF8SjZR0Io1d9AeG8Tye7j6VZQA6wrlE9Z4aJEFINk+2Fbs0ZsnaFnTiBUmBMIUT01KE=
X-Gm-Message-State: AOJu0Yz81vyedhzYD1IZOmjCTUink0L1N9xtAZqPfJgx1im6bFVfADcI
	ZMAiiUVeKD0bp/OvQUa+DBrhpDitcz9xSx1kZF2JiApbKcH/sBMqpQIZGzx5G68=
X-Google-Smtp-Source: AGHT+IEMU3zDMyDJgndBukHhKet4CwZMtaNSqI9zQV7yUHKmjlfWHNRYLaDkzuise9hKk+9FwxbH6A==
X-Received: by 2002:a17:902:8493:b0:1dc:b16c:63f4 with SMTP id c19-20020a170902849300b001dcb16c63f4mr1456004plo.4.1709664572494;
        Tue, 05 Mar 2024 10:49:32 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id w7-20020a170902e88700b001dba739d15bsm10939571plg.76.2024.03.05.10.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 10:49:31 -0800 (PST)
Message-ID: <cbd5ed5f-f4f6-455f-aedd-98e41be70d92@kernel.dk>
Date: Tue, 5 Mar 2024 11:49:30 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.8 20240305
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Cc: Xiao Ni <xni@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Junxiao Bi <junxiao.bi@oracle.com>,
 Dan Moulding <dan@danm.net>, Song Liu <song@kernel.org>
References: <2FCF4E06-B33B-44A8-95D7-8BA481313BB8@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2FCF4E06-B33B-44A8-95D7-8BA481313BB8@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/5/24 11:47 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fixes for md-6.8 on top of your 
> block-6.8 branch. This set fixes two issues:
> 
> 1. dmraid regression since 6.7 kernels. This issue was initially 
>    reported in [1]. This set of fix has been reviewed and tested by
>    md and dm folks. 
> 
> 2. raid5 hang since 6.7 kernel, reported in [2]. We haven't got a 
>    better fix for this issue yet. This revert is a workaround. It has
>    been applied to 6.7 stable kernels [3], and proved to be affective.
>    We will look more into this issue for a better fix. 
> 
> We understand this is really last minute for the 6.8 release. But based 
> on the data we have, these changes are safe and fix issues in the 6.8 
> kernel. 

There's just no way we're doing this much at this late in the process,
particularly when these are a) not introduced in the 6.8 cycle, and b)
we're not even a week away from the merge window. Doing them now for 6.8
would just further risk stability there, no matter how well it's tested,
and it won't really reduce the time to stable anyway. Hence no, please
add these to the 6.9 queue.

-- 
Jens Axboe

