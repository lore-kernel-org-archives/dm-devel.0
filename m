Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A1F1C001DC
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jul 2023 21:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689716083;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=t3X2Z22vcgqyqRdDTdn7yIHzBcHJMzLN+6ANHrFeyuU=;
	b=YJEcoGnm4TwMyOBPSYI2Ps1DtHahmF65RWnmH1AeO40DnJTvoaR5lXd7w076lOvzoZ+cqL
	l9btsOtjxiZ8RmkmXuM3eY7Y64MsiqTOGe9nmelRPDe7huvNLod2tRPtzyoOUfzRea78bt
	67lhOVdyxjxREH0+x9GF9/JJVo1TBog=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-hoVkQSKvOL68lN9M67sXcw-1; Tue, 18 Jul 2023 17:34:42 -0400
X-MC-Unique: hoVkQSKvOL68lN9M67sXcw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 257C2104458F;
	Tue, 18 Jul 2023 21:34:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 17A5BC33178;
	Tue, 18 Jul 2023 21:34:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C9CC61946595;
	Tue, 18 Jul 2023 21:34:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 939631946594
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Jul 2023 21:34:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 86BC1492B02; Tue, 18 Jul 2023 21:34:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E6F5492B01
 for <dm-devel@redhat.com>; Tue, 18 Jul 2023 21:34:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18E7A185A78B
 for <dm-devel@redhat.com>; Tue, 18 Jul 2023 21:34:36 +0000 (UTC)
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-DOB-SRj_PeWfjEX-Mb8xPQ-1; Tue, 18 Jul 2023 17:34:34 -0400
X-MC-Unique: DOB-SRj_PeWfjEX-Mb8xPQ-1
Received: from cwcc.thunk.org (pool-173-48-116-181.bstnma.fios.verizon.net
 [173.48.116.181]) (authenticated bits=0)
 (User authenticated as tytso@ATHENA.MIT.EDU)
 by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 36ILWCmR016366
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Tue, 18 Jul 2023 17:32:13 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
 id 5D34B15C026A; Tue, 18 Jul 2023 17:32:12 -0400 (EDT)
Date: Tue, 18 Jul 2023 17:32:12 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Alan C. Assis" <acassis@gmail.com>
Message-ID: <20230718213212.GE3842864@mit.edu>
References: <20230717075035.GA9549@tomerius.de>
 <CAG4Y6eTU=WsTaSowjkKT-snuvZwqWqnH3cdgGoCkToH02qEkgg@mail.gmail.com>
 <20230718053017.GB6042@tomerius.de>
 <CAEYzJUGC8Yj1dQGsLADT+pB-mkac0TAC-typAORtX7SQ1kVt+g@mail.gmail.com>
 <CAG4Y6eTN1XbZ_jAdX+t2mkEN=KoNOqprrCqtX0BVfaH6AxkdtQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAG4Y6eTN1XbZ_jAdX+t2mkEN=KoNOqprrCqtX0BVfaH6AxkdtQ@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] File system robustness
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
Cc: =?iso-8859-1?Q?Bj=F8rn?= Forsman <bjorn.forsman@gmail.com>,
 dm-devel@redhat.com, Ext4 Developers List <linux-ext4@vger.kernel.org>,
 linux-embedded@vger.kernel.org, Kai Tomerius <kai@tomerius.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: mit.edu
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jul 18, 2023 at 10:04:55AM -0300, Alan C. Assis wrote:
> 
> You are right, for NAND there is an old (but gold) presentation here:
> 
> https://elinux.org/images/7/7e/ELC2009-FlashFS-Toshiba.pdf
> 
> UBIFS and YAFFS2 are the way to go.

This presentation is specifically talking about flash devices that do
not have a flash translation layer (that is, they are using the MTD
interface).

There are multiple kinds of flash devices, that can be exported via
different interfaces: MTD, USB Storage, eMMC, UFS, SATA, SCSI, NVMe,
etc.  There are also differences in terms of the sophistication of the
Flash Translation Layer in terms of how powerful is the
microcontroller, how much memory and persistant storage for flash
metadata is available to the FTL, etc.

F2FS is a good choice for "low end flash", especially those flash
devices that use a very simplistic mapping between LBA (block/sector
numbers) and the physical flash to be used, and may have a very
limited number of flash blocks that can be open for modification at a
time.  For more sophiscated flash storage devices (e.g., SSD's and
higher end flash devices), this consideration won't matter, and then
the best file system to use will be very dependant on your workload.

In answer to Kai's original question, the setup that was described
should be fine --- assuming high quality hardware.  There are some
flash devices that designed to handle power failures correctly; which
is to say, if power is cut suddenly, the data used by the Flash
Translation Layer can be corrupted, in which case data written months
or years ago (not just recent data) could be lost.  There have been
horror stories about wedding photographers who dropped their camera,
and the SD Card came shooting out, and *all* of the data that was shot
on some couple's special day was completely *gone*.

Assuming that you have valid, power drop safe hardware, running fsck
after a power cut is not necessary, at least as far as file system
consistency is concerned.  If you have badly written userspace
application code, then all bets can be off.  For example, consider the
following sequence of events:

1)  An application like Tuxracer truncates the top-ten score file
2)  It then writes a new top-ten score file
3)  <Fail to call fsync, or write the file to a foo.new and then
       rename on top of the old version of the file>
4)  Ut then closes the Open GL library, triggering a bug in the cruddy
    proprietary binary-only kernel module video driver,
    leading to an immediate system crash.
5)  Complain to the file system developers that users' top-ten score
    file was lost, and what are the file system developers going to
    do about it?
6)  File system developers start creating T-shirts saying that what userspace
    applications really are asking for is a new open(2) flag, O_PONIES[1]

[1] https://blahg.josefsipek.net/?p=364

So when you talk about overall system robustness, you need robust
hardware, you need a robust file aystem, you need to use the file
system correctly, and you have robust userspace applications.

If you get it all right, you'll be fine.  On the other hand, if you
have crappy hardware (such as might be found for cheap in the checkout
counter of the local Micro Center, or in a back alley vendor in
Shenzhen, China), or if you do something like misconfigure the file
system such as using the "nobarrier" mount option "to speed things
up", or if you have applications that update files in an unsafe
manner, then you will have problems.

Welcome to systems engineering.  :-)

						- Ted

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

