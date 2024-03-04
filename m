Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366EA4E1AD
	for <dm-devel@lists.linux.dev>; Mon,  4 Mar 2024 15:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709567052; cv=none; b=ZzIy34vYwkN23wJjfUNXsfzQTZFvm/TCgMatVD0QvfH+/vuOp3ujh1C58Hqar2t2crGBxp0dAsKEskoJyMuvBbW582QGQFPI6/rCfGcXIcI16/2/F1Ry8cNVgadXwJsFzLk7VT/Owzvz5xoOAMhX1bFnHcRJU4OUp1xNKbhD3RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709567052; c=relaxed/simple;
	bh=K3Tbh/TUF22F4D3KDGEQCRwEcOmDShI3J5wZfknN3YM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j/zc0VgOGDrffDSlCvc4PPQi9j4UzFlRV/zL2s/vBDYZ3zrt7enetu8awyBcxlpNbinUM8wJ1QCB2fFBwl9fFzyByk5Gtl9g3Ao4K6W12IJJ45g9QYSzyYrcm8+bSQzkyhD9cT+fFzv94EJobvGmn+q6sx98ZXCr2ELmiU2j1Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZNP9GXZR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZNP9GXZR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709567050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7sJ7CmU0c5upUT3OMZqX4LQ9Z9l8nDHTecyV/ztXYc4=;
	b=ZNP9GXZRKtN+oQFMLlp01H+QXQjvXSf7BwwvZDcCfDGYeWIEuuqsf6vTMDk46xREz8U3qT
	zKjghl/ueYXnMcBlqxQfYfXfESg8FOEQnU2HadYpLFUq3DKM6iiYnbykkqPkyCLVcHRHip
	EhQ28WCFo0Sj5+ADK+pe9W9+/HFqvIs=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-EC76ssEeNWSybRrzlFp2wg-1; Mon, 04 Mar 2024 10:44:08 -0500
X-MC-Unique: EC76ssEeNWSybRrzlFp2wg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a44143c8908so432184466b.1
        for <dm-devel@lists.linux.dev>; Mon, 04 Mar 2024 07:44:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709567047; x=1710171847;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7sJ7CmU0c5upUT3OMZqX4LQ9Z9l8nDHTecyV/ztXYc4=;
        b=C4QYmbPh95s2ixZDgLD+ZMOU1Dp94kq7SmNAEZHubs1Pb7QgBDQHWdfj1fkcoPTGHm
         U5gTHwOE/k+cREkSIE/abmkzOQ/40Nkriv+VWO/I85I7nCk+JEgo5bYMWn7g7L+lVGsL
         ea5pMCSAiWcnNN+xnvlmPLXXi0/lUsd6iDY4dQfIHRkMMUOXBqh2w/lGAVd5ixLB8zdr
         0HuDeTlrET9wtRru+tSikNNRcU4dxJUxGjZKfKnmeBN5wPS+xJ9wa+y/kwmkoQ3Limif
         WmFJRqoFMxgZT6cwcpMsJ6Wyo5V/o+nfGuWFHrMpbIgRrv0kMudkVKaxDNwF+XgGCILr
         rI/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWuZdm3lq88jVdTKXXTEe5Mn9BhoMQFBDdTlvILanogadhCHj3ijuGfQ+NkFaCS3Uxffhg5Bl1T15WFVnjnuzOZ+ec+RMmeye8=
X-Gm-Message-State: AOJu0Yw0uepIRq1qQPgpcZXHqdYUGuMtJLQhYmTF5OITC20VEYY0rbDc
	VMaMcgQGYY5syjfmjjH/GSoo1qYo8JV2KYxDpCEcIbQWNUad++ImXm/ma+t3+ygQboCal4CBI5e
	1qUZPCFeKgko5kqH6tgfOXFJPf+EMZcM+MhvZZNKPwnqiqrFebHHoD14m
X-Received: by 2002:a17:906:cb90:b0:a44:cd4:95e0 with SMTP id mf16-20020a170906cb9000b00a440cd495e0mr8117883ejb.1.1709567047576;
        Mon, 04 Mar 2024 07:44:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEvVpqs3CLx3PtZkuyU42nlFsp8MbNjT/u7WEoalcgWFprQleGffEDh+7XfMniINjeywzCBSw==
X-Received: by 2002:a17:906:cb90:b0:a44:cd4:95e0 with SMTP id mf16-20020a170906cb9000b00a440cd495e0mr8117860ejb.1.1709567047188;
        Mon, 04 Mar 2024 07:44:07 -0800 (PST)
