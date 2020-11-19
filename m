Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92CCC2D0E4
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:25:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 175FE246B0
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:25:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 175FE246B0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-PqTWgHS9Nw6ZcztKrv_XIQ-1; Thu, 19 Nov 2020 03:25:22 -0500
X-MC-Unique: PqTWgHS9Nw6ZcztKrv_XIQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8B8B1005D44;
	Thu, 19 Nov 2020 08:25:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69B7F189A5;
	Thu, 19 Nov 2020 08:25:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A124F180954D;
	Thu, 19 Nov 2020 08:25:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJ8PEPm014112 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 03:25:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1600B2166BA2; Thu, 19 Nov 2020 08:25:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10E532166B44
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:25:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85C7F800962
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:25:10 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-14-G-NEXkzLPTaMTfaLns4RKQ-1;
	Thu, 19 Nov 2020 03:25:07 -0500
X-MC-Unique: G-NEXkzLPTaMTfaLns4RKQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 1FC9DAD2F;
	Thu, 19 Nov 2020 08:25:06 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id C74001E1303; Thu, 19 Nov 2020 09:25:05 +0100 (CET)
Date: Thu, 19 Nov 2020 09:25:05 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201119082505.GS1981@quack2.suse.cz>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-8-hch@lst.de>
	<20201118143747.GL1981@quack2.suse.cz>
	<20201119075225.GA15815@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201119075225.GA15815@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 07/20] init: refactor name_to_dev_t
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

On Thu 19-11-20 08:52:25, Christoph Hellwig wrote:
> On Wed, Nov 18, 2020 at 03:37:47PM +0100, Jan Kara wrote:
> > > -static inline dev_t blk_lookup_devt(const char *name, int partno)
> > > -{
> > > -	dev_t devt = MKDEV(0, 0);
> > > -	return devt;
> > > -}
> > >  #endif /* CONFIG_BLOCK */
> > 
> > This hunk looks unrelated to the change? Also why you move the declaration
> > outside the CONFIG_BLOCK ifdef? AFAICS blk_lookup_devt() still exists only
> > when CONFIG_BLOCK is defined? Otherwise the patch looks good to me.
> 
> blk_lookup_devt is a hack only for name_to_dev_t only referenced from
> code under CONFIG_BLOCK now, as it didn't do anything before when
> blk_lookup_devt returned 0.  I guess I'll need to update the commit log
> a little to mention this.

OK, understood. Still it would seem more logical to leave blk_lookup_devt()
declaration inside #ifdef CONFIG_BLOCK and just delete the !CONFIG_BLOCK
definition (to make it clear we ever expect only users compiled when
CONFIG_BLOCK is defined). But whatever... Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

