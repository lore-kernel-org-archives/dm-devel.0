Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6654CC77B76
	for <dm-devel@archiver.kernel.org>; Fri, 21 Apr 2023 22:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682114566;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cdFA43ioSmD7uQluBzCaahTojPLgdqUIYFj1sXh7WV0=;
	b=Ww9XHuiCj+g4v5trmOXQTf+Yudui0HHVp1GfB3uGTvKRpi0QjXjGcGSWgxLm9gTeik4IMa
	5CfCE7/HNOubqhSxuwlmd6pCq+oGdAvsaDHOsCZz2sgAogOZq6ej3oV+YeGszDUKoVRqAV
	DP4M72urY3K3N+OvHhG/tCY52dSR3P4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116--VbXXvjCMNGR-SGgBIfocA-1; Fri, 21 Apr 2023 18:02:44 -0400
X-MC-Unique: -VbXXvjCMNGR-SGgBIfocA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02CC7185A791;
	Fri, 21 Apr 2023 22:02:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7B7402166B33;
	Fri, 21 Apr 2023 22:02:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 165D81946A40;
	Fri, 21 Apr 2023 22:02:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6427019466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Apr 2023 22:02:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 10BB4C16026; Fri, 21 Apr 2023 22:02:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 095A8C16024
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 22:02:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E305C85A5B1
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 22:02:37 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-XZCC98mZOh-D7jV70WRenA-1; Fri, 21 Apr 2023 18:02:34 -0400
X-MC-Unique: XZCC98mZOh-D7jV70WRenA-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red
 Hat Linux)) id 1ppypq-00Bv2r-1H; Fri, 21 Apr 2023 22:02:30 +0000
Date: Fri, 21 Apr 2023 15:02:30 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Message-ID: <ZEMH9h/cd9Cp1t+X@bombadil.infradead.org>
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-4-mcgrof@kernel.org>
 <ZELuiBNNHTk4EdxH@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <ZELuiBNNHTk4EdxH@casper.infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 3/5] iomap: simplify iomap_init() with
 PAGE_SECTORS
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: djwong@kernel.org, philipp.reisner@linbit.com, linux-mm@kvack.org,
 dm-devel@redhat.com, agk@redhat.com, drbd-dev@lists.linbit.com,
 christoph.boehmwalder@linbit.com, hch@infradead.org, p.raghav@samsung.com,
 senozhatsky@chromium.org, snitzer@kernel.org, linux-block@vger.kernel.org,
 kbusch@kernel.org, axboe@kernel.dk, da.gomez@samsung.com,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, minchan@kernel.org,
 patches@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Apr 21, 2023 at 09:14:00PM +0100, Matthew Wilcox wrote:
> On Fri, Apr 21, 2023 at 12:58:05PM -0700, Luis Chamberlain wrote:
> > Just use the PAGE_SECTORS generic define. This produces no functional
> > changes. While at it use left shift to simplify this even further.
> 
> How is FOO << 2 simpler than FOO * 4?
> 
> > -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
> > +	return bioset_init(&iomap_ioend_bioset, PAGE_SECTORS << 2,

We could just do:


-	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
+	return bioset_init(&iomap_ioend_bioset, 4 * PAGE_SECTORS,

The shift just seemed optimal if we're just going to change it.

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

