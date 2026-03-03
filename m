Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15C935CBD7
	for <dm-devel@lists.linux.dev>; Tue,  3 Mar 2026 06:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772520773; cv=none; b=eia2LvGntF4te5pl+SzpVHyuencLQN5E88dyPu1DnkWzdJC4rCcWw6CE8dJiWoeOgtCkT9zlgy0uw6l6mgJJtCkLFV8RhJonQ2Go7DM/wXIcT/ZX1xz6xwUib8gnfWT8+rcCdTHzrzQi7ZtE1RFw0VsfA1wRxW/nNldAut+npUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772520773; c=relaxed/simple;
	bh=9pJJVTZZM3QCn+oui6V6Hn0OTNpM5sMorAYDGGh6gjc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=doQbJainOkbbaUwS8UmwQy/Q3obG0p54lZCNOCRfV/atmo4Rm+Wj+yJnSjoxGMcXdv484N7202eN1p/mwpT8eaaJOZqDpYsSjsE9kJJI+PeYUK/2IcjHj9Uv8K2vkrRVthUh71UiduzzL7mRTsWd5ZS+MO9jzH9a83vatoINbJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AujvFRZZ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AujvFRZZ"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4806cc07ce7so59578775e9.1
        for <dm-devel@lists.linux.dev>; Mon, 02 Mar 2026 22:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772520769; x=1773125569; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a2Ju36mr4bvkPwgZixZd3t2ngeaxuwiZ8lFBXsrk3Fg=;
        b=AujvFRZZJz1WEefOQIj/pv2nMAp2cTTOH1eqqAsnFCbrrYwUQvxL+MGWAetYUYpBpS
         cGgdY0PqJn780bCvUV4ebwb1kH1GJvV/PeMsBac7lrwxpuHic4BtLbi+Id/uDhOqDLdP
         Mo6LMADEJefG12GJ5QiHxRdpBMSJVR+vY8Fb9LYqHGNQPxN+w09Hj5Df4V6+8NXeN4TQ
         vuxyad3dbDdqDvViMUi2PApNccK89SBU0XB8qtKL3vDmmqCNq6QhdUjTtZCRzYTyD+6+
         LDS5jQqWoKu1gzr8zdx5DPw17KyUV9QR+WfnH+PrUee/OptIOjnwOdGQA8ZuGCy0XHbl
         yljQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772520769; x=1773125569;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a2Ju36mr4bvkPwgZixZd3t2ngeaxuwiZ8lFBXsrk3Fg=;
        b=n5JQ8LfaLyiRBksGZ2lUo1YeQx8YzoK50jKMmVjEzGrpmmr0olE0e3UM7h2VaPh9FS
         0MO7nNyhM0nshtwd8OEfB48mDd3quEEvOJ67TWkDIwsUEsqwSPCz0At7jxOv+FoZb0dS
         FdHnN5/1T7/Yd17yykm50S00G1n0BmLZ1JD5tReJ+mJmOAe8wco82GhagkIPDOA+ocEH
         yh838elZLI8BnMcsFc6eFZH4eT7GrIXpYCzlkI75LLVYii7hmgtiASVKUxnDynz9xGrf
         cJR3YIo6mJQD/Y1zi6W7mx2Bw/psXvdltyRkU3KSpETcS8FUZa2NcT4gzTBc5XK6q/zo
         +Fiw==
X-Forwarded-Encrypted: i=1; AJvYcCUtvxvn5qFVlW+jOlZwiIn96QsSpVsMCKwCRuBIMH4ireXgka/lh6LfcTEhdBvNibH48dEj/or9ww==@lists.linux.dev
X-Gm-Message-State: AOJu0YwXb4NtnUsdhO3N5oriH9I6v1kmFerDC/1gS/jxabK/3wimCTD1
	qZdVRZXkT1EWz2qsljv/OHgLHcnebs7FTwJX717pvKhh2RKB1UdfIlR7LgBEuU3b6iQ=
X-Gm-Gg: ATEYQzwa/YrFty+B7jCAirUCCIN4pEJcNuaGOZzDOEHQodbOgVlQDIgDO1c9kdejJa4
	RQruthV0OMRT/dGgd6DGSMyY7rxLI1D8HTmy53V7zNIMRFigfeBLHNdGh+Z37degp7K/O/XAF4P
	DEf98c9IqHX0Kizt8XJJevPh/+iJzriku/eVXRdPHnGYmD6reCQQjat2PzBv9MBgk1uYhIVnbv2
	IWZdqzrRyo8czpblSd+5lepr8gAvakCCsF+vRDuDOBCCxT2WAUaD1SfH4aP4fpZEGOiAW4Amw1u
	etI4lkQfNRsiOTLTBYk/5On+xrNh6K8m4lPR9Fwq4qLbzj9B/1t4MJovHUENq3OS08a/AZmYGXj
	Zc5Y73TaG/B+jAI/tX7hdCAg1NxKA1KYsWd9jfghR+iaXVkCZUe75nfxzJso2FK8lWYLU3QOcbs
	FOJKiqHBhwCXDzUtqRXGL02VDvma9p1rbXeDND59cPxJ76eHvehezPcxDqOJWMd0EVnxMcpRDYC
	iwb
X-Received: by 2002:a05:600c:3108:b0:483:887:59b0 with SMTP id 5b1f17b1804b1-483c9c1cd2bmr282993795e9.35.1772520769194;
        Mon, 02 Mar 2026 22:52:49 -0800 (PST)
Received: from [192.168.178.47] (aftr-82-135-83-117.dynamic.mnet-online.de. [82.135.83.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b3ce8fsm329359945e9.4.2026.03.02.22.52.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 22:52:48 -0800 (PST)
Message-ID: <d79cb9d5-8935-45ac-b2f0-f86f0728bd8d@suse.com>
Date: Tue, 3 Mar 2026 07:52:47 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/24] scsi: core: add SCSI_MAX_QUEUE_DEPTH
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, michael.christie@oracle.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-2-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260225153627.1032500-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/25/26 16:36, John Garry wrote:
> Add a macro for the max queue depth which is supported.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi.c      | 2 +-
>   drivers/scsi/scsi_priv.h | 2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
Maybe: 'Add a macro for the supported queue depth'?

Anyway:
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
