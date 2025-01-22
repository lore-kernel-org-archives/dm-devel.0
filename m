Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACE621518B
	for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 18:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737572209; cv=none; b=kMONfHgLdOYjL7m7z/GgKF1w5Zbk/u3uBUCN7aSWwuibxh3WKQxzeMPv+naLWYn+NADnkQP+274idgNOE+0XUEpYWRnXTgT0hxuLXY3ASAtY2QRxox6Q9kFYEFupfrcnZbiCAog42DWSrjxf2nb/XmQZQ5DtuyX0pTzHiDJjJPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737572209; c=relaxed/simple;
	bh=ZHsfcotq7wnbdIVRos6QfNAL9ztbElxGmFlP/QgdHVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V0/HBHSjphQXecq0x55kXX0ZzhZxQuQpMks/TrzDkHB15rmkdcUOeXeoInovfb6n9Utz3DVRBRucvZ4qhhGx6JWPViVwILdk9/h+J6GZEmTv56z2fdMF5BqnlrqsiahYtfSVzEmqtqY89rpkwyi+ViMrXqtk0yDnM+dL6f5G30k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ci27ML5u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ci27ML5u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737572206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SyGfCFLjsawOSJk2tFFVE6vz2VXdUheIwf5+i/3wPgA=;
	b=Ci27ML5u5TJCC5FC4dWKpTZgV0N1hZvv8bMyFDKmBDUy1AjFfn9V4A324pliskisk+IAFK
	vaZWIStUW7TyPTPFx5gqiHAgcINDJQisqABvKt6XPjaoFU9O6w10By7BETzPGtB+FVfXkg
	l9H3TxhQ3vL4zMZkp3jtQwWG/y3uN4M=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-JVV-UkxxOBOw64Sj0Co21A-1; Wed, 22 Jan 2025 13:56:45 -0500
X-MC-Unique: JVV-UkxxOBOw64Sj0Co21A-1
X-Mimecast-MFC-AGG-ID: JVV-UkxxOBOw64Sj0Co21A
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6d889fd0fd6so3784986d6.0
        for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 10:56:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737572204; x=1738177004;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SyGfCFLjsawOSJk2tFFVE6vz2VXdUheIwf5+i/3wPgA=;
        b=Y83MP0t3Z/eUigIQkQRgNzsiJX4sCHbT69WuUXlValxtsvaPQa/xMWcrJ1K/VQoWoM
         4g2+aDNLqHta/89JNzjxr5WaE9XZyf0crO5AvpUn2CdAGtifD7C/F3ooddxdJQO0H5kl
         l3WB0J5lIs6RTWd6gh9K/bIuTrBpkJWKVDvRN1FPIP6J/K2tmdOHaaZCr3j8eTYpQuEG
         DJUKvRf1cUk4Etq0ovnrqv8Vb0klvA0zm2wdL4B7+YTcW8KRl9W/nRZB6L8TbHCeTzb/
         jjA1vRZ3YCc24eb9qJcP/CPqeCcm3V/gbY86kaQEmuoRvgQmm3uHklpKI3BxRdYdS6Mz
         0+Vg==
X-Gm-Message-State: AOJu0Yx2ZBZWI7rLJGYAqDmoHQchHLLZxLRAI2RT+B4EGPvaA3nUvVxR
	32l27G8sokdTa+yz9X2OzWMY11bzTtpJGvIDd3/3CgBsgZGPxAJvMbfTAciXgMD600r2NesoLrx
	KsLtbDS8IkOlhyvlLUGON7OR/MZ+WSZHxE1/GQThuGS4VBSCp0l0mSPW/
X-Gm-Gg: ASbGncsXQuecdB4yDhS3Ub5ZrfJTn38UY8VlNCWx0E2s1qTrvBwQPiBJ70GkbN7oSU/
	qnlR1BLEzCzj92hg8BfZOXWQ9yWCB4G/2i3gNSW+4yIYLCG0tw5zFvgYnm7z81HRThcB9TBjhYi
	qnGJ5pYKO5ykC03uFz4UCxg5wvocQOPdq4tkQqQjYdDVNp7JLaPmRmlYm1yNR9G/1NlesZn7KHW
	PGg7o1SvSRd+yXWSOpDPORsfqrP6LgPGk1cfdnG8o+za9PWT7TYxhnYfBVZW7tJsUagAEI=
