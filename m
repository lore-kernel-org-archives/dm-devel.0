Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6726DC63777
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:16:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 91F5D2224C
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:16:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91F5D2224C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-fpHn6VgfPCGeHiRpNuvXUQ-1; Fri, 20 Nov 2020 04:16:05 -0500
X-MC-Unique: fpHn6VgfPCGeHiRpNuvXUQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E98F8797DA;
	Fri, 20 Nov 2020 09:16:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6FF960BE2;
	Fri, 20 Nov 2020 09:15:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8164C180954D;
	Fri, 20 Nov 2020 09:15:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK9FwAK021986 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 04:15:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0AB1C2166B2B; Fri, 20 Nov 2020 09:15:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05E202166B28
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 09:15:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9A24811E85
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 09:15:55 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-524-k73oXmuNMEqMq5Oq09A2Aw-1;
	Fri, 20 Nov 2020 04:15:51 -0500
X-MC-Unique: k73oXmuNMEqMq5Oq09A2Aw-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8D37C67373; Fri, 20 Nov 2020 10:15:47 +0100 (CET)
Date: Fri, 20 Nov 2020 10:15:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Message-ID: <20201120091546.GE21715@lst.de>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-16-hch@lst.de>
	<20201119143921.GX1981@quack2.suse.cz>
MIME-Version: 1.0
In-Reply-To: <20201119143921.GX1981@quack2.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	linux-mm@kvack.org, Jan Kara <jack@suse.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 19, 2020 at 03:39:21PM +0100, Jan Kara wrote:
> This patch is kind of difficult to review due to the size of mostly
> mechanical changes mixed with not completely mechanical changes. Can we
> perhaps split out the mechanical bits? E.g. the rq->part => rq->bdev
> renaming is mechanical and notable part of the patch. Similarly the
> part->foo => part->bd_foo bits...

We'd end with really weird patches that way.  Never mind that I'm not
even sure how we could mechnically do the renaming.

> 
> Also I'm kind of wondering: AFAIU the new lifetime rules, gendisk holds
> bdev reference and bdev is created on gendisk allocation so bdev lifetime is
> strictly larger than gendisk lifetime. But what now keeps bdev->bd_disk
> reference safe in presence device hot unplug? In most cases we are still
> protected by gendisk reference taken in __blkdev_get() but how about
> disk->lookup_sem and disk->flags dereferences before we actually grab the
> reference?

Good question.  I'll need to think about this a bit more.

> Also I find it rather non-obvious (although elegant ;) that bdev->bd_device
> rules the lifetime of gendisk. Can you perhaps explain this in the
> changelog and probably also add somewhere to source a documentation about
> the new lifetime rules?

Yes.

> > -struct hd_struct *__disk_get_part(struct gendisk *disk, int partno);
> > +static inline struct block_device *__bdget_disk(struct gendisk *disk,
> > +		int partno)
> > +{
> > +	struct disk_part_tbl *ptbl = rcu_dereference(disk->part_tbl);
> > +
> > +	if (unlikely(partno < 0 || partno >= ptbl->len))
> > +		return NULL;
> > +	return rcu_dereference(ptbl->part[partno]);
> > +}
> 
> I understand this is lower-level counterpart of bdget_disk() but it is
> confusing to me that this has 'bdget' in the name and returns no bdev
> reference. Can we call it like __bdev_from_disk() or something like that?

Sure.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

