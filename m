Return-Path: <SRS0=Iac5=NL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5652FC4338F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 21:19:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DB31A61130
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 21:19:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DB31A61130
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-jcgM39D5P46RwWkPlXpVsA-1; Fri, 20 Aug 2021 17:19:43 -0400
X-MC-Unique: jcgM39D5P46RwWkPlXpVsA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA830875047;
	Fri, 20 Aug 2021 21:19:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 522781ABD8;
	Fri, 20 Aug 2021 21:19:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B14064BB7C;
	Fri, 20 Aug 2021 21:19:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17KLIci2023416 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Aug 2021 17:18:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3666520C15B8; Fri, 20 Aug 2021 21:18:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 31FA420BEDD1
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 21:18:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FA9E800159
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 21:18:35 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
	[209.85.216.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-120-mhNSAp2oMSu2MCY7FlzMbQ-1; Fri, 20 Aug 2021 17:18:33 -0400
X-MC-Unique: mhNSAp2oMSu2MCY7FlzMbQ-1
Received: by mail-pj1-f47.google.com with SMTP id
	m24-20020a17090a7f98b0290178b1a81700so8155229pjl.4; 
	Fri, 20 Aug 2021 14:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=ghNGDEZc2SSWn9VvNAd7fmG9UBe/rSvbMP1W9zaThGE=;
	b=EZSIhrm+9xRgatJ4dY/PioQYuhcPSBbTzCr35ZkGU7qCPiCelXr5ydQS8gGwWmtDTn
	vDcX76JUktPcqacIUfncWC6q720nj6j6V8AZVgq514x2EI8lLhNpFP0xkgHAqAYc/Rj3
	KIytUy6/o8jis+1QuSoVQdpvGmY8OT2X1eFSd9/oc3wi4rxghPksHOgrqWktWkXeEqw3
	BQUYEgBvDssab1Qqu0rhnRnQ8wjQdpZf6CZmk+ysH5O5rxWqbujr6O3xuZOhQJSyOWYO
	0OGxQEFQPvCLKsjtWVGyW6xxoxzIuJZqCZznUj9IM9Ngg4Z53b2oIAXtCpEhuuevsATo
	F76w==
X-Gm-Message-State: AOAM532MZQCTWn2oow9pzrCBkfe6WaJCbSm4/2BDpFakMBE0xinxMdxa
	wp0vLiy2atjGa3BXzDPRBHA=
X-Google-Smtp-Source: ABdhPJzuE+NZzfM/vev5NRgk1CFObdVgW7MtwdoY7ko+PcKgdRS+PzinaHKAfWWwgZcHMP+PbGE5lA==
X-Received: by 2002:a17:90a:4a95:: with SMTP id
	f21mr6714960pjh.122.1629494311917; 
	Fri, 20 Aug 2021 14:18:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com
	([2620:15c:211:201:ddfe:8579:6783:9ed8])
	by smtp.gmail.com with ESMTPSA id 8sm8164521pfo.153.2021.08.20.14.18.29
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 20 Aug 2021 14:18:31 -0700 (PDT)
To: Kanchan Joshi <joshiiitr@gmail.com>
References: <20210817101423.12367-1-selvakuma.s1@samsung.com>
	<CGME20210817101758epcas5p1ec353b3838d64654e69488229256d9eb@epcas5p1.samsung.com>
	<20210817101423.12367-4-selvakuma.s1@samsung.com>
	<ad3561b9-775d-dd4d-0d92-6343440b1f8f@acm.org>
	<CA+1E3rK2ULVajQRkNTZJdwKoqBeGvkfoVYNF=WyK6Net85YkhA@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <fb9931ae-de27-820a-1333-f24e020913ff@acm.org>
Date: Fri, 20 Aug 2021 14:18:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CA+1E3rK2ULVajQRkNTZJdwKoqBeGvkfoVYNF=WyK6Net85YkhA@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	djwong@kernel.org, linux-nvme@lists.infradead.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	agk@redhat.com, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, Matthew Wilcox <willy@infradead.org>,
	Nitesh Shetty <nj.shetty@samsung.com>, kch@kernel.org,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	Selva Jove <selvajove@gmail.com>, linux-block@vger.kernel.org,
	mpatocka@redhat.com, Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Damien Le Moal <damien.lemoal@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	KANCHAN JOSHI <joshi.k@samsung.com>, linux-api@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-fsdevel@vger.kernel.org, Javier Gonzalez <javier.gonz@samsung.com>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [dm-devel] [PATCH 3/7] block: copy offload support
	infrastructure
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/20/21 3:39 AM, Kanchan Joshi wrote:
> Bart, Mikulas
> 
> On Tue, Aug 17, 2021 at 10:44 PM Bart Van Assche <bvanassche@acm.org> wrote:
>>
>> On 8/17/21 3:14 AM, SelvaKumar S wrote:
>>> Introduce REQ_OP_COPY, a no-merge copy offload operation. Create
>>> bio with control information as payload and submit to the device.
>>> Larger copy operation may be divided if necessary by looking at device
>>> limits. REQ_OP_COPY(19) is a write op and takes zone_write_lock when
>>> submitted to zoned device.
>>> Native copy offload is not supported for stacked devices.
>>
>> Using a single operation for copy-offloading instead of separate
>> operations for reading and writing is fundamentally incompatible with
>> the device mapper. I think we need a copy-offloading implementation that
>> is compatible with the device mapper.
>>
> 
> While each read/write command is for a single contiguous range of
> device, with simple-copy we get to operate on multiple discontiguous
> ranges, with a single command.
> That seemed like a good opportunity to reduce control-plane traffic
> (compared to read/write operations) as well.
> 
> With a separate read-and-write bio approach, each source-range will
> spawn at least one read, one write and eventually one SCC command. And
> it only gets worse as there could be many such discontiguous ranges (for
> GC use-case at least) coming from user-space in a single payload.
> Overall sequence will be
> - Receive a payload from user-space
> - Disassemble into many read-write pair bios at block-layer
> - Assemble those (somehow) in NVMe to reduce simple-copy commands
> - Send commands to device
> 
> We thought payload could be a good way to reduce the
> disassembly/assembly work and traffic between block-layer to nvme.
> How do you see this tradeoff?  What seems necessary for device-mapper
> usecase, appears to be a cost when device-mapper isn't used.
> Especially for SCC (since copy is within single ns), device-mappers
> may not be too compelling anyway.
> 
> Must device-mapper support be a requirement for the initial support atop SCC?
> Or do you think it will still be a progress if we finalize the
> user-space interface to cover all that is foreseeable.And for
> device-mapper compatible transport between block-layer and NVMe - we
> do it in the later stage when NVMe too comes up with better copy
> capabilities?

Hi Kanchan,

These days there might be more systems that run the device mapper on top 
of the NVMe driver or a SCSI driver than systems that do use the device 
mapper. It is common practice these days to use dm-crypt on personal 
workstations and laptops. LVM (dm-linear) is popular because it is more 
flexible than a traditional partition table. Android phones use 
dm-verity on top of hardware encryption. In other words, not supporting 
the device mapper means that a very large number of use cases is 
excluded. So I think supporting the device mapper from the start is 
important, even if that means combining individual bios at the bottom of 
the storage stack into simple copy commands.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

