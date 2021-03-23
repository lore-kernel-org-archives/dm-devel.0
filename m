Return-Path: <SRS0=HPtm=IV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6320FC433C1
	for <dm-devel@archiver.kernel.org>; Tue, 23 Mar 2021 11:24:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F3D75600CC
	for <dm-devel@archiver.kernel.org>; Tue, 23 Mar 2021 11:24:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3D75600CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616498640;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SxF6sL7t46LZkLUUWJIrl2cp+ZnJ6p7CQPTRk/0Ig9o=;
	b=MMIgGFfly9OIEmWCy8bdghOL1PLJY8Mky/cA3eMiNHL1Zc2AY56SHlS4ZzSngYM7SljFZ4
	VMGMyz3bwBgde4lUevrN+G4gdili5+8Q4QKSKCmyibn0F8TSaiG3uYZd76+LZSf7kqmSxl
	d1UXXUaV/nElsd+SfZ+syaAph3XQVU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-Tlx_2u3bObegqoOlP1dfKg-1; Tue, 23 Mar 2021 07:23:57 -0400
X-MC-Unique: Tlx_2u3bObegqoOlP1dfKg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96297801817;
	Tue, 23 Mar 2021 11:23:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1B991975F;
	Tue, 23 Mar 2021 11:23:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D25AF1809C83;
	Tue, 23 Mar 2021 11:23:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12NBNnKM023712 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Mar 2021 07:23:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 239E360C5F; Tue, 23 Mar 2021 11:23:49 +0000 (UTC)
Received: from T590 (ovpn-13-171.pek2.redhat.com [10.72.13.171])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED02060BE5;
	Tue, 23 Mar 2021 11:23:37 +0000 (UTC)
Date: Tue, 23 Mar 2021 19:23:32 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <YFnPtHiFnojajCUK@T590>
References: <20210318164827.1481133-1-ming.lei@redhat.com>
	<20210318164827.1481133-5-ming.lei@redhat.com>
	<20210319170509.GB9938@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210319170509.GB9938@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH V2 04/13] block: create io poll context
 for submission and poll task
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

On Fri, Mar 19, 2021 at 01:05:09PM -0400, Mike Snitzer wrote:
> On Thu, Mar 18 2021 at 12:48pm -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > Create per-task io poll context for both IO submission and poll task
> > if the queue is bio based and supports polling.
> > 
> > This io polling context includes two queues:
> 1) submission queue(sq) for storing HIPRI bio submission result(cookie)
>    and the bio, written by submission task and read by poll task.

BTW, V2 has switched to store bio only, and cookie is actually stored in
side bio.

> 2) polling queue(pq) for holding data moved from sq, only used in poll
>    context for running bio polling.
>  
> (nit, but it just reads a bit clearer to enumerate the 2 queues)

OK.

-- 
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

