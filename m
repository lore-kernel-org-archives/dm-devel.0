Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3BF0C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 15:19:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8B0AE601FF
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 15:19:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8B0AE601FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636730394;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5ZwZ6kb9V1JWV6LONqoQ+Gskx9bq3DanWi4u7hfRk10=;
	b=NkyFa03Ciw1bUnRzukk1fV/d+DBaJsb9ne6Sa2gBXkb4/8rdoA33xmXw727A80ZSGdwUnT
	MiptIwijMT/eVXx4aSBI7MmeaoMAXXng9Fryu7o19CpUITSjvjDSv2w+OxtrWyO/Ca6FIH
	4uCRnE0+mBA8HbptpIM4mwbFJM4GTeg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-5EDRx3DwM52Rjp2LagZf7g-1; Fri, 12 Nov 2021 10:19:52 -0500
X-MC-Unique: 5EDRx3DwM52Rjp2LagZf7g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 965CA1018728;
	Fri, 12 Nov 2021 15:19:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D0225D9D3;
	Fri, 12 Nov 2021 15:19:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EF41A181A1CF;
	Fri, 12 Nov 2021 15:19:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ACFJfgC014113 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Nov 2021 10:19:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8C36351E3; Fri, 12 Nov 2021 15:19:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8713351E2
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 15:19:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95A46863721
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 15:19:38 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
	[209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-200-A7xERi3-NXqj4j3OL0RRHg-1; Fri, 12 Nov 2021 10:19:35 -0500
X-MC-Unique: A7xERi3-NXqj4j3OL0RRHg-1
Received: by mail-qv1-f71.google.com with SMTP id
	ke1-20020a056214300100b003b5a227e98dso8619912qvb.14
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 07:19:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=VFN3YfKrrN4rviirmH1lG0NY9uufAM6YHK0vPxccEaw=;
	b=T7gkAzaU8bO6KMp3lPiEOBOkWazWlqSgeVTarhs7R4+x5mjr1f6VxfPL88VHhUhtjh
	/1WGYBelmcf9e4d/cDVtB8+Dowe6C11yVBSCSmnCrxik69cY0q2ZUx9s+yoaej/E4HtU
	VzaTaIkmF3zrlOdCL9enjHS0SyoSwzwIKfZ8wzlrrq0EQvu4m+LI1+xUQR24Hqz2xFz9
	c415gB7TTRWHCms/haK2qiL6tI02XGguPo4qhXd0zSFDinyyJsPanef2ExM6RyPEIW95
	2pNIgSjdrAIxMoOyc1YSZlkytDzR3/vccm24+qB5Aarf0maw+oApatxT+7gkcMJA2g2C
	VHEg==
X-Gm-Message-State: AOAM530kwH07g4TVXIodj8PV8kw6skt62jnpHY+dd83/AFur6RQzhj5s
	MDEIkw5SuYwJskCub+VfiVqIueW6ZENIXRKNvonyyZzBzw2ZtU5f4R2FVQGGs2tw8oEZgx2+dN+
	uDV0aNKGCt6DOJQ==
X-Received: by 2002:a37:2f02:: with SMTP id v2mr13127488qkh.232.1636730375044; 
	Fri, 12 Nov 2021 07:19:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxk6sSDPzw7jrkKAxFn/K0PAx9HKUToVCIsJBG7fV34DkkAlHg0N9AMoil4JWoJAqjFdQQ15g==
X-Received: by 2002:a37:2f02:: with SMTP id v2mr13127438qkh.232.1636730374828; 
	Fri, 12 Nov 2021 07:19:34 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	az14sm2791255qkb.125.2021.11.12.07.19.34
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 12 Nov 2021 07:19:34 -0800 (PST)
Date: Fri, 12 Nov 2021 10:19:33 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <YY6GBaSypKNPZnBj@redhat.com>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
	<20211104064634.4481-9-chaitanyak@nvidia.com>
	<d770a769-7f2c-bb10-a3bd-0aca371a724e@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <d770a769-7f2c-bb10-a3bd-0aca371a724e@nvidia.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: "ebiggers@google.com" <ebiggers@google.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"song@kernel.org" <song@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>,
	"javier@javigon.com" <javier@javigon.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dongli.zhang@oracle.com" <dongli.zhang@oracle.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"osandov@fb.com" <osandov@fb.com>,
	"danil.kipnis@cloud.ionos.com" <danil.kipnis@cloud.ionos.com>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	"jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"clm@fb.com" <clm@fb.com>,
	"johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
	"jlayton@kernel.org" <jlayton@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"jefflexu@linux.alibaba.com" <jefflexu@linux.alibaba.com>,
	"jack@suse.com" <jack@suse.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [dm-devel] [RFC PATCH 8/8] md: add support for REQ_OP_VERIFY
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 11 2021 at  3:13P -0500,
Chaitanya Kulkarni <chaitanyak@nvidia.com> wrote:

> On 11/3/2021 11:46 PM, Chaitanya Kulkarni wrote:
> > From: Chaitanya Kulkarni <kch@nvidia.com>
> > 
> > Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
> 
> I want to make sure the new REQ_OP_VERIFY is compatible with the
> dm side as it is a generic interface.
> 
> Any comments on the dm side ? It will help me to respin the series for
> V1 of this proposal.

I can review, but have you tested your XFS scrub usecase ontop of
the various DM devices you modified?

Also, you seem to have missed Keith's suggestion of using io_uring to
expose this capability.  If you happen to go that route: making sure
DM has required io_uring capabilities would be needed (IIRC there
were/are some lingering patches from Ming Lei to facilitate more
efficient io_uring on DM.. I'll try to find, could be I'm wrong).

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

