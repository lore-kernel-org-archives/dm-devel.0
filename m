Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5F6137E
	for <dm-devel@lists.linux.dev>; Tue,  6 Feb 2024 00:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707181060; cv=none; b=n+BsIr2ovVJOGEyWvwonpOcemmkNcUEWmgmfHG6cRWVKbmqJoU5Qwez60ip1gp1j3fnyFLCC20/54l8uqdvHWWjb5iacuRBr6bVA3kTTP+GTmb13UV3KA4Eba3jszuNChoLXsmUtvhyDqxGgifIQsKvLtReypGydUv98Zy+NyuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707181060; c=relaxed/simple;
	bh=YWNKKmsMv/jBqFoU7Yl6BOcdIWeoPqHd7UeMGcgtxRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BhasSDsPPdrPiEm1zq1FFKeJFuQm4AjtDabKmKP7U/dpVrlmCwxZhGImelm91wMzEOxMLhFT2YMKY+jTfLozANypoGndv4gFJOEW4F/kqJiNomVYnqTSUgcbpooLQgIZMP+pdvY/v7IUmx7MwpJhjPDNkN1x2pleA+FVfVVTgGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5dbcfa0eb5dso368326a12.3
        for <dm-devel@lists.linux.dev>; Mon, 05 Feb 2024 16:57:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707181058; x=1707785858;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=opHqb+C62MdhDCBurOh6qgNf+dB4dwPStmEHHYjGuQs=;
        b=oRXcqmbdeDNkYAEmmTOf6v5uUIjWrlT/G1+9BOi4RT2tPdweRVAFe+/doARWumhZBo
         IorXQLCZakORz3ymVQJcX7UAakAZqzs8g9tg0NPkaPf7388ho/fnWZByPcuyUcmPoNL8
         3e3NE/T2Ppva4DkCH8lwLnYIE5CYVsayMGM3g5JRaFRiOt7xbY5Q2WreyExEthpb4znx
         h9dtFr99hxW5nr/Uf9hf/b2wEYAbJIG1fPKInYAulpfUAJrJ+VJASbJcUmtKS/lhydvj
         FOE2oSDwZodVZDIqSbNV6AwiImrLEMmDFIwf1mszTQCifQI84d67jvmSMKKlXU1b6Zg+
         O7ew==
X-Gm-Message-State: AOJu0YyGu0rB18hpNItBkjV3KdgZ/nUKVnlIFQkdGyGm7BWp8xZZM9B7
	7eWBy6pHHuI3r0L28c6bBG9+JRr4OEqVaoL2MfZ20qornvmKnloC
X-Google-Smtp-Source: AGHT+IFgEqpD+F+h/zwX8mI4dzAdSsOBPqzDR+llq5TTnQWnncz39XzUg62UjYTHQWYfuWai2I6HIQ==
X-Received: by 2002:a05:6a20:3d8a:b0:19c:b3ea:27ba with SMTP id s10-20020a056a203d8a00b0019cb3ea27bamr171383pzi.52.1707181057909;
        Mon, 05 Feb 2024 16:57:37 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVKRXhnFahbWUq+nAQAqMtfCnJ7Tna9OqKRm2WnZQL/Mh5NLT+yd4LyWd45ZL/gFFccK1p0jgZ6exFt5sKlJF9XXLDZ7H5vGvW/D+vwZF8TVFngxA4ndfQnfveeb3wcoJt2OpO89Y3qoO2ST0mB5zveFC4mmw+BbRODmQmKziPuxaj3qqU42L+IH8OkBATSwYY4fze9qcAsix4syv+MIWKaLNdp4kla1uxEMZPDjVLIcObSkKOvs+gN6FKTjhBJtq1y8Q==
Received: from ?IPV6:2601:647:4d7e:54f3:667:4981:ffa1:7be1? ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id e3-20020a635443000000b0058901200bbbsm696647pgm.40.2024.02.05.16.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 16:57:37 -0800 (PST)
Message-ID: <38c39245-3dbb-4683-8dd0-b5aabb672583@acm.org>
Date: Mon, 5 Feb 2024 16:57:36 -0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <7c98aae0-46d1-473d-8d60-8252a96c414a@acm.org>
 <ee72eeb6-f929-4879-906a-a628faa1c374@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ee72eeb6-f929-4879-906a-a628faa1c374@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/24 15:42, Damien Le Moal wrote:
> On 2/6/24 02:21, Bart Van Assche wrote:
>> On 2/1/24 23:30, Damien Le Moal wrote:
>>> The patch series introduces zone write plugging (ZWP) as the new
>>> mechanism to control the ordering of writes to zoned block devices.
>>> ZWP replaces zone write locking (ZWL) which is implemented only by
>>> mq-deadline today. ZWP also allows emulating zone append operations
>>> using regular writes for zoned devices that do not natively support this
>>> operation (e.g. SMR HDDs). This patch series removes the scsi disk
>>> driver and device mapper zone append emulation to use ZWP emulation.
>>
>> How are SCSI unit attention conditions handled?
> 
> ???? How does that have anything to do with this series ?
> Whatever SCSI sd is doing with unit attention conditions remains the same. I did
> not touch that.

I wrote my question before I had realized that this patch series
restricts the number of outstanding writes to one per zone. Hence,
there is no risk of unaligned write pointer errors due to reordering
of writes due to unit attention conditions. Hence, my question can
be ignored :-)

Thanks,

Bart.


