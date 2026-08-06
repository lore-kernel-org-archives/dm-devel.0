Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367A447254E
	for <dm-devel@lists.linux.dev>; Thu,  6 Aug 2026 12:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018899; cv=none; b=GreEKw2oO4BLyD276u+owI+cnn/gk9/XOUHwU9RcYyHN4aKjD89sbbiEbKM1ZTZW9RLqH84GnSQfSC6e6m2VQiw/FATIdkc/r6ELG5PLsVV1oPfZoJexP/g0z2ZfDMPqdKScfGO/2Q092+o+9CzDPYqLQa/Do11EEHrhvzptjmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018899; c=relaxed/simple;
	bh=TTiHlStxZcKVKrwqcuDMLj38rBSP7TpoZoQlRZGLyrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZCP+h5G751szhRTwHZzpvyRSKO35GpSs0TluZPViUN3A5Ps47ptFjLtnqYR+A0C+NJeK7LkkcYWe6U+d88S0ukrn/hxvyV4Pgf0v6Ig7Unxt0mxx30mQxluOYhBWGVlliLwNn8caic0vsQILIJvdARsZinCyZSdbQEKQ18wFrcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ex5p6Jcq; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ex5p6Jcq"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f703a9e5dso1084706f8f.0
        for <dm-devel@lists.linux.dev>; Thu, 06 Aug 2026 05:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786018896; x=1786623696; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DfDlnjwEjqQiBft6//i9aWDA7+Wxp9IrqsB/3Fhaw40=;
        b=ex5p6JcqLI7580jOqQx82M5xec/IilPnvgUgo42AJ21+ifc33DsD+NslqKi/75GrfF
         BdxYFKbWg6ePWg6KZs6zNQEL5h1yOlXPFhXvlj7EAZtqkds3q+G1U/4Pce1Y+F2WbF+4
         U/W8JpUe43eT/78ZvbKpP1rLcAOVfUqUqjJIrahNSoIMkw2KtMhoPmzFiY86/wMyOCzD
         2JQnPFj2j+QFwqKhSsPIXR5GqhU2ofRSAo5H57QNpkCxTbeUdY4VXhrnv9fUZ0u7KWg/
         TN1HNlsatVxzaTLDfg2Pdavdw01f+r09cBIS9A2/bEVCQA0gnlhpipUgIUE4+vSFJ75r
         MzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786018896; x=1786623696;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DfDlnjwEjqQiBft6//i9aWDA7+Wxp9IrqsB/3Fhaw40=;
        b=f6ky86f53mil378N90/XeBV3Jm+KDh15/Sg8MZCTJg57sG5d4zwKaUIgfZEZesJuws
         Lc5Qcjyk5ogcGrbQCdspmyBEmy0die0guPodv/NO9w02NhaF7aXqWu16n8pDXng6nJMG
         yVBDVO+AdYZ6zouj867xS+5C8KyvNLgfZqa4uQf2bU3C044lns2wRf5zCKz2xKhOn2K+
         jXzNljKc2qdXwFHmaErq+iwN6hW/6rW0pT51wBVKcXTq4Ebl84IpgQdjSMqOYju6v9kc
         ewMNDSjOX+E5YUSqdMKeyYYpMZ8143t3pC3Ys0EgHIwXiWMndFhXliRHJ1P/oJqCrzpi
         K9Wg==
X-Forwarded-Encrypted: i=1; AHgh+Rq7l/rVDA3b9zEckJg7pqkYco2Mq3VViVGfI3OsusORYBfia7OcLbcrvmwptW9Jw10AK3l+GMdBnQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6aVhzNamSISM5jfHJlYA5bIweV5v1J5sNujbVo1GaHkm5xLFT
	0IwxcSq5oCs5F+EOcahlGYxslYC4V2r6zHa2cJ4H/WYTOsjwBRdboOd1
X-Gm-Gg: AR+sD13u32ryW5TsH4VNCyPmKsH3k3i0BZFVBV72WWhNgsY4IWa1Z2RsLeKRw1+Y31v
	YXKGnhr0XKu9jfD8RKlNEuBEHM3m8ZPnJj8o7wwsAMhZw47bYNKj7MJYbazu8qsSOuhFkUMR0fs
	Bi5Z63PF7qKo+4lw2hdBNq1WHQByLtlzYQUyKCETGY9/Zp3a7TzM4LQQI6mcxCknRUqDMnTIPPl
	XZg+BPWJ8mz8zpVUe69njIgDcZexppTQ8EkjNpUO1YaH3v0X/jevIy1dE8IFQkbTRK6i0itu+Bg
	VsBkcIGDwpxcNx38yxhNNzxtkeha4Z52JpqujPZA7PCHN4gmPkkTnR9Lr4IIuhjsXsd9axTr9sd
	d1oFD/qMHYjOO5LlIrtPWBdUHokBHo/E5Yf1uwOkOFFdSFxpbq3YDgjgIwUQpSqgd+Emq/2WqdG
	NuMD2Rl4oK7FUyoa/Nznw1YSuRPIh7iT9LC+RlGUtiawGP2xrQwdnVCzYWdny28H1rDFmX6mEDE
	JE46vYGBH+rvqP7dY09A2eOazV92mH/b6R3q3aEf/syW+XyBI5l+yFwnoSb3flpynHV/F3PTYDn
	xEa2A63sU7+SVUvza4sCq9v53yFGZUvr6sSSog==
X-Received: by 2002:a05:6000:290d:b0:47f:f42e:9715 with SMTP id ffacd0b85a97d-47ff42e974fmr10864047f8f.12.1786018896398;
        Thu, 06 Aug 2026 05:21:36 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff7b32492sm5927425f8f.35.2026.08.06.05.21.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 05:21:35 -0700 (PDT)
Message-ID: <f47ed617-5ee7-4259-9f5f-a6fd0f5aab24@gmail.com>
Date: Thu, 6 Aug 2026 13:21:38 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] block: rename bi_bvec_done
To: linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>, Ilya Dryomov
 <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Hannes Reinecke <hare@kernel.org>,
 linux-doc@vger.kernel.org, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <4e4c21858705a200bd8848ffe4080522e3eb5c1c.1786018753.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4e4c21858705a200bd8848ffe4080522e3eb5c1c.1786018753.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/6/26 13:19, Pavel Begunkov wrote:
> struct bvec_iter::bi_bvec_done is used an offset in the current bvec,
> let's rename it accordingly for better clarity. I also plan to use it
> for non-bvec based iteration in the future like dma-buf, so drop the
> "bvec" part.

I have this patch for the dma-buf patch set, but it's a very noisy
one, and I've got an impression that it'd be a good thing to do
regardless. Hence sending separately hoping it'd get into 7.3

-- 
Pavel Begunkov

