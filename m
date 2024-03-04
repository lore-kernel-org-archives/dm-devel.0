Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1451038DE7
	for <dm-devel@lists.linux.dev>; Mon,  4 Mar 2024 10:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709549364; cv=none; b=ARemfaXC4jwkLov3ru8YBPU+8hY2LfYosvXg/CKdAftp/KKhYmdr0jtjtR2HLkRN3EjfCDLMuJqpRNdPk2X6SDq4w2BKfnLiunpLqOP+bNc60cnQJG3b7Ict/N9wI2a2YEZMLD1qlg/9lYX7nsYybvytahKQfoGaIilH6NRTmSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709549364; c=relaxed/simple;
	bh=Fk2rr8h9CoKt+fatQaqJ8GInj+bhXPR0RGdYBFjyirE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fm9F6mGnm/6IvgYbwVhhy2yyr7286P08dgCiiDNByCAOAZqnbau8u1IjKRe+GPC0QMVnwhoUrHnbiauiWeDGsxXiGFYPNICwLgue7GPDQIo74YfjE9NMGeISpG3dCe5J1wEOMiW3cKJkY7DWGrYrPQCfUikzArc5fLEGVzadHwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bGgvnf77; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bGgvnf77"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709549361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CRXnW5N0D+T0nFkHtVIwIbsJVLwrkZ4Q+TcKGMJnXn8=;
	b=bGgvnf77ZsqDi3ayOQdxe/YtjiC7FLlPeme0V1YZ2zCDg5JFafyfMhVloP1fbo3vsuBRWh
	h0kiO/Wsu3BJ/1bgAU+VWD+A0Y3DjyQpwly/oU1LPBkrhD91kzVTSKzOrPRVX37lZPCMnu
	H2+eEyjm5EFmqu+RXnkeLRcMo6dZxbI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-DkfprFf4MPao-kxVG-gP9w-1; Mon, 04 Mar 2024 05:49:20 -0500
X-MC-Unique: DkfprFf4MPao-kxVG-gP9w-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33d0d313b81so2095580f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 04 Mar 2024 02:49:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709549359; x=1710154159;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CRXnW5N0D+T0nFkHtVIwIbsJVLwrkZ4Q+TcKGMJnXn8=;
        b=kl/iWCCB9r4W27RZ6cgzH1sbSYybvRVJ6ze4PjeX1Qds0alnDhCu5emeWfexqagH1A
         pxGPLrjsAgLgdLyVLJIQx+RW6kNtBtYHgXbZzytQmUBCZ+Cn0vsyFlePkZLyw1CGYksZ
         YSItMDaY6WpmXvkTFXeKIHl/4G3PSFwqQqF+HevMuiCUKfiXw3Uz+FBR7Ht9WI0y40oU
         tpe5ErFy+YiBqosx2WwRr8BpMW67UUSHY99nC2VWSAOWnzD8mWR3TJBxewUmvSmiN1A2
         Oa4FSuMOzMVfDIfeYUCDsu2JnCkeqWRxyhbvO+8YoCfPkYi6g2axYOj3O3yf//QJshJw
         Q97A==
X-Forwarded-Encrypted: i=1; AJvYcCWmzH7JtOkvL9bjaQbCBFRlJTQWJCmEMtKWqRa2bdknqfO2MueloQLJku9f7cZX8DMMAiO4PqQ61nmFAo17d94wtfg3thNJ+lE=
X-Gm-Message-State: AOJu0Yy4bi826hve8+CBerGzX0ECFVQmAzS2XUR9sOZyyO6C26qvuXVf
	gyVfHrt8h3RZ/ggraoj9WDmN9R4yeAXqyzQXP/erJOgBHvnxX5/4uru0bwdDkYXeDidXxLMBq/v
	5B78s4JjVxX3I73Kmgr5xidGez0Dv+a/UtyqxgOt13Fr5YKw6wYV8pd/D
X-Received: by 2002:a5d:4d87:0:b0:33e:d17:76b with SMTP id b7-20020a5d4d87000000b0033e0d17076bmr6003223wru.7.1709549359474;
        Mon, 04 Mar 2024 02:49:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFsjcm7i0vxhvDjGogVIRUa09eFCmwnM4Pyb64wT/VvaTwdRhW8Sf8ecg3iE9LSOLAqMIVeGQ==
