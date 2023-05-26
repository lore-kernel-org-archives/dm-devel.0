Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D594C77B7A
	for <dm-devel@archiver.kernel.org>; Fri, 26 May 2023 08:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685089231;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0+o1POD3mi+csA4lg8ZqOR9DBi6dQvI9jYncaimYJ0g=;
	b=JzEB5qWduMCbN6sNW5hdbxbNwlBwiv0Dgid3jHldJcsy3GsvwP5qBEqrPupXJ8WZvGaRTf
	HLjdnOM5OGWVaUqD0ndGmsuhJeRDYq65Xcct7DDdGfP6h5VIK0G8QGZ0s3vARif6XQD3mr
	RJHu+jtJcmiBEVVEGtEuwimLxj6nJ/k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-dhNzNRP-OkCmbQLtSTgJ3w-1; Fri, 26 May 2023 04:20:25 -0400
X-MC-Unique: dhNzNRP-OkCmbQLtSTgJ3w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6088101A531;
	Fri, 26 May 2023 08:20:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CAFBD1121314;
	Fri, 26 May 2023 08:20:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A4BC819465A4;
	Fri, 26 May 2023 08:20:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1E51719465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 08:20:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F1DEBC154D2; Fri, 26 May 2023 08:20:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E9C72C154D1
 for <dm-devel@redhat.com>; Fri, 26 May 2023 08:20:20 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA9013C0F23A
 for <dm-devel@redhat.com>; Fri, 26 May 2023 08:20:20 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-n2cz29BvO6WKUP1DjhmxNQ-1; Fri, 26 May 2023 04:20:18 -0400
X-MC-Unique: n2cz29BvO6WKUP1DjhmxNQ-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red
 Hat Linux)) id 1q2SgK-001aII-1S; Fri, 26 May 2023 08:20:16 +0000
Date: Fri, 26 May 2023 01:20:16 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <ZHBrwFk0d80IiOfV@bombadil.infradead.org>
References: <20230526073336.344543-1-mcgrof@kernel.org>
 <20230526073336.344543-2-mcgrof@kernel.org>
 <ZHBqGosY0tWkNdIR@infradead.org>
MIME-Version: 1.0
In-Reply-To: <ZHBqGosY0tWkNdIR@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
 christoph.boehmwalder@linbit.com, willy@infradead.org, p.raghav@samsung.com,
 rohan.puri@samsung.com, senozhatsky@chromium.org, snitzer@kernel.org,
 da.gomez@samsung.com, kbusch@kernel.org, axboe@kernel.dk,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 rpuri.linux@gmail.com, linux-xfs@vger.kernel.org, minchan@kernel.org,
 patches@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 26, 2023 at 01:13:14AM -0700, Christoph Hellwig wrote:
> On Fri, May 26, 2023 at 12:33:32AM -0700, Luis Chamberlain wrote:
> > This ensures no other users pop up by mistake easily and provides
> > us a with an easy vehicle to do the same with other routines should
> > we need it later.
> 
> I don't see how this is related to the rest of the seris.

Jessh, sorry it is too late here and that was a typo that the commit
went into the series. I'll go sleep now. This I just had queued
as a reminder for the new annotation for deprecated symbols to be
used in some situations.

Please ignore this patch.

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