X-Received: by 2002:a05:6214:262f:b0:6e1:e90:b777 with SMTP id 6a1803df08f44-6e1f9f927c8mr7636066d6.3.1737572204499;
        Wed, 22 Jan 2025 10:56:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG3Xnlw9mCpuR2vOZMvydD+JwOK2MFV9nJQNFa+BNzjyKLj5IzYInZHHAku1jZC7hC2t75Jew==
X-Received: by 2002:a05:6214:262f:b0:6e1:e90:b777 with SMTP id 6a1803df08f44-6e1f9f927c8mr7635816d6.3.1737572204214;
        Wed, 22 Jan 2025 10:56:44 -0800 (PST)
Received: from [192.168.1.165] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e1bf056fb8sm49513376d6.34.2025.01.22.10.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 10:56:43 -0800 (PST)
Message-ID: <996fa43a-4255-48ba-9eeb-eea518d9c407@redhat.com>
Date: Wed, 22 Jan 2025 13:56:43 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Adding zstd to VDO
To: Anton Gavriliuk <antosha20xx@gmail.com>
Cc: dm-devel@lists.linux.dev
References: <CAAiJnjoGn4Jn6O-SWAaAzwNk4DhEiCFUA0Q0X2RLdrHH7NR5qg@mail.gmail.com>
 <2f847044-fef9-4cfd-95c6-038c07468e0d@redhat.com>
 <CAAiJnjpdDU9rVLag0mFTy1iYb+aPFVq+QaBMjEn4cq1fp4YbbA@mail.gmail.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <CAAiJnjpdDU9rVLag0mFTy1iYb+aPFVq+QaBMjEn4cq1fp4YbbA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _Xxzj22YgNro_-aUCHxA3XUtUNdF0Q2IHr1wMNri7rU_1737572204
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 1/22/25 4:35 AM, Anton Gavriliuk wrote:
> For storage server solutions space saving is very useful, both
> compression and deduplication are important.  Deduplication is just a
> part of the story.
> 
> What if the compression algorithm (lz4 or zstd) could be selected per
> device basis with default lz4 ?
> 
> It also may not be a bad idea to add compression levels from --fast to --best.
> 
> Combining above, users could select different algorithms (lz4, zstd),
> different compression ratios and speed for each device.
> 
> For instance - there are 2 volumes, one with hot data and lz4, another
> with cold data with zstd, but both volumes with deduplication.
> 
>> Switching algorithms after data has been written to the volume could make older compressed data unreadable, so we don't want to allow that.
> 
> Yes, there must be a warning, that after selecting the algorithm there
> is no turning back.
> 
> An example - nearly a year ago, HPE's software defined storage
> solution - "Alletra MP" compression algorithm was switched to lz4 ->
> zstd.
> 
> If still keeps a single compression algorithm, zstd almost always
> looks better lz4 (probably except decompress speed)

We cannot remove support for lz4. There are existing users that rely on it.

I have no objection to adding more options, though. It's on our roadmap 
already, so perhaps we'll look into it. If you wanted to put together 
patches for adding this, we'd certainly take a look at them.

Matt

> Anton
> 
> ср, 22 янв. 2025 г. в 04:59, Matthew Sakai <msakai@redhat.com>:
>>
>> It's a reasonable idea. We've discussed it before but it hasn't been
>> particularly high priority. Since VDO is mainly focused on
>> deduplication, it's not clear how much it would help to use a different
>> compression algorithm, but it shouldn't hurt anything, either.
>>
>> To make this work we'd want to add a new create-time option to specify
>> the compression algorithm to use. Switching algorithms after data has
>> been written to the volume could make older compressed data unreadable,
>> so we don't want to allow that.
>>
>> Matt
>>
>> On 1/18/25 12:53 PM, Anton Gavriliuk wrote:
>>> What if zstd can be added to VDO as a compression algorithm along with lz4 ?
>>>
>>> It could provide more flexibility for users - faster compression or
>>> better compression ratio.
>>>
>>> Anton
>>>
>>
> 

