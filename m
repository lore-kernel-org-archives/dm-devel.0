Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B826D6CA
	for <dm-devel@lists.linux.dev>; Tue,  9 Jan 2024 03:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g15jT6P3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704770275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VoAUWboJV3N++jvAx60A7rPv2QfqwBBWHOXD8r6KDcg=;
	b=g15jT6P30LjZFAE9nKBE9dqTt4XfNuV1imcq0tJ0jPFOk2N2vj6lJia1d8LNaoJRX3Cs3q
	F35BbCxZBUh8obr8PJ7cP6+rArg6mBkKtIhdVVA/uynUoHAntCMqNroCHa31FrVoLN1/79
	SREbNDQNKicUjS1TPN1r5Wd+Hp4coZo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-OY25hrjTNhqsjAGiJ12-2Q-1; Mon, 08 Jan 2024 22:17:51 -0500
X-MC-Unique: OY25hrjTNhqsjAGiJ12-2Q-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7816bea8d28so617261485a.0
        for <dm-devel@lists.linux.dev>; Mon, 08 Jan 2024 19:17:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704770271; x=1705375071;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VoAUWboJV3N++jvAx60A7rPv2QfqwBBWHOXD8r6KDcg=;
        b=b2s72s4bIWHWmqjyL1FPzKa8z6RSEwN4toc37gPIbo1D2YFnw800IC7iQop4x0ASef
         msDXBMZE2SZK/i8awHZ9dZj6TtxyC/hvWvBC9E92OoYgXElvQKwdoGSkCjbtKmIJaHnO
         YkMWEzfHNd4qpyaca3hUKaInD44RFJJOxnYWlplj2qqgGY+ZiUIptFAAQC3bwR4oky9n
         LMUU5wvRZjjELnzn0jWwz7/cAAqOA/YBpz/CEvSRbdr3rcb3RjkJbP+UpNNKszTc8QTd
         lQ0NH/tIS13T9qGJGw9+dj1XSvDI4+yRD8sLTYjVJmXPq6pVTtfo+3/5ilwFj0/9fVzG
         0I6Q==
X-Gm-Message-State: AOJu0Yy9Zp7E0GCQdHnh2mQIZlswnGjtwdeNFHLPjG8j1GRiM/QS4ckW
	netp57cPO1m5F6xrWmY4DTxyUF8iWz8ofFVH2RXydQ1yR2exwiXbMYmbGmqcJKvN5MHP4NmDPx8
	ck2GWZ46NgQ/qh2mcljUYS8jrfiA=
X-Received: by 2002:a05:620a:29d3:b0:781:6199:e5cc with SMTP id s19-20020a05620a29d300b007816199e5ccmr161940qkp.7.1704770271139;
        Mon, 08 Jan 2024 19:17:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7rOvOVX9giI4c3BlDlVNcSksGusDuYH7M46iAnHXlBpZt8oWTHzF6QgveR1ERW+/VejaCcg==
X-Received: by 2002:a05:620a:29d3:b0:781:6199:e5cc with SMTP id s19-20020a05620a29d300b007816199e5ccmr161932qkp.7.1704770270875;
        Mon, 08 Jan 2024 19:17:50 -0800 (PST)
Received: from [192.168.1.158] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id d6-20020a05620a240600b00781b73f77b1sm435379qkn.128.2024.01.08.19.17.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jan 2024 19:17:50 -0800 (PST)
Message-ID: <151f92c6-9bc9-d3b5-9123-1ba39beeec73@redhat.com>
Date: Mon, 8 Jan 2024 22:17:49 -0500
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
 <8207e4fb-0ef0-50e8-5954-363a3723ffa6@redhat.com>
 <ZZwaPjBECFvs8F4i@google.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <ZZwaPjBECFvs8F4i@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/8/24 10:52, Matthias Kaehlcke wrote:
