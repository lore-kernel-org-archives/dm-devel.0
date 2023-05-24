Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1557C77B73
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 06:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684908548;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FbGFR51GUTc6CNSvI55IRXTLZYqLmf6mAZYuw1IAUps=;
	b=O4/kyhPgT8lSsVKJjxTCOlu+2cVm/YRttbqXItc1dRrRtlOYRA2lezJFsHxkdhx4bLMhFq
	NZH1P80ByWFBksYuX9FG9GBGh5zwVMpzNm+5yamqy618aWKwr2HXsZtCgQIIi7p5qbCbrb
	QAOSfh+x5Mvzv06ypbqcOcaKF4dKKpg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-X5w18w8mPeuXoFDajRZUxA-1; Wed, 24 May 2023 02:09:05 -0400
X-MC-Unique: X5w18w8mPeuXoFDajRZUxA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEE623801EDF;
	Wed, 24 May 2023 06:09:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ACB7220296C6;
	Wed, 24 May 2023 06:09:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8323819465A8;
	Wed, 24 May 2023 06:09:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9EECA19465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 06:08:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7E0672166B26; Wed, 24 May 2023 06:08:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 75FAD2166B25
 for <dm-devel@redhat.com>; Wed, 24 May 2023 06:08:51 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D85429AA3B9
 for <dm-devel@redhat.com>; Wed, 24 May 2023 06:08:51 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-33-IHsLjd_eP_-qBDmsyyv_Jg-1; Wed, 24 May 2023 02:08:49 -0400
X-MC-Unique: IHsLjd_eP_-qBDmsyyv_Jg-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 4CF6E68CFE; Wed, 24 May 2023 08:08:45 +0200 (CEST)
Date: Wed, 24 May 2023 08:08:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <20230524060844.GC19611@lst.de>
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-16-hch@lst.de>
 <b384f464-92c6-6a14-4072-1faa9fa6a6a8@infradead.org>
 <e96e4e85-7371-2859-b9a5-0f2c1f3b97d9@infradead.org>
MIME-Version: 1.0
In-Reply-To: <e96e4e85-7371-2859-b9a5-0f2c1f3b97d9@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 15/24] block: move the code to do early boot
 lookup of block devices to block/
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
Cc: Jens Axboe <axboe@kernel.dk>, Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 23, 2023 at 09:59:50PM -0700, Randy Dunlap wrote:
> >>  	root=		[KNL] Root filesystem
> >> -			See early_lookup_bdev comment in init/do_mounts.c.
> >> +			See early_lookup_bdev comment in block/early-lookup.c
> > 
> > Patch 13 does this:
> > 
> >  	root=		[KNL] Root filesystem
> > -			See name_to_dev_t comment in init/do_mounts.c.
> > +			See early_lookup_bdev comment in init/do_mounts.c.
> > 
> > Should this latter chunk be dropped?
> > 
> 
> Oh, oops, reverse order of patches?

Patch 13 renames the function, this patch moves it.  So I think this
correct, but feel free to double check my foggy brain :)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

