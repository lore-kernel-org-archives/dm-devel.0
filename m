Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E19A25575
	for <dm-devel@lists.linux.dev>; Tue,  2 Apr 2024 06:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712040137; cv=none; b=Q7V/KywTIt21FA5DbfrBIuy2qASZueQDRlPlwRgiE5IFF/QNrf5Ja2wHx/Alz0wErBMeKAbEGAWZRHrQqV5pHjUPFtMQB4k8qn8ZRLerOgvD0tQQZUR1yxqCjO3zsD/QLm7weLgH7WUSaca4HY2gLczuWoS1Bviyyjwe2qdwpzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712040137; c=relaxed/simple;
	bh=JjAntBOnD5xFGFnRblpAkq+2VumhA3Hem++jWk6Y4W8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=OjQ43iDkNikw2IBWiEq3gOmz0quouZs9NzHMpUDxKVN1YykU5KMSdfEEhFpEDXEKl+jyeLAuywHi9QT/u6YtuxDlsG8/v8kQgE+Hbs4ZSA3jsB8SchYmbivqJp7bRWghJP12Iz+ON8KR2wn4WaybBDDz8L1Zw/iR8ZShT6FtcPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m9QjIg34; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m9QjIg34"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3c3d2d0e86dso2278834b6e.2
        for <dm-devel@lists.linux.dev>; Mon, 01 Apr 2024 23:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712040135; x=1712644935; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uU48DJgFaHLx1/2t1/ZicKir2GW9GbUz5ocKNaf/XsY=;
        b=m9QjIg34XjekOUtPLgRREPbggB+bkEk4Gdx8Wx0ln5TDQ4SNhfNh6LpPXeJT6VLBwt
         NP14zYDXWuQ6yiVzFFvPf9hmYi3scmm8XGxVulE8XGeq17GsrCxTUonBU0JDP2t6MQrl
         n12QNshi8/O/NqXN/B7NntM49vIHeS+sEdW9ujLlTjnfeMmL9qf4b2RrKMMdKWUzKO6U
         DwxYoBXxLULJk6D3RcpG4ES91WQKdNkItd1wLXfIpZ/Dj1dNLIIDMB1FlLO86OBr3/oI
         FAUaPB5x75tJat3ymH/zReQ97KxGX+RLcg81YYE3DReSvyg9gnf2xKi44tFDM/fu94Ey
         FQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712040135; x=1712644935;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uU48DJgFaHLx1/2t1/ZicKir2GW9GbUz5ocKNaf/XsY=;
        b=ONGYb0G2rYcMiNvQo/1kogPD682G84Yak2UdNhfrnoqjy4COKMEzhJpEaDb3QPH/lm
         r5RDyrrcRDj1vLQHTzLRtjDrK3nER7cNUXh9VxpahjmXmvnBfhwFvoxAblOxPFddEa0M
         F1qtK6oDzX3u9NbEvWDy1dcZtVcuPvGs58a9yhRBDi4opsuJUWsL0eGCzeZJghLO5iLW
         pId2XeAv7i0K0djNvvK0VFkV3jKkKgwAw25bkwsFgLnRD1gsOXGgxnSQEHziTkRPDtwc
         g2KISVD1qs413peCf5YaI6C7bArpQni9+uwRph6vxK12uBWISUtJksgdsdwQXGqsTFk4
         nIog==
X-Forwarded-Encrypted: i=1; AJvYcCXoQZqGuYjAR5IomTc4ABmiUBJUnLVRIECUSvUlnIe5/8VHZUwzQWuS2vfMLpgY0WBK7/qo+IoMT6Xn+8f6AC34I1n8gOunk+Y=
X-Gm-Message-State: AOJu0YxSA0WvxzF1p48JZX5+a0K5mrlMi8D4tq6sMqbPpaUnAZaijshz
	F8cneXWSPgB5yDTE+st0rDg2FfgSJ04LELr2VhZdMGeGqRrRffI9
X-Google-Smtp-Source: AGHT+IFJBRPUzzyLOZ+Iz+JssAjGs8OrSAfHCaYLwSwDXfN3nVO69I7ZzxGjs/eatznGecPM52vC8Q==
X-Received: by 2002:a05:6808:19a1:b0:3c3:e621:4bd2 with SMTP id bj33-20020a05680819a100b003c3e6214bd2mr14487788oib.8.1712040135376;
        Mon, 01 Apr 2024 23:42:15 -0700 (PDT)
Received: from ?IPV6:2600:8802:3800:75a0:2378:fa3f:c6b3:24d1? ([2600:8802:3800:75a0:2378:fa3f:c6b3:24d1])
        by smtp.gmail.com with ESMTPSA id z9-20020a63e549000000b005cd8044c6fesm8907652pgj.23.2024.04.01.23.42.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 23:42:14 -0700 (PDT)
Message-ID: <f502ece5-4120-40dd-999f-2904ca5d0b38@gmail.com>
Date: Mon, 1 Apr 2024 23:42:13 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/30] null_blk: Introduce fua attribute
To: Damien Le Moal <dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-20-dlemoal@kernel.org>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20240328004409.594888-20-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 17:43, Damien Le Moal wrote:
> Add the fua configfs attribute and module parameter to allow
> configuring if the device supports FUA or not. Using this attribute
> has an effect on the null_blk device only if memory backing is enabled
> together with a write cache (cache_size option).
> 
> This new attribute allows configuring a null_blk device with a write
> cache but without FUA support. This is convenient to test the block
> layer flush machinery.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke<hare@suse.de>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck



