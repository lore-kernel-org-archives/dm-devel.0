Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3B38C77B7C
	for <dm-devel@archiver.kernel.org>; Fri, 26 May 2023 08:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685091222;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5w5G4xoClGABb+IeXgmUBJ6YfMteQyLA2JOL+IQ4y10=;
	b=TZLicptmLJpD23+bRuPk5mq+oOOCjg/0iHinjSaQtwJd+X+kFu/AkpW9jvz7yBxWMcwivu
	UTW6yyVCViexvKyYsaOeBietmDJx1DxgmYHYUmivPA2GYveJ3p6MVoSXyGYrMeFxOnbgUf
	IgDjviueHokAnmHcOqDft9zG6NQCu0M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-s-p9jkGrMsqObAw8aW3WbA-1; Fri, 26 May 2023 04:53:39 -0400
X-MC-Unique: s-p9jkGrMsqObAw8aW3WbA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B3591C12F86;
	Fri, 26 May 2023 08:53:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 89BE81121314;
	Fri, 26 May 2023 08:53:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 45CA119465A4;
	Fri, 26 May 2023 08:53:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3F93319465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 08:53:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 156B940D1B66; Fri, 26 May 2023 08:53:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EDCA40D1B67
 for <dm-devel@redhat.com>; Fri, 26 May 2023 08:53:36 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E32363C0ED58
 for <dm-devel@redhat.com>; Fri, 26 May 2023 08:53:35 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-ummdIBI-OhexfboliMbtIw-1; Fri, 26 May 2023 04:53:34 -0400
X-MC-Unique: ummdIBI-OhexfboliMbtIw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat
 Linux)) id 1q2SZW-001Z7f-3C; Fri, 26 May 2023 08:13:14 +0000
Date: Fri, 26 May 2023 01:13:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Message-ID: <ZHBqGosY0tWkNdIR@infradead.org>
References: <20230526073336.344543-1-mcgrof@kernel.org>
 <20230526073336.344543-2-mcgrof@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230526073336.344543-2-mcgrof@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v2 1/5] block: annotate bdev_disk_changed()
 deprecation with a symbol namespace
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
 christoph.boehmwalder@linbit.com, willy@infradead.org, hch@infradead.org,
 p.raghav@samsung.com, rohan.puri@samsung.com, senozhatsky@chromium.org,
 snitzer@kernel.org, linux-block@vger.kernel.org, kbusch@kernel.org,
 axboe@kernel.dk, da.gomez@samsung.com, linux-kernel@vger.kernel.org,
 rpuri.linux@gmail.com, linux-xfs@vger.kernel.org, minchan@kernel.org,
 patches@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 26, 2023 at 12:33:32AM -0700, Luis Chamberlain wrote:
> This ensures no other users pop up by mistake easily and provides
> us a with an easy vehicle to do the same with other routines should
> we need it later.

I don't see how this is related to the rest of the seris.  I also don't
think it's a good idea.  The APIs isn't deprecated per se.  It just
should not be called by drivers.  The right thing would be an interface
like

EXPORT_SYMBOL_GPL_FOR(bdev_disk_changed, loop.ko, CONFIG_BLK_DEV_LOOP);
EXPORT_SYMBOL_GPL_FOR(bdev_disk_changed, dasd_mod.ko, CONFIG_DASD);

with the modulo code enforcing that no one but the module this is
explicitly exorted for can use the symbol.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

