Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6A161FF2
	for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 02:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737513835; cv=none; b=h1Wlw5o7KirhDfuQRJDKegwVGeHbtXS6hZCqJXdXCiUOpbuy/ns72eREMJLUJOB6/Br21LnS+b/AiAYwsylk3g6lLamzDkYXIsiDpRadpPetnsrzx4aGzjzKk8v2+Zk0nrEomWikRZo18AeR8hc3QkqHWrnZZ70wUOgcs05Qee4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737513835; c=relaxed/simple;
	bh=01mKjFHF18UT9Rh1TtcBb41c9vc0Dej/Q3GoDP1jljw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LS8+Zwv/o5kyzNLeT4nooegMpbYFSplw5GPVGLPApIJNS347EZusybJG7fOCb8y/KyVUxBHweTB1O8a8N2TsVaJaJLsekjrjFgPanQwIqYJXTcHN7msE9HooIuBrD3MZeQ4gHsTuiIKPh2Xpavyhja3PTiWgWYp5AUsUtKBxxjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LusLwOWA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LusLwOWA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737513832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2hFa7R+wvEYsT2w4qdWiDE4fb5Y1478tOuJnTA1MlOM=;
	b=LusLwOWAacTC90TE0+2YwmvLb/hWWyAo9feoBq/w6XPbrc+rJyDkOrDFZG5ixlWTA42vGm
	mvrpKZDu0eazf3xy5J+xfA4GLEWn3uAOA2CVfNQyUG9QHzEGYeyU28ui+q9/hIaO3ymoUU
	Ixc/yjGwZfHsSb4pBHYVJdx2zkaMFPE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-6iFtdKvONBi8wAg4RNSrEw-1; Tue, 21 Jan 2025 21:43:51 -0500
X-MC-Unique: 6iFtdKvONBi8wAg4RNSrEw-1
X-Mimecast-MFC-AGG-ID: 6iFtdKvONBi8wAg4RNSrEw
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7b6e1b037d5so940711485a.0
        for <dm-devel@lists.linux.dev>; Tue, 21 Jan 2025 18:43:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737513830; x=1738118630;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2hFa7R+wvEYsT2w4qdWiDE4fb5Y1478tOuJnTA1MlOM=;
        b=cxp69IJxiywxsDo3p+tOgb+pEYtvPAHthm6X5Rph9I3ObOeavkeeQPqdgMk3xpnRVQ
         399LnGaH/YzRDzxx0wa5biwagmxvKf7LXxNqNJrWB4no++BV8JB6M2UGO6kPM3w/arhG
         VH9/1Mlh7nVa6ilCAkV748fVknA5mEwwI2b3HIzMAMOi0jiz8ImrXkgPlDxFy3nirase
         bFcyR+7Z06oQUpohHF0U7JUdGktTBX4lsZwvn+4XFcHbAvBVNXTi/fwsM/Q7HY8LY0WV
         JzlCHGr3uqA0Hj5dBkgLQ3FR0bza3yjdfdppvzFtggi/yvu4aPLU259oiHdKWucBaTnZ
         6ZHw==
X-Gm-Message-State: AOJu0YzTD9RWAU0RP5mjjzG4a5ZFQq5QbKLTKl5JgLNiX4FDfftLV7d9
	yPD6pQTEqXTkjNTshjMJdhH6Y5oFz3cWS9UvG4tT7SHHfiOU26HBEsbl4tDYpZRwC/cIYFIFcQd
	pidfzWHzUs3VdjR40ntaIrFIPnfhXlsnyuyo4I5cj2k/F2dJVIbaTQIUduO02jFiE
X-Gm-Gg: ASbGncsJs7TJeu/jjfB7KHUAf+Nifa4EAZpqwM/DvKNchERkW+MUssTOiPj/zxRYXbE
	bIFtHx60azr64PXkot7+OTf2EAmlFXM18EFkrdmLcOZcYlqYyIyK0rZ/bzWfzjNxuz29Mh5L3G/
	lwk7e53D/9foD3x0Sdt61gLnJ/G4FMRynDa+i2tFJm71tsr4o3dm7Nub5Qw79Wwi1JyFnVcjxnD
	gISqn2jpIur8315NBfnPzZP81t62zLiVvl6Ze3cMH1FzbykkUKFuRIEetKEf+I6rMWxJwI=
X-Received: by 2002:a05:620a:1990:b0:7b6:785e:ce1a with SMTP id af79cd13be357-7be6321992dmr3095796885a.4.1737513830622;
        Tue, 21 Jan 2025 18:43:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG9rKmTSRQsm3GcTGtCNeLGIi+m0Nj830Xx0y7tNlnqs1NO4nLWgQPcfj5gZcSsL8zIMbzelw==
X-Received: by 2002:a05:620a:1990:b0:7b6:785e:ce1a with SMTP id af79cd13be357-7be6321992dmr3095795385a.4.1737513830316;
        Tue, 21 Jan 2025 18:43:50 -0800 (PST)
Received: from [192.168.1.165] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be614ef182sm615352385a.95.2025.01.21.18.43.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 18:43:49 -0800 (PST)
Message-ID: <10412737-d8b9-410f-8d59-ac3126d96cc2@redhat.com>
Date: Tue, 21 Jan 2025 21:43:49 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm vdo: Fix W=1 allmodconfig build error
To: John Garry <john.g.garry@oracle.com>
Cc: dm-devel@lists.linux.dev
References: <20250106141731.1341034-1-john.g.garry@oracle.com>
 <1d3beb46-c244-4ecf-8bd6-1895954c8e4d@redhat.com>
 <a9b32c24-f380-4a0b-a59f-16e2e87a833b@oracle.com>
 <d0742bb0-bd51-4338-97a2-6454d806de90@redhat.com>
 <be0b975b-232a-4fea-a1b8-85755b81eb74@oracle.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <be0b975b-232a-4fea-a1b8-85755b81eb74@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DgEWK8I7zBniJhEVLE8YkTt5p-YFArIJkA3lPFioPoQ_1737513830
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

It took longer than I had hoped, but the patch I just sent should fix 
the warning as well as simplifying the thread names.

On 1/9/25 10:20 AM, John Garry wrote:
> On 08/01/2025 22:44, Matthew Sakai wrote:
>>> BTW, as I understand, for CONFIG_DM_VDO=m, the module name is 
>>> "dm_vdo". So why different MODULE_NAME if MODULE is not defined ("dm- 
>>> vdo")?
>>
>> That is a historical artifact and it should just get removed. The 
>> module name should just be a constant string. I could write up a patch 
>> to do this if you don't want to.
> 
> Yes, please do when you get a chance.
> 
> Thanks
> 
>> It might take me a couple of days though because I'm still dealing 
>> with some holiday backlog.
>>
>> Even after we do this, I still think the prefix string should no 
>> longer rely on the module name.
> 

