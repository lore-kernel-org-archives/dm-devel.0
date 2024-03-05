Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474C37F479
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 08:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709627175; cv=none; b=ojyT2lW8QQYrIv1tNt9qgsVIQl3WbSDh+p9/0WnKliISo7QuYCFzPiUe2SBAFaAuaasVXoagGp446V5uZuWgi2ftB7rybkLinqHOYxN3eigW/pZaxVUZdaXCrt4fujx0+DaxUlcpIzPu0UuSnBB7hm9/RtVquePNA8ebrpblgv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709627175; c=relaxed/simple;
	bh=Z6jAjcjvWf3Y7JezzxY5ZFfCKFYJ2z4APJhCk1BgLKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CiSSDJlt8PolneYFPDiY44jYvmVnOaNe8QRjz+ZntffO4QMsLMnvrJckiwPGMWIZUldB7IgXCesNi7kxUHvjXhJ1gxZF5/Adoeoq9wwoCqJAVbp9dT1wAJx0HL4RLoa2ZXJvs/yuSow7fzHJ7mS6fOqNw9hmeRIjs3vdoK3Veos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OB/fYTiA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OB/fYTiA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709627173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4UrDOO2FvH1yGgBin9JaXxEtYa0JbKD0Lyqa7VrRJkQ=;
	b=OB/fYTiAAmlqvVGvl/P5q7svDruO09r9kPFYDOS2PH7DSGI48NCOCrZrjaObkqxEGqqB7T
	V3ZlcjCBmpP2isnKJcFW+bsxN/bIAgCD+JMz9eym0G/vivhzadKMam32GAUFhtUto14roD
	+ExfqBtjkRwfcpJY5UqUKc/TZwG5F54=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39--Se2AeFfPHacOi-Ak_bzRg-1; Tue, 05 Mar 2024 03:26:11 -0500
X-MC-Unique: -Se2AeFfPHacOi-Ak_bzRg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33deb1f7afdso2724356f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 05 Mar 2024 00:26:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709627170; x=1710231970;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4UrDOO2FvH1yGgBin9JaXxEtYa0JbKD0Lyqa7VrRJkQ=;
        b=Kax/BUAXrdWDcVlSW5JGJKIrfTdx8IU3QwW8+MHeXF1VrXxMTW2XnXrCJWHbcBPMlo
         NQxi6aaaYYzl7xu7ao/2aVdbaEPsUnxaRMiqiALM2MTUt7w+crVGDi0DwXqk1zPihct+
         H91hBBOR9zGj5zd0TciPH9y56lPsACRnwMvch4jwiY+ktFvgr5Vp/tw/odSjasPhNlLl
         wbPCtS7eEMFkQSv3qRe74DXZPji5sEay4ujnOux7qdMyXIEU9wE6ZME1JAW4UqGORXKS
         zb1EqXoKsTf+duC0roJFVmyIPv4oTZlP2DFIi9ZX2YAlQnSvn+aZo3iygw3Ry3AKfATp
         MzRw==
X-Forwarded-Encrypted: i=1; AJvYcCV2Ni3Oqvy+T8ztm8Cz4vxq6omlVxr31ilXzHL4AjhQ1E20XIFA+Tmcu8oGL0JoZJxGjyKvAUsFoC8uhD1UvCdrc8CV+hMkdfk=
X-Gm-Message-State: AOJu0YyXXG8/q8OXkxQBUtyZ85Tu+DYHdX3pUgYrmrsRykh8a75VtbDq
	WkbDisgod2rJhAF8QPUCnf/ffb0f/2CI32y3FoldcpdN6ACbfF1TjBr2BuG7t8sogf/cmRRicfL
	TUR5XEYtbxWJMtSNDp+0cfMrX52eaCiNq4+duhoz47L2Yy0J3kqbufFI5
X-Received: by 2002:a05:6000:1cd2:b0:33d:fe8d:4250 with SMTP id bf18-20020a0560001cd200b0033dfe8d4250mr7942891wrb.5.1709627170391;
        Tue, 05 Mar 2024 00:26:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH//GR+rH+K/J9ycpSG0iKl9SRXHod8HasydZD+sP+C1Ac/neK6XukuubqGK4qL8VIjbnu/JA==
X-Received: by 2002:a05:6000:1cd2:b0:33d:fe8d:4250 with SMTP id bf18-20020a0560001cd200b0033dfe8d4250mr7942877wrb.5.1709627170078;
        Tue, 05 Mar 2024 00:26:10 -0800 (PST)
Received: from [10.43.17.192] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id bs19-20020a056000071300b0033daaef7afcsm14620189wrb.83.2024.03.05.00.26.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 00:26:09 -0800 (PST)
Message-ID: <a23a5d51-32fd-4e6e-a79b-901d37734d5e@redhat.com>
Date: Tue, 5 Mar 2024 09:26:09 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 7/7] 10-dm.rules: bump DM_UDEV_RULES_VSN to 3
To: Martin Wilck <mwilck@suse.com>, Zdenek Kabelac <zkabelac@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev, dm-devel@lists.linux.dev,
 Hannes Reinecke <hare@suse.de>
References: <20240301224011.11117-1-mwilck@suse.com>
 <20240301224011.11117-8-mwilck@suse.com>
 <dfb7c85c-81fb-493b-a897-dae355d22d82@redhat.com>
 <1bfb001084b17ab60c57f4819711c7d91c461536.camel@suse.com>
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
In-Reply-To: <1bfb001084b17ab60c57f4819711c7d91c461536.camel@suse.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/4/24 17:46, Martin Wilck wrote:
> On Mon, 2024-03-04 at 12:09 +0100, Peter Rajnoha wrote:
>> One thing that comes to my mind here is cooperation between the rules
>> from initrd/initramfs and rootfs - the initrd/initramfs can have
>> different versions of the rules installed.
> 
> Yes, that's a source of pain. Are there current initramfs tools that
> user DM_UDEV_RULES_VSN!=2? I think "2" should be the standard today,
> given that it has existed since 2009. dracut just installs the upstream
> rules it finds, at least for dm, AFAICT.
> 
> I've reviewed other rule sets I'm aware of, and the only one in which I
> needed to check DM_UDEV_RULES_VSN was 11-dm-mpath.rules. I didn't have
> a close look at the rule sets that dracut ships yet, let alone other
> tools for initramfs maintenance.
> 
> Regardless, my patch set changes the availability and semantics of the 
> device-mapper udev properties, and thus we should bump the version, no?

Sure, that is expected if we do such changes to rules.

I just meant to be cautious about a situation where we have initramfs
running a different version of rules, then keeping the udev database
over the pivot-to-rootfs (which happens with dracut, not sure about
others). Then, on coldplug running from rootfs, refreshing the state
with the other version of rules.

Important here is that the rules running from rootfs do not get mislead
with the state that was taken over from the initrams.

-- 
Peter

