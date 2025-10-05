Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A916B27461
	for <dm-devel@lists.linux.dev>; Sun,  5 Oct 2025 18:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759689201; cv=none; b=A5D5f602hq1Ym5+AhnRddDlSzPqyUKjRFOdyl7a19qQkcmg7QqN0Fo07Uc9huJuIdGWsJXkgaUV0WRG5NjYSDO3Iskyp1DlzUFBS2q4Iol5JhFRNY+KdIs2FGX0mXahh4H/cVlS5vQXsLR4WBBUhPZKTj3h1wpPS+5RkduSiQa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759689201; c=relaxed/simple;
	bh=nqWvyPXitMdC5oet1oazAlYPRvRdZ22Yg22NBlDixj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tt5czYiELEAyJEIByXJuhoGdc36w4iT40ObuoB3XxTE3/gYNEVvTOzIRHRx8EzqWkX1ohSXetYkidi2dbomTokhCDF1mOAoL5Izx2+BiQA45gUqgcaUBV0OkXY9KpM4GriA3Hck5mKtk6XkO12QHtI6TNPcG6/yEG3h88zfRAxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kY8LAbq3; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kY8LAbq3"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e34c691a8so6879635e9.0
        for <dm-devel@lists.linux.dev>; Sun, 05 Oct 2025 11:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759689198; x=1760293998; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nqWvyPXitMdC5oet1oazAlYPRvRdZ22Yg22NBlDixj8=;
        b=kY8LAbq3b+ya+RGtHgQdIptJBAbKmjuvWegn7C6vx/o2983/KYHlhlfXSenm9e3qog
         ut5cW9UOmtDdwj+WBkdOIhcDvJ3uNtJHsuWkh4ALTbC0sHzwosMUz1DVARj0g9ubhD/s
         izUV6yMAFYpj0yBBjkzRvIkvKcximTbq/mJaFIyogDafHPNU6N6mD5IGxfyu3CR59Rd5
         vW1fLGoxZ4gC8P6OW8Dgy+KZ2+NyJwM9js9uiA+EQt7bPd1ClyFvnTyKGsjxfiCG8+H9
         Dc/0jcFrcbOW5Z9VKDGeacg1rowB1cmjO2DBZQ1G6y/l5jGEIi3kD1fuh2at69I2vajr
         722g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759689198; x=1760293998;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nqWvyPXitMdC5oet1oazAlYPRvRdZ22Yg22NBlDixj8=;
        b=mAj3gcmUf+uTbnIVF2mnO9x/AeEWB1wnKg8UmY7yYHJ51iAv+CuQzBmnOMfIIt8WeE
         yK3Ifp6FN5ZehDzbSyFrS2bZRRBqKJezDu4+eXa+ORlb/9lho2T8VCNNcTbtpPU03pdX
         kl+HxmlI99cmk8l1tMGXP9mlA3HJffgjRpfgYH/zyJefV8eCYMLdShICXPzPoyXkmsl+
         RsHBnaYyQi3ZL2W5Ektx86r+WljZ4J3gaznhvGAsJDMK8dPoWp4RysMy8It1W+rlPpjK
         iF4Hy8ZKJNtk/3PCLzVBQp5e66HXXf9X+1BljQ8fMISh9GuHw+9vCeoUyRSg5pAJK5PT
         vRRA==
X-Forwarded-Encrypted: i=1; AJvYcCWl8DMoXHotEdvS0LNb4q79QZwAbk8ZW/a70PC7vcK75r9jhd/wEqhp+AtF41ZVzUPbF81RtWaYkA==@lists.linux.dev
X-Gm-Message-State: AOJu0YztUvZa3Sk/SctdtDg1zYyC8HMoxnz6iJ74reyWoCLj5v9qsbY6
	h/miwiIRl1QdQmZcX8nUyNqKu8Y7+X39BUh3sLAoUWE2qKB/UAxSGLc=
X-Gm-Gg: ASbGnctSpJRYq5bswZgTIhle5e6BcSGMNjoPTlnQFiQ4bCyvZ35dMB1C4Co+h5lgFR6
	1g5jPRdBVMCUt4a3bQFXwN85PEA0uFVp+P9nY/gZfkrsYbHT1p8yJixpZVWY86KbY4gwQLCzNAh
	YeqkVNEYU8io4A6TLymLCjB4SsNrXcN2oeUzUF4FmukXIPatqzKcUNW0b9vB5xVsX/SE7/ii0Zi
	thygefoy+Mow2g5BVUBolBMYNVxTLxFOWA2Wy+KDCXnnRHs/0F45BBO7D/pWDfTJ4jpHLVR6yYK
	q7K1qJ6l5TiCwlwJh3iVDD8Aa76wgCugN/zMwvTWi3b6gHGr+9OTQ+htNWk9mvfbLCiuDEOV3GV
	jarCeG+96Q9hG6MEGV3nnVMkuCgzyRVwvkL7wO+UKcLRk0UjfyGmTGvciC+FPo0QLzZVF0xPni4
	QWEEKfuTd2KMTQsAYKoqqLGpJO6A==
X-Google-Smtp-Source: AGHT+IE7lOvJUc+Q9KLSQwd5ZZFeQoLpi5aywdpCrA2KehWt3fks+59q1R1qWhLrGtCodRKsUq6RxQ==
X-Received: by 2002:a05:600c:524f:b0:46e:372e:bfe9 with SMTP id 5b1f17b1804b1-46e7115cdf3mr36830285e9.8.1759689197779;
        Sun, 05 Oct 2025 11:33:17 -0700 (PDT)
Received: from localhost (120.red-80-39-141.dynamicip.rima-tde.net. [80.39.141.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a25dbcsm238203725e9.19.2025.10.05.11.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Oct 2025 11:33:17 -0700 (PDT)
Message-ID: <8b3cc8cc-052e-4ab5-a669-726e62f7a162@gmail.com>
Date: Sun, 5 Oct 2025 20:33:16 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] multipath-tools: add new NVMe devices to hwtable
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Steven Schremmer <Steve.Schremmer@netapp.com>,
 NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20250913130221.35073-1-xose.vazquez@gmail.com>
 <a8295cfe0ea955f6d0200ee04523cbd79eba6ca8.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <a8295cfe0ea955f6d0200ee04523cbd79eba6ca8.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/25 8:56 PM, Martin Wilck wrote:

> I realize you set .no_path_retry = NO_PATH_RETRY_QUEUE for all devices.
> Should we use this for the generic NVMe device, too?

I played it safe, because most of them are using that value.
"generic" is fine as it is.
