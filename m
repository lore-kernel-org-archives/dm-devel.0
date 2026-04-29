Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705173B19A6
	for <dm-devel@lists.linux.dev>; Wed, 29 Apr 2026 18:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777488760; cv=none; b=PZjT8lwsV30U0iolEi8qxSbVHePdZdr2QPRfZeh9LVJjeLYBkfLOB5eOvmhkuK4mMKBx5FeZhe0twuVyOf9928JMdsxCz3LUHj2s2Ffj53QA1+Sil9YckkrZpVMo7gCcjtsNJa69gBbTJ+ELx8YhAv5/dv5EHGRBvoXuUvAp7hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777488760; c=relaxed/simple;
	bh=WoAoZrh6qUP+h0bIpQuDz67mdMrJv6QRorvDpMmdD08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WlqcnUcYajLZ3+nhZjTKZHV/SFGOzXsbvjfOyM4UYBUF3mUrpFIeMKacFXquvD3WxH0k811/J737bmxUR781Cfi0ZRMMPP57CdHfGVfD0Jg5lxW7tg5YhA8GaEkrEIbDpbX/uK59OWZ8G9O3Md+jrfKfDvXY7JfQ+phSMJujy6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Swj5lOXz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Swj5lOXz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777488757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jhdPtC7h7TlVuFzdU/5OKrtMzdGmH9Cdjx+jymjl8pc=;
	b=Swj5lOXzsxBU5aXo0rH/53UHqIJqLqP4VYCRnFzmY4MQINVnLfYN6lVKjSrHf/waUhsZrA
	KhvgeLOBFW5tRifAtz0RJfNv+G1McFcVyqrTvv2DXug3zZO2avq9ja/NdtTkfVDiQb8wjz
	RjXyECarR3cQBv14fYePMXHW/Gyt1vc=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-0RrrsvknPYCn4dLVmc7UQQ-1; Wed, 29 Apr 2026 14:52:35 -0400
X-MC-Unique: 0RrrsvknPYCn4dLVmc7UQQ-1
X-Mimecast-MFC-AGG-ID: 0RrrsvknPYCn4dLVmc7UQQ_1777488755
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8d5b5d607d1so20010885a.3
        for <dm-devel@lists.linux.dev>; Wed, 29 Apr 2026 11:52:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777488755; x=1778093555;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jhdPtC7h7TlVuFzdU/5OKrtMzdGmH9Cdjx+jymjl8pc=;
        b=epe1yvyx399nZs/MtIa4oVLShx/itmUpMka8bqPOBWzOHHBhFZII/L627TaWdBFQNK
         jDuploVKZU7jkQG+ZH5aNoImtJ8BrnefQhoFR+q/I1fXCLheCt9x9e2Qron7V0ybPDtR
         wCPsfGVgzFiDk8Eq0VXLFu7C9MCdB7vTmdgNSaOko7Cm4WdvJImWTs14SIoohh5ccWWu
         m55YQeCuA57Eg2E3WirNMcEyIHlkSbREFiMoZXAPEwZHSWDHqjZD+FrsV9NkRzeuWTyZ
         bYNlVxyA8yUZ6T/1aAGO1WGo1X1t/jQim8Y/rzt+m+09gU7YZTIDE/zZgWEwJcvC6B5W
         M0WQ==
X-Gm-Message-State: AOJu0Yy+JPhngkRrjvNCYmoh8c8Pc8PYtdn1S9Z+Xd8dTxJLSqVuNdHE
	aXjTmN6+DaZ9FKHQpEXndttS43iuIosIZ97xkaa+dJCsfWNLB4V8yk/cMySN6MB1S/0ntB3gkdj
	cMu24oVEcid4DdcsMcEOOQ46YBWZzReDvx+WK7wR3g55NvBlyI82m92Gt09Z9b0Y6opXt
