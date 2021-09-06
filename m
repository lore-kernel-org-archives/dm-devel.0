Return-Path: <SRS0=WplP=N4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53351C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  6 Sep 2021 08:09:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E53A96103B
	for <dm-devel@archiver.kernel.org>; Mon,  6 Sep 2021 08:09:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E53A96103B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-1QTsGpl-OGelP6r_rjMMgA-1; Mon, 06 Sep 2021 04:09:31 -0400
X-MC-Unique: 1QTsGpl-OGelP6r_rjMMgA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5ACBB188E3C2;
	Mon,  6 Sep 2021 08:09:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6239101F6D5;
	Mon,  6 Sep 2021 08:09:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 55DDE44A5A;
	Mon,  6 Sep 2021 08:09:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18689LIY004285 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 6 Sep 2021 04:09:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 844BB202812A; Mon,  6 Sep 2021 08:09:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F5A82028128
	for <dm-devel@redhat.com>; Mon,  6 Sep 2021 08:09:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC705101A5B3
	for <dm-devel@redhat.com>; Mon,  6 Sep 2021 08:09:17 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-555-ya4S4wbnNGC0hZ5-Y7pX6w-1;
	Mon, 06 Sep 2021 04:09:14 -0400
X-MC-Unique: ya4S4wbnNGC0hZ5-Y7pX6w-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id E18B767373; Mon,  6 Sep 2021 10:09:08 +0200 (CEST)
Date: Mon, 6 Sep 2021 10:09:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <20210906080908.GA25575@lst.de>
References: <20210830212538.148729-1-mcgrof@kernel.org>
	<20210830212538.148729-4-mcgrof@kernel.org>
	<677ca876-b003-d3b5-9e2e-d50ebef82cce@suse.de>
MIME-Version: 1.0
In-Reply-To: <677ca876-b003-d3b5-9e2e-d50ebef82cce@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: ulf.hansson@linaro.org, snitzer@redhat.com, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>, agk@redhat.com,
	beanhuo@micron.com, ming.lei@redhat.com, sagi@grimberg.me,
	linux-scsi@vger.kernel.org, hch@infradead.org,
	jejb@linux.ibm.com, josef@toxicpanda.com, nbd@other.debian.org,
	linux-block@vger.kernel.org, avri.altman@wdc.com,
	kbusch@kernel.org, swboyd@chromium.org, bvanassche@acm.org,
	axboe@kernel.dk, martin.petersen@oracle.com,
	linux-mmc@vger.kernel.org, adrian.hunter@intel.com,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [dm-devel] [PATCH v3 3/8] nvme: add error handling support for
	add_disk()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 06, 2021 at 08:16:35AM +0200, Hannes Reinecke wrote:
> I would rather turn this around, and call 'nvme_put_ctrl()' after removing 
> the namespace from the list. But it's probably more a style issue, come to 
> think of it.

The order in the patch is the inverse of the order before the failure,
which generally is the right thing to do.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

