Return-Path: <SRS0=tECb=HA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E312C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 15:40:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 012F464E02
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 15:40:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 012F464E02
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-DjZPX0RdNuKYDjNwubcOiQ-1; Fri, 29 Jan 2021 10:40:14 -0500
X-MC-Unique: DjZPX0RdNuKYDjNwubcOiQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C8C7806688;
	Fri, 29 Jan 2021 15:40:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0639C5C1B4;
	Fri, 29 Jan 2021 15:40:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1ABBD5003B;
	Fri, 29 Jan 2021 15:40:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10TFe2Su004212 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Jan 2021 10:40:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 61F4FF3D1F; Fri, 29 Jan 2021 15:40:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B7F1110EBF
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 15:39:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A33EB108C184
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 15:39:59 +0000 (UTC)
Received: from mx2.veeam.com (mx2.veeam.com [64.129.123.6]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-420-lHzmjbJCPkenxRH3-tfLdw-1;
	Fri, 29 Jan 2021 10:39:56 -0500
X-MC-Unique: lHzmjbJCPkenxRH3-tfLdw-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.veeam.com (Postfix) with ESMTPS id BA20F411C7;
	Fri, 29 Jan 2021 10:39:51 -0500 (EST)
Received: from veeam.com (172.24.14.5) by prgmbx01.amust.local (172.24.0.171)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.721.2;
	Fri, 29 Jan 2021 16:39:49 +0100
Date: Fri, 29 Jan 2021 18:39:42 +0300
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Message-ID: <20210129153942.GA32240@veeam.com>
References: <1611853955-32167-1-git-send-email-sergei.shtepa@veeam.com>
	<BL0PR04MB6514A510F37C59F52D87E2EDE7B99@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <BL0PR04MB6514A510F37C59F52D87E2EDE7B99@BL0PR04MB6514.namprd04.prod.outlook.com>
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx02.amust.local (172.24.0.172) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D265677C6B
X-Veeam-MMEX: True
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
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	Pavel Tide <Pavel.TIde@veeam.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/2] block: blk_interposer v3
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The 01/29/2021 03:18, Damien Le Moal wrote:
> On 2021/01/29 2:23, Sergei Shtepa wrote:
> > Hi all,
> > 
> > I`m ready to suggest the blk_interposer again.
> > blk_interposer allows to intercept bio requests, remap bio to
> > another devices or add new bios.
> > 
> > This version has support from device mapper.
> > 
> > For the dm-linear device creation command, the `noexcl` parameter
> > has been added, which allows to open block devices without
> > FMODE_EXCL mode. It allows to create dm-linear device on a block
> > device with an already mounted file system.
> > The new ioctl DM_DEV_REMAP allows to enable and disable bio
> > interception.
> > 
> > Thus, it is possible to add the dm-device to the block layer stack
> > without reconfiguring and rebooting.
> 
> Please add the changelog here instead of adding it in each patch. And keep the
> changelog for previous versions too (i.e. v1->v2 in this case) so that the
> changes overall can be tracked.
> 
> The proper formatting for the title should be [PATCH v3 X/Y] instead of adding
> v3 in the title itself. With git format-patch, you can use "-v 3" option to
> format this for you, or --subject-prefix="PATCH v3" option.

Thanks. I think I need to work with the style of my patches.

> 
> > 
> > 
> > Sergei Shtepa (2):
> >   block: blk_interposer
> >   [dm] blk_interposer for dm-linear
> > 
> >  block/bio.c                   |   2 +
> >  block/blk-core.c              |  29 +++
> >  block/blk-mq.c                |  13 ++
> >  block/genhd.c                 |  82 ++++++++
> >  drivers/md/dm-core.h          |  46 +++-
> >  drivers/md/dm-ioctl.c         |  39 ++++
> >  drivers/md/dm-linear.c        |  17 +-
> >  drivers/md/dm-table.c         |  12 +-
> >  drivers/md/dm.c               | 383 ++++++++++++++++++++++++++++++++--
> >  drivers/md/dm.h               |   2 +-
> >  include/linux/blk-mq.h        |   1 +
> >  include/linux/blk_types.h     |   6 +-
> >  include/linux/device-mapper.h |   7 +
> >  include/linux/genhd.h         |  19 ++
> >  include/uapi/linux/dm-ioctl.h |  15 +-
> >  15 files changed, 643 insertions(+), 30 deletions(-)
> > 
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research
> 

-- 
Sergei Shtepa
Veeam Software developer.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