> Hi Matthew,
> 
> Thanks for your reply!
> 
> On Thu, Jan 04, 2024 at 09:07:07PM -0500, Matthew Sakai wrote:
>>
>>
>> On 12/28/23 14:16, Matthias Kaehlcke wrote:
>>> Hi,
>>>
>>> On Fri, Nov 17, 2023 at 03:59:18PM -0500, Matthew Sakai wrote:
>>>> This adds the admin-guide documentation for dm-vdo.
>>>>
>>>> vdo.rst is the guide to using dm-vdo. vdo-design is an overview of the
>>>> design of dm-vdo.
>>>>
>>>> Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
>>>> Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
>>>> Signed-off-by: Matthew Sakai <msakai@redhat.com>
>>>> ---
>>>>    .../admin-guide/device-mapper/vdo-design.rst  | 415 ++++++++++++++++++
>>>>    .../admin-guide/device-mapper/vdo.rst         | 388 ++++++++++++++++
>>>>    2 files changed, 803 insertions(+)
>>>>    create mode 100644 Documentation/admin-guide/device-mapper/vdo-design.rst
>>>>    create mode 100644 Documentation/admin-guide/device-mapper/vdo.rst
>>>>
>>>> diff --git a/Documentation/admin-guide/device-mapper/vdo-design.rst b/Documentation/admin-guide/device-mapper/vdo-design.rst
>>>> new file mode 100644
>>>> index 000000000000..c82d51071c7d
>>>> --- /dev/null
>>>> +++ b/Documentation/admin-guide/device-mapper/vdo-design.rst
>>>> @@ -0,0 +1,415 @@
>>>> +.. SPDX-License-Identifier: GPL-2.0-only
>>>> +
>>>> +================
>>>> +Design of dm-vdo
>>>> +================
>>>> +
>>>> +The dm-vdo (virtual data optimizer) target provides inline deduplication,
>>>> +compression, zero-block elimination, and thin provisioning. A dm-vdo target
>>>> +can be backed by up to 256TB of storage, and can present a logical size of
>>>> +up to 4PB.
>>
>> [snip]
>>
>>>> +	block map cache size:
>>>> +		The size of the block map cache, as a number of 4096-byte
>>>> +		blocks. The minimum and recommended value is 32768 blocks.
>>>> +		If the logical thread count is non-zero, the cache size
>>>> +		must be at least 4096 blocks per logical thread.
>>>
>>> If I understand correctly the minimum of 32768 blocks results in the 128 MB
>>> metadata cache mentioned in 'Tuning', which allows to access up to 100 GB
>>> of logical space.
>>>
>>> Is there a strict reason for this minimum? I'm evaluating to use vdo on
>>> systems with a relatively small vdo volume (say 4GB) and 'only' 4-8 GB of
>>> RAM. The 128 MB of metadata cache would be a sizeable chunk of that, which
>>> could make the use of vdo infeasible.
>>
>> The short answer is that VDO can often use a smaller cache than the default,
>> but it likely won't help in the way you want it to.
>>
>>>> +Examples:
>>>> +
>>>> +Start a previously-formatted vdo volume with 1 GB logical space and 1 GB
>>>> +physical space, storing to /dev/dm-1 which has more than 1 GB of space.
>>>> +
>>>> +::
>>>> +
>>>> +	dmsetup create vdo0 --table \
>>>> +	"0 2097152 vdo V4 /dev/dm-1 262144 4096 32768 16380"
>>>
>>> IIUC the backing device needs to be previously formatted. The formatting
>>> fails when the size of the backing device is < 5GB:
>>>
>>> vdoformat /dev/loop8
>>>     Minimum required size for VDO volume: 5063921664 bytes
>>>     vdoformat: formatVDO failed on '/dev/loop8': VDO Status: Out of space
>>>
>>> That was with 'vdoformat' from https://github.com/dm-vdo/vdo/
>>>
>>> It would be great if somewhat smaller devices could be supported.
>>
>> VDO was designed to handle the challenge of data deduplication in very large
>> storage pools. It generally is not very useful for very small pools. The
>> first question to ask is whether VDO can actually provide any value in the
>> sort of environment you're using. VDO generally takes the strategy of saving
>> storage space by using extra RAM and CPU cycles. In addition, VDO needs to
>> track a certain amount of metadata, which reduces the amount storage
>> available for actual user data.
>>
>> For vdoformat, the biggest consideration is the deduplication index and
>> other metadata, which are basically a fixed cost of about 3.5GB. In order
>> for VDO to be useful, VDO would have to find enough deduplication to make up
>> for the storage lost to VDO's metadata, so the minimum useful size of a VDO
>> volume is in the 8-12GB range.
>>
>> For the block map cache, decreasing the cache size may increase the
>> frequency of metadata writes, which generally decreases the write throughput
>> of the VDO device. So the tradeoff is between RAM and write speed.
>>
>> Nothing about the generic structure of VDO would prevent us from producing a
>> smaller VDO (and in fact we do for some testing purposes), but in a scenario
>> where you can only expect to save a few gigabytes through deduplication, VDO
>> is generally more expensive than it is worth.
>>
>> If you still think this might be worth pursuing, let me know and we can try
>> to work out a configuration which might suit your goals.
> 
> Some more context about my use case:
> 
> I'm evaluating the use of VDO for storing a hibernate image, the goal is to
> reduce hibernate resume time by loading less data from potentially slow
> storage. That's why the volume is relatively small. The image is only
> written once per hibernate cycle and generally after the system was idle
> for a longer time, so the lower write throughput due to a smaller cache
> size probably wouldn't be a major concern. The systems might not have huge
> amounts of free disk space, an overhead of ~3.5GB for the deduplication
> index would probably rule out the use of VDO.
> 
> In the context of this use case the compression part of VDO seems more
> interesting than the deduplication. In the documentation of VDO I noticed
> a parameter to disable deduplication. With that I wonder if it would be
> feasible/reasonable to add an option to vdoformat to omit the deduplication
> index.
> 
> Do you think VDO might be (made) suitable for this scenario or is it
> just not the right tool?
> 
> Thanks
> 
> Matthias

The primary reason for VDO is the deduplication capability.  You can 
disable deduplication on a VDO target, but you would still be paying the 
overhead costs of being able to enable it. Certainly I think VDO itself 
is not the right tool here.

We have considered making a compression-only target, but realistically 
it would be a completely separate dm target and not a version of VDO. A 
compression-only target could remove all the complication of the 
deduplication aspects of VDO, and it could potentially even get better 
compression by removing some of the constraints imposed by supporting 
deduplication. Conceptually it's not too hard, I think, but we haven't 
really done any work developing it so it wouldn't come into being any 
time soon. If you thought it would be helpful then we can consider 
prioritizing that work.

For the specific use case you described, it sounds like you've got a 
pretty good idea of what you need to write already. Have you considered 
trying to compress that image before writing it, just using file-level 
compression or something similar? I wonder if being able to load less 
data from storage is actually a win once you account for the extra 
computation you would need to decompress the image.

Matt





















