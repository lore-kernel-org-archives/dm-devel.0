Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B5FC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 07:22:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-_mUUEDRBNr2mdD0_-lp8vw-1; Wed, 24 Nov 2021 02:22:54 -0500
X-MC-Unique: _mUUEDRBNr2mdD0_-lp8vw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51A978042E2;
	Wed, 24 Nov 2021 07:22:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1A8F2B178;
	Wed, 24 Nov 2021 07:22:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E9DC51809C89;
	Wed, 24 Nov 2021 07:22:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AO7MiVD005275 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 02:22:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 96EBA40CFD11; Wed, 24 Nov 2021 07:22:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91E0140149B1
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 07:22:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 595B718162C4
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 07:22:44 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-248-_BOBpMOHNGKbg0CZ_FXHFg-1; Wed, 24 Nov 2021 02:22:42 -0500
X-MC-Unique: _BOBpMOHNGKbg0CZ_FXHFg-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mpmc2-0044bY-GE; Wed, 24 Nov 2021 07:22:38 +0000
Date: Tue, 23 Nov 2021 23:22:38 -0800
From: "hch@infradead.org" <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <YZ3oPrgI1GFugzVY@infradead.org>
References: <YZybvlheyLGAadFF@infradead.org>
	<79d38fc2-cd2f-2980-2c4e-408078ce6079@gmx.com>
	<YZyiuFxAeKE/WMrR@infradead.org>
	<cca20bcb-1674-f99d-d504-b7fc928e227a@gmx.com>
	<PH0PR04MB74169757F9CF740289B790C49B609@PH0PR04MB7416.namprd04.prod.outlook.com>
	<YZz6jAVXun8yC/6k@infradead.org>
	<133792e9-b89b-bc82-04fe-41202c3453a5@gmx.com>
	<YZ3XH2PWwrIl/XMy@infradead.org>
	<e3fce9af-429c-a1e3-3f0b-4d90fa061d94@gmx.com>
	<YZ3jnFWk05058h/J@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YZ3jnFWk05058h/J@infradead.org>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 23, 2021 at 11:02:52PM -0800, hch@infradead.org wrote:
> > Does it mean as long as our splitted bio doesn't exceed zone limit, we
> > can do the convert without any further problem?
> 
> You need to look at the limits when splitting.  I have modified
> blk_bio_segment_split and exported it to deal with that.  Let me split
> those changes out cleanly and push out a branch.

Here:

http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/zone-append-split

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

