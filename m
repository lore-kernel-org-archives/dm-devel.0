Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E0F1F76C9
	for <dm-devel@lists.linux.dev>; Tue,  3 Dec 2024 15:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238568; cv=none; b=Sh2hl0pUw8glCvaJTLEk4m7BEbLdgZZRx3BKS0bnFaOhiSsxVLN8n3jNyd5iYYnc5r4o9m6+vZ1DwRdYCgvdj/2KEJszWdDskiysKSakqwsBOM1BshrQfjZDUDklx+YQmvCHmFGayd2IR2JVhe9Opewg83f89IQiprdEKZL7LqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238568; c=relaxed/simple;
	bh=ptJpUzd/BhAIeWpF97J96wy/fzTMEo/QGYZYJybeNNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RDlo3N+2IT5r3Nrgc40tvb5lme+ry6sC1dqTSLGTCkJzmVfEdfWQ/w7GdhMkqC8laIw0mO/7UP3FG0MgNpUYOQObp8qFpaSZATuN8BFiKJ3tcQCVSB3MTfURRUX6mn9MEAs50Wn7cAja/q8NG8OkgIWtUM67yt7A94JrOHl6HKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KC6/IIv7; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KC6/IIv7"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3ea411ef5a9so2727369b6e.0
        for <dm-devel@lists.linux.dev>; Tue, 03 Dec 2024 07:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733238566; x=1733843366; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ii6/Eam+Rd1w/XN536sPdorZmSq0gN6Qv3+oQutPo10=;
        b=KC6/IIv7C8U2PUFUtv5pOPwJvAc+vvUEsJVcLKw39IiccVGP1jTx7BHyZQe7BE6ga2
         0Jkcw+CRT1fttDRWJEw31TG4/vfSCNz4GtpGEJfOQZnZGjYNxKMbzhdMJ99cFsEmqXp0
         yA0XVT4g8cQ1rHeLO2nSAPp0aXCsp+WWwnU+tt2DLCBPoSGFfJsmki1TREsCmWvk7PsW
         CmFUa5yc/3tRIV8DOvc27UVUh7tG7bJdoVf3D/87ww8qAsf166pXYGm+FGCdfO+Zql5M
         3f/FVLoVwNCVgyryH+G81ufDwXsReFBqtx/eI6lDEVdLAfDeJ6pA/uQk0U2bKAbCyS36
         az1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733238566; x=1733843366;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ii6/Eam+Rd1w/XN536sPdorZmSq0gN6Qv3+oQutPo10=;
        b=c7FXhbqgFWotXpcsPGDBpgnsM/yHc3nDL0r70LY2xiOpgRvPNeYOpgc1X27/mEDOkb
         yJqvIsxivU88o3G2lBvESFJZW8UjTHEhYjD7Tc4e6kw94Q4ND4121TrajhR0IBDryHKw
         mISZTSnqRU/Fc2KWt7RGw21JfWLorJwfrG1k3A1vXgbJceZdkxGfhO4lxFN0llzsRTch
         Iai7y43EkT/6/qDxgrxaYn0+FCF5wYh0Vdgrfg3pYHD/CEZHVG7RiKhSL/XKuoOf/BRl
         iDNd/5vh8hjvuIDizLdNykeWbckR0b4BJxdB8h5B534JGqHTLBUMe7rDBbB3BZbPnCKl
         mxgw==
X-Forwarded-Encrypted: i=1; AJvYcCVXFNvhPP9mDVP+mRLNfzT/hEm39Owlo7IyR7ExxPDD9FfA1c9lwuHsqRyzcMaEfjwjVbrjQPKdbg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxKco4Cty0v5pRSNf+AN3qcGW1uUZwj12OdGMgBP0JMJ7GE3Y2r
	qk4Kdy4QDwQp7wqcoIC21paAgFTtIpyhN7m7rzFjaxmUstQu8NNGmSCAMgdV1cI=
X-Gm-Gg: ASbGnctfIYR92QDJbpcWob+m5OHG7vlIBVL68vKm334ubv4r5oEa0YeF+H0Ao7vPiK2
	6+XdMn4dvlMfurqbkI8BFOpin7ERKTDxttoYapgkeDcVe6cR8aVXLfCQP4RuQFFxyv0Awb8s4ku
	Oxy+5arqvJUF59+tiXe2BsWPqQPtn+NXEpTKexNmNctTnfdrQdS0h3rSjGp5iyirOJYXlWxGd1b
	gEyRMmFVhCbubMkUiztwk+K0nJf4a3m10OLszx/ioYbSQ6l
X-Google-Smtp-Source: AGHT+IHdP/r0VTOfmHgK6zsgpRftwhI0VmkZTrKusX1MqvGl6wn141rPYAXz2iiNvED/ZdfolUyPmA==
X-Received: by 2002:a05:6808:3843:b0:3e8:1f5d:b7f8 with SMTP id 5614622812f47-3eae4edadc4mr3237519b6e.1.1733238565720;
        Tue, 03 Dec 2024 07:09:25 -0800 (PST)
Received: from [172.20.2.46] ([130.250.255.163])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3ea8609f140sm2829517b6e.19.2024.12.03.07.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 07:09:24 -0800 (PST)
Message-ID: <c3407d1c-6c5c-42ee-b446-ccbab1643a62@kernel.dk>
Date: Tue, 3 Dec 2024 08:09:21 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v7 00/17] Hardware wrapped key support for QCom ICE
 and UFS core
To: Eric Biggers <ebiggers@kernel.org>, Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Asutosh Das <quic_asutoshd@quicinc.com>,
 Ritesh Harjani <ritesh.list@gmail.com>, Ulf Hansson
 <ulf.hansson@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Gaurav Kashyap <quic_gaurkash@quicinc.com>,
 Neil Armstrong <neil.armstrong@linaro.org>,
 Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org,
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
 Om Prakash Singh <quic_omprsing@quicinc.com>
References: <20241202-wrapped-keys-v7-0-67c3ca3f3282@linaro.org>
 <20241202183643.GB2037@sol.localdomain>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241202183643.GB2037@sol.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/2/24 11:36 AM, Eric Biggers wrote:
> On Mon, Dec 02, 2024 at 01:02:16PM +0100, Bartosz Golaszewski wrote:
>> The previous iteration[1] has been on the list for many weeks without
>> receiving any comments - neither positive nor negative. If there are no
>> objections - could we start discussing how to make these patches go
>> upstream for v6.14?
> 
> The way to do it will be for the block patches to be taken through the block
> tree first.  That will unblock the rest, which can be taken through their
> respective trees in subsequent cycles.

I can queue up patches 1..3 in a separate branch that we can both use,
and that can get pulled into for-6.14/block as well. Didn't want to do
that before the rest of them are ready. IOW, if it's going to be bound
for 6.14, let me know, and I'll setup the branch with the patches.

-- 
Jens Axboe
