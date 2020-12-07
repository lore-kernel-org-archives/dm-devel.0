Return-Path: <SRS0=+j0W=FL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NAME_EMAIL_DIFF,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67465C4361B
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 10:00:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DB19A2311B
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 10:00:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB19A2311B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-x2mUTHrMNgChLAf6MwQsqw-1; Mon, 07 Dec 2020 05:00:13 -0500
X-MC-Unique: x2mUTHrMNgChLAf6MwQsqw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6371EA0BD5;
	Mon,  7 Dec 2020 10:00:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 450FF60BE2;
	Mon,  7 Dec 2020 10:00:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1588E4EE7F;
	Mon,  7 Dec 2020 10:00:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B77kNCb004527 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Dec 2020 02:46:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 991C344027; Mon,  7 Dec 2020 07:46:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 92D4444007
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 07:46:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6978D858284
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 07:46:21 +0000 (UTC)
Received: from mail-ej1-f66.google.com (mail-ej1-f66.google.com
	[209.85.218.66]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-132-75FZTRVDNSeMJryiUZAMng-1; Mon, 07 Dec 2020 02:46:18 -0500
X-MC-Unique: 75FZTRVDNSeMJryiUZAMng-1
Received: by mail-ej1-f66.google.com with SMTP id m19so18041702ejj.11
	for <dm-devel@redhat.com>; Sun, 06 Dec 2020 23:46:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:date:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=H37Uk/40yzLuHJ510VKEIUp0RQ+PZefPT2yeqkErhUg=;
	b=eyjLdqXFhC/ZGNyhqEJKC6vRmZO7t2I/GKv/dKdzNFPxrfZJnSMir7x1ZI5Vn5MAxC
	0ejfo7n9qsSDflnOFMZ6APIftfyD6adIfEaZoku3t1gRlHPS/hG3LLbfHmVEcqVPl203
	aow7Ay9yW0zSWBsnF/DO5qyFt7YCTP+Q5xrzJL9IK/GFVz+X2FpNrZa5kN1YMB78bDxC
	JdHe2uGxXkZhqbufbT/qFqtEVUVZIphiY954UO21mUJn0T1EQzDe13BaQNa+n6QefIfN
	KgC0NFG8GmnQwF2IZ65BRU5lKXKQeaDe4gy1ygRvwM3SNr7JK8rpymNORaJXIaNRjOyT
	Cmhw==
X-Gm-Message-State: AOAM530rcoL8dGGfhpd/ITw3bakET9ooM0HEkFNZOt5nOENumqT1CTJx
	Bhy0Zpx87PLmk0KZP2z78NiNgA==
X-Google-Smtp-Source: ABdhPJzIa5O3cMvuafw6M6JqsvV9/GygQAIh8T7eOMf7z+MaNcc/rzLLg6xADVx25y95wFRUKMw1cg==
X-Received: by 2002:a17:906:12cf:: with SMTP id
	l15mr17565338ejb.540.1607327177482; 
	Sun, 06 Dec 2020 23:46:17 -0800 (PST)
Received: from localhost (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
	by smtp.gmail.com with ESMTPSA id
	z96sm5951767ede.81.2020.12.06.23.46.16
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sun, 06 Dec 2020 23:46:16 -0800 (PST)
From: "javier.gonz@samsung.com" <javier@javigon.com>
X-Google-Original-From: "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Date: Mon, 7 Dec 2020 08:46:16 +0100
To: Keith Busch <kbusch@kernel.org>
Message-ID: <20201207074616.mocdy6m5qgsn6yqg@mpHalley>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<CH2PR04MB6522F1188557C829285ED5E8E7F10@CH2PR04MB6522.namprd04.prod.outlook.com>
	<20201204144003.GA8868@redsun51.ssa.fujisawa.hgst.com>
MIME-Version: 1.0
In-Reply-To: <20201204144003.GA8868@redsun51.ssa.fujisawa.hgst.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 07 Dec 2020 04:59:37 -0500
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>, "hch@lst.de" <hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 04.12.2020 23:40, Keith Busch wrote:
>On Fri, Dec 04, 2020 at 11:25:12AM +0000, Damien Le Moal wrote:
>> On 2020/12/04 20:02, SelvaKumar S wrote:
>> > This patchset tries to add support for TP4065a ("Simple Copy Command"),
>> > v2020.05.04 ("Ratified")
>> >
>> > The Specification can be found in following link.
>> > https://nvmexpress.org/wp-content/uploads/NVM-Express-1.4-Ratified-TPs-1.zip
>> >
>> > This is an RFC. Looking forward for any feedbacks or other alternate
>> > designs for plumbing simple copy to IO stack.
>> >
>> > Simple copy command is a copy offloading operation and is  used to copy
>> > multiple contiguous ranges (source_ranges) of LBA's to a single destination
>> > LBA within the device reducing traffic between host and device.
>> >
>> > This implementation accepts destination, no of sources and arrays of
>> > source ranges from application and attach it as payload to the bio and
>> > submits to the device.
>> >
>> > Following limits are added to queue limits and are exposed in sysfs
>> > to userspace
>> > 	- *max_copy_sectors* limits the sum of all source_range length
>> > 	- *max_copy_nr_ranges* limits the number of source ranges
>> > 	- *max_copy_range_sectors* limit the maximum number of sectors
>> > 		that can constitute a single source range.
>>
>> Same comment as before. I think this is a good start, but for this to be really
>> useful to users and kernel components alike, this really needs copy emulation
>> for drives that do not have a native copy feature, similarly to what write zeros
>> handling for instance: if the drive does not have a copy command (simple copy
>> for NVMe or XCOPY for scsi), then the block layer should issue read/write
>> commands to seamlessly execute the copy. Otherwise, this will only serve a small
>> niche for users and will not be optimal for FS and DM drivers that could be
>> simplified with a generic block layer copy functionality.
>>
>> This is my 10 cents though, others may differ about this.
>
>Yes, I agree that copy emulation support should be included with the
>hardware enabled solution.

Keith, Damien,

Can we do the block layer emulation with this patchset and then work in
follow-up patchses on (i) the FS interface with F2FS as a first user and
(ii) other HW accelerations such as XCOPY?

For XCOPY, I believe we need to have a separate discussion as much works
is already done that we should align to.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

