Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 833A7C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 20:31:58 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-ir8CtmZeNZGeNH5P03XtaQ-1; Fri, 19 Nov 2021 15:31:53 -0500
X-MC-Unique: ir8CtmZeNZGeNH5P03XtaQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2A6210B7440;
	Fri, 19 Nov 2021 20:31:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C0BA5FC25;
	Fri, 19 Nov 2021 20:31:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD1FB4A703;
	Fri, 19 Nov 2021 20:31:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AJKVgKN013766 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Nov 2021 15:31:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 52703404727C; Fri, 19 Nov 2021 20:31:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D9B64047279
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 20:31:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35BAC800C00
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 20:31:42 +0000 (UTC)
Received: from yourcmc.ru (yourcmc.ru [195.209.40.11]) by relay.mimecast.com
	with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-86-35cBoXOxP465X0vUTiQ0cg-1; Fri, 19 Nov 2021 15:31:40 -0500
X-MC-Unique: 35cBoXOxP465X0vUTiQ0cg-1
Received: from yourcmc.ru (localhost [127.0.0.1])
	by yourcmc.ru (Postfix) with ESMTP id E8417FE0662
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 23:31:38 +0300 (MSK)
Received: from rainloop.yourcmc.ru (yourcmc.ru [195.209.40.11])
	by yourcmc.ru (Postfix) with ESMTPSA id D381FFE0658
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 23:31:38 +0300 (MSK)
MIME-Version: 1.0
Date: Fri, 19 Nov 2021 20:31:38 +0000
From: vitalif@yourcmc.ru
Message-ID: <431f30390fd3a32cb4445d024524e45a@yourcmc.ru>
To: dm-devel@redhat.com
In-Reply-To: <8b08d35705cd7a03f46209e2a7dad64a@yourcmc.ru>
References: <8b08d35705cd7a03f46209e2a7dad64a@yourcmc.ru>
X-Virus-Scanned: ClamAV using ClamSMTP
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AJKVgKN013766
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Even worse, dm-linear has the same problem.

dm-linear over mdadm RAID5 doesn't support discard while mdadm device itself supports it.

> Hi!
> 
> A dm-era device created over a RAID5 array loses discard support.
> 
> Test script is attached.
> 
> If you run it on SSD you'll see something like:
> 
> loop0 4096
> loop1 4096
> loop2 4096
> loop3 4096
> md55 1048576
> loop_test_era 0
> 
> I.e. mdadm device supports discard, but dm-era device started over it doesn't.
> 
> If you create a dm-era device over a normal block device without mdadm RAID5 or even over mdadm
> RAID1 - it will preserve discard support.
> 
> Why? How can it be fixed?
> 
> -- 
> With best regards,
> Vitaliy Filippov
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

