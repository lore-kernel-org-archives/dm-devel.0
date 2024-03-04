Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6CF20323
	for <dm-devel@lists.linux.dev>; Mon,  4 Mar 2024 10:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709548665; cv=none; b=gFHCQCNIhrVHDEK12/w7zryzaQA2PbNIsX6WOCX2EJOrZH7sQQiTlM8jB4nkxmA5862Ir+KZnx5lzjoy6nCJnZDNNiTZO/VbsJfeQXC1F4VC+mtcG1GQHvXGQmBoVHVgK5P0xvegSO7nPZ7HuMT/mmhbLmU7X61b3XD6MkH1jbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709548665; c=relaxed/simple;
	bh=BmoPfstdfer41KiTutAfwcAgRY/APq7kxrfDmfmvK2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B/9/x5UEgOw6u4w7MW+aGzgUTGPombQ9SxpMIPY7lrA21MpZ1qG5OOsgXa2ivCs7lVUYG9Fqcyq2hBnLtxMtzAgAP4YhqPpp7QcFhE1cS7IK8w/U+klfXQHCoQZEDze5WApUEvfhSp8Xmk5y6lLOzKsQ6qoBdUXOA4NRppsp5pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iY+eVqUm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iY+eVqUm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709548662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PWaJIR7zP8MNHpeZwLeMMOO0hOo/kagxoZ9mccSSbv0=;
	b=iY+eVqUmP4k0DI1zpRaIbsn/AcjqMVhFNJlt2uuJckVKNxgZC+iJXp95b6Ml2lHAvwuEkr
	v4zTQprhI404+jgOUGGgc5RsLWH4BGBAwZwsTSqVb/Siv1sgpt01o6yk3B5psKtEi58Smn
	+OdVpMDRcAFNW/YED3olwEYbPTf/ha4=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-7CO-RFibNae3y8g0i5Bd_g-1; Mon, 04 Mar 2024 05:37:41 -0500
X-MC-Unique: 7CO-RFibNae3y8g0i5Bd_g-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-513297a755dso5396368e87.0
        for <dm-devel@lists.linux.dev>; Mon, 04 Mar 2024 02:37:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709548659; x=1710153459;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PWaJIR7zP8MNHpeZwLeMMOO0hOo/kagxoZ9mccSSbv0=;
        b=gXs22ehy25d5a0w5Tl+8ORVNFMyHkWAu9Pgpy1hpLnqusOVFtYsS5UQA9ypkSxzuzr
         usndBmPu7C3VdrETBZ+RLu+PeFAhjMtZOWdqKDOj0CKsNCVS13HKr5DZC897Z1pxtKJ/
         0peu59tRzAw7MsRdt7M4r6ZA79s1nXvs2vfv7wEYhQw/5MlNr9Nmj/L8elWgoxevMB+J
         rC9fKtsyiqq7NjKwy0m3dhm/6gA5MW+lNaFlOuriAiMYcRSic5b1sOzkQPGvKcItd/bW
         AvzGfuNpIgB6JW5/HA7ck6Ttzec+88y3kpwhRk2IK3jzW35fGYrZIGRUKMlQn30utI1R
         FawQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+r1aAvhshjnR2NxeG31k0Z1mHtXhqQ5P7k0JG6BSeWzIViE7+70dpYDEM8UA0kf1gHXuBa1zBnKrLWB/Yh/nd50e1372jKlI=
X-Gm-Message-State: AOJu0YyYpwWVAap70UH2cOwC6UY9TtMWUmhP5ypj5chr1arPBYOoWids
	UkkyY1PAWZ9t2sBk1BR2s4iZ38qD0GY6RY8bPMQq+1ZCCgFx6n3BFopIWjVXoVsIgI2xIoioGno
	IU5JR1IxlI7TCTdgW+alqOQwkjPAO2NDywXtYyt8TUonVFPabVxZvubaj
X-Received: by 2002:a05:6512:716:b0:513:1385:c943 with SMTP id b22-20020a056512071600b005131385c943mr5227342lfs.40.1709548659667;
        Mon, 04 Mar 2024 02:37:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF4URscpT4sDRGcAzKIteGbYa/hP3Z6y8djyt5sluy0hByZTqKG8L8Nh2sQnNe9sJo/peJV0Q==
X-Received: by 2002:a05:6512:716:b0:513:1385:c943 with SMTP id b22-20020a056512071600b005131385c943mr5227330lfs.40.1709548659274;
        Mon, 04 Mar 2024 02:37:39 -0800 (PST)
Received: from [10.43.17.192] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t15-20020a05600c128f00b0041290cd9483sm16740581wmd.28.2024.03.04.02.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 02:37:38 -0800 (PST)
Message-ID: <f82c786b-4b8e-4e5a-a049-bd4cfba668bd@redhat.com>
Date: Mon, 4 Mar 2024 11:37:38 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/7] 13-dm-disk.rules: import ID_FS_TYPE
To: Martin Wilck <martin.wilck@suse.com>, Zdenek Kabelac
 <zkabelac@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev, dm-devel@lists.linux.dev,
 Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>
References: <20240301224011.11117-1-mwilck@suse.com>
 <20240301224011.11117-2-mwilck@suse.com>
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
In-Reply-To: <20240301224011.11117-2-mwilck@suse.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/24 23:40, Martin Wilck wrote:
> ID_FS_TYPE is the most important udev property for most follow-up
> rules. It must be imported from the udev db if blkid can't be run.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  udev/13-dm-disk.rules.in | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/udev/13-dm-disk.rules.in b/udev/13-dm-disk.rules.in
> index dca00bc..eaad972 100644
> --- a/udev/13-dm-disk.rules.in
> +++ b/udev/13-dm-disk.rules.in
> @@ -26,6 +26,7 @@ ENV{DM_NOSCAN}=="1", GOTO="dm_watch"
>  GOTO="dm_link"
>  
>  LABEL="dm_import"
> +IMPORT{db}="ID_FS_TYPE"
>  IMPORT{db}="ID_FS_USAGE"
>  IMPORT{db}="ID_FS_UUID_ENC"
>  IMPORT{db}="ID_FS_LABEL_ENC"

I think this one was left out deliberately. The original intention was
to import only the minimal set of "blkid" variables needed to properly
keep the symlinks based on these values in place (patch 94f77a4). And
the "ID_FS_TYPE" is not actually needed for this.

Though, importing even the "ID_FS_TYPE" together with other blkid
variables should not be an issue because this "import from previous
state" happens only if we have DM_SUSPENDED or DM_NOSCAN set for current
event, in which case any other rules should be also disabled with
DM_UDEV_DISABLE_OTHER_RULES_FLAG="1".

So even if some other rule fires based on ID_FS_TYPE value, the
DM_UDEV_DISABLE_OTHER_RULES_FLAG should stop it anyway.

Then, the question is whether we really need to 'IMPORT{db}="ID_FS_TYPE'?

-- 
Peter

