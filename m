Return-Path: <SRS0=mcEr=MU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9350DC4338F
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jul 2021 06:54:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B01A060EBB
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jul 2021 06:54:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B01A060EBB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-lcfespMZNuK-ui7P3JVaUA-1; Wed, 28 Jul 2021 02:54:25 -0400
X-MC-Unique: lcfespMZNuK-ui7P3JVaUA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EE24801AE7;
	Wed, 28 Jul 2021 06:54:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C809A1007606;
	Wed, 28 Jul 2021 06:54:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ED0024BB7C;
	Wed, 28 Jul 2021 06:54:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16S6sDr7003550 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Jul 2021 02:54:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CDF632167807; Wed, 28 Jul 2021 06:54:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C95FF21677FB
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 06:54:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CDEE858286
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 06:54:10 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-564-LcdFC1l9NNuO-ktAU207IQ-1;
	Wed, 28 Jul 2021 02:54:06 -0400
X-MC-Unique: LcdFC1l9NNuO-ktAU207IQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 683BD67357; Wed, 28 Jul 2021 08:54:03 +0200 (CEST)
Date: Wed, 28 Jul 2021 08:54:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20210728065403.GA4815@lst.de>
References: <20210725055458.29008-1-hch@lst.de>
	<20210725055458.29008-5-hch@lst.de> <YQAu7KKyKnCm+tlf@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YQAu7KKyKnCm+tlf@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 4/8] block: support delayed holder
	registration
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

On Tue, Jul 27, 2021 at 12:06:04PM -0400, Mike Snitzer wrote:
> This header starts to shine some light on what is motivating this
> series by touching on "all kinds of bad side effects" being fixed.
> Any chance you could elaborate what you've noticed/found/hit?

The proble mis that it leaves the queue in a weird half state.  The
normal states for a gendisk are:

 1) allocated		(after *alloc_disk)
 2) registered		(after add_disk*)
 3) unregistered	(after del_gendisk)

the delayed queue registration adds a weird half state where it is
sort of registered, except for in sysfs and the elevator.  I have
some pretty big changes between how the disk and queue interact
that tripped over it, but even right now code has to be very careful
in the takedown path to deal with the half-initialized disks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

