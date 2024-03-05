Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8492B8664C
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 14:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709649751; cv=none; b=VLx4dlq3H5jo6oMfcyAagCZvNfqhlUKFpYVqb37l9Wge6BYxrCxdDNGbsGj08LoCZ3hvhGvkh/0uTO/nEv21UwMb4A7ACPYTofIrma+gYE0vifYDTAabWxkd2TommmsYa/AOE1Xh5TZP1b7priqwgCbvhnWvjGVnLgbPwjFjP7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709649751; c=relaxed/simple;
	bh=rrUs/1+bDGj9wKgLjOjtYbA9vOHJh6dgN224Vnn0njY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AMuKL4s2Dt7jB1Y0qmzs9fJK1rzzwUjdCvJyTE5JKZDqsAyRrVMu7BN2zkS7fhehpI6QtTM/NZkG1uZTorcwKptLZYyJACOGDpnNT80GxNpecuwyIzUpKZO0N4GYRMnVnicuxis1ag7uqjrRbTqu2cujLgbPkKNgwlvWVMlPS7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WgEFfB2j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WgEFfB2j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709649748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hkCvxYrhFUqX5aN39YiixsoelylphZU5rJpwKC/MjcA=;
	b=WgEFfB2jebdB2/ogGabEXuX4NPT6zZAtq349IK0R4vl6agYQizWE009FN67vVC66hYOD28
	f13o7nU+hKSu9Hk1n+6UPVPDkSbEza0qIm7idza6laoA4gYO0JqBLSLc1GfDSVl5bWBVWe
	bXIZzgxPYJh014EYrwtLf5eUyVaxcQE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-fKEbL7qsPC6JAo7gSyG3oQ-1; Tue, 05 Mar 2024 09:42:27 -0500
X-MC-Unique: fKEbL7qsPC6JAo7gSyG3oQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-412e99244dbso6906315e9.2
        for <dm-devel@lists.linux.dev>; Tue, 05 Mar 2024 06:42:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709649746; x=1710254546;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hkCvxYrhFUqX5aN39YiixsoelylphZU5rJpwKC/MjcA=;
        b=vJ0G9ZdmE9KYtbmeZvi6bKi91LPpNIUt1bhXbGjoKWpZLpAZH6HpfngaJ3VsGtbx3J
         ml4Pwy3Pu9bydBcMMaPeuNHYrMUclGGx7kCYnQchacSK0rVRaD7I9Jsam3W8TGV3lLPQ
         Sl/Oi3nfBjZZODjrb5zX89/Xx06h0TcV0MBwg0Y+02HaMi/PMzR/6hvS0EFuCzhbuTyH
         BEhtMggDwbWjuflHtXoVmKfJlwxtQ7tJ8fuoxNsa2gF4hSgKo3jzr2bzFQcedVsa9sUe
         /Xl1pPmrk5qnUwqRGQvzprgxZvDEvqfZjephyTUi1YzWRVu9wIUAFjlj2a6KZUEf9Ful
         /hXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWq5HfL5zUiiPr3W0aLpLRceBvnqE4PjH9c5o65ZgQs9j+6hqabmS+0m9YYcbM0jB67F+XYFU5/jcmBbRs2AgusP8VEdV+1IY=
X-Gm-Message-State: AOJu0Yxk8VDd7g7hoDdxeWgw/3vRDvEeYaL8+nbG7GjQkJJYAWqcGLXL
	9A4Hew10JQ7zDyPOJytWd7P86puQKBVzw4tg1GxDpFBp0B5kmCsv2Sc1LJhoxV5+fArlYX8yGz1
	4op7/PUXFdOyD3VoJTF1cEdViGPhzTr7yaBc9e2mefmRWotWLqWxJYKPN
X-Received: by 2002:a05:600c:a005:b0:412:ef3c:f86e with SMTP id jg5-20020a05600ca00500b00412ef3cf86emr922915wmb.17.1709649745905;
        Tue, 05 Mar 2024 06:42:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHPVzy8OkYU7nRb4Y8+l1K6zVEUAa+oC3MfrE/SSQxotu9ySbkUW0fORvZTSTjjdOe1mYkPww==
X-Received: by 2002:a05:600c:a005:b0:412:ef3c:f86e with SMTP id jg5-20020a05600ca00500b00412ef3cf86emr922901wmb.17.1709649745613;
        Tue, 05 Mar 2024 06:42:25 -0800 (PST)
Received: from [10.43.17.192] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id d8-20020a05600c3ac800b00412e84e59d8sm4217354wms.44.2024.03.05.06.42.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 06:42:25 -0800 (PST)
Message-ID: <b605f50c-700a-40a7-b8a0-f5c05400161c@redhat.com>
Date: Tue, 5 Mar 2024 15:42:24 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] device mapper udev rules rework
To: Martin Wilck <martin.wilck@suse.com>, Zdenek Kabelac
 <zkabelac@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev, dm-devel@lists.linux.dev,
 Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>
References: <20240305120550.11617-1-mwilck@suse.com>
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
In-Reply-To: <20240305120550.11617-1-mwilck@suse.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/5/24 13:05, Martin Wilck wrote:
> Martin Wilck (7):
>   13-dm-disk.rules: import ID_FS_TYPE
>   10-dm.rules: test DISK_RO after importing properties
>   10-dm-rules: don't restore DM_UDEV_DISABLE_OTHER_RULES_FLAG from db
>   11-dm-lvm.rules: don't restore DM_UDEV_DISABLE_OTHER_RULES_FLAG from
>     db
>   dm udev rules: don't export and save DM_SUSPENDED
>   dm udev rules: don't export and save DM_NOSCAN
>   10-dm.rules: bump DM_UDEV_RULES_VSN to 3
> 
>  udev/10-dm.rules.in          | 43 +++++++++++++++++++++++++++---------
>  udev/11-dm-lvm.rules.in      | 13 +++++------
>  udev/12-dm-permissions.rules |  2 +-
>  udev/13-dm-disk.rules.in     |  9 ++++----
>  4 files changed, 43 insertions(+), 24 deletions(-)
> 

Only really minor and cosmetic things:
  - we're using $env instead of %E to reference the variables,
  - maybe let's dump the mention about DM_SUSPENDED in
12-dm-permissions.rules if we're at it

But functionality-wise looks good as already discussed in the RFC
version of the patchset. Thank you!

(You can also create an MR in lvm2's gitlab upstream repo
https://gitlab.com/lvmteam/lvm2 if you have an account there.)

For the whole patchset:
Reviewed-by: Peter Rajnoha <prajnoha@redhat.com>

-- 
Peter

