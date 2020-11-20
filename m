Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16697C56202
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 10:53:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2F20220657
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 10:53:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F20220657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-ZC1mb4q0Nv2qLtV48uvcIg-1; Fri, 20 Nov 2020 05:53:48 -0500
X-MC-Unique: ZC1mb4q0Nv2qLtV48uvcIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B60E7801B17;
	Fri, 20 Nov 2020 10:53:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 346E11002388;
	Fri, 20 Nov 2020 10:53:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 48E834A7C6;
	Fri, 20 Nov 2020 10:53:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AKArbXP003128 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 05:53:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9E802115589D; Fri, 20 Nov 2020 10:53:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AA49115589B
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 10:53:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69DD585829F
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 10:53:24 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-306-h7jR73IUMFO5D0PmrLFcQQ-1;
	Fri, 20 Nov 2020 05:53:21 -0500
X-MC-Unique: h7jR73IUMFO5D0PmrLFcQQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 015E9AED9;
	Fri, 20 Nov 2020 10:53:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id AC96F1E130B; Fri, 20 Nov 2020 11:53:19 +0100 (CET)
Date: Fri, 20 Nov 2020 11:53:19 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201120105319.GA15537@quack2.suse.cz>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-16-hch@lst.de>
	<20201119143921.GX1981@quack2.suse.cz>
	<20201120091546.GE21715@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201120091546.GE21715@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 15/20] block: merge struct block_device and
 struct hd_struct
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

On Fri 20-11-20 10:15:46, Christoph Hellwig wrote:
> On Thu, Nov 19, 2020 at 03:39:21PM +0100, Jan Kara wrote:
> > This patch is kind of difficult to review due to the size of mostly
> > mechanical changes mixed with not completely mechanical changes. Can we
> > perhaps split out the mechanical bits? E.g. the rq->part => rq->bdev
> > renaming is mechanical and notable part of the patch. Similarly the
> > part->foo => part->bd_foo bits...
> 
> We'd end with really weird patches that way.  Never mind that I'm not
> even sure how we could mechnically do the renaming.

Well, I believe coccinelle should be able to do the renaming automatically.

> > Also I'm kind of wondering: AFAIU the new lifetime rules, gendisk holds
> > bdev reference and bdev is created on gendisk allocation so bdev lifetime is
> > strictly larger than gendisk lifetime. But what now keeps bdev->bd_disk
> > reference safe in presence device hot unplug? In most cases we are still
> > protected by gendisk reference taken in __blkdev_get() but how about
> > disk->lookup_sem and disk->flags dereferences before we actually grab the
> > reference?
> 
> Good question.  I'll need to think about this a bit more.

My thinking was that you could use

kobject_get_unless_zero(bdev->bd_device->kobj)

and after you hold this reference, you can do everything else safely. In
this case it is really useful that device is embedded in block_dev and
not in gendisk itself...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

