Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2BA8C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 07:04:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-pELioy-2OP-VhVNlhpd_2A-1; Wed, 24 Nov 2021 02:04:51 -0500
X-MC-Unique: pELioy-2OP-VhVNlhpd_2A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 581F89F92A;
	Wed, 24 Nov 2021 07:04:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 200FC60843;
	Wed, 24 Nov 2021 07:04:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DDFBC4BB7C;
	Wed, 24 Nov 2021 07:04:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AO72OEK003943 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 02:02:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 192D54010FFC; Wed, 24 Nov 2021 07:02:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1388840CFD0E
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 07:02:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE797811E81
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 07:02:23 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-452-QE0eZlJqONmopShmpxtIAQ-1; Wed, 24 Nov 2021 02:02:21 -0500
X-MC-Unique: QE0eZlJqONmopShmpxtIAQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mplTL-003yvO-6b; Wed, 24 Nov 2021 06:09:35 +0000
Date: Tue, 23 Nov 2021 22:09:35 -0800
From: "hch@infradead.org" <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <YZ3XH2PWwrIl/XMy@infradead.org>
References: <5d8351f1-1b09-bff0-02f2-a417c1669607@gmx.com>
	<YZybvlheyLGAadFF@infradead.org>
	<79d38fc2-cd2f-2980-2c4e-408078ce6079@gmx.com>
	<YZyiuFxAeKE/WMrR@infradead.org>
	<cca20bcb-1674-f99d-d504-b7fc928e227a@gmx.com>
	<PH0PR04MB74169757F9CF740289B790C49B609@PH0PR04MB7416.namprd04.prod.outlook.com>
	<YZz6jAVXun8yC/6k@infradead.org>
	<133792e9-b89b-bc82-04fe-41202c3453a5@gmx.com>
MIME-Version: 1.0
In-Reply-To: <133792e9-b89b-bc82-04fe-41202c3453a5@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: "hch@infradead.org" <hch@infradead.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] Any bio_clone_slow() implementation which doesn't
 share bi_io_vec?
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 24, 2021 at 07:07:18AM +0800, Qu Wenruo wrote:
> In that case, the missing piece seems to be a way to convert a splitted
> plain bio into a REQ_OP_ZONE_APPEND bio.
> 
> Can this be done without slow bvec copying?

Yes.  I have a WIP stacking driver that converts writes to zone appends
and it does just that:

	sector_t orig_sector = bio->bi_iter.bi_sector;
	unsigned int bio_flags = bio->bi_opf & ~REQ_OP_MASK;

	...

	clone = bio_clone_fast(bio, GFP_NOIO, &bdev->write_bio_set);

	...

	clone->bi_opf = REQ_OP_ZONE_APPEND | REQ_NOMERGE | bio_flags;
	bio_set_dev(clone, dev->lower_bdev);
	clone->bi_iter.bi_sector = zone_sector;
	trace_block_bio_remap(clone, disk_devt(disk), orig_sector);

> 
> Thanks,
> Qu
---end quoted text---

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

