Return-Path: <SRS0=2hlQ=FB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31D3C2D0E4
	for <dm-devel@archiver.kernel.org>; Fri, 27 Nov 2020 15:24:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2FEC9221F1
	for <dm-devel@archiver.kernel.org>; Fri, 27 Nov 2020 15:24:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FEC9221F1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-ogBWLBrlNTW3WyulseWewg-1; Fri, 27 Nov 2020 10:24:28 -0500
X-MC-Unique: ogBWLBrlNTW3WyulseWewg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FA16805BFA;
	Fri, 27 Nov 2020 15:24:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6447319C66;
	Fri, 27 Nov 2020 15:24:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 62ABD5002C;
	Fri, 27 Nov 2020 15:24:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ARFOHT9000639 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 27 Nov 2020 10:24:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 002EED7B31; Fri, 27 Nov 2020 15:24:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF27CD7B2E
	for <dm-devel@redhat.com>; Fri, 27 Nov 2020 15:24:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA72E800889
	for <dm-devel@redhat.com>; Fri, 27 Nov 2020 15:24:14 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-320-CPcYUCYOOBKMuP8gKaDXdA-1;
	Fri, 27 Nov 2020 10:24:10 -0500
X-MC-Unique: CPcYUCYOOBKMuP8gKaDXdA-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6661868B05; Fri, 27 Nov 2020 16:24:07 +0100 (CET)
Date: Fri, 27 Nov 2020 16:24:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Message-ID: <20201127152407.GA7115@lst.de>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-42-hch@lst.de>
	<20201127125341.GD27162@quack2.suse.cz>
MIME-Version: 1.0
In-Reply-To: <20201127125341.GD27162@quack2.suse.cz>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 41/44] block: switch disk_part_iter_* to use
 a struct block_device
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 27, 2020 at 01:53:41PM +0100, Jan Kara wrote:
> On Thu 26-11-20 14:04:19, Christoph Hellwig wrote:
> > Switch the partition iter infrastructure to iterate over block_device
> > references instead of hd_struct ones mostly used to get at the
> > block_device.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> The patch mostly looks good. Two comments below.
> 
> > diff --git a/block/genhd.c b/block/genhd.c
> > index 28299b24173be1..b58595f2ca33b1 100644
> > --- a/block/genhd.c
> > +++ b/block/genhd.c
> > @@ -233,7 +233,7 @@ EXPORT_SYMBOL_GPL(disk_part_iter_init);
> >   * CONTEXT:
> >   * Don't care.
> >   */
> > -struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
> > +struct block_device *disk_part_iter_next(struct disk_part_iter *piter)
> >  {
> >  	struct disk_part_tbl *ptbl;
> >  	int inc, end;
> 
> There's:
> 
>         /* put the last partition */
>         disk_put_part(piter->part);
>         piter->part = NULL;
> 
> at the beginning of disk_part_iter_next() which also needs switching to
> bdput(), doesn't it?

That is switched to call disk_part_iter_exit in patch 13.

> 
> > @@ -271,8 +271,7 @@ struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
> >  		      piter->idx == 0))
> >  			continue;
> >  
> > -		get_device(part_to_dev(part->bd_part));
> > -		piter->part = part->bd_part;
> > +		piter->part = bdgrab(part);
> 
> bdgrab() could return NULL if we are racing with delete_partition() so I
> think we need to take care of that.

bdgrab never retuns NULL..

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

