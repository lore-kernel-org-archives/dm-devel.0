Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAADBC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 14:30:10 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-1eWhs5fFNQK3KExbH40NWA-1; Tue, 23 Nov 2021 09:30:06 -0500
X-MC-Unique: 1eWhs5fFNQK3KExbH40NWA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21C171572A;
	Tue, 23 Nov 2021 14:30:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B7F6B652AC;
	Tue, 23 Nov 2021 14:29:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B8FA61832E80;
	Tue, 23 Nov 2021 14:29:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANESYTQ000757 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 09:28:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EDF0C40CFD04; Tue, 23 Nov 2021 14:28:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E8D8940CFD0D
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 14:28:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D051C10AF951
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 14:28:33 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-508-sDt7YmrmM7m2KtrKZvLxWQ-1; Tue, 23 Nov 2021 09:28:31 -0500
X-MC-Unique: sDt7YmrmM7m2KtrKZvLxWQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mpWma-002cKJ-SG; Tue, 23 Nov 2021 14:28:28 +0000
Date: Tue, 23 Nov 2021 06:28:28 -0800
From: "hch@infradead.org" <hch@infradead.org>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Message-ID: <YZz6jAVXun8yC/6k@infradead.org>
References: <5d8351f1-1b09-bff0-02f2-a417c1669607@gmx.com>
	<YZybvlheyLGAadFF@infradead.org>
	<79d38fc2-cd2f-2980-2c4e-408078ce6079@gmx.com>
	<YZyiuFxAeKE/WMrR@infradead.org>
	<cca20bcb-1674-f99d-d504-b7fc928e227a@gmx.com>
	<PH0PR04MB74169757F9CF740289B790C49B609@PH0PR04MB7416.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <PH0PR04MB74169757F9CF740289B790C49B609@PH0PR04MB7416.namprd04.prod.outlook.com>
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
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>
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

On Tue, Nov 23, 2021 at 11:39:11AM +0000, Johannes Thumshirn wrote:
> I think we have to differentiate two cases here:
> A "regular" REQ_OP_ZONE_APPEND bio and a RAID stripe REQ_OP_ZONE_APPEND
> bio. The 1st one (i.e. the regular REQ_OP_ZONE_APPEND bio) can't be split
> because we cannot guarantee the order the device writes the data to disk. 
> For the RAID stripe bio we can split it into the two (or more) parts that
> will end up on _different_ devices. All we need to do is a) ensure it 
> doesn't cross the device's zone append limit and b) clamp all 
> bi_iter.bi_sector down to the start of the target zone, a.k.a sticking to
> the rules of REQ_OP_ZONE_APPEND.

Exactly.  A stacking driver must never split a REQ_OP_ZONE_APPEND bio.
But the file system itself can of course split it as long as each split
off bio has it's own bi_end_io handler to record where it has been
written to.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

