Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA2EC2B9F7
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 04:50:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BE7D3613AD
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 04:50:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE7D3613AD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-Q_AzCH4DMHG6UaiIOnPFlg-1; Wed, 26 May 2021 00:50:30 -0400
X-MC-Unique: Q_AzCH4DMHG6UaiIOnPFlg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DEB6180FD62;
	Wed, 26 May 2021 04:50:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0ED5C5D9D0;
	Wed, 26 May 2021 04:50:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 773BB1801029;
	Wed, 26 May 2021 04:50:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14Q4oGW4003867 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 May 2021 00:50:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E63B1BDC5F; Wed, 26 May 2021 04:50:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E10CAFC758
	for <dm-devel@redhat.com>; Wed, 26 May 2021 04:50:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57FF28007AC
	for <dm-devel@redhat.com>; Wed, 26 May 2021 04:50:13 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-312-7W5EAw5qOSevLfiaZHIo7g-1;
	Wed, 26 May 2021 00:49:48 -0400
X-MC-Unique: 7W5EAw5qOSevLfiaZHIo7g-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3ADA76736F; Wed, 26 May 2021 06:49:44 +0200 (CEST)
Date: Wed, 26 May 2021 06:49:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Message-ID: <20210526044943.GA28551@lst.de>
References: <20210521055116.1053587-1-hch@lst.de>
	<CAPDyKFpqdSYeA+Zg=9Ewi46CmSWNpXQbju6HQo7aviCcRzyAAg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPDyKFpqdSYeA+Zg=9Ewi46CmSWNpXQbju6HQo7aviCcRzyAAg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, linux-m68k@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, Joshua Morris <josh.h.morris@us.ibm.com>,
	linux-s390@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Christoph Hellwig <hch@lst.de>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Matias Bjorling <mb@lightnvm.io>, Nitin Gupta <ngupta@vflare.org>,
	Vasily Gorbik <gor@linux.ibm.com>, linux-xtensa@linux-xtensa.org,
	Alex Dubov <oakad@yahoo.com>, Heiko Carstens <hca@linux.ibm.com>,
	Coly Li <colyli@suse.de>, linux-block <linux-block@vger.kernel.org>,
	linux-bcache@vger.kernel.org, drbd-dev@tron.linbit.com,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>, Chris Zankel <chris@zankel.net>,
	linux-raid@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
	linux-mmc <linux-mmc@vger.kernel.org>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Jim Paris <jim@jtan.com>, Minchan Kim <minchan@kernel.org>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [dm-devel] simplify gendisk and request_queue allocation for
 bio based drivers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 26, 2021 at 12:41:37AM +0200, Ulf Hansson wrote:
> On Fri, 21 May 2021 at 07:51, Christoph Hellwig <hch@lst.de> wrote:
> >
> > Hi all,
> >
> > this series is the first part of cleaning up lifetimes and allocation of
> > the gendisk and request_queue structure.  It adds a new interface to
> > allocate the disk and queue together for bio based drivers, and a helper
> > for cleanup/free them when a driver is unloaded or a device is removed.
> 
> May I ask what else you have in the pipe for the next steps?
> 
> The reason why I ask is that I am looking into some issues related to
> lifecycle problems of gendisk/mmc, typically triggered at SD/MMC card
> removal.

In the short run not much more than superficial cleanups.  Eventually
I want bio based drivers to not require a separate request_queue, leaving
that purely as a data structure for blk-mq based drivers.  But it will
take a while until we get there, so it should not block any fixes.

For hot unplug handling it might be worth to take a look at nvme, as it
is tested a lot for that case.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

