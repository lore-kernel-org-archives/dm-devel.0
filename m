Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B341715A4
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 02:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715826617; cv=none; b=e2t4v5yzDBJ37mDJD0lOm302dUayNNc1sdWYus857Bx1bN/gf2WsCQW23Azdoumo6HE4dlhbIjng/GnfMN7RqPIvYwri3l7YfucVaioamNNxaaV92QjfqmqBK1RDBLxKHpD1J/Edo3P/Pat9Ze7jUs4+59U5UR9tLE6c/9nov+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715826617; c=relaxed/simple;
	bh=IJfeXlGUHjly/M0zLN9mmkIcm0dd0HVgqLHDqtsmfqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PxJ2M5WjTBXGnNqHAaqLparXXpLdHThP1cENo2QWP4RBdV9doBe9ElO6hV43P344cNutmqLLvzYZC6rjLYWmUrocP6ywNfvYdbr9as9U6KGqhRg1A2kZ/jVEPPIADMkxgUcCsFWZM4rTVx1Dtu94pC55YkV66SV+mow2fRQXqnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ldCfgCr1; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ldCfgCr1"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2b432ae7dabso1958059a91.0
        for <dm-devel@lists.linux.dev>; Wed, 15 May 2024 19:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715826615; x=1716431415; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I+7daecJRB1K8ERvqxbImKF1sffU1MhW8D6cj40EMyY=;
        b=ldCfgCr19W6FbTixF8XZ+g8/SVV0UOkTaJdVibS0QeUdonSSJyigBnaxM00zbZ0RbZ
         bX3++4ZX6I+kzjfhwrxSKSSGgeotn8l/pWZfwAm/X1toSOGvce5YN7SNtiOSsJLBXNUO
         gCXLmZDUHNyUo5RcgeQwIbiTym/+QSuivjkLQ/SpdsOk0SWiwUlIFUF+ZnK31Mb7vsed
         /SmYanpyqHsJchX6d0TLFSQLUUSpNA0POfa48XCdQVH9IRFxC2N90k9o97Ah/nN+63Pc
         9K3X0Q5qToigmQopQhhPwlmeHGC31QlHfNaE6n/G+w1zICgXZhN/f1QSnza8KYW8WoYb
         kCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715826615; x=1716431415;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I+7daecJRB1K8ERvqxbImKF1sffU1MhW8D6cj40EMyY=;
        b=hcyNnN9KnUunKBUzPHX2ENORA6q8yfkrAgsPwCpgDffFa8VHelxeLebn5cZDcKQrOf
         8d/ueKo/QNAmBjsDiA6SYVagpwaunKVHZo5CzCVkSQusL04yqU8arp4utktTcFbP7FwB
         VDFXuG0ogS4aivJ4uglc9q6jTyjsS4FEwHyInjvybFjXmNQmaVnxKA0smQXBKHEWFhcL
         U3BcXcGvGq4741VlsnZp//g+sp9lMYmp1Z6bCf3+/dJ/iq45AmktY4v3ZpyRJhBOq+To
         fvIzEs6s/76R/Yl8UXmucixBlNet/8HLf6T1v5pI6A+pPnm/PhGzjw47coIKNVjkBDpT
         OHVg==
X-Forwarded-Encrypted: i=1; AJvYcCU3OBeQogLOaDge8shMBt+KjcySDcUlBhiwnyjDM6EKyQ/RuRvEyZrXE89JPCooop1T973quVDaF7zfcm16jC/rylbTbf+IZ3Y=
X-Gm-Message-State: AOJu0Yx0HCv3OGXohgN6ZstdYGdWt9HAz/tCKd4XqY33keUeSR/JC/9V
	lmoeWOQMzbok75rGcFnP7urOaeEXdYOxczoGro3sRDFvP9Uie42mDmYewM7Li1U=
X-Google-Smtp-Source: AGHT+IHisy9+lDOgAxqwY5N2n4AXPgS6IiVdn1NisspaguWsx50BdDg5mkfFVisgYhmrskBIhdn0sg==
X-Received: by 2002:a17:903:2444:b0:1e2:c544:9bb0 with SMTP id d9443c01a7336-1ef433d37a2mr200912295ad.0.1715826614709;
        Wed, 15 May 2024 19:30:14 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bf30fc7sm125494195ad.133.2024.05.15.19.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 19:30:14 -0700 (PDT)
Message-ID: <8522af2f-fb97-4d0b-9e38-868c572da18a@kernel.dk>
Date: Wed, 15 May 2024 20:30:12 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] block: change rq_integrity_vec to respect the
 iterator
To: Mikulas Patocka <mpatocka@redhat.com>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-nvme@lists.infradead.org
References: <f85e3824-5545-f541-c96d-4352585288a@redhat.com>
 <c366231-e146-5a2b-1d8a-5936fb2047ca@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c366231-e146-5a2b-1d8a-5936fb2047ca@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/15/24 7:28 AM, Mikulas Patocka wrote:
> @@ -177,9 +177,9 @@ static inline int blk_integrity_rq(struc
>  	return 0;
>  }
>  
> -static inline struct bio_vec *rq_integrity_vec(struct request *rq)
> +static inline struct bio_vec rq_integrity_vec(struct request *rq)
>  {
> -	return NULL;
> +	BUG();
>  }
>  #endif /* CONFIG_BLK_DEV_INTEGRITY */
>  #endif /* _LINUX_BLK_INTEGRITY_H */

Let's please not do that. If it's not used outside of
CONFIG_BLK_DEV_INTEGRITY, it should just go away.

-- 
Jens Axboe

