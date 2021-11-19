Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 897BCC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 22:43:24 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-BIurTT9XNnibSYQLtwE4HQ-1; Fri, 19 Nov 2021 17:43:19 -0500
X-MC-Unique: BIurTT9XNnibSYQLtwE4HQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 591A61DDE1;
	Fri, 19 Nov 2021 22:43:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E368019D9D;
	Fri, 19 Nov 2021 22:43:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 99D911832E81;
	Fri, 19 Nov 2021 22:43:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AJMhAeI024136 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Nov 2021 17:43:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6B2322026D67; Fri, 19 Nov 2021 22:43:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 64C502026D5D
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 22:43:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25AA18032EB
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 22:43:06 +0000 (UTC)
Received: from yourcmc.ru (yourcmc.ru [195.209.40.11]) by relay.mimecast.com
	with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-274-Fj9Bvv-6N3yFzzRDJbaUqA-1; Fri, 19 Nov 2021 17:43:04 -0500
X-MC-Unique: Fj9Bvv-6N3yFzzRDJbaUqA-1
Received: from yourcmc.ru (localhost [127.0.0.1])
	by yourcmc.ru (Postfix) with ESMTP id CCEECFE0665
	for <dm-devel@redhat.com>; Sat, 20 Nov 2021 01:43:02 +0300 (MSK)
Received: from rainloop.yourcmc.ru (yourcmc.ru [195.209.40.11])
	by yourcmc.ru (Postfix) with ESMTPSA id B87EEFE0661
	for <dm-devel@redhat.com>; Sat, 20 Nov 2021 01:43:02 +0300 (MSK)
MIME-Version: 1.0
Date: Fri, 19 Nov 2021 22:43:02 +0000
From: vitalif@yourcmc.ru
Message-ID: <79362b760a65c75d75c17ec1537ccf60@yourcmc.ru>
To: dm-devel@redhat.com
In-Reply-To: <431f30390fd3a32cb4445d024524e45a@yourcmc.ru>
References: <431f30390fd3a32cb4445d024524e45a@yourcmc.ru>
	<8b08d35705cd7a03f46209e2a7dad64a@yourcmc.ru>
X-Virus-Scanned: ClamAV using ClamSMTP
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AJMhAeI024136
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] dm-era over mdadm raid5 loses discard support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

Just to note, the problem is solved by setting raid456.devices_handle_discard_safely=Y in kernel command line.

It seems that dm-table.c checks for blk_queue_discard() of underlying devices and RAID5 device has the QUEUE_FLAG_DISCARD unset and at the same time discard_granularity != 0. So discards actually work even without raid456.devices_handle_discard_safely=Y, but aren't passed via the DM device.

> Even worse, dm-linear has the same problem.
> 
> dm-linear over mdadm RAID5 doesn't support discard while mdadm device itself supports it.
> 
>> Hi!
>> 
>> A dm-era device created over a RAID5 array loses discard support.
>> 
>> Test script is attached.
>> 
>> If you run it on SSD you'll see something like:
>> 
>> loop0 4096
>> loop1 4096
>> loop2 4096
>> loop3 4096
>> md55 1048576
>> loop_test_era 0
>> 
>> I.e. mdadm device supports discard, but dm-era device started over it doesn't.
>> 
>> If you create a dm-era device over a normal block device without mdadm RAID5 or even over mdadm
>> RAID1 - it will preserve discard support.
>> 
>> Why? How can it be fixed?
>> 
>> --
>> With best regards,
>> Vitaliy Filippov
>> 
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://listman.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

