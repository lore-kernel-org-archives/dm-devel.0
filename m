Return-Path: <SRS0=UIu2=FN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76315C4361B
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:57:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C1A3C23433
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:57:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1A3C23433
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=javigon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-hb3mCaY2Plm8591Rk73oUw-1; Wed, 09 Dec 2020 04:57:09 -0500
X-MC-Unique: hb3mCaY2Plm8591Rk73oUw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53750809DD6;
	Wed,  9 Dec 2020 09:57:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 332565C266;
	Wed,  9 Dec 2020 09:57:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D21B75002F;
	Wed,  9 Dec 2020 09:57:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B7JP2ct014526 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Dec 2020 14:25:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CD6841004059; Mon,  7 Dec 2020 19:25:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C89C91112862
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 19:25:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D296100B165
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 19:25:00 +0000 (UTC)
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com
	[209.85.218.67]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-324-AHMT8Sk1PNG-OXgA5rlMxA-1; Mon, 07 Dec 2020 14:24:56 -0500
X-MC-Unique: AHMT8Sk1PNG-OXgA5rlMxA-1
Received: by mail-ej1-f67.google.com with SMTP id f23so21174370ejk.2
	for <dm-devel@redhat.com>; Mon, 07 Dec 2020 11:24:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:date:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=IVD1p2kuvVXrBfr0DQp8uX8UYpU8DuPwPA/j+U9iw7o=;
	b=j+9t6v3Vz+3KwH56VQKuH6deqe1YLY4fK9nWkj0CSxy5m9NohDlNO6EC6uApMzdodA
	ldGt1Ci9YytCDBqFvFMuQnsLYHC3ciF59iGvy+bD9G2/yjAlJmphho/PNO4RXFEcnQX1
	s524FyhMeVUqZo7UN8gKFB76+op+YzxSwTzj3w/3Vwu8/xXdYtCgX+J6IJeyZy1EBsoR
	S17bx8YkJ5qT+TX1Edsi8yXV+lIXUPHYQ2+wsSic0Qw1kb/Lv4UO1vk5FW5qE1cLTehV
	LSXRSzG72moURYE0/uXxMYcRH8y3eXNMPH0cnGAl9xCtSHiBxiw+Ec+K+F70Qm/ue1Yk
	RxMg==
X-Gm-Message-State: AOAM533WOn/sXXNxxmf+7a4LiWQoiU63PgdT0pOPCKBfs/ZBX/dS7zR8
	Hs0NpB3bKcAW75NzySicV2eNZQ==
X-Google-Smtp-Source: ABdhPJz9bYSQy3NHjmWx84lzpD6uTWLsBYmyjEhdoYT4EzGm+iefSEkI4OwWBZ212/zNmk1iIBD9rw==
X-Received: by 2002:a17:906:b08b:: with SMTP id
	x11mr20225762ejy.302.1607369095020; 
	Mon, 07 Dec 2020 11:24:55 -0800 (PST)
Received: from localhost (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
	by smtp.gmail.com with ESMTPSA id
	b17sm13218700eju.76.2020.12.07.11.24.54
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 07 Dec 2020 11:24:54 -0800 (PST)
From: "Javier =?utf-8?B?R29uesOhbGV6?=" <javier@javigon.com>
X-Google-Original-From: Javier =?utf-8?B?R29uesOhbGV6?=
	<javier.gonz@samsung.com>
Date: Mon, 7 Dec 2020 20:24:53 +0100
To: Hannes Reinecke <hare@suse.de>
Message-ID: <20201207192453.vc6clbdhz73hzs7l@mpHalley>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<20201207141123.GC31159@lst.de>
	<01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
MIME-Version: 1.0
In-Reply-To: <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
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
X-Mailman-Approved-At: Wed, 09 Dec 2020 04:56:16 -0500
Cc: axboe@kernel.dk, damien.lemoal@wdc.com,
	SelvaKumar S <selvakuma.s1@samsung.com>, sagi@grimberg.me,
	snitzer@redhat.com, selvajove@gmail.com,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	nj.shetty@samsung.com, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	joshi.k@samsung.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
	kbusch@kernel.org, linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
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

On 07.12.2020 15:56, Hannes Reinecke wrote:
>On 12/7/20 3:11 PM, Christoph Hellwig wrote:
>>So, I'm really worried about:
>>
>>  a) a good use case.  GC in f2fs or btrfs seem like good use cases, as
>>     does accelating dm-kcopyd.  I agree with Damien that lifting dm-kcopyd
>>     to common code would also be really nice.  I'm not 100% sure it should
>>     be a requirement, but it sure would be nice to have
>>     I don't think just adding an ioctl is enough of a use case for complex
>>     kernel infrastructure.
>>  b) We had a bunch of different attempts at SCSI XCOPY support form IIRC
>>     Martin, Bart and Mikulas.  I think we need to pull them into this
>>     discussion, and make sure whatever we do covers the SCSI needs.
>>
>And we shouldn't forget that the main issue which killed all previous 
>implementations was a missing QoS guarantee.
>It's nice to have simply copy, but if the implementation is _slower_ 
>than doing it by hand from the OS there is very little point in even 
>attempting to do so.
>I can't see any provisions for that in the TPAR, leading me to the 
>assumption that NVMe simple copy will suffer from the same issue.
>
>So if we can't address this I guess this attempt will fail, too.

Good point. We can share some performance data on how Simple Copy scales
in terms of bw / latency and the CPU usage. Do you have anything else in
mind?

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