Received: from [192.168.0.8] ([85.13.73.241])
        by smtp.gmail.com with ESMTPSA id f11-20020a170906048b00b00a4380e85e5csm4935000eja.202.2024.03.04.07.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 07:44:06 -0800 (PST)
Message-ID: <bf15203b-16ec-4296-a642-2e5ae25975ba@redhat.com>
Date: Mon, 4 Mar 2024 16:44:04 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/7] 13-dm-disk.rules: import ID_FS_TYPE
To: Martin Wilck <mwilck@suse.com>, Zdenek Kabelac <zkabelac@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev, dm-devel@lists.linux.dev,
 Hannes Reinecke <hare@suse.de>
References: <20240301224011.11117-1-mwilck@suse.com>
 <20240301224011.11117-2-mwilck@suse.com>
 <f82c786b-4b8e-4e5a-a049-bd4cfba668bd@redhat.com>
 <2148e09214fd1d33d9eeadcf763c710eb739b46e.camel@suse.com>
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
In-Reply-To: <2148e09214fd1d33d9eeadcf763c710eb739b46e.camel@suse.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/4/24 16:17, Martin Wilck wrote:
> On Mon, 2024-03-04 at 11:37 +0100, Peter Rajnoha wrote:
>> On 3/1/24 23:40, Martin Wilck wrote:
>>> ID_FS_TYPE is the most important udev property for most follow-up
>>> rules. It must be imported from the udev db if blkid can't be run.
>>>
>>> Signed-off-by: Martin Wilck <mwilck@suse.com>
>>> ---
>>>  udev/13-dm-disk.rules.in | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/udev/13-dm-disk.rules.in b/udev/13-dm-disk.rules.in
>>> index dca00bc..eaad972 100644
>>> --- a/udev/13-dm-disk.rules.in
>>> +++ b/udev/13-dm-disk.rules.in
>>> @@ -26,6 +26,7 @@ ENV{DM_NOSCAN}=="1", GOTO="dm_watch"
>>>  GOTO="dm_link"
>>>  
>>>  LABEL="dm_import"
>>> +IMPORT{db}="ID_FS_TYPE"
>>>  IMPORT{db}="ID_FS_USAGE"
>>>  IMPORT{db}="ID_FS_UUID_ENC"
>>>  IMPORT{db}="ID_FS_LABEL_ENC"
>>
>> I think this one was left out deliberately. The original intention
>> was
>> to import only the minimal set of "blkid" variables needed to
>> properly
>> keep the symlinks based on these values in place (patch 94f77a4). And
>> the "ID_FS_TYPE" is not actually needed for this.
> 
> Why would we want to maintain the symlinks, but not other properties?
> ID_FS_TYPE is the blkid property with the highest number of consumers
> in a standard rule set. It is interpreted by most rule sets which build
> additional layers on top of dm devices.
> 
>> Though, importing even the "ID_FS_TYPE" together with other blkid
>> variables should not be an issue because this "import from previous
>> state" happens only if we have DM_SUSPENDED or DM_NOSCAN set for
>> current
>> event, in which case any other rules should be also disabled with
>> DM_UDEV_DISABLE_OTHER_RULES_FLAG="1".
>>
>> So even if some other rule fires based on ID_FS_TYPE value, the
>> DM_UDEV_DISABLE_OTHER_RULES_FLAG should stop it anyway.
> 
> Exactly.
> 
>> Then, the question is whether we really need to
>> 'IMPORT{db}="ID_FS_TYPE'?
> 
> I believe the question to ask rather "why should we not?". What harm do
> you think could be done by importing ID_FS_TYPE from the db?
> 
> If we don't import ID_FS_TYPE, a later rule set could justly assume
> that the fstype had changed, and in the worst case, might even take
> some destructive action in response. AFAICS no rule set currently does,
> but there's no guarantee for that. We should provide the follow-up
> rules as much information as we can about the device, and if a device
> is suspended, or the NOSCAN flag is set, there is no reason to assume
> that the device has changed it fstype, or is about to change it.
> 

I agree.

The only issue I can identify here is that someone may fire its rule
based on the ID_FS_TYPE existence, but that would also mean they are
ignoring the DM_UDEV_DISABLE_OTHER_RULES_FLAG, which is much bigger
issue. I was just curious whether it makes sense in that case to import
it if nobody is reading it, but it's true some rule can still compare
previous and current state of ID_FS_TYPE and then act on a state change.
So yes, better to have that in.

-- 
Peter

