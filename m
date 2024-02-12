Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856783FE2B
	for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 18:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707763247; cv=none; b=CbaX8lAz5R65NpzjJ3vhAjqITWoooAavwAzv1C7tYfH3WDcZlyeMIqn++eEiTB6hyllftFhxEpTZnTAZUHXNtwz8a9YPfo+1nFC9mFkeD/WCC9SIkjUIG4yMR6q2Cv0W7L/JJIdNM9Vbm0RMNIS30+4aeYvXKhKp5vSlWuCfek4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707763247; c=relaxed/simple;
	bh=0EWHPQzyjvpkDP7Vq129ZoEDQO02WGyEBKILyGceJ9k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=knVtF8MExvc65BSwanq/K9+sEQwybszElCtFmw0eifgECHcRJOfCm4wZskcl12KYDeSc/yHrbLSgQX0Z9gbwQQLIHb1ZS93FyccB+lGmkXIxj0M/E1+Bffwbq2lQJKAcWzDTSyZu3rSrth9qlt1vU8Z0BCN3pwQdr2ccb7LGcpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d932f6ccfaso23854245ad.1
        for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 10:40:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707763246; x=1708368046;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PGslitScMSVc81UDgVXb8aGeYEXh6I3P5siRBkvzHMc=;
        b=fCsBSxTvfb9xTi+6FVtEvDPDgc5aU2URG8lJSJqcj8IaBE3ZGseLI66hTh+pR2xHtJ
         ICSWT10jktRZS1qnO22H5sUdzebZXGXVDPfizLUx/ikKa86pBnUszWSTLxhIoL07IIAV
         OFKKRCm/FTp+d6lAPosVlPOINhE/8/D4r1IaK1cVipsgg7FWk1rC2SML41A10O61OzeM
         R1lZemWJ6YA5+++FA40d2iA5hUUtwgDAeK96Q+p091OpxhXyKcbF6SQepYjugXzkDF44
         4EDj8Ykwbd8bBSg6Tm7X0jCWYsjLFDfGgU+19w5YBAQ+NIwTdnitWrq1DxLCQ9E/nNnf
         r4Dw==
X-Forwarded-Encrypted: i=1; AJvYcCWG2e2zeJwNS64oGRafbdTIQOFxQkdZcpxW/92OOco+Hv1/EDS03Qn1UMIMaG2ey96Ze2maZdOs2d+b4AfbiZsa5iCClJ552Iw=
X-Gm-Message-State: AOJu0YwBtpbSmWRqCGBgCuj+6l+RjAFx8z8yNO88+f2thwthL5UWyA1w
	LBxGU0wgiZM40zgKTk5b42i3Of9qlS2lQgJsdGvvFssv8/UbYoy7
X-Google-Smtp-Source: AGHT+IFkRZxtDzzX+Ggs3f7xckQrNiAEiUzUixbR7Z9lCO/KwbdCkkRG9d9r1bdUD1cTxygB7tpgVw==
X-Received: by 2002:a17:902:b906:b0:1da:1e83:b961 with SMTP id bf6-20020a170902b90600b001da1e83b961mr5753240plb.63.1707763245668;
        Mon, 12 Feb 2024 10:40:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWrXQ/KEXcGeiEx5uc2tl4aoNelzoOV58sUi2AYC+c2XRDy90hDtWiSDrnNTrKRQlijDVc2tXY5hG0aICU3lj47jmU+BmUpgduWcm7HkewVO9FNlVoUYa30IHStunl+cfxc18OyC3amddo1O/lUVBzMo8vJ8vC7EO12sCsstMX0Gb55GjGqACDNg1TsTgX3idRqskHFYmgURVc/7M9/hZQpyWb9693TQ9pet+zV5yvNdhZgJTOzs3bTW+xnmgz1bcpzvLN0mEuzo/fqw7uIXTe4
Received: from ?IPV6:2620:0:1000:8411:dfc4:6edd:16dd:210a? ([2620:0:1000:8411:dfc4:6edd:16dd:210a])
        by smtp.gmail.com with ESMTPSA id g12-20020a170902c98c00b001d9fcd344afsm648352plc.222.2024.02.12.10.40.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Feb 2024 10:40:44 -0800 (PST)
Message-ID: <768a184f-c921-40fc-8405-2777f03e1668@acm.org>
Date: Mon, 12 Feb 2024 10:40:43 -0800
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
 <2e246189-a450-4061-b94c-73637859d073@acm.org>
 <75240a9d-1862-4d09-9721-fd5463c5d4e5@kernel.org>
 <e2a1a020-39e3-4b02-a841-3d53bd854106@acm.org>
 <c03735f3-c036-4f78-ac0b-8f394e947d86@kernel.org>
 <a1531631-dce4-49a6-a589-76fa86e88aeb@acm.org>
 <c582fc6c-618e-4052-9f15-3045df819389@kernel.org>
 <2b45ee45-5f2e-4923-9ef6-a7f03bcb65bf@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2b45ee45-5f2e-4923-9ef6-a7f03bcb65bf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/12/24 00:47, Damien Le Moal wrote:
> Replying to myself as I had an idea:
> 1) Store the zone capacity in a separate array: 4B * nr_zones needed. Storing
> "0" as a value for a zone in that array would indicate that the zone is
> conventional. No additional zone bitmap needed.
> 2) Use a sparse xarray for managing allocated zone write plugs: 64B per
> allocated zone write plug needed, which for an SMR drive would generally be at
> most 128 * 64B = 8K.
> 
> So for an SMR drive with 100,000 zones, that would be a total of 408 KB, instead
> of the current 1.6 MB. Will try to prototype this to see how performance goes (I
> am worried about the xarray lookup overhead in the hot path).

Hi Damien,

Are there any zoned devices where the sequential write required zones occur before
the conventional zones? If not, does this mean that the conventional zones always
occur before the write pointer zones and also that storing the number of conventional
zones is sufficient?

Are there zoned storage devices where each zone has a different capacity? I have
not yet encountered any such device. I'm wondering whether a single capacity
variable would be sufficient for the entire device.

Thank you,

Bart.


