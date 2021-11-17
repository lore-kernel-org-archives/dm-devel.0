Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3AA5C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 17:44:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 78CC9619F6
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 17:44:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 78CC9619F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-v6fjJMB6N-GuL8NAzyCsZQ-1; Wed, 17 Nov 2021 12:44:09 -0500
X-MC-Unique: v6fjJMB6N-GuL8NAzyCsZQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A43E4804141;
	Wed, 17 Nov 2021 17:44:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68FFB101E87D;
	Wed, 17 Nov 2021 17:44:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 02FFF180BAD2;
	Wed, 17 Nov 2021 17:44:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHHi2I2002482 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 12:44:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C23C34010FDD; Wed, 17 Nov 2021 17:44:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCBF240CFD05
	for <dm-devel@redhat.com>; Wed, 17 Nov 2021 17:44:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1D68802802
	for <dm-devel@redhat.com>; Wed, 17 Nov 2021 17:44:02 +0000 (UTC)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com
	[209.85.214.177]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-419-ysAUIC-PNQ-pWrUPjSYJnw-1; Wed, 17 Nov 2021 12:44:01 -0500
X-MC-Unique: ysAUIC-PNQ-pWrUPjSYJnw-1
Received: by mail-pl1-f177.google.com with SMTP id y7so2869425plp.0
	for <dm-devel@redhat.com>; Wed, 17 Nov 2021 09:44:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=qvHf9aM+bFVV8YG4MJi5X6jszYRFNPnvYw8P8XxAMSs=;
	b=Doh8wfgy1L6Q8MgBnNNPBT9YSTyLMCMaqyiaBi9riRMg+02nZjF9PnwgNH4qi2MBSM
	lzhsWrfAeDrgcM7xW0jgoQ2QEJsS9wuRtSePOidNgPNUyux8Tkju/mFE8m9H3uAwaTeJ
	xGKgrmM5EpXRRjK6GtAFP5+/cFipRPbmPuKElidnfpgt8Ve2u84dWUVy3/bYrzMYThlC
	CpGOPz7rZOAgpG1gemkyjCDiuK/LLoSdBnkTD4FNczsN61DRlgcGq5bCM4VVBn5dmZFN
	PoTPu1vTBqgDlyU8tldPnZ5PHmoHHuvNtvqqWY164fqkh09lYc7oBK7ryKl1ZUjIsSM5
	yBwg==
X-Gm-Message-State: AOAM533ikbSosGdMbZGMZhwbzhxy8mF9vN+0B1AYxwmH+VMMJ8xKolYu
	5CMRNwn20gsG2wMbfyYdv7W3SbBWzLvkOi8DnQ5UdQ==
X-Google-Smtp-Source: ABdhPJzkkUh8z9sNK4035DW8QI/H+P4iSKXjlSdI0PBBNtw2VKYOtUcKXKOrARUi3RsvsZHwUrgnG1t18LSvWsJCfmc=
X-Received: by 2002:a17:902:6acb:b0:142:76c3:d35f with SMTP id
	i11-20020a1709026acb00b0014276c3d35fmr57313687plt.89.1637171039968;
	Wed, 17 Nov 2021 09:43:59 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-4-hch@lst.de>
In-Reply-To: <20211109083309.584081-4-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Nov 2021 09:43:46 -0800
Message-ID: <CAPcyv4hzWBZfex=C2_+nNLFKODw8+E9NSgK50COqE748cfEKTg@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 03/29] dax: remove CONFIG_DAX_DRIVER
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> CONFIG_DAX_DRIVER only selects CONFIG_DAX now, so remove it.

Applied.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

