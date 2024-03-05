Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C8F7E57D
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 08:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709626780; cv=none; b=Jbc3kwXvZs/phh7PfV8RsyjIK2uvm1VtMOqMa8r1+WMQliMM/YEoaVZULluarwWeSXowN/F/yLVGvxti2Gs65+GuUQ864RhfGP16oqPF34X6NI5c8yhY2ny32+bT88Aaxxxb+PZbEeSSlUZCye14q5QU0pYMoLHHtjtl9+OA4v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709626780; c=relaxed/simple;
	bh=8pmeYpZLluPwNZLtVa4VnqxsTKb7mljP7LSio6qwmME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R3YYaUZdzFsFDXcFNfzwhqV8sBatLyqhIuZUe4JhNBm1xE5i7s9T0Swz6hYr2JC7KiCWNOofAPTQG/l1ZGtjpDTSNW18DCBMP16Yd6bPEWoWB0sRp/zQWZ0qrWF+xXpH9GbgmCZyDa1M7vN2ECY2xLDis3NnK9hS9QJeJkBOzAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OfBdJgqf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OfBdJgqf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709626777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ISfyxRlrlMNX29sdFAIMR5HEH/SWgY+7GxW9vE2aOqU=;
	b=OfBdJgqfhgjMudHsLVjcbOY1bSVIXqnxgexqyEYvu+dLgVVz8igP9YfsilahErX8f0BdWY
	VezMNWR7WXB2Gp3lEVuR2ShQPqedVYQvTkc7YHq1cHuRX1PpT02hl8tvd4YgppNPHJSUsU
	JYjBeqiWo6jwKfTb6C4EQmh41s+8TnI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-DwS6FklxMv-Yn1j29_Gg6A-1; Tue, 05 Mar 2024 03:19:35 -0500
X-MC-Unique: DwS6FklxMv-Yn1j29_Gg6A-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-412c9e3c9b9so18956935e9.0
        for <dm-devel@lists.linux.dev>; Tue, 05 Mar 2024 00:19:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709626775; x=1710231575;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ISfyxRlrlMNX29sdFAIMR5HEH/SWgY+7GxW9vE2aOqU=;
        b=NZsjD5bnELNC+7kHVZtLtkkKJGdF2apZpKw4xNX1aapjERO2JFvsKX/vWVECwNEtKP
         rIogGTAYyEBoWdA5UIIk1Nv1zCqxypxlUS69ByS4sGuwYvqH73ZHRitCM4O9U0A06Zk6
         FGsxl991YxfmJO5odAnSd4ugsumpO2pk1rDs3N6QR30YWk6Dlgc+VqduAjsyJMfFrWPj
         vav31UHvWn0j3FNMtQX4AJgGcSIY5z0MEdiPlWzZqDIEz0kuBqcSrm2arEkf3UNKorSj
         Ms6L6ao3Cd3gM5GjR1MCIq92K/5FXUM0sTA763PZucTU4LuNi5G+1klZSRbwRdQQ6dGr
         tMvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWUblKSAD2mCzdWTi8rCz7EVJxng9uZEQFOmrrFmyr5yzfJpEypek/njYwhwidYOE4lV3zehS3hfRozeQq3kr3SRQKh5H8C+M=
X-Gm-Message-State: AOJu0YwlVcCvYzufcaFDepbUPQs03ZeCEuvwpD4s9kquFvzi/29K7+Mj
	ACQfvviWByLxCYEMFYPgwCccqe+rJI2rGnqAxpZtl+qgiCe/1ALHfCsmqsX+RI/34MCgxVKtQaQ
	ktZ+H5r8b89fZftP91Lp+whRyRxHkbPFSwtlhd9GJzjeEBz7Pq5lE6LIR+mCJlStF
X-Received: by 2002:a05:600c:4ecd:b0:412:aa70:67a with SMTP id g13-20020a05600c4ecd00b00412aa70067amr1524809wmq.5.1709626774867;
        Tue, 05 Mar 2024 00:19:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFT3FIu0Hl0EjYg7GOdjMai62dWyXFdeJTgZ/rvEIMeMv73oXS/bt5gJRkBpADJv1/3/SGNjA==
X-Received: by 2002:a05:600c:4ecd:b0:412:aa70:67a with SMTP id g13-20020a05600c4ecd00b00412aa70067amr1524789wmq.5.1709626774541;
        Tue, 05 Mar 2024 00:19:34 -0800 (PST)
Received: from [10.43.17.192] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id p4-20020a05600c358400b00412b56aa46bsm16926854wmq.13.2024.03.05.00.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 00:19:34 -0800 (PST)
Message-ID: <6e36545a-42e3-4bfc-945c-77d07b6ab484@redhat.com>
Date: Tue, 5 Mar 2024 09:19:33 +0100
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
In-Reply-To: <0404fc2e69aea20c74f8a1a258b98dafd6ae0fec.camel@suse.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/4/24 17:21, Martin Wilck wrote:
> On Mon, 2024-03-04 at 12:00 +0100, Peter Rajnoha wrote:
>>
>> OK, makes sense. But I haven't looked at what implications this might
>> have for 99-systemd.rules yet, but we surely need to have that
>> covered
>> somehow.
>>
>> Maybe, now, I would probably even remove the mention about
>> DM_SUSPENDED
>> in 12-dm-permissions.rules, it looks superfluous there. We normally
>> set
>> perms based on names, not on DM_SUSPENDED state. I'm not sure why we
>> mentioned it there before.
>>
>> Do mpath rules still need to look at DM_SUSPENDED?
> 
> No, and yes :-)
> 
> If we remove the DISK_RO clause, DM_SUSPENDED and
> DM_UDEV_DISABLE_OTHER_RULES_FLAG (as input from 10-dm.rules) are
> equivalent for multipath. We'd be able to modify 11-dm-mpath.rules such
> that DM_SUSPENDED isn't used any more. The downside is that 11-dm-
> mpath.rules needs to modify DM_UDEV_DISABLE_OTHER_RULES_FLAG under
> certain conditions, and that DM_SUSPENDED is shorter and expresses the
> actual situation more intuitively. Therefore I don't love the idea to 
> replace use of DM_SUSPENDED with "DUDORF" in 11-dm-mpath.rules.
> 
> My personal take on this is that 11-dm-mpath.rules actually belongs to
> device-mapper (being executed before 13-dm-disk.rules), even though
> it's not maintained in the lvm2 repository. As such, it should be
> allowed to access dm-internal flags like DM_SUSPENDED. 
> Not that's not a problem with this patch; the multipath rules can just
> access .DM_SUSPENDED instead of DM_SUSPENDED.

Within DM and DM-subsystem rules, it's OK to use DM_SUSPENDED, if needed.

We should just hide it from all the "other" rules so they don't need to
bother. For them (right now), it's either "usable" or "unusable" device
for whatever reason behind and we (DM+DM-subystem) should reimport
whatever is needed for the state/set of variables that others may use,
to stay sane. Of course, we can do this only for the state that we own.

As we discussed before, this can be extended to making a difference
among "usable", "temporarily unusable" (so reimport the state/variables
needed) and "completely unusable" state for others.

-- 
Peter

