Return-Path: <SRS0=xRQ1=F3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAB3C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 23 Dec 2020 08:06:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E8595207AA
	for <dm-devel@archiver.kernel.org>; Wed, 23 Dec 2020 08:06:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8595207AA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-Ny9JeMNuMJuHtpW_QVMZjg-1; Wed, 23 Dec 2020 03:06:02 -0500
X-MC-Unique: Ny9JeMNuMJuHtpW_QVMZjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D06918144E1;
	Wed, 23 Dec 2020 08:05:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 003275D9D3;
	Wed, 23 Dec 2020 08:05:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 360A04BB7B;
	Wed, 23 Dec 2020 08:05:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BN85mwE000425 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 03:05:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BD012110E982; Wed, 23 Dec 2020 08:05:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B9A25110F0DE
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 08:05:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27592811E87
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 08:05:45 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-571-2BLx_mv7MDWhhd63BmuOzg-1;
	Wed, 23 Dec 2020 03:05:40 -0500
X-MC-Unique: 2BLx_mv7MDWhhd63BmuOzg-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id CDCE467373; Wed, 23 Dec 2020 09:05:37 +0100 (CET)
Date: Wed, 23 Dec 2020 09:05:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <20201223080537.GA4974@lst.de>
References: <20201222095056.7a5ac0a0@canb.auug.org.au>
	<20201222131528.GA29822@lst.de> <20201222145327.GC12885@redhat.com>
	<288d1c58-c0e2-9d6f-4816-48c66536fe8b@suse.de>
MIME-Version: 1.0
In-Reply-To: <288d1c58-c0e2-9d6f-4816-48c66536fe8b@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>,
	Mike Snitzer <snitzer@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] DM's filesystem lookup in dm_get_dev_t() [was: Re:
 linux-next: manual merge of the device-mapper tree with Linus' tree]
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 22, 2020 at 06:24:09PM +0100, Hannes Reinecke wrote:
> Ok. The problem from my perspective is that device-mapper needs to
> a) ensure that the arbitrary string passed in with the table definition 
> refers to a valid block device
> and
> b) the block device can be opened with O_EXCL, so that device-mapper can 
> then use it.
>
> Originally (ie prior to commit 644bda6f3460) dm_get_device() just converted 
> the string to a 'dev_t' representation, and then the block device itself 
> was checked and opened in dm_get_table_device().
> 'lookup_bdev' was just being used to convert the path if the string was not 
> in the canonical major:minor format, as then it was assumed that it 
> referred to a block device node, and then lookup_bdev kinda makes sense.

Yes, 644bda6f3460 is the cause of all evil, as it uses an API in a place
where it should not be used.  It and the prep patch
(e6e20a7a5f3f49bfee518d5c6849107398d83912) which did the grave mistake
of making name_to_dev_t available outside of the early init code really
need to be reverted.

> However, lookup_bdev() now always recurses into the filesystem, causing 
> multipath to stall in an all-paths-down scenario.

lookup_bdev always did a file system lookup, and always only accepted
a valid name in the file system.

> Alternatively, if Mike says that only major:minor is the valid format for a 
> table definition we can kill that code completely. But clearly _I_ cannot 
> make the call here.

Before 644bda6f3460 the table definitions only accepted a valid name in
the file system.  Which is the proper interface.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

