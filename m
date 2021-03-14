Return-Path: <SRS0=muSZ=IM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E617CC433E0
	for <dm-devel@archiver.kernel.org>; Sun, 14 Mar 2021 09:31:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4F3E464EBD
	for <dm-devel@archiver.kernel.org>; Sun, 14 Mar 2021 09:31:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F3E464EBD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-TCD0831iNby4oJlWlJPQVQ-1; Sun, 14 Mar 2021 05:31:11 -0400
X-MC-Unique: TCD0831iNby4oJlWlJPQVQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8546802B7F;
	Sun, 14 Mar 2021 09:31:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DA492CD5C;
	Sun, 14 Mar 2021 09:31:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E530018006D9;
	Sun, 14 Mar 2021 09:31:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12E9V4AC023682 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 14 Mar 2021 05:31:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id ACA2D2166BA3; Sun, 14 Mar 2021 09:31:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A72172166B2F
	for <dm-devel@redhat.com>; Sun, 14 Mar 2021 09:31:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36CDF800883
	for <dm-devel@redhat.com>; Sun, 14 Mar 2021 09:31:02 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-485-8k6mUXmQMOacEVQZzFLbqA-1; Sun, 14 Mar 2021 05:30:59 -0400
X-MC-Unique: 8k6mUXmQMOacEVQZzFLbqA-1
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
	Linux)) id 1lLN54-00FqvD-M3; Sun, 14 Mar 2021 09:30:45 +0000
Date: Sun, 14 Mar 2021 09:30:38 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Sergei Shtepa <sergei.shtepa@veeam.com>
Message-ID: <20210314093038.GC3773360@infradead.org>
References: <1615563895-28565-1-git-send-email-sergei.shtepa@veeam.com>
	<1615563895-28565-4-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
In-Reply-To: <1615563895-28565-4-git-send-email-sergei.shtepa@veeam.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
	Mike Snitzer <snitzer@redhat.com>, linux-api@vger.kernel.org,
	pavel.tide@veeam.com, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v7 3/3] dm: add DM_INTERPOSED_FLAG
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 12, 2021 at 06:44:55PM +0300, Sergei Shtepa wrote:
> DM_INTERPOSED_FLAG allow to create DM targets on "the fly".
> Underlying block device opens without a flag FMODE_EXCL.
> DM target receives bio from the original device via
> bdev_interposer.

This is more of a philopical comment, but the idea of just letting the
interposed reopen the device by itself seems like a bad idea.  I think
that is probably better hidden in the block layer interposer attachment
function, which could do the extra blkdev_get_by_dev for the caller.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

