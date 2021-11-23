Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C768C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 19:34:21 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-0x_5dzwMMbWkQBBeEqOjMQ-1; Tue, 23 Nov 2021 14:34:16 -0500
X-MC-Unique: 0x_5dzwMMbWkQBBeEqOjMQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2250084F209;
	Tue, 23 Nov 2021 19:34:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EEB2356A95;
	Tue, 23 Nov 2021 19:34:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 472BA4A703;
	Tue, 23 Nov 2021 19:34:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANJY1eO003254 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 14:34:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 999F32180125; Tue, 23 Nov 2021 19:34:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 947BA2180122
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 19:33:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B763F85A5AA
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 19:33:58 +0000 (UTC)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
	[209.85.210.175]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-60-HwbkXS6SPiSMZv5yURWSbQ-1; Tue, 23 Nov 2021 14:33:56 -0500
X-MC-Unique: HwbkXS6SPiSMZv5yURWSbQ-1
Received: by mail-pf1-f175.google.com with SMTP id u80so255068pfc.9
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 11:33:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=Hj7PcxuLnKzRepBdxbumr3rSJH1rp9RXoQiNS6BkqqY=;
	b=fwB6CyHyq46Wc8acSY9BseVinw46QqxGacyU7DyFfQnUDmQbZhj/XHU7MYgDKN9VQJ
	oVLAWD9vYo6CIg3OqouYX82s7ws/il+PZcvroVpIhKGsgD1N6pzXPtTDa619TBzxhrNr
	3PEkF2BqSsMkYOFKp9cSfZJZmWq+o0OUKPhSzPxbVYROFU4Tezbrmps2/suy+ioKM/Ad
	PXkbXMN5hoDskqY0+FF4yEBawyP35wMiewjueO1vMLQSli0v/rDAN7igqDAYi+SdyyZz
	RqvQ2yU0RdGuVhAB9i1QZ/y56tC9rNaBV0jiFyay5Wv/HzIquOpbarzsHxe7T/+bbgco
	ILTg==
X-Gm-Message-State: AOAM532H1rry6aW31g8RvIFcceTwD0n0GgZ7qlFa5E2EWLfNL7BScVvF
	9bAw2aZyWg3tg5ki4EEe2CokS1JCsCIGuTmDJTQc8w==
X-Google-Smtp-Source: ABdhPJzfbK/HXngr7c4SVqoUjU1z90TEgx7yZs5kS94X6ib8WevHTs6s6Lbm19DO5En0QIDCaOcGr0Q9P6r3KEtQ2kY=
X-Received: by 2002:a63:85c6:: with SMTP id u189mr5465536pgd.377.1637696035778;
	Tue, 23 Nov 2021 11:33:55 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-5-hch@lst.de>
	<CAPcyv4ic=Mz_nr5biEoBikTBySJA947ZK3QQ9Mn=KhVb_HiwAA@mail.gmail.com>
	<20211123055742.GB13711@lst.de>
In-Reply-To: <20211123055742.GB13711@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 11:33:45 -0800
Message-ID: <CAPcyv4jd2eUo4bDfX=idG7js6W=L8uKKveG97r1a8DWa-pJ=mQ@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 04/29] dax: simplify the dax_device <->
	gendisk association
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 22, 2021 at 9:58 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Nov 22, 2021 at 07:33:06PM -0800, Dan Williams wrote:
> > Is it time to add a "DAX" symbol namespace?
>
> What would be the benefit?

Just the small benefit of identifying DAX core users with a common
grep line, and to indicate that DAX exports are more intertwined than
standalone exports, but yeah those are minor.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

