Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7742B385539
	for <dm-devel@lists.linux.dev>; Thu, 26 Mar 2026 10:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774520354; cv=none; b=YuygA9M3eAqKtnt1Nxa8P44dXbwDUaw1gFzjuD3pLqsKeqmqapmJGcnvlcQEXIdoZnmbIJdBfUXamYpUnQ/LDQJjUZedEP4XJXx2HLis/DZKSfnV5Zu5hhez1ga/j3j3yPIb+4n4IBWhJdoiMvmw057IAYHmhNzRl+reFa/5b8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774520354; c=relaxed/simple;
	bh=Qae2gKOQfzbdP6PYGh8B/FDl0l8PUDf9Q4RiAP+IZxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MCk8cLbHMMBFC3fAyKDGU73jMJmU+H5Wla4H5W3/KYu+eUuxA5IhcKri53tdj/KA+M179iu4nPbjD7A1zMRzHlXSu4fg56ToFg96rrCLNGYwoxgq5eb4kE7gSA5ZG+CeEW4OvvI4vb/8vVKoyYyv4JC9xMHSNRpgthuEoMZXn9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ah+zQi7J; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ah+zQi7J"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-486fe2024a9so6085205e9.0
        for <dm-devel@lists.linux.dev>; Thu, 26 Mar 2026 03:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774520352; x=1775125152; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uc5ku6PvKiOyOZH+1palqwgwPAuIYwNWvmlAsBkODIQ=;
        b=ah+zQi7JMTZT0HxTmQBhBFgxNGYrenhCwg3Ia/5S/QTa3Tk0Ityc499/e0ydLkm9A2
         LO3spZ3Dyxe2Nvs8MMe0NPiVmBMC++b+ZUZLqz0bzCveMWhx/fpkmw+LGINE3p+won9f
         cc964Qu1GJqSyrd8oX+8hhnjCcyfkg/O1D45Ui68OTJuJQMF3jdnsE/54c5Gw2t1o1Ey
         MOJgbsAl76zEgosfu4clcqhrN2/jAn2A94RItI4mHSmvz4HdihMubZ7Sxwm0sLxTZ4fd
         DNeTAY54cc0xAzM3z1BsQlgGVIr/kCdKYsioUWeHcw1hzrPvP57FF7kk85XCKo4ka8Yl
         plzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774520352; x=1775125152;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uc5ku6PvKiOyOZH+1palqwgwPAuIYwNWvmlAsBkODIQ=;
        b=l9jwTCXQVcepOKN5gauJn1ajQs2tNKm6YnakkRmbmCOgYMj9Q8VR0DLhFO5DWO0X5D
         ODxES5lS1g2nDf+hC3F/efHUVvvzeYGXOfdokZmV+Hb6xRW+kUxzgNDtOCdQLrvaTUD9
         1xVsbmUVLkh+c3sCdTnaQ2bExwjPrsvOwQvatF/AfNplHOxUKmvCOSvJgLP3rvN9uG0Q
         6t703H8adwBjdPwwgQnSaXH+DcRbjdzitu452pnA2zlxiS+h3txAnRgyGcwhmlIwoL5I
         9zwncy9suSvPsuU4Mqc36PAEK1bTYiFWPltwyHuX7N7TSBl6yq537O2Ya3bluLL2lZiP
         5kFg==
X-Forwarded-Encrypted: i=1; AJvYcCVSyjsnPZu26R3ly16iLoGU1LPkq3Rhg4Wwv/AKFqwwXrpC9TyKhOgmbJWGZHcKV3LzAeK91aAC4Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxxMjkBcnNHte2ZfsVuDlAQLlBOiqN2u8yXqtWdLii0KtEnHLtb
	6ZmlVXkvIJkYegYHf1jz2lbL4ZVntCmIdWQzM7qgmgv0ERc84n3eJMVi/I+o1W9gNdPm+pltTUA
	ByffB
