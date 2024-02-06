Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1331BF27
	for <dm-devel@lists.linux.dev>; Tue,  6 Feb 2024 21:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707254416; cv=none; b=Sbmtdef2h+GmlQyp9vi4g9tAlXkZ8ObT3K79TQ+js9SM4rR1L1XM2At1RTQ7C5xieGRd1q+u0FQ8nJLmQnNHKJf2wTA4Byfm+W42xopbUl6vzc2OiSVJA/YNgDHd6DhrR4n21Tm/TG5pBvKO64FEbEDVrbRQH/6B3SJnj1sbpeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707254416; c=relaxed/simple;
	bh=VmSgp+63oRXrwJQrAP0cd+6cguoeR3YBtDiu9iIrJYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y0e44rzKUcL6HJkMAn7zs/aEvKU1pXHEVuHTkXlsNNPoqAgo9qKlallPL7wjvx9vTi20ByAorygqe5StQt3a27M9f/u3oHkoFyQpTTb1P/fFOTPecCAmTpLTr7yoEO5+17cC5vFHyA7bP01F0Z00gEGzIhbyE5U5enj6gYL3Y60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-296cca91667so814126a91.3
        for <dm-devel@lists.linux.dev>; Tue, 06 Feb 2024 13:20:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707254415; x=1707859215;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VmSgp+63oRXrwJQrAP0cd+6cguoeR3YBtDiu9iIrJYE=;
        b=MIs4RFAp0jb+nAxv7RYPjFQlXXxxg40gBfInZMnKk+1XGU01qlKF7d2S8zfDsKwnzj
         MPa/W5K4BO2QUIe9Oy6qKtdOVlZQ0iaCu67hZ7/6c7egAaRH4kNOW/mTMeN5lNrd47eI
         V9kay0EfH60YIgOW2r3kQY4igMSMYCAIBdH/LOviGLtPq0ITGYjpIiXi3+wzOl39ARiW
         xoh9RgrjW//lCfXg0Ljlr28k/6w1ohp5HFlNeonrO8MZegNswv4Ooqh5NzuEHZ6pgS9s
         8hR/eSRXA7lGqJS4OZu6lh0G/SsgQIoDcJncjsWIvT9iNtEMUfCxj/snllgkWmRVGFUY
         mDPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxHGvvUol7B27WBvOEGBi5g7oqTccM3RMdzJou6jxKL+9uxkXYXirUP14o2e9SDUho5jWJIQv+VODgtOj2ro/VOUbbrvLfUIc=
X-Gm-Message-State: AOJu0YxknPWEGbocNOAIAbD3K8yaV2SSN0AwYho1bKqXTrP/d49JklZN
	71jUOdC7Gir/fin3sy8FCS6HDfTvd/V5E4IKpp4hHPDrP+U8bOMF
X-Google-Smtp-Source: AGHT+IE1dmlg1DJBfQqr1jxNrF1zBsdEDx8lkYpwaHXAhDXDyTCYrU6/HXa2sJ2t2VmI74L9DJJoOQ==
X-Received: by 2002:a17:90b:480b:b0:295:a8b8:97b3 with SMTP id kn11-20020a17090b480b00b00295a8b897b3mr745099pjb.40.1707254414489;
        Tue, 06 Feb 2024 13:20:14 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW7XBAhxFuEe3PaxPzBa6pxXcvoCqeRNLsMRYKp/5Nd90UPdqU0nIMDtSmpc1Ofh4ffG2Cb1tjyVAxPzzUSFejEzf2N/bt9JK3kPiPU6MzweT1sj0tXgS53miUtMPdo8f7w+e3dZonPMTPdCWpy8tb04IjlJXpNSGWGLJOPoRJyAS9WhUyrFHE41rh692JAhkh7rnc0bRReRJyBobicuSKWAlhGCe7DJU5jVD+RgD364QUWM64mqvqT0Tws18BtvRnd/zDQENPJYpq9+8t8Wq49
Received: from ?IPV6:2620:0:1000:8411:8633:8b18:c51e:4bae? ([2620:0:1000:8411:8633:8b18:c51e:4bae])
        by smtp.gmail.com with ESMTPSA id nd8-20020a17090b4cc800b00296dd7eff41sm224974pjb.9.2024.02.06.13.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 13:20:13 -0800 (PST)
Message-ID: <2e246189-a450-4061-b94c-73637859d073@acm.org>
Date: Tue, 6 Feb 2024 13:20:12 -0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/26] block: Reduce zone write plugging memory usage
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
 linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-26-dlemoal@kernel.org>
 <09d99780-8311-4ea9-8f48-cf84043d23f6@suse.de>
 <f3a2f8b8-32d2-4e42-ba78-1f668d69033f@acm.org>
 <a324beda-7651-4881-aea9-99a339e2b9eb@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a324beda-7651-4881-aea9-99a339e2b9eb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/24 15:55, Damien Le Moal wrote:
> The array of struct blk_zone_wplug for the disk is sized for the total number of
> zones of the drive. The reason for that is that we want to retain the wp_offset
> value for all zones, even if they are not being written. Otherwise, everytime we
> start writing a zone, we would need to do a report zones to be able to emulate
> zone append operations if the drive requested that.

We do not need to track wp_offset for empty zones nor for full zones. The data
structure with plug information would become a lot smaller if it only tracks
information for zones that are neither empty nor full. If a zone append is
submitted to a zone and no information is being tracked for that zone, we can
initialize wp_offset to zero. That may not match the actual write pointer if
the zone is full but that shouldn't be an issue since write appends submitted
to a zone that is full fail anyway.

Thanks,

Bart.