X-Gm-Gg: AeBDiesBwRFPgfADdY/W113/Lxt2UjGqjHSvBFIMD3ByU/GdycLD/FqrCXnzHWbqDV1
	jyiNroYTNrbT2wqWBkG4/vuWIrYc1gaAdRA/xL5mj+mcWDpUQ3PdQHdSwmEHIVqFjXP7dxRDw7o
	HhCR68hlHj3ifmgPyOIW+7tAnnL2TBj22MuN/ojctCkmbsE39h+0nLkibGEsZDiL8tyJspE0sch
	7nNPevvz4HYOJiorPjREe7wv0lAuFXJg9fpgpv9BoVS5cDCmVVkaCBFiLyy7N7Mx50bpuqTdz63
	oUcv3AXoXKswE06inW3EfG2QIV5xPCGbpYFWHVGEAuxvsTkroXPc/QimpO/xUYa+58RVydkwyBu
	6ooOdpu9qNdywcENHXfV6fPhversz8HXRSn7zfejgdHCnH0NIeNjnriGt85rqP/UIz9Bwg1DF7L
	ubccyi
X-Received: by 2002:a05:620a:258d:b0:8cf:f215:24c6 with SMTP id af79cd13be357-8f7d7833fa5mr1157052785a.21.1777488754674;
        Wed, 29 Apr 2026 11:52:34 -0700 (PDT)
X-Received: by 2002:a05:620a:258d:b0:8cf:f215:24c6 with SMTP id af79cd13be357-8f7d7833fa5mr1157046785a.21.1777488753981;
        Wed, 29 Apr 2026 11:52:33 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:2500:540d:8da2:f197:6711? ([2600:4040:530f:2500:540d:8da2:f197:6711])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8f94005245csm276933385a.41.2026.04.29.11.52.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2026 11:52:33 -0700 (PDT)
Message-ID: <b3033f45-ec82-4c01-9234-5616bd9877b1@redhat.com>
Date: Wed, 29 Apr 2026 14:52:33 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm vdo: add optional Intel IAA-backed compression support
To: Mikulas Patocka <mpatocka@redhat.com>, "..." <439291857@qq.com>
Cc: dm-devel <dm-devel@lists.linux.dev>
References: <tencent_C10B5DDE03BCA1510BF6D23F384A4C120308@qq.com>
 <a986902e-014c-2df6-4e0d-de99a62f90f2@redhat.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <a986902e-014c-2df6-4e0d-de99a62f90f2@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1rX9or1fbwet7bzALpAHv0zvytcgVu9KaVzz5OvsDlk_1777488755
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/29/26 11:24 AM, Mikulas Patocka wrote:
> Hi
> 
> I think the best way how to support it would be to modify the VDO target
> to use the asynchronous compression API (so that it could use arbitrary
> algorithms). Then, the support for IAA could be plugged in easily with
> little or no extra code.

I agree that this is the right approach, but supporting arbitrary 
compression algorithms will require some significant changes on its own. 
dm-vdo currently has nowhere to store information about what algorithm 
is used for which blocks, so it would require reworking the metadata. 
(We would probably store the extra compression information in the 
compression block header.) This metadata rework in turn will require 
some effort to make sure we can continue to support existing users who 
will want to continue to use dm-vdo volumes in the current format.

I have a branch lying around that has done some of this work already. I 
set it aside because there didn't seem to be much interest in it and it 
is fairly complex, but it could certainly be brought back if it would be 
helpful to someone.

> It is not good to have branches like "if (iaa_enabled) ... else ...;",
> because that would just blow into unmaintainable bunch of code when other
> accelerators (maybe s390x?) would be added.
> 
> Also, it would be good (to ease reviewing), to split the patch into
> several smaller patches.
> 
> Mikulas
> 
> 
> On Wed, 29 Apr 2026, ... wrote:
> 
>>
>> Hello,
>>
>> I am following up here after an earlier reply suggested that Linux dm-vdo changes should be discussed on the device-mapper mailing list rather than as a GitHub PR.
>>
>>   Intel IAA, the In-Memory Analytics Accelerator, is a built-in accelerator in recent Intel Xeon processors. One of its main uses is offloading compression and decompression
>> work from CPU cores. This is relevant to dm-vdo because VDO already spends CPU time in the compressed write and read paths, and the kernel already exposes IAA compression
>> through the crypto API as the deflate-iaa algorithm. The existing IAA crypto driver documentation (dm-linux/Documentation/driver-api/crypto/iaa/iaa-crypto.rst) also describes
>> zswap as one consumer of this interface, so my prototype tries the same general model for dm-vdo.
>>
>> Before changing dm-vdo, I compared the current LZ4 path with IAA on a set of single-thread compression tests. For compression, IAA hardware was faster than LZ4 on most tested
>> datasets, withthe measured compression time often reduced by about 1.3x to 3.5x compared with LZ4. The compression ratio was also generally comparable to or better than LZ4,
>> because the IAA path uses DEFLATE rather than LZ4. Decompression was more mixed: IAA hardware was close to LZ4 or faster on some datasets, but slower on others.

