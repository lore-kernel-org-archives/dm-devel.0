Return-Path: <SRS0=tK5J=PU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95485C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 16:19:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4AB1861101
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 16:19:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4AB1861101
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1635783572;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=D19INlK1R2Mugvy2ZErZlGw/pNENFblOosy4r3vjIlA=;
	b=SAuxzM9o8VIl0BHsszg4tS6WachnSS6YX2jd914u3xoKH9Y4KlqLgIwd2pD1f6dINJSJ88
	8311N6VzR7DtXpyo51NF6W3chbwvXCaqxaEHTIJE1iXLuoIdfi6g9+FO9HknTFOSq/wNOi
	gRKUyiqJG/rnBNPGHFxU/86UB58lbIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-HWq_O1JPMOivP0E8pt96cQ-1; Mon, 01 Nov 2021 12:19:30 -0400
X-MC-Unique: HWq_O1JPMOivP0E8pt96cQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46AC018125C1;
	Mon,  1 Nov 2021 16:19:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 20F085F4EE;
	Mon,  1 Nov 2021 16:19:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E7E1F1806D04;
	Mon,  1 Nov 2021 16:19:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A1GJN1s003352 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Nov 2021 12:19:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8F20740CFD01; Mon,  1 Nov 2021 16:19:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 89699400DEF8
	for <dm-devel@redhat.com>; Mon,  1 Nov 2021 16:19:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 702BD18A01A9
	for <dm-devel@redhat.com>; Mon,  1 Nov 2021 16:19:22 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
	[209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-150-jJgW4CRkMTOjBh0hUBPE5w-1; Mon, 01 Nov 2021 12:19:21 -0400
X-MC-Unique: jJgW4CRkMTOjBh0hUBPE5w-1
Received: by mail-qk1-f199.google.com with SMTP id
	h2-20020a05620a10a200b00462c87635cdso8917471qkk.15
	for <dm-devel@redhat.com>; Mon, 01 Nov 2021 09:19:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=C05du9bq5580dSm6IfhlDVs1xfqwhE2XhWSAZIf2yew=;
	b=UaH1Pe1tFMNcpxoJlyHEzSBSDl5iObLylgzfQQxODHH9yYWfD/9teupF9Rtj1PEQ7i
	m6OIotFHKCTLpV2ZjpYZGu0TOfkn+DF3oq2LsY9BodnPG2+XQTxYCBqzz8EBiJ3m8CsG
	ckwod/OJCTMS3ZetuKDnx/UZLLwQ7hhNI/deMQSC/a0DGPlJm2tcPJk6tGCE3tCEN05G
	UXpIQyRMpy5Ezyu6Fu8C5BHwcN7GzxFMpIq3fATNxAGMGl1iKpKFNpwMrhw3Nz6PjNFX
	CXPexP/iw8K4chrRYxw62Yw20deeamAkzr1VQOF0YTJw50iacWhq73fhOqx9oJPvlHs6
	9QJA==
X-Gm-Message-State: AOAM533aU6138yUowxd9CcupIaCG14fmSocBop5WoLL6g1adgkq+mq1Y
	EpN9WxcGo5hO7dhT86Dg3izJF1o6qXNh2U+qb4utZjHrOI7GOgnPbeFI+CpypDQHZ9eVjomop96
	p4kgJTU+Gq22Y5Q==
X-Received: by 2002:a0c:b341:: with SMTP id a1mr28270548qvf.21.1635783560973; 
	Mon, 01 Nov 2021 09:19:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvmIEea110PcdB5LDCY7U1ej3BdqkCE7DUWVGoDnBFq+m2W3EEPnU5Ptqvnzv3GNnSJbsMew==
X-Received: by 2002:a0c:b341:: with SMTP id a1mr28270537qvf.21.1635783560844; 
	Mon, 01 Nov 2021 09:19:20 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id g8sm1775746qko.27.2021.11.01.09.19.20
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 01 Nov 2021 09:19:20 -0700 (PDT)
Date: Mon, 1 Nov 2021 12:19:19 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <YYATh6yxGehyjpcm@redhat.com>
References: <20211018044054.1779424-1-hch@lst.de>
	<20211018044054.1779424-10-hch@lst.de>
	<CAPcyv4iaUPEo73+KsBdYhM72WqKqJpshL-YU_iWoujk5jNUhmA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iaUPEo73+KsBdYhM72WqKqJpshL-YU_iWoujk5jNUhmA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 09/11] dm-log-writes: add a
	log_writes_dax_pgoff helper
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

On Wed, Oct 27 2021 at  9:36P -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Add a helper to perform the entire remapping for DAX accesses.  This
> > helper open codes bdev_dax_pgoff given that the alignment checks have
> > already been done by the submitting file system and don't need to be
> > repeated.
> 
> Looks good.
> 
> Mike, ack?
> 

Acked-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

