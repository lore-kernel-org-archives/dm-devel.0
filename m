Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56DE30DD22
	for <dm-devel@lists.linux.dev>; Tue,  3 Mar 2026 07:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772522377; cv=none; b=IA3eaNO3y4/kd6uTRomCsd1MPEpIPcXzMcO1Xu+z1bU4ln+veOr2MyyY87DDyzklx6otjgrqmhMYSD89DCnbBVzMO9RgG6IEpRXOhBmJJTDNxu4iAJ4fNdQMPxiW9VD87B0vYeDqBVIXLKigSDKXBlSUcWyfTdpwP//KM5y+a0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772522377; c=relaxed/simple;
	bh=CwpYG7JVqX3mAprWsx7y8qvWB1SdKDYQNXQBFtdWS/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wmf9At6qAvBGcGnl0hBeZG54oV81NHY70Nh+qPKkD4H552+FCINQ5wiD6F5EAPgqykmWwQwXdSivPRCEjuuHiseqnqc2AffcqnVStlslXpjJStTXMrY/uWtp7VxzkMuCUbFBZy8h00CtviAbwJAGwWNQjwyHL51yaD8xWipFMSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UB6F4Rmk; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UB6F4Rmk"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-437711e9195so4089544f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 02 Mar 2026 23:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772522375; x=1773127175; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=emzxcalxhefyJPtrnF5BVbzsZJUc4QzYRAPUO5dkvYQ=;
        b=UB6F4RmktOUlU4uUJ9+NPZIQ85G8vc9Eq2xTs61940pD2yNfgqWDGCEi/il5g8mzm5
         ctPm/zYFn8PkLwm0OpmgCYG/RWj2igsnkcKBkk8YKeKISqxFpqeLO1/b+k7lFUkDIxGy
         D/bsl4HyKg+LM7tcytR7UPrXoFJQ9gRDlE30+YrbyUFAOwvFOFfwpooinUlZzNCJnwnc
         2uUJeq70rVhQPaeQ1FNHIptVGTzG6aTUIHZbkn66TZtm2Aa4adeTYetYKRMxZsVlKD+S
         DOMhM+BrzmodMCTU1BAjtWyL/396KKeinV/nnR5VPGibSz4aprTf9bX8S7z/Dnkpy6Ki
         Alag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772522375; x=1773127175;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=emzxcalxhefyJPtrnF5BVbzsZJUc4QzYRAPUO5dkvYQ=;
        b=YY5PGc9sqDFHV9xGMx6CKJyvf4HvOXXE1nUfmM/1dZyveFReKYrCGg0DTllKig442N
         YRQXF2xmxpxaZPoX/uEGFOm1jOAdwiH3icMSZHfT+BapNOpDmKixQ0VF8hoFdv+ZZLxv
         Y1/dct0sjtG+tlvu2rK3EnLkIUDH2v3s2bOlFUWx5PnqlXJjpiv1B0YV1V3w6tPtP4HB
         bNDVp+uJXG8OI75JgL2Pp/jMn54o109jsP+d2UOo6emyLI4buVawjFjWcP7fxHdWFYdY
         /LP9x4wi4CzjYSZDpdREX/P/48iPLt3f13+rfFMVtw/5MTyFvzWXnKBS4Hs7sqbuD2dI
         yW4A==
X-Forwarded-Encrypted: i=1; AJvYcCVTBiHUS7amp7q2PwO9k81Po488mreGkSeMZzlnIsFJhUuGNSldee92UcNPqutnMu9QSws2I2XIMA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzLvSF/MpIQjXCa1wC9NdVP2mXbfZi4+yoN1XqZ4lW8zuBgnm6T
	aNHIGmj3DfB9tBtB41FghKjDKocGvZo8d5fUhnC/eWV09R+wGXnl3epd59CsHL0Y2aY=
X-Gm-Gg: ATEYQzwx++BEzMNmO6V8zDwo6fQ6MtZqpOdIq6GPTXhyRG68BuO6AMMWvg9KtFwHsjl
	Go4pv3xjeUDh5M5Y3enOTUC9Kq0x2AIvIkyS/6IF3jnCY/PLppBzObearYXtjbOncCQMNslsnfd
	Bh3A+/zhwfx8mgbnN2JeEkjsuJcnUXH6Sfup5SXfyksWVVbf40sGCFwBFVRsTfyIChndcvz/485
	afICRsjpprtUn+0KvzPJ3+NGdno3YAazjaDVNWn9z3Z4AvcT9B4T7xZFvWGaHaHB9blPq0Qs3b9
	otQCUNVxXSFYCx5e9lps88Y4ot1AnWEnSKwWG210QzgysaMVpEpAdBiOp6dx6ByIem3lGtny9mG
	78+4Xu4zqgIDSKv8NMfWsTnLSAPgefxHgtCWW/TBjgQyNs0HbWdh5FmftDI579jRfA/Remze0JX
	6eNOTqDpl67NGioveFmaZ/M/jN8vAsk44F0WqVrZj0Y60IX7xqqHHHMW/YxjUebXz+Pw==
X-Received: by 2002:a05:600c:1d0e:b0:480:3bba:1cac with SMTP id 5b1f17b1804b1-483c9bc55c0mr240863065e9.6.1772522375015;
        Mon, 02 Mar 2026 23:19:35 -0800 (PST)
Received: from [192.168.178.47] (aftr-82-135-83-117.dynamic.mnet-online.de. [82.135.83.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd7030b9sm370239755e9.4.2026.03.02.23.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 23:19:34 -0800 (PST)
Message-ID: <3c173449-bad5-4d74-bdff-4fc9fe4df566@suse.com>
Date: Tue, 3 Mar 2026 08:19:33 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/24] scsi-multipath: provide sysfs link from to
 scsi_device
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, michael.christie@oracle.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-6-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260225153627.1032500-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/25/26 16:36, John Garry wrote:
> Provide a link in sysfs from a scsi_mpath_device to member scsi_device's.
> 
> An example is as follows:
> # ls -l /sys/class/scsi_mpath_device/0/multipath/
> total 0
> lrwxrwxrwx    1 root     root             0 Feb 24 12:01 8:0:0:0 -> ../../../../platform/host8/session1/target8:0:0/8:0:0:0
> lrwxrwxrwx    1 root     root             0 Feb 24 12:01 9:0:0:0 -> ../../../../platform/host9/session2/target9:0:0/9:0:0:0
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi_multipath.c | 45 +++++++++++++++++++++++++++++++++++
>   drivers/scsi/scsi_sysfs.c     |  5 ++++
>   include/scsi/scsi_multipath.h |  9 +++++++
>   3 files changed, 59 insertions(+)
> 
And again; just what I complained about in the previous patch.
Still not sure about the naming; 'multipath' conveys to me
the opposite (ie the multipath device, not the devices which
are part of a multipath device).

But anyway.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
