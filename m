Return-Path: <SRS0=UIu2=FN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050B9C4361B
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:58:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 52A5D23433
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:58:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52A5D23433
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-Llsm092MMuWdaouvYM9wLw-1; Wed, 09 Dec 2020 04:57:57 -0500
X-MC-Unique: Llsm092MMuWdaouvYM9wLw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F61E6D52B;
	Wed,  9 Dec 2020 09:57:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E9F95C234;
	Wed,  9 Dec 2020 09:57:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D87101809CA1;
	Wed,  9 Dec 2020 09:57:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B7JEX3k013701 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Dec 2020 14:14:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D3DAF2166B27; Mon,  7 Dec 2020 19:14:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE73F2166B2A
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 19:14:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65765811E76
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 19:14:31 +0000 (UTC)
Received: from mail-ed1-f65.google.com (mail-ed1-f65.google.com
	[209.85.208.65]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-504-u-W_r-V0MVuVwzV8RFbzxw-1; Mon, 07 Dec 2020 14:14:27 -0500
X-MC-Unique: u-W_r-V0MVuVwzV8RFbzxw-1
Received: by mail-ed1-f65.google.com with SMTP id c7so14937289edv.6
	for <dm-devel@redhat.com>; Mon, 07 Dec 2020 11:14:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:date:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=jmde5DLX9qAtIBMJ/NIdWYTAYpRwSsr9Odz1F7TWunw=;
	b=nqm6MDRAVGwkIGmlBgscbX5QBMQLB10AUhxDH1UVABioOKCCVExoVKsGnZrvQD+9XT
	9DlrDEWCDESwH9JkIJ3MpHTRYf0EYd7eIEidw28zAujt9bpopfXUX6+lQjTX6EzWN2Y9
	YlIM3MPWaWAQkRWCEG3L4VyAGNJFRdTdrRvQq99kloJUJT3fnXxAQCNu15NxNjQFH/V4
	vm/Ex+N/w5guZ2e2LkVTPlsTxY9ELLzX2H08/j9IHpkqU207YFHZFXXgUwh0J9Uy7ier
	RBB9EcmqiVRphSaX2az1xWX+OW4OtE65byubazqDbpMt2bxyC0ZdjnE3pgwGF5s3UpeA
	WiCw==
X-Gm-Message-State: AOAM533nuElUIlpdFwbUZVUkUBbBBkrLIbOki2jR8gwDtLNzFhUCMP2H
	ek/ZwcuQSrDQc/WWGkKTwQ3wYg==
X-Google-Smtp-Source: ABdhPJwAxYlw0xJXIJ41PWVh5rYvbijBwYLzNksYRS3VcSJC/SMdkG5LM2Q6gxg67VeNVe1TazaBGA==
X-Received: by 2002:a50:fe8d:: with SMTP id d13mr20530601edt.132.1607368465788;
	Mon, 07 Dec 2020 11:14:25 -0800 (PST)
Received: from localhost (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
	by smtp.gmail.com with ESMTPSA id l1sm5898215eje.12.2020.12.07.11.14.24
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 07 Dec 2020 11:14:25 -0800 (PST)
From: "Javier =?utf-8?B?R29uesOhbGV6?=" <javier@javigon.com>
X-Google-Original-From: Javier =?utf-8?B?R29uesOhbGV6?=
	<javier.gonz@samsung.com>
Date: Mon, 7 Dec 2020 20:14:24 +0100
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201207191424.bzwoonfpxknbbqlc@mpHalley>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<20201207141123.GC31159@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201207141123.GC31159@lst.de>
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
X-Mailman-Approved-At: Wed, 09 Dec 2020 04:56:16 -0500
Cc: axboe@kernel.dk, damien.lemoal@wdc.com,
	SelvaKumar S <selvakuma.s1@samsung.com>, sagi@grimberg.me,
	snitzer@redhat.com, selvajove@gmail.com,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, joshi.k@samsung.com,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	kbusch@kernel.org, linux-scsi@vger.kernel.org,
	nj.shetty@samsung.com, Bart Van Assche <bvanassche@acm.org>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 07.12.2020 15:11, Christoph Hellwig wrote:
>So, I'm really worried about:
>
> a) a good use case.  GC in f2fs or btrfs seem like good use cases, as
>    does accelating dm-kcopyd.  I agree with Damien that lifting dm-kcopyd
>    to common code would also be really nice.  I'm not 100% sure it should
>    be a requirement, but it sure would be nice to have
>    I don't think just adding an ioctl is enough of a use case for complex
>    kernel infrastructure.

We are looking at dm-kcopyd. I would have liked to start with a very
specific use case and build from there, but I see Damien's and Keith's
point of having a default path. I believe we can add this to the next
version.

> b) We had a bunch of different attempts at SCSI XCOPY support form IIRC
>    Martin, Bart and Mikulas.  I think we need to pull them into this
>    discussion, and make sure whatever we do covers the SCSI needs.

Agree. We discussed a lot about the scope and agreed that everything
outside of the specifics of Simple Copy requires the input from the ones
that have worked on XCOPY support in the past.

>
>On Fri, Dec 04, 2020 at 03:16:57PM +0530, SelvaKumar S wrote:
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
>>
>> Changes from v1:
>>
>> 1. Fix memory leak in __blkdev_issue_copy
>> 2. Unmark blk_check_copy inline
>> 3. Fix line break in blk_check_copy_eod
>> 4. Remove p checks and made code more readable
>> 5. Don't use bio_set_op_attrs and remove op and set
>>    bi_opf directly
>> 6. Use struct_size to calculate total_size
>> 7. Fix partition remap of copy destination
>> 8. Remove mcl,mssrl,msrc from nvme_ns
>> 9. Initialize copy queue limits to 0 in nvme_config_copy
>> 10. Remove return in QUEUE_FLAG_COPY check
>> 11. Remove unused OCFS
>>
>> SelvaKumar S (2):
>>   block: add simple copy support
>>   nvme: add simple copy support
>>
>>  block/blk-core.c          |  94 ++++++++++++++++++++++++++---
>>  block/blk-lib.c           | 123 ++++++++++++++++++++++++++++++++++++++
>>  block/blk-merge.c         |   2 +
>>  block/blk-settings.c      |  11 ++++
>>  block/blk-sysfs.c         |  23 +++++++
>>  block/blk-zoned.c         |   1 +
>>  block/bounce.c            |   1 +
>>  block/ioctl.c             |  43 +++++++++++++
>>  drivers/nvme/host/core.c  |  87 +++++++++++++++++++++++++++
>>  include/linux/bio.h       |   1 +
>>  include/linux/blk_types.h |  15 +++++
>>  include/linux/blkdev.h    |  15 +++++
>>  include/linux/nvme.h      |  43 ++++++++++++-
>>  include/uapi/linux/fs.h   |  13 ++++
>>  14 files changed, 461 insertions(+), 11 deletions(-)
>>
>> --
>> 2.25.1
>---end quoted text---

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

