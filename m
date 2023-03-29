Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 985BEC6FD18
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 12:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680094415;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oqyQc8DHAySLe2FGVwwcIrntB5r7oasVPCpYgPmFCVM=;
	b=MXSlHsX0/uVMCuCVZeqtQzVMnzmwvnWdalidUo4ankXK6IIxoVdT3wF8h5IgZFgIHwFTcW
	L+/5gi68AYmE6Om9KRUAliUxPWWq2lMcdb/1RcufKc1WkzPoisBxzyLdl0Ph0FUXxuUlx8
	rdPEs4LUXNhxRinBtuYkJy53bGLjoOk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-n0T18CfqNMy98ZLbvkiFLA-1; Wed, 29 Mar 2023 08:53:31 -0400
X-MC-Unique: n0T18CfqNMy98ZLbvkiFLA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C96F8185A791;
	Wed, 29 Mar 2023 12:53:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0929C2027040;
	Wed, 29 Mar 2023 12:53:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D0BFD194658C;
	Wed, 29 Mar 2023 12:53:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 267131946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 12:24:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1373F2027040; Wed, 29 Mar 2023 12:24:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B705202701F
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 12:24:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEC48185A790
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 12:24:21 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-P_ALowGVPImYi_4e8XfyYQ-1; Wed, 29 Mar 2023 08:24:19 -0400
X-MC-Unique: P_ALowGVPImYi_4e8XfyYQ-1
X-IronPort-AV: E=Sophos;i="5.98,300,1673884800"; d="scan'208";a="331227838"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 29 Mar 2023 20:24:18 +0800
IronPort-SDR: 8QulcRe0eRATLaCpmyiI7y3l++yqVglyJhEh0AyecuA6stus0ruL97O+vZfkAr9+E59dkL+D09
 IgpSaVyMk2lxBziJKjLSvf0iuvxXXJhITtG6To0rhTCVJZ7T2zmuynMTzCwb2qITOpWSAt7fk1
 4fT+OTq7r2/WLydN4qEZUQoCnqiKvBtiqb+KbAGK3zSYNsHaSshfobf6X/qASwNj7NL7ASqW1w
 YcEY0TF4nMB2lRyk06odhckF3QXbfqA4qDXCVqOIvblrTix5PqBrBaRNR3TngjZ5ARNmd0h0Lr
 vcc=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 04:40:27 -0700
IronPort-SDR: A6RphZYepPVNOMZFtIYMysik9AqTbbZFoNRxIuLH9xe9HMdnStkOzjzaGscapObRJC7pSr12oh
 4udw0Io/6mr8MwEqHrp2nco0DhKwiV7THbLykXVfVeRdb8reEREdcqk7TYPIaKPe+HHj9DmY2n
 O8/gaZGxwyZpwNju3fGjnocdLYAXiwKb9qmPksjixdErG1svoorPUggVrpzfgWBZghxJRmUeBY
 bX9bEvx+5byZLQwv5FVxyxu3J4zl5nfIINnGadmOG+nAA1ni2za4tY4lOije4jtWGGHakGp4sW
 FLM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 05:24:18 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pmm294fTMz1RtVp
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 05:24:17 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id VE4D2GsJi89S for <dm-devel@redhat.com>;
 Wed, 29 Mar 2023 05:24:16 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pmm253ydnz1RtVm;
 Wed, 29 Mar 2023 05:24:13 -0700 (PDT)
Message-ID: <03c647ff-3c4f-a810-12c4-06a9dc62c90e@opensource.wdc.com>
Date: Wed, 29 Mar 2023 21:24:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084216epcas5p3945507ecd94688c40c29195127ddc54d@epcas5p3.samsung.com>
 <20230327084103.21601-2-anuj20.g@samsung.com>
 <e725768d-19f5-a78a-2b05-c0b189624fea@opensource.wdc.com>
 <20230329104142.GA11932@green5>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230329104142.GA11932@green5>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v8 1/9] block: Introduce queue limits for
 copy-offload support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, joshi.k@samsung.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: opensource.wdc.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/29/23 19:41, Nitesh Shetty wrote:
>>> +What:		/sys/block/<disk>/queue/copy_max_bytes
>>> +Date:		November 2022
>>> +Contact:	linux-block@vger.kernel.org
>>> +Description:
>>> +		[RW] While 'copy_max_bytes_hw' is the hardware limit for the
>>> +		device, 'copy_max_bytes' setting is the software limit.
>>> +		Setting this value lower will make Linux issue smaller size
>>> +		copies from block layer.
>>
>> 		This is the maximum number of bytes that the block
>>                 layer will allow for a copy request. Must be smaller than
>>                 or equal to the maximum size allowed by the hardware indicated
> 
> Looks good.  Will update in next version. We took reference from discard. 
> 
>> 		by copy_max_bytes_hw. Write 0 to use the default kernel
>> 		settings.
>>
> 
> Nack, writing 0 will not set it to default value. (default value is
> copy_max_bytes = copy_max_bytes_hw)

It is trivial to make it work that way, which would match how max_sectors_kb
works. Write 0 to return copy_max_bytes being equal to the default
copy_max_bytes_hw.

The other possibility that is also interesting is "write 0 to disable copy
offload and use emulation". This one may actually be more useful.

> 
>>> +
>>> +
>>> +What:		/sys/block/<disk>/queue/copy_max_bytes_hw
>>> +Date:		November 2022
>>> +Contact:	linux-block@vger.kernel.org
>>> +Description:
>>> +		[RO] Devices that support offloading copy functionality may have
>>> +		internal limits on the number of bytes that can be offloaded
>>> +		in a single operation. The `copy_max_bytes_hw`
>>> +		parameter is set by the device driver to the maximum number of
>>> +		bytes that can be copied in a single operation. Copy
>>> +		requests issued to the device must not exceed this limit.
>>> +		A value of 0 means that the device does not
>>> +		support copy offload.
>>
>> 		[RO] This is the maximum number of kilobytes supported in a
>>                 single data copy offload operation. A value of 0 means that the
>> 		device does not support copy offload.
>>
> 
> Nack, value is in bytes. Same as discard.

Typo. I meant Bytes. Your text is too long an too convoluted, so unclear.

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

