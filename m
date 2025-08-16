Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951BF139579
	for <dm-devel@lists.linux.dev>; Sat, 16 Aug 2025 17:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755364556; cv=none; b=D9hJzairaMLnzlI2iJlKc9pxNkmErUxAbzXWGjQZPoEkev9X3HkxrW71Yj1+6fS8Jc5JZKzDHFFPaUZHA6LXPeUXfdl5SdUgfYy3WMemIPPfcO/yn/45XJRrSr9da0GNtFHrt1FIH4YXDKlT0Dulha2UMp4FFkIimXyU9EiuAdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755364556; c=relaxed/simple;
	bh=ThKzClGHA7jgqPLOlN8mJRduE6aRMNGldbvyaEZ3vv4=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:To:From:
	 In-Reply-To:Content-Type; b=unczgdk0pYUVQk0qBpd91VfUjCVSU0FDBX+fsGp1DrnLjYyYp3KcgOjvChbF5fhCgkRAY9eVkHnSmSAIUn8a7rKTdmU3+axUpjgp8S0FBoAy7C5jMOmbQW+tlONBqCVILHYGia0k+oJ2345sGHYSXFKx8aacJNdWtChj9lQxjxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CUOCMt4O; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CUOCMt4O"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b9d41d6e34so179862f8f.0
        for <dm-devel@lists.linux.dev>; Sat, 16 Aug 2025 10:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755364553; x=1755969353; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:to:content-language
         :references:cc:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=17xGCAOYPaXnnoQHmlg6SyfhhHnDFJ6cUvyz6KfIIP0=;
        b=CUOCMt4OzuPLgABOCT1yW4R6NvRIRCT8Xwh6LBEf7BCIO5XXUp8W3swMpWRknvicaJ
         uqH4RCUD/QNSOF6iyMo3hrQx+3QXzeLUXu1Wk6vf0mgKwzPWRYBWFrFAX6vWQNte+omS
         ZiXXYgyl0eEaJNT+p4XjNd3HaWR9q6PggP7zlewhgbI/lKmuM/YPhgqXH119Z90G6L5Q
         mh6xuZkGFH2T1s4sHUdoWG0Vuci/Jzw8+8ThU/MIl1jbT3rVffsUoNxWGn7lZK40uFsX
         F8gPqQ/7zG2I2gUlfbdYXBhxTpz2QMC3zAdnWY2tD8JBDKukiQzRizoK0ALD79lhj5mV
         bwSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755364553; x=1755969353;
        h=content-transfer-encoding:in-reply-to:from:to:content-language
         :references:cc:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=17xGCAOYPaXnnoQHmlg6SyfhhHnDFJ6cUvyz6KfIIP0=;
        b=lO/+Q/FYwGCRms8tGv+j24PLOEHMiPRvTjnEV6UOYAeGuTk8ZY6LJC2EqgCyBYgGvc
         TfmMfTDf9v6pkmfW25rNDomSF2nqXm1ZNCZ9oA2foma/YEJmCkJjc78yHGfi4QTvYz2V
         N+JMB5pTDlcCdwtGuteQkx2gstRnrxuR4cu0Cas5vR6orl5BxSvUMkhG+ke/ZwDvHHN5
         VXszCGmlmQDjdH+XV3hpuT2uJt/sD4CnH2wYr5+Pt5o4OpFs9Mfw5Kkb9Y6hN9DjaKUC
         S3mgnGD+1rmpFKm1L/HaG2BcdAew2dcC8IAEvxAUz5mkKlYGoHQC5yBeLVNPcVIea9xE
         KpuA==
X-Gm-Message-State: AOJu0YxXrN8RxjJsmlMVtVxqNwHgv+Fj8zCVkeR8xToH8mxPj12S9Eud
	TXOkWaOcHnlQOMCoyapobP6GHr79sw3AYNytx5NotLakZEML92YKr32z0oJjTJ9bvypN