X-Gm-Gg: ATEYQzzDOq0msOjPubeswW0b0bQ6Gdyjfz0shMlDx049Vh0/tchw7lgBnqIa9Hn+cn5
	HOjX7d3QgXxbIxUQtwmL6TKP8Z66Sv/fauZUZDTyFL5xpiPeGTb4UYLuHMWqxlfk0exXATb/wTS
	wfSpgqCa+FAZO16ssic75KizJjq8CyFMIUKkm4Oew34WGIGIRD4HGVfA4oTBpFH+B9jBJ2FLl//
	+HWMzqPtfcuFyC7ELISNhHncdxo7WOHCmYo/6r+Q+AbXOMUU1moFyC7mYDm8mz5II3zkINuqeYd
	QqbKCD1B7Y9msquyC0GPRo6bKFsPpQwhlDGk60HjOGkFnd4m3ijD4CvCrTKSy2HdofhNVWpZJOW
	KdKLSrSKyFydib9PEsRKY2mGxm1T8hVEGeuJUOYV3xDIUn5MpVBxuls7eDHf1Vs/t4hfpMCTdP6
	J5++LsPkWdSNzmMa+4HlKFPCCBpfEsm/O7mCoILjTL1ew2PmTsLw5QMiDL
X-Received: by 2002:a05:600c:a4f:b0:486:fbd1:9dc0 with SMTP id 5b1f17b1804b1-487160350d6mr95710745e9.22.1774520351745;
        Thu, 26 Mar 2026 03:19:11 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722fa8dc6sm38717085e9.1.2026.03.26.03.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2026 03:19:11 -0700 (PDT)
Message-ID: <ff1d65e0-bb5a-4dc1-8bbc-dc781acb341d@suse.com>
Date: Thu, 26 Mar 2026 11:19:10 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
To: John Garry <john.g.garry@oracle.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
 <acFpYuaL-_9g90RI@redhat.com>
 <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
 <acGYbD6X55eA-ynl@redhat.com>
 <43ca92bc-af38-4833-841c-421997ed90fe@oracle.com>
 <acKYbwGlfgWKDxnF@redhat.com>
 <2f84e35f-3574-45e8-9567-4edcfdbe5a45@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <2f84e35f-3574-45e8-9567-4edcfdbe5a45@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/24/26 16:12, John Garry wrote:
> On 24/03/2026 13:58, Benjamin Marzinski wrote:
>>>> If it allowed device handlers to get attached, these two
>>>> developement efforts (native scsi multipath and refactoring the alua
>>>> support) could go on in parallel.
>>>>
>>>> Or am I missing something here?
>>> It just seems to be about this DH stuff is that there is bad history 
>>> there
>>> and no more users are wanted.
>> Just to be clear, if the idea was that the Native Multipath code
>> shouldn't use include/scsi/scsi_dh.h, I completely agree with that. But
>> I don't see why it can't make use of the results of the existing
>> implicit ALUA support, since IIUC it doesn't need the scsi_dh interface
>> to do that.
> 
> We would need something like the following to ensure that DH ALUA is 
> present to update sdev access_state:
> 
> @@ -80,6 +80,7 @@ config SCSI_MULTIPATH
>          bool "SCSI multipath support"
>          depends on SCSI_MOD
>          select LIBMULTIPATH
> +       select SCSI_DH_ALUA
>          help
>            This option enables support for native SCSI multipath support 
> for
>            SCSI host.
> 
> And that is even enough, as Kconfigs should only specify build 
> requirements.
> 
> We really should be also calling something like scsi_dh_attach() for 
> scsi multipath to ensure that DH is attached (and running to update 
> sdev->access_state).
> 
> And I am not sure how the dh alua module is even autoloaded. I think 
> that on my ubuntu machine the multipath-tools.service does it - 
> something like this would not be nice for native SCSI multipath support.
> 
Gnaa. But then we don't need this patchset at all.
Main point was that we _do not_ need to hook into scsi dh for implicit
ALUA.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
