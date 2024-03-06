Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4171E488
	for <dm-devel@lists.linux.dev>; Wed,  6 Mar 2024 15:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709738947; cv=none; b=hV2A40PdEsX5hgKyMT+P/N9LCi1TRDYDNWUNezVhv2ourWZhHyCtx28Q2cRrxh74xGJuCBGdrKZInNoFtjR73DdO+4EsXCSaOl9Ng5snwCIMAIeYNnoynDISs2isjblkeyRPlBiK4pwb/oJVTNCfhngP6HYPNYk7tFqyWVCBenw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709738947; c=relaxed/simple;
	bh=VhXw0RGdwJ3yBwNfC77fS+QJ5ba/tqo/u1fSxdI9gVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CMeMNuiqtZDeMzfCgpLpmYrfS3O7n+r3yKVEbBX1D2124KcE0pplzcz4WQxsauU7GuQ5Z+40/+s3DBpK005rPr17mMQAaGt4MJSewG3PuV7Rd+RH6PlWa4ssPZ7q+H6NuHvrLYCdJDvMBazwACXnL3Tl4kwpgSvE3qB6d2EQVG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cIqTOVew; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cIqTOVew"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7c49c979b5dso102478639f.1
        for <dm-devel@lists.linux.dev>; Wed, 06 Mar 2024 07:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709738945; x=1710343745; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HuiHolB1Euh2agtRTRDo+ej1B7ApR1A/nMWa1zjFtyM=;
        b=cIqTOVewhegz+MTVq69YQyW7uMlOWaW5mpmVcYt/OCj9a+bScpu86WMrRbxV8pv9Td
         CjHUufGoRSDS/utpl+uAs59X1O23bh4wEQ4Iy7kRO9efnH2Hy12uwGB+RclhCqGZn/rn
         oGUClxkGX9SzbNiH9OuZusLao3HPGzGWa379r1FUxVz8dO4jn5jY9qFt1BejP57rCaxz
         9QA4BlMktxU9THgIfKHKSLJeW5kOv6iu4f8bdEd93Q3yb5AI3innf54mh+q4AXGHeved
         b2fdsO70il1Fb825lKMGdY4IJ7yJ7CQ2HXv8kb7MDKLdekNf2Iq5AyFoiTDaFp221BN/
         M9bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709738945; x=1710343745;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HuiHolB1Euh2agtRTRDo+ej1B7ApR1A/nMWa1zjFtyM=;
        b=Dz9sxm0LysK3HeoSoKHy+e02fybW01PVhhqBWQsnnuV/5FofSrsF7QV/EvbF8n4qxq
         IBaCiSn3FEmfo80JoG+V+L/rCaU18EreW/RDIm/d6LorCRxytylIDQX1H+M7m+XSvLjq
         Y8b6Q6DSpBcKhin7RUubVaYTTcTTMxnlYrgPr4Y2nMasMc7bSQO2y6uOwsYozrek0dOI
         CDlueAk7Mhz4hpHD74NxB+Usf6lxM/1uYbRg+31cKw11BDznBpQFUBA/UvETq48Wc7q6
         HbMbAzyVbdp5vdbTyde6NovKdXSDatvHXoF12BGFeg9Sz7Ald4RateqkgSgbXZp7mjhy
         QFag==
X-Forwarded-Encrypted: i=1; AJvYcCV0Nuv//ZK3ZNDd1KfcXct4HUxeS3XED72P1e7h4KI8bGDbuMlanBu6o9vHYz46Wypu4gKltfkEQsltolgxB9F66ois9P113qY=
X-Gm-Message-State: AOJu0YyiYmqVblOg0gcCy0NADcUyE9DDnW9Hksi5G9P8m5KM4v1rvSa2
	5/zx4Y8+ZsQjM3EGMuViNVdzJ84tREmGhL3PCuQYDT9ikQGF36cyX/fWQ6llTzY=
X-Google-Smtp-Source: AGHT+IFfFfT6TfzD8hpsFF9DRyNIvUMsP7yklx651z5MiIECpjaDta7a2YFi5GznQsk+b7UFUUVBlQ==
X-Received: by 2002:a5d:990c:0:b0:7c8:789b:b3d8 with SMTP id x12-20020a5d990c000000b007c8789bb3d8mr1868870iol.0.1709738945072;
        Wed, 06 Mar 2024 07:29:05 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z20-20020a056638241400b00474e0c312acsm2291532jat.49.2024.03.06.07.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 07:29:04 -0800 (PST)
Message-ID: <b4731092-7028-4852-8186-5bc805bd1ba6@kernel.dk>
Date: Wed, 6 Mar 2024 08:29:03 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.9 20240305
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Cc: Xiao Ni <xni@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Junxiao Bi <junxiao.bi@oracle.com>,
 Dan Moulding <dan@danm.net>, Song Liu <song@kernel.org>
References: <1C22EE73-62D9-43B0-B1A2-2D3B95F774AC@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1C22EE73-62D9-43B0-B1A2-2D3B95F774AC@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/5/24 4:42 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fixes for md-6.9 on top of your 
> for-6.9/block branch. This set fixes two issues:
> 
> 1. dmraid regression since 6.7 kernels. This issue was initially 
>   reported in [1]. This set of fix has been reviewed and tested by
>   md and dm folks. 
> 
> 2. raid5 hang since 6.7 kernel, reported in [2]. We haven't got a 
>   better fix for this issue yet. This revert is a workaround. It has
>   been applied to 6.7 stable kernels [3], and proved to be affective.
>   We will look more into this issue for a better fix. 
> 
> Note: Some recent fixes were shipped via the md-6.8 branch, so the 
> md-6.9 branch doesn't have all the fixes. I tested that there is no 
> conflict between these fixes and those shipped earlier. I run the 
> tests with upstream kernel and changes in block tree and md tree 
> (v6.8-rc7 + for-6.9/block + md-6.9).

Pulled, thanks.

-- 
Jens Axboe


