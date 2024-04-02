Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3B721A0A
	for <dm-devel@lists.linux.dev>; Tue,  2 Apr 2024 06:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712040262; cv=none; b=ISV9xBgXRNIXjamG6c6HReHr/0UCua7MJ+UKr+WgYu1XVqHH++hjxcGJoJCDsqMXNMcMBLCBN/Lw8f5Zc0BuMrjc7PYWXn68BeNPJDlWPIzh3bPrT0VtStQX5viTWOTAAgIODR/hWioNg6Te5RT8+IjCLq5X8MwMPc31/K8yQu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712040262; c=relaxed/simple;
	bh=m6n+rmD1AQUeFVuOYAPQoLt/JLCEJTj1YtNrJPF/8b4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SlJFibV2STmf7XO59cJW8B8Ss5SEXEJU10m1lFG3OlFurs39aww6CEhKfCskVmW8gvF8x+Sn+qWQIbKN1qy704ZX+kKYvq5fJTV+1tU6UWvB0JxF7Z/yp62nqQq7aiQheW1GASHASTAUNIJa88DRGYCjGzHep9xXNPj2SV6vDyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FnZ3AgOK; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FnZ3AgOK"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6e8ab3701ffso458545a34.1
        for <dm-devel@lists.linux.dev>; Mon, 01 Apr 2024 23:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712040260; x=1712645060; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o4Gt2A/YlxbVubczq49Ydic0OlMC6zIRUZ48mhZIweI=;
        b=FnZ3AgOKWbb1EzaKiLOoJoa+O70hyWeNblHckYrDl9MOE8tHi6lbGzgL8l3kQtdc2G
         XPZPwSbJpLPr22ePvy7XEmomeH8hD95ttKzb0hl9/N2aMf2JbZstJ7ao6RJ6R+2vm0Lu
         q4HjLHDf0nIfFR/PR4W90nQHrFTtVWfsfEIK/T8YAn6+8i+tWqi0fbU4+8dE0dGWJ5C1
         Bpdpp9BJmAvmdAn74KF9F8HcR4XOS9siJU3nQKUJsSrLmgAVcivUMICu/mLijcFur8sP
         qt4fEhhIbKN7rhO6XU9ErDPkd0zuBykhmU77bBQjwtoHhWNoIwVqYdmt41zGfEL2jKv7
         zoew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712040260; x=1712645060;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o4Gt2A/YlxbVubczq49Ydic0OlMC6zIRUZ48mhZIweI=;
        b=HCO43wZMm8os8YI9Ma/Fr96hpO5kk2FuM/QC9oagz/Ow7pMn4C/Cz7Am+B6BZ/vWIS
         U6HvgUQBBjAAV3Bp8p9uGYRiGej4PHjO9uc2Da58iV27YEaz6p4CldrGH5hthr/EZCoG
         T5oGpdgc5kZZXcvuTf+d2n9Ip3q9xJiarOt7D9DS0wLmnRsgy362wG0JuE2y6+mEajaM
         gll27Zgy/F5M0yX91f8cqQND2VdZFuYuBV/U+kJ8t88hnf8QQZG1Uz9s0VFdeqDQ5El+
         pBOWg3r2rbq4YH6FZiiiQBXthXWLqx0cLKeYQoZ4V+0LWUgBPpzLpErYgcxhj9sNHMmR
         er2g==
X-Forwarded-Encrypted: i=1; AJvYcCV7Z5923AtiKmFHUtn4RG8p9LBZoHVzvmsa++GbCfR1mmVFXsLumI7fDxqprirrVOPxWWN63pQy8oQcvyVluyBJIS2gPz/kKyI=
X-Gm-Message-State: AOJu0YzLCk1hpjGtumJMA3ZWNYsf9fHKsbSY0KajGrgUghrYveH3RjPU
	pqgnqLHpHxW23l8qOzqOi37Gcj6/bywnL9VtwyCaYrqH5shixLEJ
X-Google-Smtp-Source: AGHT+IGsALuz+EYbsn3NEk9dyZFdNc4oYqbTtk6nUxsCzJEfOMWdydw5yQ9IV6Tn1FPKa+CognHTmQ==
X-Received: by 2002:a9d:625a:0:b0:6e6:d5e0:2308 with SMTP id i26-20020a9d625a000000b006e6d5e02308mr13185747otk.4.1712040259823;
        Mon, 01 Apr 2024 23:44:19 -0700 (PDT)
Received: from ?IPV6:2600:8802:3800:75a0:2378:fa3f:c6b3:24d1? ([2600:8802:3800:75a0:2378:fa3f:c6b3:24d1])
        by smtp.gmail.com with ESMTPSA id q20-20020a635054000000b005dc120fa3b2sm8756141pgl.18.2024.04.01.23.44.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 23:44:19 -0700 (PDT)
Message-ID: <30d1d907-4585-40e9-880d-e23a2a5e88c5@gmail.com>
Date: Mon, 1 Apr 2024 23:44:18 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/30] null_blk: Introduce zone_append_max_sectors
 attribute
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-19-dlemoal@kernel.org>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20240328004409.594888-19-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 17:43, Damien Le Moal wrote:
> Add the zone_append_max_sectors configfs attribute and module parameter
> to allow configuring the maximum number of 512B sectors of zone append
> operations. This attribute is meaningful only for zoned null block
> devices.
> 
> If not specified, the default is unchanged and the zoned device max
> append sectors limit is set to the device max sectors limit.
> If a non 0 value is used for this attribute, which is the default,
> then native support for zone append operations is enabled.
> Setting a 0 value disables native zone append operations support to
> instead use the block layer emulation.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke<hare@suse.de>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


