Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE82C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 18:10:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 33FAD61207
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 18:10:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 33FAD61207
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-6nbUv6eUM42fGS1pbdBXgA-1; Thu, 04 Nov 2021 14:10:39 -0400
X-MC-Unique: 6nbUv6eUM42fGS1pbdBXgA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D092910A8E05;
	Thu,  4 Nov 2021 18:10:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B4102A6C50;
	Thu,  4 Nov 2021 18:10:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 83F5F4A704;
	Thu,  4 Nov 2021 18:10:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4IAXue009857 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 14:10:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F37FD400F3C6; Thu,  4 Nov 2021 18:10:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF509401A993
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 18:10:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF97A1064E6E
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 18:10:32 +0000 (UTC)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
	[209.85.214.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-433-qzyyOctPMuG5QexIi4drfQ-1; Thu, 04 Nov 2021 14:10:31 -0400
X-MC-Unique: qzyyOctPMuG5QexIi4drfQ-1
Received: by mail-pl1-f175.google.com with SMTP id u11so8615027plf.3
	for <dm-devel@redhat.com>; Thu, 04 Nov 2021 11:10:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=7mdrEIaynFJhMAYVbY2RCFSQ3xBs/5manpadoyeA8Jg=;
	b=CzyS7ZS/AW801d/v7ktWHyC81D9oSEd7FksXbdF5TB2O2siTwXK/bo4w1bD8mF7yaY
	IoXqkkoNHgtxNeAINC7L0IPeSC4329cjtNcYH4yl9swadjO0kNbnh4++EC7RBuNkSW2Q
	LHQ3XeQz2oBq8/hi3SunpAF6N5oJDxSaFOFM29fDKPX5zvNWGTh74B4Pk98cZiQI6mJN
	s6vL9a0Dzf/XjZACouHRCNwj4JkQsEaa5l9Ljo8ggoi5eiqDEZo1NHRVNCfRxyQZpFZE
	0sfNFz5/2NLiTCtTbJ44X4OhsgYTLlWqQe2aOmWz5aE33Ow/ZEanhbcO6Oc20JfSmS2R
	PCDw==
X-Gm-Message-State: AOAM530UQIWYkZUD8e/ILBWOMlfbhJlw6dmif1Q6WG4Dh0PJYMl4ZYhE
	5Ce+3PvVQmZRb8/35PJMr8VLeM1TED69rHi5NfzTyg==
X-Google-Smtp-Source: ABdhPJxpE7179nYWnBAffbsem/btoh3olrocKEPy5McMuIBWtGLmZ02iwXqFLVvSNceMnE3VXVk1wLsDAvNCq2GAmrQ=
X-Received: by 2002:a17:902:b697:b0:141:c7aa:e10f with SMTP id
	c23-20020a170902b69700b00141c7aae10fmr33445935pls.18.1636049430346;
	Thu, 04 Nov 2021 11:10:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de>
	<21ff4333-e567-2819-3ae0-6a2e83ec7ce6@sandeen.net>
	<20211104081740.GA23111@lst.de> <20211104173417.GJ2237511@magnolia>
	<20211104173559.GB31740@lst.de>
In-Reply-To: <20211104173559.GB31740@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 11:10:19 -0700
Message-ID: <CAPcyv4jbjc+XtX5RX5OL3vPadsYZwoK1NG1qC5AcpySBu5tL4g@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-erofs@lists.ozlabs.org,
	Mike Snitzer <snitzer@redhat.com>, linux-s390 <linux-s390@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Eric Sandeen <sandeen@sandeen.net>,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] futher decouple DAX from block devices
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 4, 2021 at 10:36 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Nov 04, 2021 at 10:34:17AM -0700, Darrick J. Wong wrote:
> > /me wonders, are block devices going away?  Will mkfs.xfs have to learn
> > how to talk to certain chardevs?  I guess jffs2 and others already do
> > that kind of thing... but I suppose I can wait for the real draft to
> > show up to ramble further. ;)
>
> Right now I've mostly been looking into the kernel side.  An no, I
> do not expect /dev/pmem* to go away as you'll still need it for a
> not DAX aware file system and/or application (such as mkfs initially).
>
> But yes, just pointing mkfs to the chardev should be doable with very
> little work.  We can point it to a regular file after all.

Note that I've avoided implementing read/write fops for dax devices
partly out of concern for not wanting to figure out shared-mmap vs
write coherence issues, but also because of a bet with Dave Hansen
that device-dax not grow features like what happened to hugetlbfs. So
it would seem mkfs would need to switch to mmap I/O, or bite the
bullet and implement read/write fops in the driver.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

