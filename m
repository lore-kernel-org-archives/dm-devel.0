Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9568A2D0C89
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 11:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763465951; cv=none; b=DiOnZeYWmC16IXSHVZiIL6C0Vzdi3V0Dt2FNk41TrnqgqBPiSWbasuXVhN58LbJm5Sbgp95Ja2yJYy/yxt1ydKja9HVfR7mOAimhFw/Rw8p7ojahbmKl2cFGSsdI8eXpqApt/YjhcIKwD/DG4g9pHvaVU7YadOQzLwZINTOD5eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763465951; c=relaxed/simple;
	bh=lstkbu9jeYEj+mqjxq9BNsch8aP/MpxnagJpphhbA7I=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GYOE6UDBUbsOhX5cVno2/kZsLV5Yboo1Nj2C1YByyw0ffYMb3TlvIJUt22r9V5zUpKqz9PN4oFYY/+yWMh4XDCHJP0scDEWuDcLsB53izRo3uTuXzpEgPtObjsTPVtmGFR0ucG7t1GW3Nju1SOVQ4tUpIQQgS7N6BsTlh2ljWqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WKLKx1H5; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WKLKx1H5"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-594285c6509so5563807e87.0
        for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 03:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763465948; x=1764070748; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rlTQClVvmrzgofylmc+Uoi7ksLdBMhV5f6NzAqw9ixI=;
        b=WKLKx1H5UK/WdfHzdfKtT//7Q4kIaToCenYhwrTRgrV9o7jJslnKYvrwyYTeIHvw6m
         iP2vemw9XwXZkqfO7OLKTlkYHkdzRefvFoK7rJ6WRwiV4AgrOWWKrsZKj8r3Zsrwx52C
         6QduyS3+I5dNf+UOImY6+rdvBKG29TLQBHkXQh7h7owmZR+lHAyDOAREadAkySWKpZCg
         gKtk0zToUk4S+RTnxsSnNj2qZXVYOz8fGGGmPyJ/ceqF3odNHYgNCSPVuqW7iIC+zZLB
         7c4soZ9w5iNJjbB/JPvnL2ocxUa/+za1iG695ryBerQ1kFWxTJrvSSgcvTeiUQkLF/Qx
         NowA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763465948; x=1764070748;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rlTQClVvmrzgofylmc+Uoi7ksLdBMhV5f6NzAqw9ixI=;
        b=h1+kQgUF2aka9UFFJ3ujJ7gTABt5dCn+H2zUcSW+DQBnjJuAUcvuO+s10Rf8kz01Ok
         8WSi4BlU/brtYJWJDgl85mHuXtB5mmvDrrgUvMYAkmZgLu5aOb902V9I7ImSfAlJlaJE
         zokgWS0cTE749iiizIvtARFeNlTSaRKUb7/Tkcorur9MSUXOxnYe2v8Lvk7F7IlqhBDt
         h70rFtmFHuy4EM8C5bSU1j/qgYSd/ytFT2S3xnwim6a8ZqhrN/ftRuZPIIa/vE91zj9J
         lvoN4g6nP24ebYUhnpIlg0w04PrvyJnHdTDdJ+yVMLqRpemM23K52bOIvv0pp4iZtfPG
         vjoA==
X-Forwarded-Encrypted: i=1; AJvYcCXlxQF8vUEYxKuQZUl5eiPMLpADyHuZlcMqeWp/oa2HfZeYqdkYFEBxxH9RBq3exSufKhh9LM+T5A==@lists.linux.dev
X-Gm-Message-State: AOJu0YzfWqHQxeG2wS3X8+Pks3oiTaPYkqNVBukDr76tt4/qg62MWAXa
	foHU1S79CbkpEgiN8vQ7cq9d2aiyImDruxh2aM3Lt0zHLAqIM+EAAUPK
X-Gm-Gg: ASbGncvQbJHSSC8U+zDzup7ZI5qIaMPVMTqFslxObjumHF8ek0tIy8Us16tFHTVnnI9
	cZnBEmkFxb5/2gMkx+mwYX3FpmLxNqq6OC4FW80R0AVDkT4KTzf2L/ikArbwPEfi/hM6IaoLijn
	yNclr1oH8bMR3+Zlov8psiT+vRST2rnproSGmR4zzpIb3FfAw6ydMoQPUgyA3+AeVk7KfenW3SM
	lk4JuNn6Z80bJxsHvmkEtsbiPbyBzwWDqTMqVyZZtKj7yZsotz5mYnkqTkUm/zptDAVSF+s6Ihs
	BjxSIwWHikaIgOG1ngwfSBtcvQ88dGesPr1QQtAuj/FFbLp6VFSSZg5B5X79mhHf+tybN8Op/XK
	791nIzMk/L8gljE0sPx+0mGlsGoIFqWCPpmnyi1dwKrdZz7cF5mWt8muiiQdx3/f0uTQhPfZLHH
	qRUOfxhfhrtIezc3gSzwSRGOT4i399Kg==
X-Google-Smtp-Source: AGHT+IEKGD7PXMBcM20Woz6ev9FO4W8dNz70vLMNsY0OMuwWIAFzfu3DdhtYGT13nMWnijRMcLW3JQ==
X-Received: by 2002:a05:6512:39cd:b0:594:4b55:d2dc with SMTP id 2adb3069b0e04-59584217be0mr5431052e87.47.1763465947450;
        Tue, 18 Nov 2025 03:39:07 -0800 (PST)
Received: from pc636 (host-90-233-212-127.mobileonline.telia.com. [90.233.212.127])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-595804004b5sm3919144e87.64.2025.11.18.03.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 03:39:06 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 18 Nov 2025 12:39:03 +0100
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <aRxa1wPMsJwBubjx@pc636>
References: <20251117105945.10179-1-urezki@gmail.com>
 <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com>

Hello, Mikulas!

> Hi
> 
> What is the logical_block_size of the underlying nvme device? - i.e. 
> what's the content of this file 
> /sys/block/nvme0n1/queue/logical_block_size in the virtual machine?
> 
It is 512. Whereas a physical is bigger, i.e. my device can not perform
I/O by 512 granularity.

As for virtual machine, i just simulated the problem so people can set
it up and check. The commit message describes how it can be reproduced.

The dm-ebs target which i setup does ebs to ubs conversion, so the NVME
driver gets BIOs are in size and aligned to ubs size. The ubs size
corresponds to the underlying physical device I/O size.

So your patch does not work if logical < physical. Therefore it does
not help my project.

--
Uladzislau Rezki
