Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A198A7260A
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 18:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753121238; cv=none; b=aYy5y/+MP2lbPzcyzsqd9DzFXbZV7nQP+20zg5Ozbsjmi9Sg+aSiNZbNZ/OFWwDj6jHCaBI7pyQV2ZkjYbpMRicQ38wDIOBmeuiAmBzUa4o7IV9UZsJDTGQkfh2NPEhJ3Y9xAso0teit2WkW0MuLGJVln+8CV3Dxw40VFZ5Ra2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753121238; c=relaxed/simple;
	bh=dlqR+BoOjh7xIC5sm38NYSlz6u98/wT8p0xRQirI60k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tAP913gTBq3OQP3GKET4ZoDkyRd9PmJua3q3COuvdACGZTTf0mUqjdhbSHSI/8xA+zFTN6TEv8yiFxVXn4okTeKr2xcchS0No2GQGtAz+MZWuBZTnupo2qpZJYZLgajmo9c/9EeqMyZqIVr4Zyqcv/pXLJQ/d79k9t33ymHRXlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bq/dj7Ly; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bq/dj7Ly"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753121235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nJFty5E+nnrr4B1iKN/IzI9unKAMyqZjIf2ryJjc/GA=;
	b=Bq/dj7LyNt8fa1Ur2Zk6XfdShxctesyg2R5As33SwCu5n185ce+zXHg0TMQ1UDDlzEXQ4w
	MqqFw7KoCrKlYbBVYbYAAJED+Ek51I0cnr7xyeAh/Y+OyaR8gDTvu5WxiLgISjqyJ84xWe
	TbFfda1a/EYDdY2u4exS/SZiR7Usyd0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-9ZEu1PLvP2-7WxAV06g0ZQ-1; Mon, 21 Jul 2025 14:07:12 -0400
X-MC-Unique: 9ZEu1PLvP2-7WxAV06g0ZQ-1
X-Mimecast-MFC-AGG-ID: 9ZEu1PLvP2-7WxAV06g0ZQ_1753121232
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6fb520a74c8so75881126d6.1
        for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 11:07:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753121232; x=1753726032;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nJFty5E+nnrr4B1iKN/IzI9unKAMyqZjIf2ryJjc/GA=;
        b=cXl8wYVOzaODaOpVQos2tqFLxQ/VP8Roew8M/ZkOVU8HnbPMei8TDssq/8oXMbnwpU
         jkxRcl5b3KdciN/SiJGUGHbisJAMflA5szJlP5VnQWFNCNw9DotlMRrJSI8Ffv9r/2dL
         08iKTjBDtcxEj/4KL4xSH3LVy9nBtfIiW4dMjXi092pCSSH9q7hueWsCTpQL892Ewdt1
         tNSfE9cLltot5fKatK7psLXWHRGM6kukLoUvPXLH7OXDaDakDSPf8xBvIUEwBs208CJ6
         6yWR4Pk1LAP/28/q+Uz3FXGPlECWFo9oPNotSItbRMrwS9xY8y0d2lwOkDIsPinUWC8C
         h1Cg==
X-Forwarded-Encrypted: i=1; AJvYcCW8QM5/rmK0GtOnTfGQ7Ggng5WqnEBVGq3sHaO9eVw8khaH7OGOWoCCnX87a+xNjlTHtxwu7HNV7A==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz77Pi3VHDZ7cjCqEBeNYnPHgnKyASdEAqEe0mSm4QEBlHcoJqi
	xVIlIh6dnQIlNqO6UTrXO8DxvQhlMjfResXQW0p4dLh9akpvBjlrPQ1bbU/Qe6I/erlAL1PgyM2
	LPDv4wV3pmDkeFcAXG1hymwV264nQbtSMtllfqETayWuZcMnIxep7eDTcZyR0v3l/bDyq
X-Gm-Gg: ASbGncsTKErLip3W0fw/kUL4qbJsj+FjI2EFEYkCnujMhkBuvwyRUbIE8o4I9Ra7IIA
	P+uXl82weu4Btd4+rQIIQQ7YqQjPk8GXq6sZJxmOHgxpKjXRdGBQoMYNtRCm/gVlO58RaAo3LId
	JgRp/i98Ga3DcxwjXnki+gSR7cw3CAfFW2g8dXimwIvKk3ySbhRvHypgHN50o5U3WHHj0uNlcp5
	AwMl2oF1ITwlbgFFmuOwT4JCbYTO6L6m/Z4EGBTuUVHthHCSvcjKt/Yq/YsEVmaKID3EfZV4A6/
	4ZASrqiggNJ5fAj6yISWSVfK0OtwMhakbcmBzmcdf3qfINMqztn6fCaedFLLth7McFhYTVhfv8s
	2sFwadc3yk+8=
