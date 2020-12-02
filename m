Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721E5C64E7B
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 15:19:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CC00520B1F
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 15:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC00520B1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1606922356;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3AehZtbeNOLAGrLURpBeJS3Dqfr5rrlaJZ3kfGIWakA=;
	b=ccCNDUQofJQZVZSVAXW1cWhPn5Pa4sFzKTSyTSbDTGHm8qze27UuUiprn+WK52dYN1sMcp
	z0S5b+lpO1mzH3dxopJMVstLk31vwR2SfXxmcumdwIRH36Di5LTiWmdRfyVWr7RSMF+Cpp
	QXro/C8RckvFCcVm3s5e3MUBghJPau8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-9G0mADGpN--HECzNdX7WhQ-1; Wed, 02 Dec 2020 10:19:14 -0500
X-MC-Unique: 9G0mADGpN--HECzNdX7WhQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98EB11084430;
	Wed,  2 Dec 2020 15:19:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46FCE5D6AC;
	Wed,  2 Dec 2020 15:19:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 06D0A180954D;
	Wed,  2 Dec 2020 15:19:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B2FJ6Em026830 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 10:19:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CCA42189B6; Wed,  2 Dec 2020 15:19:06 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A508560636;
	Wed,  2 Dec 2020 15:19:03 +0000 (UTC)
Date: Wed, 2 Dec 2020 10:19:02 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <20201202151902.GE20535@redhat.com>
References: <20201130113339.42817-1-jefflexu@linux.alibaba.com>
	<38922bfe-4d52-af4d-f6f0-9d452b257ba1@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <38922bfe-4d52-af4d-f6f0-9d452b257ba1@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com
Subject: Re: [dm-devel] dm crypt: export sysfs of kcryptd workqueue
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 01 2020 at 11:04pm -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

> Hi Mike,
> 
> What about this patch?
> 
> On 11/30/20 7:33 PM, Jeffle Xu wrote:
> > It should be helpful to export sysfs of "kcryptd" workqueue in some
> > cases, such as setting specific CPU affinity of the workqueue.
> > 
> > Besides, also tweak the name format a little. The slash inside a
> > directory name will be translate into exclamation mark, such as
> > /sys/devices/virtual/workqueue/'kcryptd!253:0'.
> > 
> > Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> > ---
> >  drivers/md/dm-crypt.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > index 392337f16ecf..6b4c1f674239 100644
> > --- a/drivers/md/dm-crypt.c
> > +++ b/drivers/md/dm-crypt.c
> > @@ -3166,11 +3166,12 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> >  	}
> >  
> >  	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
> > -		cc->crypt_queue = alloc_workqueue("kcryptd/%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
> > +		cc->crypt_queue = alloc_workqueue("kcryptd-%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
> >  						  1, devname);
> >  	else
> > -		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
> > -						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
> > +		cc->crypt_queue = alloc_workqueue("kcryptd-%s",
> > +						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM |
> > +						  WQ_UNBOUND | WQ_SYSFS,
> >  						  num_online_cpus(), devname);
> >  	if (!cc->crypt_queue) {
> >  		ti->error = "Couldn't create kcryptd queue";
> > 

Looks fine, I'll get it staged for 5.11.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