X-Received: by 2002:a5d:4d87:0:b0:33e:d17:76b with SMTP id b7-20020a5d4d87000000b0033e0d17076bmr6003209wru.7.1709549359202;
        Mon, 04 Mar 2024 02:49:19 -0800 (PST)
Received: from [10.43.17.192] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h3-20020adfa4c3000000b0033dd2a7167fsm11986328wrb.29.2024.03.04.02.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 02:49:18 -0800 (PST)
Message-ID: <c19cc76a-96f9-4ffd-8208-0513f000d331@redhat.com>
Date: Mon, 4 Mar 2024 11:49:18 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/7] 10-dm-rules: don't restore
 DM_UDEV_DISABLE_OTHER_RULES_FLAG from db
To: Martin Wilck <martin.wilck@suse.com>, Zdenek Kabelac
 <zkabelac@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev, dm-devel@lists.linux.dev,
 Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>
References: <20240301224011.11117-1-mwilck@suse.com>
 <20240301224011.11117-4-mwilck@suse.com>
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
In-Reply-To: <20240301224011.11117-4-mwilck@suse.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/24 23:40, Martin Wilck wrote:
> We use DM_UDEV_DISABLE_OTHER_RULES_FLAG to tell upper non-DM layers
> to keep their hands off the device in question, for any reason.
> One possible reason is that the device is supended; another is that
> the cookie carries the flag of the same name.
> 
> DM_SUSPENDED is not restored from the db, but evaluated anew for every
> uevent. Therefore DM_UDEV_DISABLE_OTHER_RULES_FLAG shouldn't be
> restored, either. Use a new variable DM_COOKIE_DISABLE_OTHER_RULES_FLAG
> to save and restore the original value from the cookie.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  udev/10-dm.rules.in | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/udev/10-dm.rules.in b/udev/10-dm.rules.in
> index c08d829..ef36209 100644
> --- a/udev/10-dm.rules.in
> +++ b/udev/10-dm.rules.in
> @@ -48,7 +48,14 @@ ACTION!="add|change", GOTO="dm_end"
>  # These flags are encoded in DM_COOKIE variable that was introduced in
>  # kernel version 2.6.31. Therefore, we can use this feature with
>  # kernels >= 2.6.31 only. Cookie is not decoded for remove event.
> -ENV{DM_COOKIE}=="?*", IMPORT{program}="(DM_EXEC)/dmsetup udevflags $env{DM_COOKIE}"
> +ENV{DM_COOKIE}!="?*", GOTO="dm_no_cookie"
> +IMPORT{program}="(DM_EXEC)/dmsetup udevflags $env{DM_COOKIE}"
> +
> +# Store the original flag from the cookie as DM_COOKIE_DISABLE_OTHER_RULES_FLAG
> +# in the udev db. DM_UDEV_DISABLE_OTHER_RULES_FLAG will be or'd with other
> +# conditions for use by upper, non-dm layers.
> +ENV{DM_COOKIE_DISABLE_OTHER_RULES_FLAG}="%E{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
> +LABEL="dm_no_cookie"
>  
>  # There is no cookie set nor any flags encoded in events not originating
>  # in libdevmapper so we need to detect this and try to behave correctly.
> @@ -58,12 +65,13 @@ ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=="1", ENV{DM_ACTIVATION}="1", GOTO="dm_flags_do
>  IMPORT{db}="DM_UDEV_DISABLE_DM_RULES_FLAG"
>  IMPORT{db}="DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG"
>  IMPORT{db}="DM_UDEV_DISABLE_DISK_RULES_FLAG"
> -IMPORT{db}="DM_UDEV_DISABLE_OTHER_RULES_FLAG"
> +IMPORT{db}="DM_COOKIE_DISABLE_OTHER_RULES_FLAG"
>  IMPORT{db}="DM_UDEV_LOW_PRIORITY_FLAG"
>  IMPORT{db}="DM_UDEV_DISABLE_LIBRARY_FALLBACK_FLAG"
>  IMPORT{db}="DM_UDEV_PRIMARY_SOURCE_FLAG"
>  IMPORT{db}="DM_UDEV_FLAG7"
>  IMPORT{db}="DM_UDEV_RULES_VSN"
> +ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="%E{DM_COOKIE_DISABLE_OTHER_RULES_FLAG}"
>  LABEL="dm_flags_done"
>  
>  # Normally, we operate on "change" events. But when coldplugging, there's an

Looks good...

-- 
Peter

