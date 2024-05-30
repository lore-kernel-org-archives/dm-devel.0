Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708A1208A5
	for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 21:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103009; cv=none; b=BtULze+QaZgrFogh4zxV908FHdy6B8nW2GBxgLwD3jaKb9vrLURbKPX4NAPiT76GzizceqQHBQXApMtYkCmrF5X0hPhPmjxGm1nZQMrk6441H1ZlnIQWCT7KCyQPrSmyMTSwB1Yw7zXxfVMw6R306CuuxMRCdhhnA03dkwgrFKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103009; c=relaxed/simple;
	bh=z1QkV/oN4PrtxkXkowk2WXG5mwwAmpepcbaxRHSK50k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=R3Oeu2KvuhrmjeMN0OPWOZyzAqchdrZ/N1YRDg8rEyROtPSeG+uL38ykR7XHLlDJog0DqjzIYd3ZNDAek2jWelCgfIl8dDukaJqZzAj9sMJLcBhCpJWOeE980P+m8Kz7Y1MHfpKzgu2GQgoBdTEi60Sio6cx8CHebA0VChyy/78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1xe+uWR6; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1xe+uWR6"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6f907a8d289so19278a34.0
        for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 14:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717103006; x=1717707806; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8ADwps8sC0bvy2KrBBRv+blQLWKGCsgQXNcwl/1TWNo=;
        b=1xe+uWR6g9kNN+v7hGiIHl0SAweWzKhgtToUfmsO3Mk3ytCioSSh3oZMLnIxOrstWF
         C8PGM1D2GjKsQz8jzjWhbV3Iuo4gQe5Bzo9f9MbyAMo+s21v0vHTPbXSI4jGKJa8Cq9g
         /ifCj3o8PXYy3Tahjs2JWHFOqW7ImqtjaJMLBJp5MjP+V8OlCIjVJkRhBUbAqk29VM59
         UmuaQPy9sLdFNZH8yWCxUik6IHpC2MAZ58zKDVhuAG8V158jimvKAkAwfVF15K9VAO8H
         mM/X+4ILwvn7gsXdUWMLFW5R0aToZ8h5I6U3RH23lKC14/sD+wvrOOe7z+3ZW5bMgK19
         R9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717103006; x=1717707806;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ADwps8sC0bvy2KrBBRv+blQLWKGCsgQXNcwl/1TWNo=;
        b=uQGdvDbRlHTTdNWc51ccAVWpRbj8kRILt+QmMbCle/CczvZk5fDkyvUVEdk58R2KtQ
         ziHOBOyQEeau+nTJRLIGm9t+lODyFu3A19gCqTn52RTWc2JLv++PH7r8RYcQDzL0pgRH
         wl9/dschrlNAaqCoxhLNp9qavJpbfGqp/v141u6551tJMdZtyfl5gjRTezjnWyVArwTt
         RCddqgZCkZcvI2fXQG/ejcOX7VAa14YUN2OkYz3OFwwiWofcRvpsb9SEyGXpDS28HOh4
         31eFmWt72Suf/I0FZVT+08pUyRIHKA45p+LyDGn6P0cAECYyBNheK/yc4d4rt4n8UZeZ
         r01A==
X-Forwarded-Encrypted: i=1; AJvYcCVrK+M2mnISYWq91EiHHKGCxqIwsh8Cu8q4ps0lePWvaxcVjKWghxTvndEZ10hugydFdYf2iCu0b4j+6i+7NZ8z8VXmhmVrL4s=
X-Gm-Message-State: AOJu0YwWocw63TParPxIPxOthHgd7HTmtxmjDbPk6sCjmjRXKuP2pkaI
	vmeN18p+duWJyKogyXrbSGCp1ViYhBVSIU0Upc+ThvQp3MeTqOmqzdUQEEo/S50=
X-Google-Smtp-Source: AGHT+IF59a24algYsdHIAtCu4zdmdj/N+NLGFiVkQN1zMHhH16wEcxkPdyBROz5FEWzkyW5od0gN8g==
X-Received: by 2002:a05:6830:7203:b0:6f0:3cf3:fb35 with SMTP id 46e09a7af769-6f90aee6d10mr3391090a34.1.1717103006452;
        Thu, 30 May 2024 14:03:26 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f9105239d5sm100984a34.6.2024.05.30.14.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 14:03:25 -0700 (PDT)
Message-ID: <1599ad1c-4395-46eb-9b9b-7439850a8300@kernel.dk>
Date: Thu, 30 May 2024 15:03:24 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Zone write plugging and DM zone fixes
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20240530054035.491497-1-dlemoal@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240530054035.491497-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 11:40 PM, Damien Le Moal wrote:
> The first patch of this series fixes null_blk to avoid weird zone
> configurations, namely, a zoned device with a last smaller zone with a
> zone capacity smaller than the zone size. Related to this, the next 2
> patches fix the handling by zone write plugging of zoned devices with a
> last smaller zone. That was completely botched in the initial series.
> 
> Finally, the last patch addresses a long standing issue with zoned
> device-mapper devices: no zone resource limits (max open and max active
> zones limits) are not exposed to the user. This patch fixes that,
> allowing for the limits of the underlying target devices to be exposed
> with a warning for setups that lead to unreliable limits.

Would be nice to get the dm part acked, but I guess I can queue up 1-3
for now for 6.10?

-- 
Jens Axboe

