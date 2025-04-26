Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA7F149C7D
	for <dm-devel@lists.linux.dev>; Sat, 26 Apr 2025 12:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745669301; cv=none; b=GZN8P6/EG+/FvMG71kzBWlksfY4Lkla4t72Kqbe3X/XycNf6mHU/3acWZIcqWbp3i1hPCnN3lifyvGTbWw7Jg4+diPnFMP8T7a4IFM5xR9a68bO+ig5rGAUDs17ewns53EeSHXZ28zYqgorAmg9cd/pSzgY3Gdc6yaTLJO3rP/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745669301; c=relaxed/simple;
	bh=cv9zkoKJI7ajfLC5Uay8pIk7YWvauAwuhgvVBRmvrjQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=pvs/yRSeRDcBnlP2UTWPTy+IXPfFbbpR/md7UL8r+9H5CWCtb0YmIC2MWJTwWfNRtBDJijqZoJK/DaFkct6a5zfCdGpDTIFKuUUCEJmpE5zJZy3fKEv3ulDlqedk+i6eb0ESv3CCvExZqCWlFmsPb24aPmp3lHLzO10nOB3RfUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W3gUJG96; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W3gUJG96"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43cf7c2c351so2731725e9.0
        for <dm-devel@lists.linux.dev>; Sat, 26 Apr 2025 05:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745669296; x=1746274096; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dMTCTVRdMnnRM0IvmxhUlBYrvUiYEvzhSkNUdDlzy5I=;
        b=W3gUJG96mQrHUr5c1rs88fB71KOA7kWKCHyxXKCxTReE+DbhLrFUNUnMPMR1NYaiNy
         jOxGdhtj9J3VS1t0QIon+5B0ElBR3YuxhsaWCU0+7raCZ/E2DzEtimRYj52SxcD2xES/
         V2sJfQi8lgRoj/FiPetxEs812Fd8G6mr1Ph5exLnq+mWYCWMFZAyreoTu5kZMeHs4ewj
         FaG6WumLezWT7OKljCGS2XX1edqcJ+4mzcrQfsJYp8Z1wXPcpYbogKUdG5LgVLsbgu/7
         0ZNRyiML493oLGc1N7G81/LbZ09UTaQxAsAEnZYfkp8cW/twZneEMfwADujaeoi/bzeo
         xn+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745669296; x=1746274096;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dMTCTVRdMnnRM0IvmxhUlBYrvUiYEvzhSkNUdDlzy5I=;
        b=Ckmh4dPsJsupM9wVe/mOlY/bI7VgUvKegL40Ll7xf1yUkaMiePBrhtg2lo5nDSg8hf
         yhOSGnPWKKxlJt6diaGtDLab0D5LBsjeExzotimzPszQgtKw/k+Y4kXiXPA9djwy7UZz
         YdFFcJCVQwXINzP0mXicbP5jDpDKXmGX1o/oBH4uxVac8qjL/EOhsdp8WIFJnK7zV+eB
         BEqC2sKz8vvhe++35/MlbP6QEconfcjo7bDe8i4Wi4nwnoqCFeyyVq1n3HkJP1fX4Hx/
         6Ehwr30myU1HO6gkoKArhR6JEMD2ETkpan6W7kRHLNlhzEmKmKTxZbt9KP8bPytPCX38
         8CVA==
X-Forwarded-Encrypted: i=1; AJvYcCUSBCJR/rA+hQcgbvuwGJ3CdcB3o8d/+KqG32Aw4buYVKAQ5UnbblAyt1FhMa6TMeuHOaPg5QMaQA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxIim/bBawO1qxNE39N6EajSN6GSFtNd1M0z7H8CkzoogdLGBF/
	FhdcCAUWzXcsOE52/RxVB5xjhuPK/0I3RrRSlSAQ0qNI3reTRBA=
X-Gm-Gg: ASbGncuIOQY/U/MpOrK/EEOtXG72hlh1nrLFHwLTB8YuvQnZeOJpFrraUOHNFXCibuX
	Vj4ybafnQ0h/ABjniPrZ4kHuuNx6jO2De+Kim7ZHbuxcaUi1pqfZC3dleZ5jVr7usFBwfmt+PfW
	Kbt0n+m5x82f99bkcCfRpmx0KJ2qxrY2P2utyehVWUw1UaG3FV4l3Qzc1H0kzMW0Zd/6BwNe7rX
	iK+BPKC4RuCxV0LbiTzQGuvbeDKfOEqJyym93r7iJHgb3B2tcX5pPgr+UfZDKb572Jd6rr30S6z
	U78KQL7kjUGmkenB2uxXl69rKEekUiXXNdTKVqB5tnAEbBH83gJnY+krNA02BaCA3kSlL6BFhIl
	BRoDNP8d/
X-Google-Smtp-Source: AGHT+IHauUn0kkWTUX4ngcnTkM8g3PlIFCXgE74FQ1SpQo/2cBnlWZ4rGoQS9idvGUQwXCk3j6QLFg==
X-Received: by 2002:a05:600c:358e:b0:439:a30f:2e49 with SMTP id 5b1f17b1804b1-440a66a0f5emr14955775e9.5.1745669296175;
        Sat, 26 Apr 2025 05:08:16 -0700 (PDT)
Received: from localhost (234.red-80-39-170.dynamicip.rima-tde.net. [80.39.170.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d29b990sm94501855e9.4.2025.04.26.05.08.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Apr 2025 05:08:15 -0700 (PDT)
Message-ID: <fe56f3f9-3db1-4627-ade6-6499c6553696@gmail.com>
Date: Sat, 26 Apr 2025 14:08:14 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: Announcement: "stable" branches for multipath-tools
To: Martin Wilck <martin.wilck@suse.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 DM-DEVEL ML <dm-devel@lists.linux.dev>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Hannes Reinecke <hare@suse.com>, Chris Hofstaedtler <zeha@debian.org>,
 Christian Hesse <mail@eworm.de>,
 Mitchell Dzurick <mitchell.dzurick@canonical.com>,
 Steve Langasek <steve.langasek@ubuntu.com>
References: <df3d023177dca2006b5aab4b2c4ef78fe1acf8c5.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
In-Reply-To: <df3d023177dca2006b5aab4b2c4ef78fe1acf8c5.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/10/25 10:25 PM, Martin Wilck wrote:

> the multipath-tools maintainers have decided to start providing stable
> branches that accumulate bug fix patches only. We currently provide two
> branches, stable-0.10.y [1] and stable-0.11.y [2].
> 
> The stable branches are meant as a guideline for distribution
> maintainers to pick bug fixes without major regression risk. Only small
> patches that fix actual problems are eligible for inclusion in the
> stable trees.

hwtable patches ( https://github.com/opensvc/multipath-tools/commits/master/libmultipath/hwtable.c )
could be backported, as they are low risk.

Thanks.
