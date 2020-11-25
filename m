Return-Path: <SRS0=8HMs=E7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E06ECC56201
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 16:46:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 35847206D8
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 16:46:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35847206D8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-5DIW134PP2qHvSBHA-fxTA-1; Wed, 25 Nov 2020 11:46:25 -0500
X-MC-Unique: 5DIW134PP2qHvSBHA-fxTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C2A9185E488;
	Wed, 25 Nov 2020 16:46:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B93915C1A3;
	Wed, 25 Nov 2020 16:46:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 57180180954D;
	Wed, 25 Nov 2020 16:46:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0APGjSH8009228 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 25 Nov 2020 11:45:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 21689AB40E; Wed, 25 Nov 2020 16:45:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C174AB40A
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 16:45:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 038ED811E76
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 16:45:26 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-587-5JyHE8CzMIukVk0S95TDWw-1;
	Wed, 25 Nov 2020 11:45:20 -0500
X-MC-Unique: 5JyHE8CzMIukVk0S95TDWw-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 05B8968B02; Wed, 25 Nov 2020 17:45:16 +0100 (CET)
Date: Wed, 25 Nov 2020 17:45:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Message-ID: <20201125164515.GB1975@lst.de>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-26-hch@lst.de>
	<X714udEyPuGarVYp@mtj.duckdns.org>
MIME-Version: 1.0
In-Reply-To: <X714udEyPuGarVYp@mtj.duckdns.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org, linux-mm@kvack.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 25/45] block: reference struct block_device
 from struct hd_struct
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 24, 2020 at 04:18:49PM -0500, Tejun Heo wrote:
> Hello,
> 
> Please see lkml.kernel.org/r/X708BTJ5njtbC2z1@mtj.duckdns.org for a few nits
> on the previous version.

Thanks, I've addressed the mapping_set_gfp mask nit and updated the
commit log.  As Jan pointed also pointed out I think we do need the
remove_inode_hash.

> I might be confused but am wondering whether RCU is needed. It's currently
> used to ensure that gendisk is accessible in the blkdev_get path but
> wouldn't it be possible to simply pin gendisk from block_devices? The
> gendisk and hd_structs hold the base refs of the block_devices and in turn
> the block_devices pin the gendisk. When the gendisk gets deleted, it puts
> the base refs of the block devices but stays around while the block devices
> are being accessed.

Yes, that sounds sensible.  I'll take a look.

> Also, would it make sense to separate out lookup_sem removal? I *think* it's
> there to ensure that the same bdev doesn't get associated with old and new
> gendisks at the same time but can't wrap my head around how it works
> exactly. I can see that this may not be needed once the lifetimes of gendisk
> and block_devices are tied together but that may warrant a bit more
> explanation.

Jan added lookup_sem in commit 56c0908c855afbb to prevent a three way
race between del_gendisk and blkdev_open due to the weird bdev vs
gendisk lifetime rules.  None of that can happen with the new lookup
scheme.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

