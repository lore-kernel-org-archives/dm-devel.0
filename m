Return-Path: <SRS0=Z7ED=LY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF9DC11F66
	for <dm-devel@archiver.kernel.org>; Wed, 30 Jun 2021 22:12:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0E4DD61477
	for <dm-devel@archiver.kernel.org>; Wed, 30 Jun 2021 22:12:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E4DD61477
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-s7juevxFORK2E4eyGdNE2Q-1; Wed, 30 Jun 2021 18:12:43 -0400
X-MC-Unique: s7juevxFORK2E4eyGdNE2Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B6C418D6A30;
	Wed, 30 Jun 2021 22:12:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B31A78307;
	Wed, 30 Jun 2021 22:12:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E99B54EA2A;
	Wed, 30 Jun 2021 22:12:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15UM8Oex025177 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 30 Jun 2021 18:08:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 28CA3202B17B; Wed, 30 Jun 2021 22:08:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 239BD202B181
	for <dm-devel@redhat.com>; Wed, 30 Jun 2021 22:08:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FE4280D08E
	for <dm-devel@redhat.com>; Wed, 30 Jun 2021 22:08:20 +0000 (UTC)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
	[209.85.214.169]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-519-wtopnwMtO5OftZRxkDHbfA-1; Wed, 30 Jun 2021 18:08:16 -0400
X-MC-Unique: wtopnwMtO5OftZRxkDHbfA-1
Received: by mail-pl1-f169.google.com with SMTP id u19so2319917plc.3;
	Wed, 30 Jun 2021 15:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=itel9TJ+NQ61h1BnfnOgz6HA8ahL/K/rKSKzUsDI3HM=;
	b=sdK1O3+NJ8UgXgg++uDgzT0LvcvuxxB9X9LbNdArMoB+j6nk9mz3VHu7g4QywXy7md
	PZ3efrH8FYNxQkJdB8hkMTxHxYfWon/1vA+MuJ1/faooh33dFI8fIqYd6WHV8HqGcC+r
	azSZ/AqPrEpBLUj9+OIyrM/zhWTGVu+WvbGgSelYUTo2a3L89XGeYUvm1OC5GKa+9qC5
	QJFbDM/UsRi4tRrb7pcXxK+VX7hUq4ZvT2CJlB3+mmS2xUlsM1KWkPjGd95ZuerHaPyE
	xEpJ4XzdTxvr0salFdjy+UR7EV4JW9bVgXwiA4PBAOe7d/mBbmCT+TemSQqvbiVGhs2D
	yoJw==
X-Gm-Message-State: AOAM5323A6n/ALkDUmtHrk541/5GcMduSeK29U4bQGI29JkKV+ATUg7B
	+P5ni5bQ8qM9P6J/sWUplNZRp6+cbaI=
X-Google-Smtp-Source: ABdhPJzkLCHPYFnnLC8fI4RqIsJPvxZ1rPwxyDzUQpapeaJ9De1uI/RJiqNalFcrBqZceBenrDJPHA==
X-Received: by 2002:a17:90b:4c4b:: with SMTP id
	np11mr6453051pjb.125.1625090894303; 
	Wed, 30 Jun 2021 15:08:14 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:a64c:e202:83eb:cd?
	([2601:647:4000:d7:a64c:e202:83eb:cd])
	by smtp.gmail.com with ESMTPSA id
	t7sm22433442pfe.201.2021.06.30.15.08.12
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 30 Jun 2021 15:08:13 -0700 (PDT)
To: Martin Wilck <mwilck@suse.com>, Mike Snitzer <snitzer@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
References: <20210628095210.26249-1-mwilck@suse.com>
	<20210628095210.26249-2-mwilck@suse.com> <20210628095341.GA4105@lst.de>
	<4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
	<20210629125909.GB14372@lst.de>
	<2b5fd35d95668a8cba9151941c058cb8aee3e37c.camel@suse.com>
	<20210629212316.GA3367857@dhcp-10-100-145-180.wdc.com>
	<1aa1f875e7a85f9a331e88e4f8482588176bdb3a.camel@suse.com>
	<YNyVafnX09cOIZPe@redhat.com>
	<da3039c75c892f7d4031161f7c8719e50de36057.camel@suse.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <1c05c65e-64a2-0584-1888-1f544998365e@acm.org>
Date: Wed, 30 Jun 2021 15:08:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <da3039c75c892f7d4031161f7c8719e50de36057.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
	emilne@redhat.com, linux-block@vger.kernel.org,
	dm-devel@redhat.com, nkoenig@redhat.com,
	Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Alasdair G Kergon <agk@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/30/21 9:54 AM, Martin Wilck wrote:
> @Martin, @Bart, do you have a suggestion for me?

The code in block/scsi_ioctl.c exists in the block layer since until
recently most of it was used by both the IDE and SCSI code. Now that
drivers/ide is gone (thanks Christoph!), how about moving block/bsg.c
and block/scsi_ioctl.c to drivers/scsi/? As far as I can see the BSG
code is only used by SCSI drivers:

$ git grep -nH BLK_DEV_BSG | grep /Kconfig
block/Kconfig:38:config BLK_DEV_BSG
block/Kconfig:57:config BLK_DEV_BSGLIB
block/Kconfig:59:	select BLK_DEV_BSG
drivers/scsi/Kconfig:231:	select BLK_DEV_BSGLIB
drivers/scsi/Kconfig:241:	select BLK_DEV_BSGLIB
drivers/scsi/Kconfig:250:	select BLK_DEV_BSGLIB
drivers/scsi/libsas/Kconfig:13:	select BLK_DEV_BSGLIB
drivers/scsi/ufs/Kconfig:150:	select BLK_DEV_BSGLIB

The block/scsi_ioctl.c code is used more widely however:

$ git grep -nH BLK_SCSI_REQUEST | grep /Kconfig
block/Kconfig:32:config BLK_SCSI_REQUEST
block/Kconfig:41:	select BLK_SCSI_REQUEST
block/Kconfig:60:	select BLK_SCSI_REQUEST
drivers/block/Kconfig:77:	select BLK_SCSI_REQUEST
drivers/block/Kconfig:309:	select BLK_SCSI_REQUEST
drivers/block/paride/Kconfig:30:	select BLK_SCSI_REQUEST
drivers/scsi/Kconfig:22:	select BLK_SCSI_REQUEST
drivers/target/Kconfig:8:	select BLK_SCSI_REQUEST
fs/nfsd/Kconfig:112:	select BLK_SCSI_REQUEST

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