X-Received: by 2002:a05:6214:8104:b0:704:f7d8:7031 with SMTP id 6a1803df08f44-704f7d88977mr235049616d6.51.1753121232270;
        Mon, 21 Jul 2025 11:07:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGt1vCOLLkmjUd4KuD6sqe3n8n7/UacUmVWPgHP23ityP0gOA/0UaTnvpsRw2e76gWT+2Hklg==
X-Received: by 2002:a05:6214:8104:b0:704:f7d8:7031 with SMTP id 6a1803df08f44-704f7d88977mr235049276d6.51.1753121231685;
        Mon, 21 Jul 2025 11:07:11 -0700 (PDT)
Received: from ?IPV6:2600:4040:5308:eb00:a77e:fec5:d269:f23e? ([2600:4040:5308:eb00:a77e:fec5:d269:f23e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7051b8c04fdsm41654566d6.15.2025.07.21.11.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jul 2025 11:07:11 -0700 (PDT)
Message-ID: <03f74406-2df3-407e-b440-c364c182ad78@redhat.com>
Date: Mon, 21 Jul 2025 14:07:10 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: LVM testsuite failure with VDO
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: zkabelac@redhat.com, dm-devel@lists.linux.dev
References: <11d4215f-06b4-84a2-29ab-a558c25c6331@redhat.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <11d4215f-06b4-84a2-29ab-a558c25c6331@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uqTUYngoPXcUQOpkp3lWd8U81B9fMxAIyphu1crbaec_1753121232
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/21/25 5:29 AM, Mikulas Patocka wrote:
> Hi
> 
> When I install VDO tools version 8.3.1.1 on Debian Sid and I run the LVM
> testsuite, I get failure in these tests:
> 
> shell/lvchange-vdo.sh
> shell/lvconvert-thin-from-thick.sh
> shell/lvconvert-thin-vdo.sh
> shell/lvconvert-vdo-raid.sh
> shell/lvcreate-vdo.sh
> shell/profiles-vdo.sh
> shell/vgsplit-vdo.sh
> 
> There are these syslog messages:
> 
> | [ 0:00.988] [2498.650738] <6> 2025-07-18 20:00:38  device-mapper: vdo0:lvm: table line: V4 /dev/dm-2 1310720 4096 32768 16380 deduplication on compression on maxDiscard 1 ack 1 bio 4 bioRotationInterval 64 cpu 2 hash 1 logical 1 physical 1
> | [ 0:00.988] [2498.652339] <6> 2025-07-18 20:00:38  device-mapper: vdo0:lvm: loading device '252:3'
> | [ 0:00.988] [2498.652867] <6> 2025-07-18 20:00:38  device-mapper: vdo0:lvm: zones: 1 logical, 1 physical, 1 hash; total threads: 12
> | [ 0:00.988] [2498.686527] <3> 2025-07-18 20:00:38  device-mapper: vdo: vdo0:journalQ: A logical size of 584704 blocks was specified, but that differs from the 584729 blocks configured in the vdo super block
> | [ 0:00.988] [2498.688822] <3> 2025-07-18 20:00:38  device-mapper: vdo0:lvm: Could not start VDO device. (VDO error 1473, message Cannot load metadata from device)
> | [ 0:00.988] [2498.890909] <6> 2025-07-18 20:00:38  device-mapper: vdo0:lvm: vdo_status_to_errno: mapping internal status code 1473 (VDO_PARAMETER_MISMATCH: VDO Status: Parameters have conflicting values) to EIO
> | [ 0:00.988] [2499.077804] <3> 2025-07-18 20:00:38  device-mapper: table: 252:3: vdo: Cannot load metadata from device (-EIO)
> | [ 0:00.988] [2499.078890] <3> 2025-07-18 20:00:38  device-mapper: ioctl: error adding target to table
> 
> When I use the version 8.3.0.73 on Fedora Rawhide, VDO tests don't fail.
> 
> Do you have some idea how to debug it and why is it failing with the "A
> logical size of 584704 blocks was specified, but that differs the 584729
> blocks" message?

This has to be a userspace problem, right?
The difference between versions 8.3.1.1 and 8.3.0.73 is very small, just 
an update to the acceptable inputs to vdoformat:
https://github.com/dm-vdo/vdo/commit/0ec7597b60e5e6c2c33dfea057ac38bf157acffb

The logical size of the device is not even specified on the table line, 
either. My best guess is that lvm is using the output of vdoformat to 
set the device size, and the change here means that lvm is no longer 
calculating the correct value for the device in this case? Zdenek may 
have more insight.

I haven't seen any issue like this in our own tests using lvm, but I 
think we probably haven't run this specific suite before.

Matt

> Mikulas




