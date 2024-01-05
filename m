Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA011FA3
	for <dm-devel@lists.linux.dev>; Fri,  5 Jan 2024 02:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WUG9JnOf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704420430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lMGOHMlQn73qNOF/qWGEazbtvfPKt25xMIaGXiZYr3g=;
	b=WUG9JnOfxII79uOhxkPMUbpnp/LbpDn7kOR1yU5H1sG7FYjxfB/uh3EwPo8Hrjk5EYl37m
	3GKcRYv5BwE393Np/RErX1zjdVwUjsNZ0UZOvlLrkPpzObZw6blUm8O7w6K9Q0y+3jnwfG
	0u7CdYqHgOW/OH/p0zPnQowmvIDKIQM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-m0cK4Dk_PlmOsoHNm5gyFg-1; Thu, 04 Jan 2024 21:07:09 -0500
X-MC-Unique: m0cK4Dk_PlmOsoHNm5gyFg-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6800aa45af1so15698666d6.3
        for <dm-devel@lists.linux.dev>; Thu, 04 Jan 2024 18:07:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704420429; x=1705025229;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lMGOHMlQn73qNOF/qWGEazbtvfPKt25xMIaGXiZYr3g=;
        b=AFWywD+sLynzTO8/jlRDaw94AmDv9hKbXGtzjrBknXSvnEm4EkRZSesWBCG8ZqXRvj
         MDYUj8jLb1klBP32Uy/N/QpPlOCG1Q42PHmca3S92gpKpjTwboKscfgtk3jhhTpFKV8M
         lpLRem1mo0vmBR+QbpXyUFxrghu+W5jrI/SECHI/caizRoXnH5L9Qtnpa6jKs9NJjmuP
         0vAlTuOimWtESlOzQrBcaoyJJSpoV2FspGvPKwRzUiNtCBJpwbF5J6Vrr/cvKBu30W5k
         tmaaiyXn6DBsgXBV8G0hq7SmdZpwhh6OetBoYmzuzOGt/0gdlQAtC43XXHa+mZNoL2GQ
         1szw==
X-Gm-Message-State: AOJu0YxrPrSjzrvRRJq+VWnawW66EfjW3MN+mCcTtab6ow6itGc6lBro
	AB3e1ZvnN/TC+2F0Ubx+Xt7FsrmofuBvsPDA9EyhzUMsw4sPQOhHMhEFnwkqFt6o9STpCmxUoor
	Q4OapbDGL+UX3AudDnvePmOufHwA=
X-Received: by 2002:a05:620a:1187:b0:781:38f6:198b with SMTP id b7-20020a05620a118700b0078138f6198bmr1543820qkk.39.1704420428791;
        Thu, 04 Jan 2024 18:07:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEnb7mKzPdenYnGcttTYPHWQnr6RHpL6BL8zn/RU93XFF8p6S6mSNYUAUDRUcTLd/kRNs4wHA==
X-Received: by 2002:a05:620a:1187:b0:781:38f6:198b with SMTP id b7-20020a05620a118700b0078138f6198bmr1543813qkk.39.1704420428455;
        Thu, 04 Jan 2024 18:07:08 -0800 (PST)
Received: from [192.168.1.154] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id c3-20020a37e103000000b00781ea9404dfsm234570qkm.90.2024.01.04.18.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jan 2024 18:07:07 -0800 (PST)
Message-ID: <8207e4fb-0ef0-50e8-5954-363a3723ffa6@redhat.com>
Date: Thu, 4 Jan 2024 21:07:07 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v5 01/40] dm: add documentation for dm-vdo target
To: Matthias Kaehlcke <mka@chromium.org>
Cc: dm-devel@lists.linux.dev, Brian Geffon <bgeffon@google.com>
References: <cover.1700250814.git.msakai@redhat.com>
 <b89e2912cb24b311b4196bb5cc92f10efc396886.1700250814.git.msakai@redhat.com>
 <ZY3JiwgHnbbL1vGF@google.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <ZY3JiwgHnbbL1vGF@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/28/23 14:16, Matthias Kaehlcke wrote:
