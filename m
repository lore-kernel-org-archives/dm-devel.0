Return-Path: <SRS0=4gQq=OD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DFDEC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 17:26:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C4C3A61056
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 17:26:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C4C3A61056
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-pg7sYbycPfai7ZTcdHL-4Q-1; Mon, 13 Sep 2021 13:26:01 -0400
X-MC-Unique: pg7sYbycPfai7ZTcdHL-4Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6292791270;
	Mon, 13 Sep 2021 17:25:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 029061972E;
	Mon, 13 Sep 2021 17:25:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4C2C61800B9E;
	Mon, 13 Sep 2021 17:25:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18DHLYvO005016 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Sep 2021 13:21:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4692F110DBAE; Mon, 13 Sep 2021 17:21:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E57E113431F
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 17:21:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6969891C7C8
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 17:21:30 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-467-rnzWmZ4pOz6-lZAXig7EfQ-1; Mon, 13 Sep 2021 13:21:26 -0400
X-MC-Unique: rnzWmZ4pOz6-lZAXig7EfQ-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2
	(Red Hat Linux)) id 1mPpe0-002eih-G4; Mon, 13 Sep 2021 17:21:24 +0000
Date: Mon, 13 Sep 2021 10:21:24 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <YT+IlJnSZzG0j0ON@bombadil.infradead.org>
References: <20210830212538.148729-1-mcgrof@kernel.org>
	<20210830212538.148729-2-mcgrof@kernel.org> <YTbAYyo0+rqUZ+L0@T590>
MIME-Version: 1.0
In-Reply-To: <YTbAYyo0+rqUZ+L0@T590>
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
Cc: ulf.hansson@linaro.org, snitzer@redhat.com, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>, agk@redhat.com,
	beanhuo@micron.com, sagi@grimberg.me, linux-scsi@vger.kernel.org,
	hch@infradead.org, jejb@linux.ibm.com, josef@toxicpanda.com,
	swboyd@chromium.org, linux-block@vger.kernel.org,
	avri.altman@wdc.com, kbusch@kernel.org, nbd@other.debian.org,
	bvanassche@acm.org, axboe@kernel.dk, martin.petersen@oracle.com,
	linux-mmc@vger.kernel.org, adrian.hunter@intel.com
Subject: Re: [dm-devel] [PATCH v3 1/8] scsi/sd: add error handling support
	for add_disk()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 07, 2021 at 09:29:07AM +0800, Ming Lei wrote:
> On Mon, Aug 30, 2021 at 02:25:31PM -0700, Luis Chamberlain wrote:
> > We never checked for errors on add_disk() as this function
> > returned void. Now that this is fixed, use the shiny new
> > error handling.
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  drivers/scsi/sd.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 610ebba0d66e..8c1273fff23e 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -3487,7 +3487,11 @@ static int sd_probe(struct device *dev)
> >  		pm_runtime_set_autosuspend_delay(dev,
> >  			sdp->host->hostt->rpm_autosuspend_delay);
> >  	}
> > -	device_add_disk(dev, gd, NULL);
> > +
> > +	error = device_add_disk(dev, gd, NULL);
> > +	if (error)
> > +		goto out_free_index;
> > +
> 
> The error handling is actually wrong, see 
> 
> 	https://lore.kernel.org/linux-scsi/c93f3010-13c9-e07f-1458-b6b47a27057b@acm.org/T/#t
> 
> Maybe you can base on that patch.

Done, thanks!

 Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

