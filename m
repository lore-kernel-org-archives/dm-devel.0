Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75CD0C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 00:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1642465881;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bcxiBz1Ou4R6o7ole1wTSfO3iI2THtLuCAmK2SBKAFo=;
	b=TQh1189q1mwIw73r76c6n9P943VpQR/YjNvVT7PYINyc8n01QEPH/QHhQ7LVgOYg/8wzQY
	Roj9YnaNu7z6wkrA4Wrifp/rVDg+t0lGlHXdUBnl8xTLFezgX+4YTo6R+lxw96T9L/8I+J
	ypxYOwH5WevUYTjnkC595S9/E/NUAyY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-f8lNH60UMzihNlm1MXht4g-1; Mon, 17 Jan 2022 19:31:17 -0500
X-MC-Unique: f8lNH60UMzihNlm1MXht4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D9D61006AA3;
	Tue, 18 Jan 2022 00:31:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 035221037F37;
	Tue, 18 Jan 2022 00:31:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E267C4BB7C;
	Tue, 18 Jan 2022 00:31:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20I0V677016889 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 Jan 2022 19:31:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2C1A71057F5C; Tue, 18 Jan 2022 00:31:06 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B37281057F5A;
	Tue, 18 Jan 2022 00:30:21 +0000 (UTC)
Date: Tue, 18 Jan 2022 08:30:16 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YeYKGPxVZFM8pneN@T590>
References: <1642183128-17875-1-git-send-email-bmarzins@redhat.com>
	<YeUf9dRHky81/bs4@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YeUf9dRHky81/bs4@infradead.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm rq: clear cloned bio ->bi_bdev to fix I/O
 accounting
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

On Sun, Jan 16, 2022 at 11:51:17PM -0800, Christoph Hellwig wrote:
> So I actually noticed this during code inspection a while ago, but I
> think we need to use the actual underlying device instead of NULL here
> to keep our block layer gurantees.  See the patch in my queue below.
> 
> ---
> From 1e330b8e57fc0d6c6fb07c0ec2915dca5d7a585a Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Thu, 13 Jan 2022 10:53:59 +0100
> Subject: block: assign bi_bdev for cloned bios in blk_rq_prep_clone
> 
> The cloned bios for the cloned request in blk_rq_prep_clone currently
> still point to the original bi_bdev.  This is harmless because dm-mpath

It breaks io accounting, so not harmless, but the code in this patch is
fine:

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

