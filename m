Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 737ADC004D4
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 19:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661370204;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=sa29Py0TPz3jtjFgoESxNoR6o34w/yfSp7t0P+p6gxU=;
	b=NWdJaEigSU2G6rX2kEDD8zFT9AbC5tsFk8lS7S/BlvItf1Busmyn68euveVNginkOxCMOA
	KvoHNaQIm1cK07CAXyUvSG50MMXwQrjbdcCa5E3ya8MEqT/dBfNWyC0YXc3BED/97rmvrA
	D8b8I/QpGr/nJrhdlFBxQhEfpSj/cIY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-wL5MJue5OkSAvCK0Bi06Ow-1; Wed, 24 Aug 2022 15:43:20 -0400
X-MC-Unique: wL5MJue5OkSAvCK0Bi06Ow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7372A85A58C;
	Wed, 24 Aug 2022 19:43:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C334C2166B26;
	Wed, 24 Aug 2022 19:43:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9B3A51946A47;
	Wed, 24 Aug 2022 19:43:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C2CB41946A43
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 19:42:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B0B43492CA5; Wed, 24 Aug 2022 19:42:39 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AB107492C3B;
 Wed, 24 Aug 2022 19:42:39 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 27OJgd1d002422; Wed, 24 Aug 2022 15:42:39 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 27OJgdxF002418; Wed, 24 Aug 2022 15:42:39 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Wed, 24 Aug 2022 15:42:39 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Coly Li <colyli@suse.de>
In-Reply-To: <120284F5-514F-4EA0-A0AE-8B759FF78931@suse.de>
Message-ID: <alpine.LRH.2.02.2208241530300.1585@file01.intranet.prod.int.rdu2.redhat.com>
References: <120284F5-514F-4EA0-A0AE-8B759FF78931@suse.de>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] A kernel panic (or soft lockup) due to stack
 overflow by recursive dm-table reload
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: MULTIPART/MIXED; BOUNDARY="185206533-1512172974-1661369485=:1585"
Content-ID: <alpine.LRH.2.02.2208241532400.1585@file01.intranet.prod.int.rdu2.redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185206533-1512172974-1661369485=:1585
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LRH.2.02.2208241532401.1585@file01.intranet.prod.int.rdu2.redhat.com>



On Thu, 25 Aug 2022, Coly Li wrote:

> Hi folks,
> 
> Recently I received a bug report from Intel developers (big thanks), the 
> kernel panic is caused by a kernel stack overflow and it seems from a 
> recursive dm-table reload.
> 
> Here is the simplified process to reproduce the panic, I use three 960GB name SSDs.
> 
> 1, create 2 dm devices,
> # echo '0 181065567 linear /dev/nvme2n1 0' | dmsetup create nvme2n1bbm
> # echo '0 196616709 linear /dev/nvme3n1 0' | dmsetup create nvm3n1bbm
> 
> 2, create a raid with these dm devices and another nvme SSD,
> # mdadm -C /dev/md0 -l 5 -n 3 /dev/nvme4n1 /dev/dm-0 /dev/dm-1
> 
> 3, wait for resync to finish
> 
> 4, stop the md array
> # mdadm —manage —stop /dev/md0
> 
> 5, reload dm table for dm-0
> # cat dm-table-reload | dmsetup reload /dev/dm-0
> And the content of dm-table-reload is,
> 	0 1 linear /dev/dm-0 0
> 	1 181065566 linear /dev/dm-0 1 
> 
> 6, suspend and resume dm-0
> # dmsetup suspend /dev/dm-0
> # dmsetup resume /dev/dm-0
> 
> The panic can be reproduced in Linux-v5.3 kernel[1], and it changes to 
> silent deadlock after minutes in Linux v6.0-rc2. So the problem should 
> still exist in upstream kernel.
> 
> My question are,
> 1) Does anyone observe or encounter such panic or deadlock before?
> 2) To permit recursive dm-table reload, is it a bug or just as-designed ?
> 
> Thanks in advance.
> 
> Coly Li

Hi

I would just say "don't do this".

Note that only root can reload dm table, so there are no security 
implications in this. And if someone has root, he can do much more harm 
than crashing the system with kernel stack overflow.

Recursive table mappings or very deep non-recursive mappings aren't 
supposed to work.

Mikulas
--185206533-1512172974-1661369485=:1585
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--185206533-1512172974-1661369485=:1585--

