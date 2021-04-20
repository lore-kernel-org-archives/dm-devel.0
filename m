Return-Path: <SRS0=vg7B=JR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71891C433ED
	for <dm-devel@archiver.kernel.org>; Tue, 20 Apr 2021 14:17:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D4F89613B4
	for <dm-devel@archiver.kernel.org>; Tue, 20 Apr 2021 14:17:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4F89613B4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618928272;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2jHzKqUUU+kRkQBtgJZQeZCzDses9PnVw4ePDIqI4P8=;
	b=YG9RneoOYQjigCcW+d1nCp6BGiRlYgYUEOyEEK2EjaxoABwYMroySx56650gHN3NVlnrBQ
	tdwTxI9NP5/cEHKx78uQXq3bNMp8/s/4ZfcjlR2QYUoGdtVhhg3kA7t1T+QNsp4t00JrkE
	LIF68knDeHJuHAez2RZApgzBtPTAOSE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-s_81SLztO1awxV0fkP-K1Q-1; Tue, 20 Apr 2021 10:17:49 -0400
X-MC-Unique: s_81SLztO1awxV0fkP-K1Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 257EA8030C9;
	Tue, 20 Apr 2021 14:17:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B8BE5D9C0;
	Tue, 20 Apr 2021 14:17:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6166F44A58;
	Tue, 20 Apr 2021 14:17:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13KEHZ49006039 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 20 Apr 2021 10:17:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5666560622; Tue, 20 Apr 2021 14:17:35 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 268A26061F;
	Tue, 20 Apr 2021 14:17:35 +0000 (UTC)
Date: Tue, 20 Apr 2021 10:17:34 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210420141734.GA14523@redhat.com>
References: <20210416235329.49234-1-snitzer@redhat.com>
	<20210416235329.49234-4-snitzer@redhat.com>
	<20210420093453.GB28625@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210420093453.GB28625@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, linux-nvme@lists.infradead.org
Subject: Re: [dm-devel] [PATCH v4 3/3] nvme: decouple basic ANA log page
 re-read support from native multipathing
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

On Tue, Apr 20 2021 at  5:34am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Fri, Apr 16, 2021 at 07:53:29PM -0400, Mike Snitzer wrote:
> > Whether or not ANA is present is a choice of the target implementation;
> > the host (and whether it supports multipathing) has _zero_ influence on
> > this. If the target declares a path as 'inaccessible' the path _is_
> > inaccessible to the host. As such, ANA support should be functional
> > even if native multipathing is not.

As you well know, ANA is decoupled from multipathing in the NVMe spec.
This fix illustrates that the existing Linux NVMe ANA handling is too
tightly coupled with native NVMe multipathing. Unfortunately, you've
forced this as a means to impose your political position:

> NAK.  nvme-multipathing is the only supported option for subsystems with
> multiple controllers.

And while this is largely irrelevant to the technical review of my fix:
native nvme-multipath may be the only supported option in your world. In
mine that isn't true and never has been.

Your political posturing doesn't replace technical justification. You
don't have a compelling technical case to take the stance you do, yet
you guard it like you do. Just a really stark inconsistency in your
technical leadership that is repeatedly left unchecked by others.

Alas.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

