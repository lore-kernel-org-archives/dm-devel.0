Return-Path: <SRS0=xRQ1=F3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E187FC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 23 Dec 2020 08:08:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3FE40207BC
	for <dm-devel@archiver.kernel.org>; Wed, 23 Dec 2020 08:08:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FE40207BC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-CWFlOELOMM-tL4v4qFlyFw-1; Wed, 23 Dec 2020 03:08:08 -0500
X-MC-Unique: CWFlOELOMM-tL4v4qFlyFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1316B8015D0;
	Wed, 23 Dec 2020 08:08:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ABCBB18A77;
	Wed, 23 Dec 2020 08:08:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EFB191809C9F;
	Wed, 23 Dec 2020 08:08:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BN877gX000536 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 03:07:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3636C1004036; Wed, 23 Dec 2020 08:07:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 320E5110F0D9
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 08:06:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C625D186E120
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 08:06:58 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-501-WdOCD2gyP4uNBDm2omCkYg-1;
	Wed, 23 Dec 2020 03:06:56 -0500
X-MC-Unique: WdOCD2gyP4uNBDm2omCkYg-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 407DE67373; Wed, 23 Dec 2020 09:06:54 +0100 (CET)
Date: Wed, 23 Dec 2020 09:06:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
Message-ID: <20201223080653.GB4974@lst.de>
References: <20201222095056.7a5ac0a0@canb.auug.org.au>
	<20201222131528.GA29822@lst.de> <20201222145327.GC12885@redhat.com>
	<288d1c58-c0e2-9d6f-4816-48c66536fe8b@suse.de>
	<20201222210604.GD29336@agk.fab.redhat.com>
MIME-Version: 1.0
In-Reply-To: <20201222210604.GD29336@agk.fab.redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 22, 2020 at 09:06:04PM +0000, Alasdair G Kergon wrote:
> I have not read the background about whatever the new problem is - I'm
> jumping in cold seeing this message - but from the very beginning of
> device-mapper we have strongly recommended that userspace supplies the
> block device in the form MAJOR:MINOR and all our own tools do that.  We
> guarantee not to deadlock in these places when this is done.
> 
> We also accept the device in the form of a path name as we know there
> are times when this is safe and convenient, but then we offer no
> guarantees - we place the responsibility upon userspace only to do this
> when it knows it is safe to do so i.e. no race and no deadlock.

644bda6f346038bce7ad3ed48f7044c10dde6d47 changes that by accepting all
kinds of weirdo formats :(

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

