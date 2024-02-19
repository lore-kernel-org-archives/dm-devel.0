Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F08921370
	for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 08:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708331812; cv=none; b=mUq1wzyevhUCnpLSZOlZILOzJO8oQtaWdUep9byIBCgIHbenxMiC80/WZXJYSseaDJXuTdioScV9ASoo1J3rUC8xXzUxhid4UPIB12iD9jES9RiqxsVeZGBiBwPC2YFXhAUG70ICOk58tqwqaihsDFLe0t1jGDTyGSCIF6XFnDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708331812; c=relaxed/simple;
	bh=BrpXzltbjGA+nbeqv1oqWoboeZ60CpfhH6jPRTng6dg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tCRfiblKApfDCHjvEJvTyVxSAzdF1S1bXgQ9x989dzk/zKLfR0ctFZprZTjxiPLxVqggUx/66+YMcDxTsfK0tETGb5SijZR7i3WRkVQRaVuoYadARHDWHsZ74ETLQlEWwpDoLfyqgJ2dROWrInlxSaUJAHW1zC2e/RySD/n24PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IPqPxqSg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IPqPxqSg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708331809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fv6aRDO6Js09h9BTDicI9/jIrJAhCI1gKmwSr35xlX8=;
	b=IPqPxqSgdyqcDLTgPTHjzWhO9Gz82c7UeGv5F+R+9nlbyXBNGZjZlqaNKRyi8yBpyT4N+E
	9+SoSA3FylE0BAPomGwH8zOj7gVu1/borFL90UfHr33GacITWihBoWA8J01wzAemHBRphu
	30p73S7AthzsHE7E4jt2JqHHs53D5xo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-suI0xzE0Pa-G59Pctkr7Dg-1; Mon, 19 Feb 2024 03:36:48 -0500
X-MC-Unique: suI0xzE0Pa-G59Pctkr7Dg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33d516a8026so241820f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 00:36:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708331807; x=1708936607;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fv6aRDO6Js09h9BTDicI9/jIrJAhCI1gKmwSr35xlX8=;
        b=OXYfWFnVc7klBFeTQ32Pt3OOryPjmZtCl1jOCQQ06LRhQDHkY1DFgnhj/mYIGSeW1c
         SN9NKo5X5n1/GfIWH4l65ga0X63mDyrblhpa6l2m0+umSGHJ9RrWYfhsgGHFGagP+XqA
         2TaiIMxVVFLFBLJIgxhtJiuP3H/J0H0Ny5Zd9q4NSVTeJsMXhuNxs1AkqpUvK47xMD+n
         LCUKUdhnT18i2sT0/Ni7wV8HNVzOFW6JTB3gWeynRAz+tqUu1MZi1/BJnPJg70OdXlqg
         kIGlbAH+2sd8MDQx2jFPUssLu9i5rYTFZmuve6cMo2mZfSsm1S5/ICU3Gzo/2uKVJa/Z
         f2Fg==
X-Forwarded-Encrypted: i=1; AJvYcCU66mu+wKqIW/SWnTPZEWZlxtcevvvP/d8ZqJwYXT6Nk4g72DCt23hjWn+zMITJN5rKqBlwbz07puZPYfUwmGOa32pT44M5YOc=
X-Gm-Message-State: AOJu0YzBtkNjzWGtdNlDa+rtQglAZpW6vgdsenC9mh7Ilrr6FdbtJSnc
	XXgDrZLiFj5fooeS9nhvk2oRlXEgSt8z4ziYPtY7yWCdnvh7+naKxLzQWpCx/SMwDn8onzDgAZY
	diGuAIAB9zBEe8gmh7qrjWAhEoF2aA+cjbkXGhS5NM1kLQUTp4bx5u3AW
