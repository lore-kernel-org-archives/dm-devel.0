Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D4720CCDC
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 19:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774380408; cv=none; b=uAZmGidFetF8zctapFDeKFO5q7XgEeKDi/sIjAf3pWdInkhMSkdl5SQlYfdJbbOEf1t8uWAp5o9icp2YYnJBMpQwOrfhgCMJG42uAqY4rkJN6jMf6KVWXMi4hwEmq9diaHdwYvQIAsNZglXLGsPtUXG4RHrNE7kmWoTu/ZfsrYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774380408; c=relaxed/simple;
	bh=yXYUB3PIG8RJwehlhRxPJo0GzV45/myaWuAE6pr05ac=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TTSamvHbmpDAGNa4+Pg9l1CR5FJt0pMeQ9WpY2tMqSnpx8hPVKD3qosjOhILp4ZH+ji4Y3+JrxjyknJkILYlnPvnpZsEAFHbFZFWBnICFqpjTMlOS1dyzGh6uoAQsQTRhiQMzLrXqtSHvWcn+Ph/37e7RBEcPcZYXmikCz5mghE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b/dknoyo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b/dknoyo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774380406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yXYUB3PIG8RJwehlhRxPJo0GzV45/myaWuAE6pr05ac=;
	b=b/dknoyo4KUtY2vLBQRinYLbn/V9bT8DrAimFV0Vb3UjsaF47oNX1utfWhIACeP8HlFl5q
	6/aoOXR5KMNbSI/i4uXM8HCSBlRBbn4DmmHHh1GIxLcyvBAqenbgpV70zTzNurcma4r0Zv
	UdGudPXXTFqzeBCv+/8PowEhAvCzMgU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-RelVpeZfMyCKTaVGAYCAIQ-1; Tue, 24 Mar 2026 15:26:44 -0400
X-MC-Unique: RelVpeZfMyCKTaVGAYCAIQ-1
X-Mimecast-MFC-AGG-ID: RelVpeZfMyCKTaVGAYCAIQ_1774380404
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50911c94db1so80695241cf.0
        for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 12:26:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774380404; x=1774985204;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yXYUB3PIG8RJwehlhRxPJo0GzV45/myaWuAE6pr05ac=;
        b=fOIgdoFBalw6KnpSbLadvCWwll2KKyCrwyXt2ZagC7Nx/ZjTEU7D7b6rAFl4tYSz+9
         HpLn6Un8kV2vsG/1x3NxbIpTMnzumezeAAHdp0ie7QSPCJpW7UPteVDpp1n+1ILtaw+O
         +8N0+t2drL+ImjFUwPOwFGvXSwAnL0oY5xINRd4ldXYBQ+d/Wxqyh0XcE//vF/EtKJ2H
         m3WS0TRkaLl7LYN49P0Y5mTaNRe52St8Fdn/g/EBeqhBngryx44t57uepyeKtiRjDu72
         hyYy3iU+5foNAPfZgYOE/5pfukzX2iu6i9fJ/npgv1Nacvg7nZGHLhJZHTFFXlq8Ssp+
         lQeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcdhU/RrRpQdXAjqZ9EZUczk2U0+il+XLTW6PnZ9Vnt13MDJ2Iuk2TZDpUjb6zQU5BhN4kaoQ3zA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5vp5AMDyg871xwaXcErq3BAJ6tJEJ/Y//BUPClUu7ENPdTF2x
	zUDJKEDHT8vwmmxFv0rUjE14IpF3NdC4TRjuqwjNSVVKgQAdnRrJc8Jg5GGQxPFp89aeykU9+Wu
	/IZu16SrA8dZ78Yhe8ne4hqy/kOSMNYUXE1f4NI3rfpnQV5FWMFfhD9keUYhUbR07dPpP5mk=
X-Gm-Gg: ATEYQzyQhIDRD9v1VHm0hyecYz9xTyUYAKReyju0kFOvbMIHJ1HwdQqFBaR30JOLqJj
	OmWjZIqR3LpkrwMtVcrvMazjEdGAMWOU/SdkmoK+ToCP4oRZ/+gkrx/hniKtNCHsr8TlTMP3DdM
	6xD/DdoRBKGDEGSeDnoCOZsrXXSPndj5QvRWmhu++C+c4rYtnxAtXWYDq/7nb6pDdAL03SctqrN
	GlvWXXTu/y+5D4lG1+KCcHBj4HPRQ3sbTOrX/i7a4lgU/aUhvy03nBzoJnVZj1r3JewUvD6ZcMw
	A/Fnv+r78vEygHKlS/Qkgt8WOZ/d47V/WUu5pxkxv1p9iwRb1FyyxiRl4YT6jqtFmfmrqt8emeJ
	UUWVWuLgf3eAFG5vVoZVRyCZ7RNL3a67zvbgQGHN4fS1YcOlxT1BE0TiA2nsWHq1DtsePRg==
X-Received: by 2002:a05:622a:8356:b0:50b:4f75:c925 with SMTP id d75a77b69052e-50b80d34c05mr11292491cf.24.1774380404276;
        Tue, 24 Mar 2026 12:26:44 -0700 (PDT)
X-Received: by 2002:a05:622a:8356:b0:50b:4f75:c925 with SMTP id d75a77b69052e-50b80d34c05mr11292161cf.24.1774380403719;
        Tue, 24 Mar 2026 12:26:43 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:2500:540d:8da2:f197:6711? ([2600:4040:530f:2500:540d:8da2:f197:6711])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b36e3d85bsm110025421cf.17.2026.03.24.12.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 12:26:43 -0700 (PDT)
Message-ID: <82983002-116a-4514-9b7d-ac5a9467ac2b@redhat.com>
Date: Tue, 24 Mar 2026 15:26:42 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] dm vdo: add in-kernel vdoformat support
To: Bruce Johnston <bjohnsto@redhat.com>, dm-devel@lists.linux.dev
References: <20260324180652.69439-1-bjohnsto@redhat.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20260324180652.69439-1-bjohnsto@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zk_SP-nnwbLZP3-AVycggSb1sd5kimR4QvOI_Nydsyk_1774380404
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/24/26 2:06 PM, Bruce Johnston wrote:
> This series adds support for formatting a VDO volume directly from the
> kernel module, eliminating the need for the userspace vdoformat tool.

For the series:
Reviewed-by: Matthew Sakai <msakai@redhat.com>