One reason I set the compression work aside is that it's not clear 
there's any performance benefits to using a different compression 
algorithm in dm-vdo (either for device throughput or for data 
efficiency). But raw comparisons of different algorithms don't 
necessarily translate into gains for dm-vdo. It's a lot of work to go 
through if it turns out that there's no benefit that users can see.

You don't provide a lot of details on how you did the benchmarking you 
show here (in particular, it's not clear how much compression is 
available in your test data). But results you show don't seem to show 
much of a difference, which raises the question of why do this at all?

>> [IMAGE]
>> Please see figure1 in the attachments.
>>
>> The prototype is in:
>>
>>    https://github.com/dm-vdo/dm-linux/pull/96
>>
>> It contains two commits:
>>
>>    dm vdo: add minimal IAA compression support
>>
>>    dm vdo: preserve compressed block format for IAA
>>
>> The change is intentionally narrow and only touches the dm-vdo compression and
>>
>> decompression path under `drivers/md/dm-vdo/`.The design is as shown in the figure below:
>>
>> [IMAGE]
>>
>> Please see figure2 in the attachments.
>>
>> The current result is:
>>
>> 1. dm-vdo gets an optional iaa_enabled module parameter.
>>
>> 2. On writes, compress_data_vio() first tries deflate-iaa through the async compression crypto API. If IAA is disabled, unavailable, or the IAA compression attempt fails, it
>> falls back to the existing LZ4 path.
>>
>> 3. On reads, uncompress_data_vio() can decode data produced by the IAA path. It tries IAA-assisted DEFLATE first, then software zlib inflate, and then the existing LZ4 path.
>>
>> 4. The prototype preserves the existing compressed block format. I did not add a new on-disk compressor field in this version.
>>
>> 5. Data written through the IAA path is not dependent on IAA hardware being present later, because it can still be decoded by the software DEFLATE fallback.
>>
>> In local testing, the prototype was able to write and read IAA-compressed VDO data correctly, including the software fallback case when IAA was not used for the read. The
>> performance is as shown in the figure below. As can be seen, the performance remains largely consistent with the original after adding IAA.
>>
>> Write path：
>>
>> Command: dd if=../mnt_ori/SRR.fastq of=./SSR.fastq bs=1M oflag=direct
>>
>> IAA: 6430986673 bytes (6.4 GB, 6.0 GiB) copied, 4.98476 s, 1.3
>> GB/s
>>
>> LZ4: 6430986673 bytes (6.4 GB, 6.0 GiB) copied, 4.91684 s, 1.3 GB/s
>>
>> Read path:
>>
>> [IMAGE]
>>
>> Please see figure3 in the attachments.
>>
>> The reason I think this may be worth discussing is that IAA gives dm-vdo a way to offload compression work on systems that already have the accelerator, while keeping the
>> existing LZ4 path as the compatibility and fallback path. The goal of this RFC is not to propose a final format or policy yet, but to check whether this direction is acceptable
>> before I spend more time preparing a proper patch series.
>>
>> I would appreciate feedback on whether using the existing kernel IAA crypto API from dm-vdo is a reasonable direction, and whether preserving the current compressed block
>> format is acceptable for an initial RFC.
>>
>>   
>>
>> Best regards,
>>
>>
>>
>>

This is a minor point perhaps, but you didn't sign a name to this 
message. My understanding is that kernel contributions should be 
attributable to real people using their real names. Please keep that in 
mind for the future.

Matt Sakai

