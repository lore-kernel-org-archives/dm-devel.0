Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA034DA1F
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 09:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709629847; cv=none; b=YcAUdjt+chUt8zgKgHzaSVY+kVcb5/5KDoZ4w5CriMbvinwN6p0q8KKYmSk9mohvpU2vOqqMMUGf9tFV2K/2Q5ocuCHtYuwA9HR0tbBTScop3DshVbgipfSiDgMBaTBv3JVhKXSZoaFO573BESSYuc+dquOXmFM6yPCY+FOQPWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709629847; c=relaxed/simple;
	bh=fUIGm53vhhY0a45gWtUnpm0vdCa5q11YxgjoTCgx/tY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DDIS/cggh53fGsQ9Qlc4o+VlHsUCBg3RWsBf9DqbWRWOf1mumqW5SHP7qXcChlKeqMA7MtSTrQXGhOuHh5yPcWAc9KaeBKhW47/Ck9SRUODVtRAw3jPtaMcxxxlV8iT4vgCpooh391ZeDnlAnRb1gVYDVexrVxR/VnTedJE+ulg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gPy+wsZa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gPy+wsZa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709629844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fpJJ5XODZpWKHE7pUK7/Bv8s8N2PLayKtZIKNSYeSrc=;
	b=gPy+wsZaHoBEzEp2mWQMEfaiWEtsdQse25wfEo/QDBGJIGdpyVqmLE0kAf9fOUAvqss1Wm
	XFba3PNsZpCn0OmIezCxd2aIzV9+FEviVstfc9NhbjxC/yjC75wcPbFtciiuGkPEab2+R/
	ZKIexGryScOyC1OX9UyhlERwNHB8SBU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-9sfHf0oYNH-Um7qSl5mcFQ-1; Tue, 05 Mar 2024 04:10:43 -0500
X-MC-Unique: 9sfHf0oYNH-Um7qSl5mcFQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-412d433bba5so16060155e9.0
        for <dm-devel@lists.linux.dev>; Tue, 05 Mar 2024 01:10:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709629842; x=1710234642;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fpJJ5XODZpWKHE7pUK7/Bv8s8N2PLayKtZIKNSYeSrc=;
        b=DsBwGvhTIGuPFXFlVDie5Wpzi0v00Ty5lEh+88ywiZJiSenHXLgG+iiYIHrCSA0hff
         8E4ous0RgdAE4SHotQ6bUnI+QrcGS2Kl3mndyN4R8oF4EusLyEz3jYhWRrGV3xCUmvpN
         sGBKjnKgtaiPrWfA68JHKxpsqO7O89BOoichDmCr0N5kZjO91hKRQjoPoO53flE2xd26
         asmiWpOk1JNEX4w3w4uF1XaL5r52P3PlClVkZ0Tl4zHhmEV28Wo4fg82LliNjCjp623n
         HDBy2EED6Psfco3AM0xp4/1IxTPbtWCvD8ZkGxgirreFrUv8nlxa/VAz2faBjG17Z2Xw
         uIvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXp/qDLpFWqR9fsomkmnHIIKle22hU7Nwc3wWL8vo+mO7plhTiY5K5zCUq97PB5+kqh2WnGM/XeUqhSMtq6PectDDHr8wH9n5w=
X-Gm-Message-State: AOJu0YyWGHzrLG8gos5LNXNBvWq9YH9LFuiXTOTiO1RslGmF8NkQNhaF
	DB6J7+6zbZXnPpcGyK9OWC42rEXbGtkmVYVJNNJnVVTJE3zrMxsCPxb7WghgzHarwc1pPZOY5FU
	QZmPrtTMTMIDSEB1mIZcS3s55APxszmcdky96cH0y50UnAr9IWIRPNNYd
X-Received: by 2002:a05:600c:4e91:b0:412:b489:14f9 with SMTP id f17-20020a05600c4e9100b00412b48914f9mr9439382wmq.15.1709629842511;
        Tue, 05 Mar 2024 01:10:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH8UworSviWLD0RK59mbjlW82Ko5oJUCMYGpq+uHeDbjSUTJv7LWSeyv7l2fX53294hfWMWaQ==
