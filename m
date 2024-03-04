Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6361F3839F
	for <dm-devel@lists.linux.dev>; Mon,  4 Mar 2024 11:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709550559; cv=none; b=HSnWKtU0f4xoc6sm86piHqlZASnZnQOfIuD+7bjFeQhFtdNXgAydLIitCCjDGPCIZj5OXsRt9JYKj6mc7pE0wKSjdGv1CkPO0+0EK6E0Xoj3aco+t7EY8BV3DWbhSbxFC7ji/oFM+W9PPHcaln8Yop24537NdbNkN+3fsPqhS3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709550559; c=relaxed/simple;
	bh=lueAsQcKG8UfRNxtxUP+9zmS2TUHsMy2QBHurMTRJWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YVY+wStOYSpGYUbojS4HMlBkIuK6JW44j7ph6TX1i5r/6DxY5BA4zrmyWvqqtm96WOdjfril+yn/nzoOy7PniD9WvTnBFUG2LX2nP2ajDsZqghx2yyZdNNJ9rCSXUzewEtd4QJzyupvRB07/Y3mHlQ3ZLaMXV+yYJRIMIN5QbWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NrNjyTzC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NrNjyTzC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709550557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p9kzpo2kjYUMUH6pId8hoxWi66lb5pSAsecrgkHIxD0=;
	b=NrNjyTzClPmhjU9/K6RKk6Mz42TZnP+/iMXgK+V1mX0O4huUgyJW4siUOx7cIzJzZs5Hzr
	cawldcf0cR8qWA7SGstEivc33w83op5gSZaY6ysGzstAXgbv3GRp2CN0DVa9e7wrk5uJ3B
	bb60INop9aXyCmvnwOKAmwWGsIUvOgY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-6HrzbohdO7W3zXlitluQFA-1; Mon, 04 Mar 2024 06:09:13 -0500
X-MC-Unique: 6HrzbohdO7W3zXlitluQFA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33d29de76abso2121766f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 04 Mar 2024 03:09:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709550552; x=1710155352;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p9kzpo2kjYUMUH6pId8hoxWi66lb5pSAsecrgkHIxD0=;
        b=vyGlyOuRGPTYcLHF7aqriTYqyErFA76iidOprmMjlvo0G1GKC4n8fkjiqjysi1uUg8
         k10eC8Ks9V4mjcG5cUu4gw/i+YFxeHVuwmU0nYjT3acLl0iOvPo7WM/+xOGNuB0e/xnC
         3FjxhqIy7rIozuTWnfx9X/ZjQwcy/RO9AhELR/WpD9NppES33fUHJvX9rDZK1k/zB2Ku
         ExwQ3WQ6YaTMRrbZwtclP1yhZN0fsaXpX3JR79cWZ4YERkEGnZpbK25FPz6ED3iztGw0
         XrQWMMp0zQb+Itk5zumHWMfFawwU8w385/cwl+xZ+aKf9LnZUwEWKr9iXVv8EdzA7TzI
         CJaw==
X-Forwarded-Encrypted: i=1; AJvYcCXjdGWSgH9bkVBt1mdyoTp37003rNubtCI+2Y1Es3D+WZvGh3gYAAcHaxq1BdYPZZO27dpl9+XV3as6vblXC9UKZFNRLFjRUyU=
X-Gm-Message-State: AOJu0YxuRIysrMQYYqARRbWgqt1eZ12uS3Uwr1RhHpaElvDCRgOcSBNq
	G5dwltm9ttAzEL8YEDLd851+BlFF9QFcIRiyg9lNvhg80Nt5a5ydzddLtCM3i7HjC3HBvV6Cl0V
	e8QHYivdzzMEltlKnhd2kzTLga23013ykpoHM/WTHvvzxIiBDZjgpTtuL
X-Received: by 2002:adf:f20a:0:b0:33d:2473:4716 with SMTP id p10-20020adff20a000000b0033d24734716mr5810970wro.57.1709550552723;
        Mon, 04 Mar 2024 03:09:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHKKvz4i+huyGZEA7QSOGHXNTtRM6ZW2XzxctazKY+MFWZVMG6cXeRJ1h8VEoRWo64oJMJVog==
X-Received: by 2002:adf:f20a:0:b0:33d:2473:4716 with SMTP id p10-20020adff20a000000b0033d24734716mr5810956wro.57.1709550552453;
        Mon, 04 Mar 2024 03:09:12 -0800 (PST)
Received: from [10.43.17.192] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j11-20020a5d604b000000b0033d9ee09b7asm11903409wrt.107.2024.03.04.03.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 03:09:12 -0800 (PST)
Message-ID: <dfb7c85c-81fb-493b-a897-dae355d22d82@redhat.com>
Date: Mon, 4 Mar 2024 12:09:11 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 7/7] 10-dm.rules: bump DM_UDEV_RULES_VSN to 3
To: Martin Wilck <martin.wilck@suse.com>, Zdenek Kabelac
 <zkabelac@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev, dm-devel@lists.linux.dev,
 Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>
References: <20240301224011.11117-1-mwilck@suse.com>
 <20240301224011.11117-8-mwilck@suse.com>
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
In-Reply-To: <20240301224011.11117-8-mwilck@suse.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/24 23:40, Martin Wilck wrote:
> Bump the rules version in order to indicate that upper level rules
> should consume DM_UDEV_DISABLE_OTHER_RULES_FLAG rather than DM_NOSCAN
> and DM_SUSPENDED.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  udev/10-dm.rules.in | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/udev/10-dm.rules.in b/udev/10-dm.rules.in
> index d30f663..21bbcb0 100644
> --- a/udev/10-dm.rules.in
> +++ b/udev/10-dm.rules.in
> @@ -136,7 +136,9 @@ LABEL="dm_suspended_set"
>  # possible future changes.
>  # VSN 1 - original rules
>  # VSN 2 - add support for synthesized events
> -ENV{DM_UDEV_RULES_VSN}="2"
> +# VSN 3 - use DM_UDEV_DISABLE_OTHER_RULES_FLAG as the only "API"
> +#         to be consumed by non-dm rules.
> +ENV{DM_UDEV_RULES_VSN}="3"
>  
>  ENV{DM_UDEV_DISABLE_DM_RULES_FLAG}!="1", ENV{DM_NAME}=="?*", SYMLINK+="(DM_DIR)/$env{DM_NAME}"
>  

One thing that comes to my mind here is cooperation between the rules
from initrd/initramfs and rootfs - the initrd/initramfs can have
different versions of the rules installed. This was actually the
original reason for introducing such versioning so we can still try to
do our best even if the rules are mixed (to not cause a hang at boot
just because a proper symlink was not found undev /dev).

I haven't tested this with the new rules yet...

-- 
Peter

