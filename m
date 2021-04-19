Return-Path: <SRS0=vg7B=JR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D31AC433B4
	for <dm-devel@archiver.kernel.org>; Tue, 20 Apr 2021 07:22:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C935260FEA
	for <dm-devel@archiver.kernel.org>; Tue, 20 Apr 2021 07:22:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C935260FEA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-s-JyNdrGOpKI3qOTDmTGUg-1; Tue, 20 Apr 2021 03:22:04 -0400
X-MC-Unique: s-JyNdrGOpKI3qOTDmTGUg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31DDC106B381;
	Tue, 20 Apr 2021 07:18:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1569260C5C;
	Tue, 20 Apr 2021 07:18:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DCD981806D17;
	Tue, 20 Apr 2021 07:18:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13JGopPK018138 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Apr 2021 12:50:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4125021602B9; Mon, 19 Apr 2021 16:50:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BD5320308A4
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 16:50:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8531E800C5B
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 16:50:48 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-371-bz51SLRcMNq5OyhH0O1VFw-1;
	Mon, 19 Apr 2021 12:50:43 -0400
X-MC-Unique: bz51SLRcMNq5OyhH0O1VFw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 10B3BB30F;
	Mon, 19 Apr 2021 16:50:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
	id 45999DA732; Mon, 19 Apr 2021 18:48:22 +0200 (CEST)
Date: Mon, 19 Apr 2021 18:48:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Message-ID: <20210419164822.GN7604@twin.jikos.cz>
Mail-Followup-To: dsterba@suse.cz, Damien Le Moal <Damien.LeMoal@wdc.com>,
	"hch@infradead.org" <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>
References: <20210416030528.757513-1-damien.lemoal@wdc.com>
	<20210416030528.757513-4-damien.lemoal@wdc.com>
	<20210416161720.GA7604@twin.jikos.cz>
	<20210419092855.GA3223318@infradead.org>
	<BL0PR04MB651459AE484861FD4EA20669E7499@BL0PR04MB6514.namprd04.prod.outlook.com>
	<20210419093921.GA3226573@infradead.org>
	<BL0PR04MB65145DA8B6252C452EAA8BC9E7499@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <BL0PR04MB65145DA8B6252C452EAA8BC9E7499@BL0PR04MB6514.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
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
X-Mailman-Approved-At: Tue, 20 Apr 2021 03:18:36 -0400
Cc: Jens Axboe <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"dsterba@suse.cz" <dsterba@suse.cz>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Josef Bacik <josef@toxicpanda.com>,
	"hch@infradead.org" <hch@infradead.org>, David Sterba <dsterba@suse.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [dm-devel] [PATCH 3/4] btrfs: zoned: fail mount if the device
 does not support zone append
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
Reply-To: dsterba@suse.cz
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

On Mon, Apr 19, 2021 at 09:46:36AM +0000, Damien Le Moal wrote:
> On 2021/04/19 18:41, hch@infradead.org wrote:
> > On Mon, Apr 19, 2021 at 09:35:37AM +0000, Damien Le Moal wrote:
> >> This is only to avoid someone from running zoned-btrfs on top of dm-crypt.
> >> Without this patch, mount will be OK and file data writes will also actually be
> >> OK. But all reads will miserably fail... I would rather have this patch in than
> >> deal with the "bug reports" about btrfs failing to read files. No ?
> >>
> >> Note that like you, I dislike having to add such code. But it was my oversight
> >> when I worked on getting dm-crypt to work on zoned drives. Zone append was
> >> overlooked at that time... My bad, really.
> > 
> > dm-crypt needs to stop pretending it supports zoned devices if it
> > doesn't.  Note that dm-crypt could fairly trivially support zone append
> > by doing the same kind of emulation that the sd driver does.
> 
> I am not so sure about the "trivial" but yes, it is feasible. Let me think about
> something then. Whatever we do, performance with ZNS will no be great, for
> sure... But for SMR HDDs, we likely will not notice any difference in performance.

So this needs to be fixed outside of btrfs. The fix in btrfs would make
sense in case we can't sync the dm-crypt and btrfs in a released kernel.
Having a mount check sounds like a better option to me than to fail
reads, we can revert it in a release once everything woks as expected.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

