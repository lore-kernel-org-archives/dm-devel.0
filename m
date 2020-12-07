Return-Path: <SRS0=+j0W=FL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NAME_EMAIL_DIFF,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D1CC4361B
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 10:00:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3F7B32311B
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 10:00:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F7B32311B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-J9n37GNjP7yOCihmI3isDQ-1; Mon, 07 Dec 2020 04:59:56 -0500
X-MC-Unique: J9n37GNjP7yOCihmI3isDQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62679803F62;
	Mon,  7 Dec 2020 09:59:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 428B55D9DE;
	Mon,  7 Dec 2020 09:59:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3AB4D1809CA0;
	Mon,  7 Dec 2020 09:59:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B78GeHr006601 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Dec 2020 03:16:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BDFDF1111C93; Mon,  7 Dec 2020 08:16:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B9E1D1000DBE
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 08:16:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5664A800183
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 08:16:38 +0000 (UTC)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com
	[209.85.218.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-513-iumu4Dr_MpCkTUBSrWQX5w-1; Mon, 07 Dec 2020 03:16:33 -0500
X-MC-Unique: iumu4Dr_MpCkTUBSrWQX5w-1
Received: by mail-ej1-f52.google.com with SMTP id bo9so18121610ejb.13
	for <dm-devel@redhat.com>; Mon, 07 Dec 2020 00:16:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=iYj4pUoj9o5PR+qG7Qn3L1SJKXMPS3+hvYYnqb4yHOw=;
	b=dnIBUvEXpKoBpsOfSzYbrhJzOaMeGVUsp6AbI3xUJbZnPRms3kwEmILN+2hI+b8t02
	G+emJBhj9LgajJq8bZZQdFJziNYkTdtgWT6ZvJXPI9VYzoFUGBpQGwySY2gEG8wj2SWk
	qaRL+AzAujipLrzsqvSKMYf4z7BlLeDPWAgNepZ+lJ7xeXRc4GQPJcbJbDc8RAXmAOpo
	3otnJD5xXayT9WZvTFJ9EwzyBl9MXj952tIleqAn9348zKk2PVHgrn1PBqtrVdO1MdsX
	Hsr5FfBlHxPFFYZYw7O8j1xVgHbq2JsvVlCTOUIRdBGCAlE1w0pAMl1q+SlZ10hbxtXY
	Ocwg==
X-Gm-Message-State: AOAM531F1s/aP8MGEOC8vcneH5zDBHcwsYVrUHK/RJvV/7M2Rr3QDZwu
	6fId0mfSZu/+f/W78Hb5bpaGiw==
X-Google-Smtp-Source: ABdhPJwb4jRV2xylIOGlV+IbqS3THEEk1xv/TWj/PDOLR2zfUPpGUmwka3CjMKimmTAV6Dyou0TXtA==
X-Received: by 2002:a17:906:7b8d:: with SMTP id
	s13mr1630369ejo.479.1607328992695; 
	Mon, 07 Dec 2020 00:16:32 -0800 (PST)
Received: from localhost (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
	by smtp.gmail.com with ESMTPSA id
	n22sm12100137edr.11.2020.12.07.00.16.31
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 07 Dec 2020 00:16:32 -0800 (PST)
Date: Mon, 7 Dec 2020 09:16:31 +0100
From: "javier.gonz@samsung.com" <javier@javigon.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Message-ID: <20201207081631.usapwn5jj35c5633@mpHalley>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<CH2PR04MB6522F1188557C829285ED5E8E7F10@CH2PR04MB6522.namprd04.prod.outlook.com>
	<20201204144003.GA8868@redsun51.ssa.fujisawa.hgst.com>
	<20201207074616.mocdy6m5qgsn6yqg@mpHalley>
	<CH2PR04MB6522623991D84D67B13DDF66E7CE0@CH2PR04MB6522.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <CH2PR04MB6522623991D84D67B13DDF66E7CE0@CH2PR04MB6522.namprd04.prod.outlook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 07 Dec 2020 04:59:37 -0500
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>, "hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH v2 0/2] add simple copy support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 07.12.2020 08:06, Damien Le Moal wrote:
>On 2020/12/07 16:46, javier.gonz@samsung.com wrote:
>> On 04.12.2020 23:40, Keith Busch wrote:
>>> On Fri, Dec 04, 2020 at 11:25:12AM +0000, Damien Le Moal wrote:
>>>> On 2020/12/04 20:02, SelvaKumar S wrote:
>>>>> This patchset tries to add support for TP4065a ("Simple Copy Command"),
>>>>> v2020.05.04 ("Ratified")
>>>>>
>>>>> The Specification can be found in following link.
>>>>> https://nvmexpress.org/wp-content/uploads/NVM-Express-1.4-Ratified-TPs-1.zip
>>>>>
>>>>> This is an RFC. Looking forward for any feedbacks or other alternate
>>>>> designs for plumbing simple copy to IO stack.
>>>>>
>>>>> Simple copy command is a copy offloading operation and is  used to copy
>>>>> multiple contiguous ranges (source_ranges) of LBA's to a single destination
>>>>> LBA within the device reducing traffic between host and device.
>>>>>
>>>>> This implementation accepts destination, no of sources and arrays of
>>>>> source ranges from application and attach it as payload to the bio and
>>>>> submits to the device.
>>>>>
>>>>> Following limits are added to queue limits and are exposed in sysfs
>>>>> to userspace
>>>>> 	- *max_copy_sectors* limits the sum of all source_range length
>>>>> 	- *max_copy_nr_ranges* limits the number of source ranges
>>>>> 	- *max_copy_range_sectors* limit the maximum number of sectors
>>>>> 		that can constitute a single source range.
>>>>
>>>> Same comment as before. I think this is a good start, but for this to be really
>>>> useful to users and kernel components alike, this really needs copy emulation
>>>> for drives that do not have a native copy feature, similarly to what write zeros
>>>> handling for instance: if the drive does not have a copy command (simple copy
>>>> for NVMe or XCOPY for scsi), then the block layer should issue read/write
>>>> commands to seamlessly execute the copy. Otherwise, this will only serve a small
>>>> niche for users and will not be optimal for FS and DM drivers that could be
>>>> simplified with a generic block layer copy functionality.
>>>>
>>>> This is my 10 cents though, others may differ about this.
>>>
>>> Yes, I agree that copy emulation support should be included with the
>>> hardware enabled solution.
>>
>> Keith, Damien,
>>
>> Can we do the block layer emulation with this patchset and then work in
>> follow-up patchses on (i) the FS interface with F2FS as a first user and
>> (ii) other HW accelerations such as XCOPY?
>
>The initial patchset supporting NVMe simple copy and emulation copy, all under
>an API that probably will be similar that of dm-kcopyd will cover all block
>devices. Other hardware native support for copy functions such as scsi extended
>copy can be added later under the hood without any API changes (or minimal changes).

Sounds good. That we can do. We will add a new patch for this.

>
>I am not sure what you mean by "FS interface for F2FS": the block layer API for
>this copy functionality will be what F2FS (and other FSes) will call. That is
>the interface, no ?

Essentially yes.. I mean adding the F2FS logic and potentially some
helpers to the block layer to aid GC.

>
>> For XCOPY, I believe we need to have a separate discussion as much works
>> is already done that we should align to.
>
>I think Martin (added to this thread) and others have looked into it but I do
>not think that anything made it into the kernel yet.

Exactly. Looking at some of the code posted through time and recalling
the discussions at LSF/MM, seems like there are a number of things we
are not addressing here that could be incorporated down the road, such
as dedicated syscalls / extensions, multi namespace / device support,
etc.
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

