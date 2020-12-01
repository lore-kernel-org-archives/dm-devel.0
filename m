Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NAME_EMAIL_DIFF,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE64C71155
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 09:55:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 462AD2223F
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 09:55:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 462AD2223F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-Cca8RTlDNM6ruvjy_GYQHA-1; Wed, 02 Dec 2020 04:55:13 -0500
X-MC-Unique: Cca8RTlDNM6ruvjy_GYQHA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1C97192D789;
	Wed,  2 Dec 2020 09:55:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 464FC5C1B4;
	Wed,  2 Dec 2020 09:55:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 575FC4A7C6;
	Wed,  2 Dec 2020 09:55:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B1CKqnV030960 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Dec 2020 07:20:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D81482166B2C; Tue,  1 Dec 2020 12:20:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D31012166B2B
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 12:20:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0B39800183
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 12:20:49 +0000 (UTC)
Received: from mail-ej1-f65.google.com (mail-ej1-f65.google.com
	[209.85.218.65]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-108-YvGGN-AeNeS3jOqLU9pFCA-1; Tue, 01 Dec 2020 07:20:47 -0500
X-MC-Unique: YvGGN-AeNeS3jOqLU9pFCA-1
Received: by mail-ej1-f65.google.com with SMTP id g20so3083201ejb.1
	for <dm-devel@redhat.com>; Tue, 01 Dec 2020 04:20:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:date:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=Fylyeg8K1HpI44gu+W/L892Ds6J+IK7AhpMNFOVv+J4=;
	b=m+thvTZaPU/0BS/+Fjgda65Ybktu8hprC+kC2d5xMTgcWUOHb1J8ptLLw23hsBkRnC
	YnrNNUl43ln5vMeAnkrL2vl9AcbsX2soYq04uSUIaciO47CvIY3eCc+wEVw/N5X7Lh3h
	BTxeo8SWgXhGuougZyUWmmlawKnrgVPuTWrmpNiIfxFTaps14TTN+RiJj9c3RY6i6RKF
	hyLbvuRzWRLL+iAlAvfFz6JLUFqfhs4g6x5VqIyoCmc0Lasy5iwLIICYuGTmWoQd3ZeD
	SDd0krkbjRLO4tFl6EKHL3lBqJw9i3BJsagZQ3hy40rz2Awm6IsDDtfueJX+otaeMQhW
	ePEQ==
X-Gm-Message-State: AOAM5312QaghJ5lcmLxZI2WqfP35dRflelg3ddzxfh9HHXv8cWt6uu77
	5zHOjUplg5RhxDxSzWcCybyrGw==
X-Google-Smtp-Source: ABdhPJyA6bpW98mfTIiD5151P4PptIAHrybHgwuhzzmuU72gxHomFLdeJrIMEsjvEi8IuWtDJ6C0aA==
X-Received: by 2002:a17:907:d1f:: with SMTP id
	gn31mr2862738ejc.192.1606825244314; 
	Tue, 01 Dec 2020 04:20:44 -0800 (PST)
Received: from localhost (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
	by smtp.gmail.com with ESMTPSA id d6sm746777ejy.114.2020.12.01.04.20.43
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 01 Dec 2020 04:20:43 -0800 (PST)
From: "javier.gonz@samsung.com" <javier@javigon.com>
X-Google-Original-From: "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Date: Tue, 1 Dec 2020 13:20:42 +0100
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Message-ID: <20201201122042.xvkdtyjuhb76nntp@MacBook-Pro.localdomain>
References: <CGME20201201054049epcas5p2e0118abda14aaf8d8bdcfb543bc330fc@epcas5p2.samsung.com>
	<20201201053949.143175-1-selvakuma.s1@samsung.com>
	<CH2PR04MB652240A4A23F89B26118FD66E7F40@CH2PR04MB6522.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <CH2PR04MB652240A4A23F89B26118FD66E7F40@CH2PR04MB6522.namprd04.prod.outlook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 02 Dec 2020 04:55:04 -0500
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>, "hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH 0/2] add simple copy support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 01.12.2020 11:22, Damien Le Moal wrote:
>+ Mike and DM list
>
>On 2020/12/01 16:12, SelvaKumar S wrote:
>> This patchset tries to add support for TP4065a ("Simple Copy Command"),
>> v2020.05.04 ("Ratified")
>>
>> The Specification can be found in following link.
>> https://nvmexpress.org/wp-content/uploads/NVM-Express-1.4-Ratified-TPs-1.zip
>>
>> This is an RFC. Looking forward for any feedbacks or other alternate
>> designs for plumbing simple copy to IO stack.
>>
>> Simple copy command is a copy offloading operation and is  used to copy
>> multiple contiguous ranges (source_ranges) of LBA's to a single destination
>> LBA within the device reducing traffic between host and device.
>>
>> This implementation accepts destination, no of sources and arrays of
>> source ranges from application and attach it as payload to the bio and
>> submits to the device.
>>
>> Following limits are added to queue limits and are exposed in sysfs
>> to userspace
>> 	- *max_copy_sectors* limits the sum of all source_range length
>> 	- *max_copy_nr_ranges* limits the number of source ranges
>> 	- *max_copy_range_sectors* limit the maximum number of sectors
>> 		that can constitute a single source range.
>
>This is interesting. I think there are several possible use in the kernel in
>various components: FS (btrfs rebalance, f2fs GC, liklely others) and DM at the
>very least.

Totally agree. We have more patches for simple copy, among others work
on F2FS that leverages for GC. We wanted to start with a simple patchset
enabling IOCTL to be an easy to review start. The rest of the patches
will come.


>However, your patches add support only for NVMe devices that have native support
>for simple copy, leaving all other block devices out. That seriously limits the
>use cases and also does not make this solution attractive since any use of it
>would need to be conditional on the underlying drive capabilities. That means
>more code for the file systems or device mapper developers and maintainers, not
>less.

Makes sense.

>
>To avoid this, I would suggest that this code be extended to add emulation for
>drives that do not implement simple copy natively. This would allow this
>interface to work on any block device, including SAS & SATA HDDs and RAID arrays.
>
>The emulation part of this copy service could I think be based on dm-kcopyd. See
>include/linux/dm-kcopyd.h for the interface. The current dm-kcopyd interface
>takes one source and multiple destination, the reverse of simple copy. But it
>would be fairly straightforward to also allow multiple sources and one
>destination. Simple copy native support would accelerate this case, everything
>else using the regular BIO read+write interface. Moving dm-kcopyd from DM
>infrastructure into the block layer as a set a generic block device sector copy
>service would allow its use in more places. And SCSI XCOPY could also be
>integrated in there as a different drive native support command.

Let us look into this. It makes sense.

It seems fair to start support bottom up from NVMe and then extend to
block layer and F2FS (potentially others). At this stage, we were
assuming that all the work that people like Martin, Bart and other have
been doing through the years on XCOPY could be integrated. Emulation can
be a part of this.

How can we move forward to do this in stages?

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

