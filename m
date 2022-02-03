Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4E6FC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  3 Feb 2022 19:55:41 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-nKgEgtgeMyav6L0-ruvLsQ-1; Thu, 03 Feb 2022 14:55:39 -0500
X-MC-Unique: nKgEgtgeMyav6L0-ruvLsQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C329851A18;
	Thu,  3 Feb 2022 19:55:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A19A9D4BE6;
	Thu,  3 Feb 2022 19:55:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E1CDB1809CB8;
	Thu,  3 Feb 2022 19:55:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 213JtRPu009722 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Feb 2022 14:55:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1D8A5492CA8; Thu,  3 Feb 2022 19:55:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 19C3A492D54
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 19:55:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F36CB3C01C25
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 19:55:26 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-349-eLNgnjCcM4SFmNCAwRBfvQ-1; Thu, 03 Feb 2022 14:55:24 -0500
X-MC-Unique: eLNgnjCcM4SFmNCAwRBfvQ-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2
	(Red Hat Linux)) id 1nFhsB-002b1R-NQ; Thu, 03 Feb 2022 19:34:27 +0000
Date: Thu, 3 Feb 2022 11:34:27 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Message-ID: <YfwuQxS79wl8l/a0@bombadil.infradead.org>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<CGME20220201183359uscas1p2d7e48dc4cafed3df60c304a06f2323cd@uscas1p2.samsung.com>
	<alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<20220202060154.GA120951@bgt-140510-bm01>
	<20220203160633.rdwovqoxlbr3nu5u@garbanzo>
	<20220203161534.GA15366@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220203161534.GA15366@lst.de>
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
Cc: Vincent Fu <vincent.fu@samsung.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"kbus @imap.gmail.com>> Keith Busch" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [RFC PATCH 3/3] nvme: add the "debug" host driver
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 03, 2022 at 05:15:34PM +0100, Christoph Hellwig wrote:
> On Thu, Feb 03, 2022 at 08:06:33AM -0800, Luis Chamberlain wrote:
> > On Wed, Feb 02, 2022 at 06:01:13AM +0000, Adam Manzanares wrote:
> > > BTW I think having the target code be able to implement simple copy without 
> > > moving data over the fabric would be a great way of showing off the command.
> > 
> > Do you mean this should be implemented instead as a fabrics backend
> > instead because fabrics already instantiates and creates a virtual
> > nvme device? And so this would mean less code?
> 
> It would be a lot less code.  In fact I don't think we need any new code
> at all.  Just using nvme-loop on top of null_blk or brd should be all
> that is needed.

Mikulas,

That begs the question why add this instead of using null_blk with
nvme-loop?

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

