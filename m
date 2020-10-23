Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060A2C2D0A3
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:22:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 33DCF20735
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:22:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33DCF20735
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50--b5dQZhvOoqY6G05bHQ_Tw-1; Mon, 26 Oct 2020 03:22:24 -0400
X-MC-Unique: -b5dQZhvOoqY6G05bHQ_Tw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C3E01074660;
	Mon, 26 Oct 2020 07:22:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F7165B4AE;
	Mon, 26 Oct 2020 07:22:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 450F51832FC4;
	Mon, 26 Oct 2020 07:22:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09NBDQZ7017904 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 23 Oct 2020 07:13:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A464E1003202; Fri, 23 Oct 2020 11:13:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FCDF1004041
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 11:13:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73EBD800161
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 11:13:24 +0000 (UTC)
Received: from mx4.veeam.com (mx4.veeam.com [104.41.138.86]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-349-1abs8aX3MouHAi7Wi99NCg-1;
	Fri, 23 Oct 2020 07:13:20 -0400
X-MC-Unique: 1abs8aX3MouHAi7Wi99NCg-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx4.veeam.com (Postfix) with ESMTPS id 6D9A8887F2;
	Fri, 23 Oct 2020 14:03:22 +0300 (MSK)
Received: from veeam.com (172.24.14.5) by prgmbx01.amust.local (172.24.0.171)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.721.2;
	Fri, 23 Oct 2020 13:03:20 +0200
Date: Fri, 23 Oct 2020 14:04:07 +0300
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <20201023110407.GA23020@veeam.com>
References: <71926887-5707-04a5-78a2-ffa2ee32bd68@suse.de>
	<20201021141044.GF20749@veeam.com>
	<ca8eaa40-b422-2272-1fd9-1d0a354c42bf@suse.de>
	<20201022094402.GA21466@veeam.com>
	<BL0PR04MB6514AC1B1FF313E6A14D122CE71D0@BL0PR04MB6514.namprd04.prod.outlook.com>
	<20201022135213.GB21466@veeam.com> <20201022151418.GR9832@magnolia>
	<CAMM=eLfO_L-ZzcGmpPpHroznnSOq_KEWignFoM09h7Am9yE83g@mail.gmail.com>
	<20201023091346.GA25115@infradead.org>
	<d50062cd-929d-c8ff-5851-4e1d517dc4cb@suse.de>
MIME-Version: 1.0
In-Reply-To: <d50062cd-929d-c8ff-5851-4e1d517dc4cb@suse.de>
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx02.amust.local (172.24.0.172) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D26A677764
X-Veeam-MMEX: True
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
X-Mailman-Approved-At: Mon, 26 Oct 2020 03:19:18 -0400
Cc: "jack@suse.cz" <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	"gustavo@embeddedor.com" <gustavo@embeddedor.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	"pavel@ucw.cz" <pavel@ucw.cz>, "steve@sk2.org" <steve@sk2.org>,
	"osandov@fb.com" <osandov@fb.com>, Alasdair G Kergon <agk@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"hch@infradead.org" <hch@infradead.org>,
	"len.brown@intel.com" <len.brown@intel.com>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"koct9i@gmail.com" <koct9i@gmail.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, Damien Le
	Moal <Damien.LeMoal@wdc.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"rjw@rjwysocki.net" <rjw@rjwysocki.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"tj@kernel.org" <tj@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [dm-devel] [PATCH 0/2] block layer filter and block device
	snapshot module
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The 10/23/2020 13:31, Hannes Reinecke wrote:
> On 10/23/20 11:13 AM, hch@infradead.org wrote:
> > On Thu, Oct 22, 2020 at 01:54:16PM -0400, Mike Snitzer wrote:
> >> On Thu, Oct 22, 2020 at 11:14 AM Darrick J. Wong
> >>> Stupid question: Why don't you change the block layer to make it
> >>> possible to insert device mapper devices after the blockdev has been set
> >>> up?
> >>
> >> Not a stupid question.  Definitely something that us DM developers
> >> have wanted to do for a while.  Devil is in the details but it is the
> >> right way forward.
> >>
> > 
> > Yes, I think that is the right thing to do.  And I don't think it should
> > be all that hard.  All we'd need in the I/O path is something like the
> > pseudo-patch below, which will allow the interposer driver to resubmit
> > bios using submit_bio_noacct as long as the driver sets BIO_INTERPOSED.
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index ac00d2fa4eb48d..3f6f1eb565e0a8 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -1051,6 +1051,9 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
> >   		return BLK_QC_T_NONE;
> >   	}
> >   
> > +	if (blk_has_interposer(bio->bi_disk) &&
> > +	    !(bio->bi_flags & BIO_INTERPOSED))
> > +		return __submit_bio_interposed(bio);
> >   	if (!bio->bi_disk->fops->submit_bio)
> >   		return __submit_bio_noacct_mq(bio);
> >   	return __submit_bio_noacct(bio);
> > 

It`s will be great! Approximately this interception capability is not
enough now.

> My thoughts went more into the direction of hooking into ->submit_bio, 
> seeing that it's a NULL pointer for most (all?) block drivers.
> 
> But sure, I'll check how the interposer approach would turn out.

If anyone will do the patch blk-interposer, please add me to CC.
I will try to offer my module that will use blk-interposer.

-- 
Sergei Shtepa
Veeam Software developer.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

