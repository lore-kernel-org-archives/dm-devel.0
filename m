Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B7638FBA
	for <dm-devel@lists.linux.dev>; Mon,  4 Mar 2024 11:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709550232; cv=none; b=s9x0fBn68A6vZmwveChbKPhfLHnpMEi+m2a7OIWFxoWVXu3H4UFB1OIsw9F/imGiqlqzC2zj/sIE5+kVk/IJmtBXUpqTIyGAtGHg87h4Gn72H0Mz7j/gSYKxKsinxY+s+DHUHtqC2LAICI1bQHjAtYirpK15Y+qjry4Ac1cyWwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709550232; c=relaxed/simple;
	bh=kes/ZzBLr5Ru4pimwYFErRhWf8gQLh9wdM4IgtkJpYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WK99TUdfEi3QMelU5sViWPAK0xaNX+INI1bOSJFwB0zBCcZZtSCCQy0cNlxvUn061QWt6Qtu+6im0ZOvFSqpcKPHHgJtBXCUDCpIr8ZK3449EGJzPHkAHk2TFRyvZu8JuMIXiJIhzBMDbDKaP1gD/vPrNT5JOpyV00K8YPzxvDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hR+L+TNt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hR+L+TNt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709550229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UUD+jMbOKUl1OVPTxzHelpclMtMfCMcZh/2iu/f+FIs=;
	b=hR+L+TNt1vpYQGbdbIVyfcsIcj5yJCTs/IQB0BfinB4q1XymMzAqXBPKg8cqCkANZWH6F6
	VNZT/tuLx10ivZcG8w5E5wtYjxda+QJGxdiShDq1oKIO2aRIQL6axbj7vCYYNRTs8S5JqD
	ptxjfVlapmEb7CpRbodEEXlTd5juQGk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-WzO2rtHZOzG8PUcb3RwlIQ-1; Mon, 04 Mar 2024 06:03:48 -0500
X-MC-Unique: WzO2rtHZOzG8PUcb3RwlIQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-412b4744e9dso26694845e9.3
        for <dm-devel@lists.linux.dev>; Mon, 04 Mar 2024 03:03:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709550227; x=1710155027;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UUD+jMbOKUl1OVPTxzHelpclMtMfCMcZh/2iu/f+FIs=;
        b=FaFHKDZZV8e/bO9gKE1PXfmkcknsBXUZUV1+lRNErT6xb/a+ch0FyV8r9BrvevwK1J
         xwtomPx3jTsLJFi6Zxwe21aZMxSj1YiO8UXBLHY2Aoy5pAzDdXUcUzh13a8iWs0ijglq
         Dv5VeNk96ddWBtOTzEyPtaNhlVPUXChtSNUHCHlY2rQONKxF8spwmJhE+J567XkPF+6M
         ri+r5LJGOWt6Sigxg6gskker5gsRLQD2UAO3KisOW3IMObf+Gu2O48aCNTdyVNV6ABJ4
         HV8H+dy6qy9GE0lOZfI9TYLpPGHPvWz28d3CqnnvKlZ/LRo2waYwaRv5TLRC7P3p49KT
         jsYA==
X-Forwarded-Encrypted: i=1; AJvYcCV1+wcv9vFfIXlVvU7X9581MQ4+UaDM4s8GR/LDoAZSUCVFK1JSXcNxsvqkVBm74vz66+wW84etADrBYHifPX5d/U1UBKjgB0k=
X-Gm-Message-State: AOJu0YxoyhLLA5QarBoZ/IXdMUfaolavR0CtHChC3swFdEna/x4QjXEp
	4ybdAjjSeyvzPNIpIiwjLeBVNmJ16d4mRNH3Z/IOwU1PKtcF9BchWPnOuzS64wpiT+5ENdIzWtY
	FeenAMSQ1UcbJ1SHiKvTgHri6o+IC6BOvojCG8B/Cinbj7+tSBawv17xE
X-Received: by 2002:a05:600c:1d91:b0:412:e8c2:d9be with SMTP id p17-20020a05600c1d9100b00412e8c2d9bemr146213wms.40.1709550227474;
        Mon, 04 Mar 2024 03:03:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5ZwGCwduFYo3ZzsuUdL/RA8YC42EbLluFs+Us3MhcD4G8Dms8EFEwX331/9tlruRV2UTUFA==
X-Received: by 2002:a05:600c:1d91:b0:412:e8c2:d9be with SMTP id p17-20020a05600c1d9100b00412e8c2d9bemr146193wms.40.1709550227166;
        Mon, 04 Mar 2024 03:03:47 -0800 (PST)