X-Received: by 2002:a05:600c:4e91:b0:412:b489:14f9 with SMTP id f17-20020a05600c4e9100b00412b48914f9mr9439365wmq.15.1709629842127;
        Tue, 05 Mar 2024 01:10:42 -0800 (PST)
Received: from [10.43.17.192] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s6-20020a05600c45c600b004129e8af6absm17187894wmo.33.2024.03.05.01.10.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 01:10:41 -0800 (PST)
Message-ID: <5b9fb513-3510-4bae-b0f3-f7d558d4ed58@redhat.com>
Date: Tue, 5 Mar 2024 10:10:41 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/7] dm udev rules: don't export and save DM_SUSPENDED
To: Martin Wilck <mwilck@suse.com>, Zdenek Kabelac <zkabelac@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev, dm-devel@lists.linux.dev,
 Hannes Reinecke <hare@suse.de>
References: <20240301224011.11117-1-mwilck@suse.com>
 <20240301224011.11117-6-mwilck@suse.com>
 <2b6bfa53-dfcb-4fe8-859c-8d99a5eadcbf@redhat.com>
 <0404fc2e69aea20c74f8a1a258b98dafd6ae0fec.camel@suse.com>
 <6e36545a-42e3-4bfc-945c-77d07b6ab484@redhat.com>
 <1fb575095f094244b6b35e7da79af81728014588.camel@suse.com>
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
In-Reply-To: <1fb575095f094244b6b35e7da79af81728014588.camel@suse.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/5/24 09:47, Martin Wilck wrote:
> On Tue, 2024-03-05 at 09:19 +0100, Peter Rajnoha wrote:
>> Within DM and DM-subsystem rules, it's OK to use DM_SUSPENDED, if
>> needed.
> 
> I gather that you agree that 11-dm-mpath.rules represents a "DM
> subsystem" rule set?
> 

Sure, of course.

>>
>> We should just hide it from all the "other" rules so they don't need
>> to
>> bother. For them (right now), it's either "usable" or "unusable"
>> device
>> for whatever reason behind and we (DM+DM-subystem) should reimport
>> whatever is needed for the state/set of variables that others may
>> use,
>> to stay sane. Of course, we can do this only for the state that we
>> own.
>>
>> As we discussed before, this can be extended to making a difference
>> among "usable", "temporarily unusable" (so reimport the
>> state/variables
>> needed) and "completely unusable" state for others.
> 
> Yeah, but that's future work, and I doubt that it makes sense to invest
> much effort into it. I definitely wouldn't want to tie this to the
> current patch set.
> 

I agree.

> As mentioned previously, it might make sense to introduce a flag that
> expresses something like "you can access this device, but you don't
> need to" (DISK_RO={0,1} case, for example). But then, we already have
> DM_ACTIVATION to express the opposite ("you must have a look at this
> device, its properties have changed"). I wonder if you consider
> DM_ACTIVATION a dm-internal property?

Well, we added DM_ACTIVATION as a helper primarily for DM and DM-subsys
rules to have a way to identify when the actual (re)activation happens,
or the "add" trigger on coldplug.

I think it was 69-dm-lvm.rules (or 69-dm-lvm-metad.rules at that time)
where we needed to run pvscan only right after the DM dev is activated
and hence avoiding running costly pvscan uselessly where it doesn't matter.

If there's anyone else out there with similar use case, I think that
checking DM_ACTIVATION might be useful. But it's true it is not
advertised and shouted out somehow publicly yet.

Usually, all the other rules are interested in rescanning all the other
"foreign" state and attributes that is out of DM's hands, which means
they know exactly when to do the scan or not or any other actions, it
depends on what attributes are they watching for.

DM_ACTIVATION is very useful to know when stacking devices on top of DM
though, so a time when to activate the layer above. So yes, this
variable might be useful for other to look for too.

-- 
Peter

