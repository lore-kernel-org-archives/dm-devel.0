Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCD5C4361A
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 09:27:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CA61E225AB
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 09:27:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA61E225AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-tF7XaeL9NSSFZphtORT56g-1; Fri, 04 Dec 2020 04:27:29 -0500
X-MC-Unique: tF7XaeL9NSSFZphtORT56g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB30580363A;
	Fri,  4 Dec 2020 09:27:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A9CE860854;
	Fri,  4 Dec 2020 09:27:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 28E2B4BB40;
	Fri,  4 Dec 2020 09:27:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3GXu3K031740 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 11:33:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 48CD92166B33; Thu,  3 Dec 2020 16:33:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 423992166B2F
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 16:33:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1ED528001B8
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 16:33:54 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-293-oTiHRaJUOf-nULCIGiPoUA-1;
	Thu, 03 Dec 2020 11:33:50 -0500
X-MC-Unique: oTiHRaJUOf-nULCIGiPoUA-1
Date: Thu, 3 Dec 2020 08:27:38 -0800
From: Keith Busch <kbusch@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20201203162738.GA3404013@dhcp-10-100-145-180.wdc.com>
References: <20201130171805.77712-1-snitzer@redhat.com>
	<20201201160709.31748-1-snitzer@redhat.com>
	<20201203032608.GD540033@T590> <20201203143359.GA29261@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20201203143359.GA29261@redhat.com>
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
X-Mailman-Approved-At: Fri, 04 Dec 2020 04:27:20 -0500
Cc: axboe@kernel.dk, martin.petersen@oracle.com, jdorminy@redhat.com,
	bjohnsto@redhat.com, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2] block: use gcd() to fix chunk_sectors
	limit stacking
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 03, 2020 at 09:33:59AM -0500, Mike Snitzer wrote:
> On Wed, Dec 02 2020 at 10:26pm -0500,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > I understand it isn't related with correctness, because the underlying
> > queue can split by its own chunk_sectors limit further. So is the issue
> > too many further-splitting on queue with chunk_sectors 8? then CPU
> > utilization is increased? Or other issue?
> 
> No, this is all about correctness.
> 
> Seems you're confining the definition of the possible stacking so that
> the top-level device isn't allowed to have its own hard requirements on
> IO sizes it sends to its internal implementation.  Just because the
> underlying device can split further doesn't mean that the top-level
> virtual driver can service larger IO sizes (not if the chunk_sectors
> stacking throws away the hint the virtual driver provided because it
> used lcm_not_zero).

I may be missing something obvious here, but if the lower layers split
to their desired boundary already, why does this limit need to stack?
Won't it also work if each layer sets their desired chunk_sectors
without considering their lower layers? The commit that initially
stacked chunk_sectors doesn't provide any explanation.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

