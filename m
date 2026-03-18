Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E34D3A63F9
	for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 09:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773825889; cv=none; b=UmAEyXi4St50F+OfOJzsNTdND5710NjA+RI46Niu7w3Za/RTKOAqz9mPBEs7RNtjIxLnPsawASmaaGawsoqtcjLBMrr5Y07ON4xq/zOW6ec6UXES3eRH5+Yh+W2ftgbwZ5/P5Lfgg97PYhD7m3UuigsRanXsgoRXa2eRdom/bg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773825889; c=relaxed/simple;
	bh=lQpBe9CcR4XYulE4lNgLbWzUt8xBy4TlZK/UmAmbEXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CUNL4U+PXU9jlYcMtrUc9fK5mxouw24VS5DYwxVkbZF6+qsCZ3ydW/c4r9jywItu9f7aOZRI8Od2tQkahlv8AOaLrQY1cNeSYq2PDZZ2PrT9bFp3xG709stJdCas6yqoydW1TZWb/0ucHKHP/NjHIMX8EmywZRu5cNsz5zzTia8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dxMJ4hFM; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dxMJ4hFM"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-439b7c2788dso4136903f8f.1
        for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 02:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773825886; x=1774430686; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rNKBTzUdX68mACaRpFmDLYY/h6NQejPTpn8KgeZ6DN4=;
        b=dxMJ4hFMaPHXZec6BAdQ03ES6yxq2pxlKrnpbmhpIopQgLHrliTI2fd4nd8uFvy4NX
         xVY5qkrwJqUZgGqzcvTgq3N9Q4Wsn6Lzz9bvlXtN3JkqtvDtNz/fTd/7Ber7JZotlEE5
         Qz8rTijTF67bQWmCIR2n3rxq+XobIWTVAEJETvOQnNETtGym1hbozV1YvdAeW9bZm+LL
         9H92r2daVLVxd2mNerGMMlxz806nIlvlSYWnzbPD2ou8PQYE/5JqSpGVl+CJURUONIF1
         xtpo8bwC7st4oyBOjjhNx5M5Y7AHYqihnbSt+B0xI/PUCy6Zm6b0dUg+qkfWOSliJ24A
         Z1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773825886; x=1774430686;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rNKBTzUdX68mACaRpFmDLYY/h6NQejPTpn8KgeZ6DN4=;
        b=Y50FBbG02QYQK+tyfgz2hTFjMtOz7NiKrB8s4oKKP2J04MqVB//0uBwKn+p+jH3B/e
         V+oemgw44lptye5gEEmF+9S65CAQpI89leuGmV+CFdPskrfuvPnbSbWxaDxSIknGrRMr
         DRC4TEOR2zSNRifkOtgvnyGV53/rKpRIduVTn7m0xE4jk5LnjIDLp1sM4rxSluc0Brnv
         w9qhcIW30N8xIkB9b5Vl/FJ4NYJ7qDcT98+jGc6i/Tiq4g4PLJUgeWHvn4yzd+fs4QVx
         ElCOgiKmSujkr/2Lsv/w+qQPaT8e7C3Sb9+CUagzLiubW3Mi+o0e398nUx9ALiJoiU0E
         G/3A==
X-Forwarded-Encrypted: i=1; AJvYcCVETxthB+6SOi/V6gRIQrwrr1UdF+6gTJJ3NhLS5HsNqMke0PulRKuVCeGDEx++/Jz/+eQ1ueN+Mw==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywdwn/EZ2b1rgkPBaL/NllRtWWcm1yQOTi4gjHXcNCZGXbckWjz
	tIcN6Fy0sHv5ZaCRjRzbQT0C6/1UgwG3fs+Wo+A9pEnELENPrNGQ3ljVVkCuQnYS7Hs=
X-Gm-Gg: ATEYQzxid7nR+kcdvVcM2bZdL2JiSRc4NQapWqHOjVr/mmf78T/NyDBVPTMSIr6lfhg
	Lh6W+uSU0VU/+kmyT40ByL2Bln69P5OCHAYdOn8fxDAOuu68+BM27jdbBGxo5bFWQK+r/jPLFQE
	Rsiz6C1Qb+2I+FxFGjBFq4N3tWExdiO/Lwnh+23W4TXUQX+cwTnQts+0Wh+2YNGLV0+Z2CZ34ZA
	ahr9v0zB2GMJ3RqqoKjjZyOk+v7BZzm1QMeonEdrcvt0gkXPswM50a3Med6Nzocj8mTwt2kVA8G
	tFiee1GYL0+CSLSoASJVtMfXcdvpgAAigJQxHDlLU3CfEZbA9tIKfav5tLJON55c379+xylYKze
	WokHsnxM229ZQmd5LzCwtIpE8aftqDNFQquT7Efqgwd1LpbVPpg49ZAMMLwjhG+HfyV0uAD3ZM8
	HRleWQVg1Vb9vLYKBO5z6X59Ssk5D3EJBaCY/ClcYedWDreK1IEZb+OFDU
X-Received: by 2002:a05:600c:83c5:b0:480:6bef:63a0 with SMTP id 5b1f17b1804b1-486f4456f1fmr40963985e9.21.1773825885802;
        Wed, 18 Mar 2026 02:24:45 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b51852097sm6495727f8f.9.2026.03.18.02.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 02:24:45 -0700 (PDT)
Message-ID: <d149f868-e3ae-4db1-b85b-9d5756d8fa05@suse.com>
Date: Wed, 18 Mar 2026 10:24:44 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] scsi: alua: Add scsi_alua_stpg_run()
To: John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-8-john.g.garry@oracle.com>
 <1bf4f9c3-7ab9-4be9-9061-0611a41242d3@suse.de>
 <f0625323-655f-49bf-bda8-324c0fa4f520@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <f0625323-655f-49bf-bda8-324c0fa4f520@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/18/26 09:59, John Garry wrote:
> On 18/03/2026 07:57, Hannes Reinecke wrote:
>>> +static inline int scsi_alua_stpg_run(struct scsi_device *sdev, bool 
>>> optimize)
>>> +{
>>> +    return 0;
>>> +}
>>>   static inline int scsi_alua_sdev_init(struct scsi_device *sdev)
>>>   {
>>>       return 0;
>>
>> No. STPG handling should be done in scsi_dh_alua _only_. We really
>> should not attempt this in the scsi core.
> 
> It's not so nice to have the functionality spread out. The way I see it 
> is that drivers/scsi/scsi_alua.c is mostly a library, but also has 
> functionality to "drive" ALUA for native SCSI multipathing.
> 
> Anyway, can you confirm which of the following do you think from this 
> series should be in scsi_dh_alua.c:
> 
> - scsi_alua_stpg_run()
> - scsi_alua_stpg()
> - submit_stpg()
> 
> You already said scsi_alua_stpg_run() should be.
> 
Gnaa. Misread that one (blame lack of coffee).
stpg should be handled in scsi_dh_alua. Arguable
we could move the utility functions (submit_stpg
and maybe scsi_alua_stpg) in the core alua code,
but scsi_alua_stpg_run() should be kept in
scsi_dh_alua.

If that makes sense ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
