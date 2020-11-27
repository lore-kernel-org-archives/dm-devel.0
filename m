Return-Path: <SRS0=2hlQ=FB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043D7C3E8C5
	for <dm-devel@archiver.kernel.org>; Fri, 27 Nov 2020 17:30:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7D89E22250
	for <dm-devel@archiver.kernel.org>; Fri, 27 Nov 2020 17:30:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D89E22250
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-2SkiPo5mMbyWpxmS2dyk0w-1; Fri, 27 Nov 2020 12:30:26 -0500
X-MC-Unique: 2SkiPo5mMbyWpxmS2dyk0w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7835F185E49C;
	Fri, 27 Nov 2020 17:30:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 39D7B10021B3;
	Fri, 27 Nov 2020 17:30:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D4FBD180954D;
	Fri, 27 Nov 2020 17:30:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ARHUIRs014642 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 27 Nov 2020 12:30:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C0613D7DE1; Fri, 27 Nov 2020 17:30:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB3FBD7B3C
	for <dm-devel@redhat.com>; Fri, 27 Nov 2020 17:30:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F349185A794
	for <dm-devel@redhat.com>; Fri, 27 Nov 2020 17:30:16 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-385-cQ19IsJFO9qdgtOz2RV4gg-1;
	Fri, 27 Nov 2020 12:30:12 -0500
X-MC-Unique: cQ19IsJFO9qdgtOz2RV4gg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 5DF80ABD7;
	Fri, 27 Nov 2020 17:30:10 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 1DA451E1319; Fri, 27 Nov 2020 18:30:10 +0100 (CET)
Date: Fri, 27 Nov 2020 18:30:10 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201127173010.GB4276@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-42-hch@lst.de>
	<20201127125341.GD27162@quack2.suse.cz>
	<20201127152407.GA7115@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201127152407.GA7115@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri 27-11-20 16:24:07, Christoph Hellwig wrote:
> On Fri, Nov 27, 2020 at 01:53:41PM +0100, Jan Kara wrote:
> > On Thu 26-11-20 14:04:19, Christoph Hellwig wrote:
> > 
> > There's:
> > 
> >         /* put the last partition */
> >         disk_put_part(piter->part);
> >         piter->part = NULL;
> > 
> > at the beginning of disk_part_iter_next() which also needs switching to
> > bdput(), doesn't it?
> 
> That is switched to call disk_part_iter_exit in patch 13.

I see, sorry for the noise.

> > > @@ -271,8 +271,7 @@ struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
> > >  		      piter->idx == 0))
> > >  			continue;
> > >  
> > > -		get_device(part_to_dev(part->bd_part));
> > > -		piter->part = part->bd_part;
> > > +		piter->part = bdgrab(part);
> > 
> > bdgrab() could return NULL if we are racing with delete_partition() so I
> > think we need to take care of that.
> 
> bdgrab never retuns NULL..

Ah, that's what I misunderstood. I was confusing bdgrab() with igrab().
igrab() can return NULL but bdgrab() uses ihold() and thus cannot return
NULL. But for the lifetime rules to be safe, we should be indeed using
igrab() and check for NULL return...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