X-Gm-Gg: ASbGncv1kFXjCngk4bmXWPycAu2Ir7kyeLz+XtcADmKfVG+EqlrQudVy/5w9i2ENoom
	joUj/p2jM9NYb7PmTHIWru9U7+QayXsLETrzJ9fZ4Emqq7Yfbc5fUKVVVB1rex1I9epmfvs+z8P
	NvA29F9rkxF43LJWeRjyfIshft1cCzS7psAMwiuYFwU7QYhxY916d6OFXY90VM8p6ekRniSav9H
	plwRq8qnTpc/y17JkegqFIG9FMSWtFLYnSXP7ll2bk+H3W2k9Y5Qdc4Dv/S8O6E3aMQSrB55YTJ
	x7bRRPopCC82FjO+z/vkSnyNA345mZW1h0lxbXC0M/Vr10sZf1WyzjkAYQbab7X/DSk2h5Xs1+T
	S61qvI5vOWyLGX32lfo+fDllGxA8RWmoPn8AnfH1krYAVRIge6ARm66gTKiHg
X-Google-Smtp-Source: AGHT+IHd/4fzeAVJN3EXLt7ZlstRloPqKelylWmj3/Y+2tnuaQjwHYDO4ph7lm/aJohEgv2+8c04Dg==
X-Received: by 2002:a05:600c:8116:b0:43b:c825:6cde with SMTP id 5b1f17b1804b1-45a2314999amr19516375e9.3.1755364552681;
        Sat, 16 Aug 2025 10:15:52 -0700 (PDT)
Received: from localhost (67.red-80-39-24.staticip.rima-tde.net. [80.39.24.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a22321a54sm61127145e9.18.2025.08.16.10.15.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 10:15:52 -0700 (PDT)
Message-ID: <7ccfba05-ec5a-4a42-a1ea-5254e7b7d97f@gmail.com>
Date: Sat, 16 Aug 2025 19:15:50 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] nvme-cli: nvmf-autoconnect: udev-rule: add a file for new
 arrays
Cc: Wayne Berthiaume <Wayne.Berthiaume@dell.com>,
 Vasuki Manikarnike <vasuki.manikarnike@hpe.com>,
 Martin George <marting@netapp.com>,
 NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
 Zou Ming <zouming.zouming@huawei.com>, Li Xiaokeng <lixiaokeng@huawei.com>,
 Randy Jennings <randyj@purestorage.com>, Thomas Song
 <tsong@purestorage.com>, Jyoti Rani <jrani@purestorage.com>,
 Brian Bunker <brian@purestorage.com>, Uday Shankar
 <ushankar@purestorage.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Marco Patalano <mpatalan@redhat.com>,
 "Ewan D. Milne" <emilne@redhat.com>, John Meneghini <jmeneghi@redhat.com>,
 Simon Schricker <sschricker@suse.de>, Daniel Wagner <dwagner@suse.de>,
 Daniel Wagner <wagi@monom.org>, Hannes Reinecke <hare@suse.de>,
 Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 NVME-ML <linux-nvme@lists.infradead.org>,
 SCSI-ML <linux-scsi@vger.kernel.org>
References: <20250815202133.51160-1-xose.vazquez@gmail.com>
Content-Language: en-US, en-GB, es-ES
To: DM_DEVEL-ML <dm-devel@lists.linux.dev>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20250815202133.51160-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/25 10:21 PM, Xose Vazquez Perez wrote:

> And it is unnecessary to set ctrl_loss_tmo to -1 for NVMe/TCP devices,
> because it is the default.

Totally wrong. I misread the code:

$ grep NVMF_DEF_CTRL_LOSS_TMO drivers/nvme/host/fabrics.c
     int ctrl_loss_tmo = NVMF_DEF_CTRL_LOSS_TMO, key_id;

$ grep ^#define drivers/nvme/host/fabrics.h
#define _NVME_FABRICS_H 1
#define NVMF_MIN_QUEUE_SIZE     16
#define NVMF_MAX_QUEUE_SIZE     1024
#define NVMF_DEF_QUEUE_SIZE     128
#define NVMF_DEF_RECONNECT_DELAY        10
#define NVMF_DEF_CTRL_LOSS_TMO          600   <---
#define NVMF_DEF_FAIL_FAST_TMO          -1

It's 10 minutes.
