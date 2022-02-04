Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6DCFC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 09:42:10 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-X1rZC69UNY6MtAPToBdcvQ-1; Fri, 04 Feb 2022 04:42:06 -0500
X-MC-Unique: X1rZC69UNY6MtAPToBdcvQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BFB9363AB;
	Fri,  4 Feb 2022 09:42:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E04173168;
	Fri,  4 Feb 2022 09:42:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 17004180BAD1;
	Fri,  4 Feb 2022 09:42:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2148OqHh004436 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 03:24:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 093C8492D4A; Fri,  4 Feb 2022 08:24:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05B01492D54
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 08:24:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8693938035AA
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 08:24:51 +0000 (UTC)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com
	[209.85.218.47]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-297-k9ujzDMFPBG1AHm_Jrcz1Q-1; Fri, 04 Feb 2022 03:24:48 -0500
X-MC-Unique: k9ujzDMFPBG1AHm_Jrcz1Q-1
Received: by mail-ej1-f47.google.com with SMTP id me13so17036681ejb.12
	for <dm-devel@redhat.com>; Fri, 04 Feb 2022 00:24:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=+AJzw4pLVP6piQQ8DJ6FcW2rv83/BHBjZGX/F+I/5C4=;
	b=wmmlYgxgQGfVW9qcIw8L+tkgYdJdQB/JgmW1Xzn2v8Ehc7Bh+OepiHCcybfJDvqkEz
	kt4vgO/elHa5Dj8oKAOAGU5rcwFcbjmbVvBghRFJfJv6Tt36u1HxQT9uOWp313/S5Wtr
	W1YJFQcQQAamxZM9FkoBrXRcfFFTy10TcVIXYXSPj302V0xPglPpBNWUZnFXT+bzXPMR
	LwtwxCT6YRBhLjactGJdN5j86TUfF1bmUrqDkYDzidPtmkWdBApBUzzmyVdbr6tTIRNW
	UtUS+bu2BvgOgUxhxum/yh5JQI0xpSRuo3UVU5FyQ2uMraXHGBM3dv8fosmu7NJcp98k
	78Hg==
X-Gm-Message-State: AOAM533yMwn85bzM2L49DCromZ13/cx/MHzLGfZ1VkSHEvN2+Pq9uanL
	nEQgvTlDm6fAzEzqg9xdawmJ+Q==
X-Google-Smtp-Source: ABdhPJyAfQjC4kR5eZYldFqWF50m/eUAUll5gwN5OdXOAvaJGO24XxVigDE5qacG6WGLefG1r9JSCg==
X-Received: by 2002:a17:906:9b8e:: with SMTP id
	dd14mr1449134ejc.6.1643963086917; 
	Fri, 04 Feb 2022 00:24:46 -0800 (PST)
Received: from localhost (5.186.121.195.cgn.fibianet.dk. [5.186.121.195])
	by smtp.gmail.com with ESMTPSA id u3sm409447ejz.99.2022.02.04.00.24.46
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 04 Feb 2022 00:24:46 -0800 (PST)
Date: Fri, 4 Feb 2022 09:24:45 +0100
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20220204082445.hczdiy2uhxfi3x2g@ArmHalley.local>
References: <alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<270f30df-f14c-b9e4-253f-bff047d32ff0@nvidia.com>
	<20220203153843.szbd4n65ru4fx5hx@garbanzo>
	<CGME20220203165248uscas1p1f0459e548743e6be26d13d3ed8aa4902@uscas1p1.samsung.com>
	<20220203165238.GA142129@dhcp-10-100-145-180.wdc.com>
	<20220203195155.GB249665@bgt-140510-bm01>
	<863d85e3-9a93-4d8c-cf04-88090eb4cc02@nvidia.com>
	<2bbed027-b9a1-e5db-3a3d-90c40af49e09@opensource.wdc.com>
	<9d5d0b50-2936-eac3-12d3-a309389e03bf@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <9d5d0b50-2936-eac3-12d3-a309389e03bf@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Feb 2022 04:41:43 -0500
Cc: "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Keith Busch <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>,
	"jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [RFC PATCH 3/3] nvme: add the "debug" host driver
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 04.02.2022 07:58, Chaitanya Kulkarni wrote:
>On 2/3/22 22:28, Damien Le Moal wrote:
>> On 2/4/22 12:12, Chaitanya Kulkarni wrote:
>>>
>>>>>> One can instantiate scsi devices with qemu by using fake scsi devices,
>>>>>> but one can also just use scsi_debug to do the same. I see both efforts
>>>>>> as desirable, so long as someone mantains this.
>>>>>>
>>>
>>> Why do you think both efforts are desirable ?
>>
>> When testing code using the functionality, it is far easier to get said
>> functionality doing a simple "modprobe" rather than having to setup a
>> VM. C.f. running blktests or fstests.
>>
>
>agree on simplicity but then why do we have QEMU implementations for
>the NVMe features (e.g. ZNS, NVMe Simple Copy) ? we can just build
>memoery backed NVMeOF test target for NVMe controller features.
>
>Also, recognizing the simplicity I proposed initially NVMe ZNS
>fabrics based emulation over QEMU (I think I still have initial state
>machine implementation code for ZNS somewhere), those were "nacked" for
>the right reason, since we've decided go with QEMU and use that as a
>primary platform for testing, so I failed to understand what has
>changed.. since given that QEMU already supports NVMe simple copy ...

I was not part of this conversation, but as I see it each approach give
a benefit. QEMU is fantastic for compliance testing and I am not sure
you get the same level of command analysis anywhere else; at least not
without writing dedicated code for this in a target.

This said, when we want to test for race conditions, QEMU is very slow.
For a software-only solution, we have experimented with something
similar to the nvme-debug code tha Mikulas is proposing. Adam pointed to
the nvme-loop target as an alternative and this seems to work pretty
nicely. I do not believe there should be many changes to support copy
offload using this.

So in my view having both is not replication and it gives more
flexibility for validation, which I believe it is always good.

>
>> So personally, I also think it would be great to have a kernel-based
>> emulation of copy offload. And that should be very easy to implement
>> with the fabric code. Then loopback onto a nullblk device and you get a
>> quick and easy to setup copy-offload device that can even be of the ZNS
>> variant if you want since nullblk supports zones.
>>
>
>One can do that with creating null_blk based NVMeOF target namespace,
>no need to emulate simple copy memory backed code in the fabrics
>with nvme-loop.. it is as simple as inserting module and configuring
>ns with nvmetcli once we have finalized the solution for copy offload.
>If you remember, I already have patches for that...
>
>>>
>>> NVMe ZNS QEMU implementation proved to be perfect and works just
>>> fine for testing, copy offload is not an exception.
>>>
>>>>>> For instance, blktests uses scsi_debug for simplicity.
>>>>>>
>>>>>> In the end you decide what you want to use.
>>>>>
>>>>> Can we use the nvme-loop target instead?
>>>>
>>>> I am advocating for this approach as well. It presentas a virtual nvme
>>>> controller already.
>>>>
>>>
>>> It does that assuming underlying block device such as null_blk or
>>> QEMU implementation supports required features not to bloat the the
>>> NVMeOF target.
>>>
>>> -ck
>>>
>
>-ck
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

