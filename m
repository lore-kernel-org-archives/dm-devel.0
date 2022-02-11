Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C43C6C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 07:13:29 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-iU45EPzfO52MtVj8-keCXg-1; Fri, 11 Feb 2022 02:13:25 -0500
X-MC-Unique: iU45EPzfO52MtVj8-keCXg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79929801B0B;
	Fri, 11 Feb 2022 07:13:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EFD51038ADE;
	Fri, 11 Feb 2022 07:13:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 370D7180B617;
	Fri, 11 Feb 2022 07:13:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21B780mN017588 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 02:08:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F1F31141DC5D; Fri, 11 Feb 2022 07:07:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE034140EBFE
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 07:07:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D411C100E651
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 07:07:59 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-564-w0cOVZURMwKlWfUtf_65CQ-1; Fri, 11 Feb 2022 02:07:56 -0500
X-MC-Unique: w0cOVZURMwKlWfUtf_65CQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1nIQ26-0063nd-Pf; Fri, 11 Feb 2022 07:07:54 +0000
Date: Thu, 10 Feb 2022 23:07:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <YgYLShZC1qboLQN4@infradead.org>
References: <20220210223832.99412-1-snitzer@redhat.com>
	<20220210223832.99412-15-snitzer@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220210223832.99412-15-snitzer@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 14/14] block: add bio_start_io_acct_remapped
 for the benefit of DM
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

On Thu, Feb 10, 2022 at 05:38:32PM -0500, Mike Snitzer wrote:
> DM needs the ability to account a clone bio's IO to the original
> block_device. So add @orig_bdev argument to bio_start_io_acct_time.
> Rename bio_start_io_acct_time to bio_start_io_acct_remapped.
> Also, follow bio_end_io_acct and bio_end_io_acct_remapped pattern by
> moving bio_start_io_acct to blkdev.h and have it call
> bio_start_io_acct_remapped.
> 
> Improve DM to no longer need to play games with swizzling a clone
> bio's bi_bdev (in dm_submit_bio_remap) and remove DM's
> clone_and_start_io_acct() interface.

Please split the core block layer part of this out, reorder it before
the current patch 10 and then do the right thing in that patch from the
start.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

