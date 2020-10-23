Return-Path: <SRS0=KxaR=D6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A80DC388F9
	for <dm-devel@archiver.kernel.org>; Fri, 23 Oct 2020 09:31:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6B1602192A
	for <dm-devel@archiver.kernel.org>; Fri, 23 Oct 2020 09:31:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B1602192A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-5mTaUDRWPguRDhNgFx4xQg-1; Fri, 23 Oct 2020 05:31:28 -0400
X-MC-Unique: 5mTaUDRWPguRDhNgFx4xQg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D487D879532;
	Fri, 23 Oct 2020 09:31:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 498CA5B4AC;
	Fri, 23 Oct 2020 09:31:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AF64E922F6;
	Fri, 23 Oct 2020 09:31:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09N9UMXY007012 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 23 Oct 2020 05:30:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 53DD2110F2F6; Fri, 23 Oct 2020 09:30:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F542110F2F4
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 09:30:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C54D811E82
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 09:30:20 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-493-EYnCz2N2PgSquWC2DejuwA-1; Fri, 23 Oct 2020 05:30:15 -0400
X-MC-Unique: EYnCz2N2PgSquWC2DejuwA-1
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat
	Linux)) id 1kVt8s-0006xU-8j; Fri, 23 Oct 2020 09:13:46 +0000
Date: Fri, 23 Oct 2020 10:13:46 +0100
From: "hch@infradead.org" <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20201023091346.GA25115@infradead.org>
References: <1603271049-20681-1-git-send-email-sergei.shtepa@veeam.com>
	<71926887-5707-04a5-78a2-ffa2ee32bd68@suse.de>
	<20201021141044.GF20749@veeam.com>
	<ca8eaa40-b422-2272-1fd9-1d0a354c42bf@suse.de>
	<20201022094402.GA21466@veeam.com>
	<BL0PR04MB6514AC1B1FF313E6A14D122CE71D0@BL0PR04MB6514.namprd04.prod.outlook.com>
	<20201022135213.GB21466@veeam.com> <20201022151418.GR9832@magnolia>
	<CAMM=eLfO_L-ZzcGmpPpHroznnSOq_KEWignFoM09h7Am9yE83g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAMM=eLfO_L-ZzcGmpPpHroznnSOq_KEWignFoM09h7Am9yE83g@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: "jack@suse.cz" <jack@suse.cz>,
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
	Sergei Shtepa <sergei.shtepa@veeam.com>,
	"koct9i@gmail.com" <koct9i@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
	Damien Le Moal <Damien.LeMoal@wdc.com>,
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

On Thu, Oct 22, 2020 at 01:54:16PM -0400, Mike Snitzer wrote:
> On Thu, Oct 22, 2020 at 11:14 AM Darrick J. Wong
> > Stupid question: Why don't you change the block layer to make it
> > possible to insert device mapper devices after the blockdev has been set
> > up?
> 
> Not a stupid question.  Definitely something that us DM developers
> have wanted to do for a while.  Devil is in the details but it is the
> right way forward.
> 

Yes, I think that is the right thing to do.  And I don't think it should
be all that hard.  All we'd need in the I/O path is something like the
pseudo-patch below, which will allow the interposer driver to resubmit
bios using submit_bio_noacct as long as the driver sets BIO_INTERPOSED.

diff --git a/block/blk-core.c b/block/blk-core.c
index ac00d2fa4eb48d..3f6f1eb565e0a8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1051,6 +1051,9 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
+	if (blk_has_interposer(bio->bi_disk) &&
+	    !(bio->bi_flags & BIO_INTERPOSED))
+		return __submit_bio_interposed(bio);
 	if (!bio->bi_disk->fops->submit_bio)
 		return __submit_bio_noacct_mq(bio);
 	return __submit_bio_noacct(bio);

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

