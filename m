Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 471A4C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 12:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643976572;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=H5I8vVNsawn5E63OlbtfQoDt+PCkiPnH1KPWzvE3NxY=;
	b=ce70/q4q6CU+mNjTtF7nzQN7UHIeyEAi642STMWRAVa9mTrY5yp2BUTEwmL8MRke+MJoBz
	x1A4gQ2TysXubd0iX7pMhPczCsaMRoMMw+hCgxrVXoulfbcrhX/GVNyB3BNuFt8U6MU1Fn
	joeUXyLI3OZWkWryCHaK0AMTO+GV7JU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-y-Qm7Xx8MdCyYlUSkoQ5zw-1; Fri, 04 Feb 2022 07:09:28 -0500
X-MC-Unique: y-Qm7Xx8MdCyYlUSkoQ5zw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 894D294DC8;
	Fri,  4 Feb 2022 12:09:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C75956A8A;
	Fri,  4 Feb 2022 12:09:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4255D1809CB8;
	Fri,  4 Feb 2022 12:09:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 214C9H22021021 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 07:09:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AFD9F78805; Fri,  4 Feb 2022 12:09:17 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 914F178A9E;
	Fri,  4 Feb 2022 12:09:09 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 214C99wH019986; Fri, 4 Feb 2022 07:09:09 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 214C97pr019978; Fri, 4 Feb 2022 07:09:07 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Fri, 4 Feb 2022 07:09:07 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a2ec9086-72d2-4a4e-c4fa-fe53bf5ba092@acm.org>
Message-ID: <alpine.LRH.2.02.2202040657060.19134@file01.intranet.prod.int.rdu2.redhat.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011331570.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<efd2e976-4d2d-178e-890d-9bde1a89c47f@acm.org>
	<alpine.LRH.2.02.2202031310530.28604@file01.intranet.prod.int.rdu2.redhat.com>
	<a2ec9086-72d2-4a4e-c4fa-fe53bf5ba092@acm.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [dm-devel] [RFC PATCH 1/3] block: add copy offload support
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Thu, 3 Feb 2022, Bart Van Assche wrote:

> On 2/3/22 10:50, Mikulas Patocka wrote:
> > On Tue, 1 Feb 2022, Bart Van Assche wrote:
> > > On 2/1/22 10:32, Mikulas Patocka wrote:
> > > >    /**
> > > > + * blk_queue_max_copy_sectors - set maximum copy offload sectors for
> > > > the
> > > > queue
> > > > + * @q:  the request queue for the device
> > > > + * @size:  the maximum copy offload sectors
> > > > + */
> > > > +void blk_queue_max_copy_sectors(struct request_queue *q, unsigned int
> > > > size)
> > > > +{
> > > > +	q->limits.max_copy_sectors = size;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(blk_queue_max_copy_sectors);
> > > 
> > > Please either change the unit of 'size' into bytes or change its type into
> > > sector_t.
> > 
> > blk_queue_chunk_sectors, blk_queue_max_discard_sectors,
> > blk_queue_max_write_same_sectors, blk_queue_max_write_zeroes_sectors,
> > blk_queue_max_zone_append_sectors also have the unit of sectors and the
> > argument is "unsigned int". Should blk_queue_max_copy_sectors be
> > different?
> 
> As far as I know using the type sector_t for variables that represent a number
> of sectors is a widely followed convention:
> 
> $ git grep -w sector_t | wc -l
> 2575
> 
> I would appreciate it if that convention would be used consistently, even if
> that means modifying existing code.
> 
> Thanks,
> 
> Bart.

Changing the sector limit variables in struct queue_limits from unsigned 
int to sector_t would increase the size of the structure and its cache 
footprint.

And we can't send bios larger than 4GiB anyway because bi_size is 32-bit.

Jens, what do you think about it? Should the sectors limits be sector_t?

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

