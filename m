Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 407FCC001B0
	for <dm-devel@archiver.kernel.org>; Sun, 23 Jul 2023 06:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690093958;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sJBD74Tz/NtqtWkvgB6my3lA42AiR68JXtFMoSJf/WY=;
	b=h9JtxDPS7dZ1aZ/4TPmMDl08pRNYb3LhplJz1nOCEcIpO572eghJ4fFd5ZuSMnBGIRxvx7
	teRh3Z0m09L7Jwz3GfMMzmwQmZtQ7QTPKQSIAoFUVBUZXKNzW58v1MmKhnb7TN/V8l1pyP
	HOAkBAF5ScVNH1GoK0VslIP6Gm+15gc=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-530-r0r9xdAQPUiWnrGVnYb2cg-1; Sun, 23 Jul 2023 02:32:34 -0400
X-MC-Unique: r0r9xdAQPUiWnrGVnYb2cg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC2042A5956B;
	Sun, 23 Jul 2023 06:32:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 09A0DC2C856;
	Sun, 23 Jul 2023 06:32:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A9D4819451DA;
	Sun, 23 Jul 2023 06:32:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1874019451CF
 for <dm-devel@listman.corp.redhat.com>; Sun, 23 Jul 2023 06:32:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 78338200C0F2; Sun, 23 Jul 2023 06:32:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 70F53200C0C4
 for <dm-devel@redhat.com>; Sun, 23 Jul 2023 06:32:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36C7A3C0C481
 for <dm-devel@redhat.com>; Sun, 23 Jul 2023 06:32:15 +0000 (UTC)
Received: from box.fidei.email (box.fidei.email [71.19.144.250]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-321-zTwahXtMPOqwvHUMsnOQRw-1; Sun,
 23 Jul 2023 02:32:10 -0400
X-MC-Unique: zTwahXtMPOqwvHUMsnOQRw-1
Received: from authenticated-user (box.fidei.email [71.19.144.250])
 (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
 (No client certificate requested)
 by box.fidei.email (Postfix) with ESMTPSA id 17E068356D;
 Sun, 23 Jul 2023 02:24:34 -0400 (EDT)
Message-ID: <509f4916-a95f-216e-b0ab-7b7a108a48a0@dorminy.me>
Date: Sun, 23 Jul 2023 02:24:32 -0400
MIME-Version: 1.0
To: Kenneth Raeburn <raeburn@redhat.com>, Mike Snitzer <snitzer@kernel.org>
References: <20230523214539.226387-1-corwin@redhat.com>
 <ZLa086NuWiMkJKJE@redhat.com>
 <CAK1Ur396ThV5AAZx2336uAW3FqSY+bHiiwEPofHB_Kwwr4ag5A@mail.gmail.com>
From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <CAK1Ur396ThV5AAZx2336uAW3FqSY+bHiiwEPofHB_Kwwr4ag5A@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
Cc: linux-block@vger.kernel.org, vdo-devel@redhat.com, dm-devel@redhat.com,
 tj@kernel.org, ebiggers@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: dorminy.me
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"


> We use a sort of message-passing arrangement where a worker thread is 
> responsible for updating certain data structures as needed for the I/Os 
> in progress, rather than having the processing of each I/O contend for 
> locks on the data structures.  It gives us some good throughput under load but it does mean upwards of a dozen handoffs per 4kB write, depending on compressibility, whether the block is a duplicate, and various other factors. So processing 1 GB/s means handling over 3M messages per second, though each step of processing is generally lightweight. 

  There seems a natural duality between
work items passing between threads, each exclusively owning a structure, 
vs structures passing between threads, each exclusively owning a work 
item. In the first, the threads are grabbing a notional 'lock' on each 
item in turn to deal with their structure, as VDO does now; in the 
second, the threads are grabbing locks on each structure in turn to deal 
with their item.

If kernel workqueues have higher overhead per item for the lightweight 
work VDO currently does in each step, perhaps the dual of the current 
scheme would let more work get done per fixed queuing overhead, and thus 
perform better? VIOs could take locks on sections of structures, and 
operate on multiple structures before requeueing.

This might also enable more finegrained locking of structures than the 
chunks uniquely owned by threads at the moment. It would also be 
attractive to let the the kernel work queues deal with concurrency 
management instead of configuring the number of threads for each of a 
bunch of different structures at start time.

On the other hand, I played around with switching messagepassing to 
structurelocking in VDO a number of years ago for fun on the side, just 
extremely naively replacing each message passing with releasing a mutex 
on the current set of structures and (trying to) take a mutex on the 
next set of structures, and ran into some complexity around certain 
ordering requirements. I think they were around recovery journal entries 
going into the slab journal and the block map in the same order; and 
also around the use of different priorities for some different items. I 
don't have that code anymore, unfortunately, so I don't know how hard it 
would be to try that experiment again.

Sweet Tea

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

