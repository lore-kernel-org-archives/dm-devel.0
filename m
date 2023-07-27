Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DCC0C04A6A
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690471808;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8tDARzdqnP9nZQElieKeP4OLsRHq1X8l/991RAsSwes=;
	b=gCHunL0ac6yC8peT8njMWFAOkN2ZOBS+VUWDYiPQQI1BFw+VLZNoLiQs0ZBV1B52YcU5cq
	dfgACshMH6iS9Pmfh2PhHNm//ebAb09J6mKbJqw8oH0CnwfoR+0fAFX5PNoDeiah6J1PkI
	vJT66Iz/+nZGCL0UzCx4XpWNpeI7lbs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-k-xKQeytPPqbzweQ-O0SUA-1; Thu, 27 Jul 2023 11:30:04 -0400
X-MC-Unique: k-xKQeytPPqbzweQ-O0SUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F7FE185A7A8;
	Thu, 27 Jul 2023 15:30:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A43C201F11C;
	Thu, 27 Jul 2023 15:30:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DB5E31946A45;
	Thu, 27 Jul 2023 15:30:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8ECA61946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Jul 2023 15:30:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6270F4094DC1; Thu, 27 Jul 2023 15:30:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B1F94094DC0
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 15:30:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CF72185A793
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 15:30:00 +0000 (UTC)
Received: from box.fidei.email (box.fidei.email [71.19.144.250]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-2-EF2LETjvM4KR5EiafIbDiA-1; Thu,
 27 Jul 2023 11:29:55 -0400
X-MC-Unique: EF2LETjvM4KR5EiafIbDiA-1
Received: from authenticated-user (box.fidei.email [71.19.144.250])
 (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
 (No client certificate requested)
 by box.fidei.email (Postfix) with ESMTPSA id 391C983618;
 Thu, 27 Jul 2023 11:29:52 -0400 (EDT)
Message-ID: <f62c9dd4-08e6-4b00-a05d-4071e87405a7@dorminy.me>
Date: Thu, 27 Jul 2023 11:29:51 -0400
MIME-Version: 1.0
From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To: Ken Raeburn <raeburn@redhat.com>
References: <20230523214539.226387-1-corwin@redhat.com>
 <ZLa086NuWiMkJKJE@redhat.com>
 <CAK1Ur396ThV5AAZx2336uAW3FqSY+bHiiwEPofHB_Kwwr4ag5A@mail.gmail.com>
 <509f4916-a95f-216e-b0ab-7b7a108a48a0@dorminy.me> <87bkfy9riw.fsf@redhat.com>
In-Reply-To: <87bkfy9riw.fsf@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [vdo-devel] [PATCH v2 00/39] Add the dm-vdo
 deduplication and compression device mapper target.
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
Cc: vdo-devel@redhat.com, ebiggers@kernel.org,
 Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, tj@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: dorminy.me
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"


> 
>> If kernel workqueues have higher overhead per item for the lightweight
>> work VDO currently does in each step, perhaps the dual of the current
>> scheme would let more work get done per fixed queuing overhead, and
>> thus perform better? VIOs could take locks on sections of structures,
>> and operate on multiple structures before requeueing.
> 
> Can you suggest a little more specifically what the "dual" is you're
> picturing?

It sounds like your experiment consisted of one kernel workqueue per 
existing thread, with VIOs queueing on each thread in turn precisely as 
they do at present, so that when the VIO work item is running it's 
guaranteed to be the unique actor on a particular set of structures 
(e.g. for a physical thread the physical zone and slabs).

I am thinking of an alternate scheme where e.g. each slab, each block 
map zone, each packer would be protected by a lock instead of owned by a 
thread. There would be one workqueue with concurrency allowed where all 
VIOs would operate.

VIOs would do an initial queuing on a kernel workqueue, and then when 
the VIO work item would run, they'd take and hold the appropriate locks 
while they operated on each structure. So they'd take and release slab 
locks until they found a free block; send off to UDS and get requeued 
when it came back or the timer expired; try to compress and take/release 
a lock on the packer while adding itself to a bin and get requeued if 
appropriate when the packer released it; write and requeue when the 
write finishes if relevant. Then I think the 'make whatever modification 
to structures is relevant' part can be done without any requeue: take 
and release the recovery journal lock; ditto on the relevant slab; again 
the journal; again the other slab; then the part of the block map; etc.

Yes, there's the intriguing ordering requirements to work through, but 
maybe as an initial performance experiment the ordering can be ignored 
to get an idea of whether this scheme could provide acceptable performance.

> There are also occasionally non-VIO objects which get queued to invoke
> actions on various threads, which I expect might further complicate the
> experiment.

I think that's the easy part -- queueing a work item to grab a lock and 
Do Something seems to me a pretty common thing in the kernel code. 
Unless there are ordering requirements among the non-vios I'm not 
calling to mind.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