Received: from [10.43.17.192] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ay37-20020a05600c1e2500b00412e7dde7d9sm754275wmb.15.2024.03.04.03.03.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 03:03:46 -0800 (PST)
Message-ID: <47ffccc8-0c52-4adf-8b55-65b6d477af52@redhat.com>
Date: Mon, 4 Mar 2024 12:03:46 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 6/7] dm udev rules: don't export and save DM_NOSCAN
To: Martin Wilck <martin.wilck@suse.com>, Zdenek Kabelac
 <zkabelac@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev, dm-devel@lists.linux.dev,
 Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>
References: <20240301224011.11117-1-mwilck@suse.com>
 <20240301224011.11117-7-mwilck@suse.com>
From: Peter Rajnoha <prajnoha@redhat.com>
Autocrypt: addr=prajnoha@redhat.com; keydata=
 xjMEY7QY9hYJKwYBBAHaRw8BAQdADIHZn5yeZYFV18ewwf4iudpl1ARfj4rnxX5xiSoJ15vN
 I1BldGVyIFJham5vaGEgPHByYWpub2hhQHJlZGhhdC5jb20+wpYEExYKAD4CGwMFCwkIBwIC
 IgIGFQoJCAsCBBYCAwECHgcCF4AWIQQhe3cZL8e9dSzFIwXndmZANt+EqwUCY7QZ9wIZAQAK
 CRDndmZANt+EqzosAQDXhWudIjLSGoWGPKgluEWw5B5LtAX+kW2OG7loCDzI2AD/fp3Xec8K
 JY7HrSqO98YMPbT98+YRjiopJSk75TcAogzOOARjtBj2EgorBgEEAZdVAQUBAQdALfG8fuls
 uqLPtrJ5tYb36UtqNlu6Bw9ME/Ou+FRGG1cDAQgHwngEGBYKACAWIQQhe3cZL8e9dSzFIwXn
 dmZANt+EqwUCY7QY9gIbDAAKCRDndmZANt+Eq22lAQDXlKMGQxkD0FZes94uihIZlhFwGjrX
 dVfZsxfwEvuJfAD/XLGDegnKVERbF6YTfdsbVngSlOX/Tu/fxAFTg0JfdQU=
In-Reply-To: <20240301224011.11117-7-mwilck@suse.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/24 23:40, Martin Wilck wrote:
> DM_NOSCAN is not an official API any more and doesn't have to be
> restored from the udev db. Rename it to .DM_NOSCAN.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  udev/11-dm-lvm.rules.in  | 2 +-
>  udev/13-dm-disk.rules.in | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/udev/11-dm-lvm.rules.in b/udev/11-dm-lvm.rules.in
> index 0b77fe2..d0a5637 100644
> --- a/udev/11-dm-lvm.rules.in
> +++ b/udev/11-dm-lvm.rules.in
> @@ -30,7 +30,7 @@ IMPORT{program}="(DM_EXEC)/dmsetup splitname --nameprefixes --noheadings --rows
>  # so those selected rules are surely skipped.
>  # We don't need to save and restore the previous of DM_UDEV_DISABLE_OTHER_RULES_FLAG,
>  # that's taken care of in 10-dm.rules.
> -ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", ENV{DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
> +ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", ENV{.DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
>  
>  ENV{DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG}=="1", GOTO="lvm_end"
>  
> diff --git a/udev/13-dm-disk.rules.in b/udev/13-dm-disk.rules.in
> index cb2ce2d..7989871 100644
> --- a/udev/13-dm-disk.rules.in
> +++ b/udev/13-dm-disk.rules.in
> @@ -18,9 +18,9 @@ SYMLINK+="disk/by-id/dm-name-$env{DM_NAME}"
>  ENV{DM_UUID}=="?*", SYMLINK+="disk/by-id/dm-uuid-$env{DM_UUID}"
>  
>  ENV{.DM_SUSPENDED}=="1", ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=="1", GOTO="dm_import"
> -ENV{DM_NOSCAN}=="1", ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=="1", GOTO="dm_import"
> +ENV{.DM_NOSCAN}=="1", ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=="1", GOTO="dm_import"
>  ENV{.DM_SUSPENDED}=="1", GOTO="dm_end"
> -ENV{DM_NOSCAN}=="1", GOTO="dm_watch"
> +ENV{.DM_NOSCAN}=="1", GOTO="dm_watch"
>  
>  (BLKID_RULE)
>  GOTO="dm_link"

Yup, the DM_NOSCAN is internal and we don't need to import that for
subsequent events.

(Well, it's still used in 13-dm-disk.rules, but that's at least in our
hands.)

-- 
Peter

