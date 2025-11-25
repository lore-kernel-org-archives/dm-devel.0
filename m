Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A0032AAB5
	for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764092298; cv=none; b=dA1+RDaZeYHCZrSR2y+ysvABx190WqduX8z8Ukram4Y7l1rUhet5ovzKx23pjTlv3ssSIIl+4rJdh4BAhetBW+fXVwtMkH1Uv/A4xN9LBr6OOwVie8ne7pGMkhtZkrdRAXYr0Z87IER3f4hJJsKRzMLzjx3mOOkGEOIKN/F5hvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764092298; c=relaxed/simple;
	bh=iPGMl91c7t5RGa6luUsGuLLK2Y4Uq1XKEbahe9phnZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PjXmBwE2/wHTj9Vi9Jz0Q7o7ufPxyYpvZBmTfwLjkPa//L6FZh61Zl8PgX0iuvk+x7ppNpgCvklnbAWtcnuY1xNqGODCW+niljpt1w2ZDnCnta+fPFYl0FYsbwHGD6UhTuU3T7OhunlUz6VRs1LBhqPrOdixgGBov6894aB8YPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UMwCHdME; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UMwCHdME"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-948da744f87so214038539f.1
        for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 09:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764092296; x=1764697096; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y/RYkXbjr0Zws5PkDP81koxcOw7wQafJJolXOcPbtL0=;
        b=UMwCHdMEkVKPn2bbwuLNdPG2jm8PDiS7Zw5TE4g7mAFtOEAHeWoBmBRo5ucX+GJutw
         gRhjIKkOy41yafX72DBjL3uw5kSu+FBjsVzp1mdUABYVfa5/B/lhLfATl2kUZR9Ka3r/
         yiml28x3+YKmyq9r4NFKfSr8H1EyZ8EaEWoUM/t7oGKLINkBYgrnxRotI+p+bOO6qWor
         Ac2rrvooXuKIgTMABMuxv05MebTUL6SS4DGbaTIUHtDmOIF6NhnOSvzFHFW4fkdT5Rvs
         xusjlYF4JF1OMrDlpOaRuh1CfbD2ohCzFt0WDd5tZcC4AuBWoWl8cRovHXN6ghk66Gi7
         WYyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764092296; x=1764697096;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y/RYkXbjr0Zws5PkDP81koxcOw7wQafJJolXOcPbtL0=;
        b=vIolUIcGcrU+u1Fe1NevCe3D/eUtWynlfal5lAOhrDH6/RKEG3edMpjaS+622t50Vt
         3u5nIDeL4YwX+v8MQo/jzL3OTQ51xuy5TXxNSud4g71o9WZm2QjA5ARPdeYHHUR8I2uX
         WEi6+nnNUMIGl8W1YK8WrsaVqKHiFS2ZCO5hXwLnKoqycb0M09Iyn+d+ok8VgRAyQIIE
         /J0YrXPEsZMdylETSrItlu2HQ5X8TKjNGGJ6ERwYxob/bAuy0T70DVqfqcHc8EjQAkIm
         wnwXF8sP0GiGTvkiqSrrd22x7/Di98vImGRkfhrx1hZ7Uv/rytSpaRwSxHJVOsVKFZID
         /4Uw==
X-Forwarded-Encrypted: i=1; AJvYcCVXEtP+3OtWbB/u1DZ3MyTC32tghre6mBwn0fyvar2slXtnKNLAU8V4juZM1wCiySGFEnep9EpVVA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyrsD0rOPElDdouD8oVwHNRQ0nOEt5blt3QXvMwGudil6bJzFGA
	TmWtEl9UtUcGblp6Kq8Hhb3KZKNKbeRFEKzj7wT+PSsEOl+Uk0PGFy3wixa79sPv4fw=
X-Gm-Gg: ASbGncuwo4O1y9RijAvG4GogrTDX1eBtYA074FBEcPbz8SCofODkYJcgeSsTubFjSjC
	69A9e+pPIpxlBV6P+NlkWc6zV8pRS/Ob+GedNkItoomciZ6zlwnRsf4nWPFkR09j+Ar2ZFcWcLw
	3vFtddl092HljBKsfpO4RkgCcpNQMTWvl8GfDdez0mdlPSBx4+pt2k6KRSj1Je/ClPAu/TNpPqk
	aldcri/ss8qCMqGjdNBsyEXVqTQR+l8u0f3NtHlHVrt8xVUHRFtekh8Fsb+DdjqZNJgO00ZmidN
	5e45Wh+QvV9cu+En4oDqSuFRa4HxFlYY3YThUHEcdWJ1p9srA26ZMcZU8fYeTzCe+JlGQ4mxeKr
	0AqN7FF/Yg2AN0TdTd9lFF2P9pfmc4hYqswGsac3aSTFjJYkOYHLNmu5GuBu1GIliMUw=
X-Google-Smtp-Source: AGHT+IEIHRk7SwMmVS4xtcTCAS6Qp+OrN5pgC4aYwqKQ9jNrDNwsm/zNssFdQ4CwiXZVR7EmZb+prg==
X-Received: by 2002:a05:6638:c0fb:b0:5ac:cd9a:4c4c with SMTP id 8926c6da1cb9f-5b999555c41mr3179432173.2.1764092295677;
        Tue, 25 Nov 2025 09:38:15 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b954b48bdcsm6970840173.45.2025.11.25.09.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 09:38:15 -0800 (PST)
Message-ID: <e3f09e0c-63f4-4887-8e3a-1fb24963b627@kernel.dk>
Date: Tue, 25 Nov 2025 10:38:13 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/6] block: ignore discard return value
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, yukuai@fnnas.com,
 hch@lst.de, sagi@grimberg.me, kch@nvidia.com, jaegeuk@kernel.org,
 chao@kernel.org, cem@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, bpf@vger.kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-2-ckulkarnilinux@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251124234806.75216-2-ckulkarnilinux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/24/25 4:48 PM, Chaitanya Kulkarni wrote:
> __blkdev_issue_discard() always returns 0, making the error check
> in blkdev_issue_discard() dead code.

Shouldn't it be a void instead then?

-- 
Jens Axboe