X-Received: by 2002:a5d:4ecb:0:b0:33d:277b:1ef1 with SMTP id s11-20020a5d4ecb000000b0033d277b1ef1mr4028586wrv.31.1708331807062;
        Mon, 19 Feb 2024 00:36:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHjDG5yZB2iB5Rfe3IPkRx/ksv19bItcOgGW0WXvNG5HCP6RZfTIPjws3Qs0U6lAfEX7JWv2A==
X-Received: by 2002:a5d:4ecb:0:b0:33d:277b:1ef1 with SMTP id s11-20020a5d4ecb000000b0033d277b1ef1mr4028574wrv.31.1708331806732;
        Mon, 19 Feb 2024 00:36:46 -0800 (PST)
Received: from [10.43.17.17] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id d2-20020adfef82000000b0033b75b39aebsm9674031wro.11.2024.02.19.00.36.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Feb 2024 00:36:46 -0800 (PST)
Message-ID: <9d50edb0-baa4-4a01-a2f0-136dfdb79937@redhat.com>
Date: Mon, 19 Feb 2024 09:36:45 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: About DM_UDEV_DISABLE_OTHER_RULES_FLAG and DM_NOSCAN
To: Martin Wilck <martin.wilck@suse.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, David Teigland
 <teigland@redhat.com>, linux-lvm@lists.linux.dev, dm-devel@lists.linux.dev,
 Heming Zhao <heming.zhao@suse.com>
References: <61638dc821c08cd97f6ac53150c5b0120f732deb.camel@suse.com>
 <4a9e62ec-f93a-4739-a406-2c6d2138258a@redhat.com>
 <9b1475e2fa5982dd508d58975b8e6eb58cad95e2.camel@suse.com>
 <f3e3db2b-8077-48b6-b507-4a9c4793affb@redhat.com>
 <8e7a574fffaded39825a01bf33482cea94507289.camel@suse.com>
 <Zc6UEKsce2ppaP62@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
 <b38d9ae7b49ec1569b25c5f5a55afbc47df4b09d.camel@suse.com>
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
In-Reply-To: <b38d9ae7b49ec1569b25c5f5a55afbc47df4b09d.camel@suse.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/16/24 15:29, Martin Wilck wrote:
> On Thu, 2024-02-15 at 17:45 -0500, Benjamin Marzinski wrote:
>> On Mon, Feb 12, 2024 at 03:16:27PM +0100, Martin Wilck wrote:
>>> On Mon, 2024-02-12 at 13:32 +0100, Peter Rajnoha wrote:
>>>
>>>>
>>>> What do you think about keeping a single
>>>> DM_UDEV_DISABLE_OTHER_RULES_FLAG for this, just having a
>>>> different
>>>> value, say "2" to denote the B case? Otherwise, we need 2
>>>> distinct
>>>> variables (which is harder for others to accept I bet).
>>>
>>> Yes, that could work, if the save / restore is implemented cleanly.
>>
>> What if we never read DM_UDEV_DISABLE_OTHER_RULES_FLAG from the
>> database. Instead how about, if DM_UDEV_DISABLE_OTHER_RULES_FLAG is
>> set
>> by "dmsetup udevflags", we save it as something like
>> DM_IGNORE_DEVICE.
>> Otherwise, if it's a spurious event, we read DM_IGNORE_DEVICE from
>> the
>> database. After "dm_flags_done", if DM_IGNORE_DEVICE is set, we set
>> DM_UDEV_DISABLE_OTHER_RULES_FLAG. This leaves the other rules free to
>> mess with DM_UDEV_DISABLE_OTHER_RULES_FLAG all they want.
> 
> That sounds good and aligns with what I'd thought by myself. But we
> should use a less suggestive name. DM_IGNORE_DEVICE would again make
> users think that they should consume this variable, like DM_NOSCAN.
> 

Yup, that looks reasonable and clean.

Though, the DM_UDEV_DISABLE_OTHER_RULES_FLAG is only one flag from the
whole set. To avoid handling only a single selected flag in a special
way and to avoid issues raising from that, we might as well apply that
logic to all the other flags decoded by `dmsetup udevflags`.

-- 
Peter