> Hi,
> 
> On Fri, Nov 17, 2023 at 03:59:18PM -0500, Matthew Sakai wrote:
>> This adds the admin-guide documentation for dm-vdo.
>>
>> vdo.rst is the guide to using dm-vdo. vdo-design is an overview of the
>> design of dm-vdo.
>>
>> Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
>> Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
>> Signed-off-by: Matthew Sakai <msakai@redhat.com>
>> ---
>>   .../admin-guide/device-mapper/vdo-design.rst  | 415 ++++++++++++++++++
>>   .../admin-guide/device-mapper/vdo.rst         | 388 ++++++++++++++++
>>   2 files changed, 803 insertions(+)
>>   create mode 100644 Documentation/admin-guide/device-mapper/vdo-design.rst
>>   create mode 100644 Documentation/admin-guide/device-mapper/vdo.rst
>>
>> diff --git a/Documentation/admin-guide/device-mapper/vdo-design.rst b/Documentation/admin-guide/device-mapper/vdo-design.rst
>> new file mode 100644
>> index 000000000000..c82d51071c7d
>> --- /dev/null
>> +++ b/Documentation/admin-guide/device-mapper/vdo-design.rst
>> @@ -0,0 +1,415 @@
>> +.. SPDX-License-Identifier: GPL-2.0-only
>> +
>> +================
>> +Design of dm-vdo
>> +================
>> +
>> +The dm-vdo (virtual data optimizer) target provides inline deduplication,
>> +compression, zero-block elimination, and thin provisioning. A dm-vdo target
>> +can be backed by up to 256TB of storage, and can present a logical size of
>> +up to 4PB. 

[snip]

>> +	block map cache size:
>> +		The size of the block map cache, as a number of 4096-byte
>> +		blocks. The minimum and recommended value is 32768 blocks.
>> +		If the logical thread count is non-zero, the cache size
>> +		must be at least 4096 blocks per logical thread.
> 
> If I understand correctly the minimum of 32768 blocks results in the 128 MB
> metadata cache mentioned in 'Tuning', which allows to access up to 100 GB
> of logical space.
> 
> Is there a strict reason for this minimum? I'm evaluating to use vdo on
> systems with a relatively small vdo volume (say 4GB) and 'only' 4-8 GB of
> RAM. The 128 MB of metadata cache would be a sizeable chunk of that, which
> could make the use of vdo infeasible.

The short answer is that VDO can often use a smaller cache than the 
default, but it likely won't help in the way you want it to.

>> +Examples:
>> +
>> +Start a previously-formatted vdo volume with 1 GB logical space and 1 GB
>> +physical space, storing to /dev/dm-1 which has more than 1 GB of space.
>> +
>> +::
>> +
>> +	dmsetup create vdo0 --table \
>> +	"0 2097152 vdo V4 /dev/dm-1 262144 4096 32768 16380"
> 
> IIUC the backing device needs to be previously formatted. The formatting
> fails when the size of the backing device is < 5GB:
> 
> vdoformat /dev/loop8
>    Minimum required size for VDO volume: 5063921664 bytes
>    vdoformat: formatVDO failed on '/dev/loop8': VDO Status: Out of space
> 
> That was with 'vdoformat' from https://github.com/dm-vdo/vdo/
> 
> It would be great if somewhat smaller devices could be supported.

VDO was designed to handle the challenge of data deduplication in very 
large storage pools. It generally is not very useful for very small 
pools. The first question to ask is whether VDO can actually provide any 
value in the sort of environment you're using. VDO generally takes the 
strategy of saving storage space by using extra RAM and CPU cycles. In 
addition, VDO needs to track a certain amount of metadata, which reduces 
the amount storage available for actual user data.

For vdoformat, the biggest consideration is the deduplication index and 
other metadata, which are basically a fixed cost of about 3.5GB. In 
order for VDO to be useful, VDO would have to find enough deduplication 
to make up for the storage lost to VDO's metadata, so the minimum useful 
size of a VDO volume is in the 8-12GB range.

For the block map cache, decreasing the cache size may increase the 
frequency of metadata writes, which generally decreases the write 
throughput of the VDO device. So the tradeoff is between RAM and write 
speed.

Nothing about the generic structure of VDO would prevent us from 
producing a smaller VDO (and in fact we do for some testing purposes), 
but in a scenario where you can only expect to save a few gigabytes 
through deduplication, VDO is generally more expensive than it is worth.

If you still think this might be worth pursuing, let me know and we can 
try to work out a configuration which might suit your goals.

Matt Sakai

