Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DA122A80C
	for <dm-devel@lists.linux.dev>; Thu,  8 May 2025 13:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746709821; cv=none; b=cJHjj35ZUbzWij95ammbIg9hwxWUs5D3rPJWoES1ET8ZU7Oz9PzgUzFIogn1gHzf6on2vsc1KaKpsSrACE4ZRvTqom3dDe8CWrp1xF6OTfVRceqfiXZaky6OcBiVg+ZrJ3GPZTGY9Nf06ilp+REVjm0cwjf0+6vJvHkhejzTkgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746709821; c=relaxed/simple;
	bh=p3igjo1WeQ4ei3xNoOb2bq7IvOmv4IUIwEwUY8QYhsA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mGK5EsxS1xRPl0P2sNxffrPpK2ceRutSxi6M9T0wdeRK8OXd9C8B1UXegibsGRlnopTndEN4A+xta26/rDYIb6Rc47AMs8MdydIvhFJYctRZj3bV89iXJd9mpQaPx8joXOK2j1YIrT6JguhapKmSebf1eHOvip3tL59ITlUx2qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xNIfPnLG; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xNIfPnLG"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4774193fdffso16662641cf.1
        for <dm-devel@lists.linux.dev>; Thu, 08 May 2025 06:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746709816; x=1747314616; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XTDtbe4K12xhEpViDB+3A6qWj2g+MO64MrS+vZvyuzM=;
        b=xNIfPnLGiPJNSLv2aJ4tsDk/GC0EaJKtux7v6E6RLwZhCNOW9gdcN2OlP5vnRLvdCN
         3kHxqx0GvNDDUBEUcvB/oP4mozuCRqxa1kfAHPvpqzNzYOTe84Xps1pxKZnNcKbbiHw5
         9QemIeKOW8OM7Gm6xC6dQzVDnChziQqxVUb4/e4wdY8tx0uuFLo0AZnHv0XRxpJE3d8G
         ltE4FnAw9sA71D14Rk84k12RnT7n/6qClOvypQTb3vZD9CJs/NXeqcYsTIJDrGQ9vMxZ
         M9gXuhkdw/OZZvKUGiV+0BzZmDdeRyESUK0OtUzWI8MeZZN1y+gfBKTpQEjuJoHDqrA/
         pyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746709816; x=1747314616;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XTDtbe4K12xhEpViDB+3A6qWj2g+MO64MrS+vZvyuzM=;
        b=EhSJCQpu9MioPUjkU1+hGhNz8OdUPUTIwheefLjh9P1xXEIOMQHCfzbBBVkBJYUgvM
         QuQyJ5Ke+zhZ2XwQjNu12ijEv6P1of8yoqihBfZjVvflpZ9vkoq9QussflM5sKxOQUta
         swBE6BGl5WYf4rVBxsYV5l272bM+9Ibb9vvET/FjjACIuBFNseb1LWzclAtrKzuN3CAW
         2q8tPZvaHQIQTpUb/217f3La/eFM1aZEixaRfUw/X/4J8haQd9gjtfpzxgMvaJU6H9yR
         JaCFdBUEQixJRMIJvt7+lYkJQkm+SPYBrUEx3d1/ibZD5yY6sZr+3Zy2Z11EJkdMIEEn
         hm4w==
X-Forwarded-Encrypted: i=1; AJvYcCUvmM38ZrJdd2xoeJVBnxbU2VvEHiIXn1rqpkzO0H3Qy82tdkI58dLudbLDfAz+Bje7EmhAEDpdBw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5UuSDegspn+BxMgK5rmR+8QWq832u2QgA+hR6qn5o4r7VuGR7
	2s1I6W2FK2uB/FjqYcWXWgDE/EkM4OXDao+DLGEs0TZTHnIWB8gBtiZ/OyOd8JEm3mdqQP+PoFS
	b
X-Gm-Gg: ASbGncslqgHoRPmqvMNAR3WwprWlweSix/sgs1bcDKu6cHxU8vUde8zVZMUMipUddf2
	r0IxT0QX92WtEgHFQIDj/MGzVcX21YCFjUyFoiPwRORMwu4+a/TVDe4Nz/FpGeMTUXE0RO1i2mB
	fFCvJkpQbJsHaAWrbjy4tmnQMnJW//60BjUKqSm8aM9uAd0jRJwaKcN5cY+0CIvP8beeKA00DcK
	a2wA/j9CEIOOq+rzrjHdMvBOM/Hj8995ujVMmrpt2+LZ7ff+RH5iBRxHeGbuk3UGo4lPDMjrV0o
	3RhWgexeDVbqDmu8m3H/KT676+VVtqcHcv4h
X-Google-Smtp-Source: AGHT+IFc67B3rj29wLwGe5b9hNdUhbBaJDAFmOrgjOa9uQdS/eOlhjhIK4I5PRu/Z5lCJQDbW0IFWg==
X-Received: by 2002:a05:6e02:12ef:b0:3d4:6ff4:261e with SMTP id e9e14a558f8ab-3da73867d6fmr68904585ab.0.1746709805765;
        Thu, 08 May 2025 06:10:05 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88a945471sm3173148173.70.2025.05.08.06.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 06:10:05 -0700 (PDT)
Message-ID: <0df727b4-c0fb-4051-9169-3bd11035d3e0@kernel.dk>
Date: Thu, 8 May 2025 07:10:03 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/19] block: add a bdev_rw_virt helper
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>,
 Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 slava@dubeyko.com, glaubitz@physik.fu-berlin.de, frank.li@vivo.com,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-pm@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20250507120451.4000627-1-hch@lst.de>
 <20250507120451.4000627-3-hch@lst.de>
 <a789a0bd-3eaf-46de-9349-f19a3712a37c@kernel.dk>
 <aBypK_nunRy92bi5@casper.infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aBypK_nunRy92bi5@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/8/25 6:52 AM, Matthew Wilcox wrote:
> On Wed, May 07, 2025 at 08:01:52AM -0600, Jens Axboe wrote:
>> On 5/7/25 6:04 AM, Christoph Hellwig wrote:
>>> +int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
>>> +		size_t len, enum req_op op)
>>
>> I applied the series, but did notice a lot of these - I know some parts
>> like to use the 2-tab approach, but I still very much like to line these
>> up. Just a style note for future patches, let's please have it remain
>> consistent and not drift towards that.
> 
> The problem with "line it up" is that if we want to make it return
> void or add __must_check to it or ... then we either have to reindent
> (and possibly reflow) all trailing lines which makes the patch review
> harder than it needs to be.  Or the trailing arguments then don't line
> up the paren, getting to the situation we don't want.

Yeah I'm well aware of why people like the 2 tab approach, I just don't
like to look at it aesthetically. And I've been dealing that kind of
reflowing for decades, never been a big deal.

> I can't wait until we're using rust and the argument goes away because
> it's just "whatever rustfmt says".

Heh one can hope, but I suspect hoping for a generic style for the whole
kernel across sub-systems is a tad naive ;-)

-- 
Jens Axboe
