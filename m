Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 534C3C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 17 Feb 2022 17:51:18 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-oe2TumZlPrmk87mpFNFK5w-1; Thu, 17 Feb 2022 12:51:15 -0500
X-MC-Unique: oe2TumZlPrmk87mpFNFK5w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF6F519253C4;
	Thu, 17 Feb 2022 17:51:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD471798A8;
	Thu, 17 Feb 2022 17:51:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5731F1806D1C;
	Thu, 17 Feb 2022 17:51:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21HHntuW027223 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Feb 2022 12:49:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2E0F440BB42; Thu, 17 Feb 2022 17:49:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A0C74022F6
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 17:49:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11D063C00086
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 17:49:55 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-272-6pTYMPrpNzq0lZJBczuaNQ-1; Thu, 17 Feb 2022 12:49:53 -0500
X-MC-Unique: 6pTYMPrpNzq0lZJBczuaNQ-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2
	(Red Hat Linux)) id 1nKkua-00BdTP-0U; Thu, 17 Feb 2022 17:49:48 +0000
Date: Thu, 17 Feb 2022 09:49:47 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <Yg6Ku8XqnTjvNCrC@bombadil.infradead.org>
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080605epcas5p16868dae515a6355cf9fecf22df4f3c3d@epcas5p1.samsung.com>
	<20220214080002.18381-3-nj.shetty@samsung.com>
	<20220217090700.b7n33vbkx5s4qbfq@garbanzo>
	<f0f9317f-839e-2be2-dec6-c5b94d7022b7@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <f0f9317f-839e-2be2-dec6-c5b94d7022b7@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>, Alasdair Kergon <agk@redhat.com>,
	"javier@javigon.com" <javier@javigon.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"nitheshshetty@gmail.com" <nitheshshetty@gmail.com>,
	James Smart <james.smart@broadcom.com>,
	"hch@lst.de" <hch@lst.de>, Nitesh Shetty <nj.shetty@samsung.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Sagi Grimberg <sagi@grimberg.me>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"arnav.dawn@samsung.com" <arnav.dawn@samsung.com>,
	"jack@suse.com" <jack@suse.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [dm-devel] [PATCH v3 02/10] block: Introduce queue limits for
 copy-offload support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 17, 2022 at 10:16:21AM +0000, Chaitanya Kulkarni wrote:
> On 2/17/22 1:07 AM, Luis Chamberlain wrote:
> >> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> >> index efed3820cbf7..792e6d556589 100644
> >> --- a/include/linux/blkdev.h
> >> +++ b/include/linux/blkdev.h
> >> @@ -254,6 +254,13 @@ struct queue_limits {
> >>   	unsigned int		discard_alignment;
> >>   	unsigned int		zone_write_granularity;
> >>   
> >> +	unsigned long		max_hw_copy_sectors;
> >> +	unsigned long		max_copy_sectors;
> >> +	unsigned int		max_hw_copy_range_sectors;
> >> +	unsigned int		max_copy_range_sectors;
> >> +	unsigned short		max_hw_copy_nr_ranges;
> >> +	unsigned short		max_copy_nr_ranges;
> > 
> > Before limits start growing more.. I wonder if we should just
> > stuff hw offload stuff to its own struct within queue_limits.
> > 
> > Christoph?
> > 
> 
> Potentially use a pointer to structure and maybe make it configurable,

Did you mean to make queue limits local or for hw offload and make that
a pointer? If so that seems odd because even for hw copy offload we
still need the other limits no?

So what I meant was that struct queue_limits seems to be getting large,
and that hw copy offload seems like an example use case where we should
probably use a separate struct for it. And while at it, well, start
adding kdocs for these things, because, there's tons of things which
could use kdoc love.

> although I'm not sure about the later part, I'll let Christoph decide
> that.

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

