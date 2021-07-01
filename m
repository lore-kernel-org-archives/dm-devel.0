Return-Path: <SRS0=hnI9=LZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AC7C11F64
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jul 2021 06:19:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3F5AE61492
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jul 2021 06:19:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F5AE61492
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-GziZiO6aMaiztxDw3Xc0Zg-1; Thu, 01 Jul 2021 02:19:24 -0400
X-MC-Unique: GziZiO6aMaiztxDw3Xc0Zg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9154879EE0;
	Thu,  1 Jul 2021 06:19:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FB6F10027A5;
	Thu,  1 Jul 2021 06:19:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 029C34A712;
	Thu,  1 Jul 2021 06:19:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1616JB6h027711 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 1 Jul 2021 02:19:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A7F2FFED4F; Thu,  1 Jul 2021 06:19:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A37E2FED46
	for <dm-devel@redhat.com>; Thu,  1 Jul 2021 06:19:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D9938556F0
	for <dm-devel@redhat.com>; Thu,  1 Jul 2021 06:19:08 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-402-iboRmDGgMR25DsDscr3Ncg-1;
	Thu, 01 Jul 2021 02:19:05 -0400
X-MC-Unique: iboRmDGgMR25DsDscr3Ncg-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2869367373; Thu,  1 Jul 2021 08:19:02 +0200 (CEST)
Date: Thu, 1 Jul 2021 08:19:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Message-ID: <20210701061901.GA22293@lst.de>
References: <20210628095210.26249-2-mwilck@suse.com>
	<20210628095341.GA4105@lst.de>
	<4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
	<20210629125909.GB14372@lst.de>
	<2b5fd35d95668a8cba9151941c058cb8aee3e37c.camel@suse.com>
	<20210629212316.GA3367857@dhcp-10-100-145-180.wdc.com>
	<1aa1f875e7a85f9a331e88e4f8482588176bdb3a.camel@suse.com>
	<YNyVafnX09cOIZPe@redhat.com>
	<da3039c75c892f7d4031161f7c8719e50de36057.camel@suse.com>
	<1c05c65e-64a2-0584-1888-1f544998365e@acm.org>
MIME-Version: 1.0
In-Reply-To: <1c05c65e-64a2-0584-1888-1f544998365e@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
	emilne@redhat.com, Martin Wilck <mwilck@suse.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	nkoenig@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 1/3] scsi: scsi_ioctl: export
 __scsi_result_to_blk_status()
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

On Wed, Jun 30, 2021 at 03:08:11PM -0700, Bart Van Assche wrote:
> On 6/30/21 9:54 AM, Martin Wilck wrote:
> > @Martin, @Bart, do you have a suggestion for me?
> 
> The code in block/scsi_ioctl.c exists in the block layer since until
> recently most of it was used by both the IDE and SCSI code. Now that
> drivers/ide is gone (thanks Christoph!), how about moving block/bsg.c
> and block/scsi_ioctl.c to drivers/scsi/? As far as I can see the BSG
> code is only used by SCSI drivers:

I have a series to clean this mess up:

http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/scsi-ioctl

But more importantly, dm has no business interpreting the errors.  Just
like how SG_IO processing generally does not look at the error and
just returns it to userspace and leaves error handling to the caller
so should be the decision to resubmit it in a multi-path setup.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

