Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC32DC433DB
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 17:55:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0092B22B3B
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 17:55:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0092B22B3B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-Go_wMs2RPsqHkNSJHc0QTA-1; Mon, 25 Jan 2021 12:55:49 -0500
X-MC-Unique: Go_wMs2RPsqHkNSJHc0QTA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AF53801AAB;
	Mon, 25 Jan 2021 17:55:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C23060871;
	Mon, 25 Jan 2021 17:55:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 411464E58F;
	Mon, 25 Jan 2021 17:55:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PHtds9002402 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 12:55:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 14E9B2026D3C; Mon, 25 Jan 2021 17:55:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 100D82026D38
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 17:55:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AE181875040
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 17:55:35 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-348-TGyLKb-cM6GoCZ8EXezhCQ-1;
	Mon, 25 Jan 2021 12:55:32 -0500
X-MC-Unique: TGyLKb-cM6GoCZ8EXezhCQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1DB9C68B02; Mon, 25 Jan 2021 18:55:29 +0100 (CET)
Date: Mon, 25 Jan 2021 18:55:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <20210125175528.GA13451@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
	<20210124100241.1167849-6-hch@lst.de>
	<dfdff48c-c263-8e7c-cb52-28e7bee00c45@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <dfdff48c-c263-8e7c-cb52-28e7bee00c45@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-s390 <linux-s390@vger.kernel.org>,
	linux-bcache <linux-bcache@vger.kernel.org>, Coly Li <colyli@suse.de>,
	"open list:SOFTWARE RAID \(Multiple Disks\) SUPPORT"
	<linux-raid@vger.kernel.org>, Song Liu <song@kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-block <linux-block@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 05/10] block: do not reassig ->bi_bdev when
 partition remapping
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 25, 2021 at 10:53:36AM -0700, Jens Axboe wrote:
> On Sun, Jan 24, 2021 at 3:05 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > There is no good reason to reassign ->bi_bdev when remapping the
> > partition-relative block number to the device wide one, as all the
> > information required by the drivers comes from the gendisk anyway.
> >
> > Keeping the original ->bi_bdev alive will allow to greatly simplify
> > the partition-away I/O accounting.
> 
> This one causes boot failures for me on my laptop...

Any output to share?  Details of the config?

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

