Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64583EB64DC
	for <dm-devel@archiver.kernel.org>; Thu, 20 Jul 2023 04:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689828111;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CPlq5pMRcy95AP0FcR3XUAXfUhXl+S51NV+aIF9vTBI=;
	b=iyw7H4TkfPFYMGnBb1tiIRC/iXwFaukHKMC//xczOL/WAzOvH5Heobka5venuf0lekhJ9m
	XeC4OzrVW1LZktdcVMZE2qCSQwwu+hfSxoUbfsv3d6u3yJVipqH30oueXIm/oH2+8aIw5c
	+9uEWHC7QLLFqDkRgaOYWgn2f6W4KZ8=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-mBfH8CvJPCKqhquzlJ6Y5Q-1; Thu, 20 Jul 2023 00:41:48 -0400
X-MC-Unique: mBfH8CvJPCKqhquzlJ6Y5Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C1653C01C20;
	Thu, 20 Jul 2023 04:41:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CC611C2C863;
	Thu, 20 Jul 2023 04:41:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 694AC19465B9;
	Thu, 20 Jul 2023 04:41:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5E9961946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Jul 2023 04:41:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 03BCB1454143; Thu, 20 Jul 2023 04:41:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF5251454142
 for <dm-devel@redhat.com>; Thu, 20 Jul 2023 04:41:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE9C91C02143
 for <dm-devel@redhat.com>; Thu, 20 Jul 2023 04:41:31 +0000 (UTC)
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-ZJoVr50nN2y4M69BkarvYw-1; Thu, 20 Jul 2023 00:41:26 -0400
X-MC-Unique: ZJoVr50nN2y4M69BkarvYw-1
Received: from cwcc.thunk.org (pool-173-48-116-181.bstnma.fios.verizon.net
 [173.48.116.181]) (authenticated bits=0)
 (User authenticated as tytso@ATHENA.MIT.EDU)
 by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 36K4fK8T018002
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 20 Jul 2023 00:41:21 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
 id 9728615C026A; Thu, 20 Jul 2023 00:41:20 -0400 (EDT)
Date: Thu, 20 Jul 2023 00:41:20 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kai Tomerius <kai@tomerius.de>
Message-ID: <20230720044120.GB5764@mit.edu>
References: <20230717075035.GA9549@tomerius.de>
 <CAG4Y6eTU=WsTaSowjkKT-snuvZwqWqnH3cdgGoCkToH02qEkgg@mail.gmail.com>
 <20230718053017.GB6042@tomerius.de>
 <CAEYzJUGC8Yj1dQGsLADT+pB-mkac0TAC-typAORtX7SQ1kVt+g@mail.gmail.com>
 <CAG4Y6eTN1XbZ_jAdX+t2mkEN=KoNOqprrCqtX0BVfaH6AxkdtQ@mail.gmail.com>
 <20230718213212.GE3842864@mit.edu>
 <20230719105138.GA19936@tomerius.de>
MIME-Version: 1.0
In-Reply-To: <20230719105138.GA19936@tomerius.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
 "Alan C. Assis" <acassis@gmail.com>, linux-embedded@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: mit.edu
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jul 19, 2023 at 12:51:39PM +0200, Kai Tomerius wrote:
> > In answer to Kai's original question, the setup that was described
> > should be fine --- assuming high quality hardware.
> 
> I wonder how to judge that ... it's an eMMC supposedly complying to
> some JEDEC standard, so it *should* be ok.

JEDEC promulgates the eMMC interface specification.  That's the
interface used to talk to the device, much like SATA and SCSI and
NVMe.  The JEDEC eMMC specification says nothing about the quality of
the implementation of the FTL, or whether it is safe from power drops,
or how many wirte cycles are supported before the eMMC soldered on the
$2000 MCU would expire.

If you're a cell phone manufacturer, the way you judge it is *before*
you buy a few million of the eMMC devices, you subject the samples to
a huge amount of power drops and other torture tests (including
verifying the claimed number of write cycles in spec sheet), before
the device is qualified for use in your product.

> But on another aspect: how about the interaction between dm-integrity
> and ext4? Sure, they each have their own journal, and they're
> independent layers. Is there anything that could go wrong, say a block
> that can't be recovered in the dm-integrity layer, causing ext4 to run
> into trouble, e.g., an I/O error that prevents ext4 from mounting?
> 
> I assume tne answer is "No", but can I be sure?

If there are I/O errors, with or without dm-integrity, you can have
problems.  dm-integrity will turn bit-flips into hard I/O errors, but
a bit-flip might cause silent file system cocrruption (at least at
first), such that when you finally notice that there's a problem,
several days or weeks or months may have passed, the data loss might
be far worse.  So turning an innocous bit flip into a hard I/O error
can be a feature, assuming that you've allowed for it in your system
architecture.

If you assume that the hardware doesn't introduce I/O errors or bit
flips, and if you assume you don't have any attackers trying to
corrupt the block device with bit flips, then sure, nothing will go
wrong.  You can buy perfect hardware from the same supply store where
high school physics teachers buy frictionless pulleys and massless
ropes.  :-)

Cheers,

						- Ted

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

