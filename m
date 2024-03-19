Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD458465
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 01:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710810850; cv=none; b=kn5v9AOEmydQKlROR0lC1T9J0jAhziOtR5VhkY28cr7XWT8jdhtb5D1MYvFV7ahXJvn1QDFbYG+SasUXeJaXJ7SMB3XSdzEcMEp7ogWN00f4xkDDHmiKnBhdYXBuh5+0hCczosCM2hu+EcgtWvKa78TvSzU9xCY2pOkGNPGr9n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710810850; c=relaxed/simple;
	bh=aKNtM1auXFf5e2SfSjWXHtQS/lxJHV0FCYpjLFlyrP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EPBfsjvkgmUAs+FS5Z0tMu/X50A0QGazLafYhoTcjUXuQ9pU1Lgpet6mFyyOUwXGdcvT/VyU2xfp5UOgJuuct5zpqrOVJir/9211OJXzYBgxdxR3wQLPbUvtQAJzTrfc2zm42KHkNecVyl86FKipAl4VYmy+w/EZQXo0rLQAye8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PQbogAaZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PQbogAaZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710810848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1+ki3M8LXsD9YdHWeoMgF7qk7wGMX3DA1a/BYmADzKU=;
	b=PQbogAaZplPVhxIueRj+u5C5/iVhrhsfEFT7BIJj6MVENwYu0ni35aMYPAhOlkQ1q97Atw
	Eng0aD8O1bRs9NnVzalmInbz3U5pSu0TFDv26YqXelponCm91xQ+r1Z+s5g94tj5DEr/Qc
	NHsosIDBugruf92mf0KVTWslQVnu12k=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-2ianEMyhMxeGiN6-QM9oTQ-1; Mon, 18 Mar 2024 21:14:06 -0400
X-MC-Unique: 2ianEMyhMxeGiN6-QM9oTQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-789ea18d175so383618985a.3
        for <dm-devel@lists.linux.dev>; Mon, 18 Mar 2024 18:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710810846; x=1711415646;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1+ki3M8LXsD9YdHWeoMgF7qk7wGMX3DA1a/BYmADzKU=;
        b=uV0cBn9SeXaau0NweL9QBfE8gfhEiizZZV12Jn+hHl1OK4NvYCD56ZrvX5C7qFCUpm
         5syZ12SDvXnjJ2IIXdTHIKL+bsyU3MaJUsm9rjveeS1GW82mFe11KkdOoja4tbZd8Dsx
         nSoTUznCtv7guYu3FbXMJMOtDlkISrSI83vcov6SHOpSDETLsTjSQyw67bsY0pIfopMX
         03wKIa6zUixlyOzUnd58BXgm70JG98sgwwCPhD1+x6WQkfOXvJofnHvpK0sH8t151jn7
         p0hEGdxAOWaRW6Unu67nzLm8KaWkWU2kjTH3PwvpSocKDyMrsyN+o1d56soZmP2Tel99
         fHMg==
X-Gm-Message-State: AOJu0YyO8CQiGwGh0FFkjt8tyfMvzGEeuWq50gbv5eACpDCUlWNoJ94Q
	ythTE7vChRy1L2H9pyBBmQ3Do1tlw4jjtkO7L1qpzOZkt0bR41klqD0gCxhGTkyvdQPXySrNfH2
	eQIC0E1kbnT7Wktv8gQ4F6AwudHBEEHGPopAxhtmbKs1ilEuEglK5fF86
X-Received: by 2002:a37:c40b:0:b0:788:7404:ae2d with SMTP id d11-20020a37c40b000000b007887404ae2dmr14022883qki.25.1710810846168;
        Mon, 18 Mar 2024 18:14:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWmXddF0iwYjeP4bycVdQMfzAK4D9WL3tJ0LdZ64qcKqDIxZFiH5WyRSavWENWDuEFzVytrw==
X-Received: by 2002:a37:c40b:0:b0:788:7404:ae2d with SMTP id d11-20020a37c40b000000b007887404ae2dmr14022873qki.25.1710810845902;
        Mon, 18 Mar 2024 18:14:05 -0700 (PDT)
Received: from [192.168.1.163] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id d14-20020a05620a204e00b00789e70d135dsm3468404qka.127.2024.03.18.18.14.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 18:14:05 -0700 (PDT)
Message-ID: <a8be4040-280f-4698-0cfe-d84c0c8bdf34@redhat.com>
Date: Mon, 18 Mar 2024 21:14:04 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v4 02/39] dm vdo: add the MurmurHash3 fast hashing
 algorithm
To: Guenter Roeck <linux@roeck-us.net>, Kenneth Raeburn <raeburn@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org
References: <20231026214136.1067410-1-msakai@redhat.com>
 <20231026214136.1067410-3-msakai@redhat.com>
 <ea57f231-f78e-4a55-bf85-c5d50e17237e@roeck-us.net>
 <CAK1Ur38jAmWo35HTNrDDAaN5Awiie9wRiPDMVrNUg6+ZM8mJ7A@mail.gmail.com>
 <28a88525-6b06-4215-9e78-2b3d8c0d8657@roeck-us.net>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <28a88525-6b06-4215-9e78-2b3d8c0d8657@roeck-us.net>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 3/18/24 16:54, Guenter Roeck wrote:
> On 3/18/24 13:37, Kenneth Raeburn wrote:
>> (resend because of accidental HTML lossage)
>>
>> On Thu, Mar 14, 2024 at 7:38 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>> On sparc64, with gcc 11.4, the above code results in:
>>>
>>> ERROR: modpost: "__bswapdi2" [drivers/md/dm-vdo/dm-vdo.ko] undefined!
>>>
>>> Guenter
>>
>> Thanks for catching that. I don't think our team has any sparc
>> machines readily available for testing.
>> This is an artifact of our having imported user-mode code to use in
>> the kernel. We should probably be using le64_to_cpup and friends, as
>> we do elsewhere, so it doesn't try to pull in libgcc support routines.
>>
> 
> I am kind of getting wary about reporting such issues. Should I drop
> building dm-vdo images for sparc ? Would it be possible to add
> "depends on BROKEN if SPARC" configuration option to indicate that
> the code isn't expected to be buildable on sparc, much less work ?

First off, sorry for the slow response. I was away for the last couple 
of days.

I would encourage you to report issues when you find them. 
Theoretically, VDO should work on sparc. However since we don't have 
that architecture readily available to us, we won't know what to fix 
unless it gets reported.

In this case, we really shouldn't be relying on these libgcc builtins 
anyway. I hope to have a patch in a couple of days that you can try out. 
If it turns out there are more extensive issues with VDO on sparc, I am 
open to disabling the config, but I hope it won't come to that.

Matt

